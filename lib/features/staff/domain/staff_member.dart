import 'package:vakif_atlas_admin/core/utils/list_equality.dart';
import 'package:vakif_atlas_admin/features/auth/domain/entities/staff_role.dart';

final class StaffMember {
  const StaffMember({
    required this.id,
    required this.displayName,
    required this.email,
    required this.roles,
    required this.disabled,
    required this.createdAt,
    this.mfaEnrolledAt,
    this.lastLoginAt,
  });

  final String id;
  final String displayName;
  final String email;
  final Set<StaffRole> roles;
  final bool disabled;
  final DateTime? mfaEnrolledAt;
  final DateTime? lastLoginAt;
  final DateTime createdAt;

  bool get mfaEnrolled => mfaEnrolledAt != null;

  @override
  bool operator ==(Object other) =>
      other is StaffMember &&
      other.id == id &&
      other.displayName == displayName &&
      setEquals(other.roles, roles) &&
      other.disabled == disabled &&
      other.mfaEnrolledAt == mfaEnrolledAt &&
      other.lastLoginAt == lastLoginAt;

  @override
  int get hashCode => Object.hash(id, disabled, mfaEnrolledAt, roles.length);

  @override
  String toString() => 'StaffMember($id)';
}

enum StaffStatusFilter { all, active, disabled }

final class StaffFilter {
  const StaffFilter({
    this.query = '',
    this.role,
    this.status = StaffStatusFilter.all,
  });

  final String query;
  final StaffRole? role;
  final StaffStatusFilter status;

  StaffFilter copyWith({
    String? query,
    StaffRole? Function()? role,
    StaffStatusFilter? status,
  }) => StaffFilter(
    query: query ?? this.query,
    role: role == null ? this.role : role(),
    status: status ?? this.status,
  );

  @override
  bool operator ==(Object other) =>
      other is StaffFilter &&
      other.query == query &&
      other.role == role &&
      other.status == status;

  @override
  int get hashCode => Object.hash(query, role, status);
}

/// Davet isteği; [idempotencyKey] diyalog açıldığında bir kez üretilir
/// (çift tıklama / ağ tekrarı ikinci hesap açmaz).
final class StaffInvitation {
  const StaffInvitation({
    required this.email,
    required this.displayName,
    required this.roles,
    required this.idempotencyKey,
  });

  final String email;
  final String displayName;
  final Set<StaffRole> roles;
  final String idempotencyKey;

  @override
  String toString() => 'StaffInvitation(roles: $roles)';
}
