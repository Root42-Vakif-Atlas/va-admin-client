part of 'auth_bloc.dart';

/// Oturumun kullanıcı isteği dışında kapanma nedeni (giriş ekranında
/// bildirilir).
enum GuestReason { none, expired, idle }

@freezed
sealed class AuthState with _$AuthState {
  /// Kayıtlı oturum henüz okunmadı (açılış).
  const factory AuthState.unknown() = AuthUnknown;

  /// Oturum yok: yalnızca giriş ve şifre sıfırlama ekranları açık.
  const factory AuthState.guest({
    @Default(GuestReason.none) GuestReason reason,
  }) = AuthGuest;

  const factory AuthState.authenticated(StaffUser user) = AuthAuthenticated;
}
