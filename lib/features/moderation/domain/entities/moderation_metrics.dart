import 'package:vakif_atlas_admin/features/moderation/domain/entities/moderated_memory.dart';

/// YZ moderasyonu metrikleri (`memories/admin/moderation-metrics`, ADR 58).
final class ModerationMetrics {
  const ModerationMetrics({
    required this.mode,
    required this.days,
    required this.thresholds,
    required this.totals,
    required this.humanReview,
    required this.overrides,
    required this.histogram,
    required this.categories,
    required this.latency,
    required this.daily,
    this.modelVersion,
  });

  /// `auto` / `manual` / `ai`.
  final String mode;
  final String? modelVersion;
  final int days;
  final MetricsThresholds thresholds;
  final MetricsTotals totals;
  final MetricsHumanReview humanReview;
  final MetricsOverrides overrides;
  final List<MetricsBin> histogram;
  final Map<AiCategory, int> categories;
  final MetricsLatency latency;
  final List<MetricsDay> daily;
}

final class MetricsThresholds {
  const MetricsThresholds({
    required this.approveBelow,
    required this.rejectFrom,
    required this.reviewPhotos,
  });

  final double approveBelow;
  final double rejectFrom;
  final bool reviewPhotos;
}

final class MetricsTotals {
  const MetricsTotals({
    required this.shared,
    required this.scored,
    required this.autoApproved,
    required this.review,
    required this.autoRejected,
    required this.unscored,
  });

  final int shared;
  final int scored;
  final int autoApproved;
  final int review;
  final int autoRejected;
  final int unscored;

  /// YZ'nin değerlendirdiği (skorlanan + skorlanamayan) anı sayısı.
  int get handled => autoApproved + review + autoRejected + unscored;
}

final class MetricsHumanReview {
  const MetricsHumanReview({
    required this.waiting,
    required this.decided,
    required this.approved,
    required this.rejected,
    this.oldestWaitingMinutes,
    this.medianDecisionMinutes,
  });

  final int waiting;
  final int? oldestWaitingMinutes;
  final int decided;
  final int approved;
  final int rejected;
  final int? medianDecisionMinutes;
}

/// Personelin YZ kararını tersine çevirdiği durumlar (doğruluk vekilleri).
final class MetricsOverrides {
  const MetricsOverrides({
    required this.autoRejectRestored,
    required this.autoApproveRemoved,
  });

  final int autoRejectRestored;
  final int autoApproveRemoved;
}

/// Skor kovası ve kovadaki anıların bugünkü durumu.
final class MetricsBin {
  const MetricsBin({
    required this.from,
    required this.to,
    required this.total,
    required this.approved,
    required this.pending,
    required this.rejected,
  });

  final double from;
  final double to;
  final int total;
  final int approved;
  final int pending;
  final int rejected;
}

final class MetricsLatency {
  const MetricsLatency({this.p50Ms, this.p95Ms});

  final int? p50Ms;
  final int? p95Ms;
}

final class MetricsDay {
  const MetricsDay({
    required this.date,
    required this.autoApproved,
    required this.review,
    required this.autoRejected,
  });

  final DateTime date;
  final int autoApproved;
  final int review;
  final int autoRejected;
}
