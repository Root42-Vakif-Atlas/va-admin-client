import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas_admin/core/error/failures.dart';
import 'package:vakif_atlas_admin/features/auth/domain/repositories/auth_repository.dart';

part 'password_reset_cubit.freezed.dart';

enum PasswordResetStep { request, confirm, done }

/// Şifre belirleme / sıfırlama (davet edilen personel ilk şifresini de bu
/// akışla belirler). E-posta yalnızca bellekte tutulur (ADR 14).
@freezed
abstract class PasswordResetState with _$PasswordResetState {
  const factory PasswordResetState({
    @Default(PasswordResetStep.request) PasswordResetStep step,
    @Default(false) bool submitting,
    @Default('') String email,
    Failure? failure,
  }) = _PasswordResetState;

  const PasswordResetState._();

  @override
  String toString() => 'PasswordResetState(step: $step, failure: $failure)';
}

@injectable
class PasswordResetCubit extends Cubit<PasswordResetState> {
  PasswordResetCubit(this._repository) : super(const PasswordResetState());

  final AuthRepository _repository;

  Future<void> requestCode(String email) async {
    if (state.submitting) {
      return;
    }
    emit(state.copyWith(submitting: true, failure: null));
    final result = await _repository.requestPasswordReset(email);
    emit(
      result.fold(
        (failure) => state.copyWith(submitting: false, failure: failure),
        (_) => state.copyWith(
          submitting: false,
          step: PasswordResetStep.confirm,
          email: email.trim(),
        ),
      ),
    );
  }

  Future<void> reset({
    required String code,
    required String newPassword,
  }) async {
    if (state.submitting) {
      return;
    }
    emit(state.copyWith(submitting: true, failure: null));
    final result = await _repository.resetPassword(
      email: state.email,
      code: code,
      newPassword: newPassword,
    );
    emit(
      result.fold(
        (failure) => state.copyWith(submitting: false, failure: failure),
        (_) => state.copyWith(submitting: false, step: PasswordResetStep.done),
      ),
    );
  }

  void changeEmail() => emit(const PasswordResetState());
}
