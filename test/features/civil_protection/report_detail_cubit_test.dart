import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas_admin/core/di/injection.dart';
import 'package:vakif_atlas_admin/core/error/failures.dart';
import 'package:vakif_atlas_admin/features/civil_protection/domain/entities/damage_report.dart';
import 'package:vakif_atlas_admin/features/civil_protection/presentation/cubit/reports_cubits.dart';

import '../../helpers/test_di.dart';
import '../../support/fake_backend.dart';

Map<String, dynamic> reportJson({
  String status = 'received',
  List<String> next = const ['inReview', 'closed'],
}) => {
  'id': 'rpt_1',
  'referenceCode': 'SK-2026-000001',
  'monument': {
    'id': 'selimiye-camii',
    'name': 'Selimiye Camii',
    'city': 'Edirne',
    'district': 'Merkez',
  },
  'category': 'vandalism',
  'urgency': 'high',
  'description': 'Avlu duvarında sprey boyayla yapılmış yazılar var.',
  'photos': <Object>[],
  'locationCheck': {'verification': 'onSite', 'distanceMeters': 120},
  'location': {'latitude': 41.0, 'longitude': 29.0, 'accuracyMeters': 25.0},
  'status': status,
  'allowedTransitions': next,
  'history': [
    {
      'status': 'received',
      'at': '2026-10-22T08:00:00Z',
      'note': null,
      'internalNote': null,
      'actor': null,
    },
  ],
  'anonymized': false,
  'createdAt': '2026-10-22T08:00:00Z',
  'updatedAt': '2026-10-22T08:00:00Z',
};

void main() {
  late FakeBackend backend;

  setUp(() async {
    backend = FakeBackend()
      ..on(
        'GET',
        'civil-protection/admin/reports/:id',
        (_) => FakeResponse(200, reportJson(), {'ETag': '"v1"'}),
      );
    await TestDependencies.setUp(transport: (_) => FakeHttpTransport(backend));
  });

  tearDown(resetDependencies);

  test('durum geçişi okunan sürümü If-Match ile gönderir', () async {
    backend.on(
      'POST',
      'civil-protection/admin/reports/:id/status',
      (request) => FakeResponse(
        200,
        reportJson(
          status: request.json['status'] as String,
          next: ['forwarded', 'resolved', 'closed'],
        ),
        {'ETag': '"v2"'},
      ),
    );
    final cubit = getIt<ReportDetailCubit>(param1: 'rpt_1');
    await cubit.load();
    expect(cubit.state.value!.location!.latitude, 41.0);
    expect(cubit.state.value!.allowedTransitions, [
      ReportStatus.inReview,
      ReportStatus.closed,
    ]);

    final saved = await cubit.changeStatus(
      ReportStatus.inReview,
      note: '  İncelemeye alındı. ',
      internalNote: '',
    );
    expect(saved, isTrue);
    final request = backend.last(
      'POST',
      'civil-protection/admin/reports/rpt_1/status',
    )!;
    expect(request.headers['if-match'], '"v1"');
    expect(request.json, {'status': 'inReview', 'note': 'İncelemeye alındı.'});
    expect(cubit.state.record!.etag, '"v2"');
    expect(cubit.state.savedCount, 1);
    await cubit.close();
  });

  test(
    'başkası değiştirdiyse (412) eskimiş veri hatası verir, kayıt korunur',
    () async {
      backend.on(
        'POST',
        'civil-protection/admin/reports/:id/status',
        (_) => FakeResponse.error(412, 'precondition_failed'),
      );
      final cubit = getIt<ReportDetailCubit>(param1: 'rpt_1');
      await cubit.load();

      expect(await cubit.changeStatus(ReportStatus.closed), isFalse);
      expect(cubit.state.actionFailure, const StaleDataFailure());
      expect(cubit.state.value!.status, ReportStatus.received);
      await cubit.close();
    },
  );

  test('geçersiz geçiş (409) çakışma hatası olarak eşlenir', () async {
    backend.on(
      'POST',
      'civil-protection/admin/reports/:id/status',
      (_) => FakeResponse.error(409, 'invalid_transition'),
    );
    final cubit = getIt<ReportDetailCubit>(param1: 'rpt_1');
    await cubit.load();
    await cubit.changeStatus(ReportStatus.inReview);
    expect(
      cubit.state.actionFailure,
      const ConflictFailure(ConflictReason.invalidTransition),
    );
    await cubit.close();
  });
}
