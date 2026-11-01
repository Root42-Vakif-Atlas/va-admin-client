import 'package:vakif_atlas_admin/core/utils/either.dart';
import 'package:vakif_atlas_admin/core/utils/typedefs.dart';
import 'package:vakif_atlas_admin/features/auth/domain/entities/auth_session_event.dart';
import 'package:vakif_atlas_admin/features/auth/domain/entities/sign_in.dart';
import 'package:vakif_atlas_admin/features/auth/domain/entities/staff_user.dart';

/// Personel kimlik doğrulaması (`auth/staff/*`): şifre → TOTP. Personel
/// oturumu vatandaş oturumundan ayrıdır (ayrı audience, 10 dk erişim
/// anahtarı, 30 dk hareketsizlik, 12 saat üst sınır).
abstract interface class AuthRepository {
  Stream<AuthSessionEvent> get sessionEvents;

  /// Cihazda kayıtlı personel oturumunu geri yükler; yoksa `null`. Ağ
  /// gerektirmez; profil ardından [refreshProfile] ile tazelenir.
  ResultFuture<StaffUser?> restoreSession();

  /// Şifreyi doğrular; ikinci adım bileti döner.
  ResultFuture<MfaChallenge> startSignIn({
    required String email,
    required String password,
  });

  /// Authenticator kodu ([code]) veya kurtarma kodu ([recoveryCode]).
  ResultFuture<SignInResult> verifyMfa(
    MfaChallenge challenge, {
    String? code,
    String? recoveryCode,
  });

  ResultFuture<TotpEnrollment> beginEnrollment(MfaChallenge challenge);

  /// Kurulumu onaylar ve oturumu kaydeder; kurtarma kodları gösterilip
  /// kullanıcı kaydettiğini onaylayana kadar oturum açılışı duyurulmaz
  /// ([completeEnrollment]).
  ResultFuture<SignInResult> confirmEnrollment(
    MfaChallenge challenge,
    String code,
  );

  /// Kurtarma kodları onaylandı: oturum açılışı yayınlanır (panele geçiş).
  void completeEnrollment(StaffUser user);

  ResultFuture<StaffUser> refreshProfile();

  ResultFuture<Unit> logout();

  /// Kod e-postayla gelir; hesap olmasa da aynı sonuç döner (ADR 13).
  ResultFuture<Unit> requestPasswordReset(String email);

  ResultFuture<Unit> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  });

  /// Diğer oturumlar sonlanır, bu oturum yeni anahtarlarla sürer.
  ResultFuture<Unit> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  /// Güncel Authenticator koduyla yeni kurtarma kodları (eskiler geçersiz).
  ResultFuture<List<String>> regenerateRecoveryCodes(String code);
}
