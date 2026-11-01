import 'package:vakif_atlas_admin/core/utils/paged.dart';
import 'package:vakif_atlas_admin/core/utils/typedefs.dart';
import 'package:vakif_atlas_admin/features/audit/domain/audit_entry.dart';

abstract interface class AuditRepository {
  ResultFuture<Paged<AuditEntry>> list(AuditFilter filter, {String? cursor});
}
