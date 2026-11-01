import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas_admin/app.dart';
import 'package:vakif_atlas_admin/core/di/injection.dart';
import 'package:vakif_atlas_admin/core/router/app_router.dart';
import 'package:vakif_atlas_admin/features/auth/presentation/bloc/auth_bloc.dart';

import '../../helpers/test_di.dart';
import '../../support/fake_backend.dart';
import 'moderation_fixtures.dart';

/// YZ moderasyonu arayüzü (ADR 58): kuyrukta YZ çipi, ayrıntıda değerlendirme,
/// metrik sayfası.
void main() {
  late FakeBackend backend;

  setUp(() {
    backend = FakeBackend()
      ..on(
        'GET',
        'civil-protection/admin/summary',
        (_) => const FakeResponse(200, {
          'total': 0,
          'open': 0,
          'byStatus': <String, int>{},
          'openByUrgency': <String, int>{},
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
      )
      ..on(
        'GET',
        'memories/admin/summary',
        (_) => const FakeResponse(200, {
          'pending': 1,
          'reported': 0,
          'hiddenByReports': 0,
          'rejected': 2,
          'approved': 10,
          'autoRejected24h': 2,
          'unscored': 0,
        }),
      )
      ..on(
        'GET',
        'memories/admin/memories',
        (_) => FakeResponse(200, {
          'items': [memoryJson()],
          'total': 1,
          'nextCursor': null,
        }),
      )
      ..on(
        'GET',
        'memories/admin/memories/:id',
        (_) => FakeResponse(200, memoryJson(), {'ETag': '"v1"'}),
      )
      ..on(
        'GET',
        'memories/admin/moderation-metrics',
        (_) => FakeResponse(200, metricsJson()),
      );
  });

  tearDown(resetDependencies);

  Future<void> signInAsModerator(WidgetTester tester) async {
    tester.view
      ..physicalSize = const Size(1440, 960)
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

  testWidgets('kuyruk ve ayrıntı YZ önerisini skor ve kategoriyle gösterir', (
    tester,
  ) async {
    await signInAsModerator(tester);
    // Pano: YZ'nin son 24 saatte kaldırdıkları.
    expect(find.bySemanticsLabel("YZ'nin kaldırdıkları (24 sa): 2"), findsOne);

    getIt<AppRouter>().router.go('/moderation/mem_1');
    await tester.pumpAndSettle();
    expect(find.text('YZ: incelenmeli · 0,62 · Hakaret'), findsWidgets);
    expect(find.text('Yapay zekâ değerlendirmesi'), findsOneWidget);
    expect(find.text('Skor inceleme bandında'), findsOneWidget);
    expect(find.text('Hakaret'), findsNWidgets(2));
    await tester.ensureVisible(find.text('Cinsel içerik'));
    await tester.pumpAndSettle();
    expect(find.bySemanticsLabel('Hakaret: 0,55'), findsOneWidget);
    expect(find.text("YZ'nin kaldırdıkları"), findsOneWidget);
    await finish(tester);
  });

  testWidgets('metrik sayfası dağılımı, eşikleri ve doğruluğu gösterir', (
    tester,
  ) async {
    await signInAsModerator(tester);
    getIt<AppRouter>().router.go('/moderation');
    await tester.pumpAndSettle();
    await tester.tap(find.text('YZ metrikleri'));
    await tester.pumpAndSettle();

    expect(getIt<AppRouter>().router.state.uri.path, '/moderation/metrics');
    expect(find.text('YZ moderasyon metrikleri'), findsOneWidget);
    expect(find.textContaining('otomatik yayın < 0,31'), findsOneWidget);
    expect(find.bySemanticsLabel(RegExp('^Otomatik kaldırılan, 8')), findsOne);
    expect(find.text('Geri yüklenen otomatik kaldırma'), findsOneWidget);
    expect(find.text('1 sa 35 dk'), findsOneWidget);
    expect(find.text('180 ms'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel(RegExp('^Otomatik kaldırılan, 8')));
    await tester.pumpAndSettle();
    expect(
      getIt<AppRouter>().router.state.uri.toString(),
      '/moderation?queue=autoRejected',
    );
    expect(
      backend.last('GET', 'memories/admin/memories')!.query['decidedBy'],
      'ai',
    );
    await finish(tester);
  });
}
