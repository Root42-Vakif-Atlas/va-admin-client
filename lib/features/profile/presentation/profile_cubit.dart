import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas_admin/core/error/failures.dart';
import 'package:vakif_atlas_admin/features/auth/domain/repositories/auth_repository.dart';

part 'profile_cubit.freezed.dart';

enum ProfileAction { none, password, recoveryCodes }

/// Profil işlemleri: şifre değiştirme ve kurtarma kodlarını yenileme. Yeni
/// kodlar yalnızca bu durumda tutulur (bir kez gösterilir).
@freezed
abstract class ProfileState with _$ProfileState {
  const factory ProfileState({
    @Default(ProfileAction.none) ProfileAction running,
    Failure? failure,
    @Default(ProfileAction.none) ProfileAction failed,
    @Default(0) int passwordChanges,
    @Default(<String>[]) List<String> recoveryCodes,
  }) = _ProfileState;

  const ProfileState._();

  @override
  String toString() => 'ProfileState(running: $running, failure: $failure)';
}

@injectable
class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._repository) : super(const ProfileState());

  final AuthRepository _repository;

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    if (state.running != ProfileAction.none) {
      return false;
    }
    emit(state.copyWith(running: ProfileAction.password, failure: null));
    final result = await _repository.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
    return result.fold(
      (failure) {
        emit(
          state.copyWith(
            running: ProfileAction.none,
            failure: failure,
            failed: ProfileAction.password,
          ),
        );
        return false;
      },
      (_) {
        emit(
          state.copyWith(
            running: ProfileAction.none,
            passwordChanges: state.passwordChanges + 1,
          ),
        );
        return true;
      },
    );
  }

  Future<bool> regenerateRecoveryCodes(String code) async {
    if (state.running != ProfileAction.none) {
      return false;
    }
    emit(state.copyWith(running: ProfileAction.recoveryCodes, failure: null));
    final result = await _repository.regenerateRecoveryCodes(code);
    return result.fold(
      (failure) {
        emit(
          state.copyWith(
            running: ProfileAction.none,
            failure: failure,
            failed: ProfileAction.recoveryCodes,
          ),
        );
        return false;
      },
      (codes) {
        emit(state.copyWith(running: ProfileAction.none, recoveryCodes: codes));
        return true;
      },
    );
  }

  void dismissRecoveryCodes() => emit(state.copyWith(recoveryCodes: const []));
}
