/// Personel rolleri (sunucu: `StaffRoles`). En az yetki ilkesi:
/// [admin] (Yönetici) her bölümü ve personel/denetim kaydı yönetimini,
/// [editor] (Editör) yalnızca kataloğu, [moderator] (Moderatör) yalnızca
/// kullanıcı içeriğini (Anı Köşesi, Sivil Koruma, geri bildirim) açar.
enum StaffRole {
  admin('vgm_admin'),
  editor('editor'),
  moderator('moderator');

  const StaffRole(this.wireName);

  final String wireName;

  static StaffRole? fromWire(String value) {
    for (final role in values) {
      if (role.wireName == value) {
        return role;
      }
    }
    return null;
  }
}

/// Panel bölümlerinin izinleri; menü ve rota koruması bunlardan türetilir.
enum StaffPermission {
  catalog,
  memories,
  civilProtection,
  feedback,
  staff,
  audit,
}

extension StaffRoleSet on Set<StaffRole> {
  bool allows(StaffPermission permission) {
    if (contains(StaffRole.admin)) {
      return true;
    }
    return switch (permission) {
      StaffPermission.catalog => contains(StaffRole.editor),
      StaffPermission.memories ||
      StaffPermission.civilProtection ||
      StaffPermission.feedback => contains(StaffRole.moderator),
      StaffPermission.staff || StaffPermission.audit => false,
    };
  }
}
