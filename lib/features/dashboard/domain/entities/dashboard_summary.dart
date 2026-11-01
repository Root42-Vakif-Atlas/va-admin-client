import 'package:vakif_atlas_admin/core/utils/list_equality.dart';

/// Sivil Koruma özeti: duruma göre sayılar, açık raporların aciliyeti ve YZ
/// kanıt etiketi (`pending`: henüz değerlendirilmedi).
final class ReportsSummary {
  const ReportsSummary({
    required this.total,
    required this.open,
    required this.byStatus,
    required this.openByUrgency,
    this.openByEvidence = const {},
  });

  final int total;
  final int open;
  final Map<String, int> byStatus;
  final Map<String, int> openByUrgency;

  /// Kanıt değerlendirmesi kapalı / eski sunucuda boş.
  final Map<String, int> openByEvidence;

  int get critical => openByUrgency['critical'] ?? 0;

  @override
  bool operator ==(Object other) =>
      other is ReportsSummary &&
      other.total == total &&
      other.open == open &&
      mapEquals(other.byStatus, byStatus) &&
      mapEquals(other.openByUrgency, openByUrgency) &&
      mapEquals(other.openByEvidence, openByEvidence);

  @override
  int get hashCode => Object.hash(
    total,
    open,
    byStatus.length,
    openByUrgency.length,
    openByEvidence.length,
  );
}

final class ModerationSummary {
  const ModerationSummary({
    required this.pending,
    required this.reported,
    required this.hiddenByReports,
    required this.rejected,
    required this.approved,
    this.autoRejected24h = 0,
    this.unscored = 0,
  });

  final int pending;
  final int reported;
  final int hiddenByReports;
  final int rejected;
  final int approved;

  /// Son 24 saatte YZ'nin otomatik kaldırdığı anılar (ADR 58).
  final int autoRejected24h;

  /// YZ servisi yanıt vermediği için skorlanamayan, bekleyen anılar.
  final int unscored;

  int get actionable => pending + reported;

  @override
  bool operator ==(Object other) =>
      other is ModerationSummary &&
      other.pending == pending &&
      other.reported == reported &&
      other.hiddenByReports == hiddenByReports &&
      other.rejected == rejected &&
      other.approved == approved &&
      other.autoRejected24h == autoRejected24h &&
      other.unscored == unscored;

  @override
  int get hashCode => Object.hash(
    pending,
    reported,
    hiddenByReports,
    rejected,
    approved,
    autoRejected24h,
    unscored,
  );
}

final class FeedbackSummary {
  const FeedbackSummary({
    required this.total,
    required this.byStatus,
    required this.byCategory,
    required this.averageRating,
    required this.ratingCount,
  });

  final int total;
  final Map<String, int> byStatus;
  final Map<String, int> byCategory;
  final double? averageRating;
  final int ratingCount;

  int get newCount => byStatus['new'] ?? 0;

  @override
  bool operator ==(Object other) =>
      other is FeedbackSummary &&
      other.total == total &&
      mapEquals(other.byStatus, byStatus) &&
      mapEquals(other.byCategory, byCategory) &&
      other.averageRating == averageRating &&
      other.ratingCount == ratingCount;

  @override
  int get hashCode => Object.hash(total, averageRating, ratingCount);
}

final class CatalogSummary {
  const CatalogSummary({
    required this.total,
    required this.published,
    required this.archived,
    required this.byCategory,
    required this.withoutImages,
    required this.version,
  });

  final int total;
  final int published;
  final int archived;
  final Map<String, int> byCategory;
  final int withoutImages;
  final String version;

  @override
  bool operator ==(Object other) =>
      other is CatalogSummary &&
      other.total == total &&
      other.published == published &&
      other.archived == archived &&
      mapEquals(other.byCategory, byCategory) &&
      other.withoutImages == withoutImages &&
      other.version == version;

  @override
  int get hashCode => Object.hash(total, published, archived, version);
}

/// Pano: kullanıcının rolünün açtığı bölümlerin özeti (yetkisiz bölüm
/// `null`; sunucuya hiç istenmez).
final class DashboardSummary {
  const DashboardSummary({
    this.reports,
    this.moderation,
    this.feedback,
    this.catalog,
  });

  final ReportsSummary? reports;
  final ModerationSummary? moderation;
  final FeedbackSummary? feedback;
  final CatalogSummary? catalog;

  @override
  bool operator ==(Object other) =>
      other is DashboardSummary &&
      other.reports == reports &&
      other.moderation == moderation &&
      other.feedback == feedback &&
      other.catalog == catalog;

  @override
  int get hashCode => Object.hash(reports, moderation, feedback, catalog);
}
