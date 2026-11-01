import 'package:vakif_atlas_admin/core/utils/paged.dart';
import 'package:vakif_atlas_admin/core/utils/typedefs.dart';
import 'package:vakif_atlas_admin/core/utils/versioned.dart';
import 'package:vakif_atlas_admin/features/feedback/domain/feedback_entry.dart';

/// Geri bildirim triajı (`feedback/admin/*`).
abstract interface class FeedbackRepository {
  ResultFuture<Paged<FeedbackEntry>> list(
    FeedbackFilter filter, {
    String? cursor,
  });

  ResultFuture<Versioned<FeedbackEntry>> get(String id);

  ResultFuture<Versioned<FeedbackEntry>> triage(
    String id, {
    required String etag,
    required FeedbackStatus status,
    String? note,
  });
}
