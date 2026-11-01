import 'package:injectable/injectable.dart';
import 'package:vakif_atlas_admin/core/utils/paged.dart';
import 'package:vakif_atlas_admin/core/utils/typedefs.dart';
import 'package:vakif_atlas_admin/core/utils/versioned.dart';
import 'package:vakif_atlas_admin/features/civil_protection/domain/entities/damage_report.dart';
import 'package:vakif_atlas_admin/features/civil_protection/domain/repositories/reports_repository.dart';
import 'package:vakif_atlas_admin/shared/paging/paged_list_cubit.dart';
import 'package:vakif_atlas_admin/shared/paging/record_cubit.dart';

/// Rapor kuyruğu (süzgeç, sıralama, imleç).
@injectable
class ReportsQueueCubit extends PagedListCubit<DamageReport, ReportFilter> {
  ReportsQueueCubit(this._repository, @factoryParam ReportFilter? initial)
    : super(initial ?? const ReportFilter());

  final ReportsRepository _repository;

  @override
  ResultFuture<Paged<DamageReport>> fetch(
    ReportFilter filter,
    String? cursor,
  ) => _repository.list(filter, cursor: cursor);

  @override
  String idOf(DamageReport item) => item.id;
}

/// Tek raporun ayrıntısı ve durum geçişi.
@injectable
class ReportDetailCubit extends RecordCubit<DamageReport> {
  ReportDetailCubit(this._repository, @factoryParam this.id);

  final ReportsRepository _repository;
  final String id;

  @override
  ResultFuture<Versioned<DamageReport>> fetch() => _repository.get(id);

  Future<bool> changeStatus(
    ReportStatus status, {
    String? note,
    String? internalNote,
  }) => mutate(
    (etag) => _repository.changeStatus(
      id,
      etag: etag,
      status: status,
      note: note,
      internalNote: internalNote,
    ),
  );
}
