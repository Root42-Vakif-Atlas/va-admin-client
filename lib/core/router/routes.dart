import 'package:vakif_atlas_admin/features/auth/domain/entities/staff_role.dart';

/// Uygulama rotaları. Kayıt ayrıntıları ana-detay düzenindedir: liste
/// rotası seçili kaydın kimliğini yolda taşır (`/civil-protection/rpt_…`),
/// böylece derin bağlantı ve sistem geri hareketi seçimi korur. Kişisel veri
/// (e-posta vb.) yolda taşınmaz (ADR 14).
abstract final class AppRoutes {
  static const String splash = '/splash';
  static const String signIn = '/sign-in';
  static const String passwordReset = '/password-reset';

  static const String dashboard = '/';
  static const String catalog = '/catalog';
  static const String catalogNew = '/catalog/new';
  static const String catalogImport = '/catalog/import';
  static const String reports = '/civil-protection';
  static const String moderation = '/moderation';

  /// YZ moderasyon metrikleri; `/moderation/:id`'den önce eşlenir (anı
  /// kimlikleri `mem_` önekli, çakışmaz).
  static const String moderationMetrics = '/moderation/metrics';
  static const String feedback = '/feedback';
  static const String staff = '/staff';
  static const String audit = '/audit';
  static const String profile = '/profile';
  static const String settings = '/settings';

  static const String fromParameter = 'from';

  static String catalogEntry(String id) =>
      '$catalog/${Uri.encodeComponent(id)}';

  static String report(String id) => '$reports/${Uri.encodeComponent(id)}';

  static String memory(String id) => '$moderation/${Uri.encodeComponent(id)}';

  static String feedbackEntry(String id) =>
      '$feedback/${Uri.encodeComponent(id)}';

  static String staffMember(String id) => '$staff/${Uri.encodeComponent(id)}';

  /// Oturum açıkken anlamsız olan ekranlar.
  static bool isGuestOnly(String path) =>
      path == signIn || path == passwordReset;

  /// Bölümün gerektirdiği izin; pano, profil ve ayarlar herkese açıktır.
  static StaffPermission? permissionFor(String path) {
    bool under(String root) => path == root || path.startsWith('$root/');
    if (under(catalog)) {
      return StaffPermission.catalog;
    }
    if (under(reports)) {
      return StaffPermission.civilProtection;
    }
    if (under(moderation)) {
      return StaffPermission.memories;
    }
    if (under(feedback)) {
      return StaffPermission.feedback;
    }
    if (under(staff)) {
      return StaffPermission.staff;
    }
    if (under(audit)) {
      return StaffPermission.audit;
    }
    return null;
  }
}
