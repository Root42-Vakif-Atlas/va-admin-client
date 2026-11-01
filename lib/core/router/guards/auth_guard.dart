import 'package:vakif_atlas_admin/core/router/routes.dart';
import 'package:vakif_atlas_admin/features/auth/domain/entities/staff_role.dart';
import 'package:vakif_atlas_admin/features/auth/presentation/bloc/auth_bloc.dart';

/// Oturum ve rol tabanlı rota koruması.
///
/// - Oturum durumu bilinmiyorsa açılış ekranında beklenir.
/// - Oturum yoksa her bölüm girişe yönlendirir; hedef `from` ile korunur ve
///   girişten sonra açılır.
/// - Rolün açmadığı bölüm panoya yönlendirilir (sunucu da 404 döner).
/// - Hedef yalnızca uygulama içi bir yol olabilir (open redirect engellenir).
abstract final class AuthGuard {
  /// [location] için yönlendirme adresi; yönlendirme gerekmiyorsa `null`.
  static String? redirect(AuthState auth, Uri location) {
    final path = location.path;
    final isSplash = path == AppRoutes.splash;
    final requested = isSplash || AppRoutes.isGuestOnly(path)
        ? safeTarget(location.queryParameters[AppRoutes.fromParameter])
        : location.toString();

    switch (auth) {
      case AuthUnknown():
        return isSplash ? null : withFrom(AppRoutes.splash, requested);

      case AuthGuest():
        if (AppRoutes.isGuestOnly(path)) {
          return null;
        }
        return withFrom(AppRoutes.signIn, requested);

      case AuthAuthenticated(:final user):
        if (isSplash || AppRoutes.isGuestOnly(path)) {
          return allowed(requested, user.can) ?? AppRoutes.dashboard;
        }
        final permission = AppRoutes.permissionFor(path);
        if (permission != null && !user.can(permission)) {
          return AppRoutes.dashboard;
        }
        return null;
    }
  }

  static String? allowed(
    String? target,
    bool Function(StaffPermission permission) can,
  ) {
    if (target == null) {
      return null;
    }
    final permission = AppRoutes.permissionFor(Uri.parse(target).path);
    return permission == null || can(permission) ? target : null;
  }

  /// [path]'e, pano dışındaki dönüş hedefini `from` olarak ekler.
  static String withFrom(String path, String? from) {
    if (from == null || from == AppRoutes.dashboard) {
      return path;
    }
    return Uri(
      path: path,
      queryParameters: {AppRoutes.fromParameter: from},
    ).toString();
  }

  /// Yalnızca `/` ile başlayan, şema/host içermeyen uygulama içi yolları
  /// kabul eder; giriş ve açılış ekranlarına dönüş döngüsünü engeller.
  static String? safeTarget(String? raw) {
    if (raw == null || raw.isEmpty) {
      return null;
    }
    final uri = Uri.tryParse(raw);
    if (uri == null ||
        uri.hasScheme ||
        uri.hasAuthority ||
        !raw.startsWith('/') ||
        raw.startsWith('//')) {
      return null;
    }
    if (AppRoutes.isGuestOnly(uri.path) || uri.path == AppRoutes.splash) {
      return null;
    }
    return raw;
  }
}
