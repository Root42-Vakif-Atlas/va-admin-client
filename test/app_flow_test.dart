import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas_admin/app.dart';
import 'package:vakif_atlas_admin/core/di/injection.dart';
import 'package:vakif_atlas_admin/core/router/app_router.dart';
import 'package:vakif_atlas_admin/core/session/idle_timer.dart';
import 'package:vakif_atlas_admin/features/auth/presentation/bloc/auth_bloc.dart';

import 'helpers/test_di.dart';
import 'support/fake_backend.dart';

void main() {
  late FakeBackend backend;

  setUp(() {
    backend = FakeBackend()
      ..on(
        'GET',
        'memories/admin/summary',
        (_) => const FakeResponse(200, {
          'pending': 2,
          'reported': 1,
          'hiddenByReports': 0,
          'rejected': 0,
          'approved': 10,
        }),
      )
      ..on(
        'GET',
        'civil-protection/admin/summary',
        (_) => const FakeResponse(200, {
          'total': 3,
          'open': 3,
          'byStatus': {'received': 3},
          'openByUrgency': {'critical': 1},
        }),
      )
      ..on(
        'GET',
        'feedback/admin/summary',
        (_) => const FakeResponse(200, {
          'total': 1,
          'byStatus': {'new': 1},
          'byCategory': {'bug': 1},
          'averageRating': 4.0,
          'ratingCount': 1,
        }),
      )
      ..on(
        'GET',
        'catalog/admin/summary',
        (_) => const FakeResponse(200, {
          'total': 21,
          'published': 20,
          'archived': 1,
          'byCategory': {'mosque': 8},
          'withoutImages': 0,
          'version': '2026-10-22.1',
        }),
      );
  });

  tearDown(resetDependencies);

  Future<void> start(WidgetTester tester, {required List<String> roles}) async {
    tester.view
      ..physicalSize = const Size(1440, 960)
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
  }

  Future<void> signIn(WidgetTester tester) async {
    await tester.enterText(
      find.widgetWithText(TextField, 'Kurumsal e-posta'),
      'vgm@vakifatlas.dev',
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

  testWidgets('şifre + kod ile panoya girilir; yönetici tüm bölümleri görür', (
    tester,
  ) async {
    await start(tester, roles: ['vgm_admin']);
    expect(find.text('Personel girişi'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextField, 'Kurumsal e-posta'),
      'vgm@vakifatlas.dev',
    );
    await tester.enterText(find.widgetWithText(TextField, 'Şifre'), 'yanlış');
    await tester.tap(find.text('Devam et'));
    await tester.pumpAndSettle();
    expect(
      find.textContaining('E-posta adresi veya şifre hatalı'),
      findsOneWidget,
    );

    await signIn(tester);
    expect(getIt<AppRouter>().router.state.uri.path, '/');
    expect(find.text('Hoş geldiniz, Akın Bezatoğlu'), findsOneWidget);
    for (final section in [
      'Katalog',
      'Sivil Koruma',
      'Anı Moderasyonu',
      'Geri Bildirim',
      'Personel',
      'Denetim Kaydı',
    ]) {
      expect(find.text(section), findsWidgets, reason: section);
    }
    // Kenar çubuğu rozeti: işlem bekleyen anı (2 + 1).
    expect(
      find.bySemanticsLabel('Anı Moderasyonu, 3 bekleyen'),
      findsOneWidget,
    );
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(minutes: 3));
  });

  testWidgets(
    'moderatör yalnızca kendi bölümünü görür ve yetkisiz rotaya giremez',
    (tester) async {
      await start(tester, roles: ['moderator']);
      await signIn(tester);
      expect(find.text('Anı Moderasyonu'), findsWidgets);
      expect(find.text('Katalog'), findsNothing);
      expect(find.text('Personel'), findsNothing);
      expect(
        backend.requests.where((r) => r.path == 'catalog/admin/summary'),
        isEmpty,
        reason: 'Yetkisiz bölümün özeti istenmez',
      );

      getIt<AppRouter>().router.go('/staff');
      await tester.pumpAndSettle();
      expect(getIt<AppRouter>().router.state.uri.path, '/');
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(minutes: 3));
    },
  );

  testWidgets(
    'hareketi azalt açılıp kapatılabilir; yalnızca cihaz ayarı kilitler',
    (tester) async {
      await start(tester, roles: ['editor']);
      await signIn(tester);
      getIt<AppRouter>().router.go('/settings');
      await tester.pumpAndSettle();
      final tile = find.widgetWithText(SwitchListTile, 'Hareketi azalt');
      await tester.ensureVisible(tile);
      SwitchListTile current() => tester.widget<SwitchListTile>(tile);

      // Uygulama ayarı açılınca anahtar kendini kilitlememeli (eski hata).
      await tester.tap(tile);
      await tester.pumpAndSettle();
      expect(current().value, isTrue);
      expect(current().onChanged, isNotNull);
      await tester.tap(tile);
      await tester.pumpAndSettle();
      expect(current().value, isFalse);

      // Cihazda açıksa kilitli açık ve nedeni yazılır.
      tester.platformDispatcher.accessibilityFeaturesTestValue =
          const FakeAccessibilityFeatures(disableAnimations: true);
      addTearDown(
        tester.platformDispatcher.clearAccessibilityFeaturesTestValue,
      );
      await tester.pumpAndSettle();
      expect(current().value, isTrue);
      expect(current().onChanged, isNull);
      expect(find.textContaining('sistem ayarlarını kullanın'), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(minutes: 3));
    },
  );

  testWidgets('24 saat hareketsizlikte oturum kapanır ve neden bildirilir', (
    tester,
  ) async {
    await start(tester, roles: ['editor']);
    await signIn(tester);
    await tester.pump(IdleTimer.defaultTimeout + const Duration(seconds: 1));
    await tester.pumpAndSettle();
    expect(getIt<AppRouter>().router.state.uri.path, '/sign-in');
    expect(
      find.textContaining('24 saat işlem yapılmadığı için'),
      findsOneWidget,
    );
    expect(backend.last('POST', 'auth/logout'), isNotNull);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(minutes: 3));
  });
}
