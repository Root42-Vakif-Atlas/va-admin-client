import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas_admin/core/di/injection.dart';
import 'package:vakif_atlas_admin/features/moderation/domain/entities/moderated_memory.dart';
import 'package:vakif_atlas_admin/features/moderation/presentation/cubit/moderation_cubits.dart';

import '../../helpers/test_di.dart';
import '../../support/fake_backend.dart';
import 'moderation_fixtures.dart';

void main() {
  late FakeBackend backend;

  setUp(() async {
    backend = FakeBackend()
      ..on(
        'GET',
        'memories/admin/memories',
        (_) => FakeResponse(200, {
          'items': [memoryJson()],
          'total': 1,
          'nextCursor': null,
        }),
      );
    await TestDependencies.setUp(transport: (_) => FakeHttpTransport(backend));
  });

  tearDown(resetDependencies);

  test('YZ değerlendirmesi ayrıştırılır (skorlar, kategori, neden)', () async {
    final cubit = getIt<ModerationQueueCubit>(param1: null);
    await cubit.load();
    final memory = cubit.state.items.single;
    final ai = memory.ai!;
    expect(ai.verdict, AiVerdict.review);
    expect(ai.score, 0.62);
    expect(ai.scores[AiCategory.insult], 0.55);
    expect(ai.scores, hasLength(7));
    expect(ai.topCategory, AiCategory.insult);
    expect(ai.reviewCause, AiReviewCause.score);
    expect(ai.modelVersion, '0.4-int8');
    expect(memory.moderation.decidedBy, isNull);
    await cubit.close();
  });

  test('bekleyen kuyruk YZ skoruna göre, otomatik kaldırılanlar YZ '
      'kararıyla süzülür', () async {
    final cubit = getIt<ModerationQueueCubit>(param1: null);
    await cubit.load(const ModerationFilter(sort: ModerationSort.aiScore));
    expect(backend.last('GET', 'memories/admin/memories')!.query, {
      'status': 'pending',
      'sort': 'aiScore',
    });

    await cubit.load(
      const ModerationFilter(queue: ModerationQueue.autoRejected),
    );
    expect(backend.last('GET', 'memories/admin/memories')!.query, {
      'status': 'rejected',
      'decidedBy': 'ai',
    });
    await cubit.close();
  });

  test('YZ\'nin kaldırdığı anı If-Match ile geri yüklenir', () async {
    backend
      ..on(
        'GET',
        'memories/admin/memories/:id',
        (_) => FakeResponse(
          200,
          memoryJson(
            status: 'rejected',
            decisions: ['approve'],
            decidedBy: 'ai',
            ai: {
              'verdict': 'reject',
              'score': 0.97,
              'scores': {'toxicity': 0.97, 'insult': 0.97},
              'topCategory': 'insult',
              'reviewCause': null,
              'lexiconMatched': true,
              'modelVersion': '0.4-int8',
              'scoredAt': '2026-10-23T09:00:01Z',
            },
          ),
          {'ETag': '"v1"'},
        ),
      )
      ..on(
        'POST',
        'memories/admin/memories/:id/decisions',
        (_) => FakeResponse(
          200,
          memoryJson(
            status: 'approved',
            decisions: ['reject'],
            decidedBy: 'staff',
          ),
          {'ETag': '"v2"'},
        ),
      );
    final cubit = getIt<MemoryDetailCubit>(param1: 'mem_1');
    await cubit.load();
    final memory = cubit.state.value!;
    expect(memory.removedByAi, isTrue);
    expect(memory.ai!.lexiconMatched, isTrue);

    expect(await cubit.decide(ModerationDecision.approve), isTrue);
    final request = backend.last(
      'POST',
      'memories/admin/memories/mem_1/decisions',
    )!;
    expect(request.headers['if-match'], '"v1"');
    expect(request.json, {'decision': 'approve'});
    expect(cubit.state.value!.moderation.decidedBy, DecisionActor.staff);
    await cubit.close();
  });

  test('metrikler dönemle yüklenir, bilinmeyen kategori yok sayılır', () async {
    backend.on(
      'GET',
      'memories/admin/moderation-metrics',
      (request) => FakeResponse(
        200,
        metricsJson(days: int.parse(request.query['days']!)),
      ),
    );
    final cubit = getIt<ModerationMetricsCubit>();
    await cubit.load();
    var metrics = cubit.state.metrics!;
    expect(metrics.days, 30);
    expect(metrics.thresholds.approveBelow, 0.31);
    expect(metrics.totals.handled, 120);
    expect(metrics.histogram, hasLength(10));
    expect(metrics.categories, {AiCategory.insult: 9, AiCategory.obscene: 5});
    expect(metrics.daily.last.date, DateTime(2026, 10, 23));

    await cubit.load(7);
    metrics = cubit.state.metrics!;
    expect(cubit.state.days, 7);
    expect(metrics.days, 7);
    expect(backend.last('GET', 'memories/admin/moderation-metrics')!.query, {
      'days': '7',
    });
    await cubit.close();
  });
}
