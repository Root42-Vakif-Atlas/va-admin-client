import 'package:vakif_atlas_admin/features/auth/domain/entities/staff_user.dart';

/// Oturum durumundaki değişiklikler.
sealed class AuthSessionEvent {
  const AuthSessionEvent();
}

final class SignedIn extends AuthSessionEvent {
  const SignedIn(this.user);

  final StaffUser user;

  @override
  bool operator ==(Object other) => other is SignedIn && other.user == user;

  @override
  int get hashCode => Object.hash(SignedIn, user);
}

/// Profil (rol, kurtarma kodu sayısı) sunucudan yenilendi.
final class ProfileRefreshed extends AuthSessionEvent {
  const ProfileRefreshed(this.user);

  final StaffUser user;

  @override
  bool operator ==(Object other) =>
      other is ProfileRefreshed && other.user == user;

  @override
  int get hashCode => Object.hash(ProfileRefreshed, user);
}

/// Kullanıcı isteğiyle oturum kapatıldı.
final class SignedOut extends AuthSessionEvent {
  const SignedOut();

  @override
  bool operator ==(Object other) => other is SignedOut;

  @override
  int get hashCode => (SignedOut).hashCode;
}

/// Anahtar yenilenemediği (sunucu reddetti: süre, rol değişikliği, devre
/// dışı bırakma) için oturum sona erdi.
final class SessionExpired extends AuthSessionEvent {
  const SessionExpired();

  @override
  bool operator ==(Object other) => other is SessionExpired;

  @override
  int get hashCode => (SessionExpired).hashCode;
}
