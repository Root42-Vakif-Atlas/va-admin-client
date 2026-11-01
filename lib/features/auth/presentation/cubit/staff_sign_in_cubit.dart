import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas_admin/core/error/failures.dart';
import 'package:vakif_atlas_admin/features/auth/domain/entities/sign_in.dart';
import 'package:vakif_atlas_admin/features/auth/domain/entities/staff_user.dart';
import 'package:vakif_atlas_admin/features/auth/domain/repositories/auth_repository.dart';

part 'staff_sign_in_cubit.freezed.dart';

enum SignInStep { credentials, verify, enroll, recoveryCodes }

/// Personel girişinin adımları: şifre → (Authenticator kodu | kurtarma kodu)
/// veya ilk girişte Authenticator kurulumu → kurtarma kodları. Bilet ve sır
/// yalnızca bu durumda (bellekte) tutulur; `toString` ikisini de yazmaz.
@freezed
abstract class StaffSignInState with _$StaffSignInState {
  const factory StaffSignInState({
    @Default(SignInStep.credentials) SignInStep step,
    @Default(false) bool submitting,
    @Default(false) bool useRecoveryCode,
    Failure? failure,
    MfaChallenge? challenge,
    TotpEnrollment? enrollment,
    StaffUser? enrolledUser,
    @Default(<String>[]) List<String> recoveryCodes,
  }) = _StaffSignInState;

  const StaffSignInState._();

  @override
  String toString() =>
      'StaffSignInState(step: $step, submitting: $submitting, '
      'failure: $failure)';
}

@injectable
class StaffSignInCubit extends Cubit<StaffSignInState> {
  StaffSignInCubit(this._repository) : super(const StaffSignInState());

  final AuthRepository _repository;

  /// Aynı adımın çift tıklamayla iki kez gönderilmesini önler.
  final _guard = _SingleFlight();

  Future<void> submitCredentials({
    required String email,
    required String password,
  }) => _guard.run(() async {
    emit(state.copyWith(submitting: true, failure: null));
    final result = await _repository.startSignIn(
      email: email,
      password: password,
    );
    await result.fold(
      (failure) async =>
          emit(state.copyWith(submitting: false, failure: failure)),
      (challenge) async {
        if (challenge.step == MfaStep.enroll) {
          emit(
            state.copyWith(
              step: SignInStep.enroll,
              challenge: challenge,
              submitting: true,
            ),
          );
          await _loadEnrollment(challenge);
        } else {
          emit(
            state.copyWith(
              step: SignInStep.verify,
              challenge: challenge,
              submitting: false,
            ),
          );
        }
      },
    );
  });

  Future<void> _loadEnrollment(MfaChallenge challenge) async {
    final result = await _repository.beginEnrollment(challenge);
    emit(
      result.fold(
        (failure) => state.copyWith(submitting: false, failure: failure),
        (enrollment) =>
            state.copyWith(submitting: false, enrollment: enrollment),
      ),
    );
  }

  void toggleRecoveryCode() => emit(
    state.copyWith(useRecoveryCode: !state.useRecoveryCode, failure: null),
  );

  Future<void> verify(String code) => _guard.run(() async {
    final challenge = state.challenge;
    if (challenge == null) {
      return;
    }
    emit(state.copyWith(submitting: true, failure: null));
    final result = await _repository.verifyMfa(
      challenge,
      code: state.useRecoveryCode ? null : code,
      recoveryCode: state.useRecoveryCode ? code : null,
    );
    // Başarıda AuthBloc oturumu açar ve yönlendirici panele geçer.
    result.fold(
      (failure) => emit(_afterFailure(failure)),
      (_) => emit(state.copyWith(submitting: false)),
    );
  });

  Future<void> confirmEnrollment(String code) => _guard.run(() async {
    final challenge = state.challenge;
    if (challenge == null) {
      return;
    }
    emit(state.copyWith(submitting: true, failure: null));
    final result = await _repository.confirmEnrollment(challenge, code);
    result.fold(
      (failure) => emit(_afterFailure(failure)),
      (signedIn) => emit(
        state.copyWith(
          submitting: false,
          step: SignInStep.recoveryCodes,
          recoveryCodes: signedIn.recoveryCodes,
          enrolledUser: signedIn.user,
          enrollment: null,
          challenge: null,
        ),
      ),
    );
  });

  /// Kodlar kaydedildi: oturum açılışı duyurulur.
  void finishEnrollment() {
    final user = state.enrolledUser;
    if (user != null) {
      _repository.completeEnrollment(user);
    }
  }

  /// Bilet süresi doldu veya kullanıcı başka hesapla girmek istiyor.
  void restart({Failure? failure}) => emit(StaffSignInState(failure: failure));

  /// Bilet tükendiyse (süre/deneme) ilk adıma dönülür ve neden gösterilir.
  StaffSignInState _afterFailure(Failure failure) {
    if (failure is AuthFailure &&
        failure.reason == AuthFailureReason.mfaExpired) {
      return StaffSignInState(failure: failure);
    }
    if (failure is TooManyRequestsFailure) {
      return StaffSignInState(failure: failure);
    }
    return state.copyWith(submitting: false, failure: failure);
  }
}

class _SingleFlight {
  Future<void>? _current;

  Future<void> run(Future<void> Function() action) {
    final current = _current;
    if (current != null) {
      return current;
    }
    return _current = action().whenComplete(() => _current = null);
  }
}
