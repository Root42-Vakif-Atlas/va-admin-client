import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas_admin/features/auth/domain/entities/auth_session_event.dart';
import 'package:vakif_atlas_admin/features/auth/domain/entities/staff_user.dart';
import 'package:vakif_atlas_admin/features/auth/domain/repositories/auth_repository.dart';

part 'auth_bloc.freezed.dart';
part 'auth_event.dart';
part 'auth_state.dart';

/// Uygulama genelindeki personel oturumu. Router'ın `AuthGuard`'ı bu durumu
/// dinler; rol bazlı menü ve rota koruması [AuthAuthenticated.user]'dan
/// türetilir.
@lazySingleton
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._repository) : super(const AuthState.unknown()) {
    on<AuthStarted>(_onStarted, transformer: droppable());
    on<AuthLogoutRequested>(_onLogoutRequested, transformer: droppable());
    on<AuthIdleTimeout>(_onIdleTimeout, transformer: droppable());
    on<AuthSessionChanged>(_onSessionChanged);

    _sessionSubscription = _repository.sessionEvents.listen(
      (event) => add(AuthEvent.sessionChanged(event)),
    );
  }

  final AuthRepository _repository;
  late final StreamSubscription<AuthSessionEvent> _sessionSubscription;

  Future<void> _onStarted(AuthStarted event, Emitter<AuthState> emit) async {
    final result = await _repository.restoreSession();
    final user = result.fold((_) => null, (user) => user);
    if (user == null) {
      emit(const AuthState.guest());
      return;
    }
    emit(AuthState.authenticated(user));
    // Roller sunucuda değişmiş olabilir; çevrimdışıysa önbellekteki profil
    // geçerli kalır (ADR 51: açılışta oturum düşmez).
    unawaited(_repository.refreshProfile());
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _repository.logout();
    emit(const AuthState.guest());
  }

  /// 30 dk hareketsizlik: oturum kapatılır (sunucuda da yenileme anahtarı
  /// aynı sürede geçersizleşir); giriş ekranı nedeni bildirir.
  Future<void> _onIdleTimeout(
    AuthIdleTimeout event,
    Emitter<AuthState> emit,
  ) async {
    if (state is! AuthAuthenticated) {
      return;
    }
    await _repository.logout();
    emit(const AuthState.guest(reason: GuestReason.idle));
  }

  void _onSessionChanged(AuthSessionChanged event, Emitter<AuthState> emit) {
    switch (event.event) {
      case SignedIn(:final user):
        emit(AuthState.authenticated(user));
      case ProfileRefreshed(:final user):
        if (state is AuthAuthenticated) {
          emit(AuthState.authenticated(user));
        }
      case SignedOut():
        if (state is AuthAuthenticated) {
          emit(const AuthState.guest());
        }
      case SessionExpired():
        if (state is AuthAuthenticated) {
          emit(const AuthState.guest(reason: GuestReason.expired));
        }
    }
  }

  @override
  Future<void> close() async {
    await _sessionSubscription.cancel();
    return super.close();
  }
}
