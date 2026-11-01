import 'package:injectable/injectable.dart';
import 'package:vakif_atlas_admin/core/utils/paged.dart';
import 'package:vakif_atlas_admin/core/utils/typedefs.dart';
import 'package:vakif_atlas_admin/features/audit/domain/audit_entry.dart';
import 'package:vakif_atlas_admin/features/audit/domain/audit_repository.dart';
import 'package:vakif_atlas_admin/shared/paging/paged_list_cubit.dart';

@injectable
class AuditCubit extends PagedListCubit<AuditEntry, AuditFilter> {
  AuditCubit(this._repository, @factoryParam AuditFilter? initial)
    : super(initial ?? const AuditFilter());

  final AuditRepository _repository;

  @override
  ResultFuture<Paged<AuditEntry>> fetch(AuditFilter filter, String? cursor) =>
      _repository.list(filter, cursor: cursor);

  @override
  String idOf(AuditEntry item) => item.id;
}
