import 'package:vakif_atlas_admin/core/utils/paged.dart';
import 'package:vakif_atlas_admin/core/utils/typedefs.dart';
import 'package:vakif_atlas_admin/core/utils/versioned.dart';
import 'package:vakif_atlas_admin/features/auth/domain/entities/staff_role.dart';
import 'package:vakif_atlas_admin/features/staff/domain/staff_member.dart';

/// Personel yönetimi (`auth/admin/staff*`, yalnızca yönetici).
abstract interface class StaffRepository {
  ResultFuture<Paged<StaffMember>> list(StaffFilter filter, {String? cursor});

  ResultFuture<Versioned<StaffMember>> get(String id);

  ResultFuture<Versioned<StaffMember>> invite(StaffInvitation invitation);

  ResultFuture<Versioned<StaffMember>> setRoles(
    String id, {
    required String etag,
    required Set<StaffRole> roles,
  });

  ResultFuture<Versioned<StaffMember>> setDisabled(
    String id, {
    required String etag,
    required bool disabled,
  });

  /// Authenticator sıfırlanır; personel sonraki girişte yeniden kurar.
  ResultFuture<Versioned<StaffMember>> resetMfa(
    String id, {
    required String etag,
  });

  ResultFuture<Versioned<StaffMember>> revokeSessions(String id);
}
