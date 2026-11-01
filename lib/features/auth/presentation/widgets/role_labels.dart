import 'package:vakif_atlas_admin/core/l10n/l10n.dart';
import 'package:vakif_atlas_admin/features/auth/domain/entities/staff_role.dart';

extension StaffRoleLabel on StaffRole {
  String label(AppLocalizations l10n) => switch (this) {
    StaffRole.admin => l10n.roleAdmin,
    StaffRole.editor => l10n.roleEditor,
    StaffRole.moderator => l10n.roleModerator,
  };

  /// Rolün açtığı bölümler (rol seçiminde açıklama).
  String description(AppLocalizations l10n) => switch (this) {
    StaffRole.admin => l10n.roleAdminDescription,
    StaffRole.editor => l10n.roleEditorDescription,
    StaffRole.moderator => l10n.roleModeratorDescription,
  };
}

/// Kullanıcının en yetkili rolü (kenar çubuğu rozeti için).
StaffRole? primaryRole(Set<StaffRole> roles) {
  for (final role in StaffRole.values) {
    if (roles.contains(role)) {
      return role;
    }
  }
  return null;
}
