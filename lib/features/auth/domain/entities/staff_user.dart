import 'package:vakif_atlas_admin/core/utils/list_equality.dart';
import 'package:vakif_atlas_admin/features/auth/domain/entities/staff_role.dart';

/// Oturum açmış VGM personeli.
final class StaffUser {
  const StaffUser({
    required this.id,
    required this.displayName,
    required this.email,
    required this.roles,
    this.mfaEnrolledAt,
    this.lastLoginAt,
    this.recoveryCodesRemaining = 0,
  });

  final String id;
  final String displayName;
  final String email;
  final Set<StaffRole> roles;
  final DateTime? mfaEnrolledAt;
  final DateTime? lastLoginAt;

  /// Kullanılmamış kurtarma kodu sayısı (azaldığında yenilemesi önerilir).
  final int recoveryCodesRemaining;

  bool can(StaffPermission permission) => roles.allows(permission);

  bool get isAdmin => roles.contains(StaffRole.admin);

  StaffUser copyWith({int? recoveryCodesRemaining}) => StaffUser(
    id: id,
    displayName: displayName,
    email: email,
    roles: roles,
    mfaEnrolledAt: mfaEnrolledAt,
    lastLoginAt: lastLoginAt,
    recoveryCodesRemaining:
        recoveryCodesRemaining ?? this.recoveryCodesRemaining,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StaffUser &&
          other.id == id &&
          other.displayName == displayName &&
          other.email == email &&
          setEquals(other.roles, roles) &&
          other.mfaEnrolledAt == mfaEnrolledAt &&
          other.lastLoginAt == lastLoginAt &&
          other.recoveryCodesRemaining == recoveryCodesRemaining;

  @override
  int get hashCode => Object.hash(
    id,
    displayName,
    email,
    Object.hashAllUnordered(roles),
    mfaEnrolledAt,
    lastLoginAt,
    recoveryCodesRemaining,
  );

  /// Loglarda PII sızmaması için yalnızca kimlik yazılır.
  @override
  String toString() => 'StaffUser(id: $id)';
}
