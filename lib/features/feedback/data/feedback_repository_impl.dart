import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas_admin/core/network/api_guard.dart';
import 'package:vakif_atlas_admin/core/network/network_constants.dart';
import 'package:vakif_atlas_admin/core/network/preconditions.dart';
import 'package:vakif_atlas_admin/core/utils/paged.dart';
import 'package:vakif_atlas_admin/core/utils/typedefs.dart';
import 'package:vakif_atlas_admin/core/utils/versioned.dart';
import 'package:vakif_atlas_admin/features/feedback/domain/feedback_entry.dart';
import 'package:vakif_atlas_admin/features/feedback/domain/feedback_repository.dart';

@LazySingleton(as: FeedbackRepository)
class FeedbackRepositoryImpl implements FeedbackRepository {
  FeedbackRepositoryImpl(@Named(DioNames.api) this._dio);

  final Dio _dio;

  static const String _base = 'feedback/admin';

  static Map<String, String> query(FeedbackFilter filter, String? cursor) => {
    if (filter.statuses.isNotEmpty)
      'status': filter.statuses.map((s) => s.wireName).join(','),
    if (filter.categories.isNotEmpty)
      'category': filter.categories.map((c) => c.wireName).join(','),
    if (filter.ratings.isNotEmpty)
      'rating': filter.ratings.map((r) => r == 0 ? 'none' : '$r').join(','),
    if (filter.query.isNotEmpty) 'q': filter.query,
    'cursor': ?cursor,
  };

  static FeedbackEntry parse(Map<String, dynamic> json) {
    final handledBy = json['handledBy'] as Map<String, dynamic>?;
    return FeedbackEntry(
      id: json['id'] as String,
      category: FeedbackCategory.fromWire(json['category'] as String),
      rating: json['rating'] as int?,
      message: json['message'] as String,
      appVersion: json['appVersion'] as String?,
      platform: json['platform'] as String?,
      language: json['language'] as String,
      fromAccount: json['fromAccount'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      status: FeedbackStatus.fromWire(json['status'] as String),
      staffNote: json['staffNote'] as String?,
      handledByName: handledBy == null
          ? null
          : handledBy['displayName'] as String? ?? handledBy['id'] as String,
      handledAt: json['handledAt'] == null
          ? null
          : DateTime.parse(json['handledAt'] as String),
    );
  }

  @override
  ResultFuture<Paged<FeedbackEntry>> list(
    FeedbackFilter filter, {
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
          parse(item as Map<String, dynamic>),
      ],
      total: json['total'] as int,
      nextCursor: json['nextCursor'] as String?,
    );
  });

  @override
  ResultFuture<Versioned<FeedbackEntry>> get(String id) => guardApi(() async {
    final response = await _dio.get<Map<String, dynamic>>(
      '$_base/${Uri.encodeComponent(id)}',
    );
    return Versioned(parse(response.data!), Preconditions.etagOf(response));
  });

  @override
  ResultFuture<Versioned<FeedbackEntry>> triage(
    String id, {
    required String etag,
    required FeedbackStatus status,
    String? note,
  }) => guardApi(() async {
    final trimmed = note?.trim();
    final response = await _dio.put<Map<String, dynamic>>(
      '$_base/${Uri.encodeComponent(id)}/status',
      data: {
        'status': status.wireName,
        if (trimmed != null && trimmed.isNotEmpty) 'note': trimmed,
      },
      options: Preconditions.ifMatch(etag),
    );
    return Versioned(parse(response.data!), Preconditions.etagOf(response));
  });
}
