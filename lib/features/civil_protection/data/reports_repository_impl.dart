import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas_admin/core/network/api_guard.dart';
import 'package:vakif_atlas_admin/core/network/network_constants.dart';
import 'package:vakif_atlas_admin/core/network/preconditions.dart';
import 'package:vakif_atlas_admin/core/utils/paged.dart';
import 'package:vakif_atlas_admin/core/utils/typedefs.dart';
import 'package:vakif_atlas_admin/core/utils/versioned.dart';
import 'package:vakif_atlas_admin/features/civil_protection/data/report_dtos.dart';
import 'package:vakif_atlas_admin/features/civil_protection/domain/entities/damage_report.dart';
import 'package:vakif_atlas_admin/features/civil_protection/domain/repositories/reports_repository.dart';

@LazySingleton(as: ReportsRepository)
class ReportsRepositoryImpl implements ReportsRepository {
  ReportsRepositoryImpl(@Named(DioNames.api) this._dio);

  final Dio _dio;

  static const String _base = 'civil-protection/admin/reports';

  static Map<String, String> query(ReportFilter filter, String? cursor) => {
    if (filter.openOnly || filter.statuses.isNotEmpty)
      'status': [
        if (filter.openOnly) 'open',
        for (final status in filter.statuses) status.wireName,
      ].join(','),
    if (filter.urgencies.isNotEmpty)
      'urgency': filter.urgencies.map((u) => u.wireName).join(','),
    if (filter.categories.isNotEmpty)
      'category': filter.categories.map((c) => c.wireName).join(','),
    if (filter.evidence.isNotEmpty)
      'evidence': filter.evidence.map((e) => e.wireName).join(','),
    if (filter.query.isNotEmpty) 'q': filter.query,
    'sort': filter.sort.name,
    'cursor': ?cursor,
  };

  @override
  ResultFuture<Paged<DamageReport>> list(
    ReportFilter filter, {
    String? cursor,
  }) => guardApi(() async {
    final response = await _dio.get<Map<String, dynamic>>(
      _base,
      queryParameters: query(filter, cursor),
    );
    final json = response.data!;
    return Paged(
      items: [
        for (final item in json['items'] as List<dynamic>)
          StaffReportDto.fromJson(item as Map<String, dynamic>).toDomain(),
      ],
      total: json['total'] as int,
      nextCursor: json['nextCursor'] as String?,
    );
  });

  @override
  ResultFuture<Versioned<DamageReport>> get(String id) => guardApi(() async {
    final response = await _dio.get<Map<String, dynamic>>(
      '$_base/${Uri.encodeComponent(id)}',
    );
    return Versioned(
      StaffReportDto.fromJson(response.data!).toDomain(),
      Preconditions.etagOf(response),
    );
  });

  @override
  ResultFuture<Versioned<DamageReport>> changeStatus(
    String id, {
    required String etag,
    required ReportStatus status,
    String? note,
    String? internalNote,
  }) => guardApi(() async {
    final response = await _dio.post<Map<String, dynamic>>(
      '$_base/${Uri.encodeComponent(id)}/status',
      data: {
        'status': status.wireName,
        'note': ?_clean(note),
        'internalNote': ?_clean(internalNote),
      },
      options: Preconditions.ifMatch(etag),
    );
    return Versioned(
      StaffReportDto.fromJson(response.data!).toDomain(),
      Preconditions.etagOf(response),
    );
  });

  static String? _clean(String? text) {
    final trimmed = text?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }
}
