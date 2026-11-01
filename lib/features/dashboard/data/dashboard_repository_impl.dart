import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas_admin/core/network/api_guard.dart';
import 'package:vakif_atlas_admin/core/network/network_constants.dart';
import 'package:vakif_atlas_admin/core/utils/typedefs.dart';
import 'package:vakif_atlas_admin/features/dashboard/domain/entities/dashboard_summary.dart';
import 'package:vakif_atlas_admin/features/dashboard/domain/repositories/dashboard_repository.dart';

@LazySingleton(as: DashboardRepository)
class DashboardRepositoryImpl implements DashboardRepository {
  DashboardRepositoryImpl(@Named(DioNames.api) this._dio);

  final Dio _dio;

  ResultFuture<T> _get<T>(
    String path,
    T Function(Map<String, dynamic>) parse,
  ) => guardApi(() async {
    final response = await _dio.get<Map<String, dynamic>>(path);
    return parse(response.data!);
  });

  static Map<String, int> _counts(Object? value) => {
    for (final MapEntry(:key, :value)
        in (value as Map<String, dynamic>).entries)
      key: value as int,
  };

  @override
  ResultFuture<ReportsSummary> reports() => _get(
    'civil-protection/admin/summary',
    (json) => ReportsSummary(
      total: json['total'] as int,
      open: json['open'] as int,
      byStatus: _counts(json['byStatus']),
      openByUrgency: _counts(json['openByUrgency']),
      openByEvidence: json['openByEvidence'] == null
          ? const {}
          : _counts(json['openByEvidence']),
    ),
  );

  @override
  ResultFuture<ModerationSummary> moderation() => _get(
    'memories/admin/summary',
    (json) => ModerationSummary(
      pending: json['pending'] as int,
      reported: json['reported'] as int,
      hiddenByReports: json['hiddenByReports'] as int,
      rejected: json['rejected'] as int,
      approved: json['approved'] as int,
      autoRejected24h: json['autoRejected24h'] as int? ?? 0,
      unscored: json['unscored'] as int? ?? 0,
    ),
  );

  @override
  ResultFuture<FeedbackSummary> feedback() => _get(
    'feedback/admin/summary',
    (json) => FeedbackSummary(
      total: json['total'] as int,
      byStatus: _counts(json['byStatus']),
      byCategory: _counts(json['byCategory']),
      averageRating: (json['averageRating'] as num?)?.toDouble(),
      ratingCount: json['ratingCount'] as int,
    ),
  );

  @override
  ResultFuture<CatalogSummary> catalog() => _get(
    'catalog/admin/summary',
    // `works`: silinmemiş eser sayısı (külliyeler ayrı: `complexes`).
    (json) => CatalogSummary(
      total: json['works'] as int,
      published: json['published'] as int,
      archived: json['archived'] as int,
      byCategory: _counts(json['byCategory']),
      withoutImages: json['withoutImages'] as int,
      version: json['version'] as String,
    ),
  );
}
