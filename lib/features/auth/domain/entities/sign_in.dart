import 'package:vakif_atlas_admin/core/utils/list_equality.dart';
import 'package:vakif_atlas_admin/features/auth/domain/entities/staff_user.dart';

/// Şifre doğrulandıktan sonra beklenen ikinci adım.
enum MfaStep {
  /// Authenticator kodu veya kurtarma kodu.
  verify,

  /// İlk giriş: Authenticator kurulumu.
  enroll,
}

/// Kısa ömürlü, tek kullanımlık giriş bileti (`mfaToken`). Bilet yalnızca
/// bellekte tutulur; loglanmaz ve cihaza yazılmaz.
final class MfaChallenge {
  const MfaChallenge({
    required this.token,
    required this.step,
    required this.expiresAt,
  });

  final String token;
  final MfaStep step;
  final DateTime expiresAt;

  @override
  bool operator ==(Object other) =>
      other is MfaChallenge &&
      other.token == token &&
      other.step == step &&
      other.expiresAt == expiresAt;

  @override
  int get hashCode => Object.hash(token, step, expiresAt);

  @override
  String toString() => 'MfaChallenge(step: $step, expiresAt: $expiresAt)';
}

/// Authenticator kurulumu: QR içeriği ([otpauthUri]) ve elle girilecek sır.
final class TotpEnrollment {
  const TotpEnrollment({
    required this.secret,
    required this.otpauthUri,
    required this.issuer,
    required this.account,
  });

  final String secret;
  final String otpauthUri;
  final String issuer;
  final String account;

  @override
  bool operator ==(Object other) =>
      other is TotpEnrollment &&
      other.secret == secret &&
      other.otpauthUri == otpauthUri;

  @override
  int get hashCode => Object.hash(secret, otpauthUri);

  /// Sır loglanmaz.
  @override
  String toString() => 'TotpEnrollment(issuer: $issuer)';
}

/// Açılan oturum. [recoveryCodes] yalnızca Authenticator kurulumundan sonra
/// bir kez döner (sunucuda yalnızca özetleri kalır).
final class SignInResult {
  const SignInResult({required this.user, this.recoveryCodes = const []});

  final StaffUser user;
  final List<String> recoveryCodes;

  @override
  bool operator ==(Object other) =>
      other is SignInResult &&
      other.user == user &&
      elementsEqual(other.recoveryCodes, recoveryCodes);

  @override
  int get hashCode => Object.hash(user, Object.hashAll(recoveryCodes));

  @override
  String toString() =>
      'SignInResult(user: $user, recoveryCodes: ${recoveryCodes.length})';
}
