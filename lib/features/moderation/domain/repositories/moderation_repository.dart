import 'package:vakif_atlas_admin/core/utils/paged.dart';
import 'package:vakif_atlas_admin/core/utils/typedefs.dart';
import 'package:vakif_atlas_admin/core/utils/versioned.dart';
import 'package:vakif_atlas_admin/features/moderation/domain/entities/moderated_memory.dart';
import 'package:vakif_atlas_admin/features/moderation/domain/entities/moderation_metrics.dart';

/// Anı Köşesi moderasyonu (`memories/admin/*`).
abstract interface class ModerationRepository {
  ResultFuture<Paged<ModeratedMemory>> list(
    ModerationFilter filter, {
    String? cursor,
  });

  ResultFuture<Versioned<ModeratedMemory>> get(String id);

  /// `reject` için [reason] zorunlu; `approve` açık bildirimleri yersiz sayar.
  ResultFuture<Versioned<ModeratedMemory>> decide(
    String id, {
    required String etag,
    required ModerationDecision decision,
    ModerationReason? reason,
    String? note,
  });

  /// YZ moderasyon metrikleri (son [days] gün: 7, 30 veya 90).
  ResultFuture<ModerationMetrics> metrics(int days);
}
