import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas_admin/app.dart';
import 'package:vakif_atlas_admin/core/di/injection.dart';
import 'package:vakif_atlas_admin/core/router/app_router.dart';
import 'package:vakif_atlas_admin/features/auth/presentation/bloc/auth_bloc.dart';

import '../../helpers/test_di.dart';
import '../../support/fake_backend.dart';
import '../moderation/moderation_fixtures.dart';

/// Duyarlı düzen: telefon (çekmece + tam sayfa ayrıntı), tablet (simge
/// şeridi, tek sütun) ve masaüstü (yan yana). Taşma (overflow) hataları
/// testi kendiliğinden düşürür.
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
      // Sıkıştıran ara katman (Cloudflare) güçlü ETag'i zayıflatır.
      ..on(
        'GET',
        'memories/admin/memories/:id',
        (_) => FakeResponse(200, memoryJson(), {'ETag': 'W/"v1"'}),
      )
      ..on(
        'POST',
        'memories/admin/memories/:id/decisions',
        (_) => FakeResponse(
          200,
          memoryJson(
            status: 'approved',
            decisions: const ['reject'],
            decidedBy: 'staff',
          ),
          {'ETag': 'W/"v2"'},
        ),
      );
  });

  tearDown(resetDependencies);

  Future<void> signIn(
    WidgetTester tester,
    Size size, {
    List<String> roles = const ['moderator'],
  }) async {
    tester.view
      ..physicalSize = size
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    stubStaffSignIn(backend, roles: roles);
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

  String path() => getIt<AppRouter>().router.state.uri.path;

  testWidgets('telefonda çekmeceden gezinilir, ayrıntı tam sayfa açılır ve '
      'karar verilir', (tester) async {
    await signIn(tester, const Size(390, 844));

    // Kalıcı kenar çubuğu yok; menü düğmesi çekmeceyi açar.
    expect(find.byType(Drawer), findsNothing);
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    expect(find.byType(Drawer), findsOneWidget);
    await tester.tap(find.text('Anı Moderasyonu'));
    await tester.pumpAndSettle();
    expect(find.byType(Drawer), findsNothing);
    expect(path(), '/moderation');

    // Liste → tam sayfa ayrıntı (liste başlığı ve süzgeçler gizlenir).
    await tester.tap(find.text('Rehber berbattı, hiçbir şey anlatmadı.'));
    await tester.pumpAndSettle();
    expect(path(), '/moderation/mem_1');
    expect(find.text('Yapay zekâ değerlendirmesi'), findsOneWidget);
    expect(find.byType(BackButtonIcon), findsOneWidget);
    expect(find.byTooltip('Kapat'), findsNothing);

    // Zayıf ETag güçlü olarak geri gönderilir (aksi hâlde 412).
    // Ayrıntı tembel kurulan bir listedir: düğme kaydırınca oluşur.
    final approve = find.widgetWithText(FilledButton, 'Yayınla');
    await tester.dragUntilVisible(
      approve,
      find.byType(ListView).first,
      const Offset(0, -300),
    );
    await tester.pumpAndSettle();
    await tester.tap(approve);
    await tester.pumpAndSettle();
    final decision = backend.last(
      'POST',
      'memories/admin/memories/mem_1/decisions',
    );
    expect(decision, isNotNull);
    expect(
      decision!.headers['if-match'] ?? decision.headers['If-Match'],
      '"v1"',
    );

    // Geri çubuğu listeye döner.
    await tester.tap(find.byType(BackButtonIcon));
    await tester.pumpAndSettle();
    expect(path(), '/moderation');
    expect(find.byType(BackButtonIcon), findsNothing);
    await finish(tester);
  });

  testWidgets('tablette kalıcı simge şeridi ve tek sütun ayrıntı', (
    tester,
  ) async {
    await signIn(tester, const Size(820, 1180));
    expect(find.byIcon(Icons.menu), findsNothing);

    getIt<AppRouter>().router.go('/moderation/mem_1');
    await tester.pumpAndSettle();
    expect(find.text('Yapay zekâ değerlendirmesi'), findsOneWidget);
    expect(find.byType(BackButtonIcon), findsOneWidget);
    await finish(tester);
  });

  testWidgets('masaüstünün en küçük penceresinde liste ve ayrıntı yan yana', (
    tester,
  ) async {
    await signIn(tester, const Size(1100, 720));
    getIt<AppRouter>().router.go('/moderation/mem_1');
    await tester.pumpAndSettle();
    // Metin hem kuyruk satırında hem ayrıntıda.
    expect(
      find.text('Rehber berbattı, hiçbir şey anlatmadı.'),
      findsNWidgets(2),
    );
    expect(find.byType(BackButtonIcon), findsNothing);
    expect(find.byTooltip('Kapat'), findsOneWidget);
    await finish(tester);
  });

  testWidgets('en dar telefonda (360 px) her bölüm taşmadan çizilir', (
    tester,
  ) async {
    backend
      ..on(
        'GET',
        'catalog/admin/complexes',
        (_) => const FakeResponse(200, <Object>[]),
      )
      ..on(
        'GET',
        'catalog/admin/works',
        (_) => const FakeResponse(200, {
          'items': [
            {
              'key': 'abdal-mehmed-camii',
              'title': {
                'tr': 'Abdal Mehmed Camii ve uzun bir ad',
                'en': 'Abdal Mehmed Mosque',
              },
              'category': 'mosque',
              'period': 'other',
              'city': {'code': 16, 'name': 'Bursa'},
              'district': 'Osmangazi',
              'thumbnailUrl': null,
              'imageCount': 3,
              'hasLocation': false,
              'complex': null,
              'isActive': true,
              'publication': 'published',
              'updatedAt': '2026-10-31T12:56:24Z',
            },
          ],
          'total': 1,
          'nextCursor': null,
        }),
      );
    await signIn(tester, const Size(360, 740), roles: ['vgm_admin']);
    for (final route in [
      '/',
      '/catalog',
      '/catalog/new',
      '/civil-protection',
      '/moderation',
      '/moderation/mem_1',
      '/moderation/metrics',
      '/feedback',
      '/staff',
      '/audit',
      '/profile',
      '/settings',
    ]) {
      getIt<AppRouter>().router.go(route);
      await tester.pumpAndSettle();
      expect(path(), route, reason: route);
      expect(tester.takeException(), isNull, reason: route);
    }
    // Dar katalog tablosu: tür ve il adın altında.
    getIt<AppRouter>().router.go('/catalog');
    await tester.pumpAndSettle();
    expect(find.text('Cami · Bursa · Konum yok'), findsOneWidget);
    await finish(tester);
  });
}
