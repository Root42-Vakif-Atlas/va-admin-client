import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas_admin/app.dart';
import 'package:vakif_atlas_admin/core/di/injection.dart';
import 'package:vakif_atlas_admin/core/router/app_router.dart';
import 'package:vakif_atlas_admin/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vakif_atlas_admin/features/civil_protection/domain/entities/damage_report.dart';
import 'package:vakif_atlas_admin/features/civil_protection/presentation/cubit/reports_cubits.dart';

import '../../helpers/test_di.dart';
import '../../support/fake_backend.dart';
import 'report_detail_cubit_test.dart' show reportJson;

/// Sunucunun `EvidencePolicy` çıktısı: katalog kopyası fotoğraf → şüpheli.
Map<String, dynamic> suspiciousEvidence() => {
  'level': 'suspicious',
  'reasons': [
    {'code': 'location.onSite', 'effect': 'supports', 'value': 120},
    {'code': 'photo.catalogCopy', 'effect': 'undermines', 'value': 0.9712},
    {
      'code': 'text.contact',
      'effect': 'neutral',
      'value': 0.6,
      'detail': 'contact',
    },
    {
      'code': 'category.suggested',
      'effect': 'neutral',
      'value': 0.52,
      'detail': 'structuralDamage',
    },
    {'code': 'future.signal', 'effect': 'neutral'},
  ],
  'version': 'evidence-1',
  'scoredAt': '2026-10-22T08:00:06Z',
};

Map<String, dynamic> evidenceReportJson({Map<String, dynamic>? evidence}) => {
  ...reportJson(),
  'evidence': evidence,
};

/// YZ kanıt etiketi (kök ADR 35): süzgeç/sıra sözleşmesi, ayrıştırma, kuyruk
/// çipi, ayrıntıdaki gerekçeler ve pano dökümü.
void main() {
  late FakeBackend backend;

  setUp(() {
    backend = FakeBackend()
      ..on(
        'GET',
        'civil-protection/admin/reports',
        (_) => FakeResponse(200, {
          'items': [evidenceReportJson(evidence: suspiciousEvidence())],
          'total': 1,
          'nextCursor': null,
        }),
      )
      ..on(
        'GET',
        'civil-protection/admin/reports/:id',
        (_) => FakeResponse(
          200,
          evidenceReportJson(evidence: suspiciousEvidence()),
          {'ETag': '"v1"'},
        ),
      )
      ..on(
        'GET',
        'civil-protection/admin/summary',
        (_) => const FakeResponse(200, {
          'total': 4,
          'open': 4,
          'byStatus': {'received': 4},
          'openByUrgency': {'high': 4},
          'openByEvidence': {
            'strong': 1,
            'unverified': 1,
            'suspicious': 1,
            'pending': 1,
          },
        }),
      )
      ..on(
        'GET',
        'memories/admin/summary',
        (_) => const FakeResponse(200, {
          'pending': 0,
          'reported': 0,
          'hiddenByReports': 0,
          'rejected': 0,
          'approved': 0,
        }),
      )
      ..on(
        'GET',
        'feedback/admin/summary',
        (_) => const FakeResponse(200, {
          'total': 0,
          'byStatus': <String, int>{},
          'byCategory': <String, int>{},
          'averageRating': null,
          'ratingCount': 0,
        }),
      );
  });

  tearDown(resetDependencies);

  test('kanıt süzgeci ve sırası sunucuya gider, etiket ayrıştırılır', () async {
    await TestDependencies.setUp(transport: (_) => FakeHttpTransport(backend));
    final cubit = getIt<ReportsQueueCubit>(
      param1: const ReportFilter(
        openOnly: true,
        evidence: {EvidenceLevel.suspicious, EvidenceLevel.pending},
        sort: ReportSort.evidence,
      ),
    );
    await cubit.load(cubit.state.filter);

    final query = backend.last('GET', 'civil-protection/admin/reports')!.query;
    expect(query['status'], 'open');
    expect(query['evidence']!.split(',').toSet(), {'suspicious', 'pending'});
    expect(query['sort'], 'evidence');

    final evidence = cubit.state.items.single.evidence!;
    expect(evidence.level, EvidenceLevel.suspicious);
    expect(
      evidence.withEffect(EvidenceEffect.undermines).single.code,
      EvidenceReasonCode.photoCatalogCopy,
    );
    expect(evidence.reasons.last.code, EvidenceReasonCode.unknown);
    expect(evidence.reasons.last.rawCode, 'future.signal');
    await cubit.close();
  });

  test(
    'değerlendirilmemiş rapor (evidence: null) "bekliyor" sayılır',
    () async {
      backend.on(
        'GET',
        'civil-protection/admin/reports/:id',
        (_) => FakeResponse(200, evidenceReportJson(), {'ETag': '"v1"'}),
      );
      await TestDependencies.setUp(
        transport: (_) => FakeHttpTransport(backend),
      );
      final cubit = getIt<ReportDetailCubit>(param1: 'rpt_1');
      await cubit.load();
      expect(cubit.state.value!.evidence, isNull);
      expect(cubit.state.value!.evidenceLevel, EvidenceLevel.pending);
      await cubit.close();
    },
  );

  Future<void> signInAsModerator(WidgetTester tester) async {
    tester.view
      ..physicalSize = const Size(1440, 1400)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    stubStaffSignIn(backend, roles: ['moderator']);
    await TestDependencies.setUp(
      transport: (_) => FakeHttpTransport(backend),
      preferences: {'settings.language_code': 'tr'},
    );
    getIt<AuthBloc>().add(const AuthEvent.started());
    await tester.pumpWidget(const VakifAtlasAdminApp());
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextField, 'Kurumsal e-posta'),
      'moderator@vakifatlas.dev',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Şifre'),
      'doğru-şifre-1234',
    );
    await tester.tap(find.text('Devam et'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextField, 'Doğrulama kodu'),
      '123456',
    );
    await tester.tap(find.text('Doğrula ve giriş yap'));
    await tester.pumpAndSettle();
  }

  Future<void> finish(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(minutes: 3));
  }

  testWidgets('kuyruk ve ayrıntı kanıt etiketini gerekçeleriyle gösterir', (
    tester,
  ) async {
    await signInAsModerator(tester);
    expect(find.text('Açık bildirimler, YZ kanıtına göre'), findsOneWidget);

    getIt<AppRouter>().router.go('/civil-protection/rpt_1');
    await tester.pumpAndSettle();

    // Kuyruk satırı + ayrıntı başlığı.
    expect(find.text('YZ: Şüpheli'), findsNWidgets(2));
    expect(find.text('Yapay zekâ kanıt değerlendirmesi'), findsOneWidget);
    expect(find.text('Zayıflatan'), findsOneWidget);
    expect(
      find.text(
        'Fotoğraf bir katalog görselinin kopyası olabilir (benzerlik 0,97)',
      ),
      findsOneWidget,
    );
    expect(find.text('Konum yerinde: esere 120 m'), findsOneWidget);
    expect(
      find.text(
        'Açıklamada iletişim bilgisi var (iletişim bilgisi); '
        'kişisel veri olabilir',
      ),
      findsOneWidget,
    );
    expect(
      find.text(
        'Açıklama başka bir türe daha yakın: Yapısal hasar (yalnızca öneri)',
      ),
      findsOneWidget,
    );
    expect(find.text('Diğer sinyal: future.signal'), findsOneWidget);
    expect(
      find.bySemanticsLabel(
        RegExp('^Zayıflatan: Fotoğraf bir katalog görselinin kopyası'),
      ),
      findsOneWidget,
    );
    await finish(tester);
  });

  testWidgets('pano dökümü süzgeçli ve kanıta göre sıralı kuyruğa götürür', (
    tester,
  ) async {
    await signInAsModerator(tester);
    await tester.tap(find.bySemanticsLabel(RegExp('^Şüpheli')).first);
    await tester.pumpAndSettle();

    final uri = getIt<AppRouter>().router.state.uri;
    expect(uri.path, '/civil-protection');
    expect(uri.queryParameters, {
      'status': 'open',
      'evidence': 'suspicious',
      'sort': 'evidence',
    });
    final query = backend.last('GET', 'civil-protection/admin/reports')!.query;
    expect(query['evidence'], 'suspicious');
    expect(query['sort'], 'evidence');
    await finish(tester);
  });
}
