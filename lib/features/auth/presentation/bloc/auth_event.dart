part of 'auth_bloc.dart';

@freezed
sealed class AuthEvent with _$AuthEvent {
  /// Uygulama açılışında kayıtlı oturumu geri yükler.
  const factory AuthEvent.started() = AuthStarted;

  const factory AuthEvent.logoutRequested() = AuthLogoutRequested;

  /// Kök hareketsizlik izleyicisi (`IdleSessionMonitor`) süre dolunca.
  const factory AuthEvent.idleTimeout() = AuthIdleTimeout;

  /// Repository'den gelen giriş / çıkış / profil / oturum sona erme olayı.
  const factory AuthEvent.sessionChanged(AuthSessionEvent event) =
      AuthSessionChanged;
}
