import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas_admin/core/network/api_guard.dart';
import 'package:vakif_atlas_admin/core/network/network_constants.dart';
import 'package:vakif_atlas_admin/core/utils/paged.dart';
import 'package:vakif_atlas_admin/core/utils/typedefs.dart';
import 'package:vakif_atlas_admin/features/audit/domain/audit_entry.dart';
import 'package:vakif_atlas_admin/features/audit/domain/audit_repository.dart';

@LazySingleton(as: AuditRepository)
class AuditRepositoryImpl implements AuditRepository {
  AuditRepositoryImpl(@Named(DioNames.api) this._dio);

  final Dio _dio;

  @override
  ResultFuture<Paged<AuditEntry>> list(
    AuditFilter filter, {
    String? cursor,
  }) => guardApi(() async {
    final response = await _dio.get<Map<String, dynamic>>(
      'auth/admin/audit',
      queryParameters: {
        'service': ?filter.service,
        if (filter.targetId.isNotEmpty) 'targetId': filter.targetId,
        'from': ?filter.from?.toUtc().toIso8601String(),
        'to': ?filter.to?.toUtc().toIso8601String(),
        'cursor': ?cursor,
      },
    );
    final json = response.data!;
    return Paged(
      items: [
        for (final item
            in (json['items'] as List<dynamic>).cast<Map<String, dynamic>>())
          AuditEntry(
            id: item['id'] as String,
            at: DateTime.parse(item['at'] as String),
            actorId: (item['actor'] as Map<String, dynamic>)['id'] as String,
            actorName:
                (item['actor'] as Map<String, dynamic>)['displayName']
                    as String?,
            service: item['service'] as String,
            action: item['action'] as String,
            targetType: item['targetType'] as String,
            targetId: item['targetId'] as String,
            changes: {
              for (final MapEntry(:key, :value)
                  in (item['changes'] as Map<String, dynamic>).entries)
                key: value as String?,
            },
            correlationId: item['correlationId'] as String?,
          ),
      ],
      total: json['total'] as int,
      nextCursor: json['nextCursor'] as String?,
    );
  });
}
