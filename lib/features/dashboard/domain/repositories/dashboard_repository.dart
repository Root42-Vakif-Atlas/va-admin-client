import 'package:vakif_atlas_admin/core/utils/typedefs.dart';
import 'package:vakif_atlas_admin/features/dashboard/domain/entities/dashboard_summary.dart';

/// Bölüm özetleri (`<servis>/admin/summary`). Her biri ayrı servistir;
/// biri yanıt vermese de diğerleri gösterilir.
abstract interface class DashboardRepository {
  ResultFuture<ReportsSummary> reports();

  ResultFuture<ModerationSummary> moderation();

  ResultFuture<FeedbackSummary> feedback();

  ResultFuture<CatalogSummary> catalog();
}
