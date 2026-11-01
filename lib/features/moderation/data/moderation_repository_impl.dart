import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas_admin/core/network/api_guard.dart';
import 'package:vakif_atlas_admin/core/network/network_constants.dart';
import 'package:vakif_atlas_admin/core/network/preconditions.dart';
import 'package:vakif_atlas_admin/core/utils/paged.dart';
import 'package:vakif_atlas_admin/core/utils/typedefs.dart';
import 'package:vakif_atlas_admin/core/utils/versioned.dart';
import 'package:vakif_atlas_admin/features/moderation/domain/entities/moderated_memory.dart';
import 'package:vakif_atlas_admin/features/moderation/domain/entities/moderation_metrics.dart';
import 'package:vakif_atlas_admin/features/moderation/domain/repositories/moderation_repository.dart';

@LazySingleton(as: ModerationRepository)
class ModerationRepositoryImpl implements ModerationRepository {
  ModerationRepositoryImpl(@Named(DioNames.api) this._dio);

  final Dio _dio;

  static const String _base = 'memories/admin/memories';

  static Map<String, String> query(ModerationFilter filter, String? cursor) => {
    ...switch (filter.queue) {
      ModerationQueue.pending => {
        'status': 'pending',
        'sort': filter.sort.name,
      },
      ModerationQueue.reported => {
        'reported': 'true',
        'status': 'approved,pending',
        'sort': 'mostReported',
      },
      ModerationQueue.autoRejected => {'status': 'rejected', 'decidedBy': 'ai'},
      ModerationQueue.rejected => {'status': 'rejected'},
      ModerationQueue.all => <String, String>{},
    },
    if (filter.query.isNotEmpty) 'q': filter.query,
    'cursor': ?cursor,
  };

  static ModeratedMemory parse(Map<String, dynamic> json) {
    final monument = json['monument'] as Map<String, dynamic>;
    final author = json['author'] as Map<String, dynamic>;
    final moderation = json['moderation'] as Map<String, dynamic>;
    final by = moderation['by'] as Map<String, dynamic>?;
    final reports = json['reports'] as List<dynamic>?;
    return ModeratedMemory(
      id: json['id'] as String,
      monumentId: monument['id'] as String,
      monumentName: monument['name'] as String,
      monumentCity: monument['city'] as String,
      authorName: author['displayName'] as String,
      text: json['text'] as String,
      photos: [
        for (final photo in json['photos'] as List<dynamic>)
          MemoryPhoto(
            url: (photo as Map<String, dynamic>)['url'] as String,
            thumbnailUrl: photo['thumbnailUrl'] as String,
            description: photo['description'] as String?,
          ),
      ],
      createdAt: DateTime.parse(json['createdAt'] as String),
      memoryDate: json['memoryDate'] as String,
      visitedOn: json['visitedOn'] as String?,
      status: MemoryStatus.fromWire(json['status'] as String),
      publiclyVisible: json['publiclyVisible'] as bool,
      openReports: json['openReports'] as int,
      reportReasons: {
        for (final MapEntry(:key, :value)
            in (json['reportReasons'] as Map<String, dynamic>).entries)
          ModerationReason.fromWire(key): value as int,
      },
      moderation: ModerationInfo(
        reason: moderation['reason'] == null
            ? null
            : ModerationReason.fromWire(moderation['reason'] as String),
        note: moderation['note'] as String?,
        byName: by == null
            ? null
            : (by['displayName'] as String? ?? by['id'] as String),
        at: moderation['at'] == null
            ? null
            : DateTime.parse(moderation['at'] as String),
        decidedBy: switch (moderation['decidedBy']) {
          'ai' => DecisionActor.ai,
          'staff' => DecisionActor.staff,
          _ => null,
        },
      ),
      ai: parseAi(json['ai'] as Map<String, dynamic>?),
      allowedDecisions: [
        for (final decision in json['allowedDecisions'] as List<dynamic>)
          ModerationDecision.values.firstWhere((d) => d.wireName == decision),
      ],
      reports: reports == null
          ? null
          : [
              for (final report in reports.cast<Map<String, dynamic>>())
                MemoryReportEntry(
                  reason: ModerationReason.fromWire(report['reason'] as String),
                  note: report['note'] as String?,
                  resolution: ReportResolution.values.firstWhere(
                    (r) => r.name == report['resolution'],
                    orElse: () => ReportResolution.open,
                  ),
                  createdAt: DateTime.parse(report['createdAt'] as String),
                ),
            ],
    );
  }

  static AiAssessment? parseAi(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }
    final scores = json['scores'] as Map<String, dynamic>?;
    return AiAssessment(
      verdict: AiVerdict.fromWire(json['verdict'] as String),
      score: (json['score'] as num?)?.toDouble(),
      scores: {
        for (final MapEntry(:key, :value) in (scores ?? const {}).entries)
          ?AiCategory.fromWire(key): (value as num).toDouble(),
      },
      topCategory: AiCategory.fromWire(json['topCategory'] as String?),
      reviewCause: AiReviewCause.fromWire(json['reviewCause'] as String?),
      lexiconMatched: json['lexiconMatched'] as bool? ?? false,
      modelVersion: json['modelVersion'] as String?,
      scoredAt: json['scoredAt'] == null
          ? null
          : DateTime.parse(json['scoredAt'] as String),
      nsfw: (json['nsfw'] as num?)?.toDouble(),
      similarity: (json['similarity'] as num?)?.toDouble(),
      images: [
        for (final image
            in (json['images'] as List<dynamic>? ?? const [])
                .cast<Map<String, dynamic>>())
          AiImageScore(
            photoId: image['photoId'] as String,
            readable: image['readable'] as bool? ?? true,
            nsfw: (image['nsfw'] as num?)?.toDouble(),
            similarity: (image['similarity'] as num?)?.toDouble(),
            references: image['references'] as int? ?? 0,
          ),
      ],
      visionVersion: json['visionVersion'] as String?,
      spam: (json['spam'] as num?)?.toDouble(),
      spamSignals: [
        for (final signal in json['spamSignals'] as List<dynamic>? ?? const [])
          signal as String,
      ],
      relevance: (json['relevance'] as num?)?.toDouble(),
      contextVersion: json['contextVersion'] as String?,
    );
  }

  static ModerationMetrics parseMetrics(Map<String, dynamic> json) {
    final thresholds = json['thresholds'] as Map<String, dynamic>;
    final totals = json['totals'] as Map<String, dynamic>;
    final review = json['humanReview'] as Map<String, dynamic>;
    final overrides = json['overrides'] as Map<String, dynamic>;
    final latency = json['latency'] as Map<String, dynamic>;
    return ModerationMetrics(
      mode: json['mode'] as String,
      modelVersion: json['modelVersion'] as String?,
      days: json['days'] as int,
      thresholds: MetricsThresholds(
        approveBelow: (thresholds['approveBelow'] as num).toDouble(),
        rejectFrom: (thresholds['rejectFrom'] as num).toDouble(),
        reviewPhotos: thresholds['reviewPhotos'] as bool,
      ),
      totals: MetricsTotals(
        shared: totals['shared'] as int,
        scored: totals['scored'] as int,
        autoApproved: totals['autoApproved'] as int,
        review: totals['review'] as int,
        autoRejected: totals['autoRejected'] as int,
        unscored: totals['unscored'] as int,
      ),
      humanReview: MetricsHumanReview(
        waiting: review['waiting'] as int,
        oldestWaitingMinutes: review['oldestWaitingMinutes'] as int?,
        decided: review['decided'] as int,
        approved: review['approved'] as int,
        rejected: review['rejected'] as int,
        medianDecisionMinutes: review['medianDecisionMinutes'] as int?,
      ),
      overrides: MetricsOverrides(
        autoRejectRestored: overrides['autoRejectRestored'] as int,
        autoApproveRemoved: overrides['autoApproveRemoved'] as int,
      ),
      histogram: [
        for (final bin
            in (json['scoreHistogram'] as List<dynamic>)
                .cast<Map<String, dynamic>>())
          MetricsBin(
            from: (bin['from'] as num).toDouble(),
            to: (bin['to'] as num).toDouble(),
            total: bin['total'] as int,
            approved: bin['approved'] as int,
            pending: bin['pending'] as int,
            rejected: bin['rejected'] as int,
          ),
      ],
      categories: {
        for (final MapEntry(:key, :value)
            in (json['categories'] as Map<String, dynamic>).entries)
          ?AiCategory.fromWire(key): value as int,
      },
      latency: MetricsLatency(
        p50Ms: latency['p50Ms'] as int?,
        p95Ms: latency['p95Ms'] as int?,
      ),
      daily: [
        for (final day
            in (json['daily'] as List<dynamic>).cast<Map<String, dynamic>>())
          MetricsDay(
            date: DateTime.parse(day['date'] as String),
            autoApproved: day['autoApproved'] as int,
            review: day['review'] as int,
            autoRejected: day['autoRejected'] as int,
          ),
      ],
    );
  }

  @override
  ResultFuture<ModerationMetrics> metrics(int days) => guardApi(() async {
    final response = await _dio.get<Map<String, dynamic>>(
      'memories/admin/moderation-metrics',
      queryParameters: {'days': '$days'},
    );
    return parseMetrics(response.data!);
  });

  @override
  ResultFuture<Paged<ModeratedMemory>> list(
    ModerationFilter filter, {
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
  ResultFuture<Versioned<ModeratedMemory>> get(String id) => guardApi(() async {
    final response = await _dio.get<Map<String, dynamic>>(
      '$_base/${Uri.encodeComponent(id)}',
    );
    return Versioned(parse(response.data!), Preconditions.etagOf(response));
  });

  @override
  ResultFuture<Versioned<ModeratedMemory>> decide(
    String id, {
    required String etag,
    required ModerationDecision decision,
    ModerationReason? reason,
    String? note,
  }) => guardApi(() async {
    final trimmed = note?.trim();
    final response = await _dio.post<Map<String, dynamic>>(
      '$_base/${Uri.encodeComponent(id)}/decisions',
      data: {
        'decision': decision.wireName,
        'reason': ?reason?.wireName,
        if (trimmed != null && trimmed.isNotEmpty) 'note': trimmed,
      },
      options: Preconditions.ifMatch(etag),
    );
    return Versioned(parse(response.data!), Preconditions.etagOf(response));
  });
}
