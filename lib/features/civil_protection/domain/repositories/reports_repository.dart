import 'package:vakif_atlas_admin/core/utils/paged.dart';
import 'package:vakif_atlas_admin/core/utils/typedefs.dart';
import 'package:vakif_atlas_admin/core/utils/versioned.dart';
import 'package:vakif_atlas_admin/features/civil_protection/domain/entities/damage_report.dart';

/// Sivil Koruma incelemesi (`civil-protection/admin/*`).
abstract interface class ReportsRepository {
  ResultFuture<Paged<DamageReport>> list(ReportFilter filter, {String? cursor});

  ResultFuture<Versioned<DamageReport>> get(String id);

  /// [etag] okunan sürümdür; arada başkası değiştirdiyse `StaleDataFailure`.
  ResultFuture<Versioned<DamageReport>> changeStatus(
    String id, {
    required String etag,
    required ReportStatus status,
    String? note,
    String? internalNote,
  });
}
