// Uygulamanın kendisini (DI + ekranlar) çalışan backend'e karşı uçtan uca
// dener ve her bölümün ekran görüntüsünü yazar. Compose yığını açık olmalı:
//   flutter test tool/backend_app_e2e_test.dart
//   --dart-define=SHOTS=<klasör> (varsayılan: build/e2e_shots)
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas_admin/app.dart';
import 'package:vakif_atlas_admin/core/di/injection.dart';
import 'package:vakif_atlas_admin/core/network/http_transport.dart';
import 'package:vakif_atlas_admin/core/router/app_router.dart';
import 'package:vakif_atlas_admin/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vakif_atlas_admin/core/storage/secure_storage_service.dart';
import 'package:vakif_atlas_admin/shared/widgets/molecules/search_field.dart';

import '../test/helpers/test_di.dart';

const String _api = String.fromEnvironment(
  'API',
  defaultValue: 'http://localhost:8080/v1/',
);
const String _shots = String.fromEnvironment(
  'SHOTS',
  defaultValue: 'build/e2e_shots',
);
const String _totpSecret = 'JBSWY3DPEHPK3PXPJBSWY3DPEHPK3PXP';

/// RFC 6238 (HMAC-SHA1, 6 hane, 30 sn) — seed personelinin güncel kodu.
String totp(String secret, DateTime now) {
  const alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';
  var buffer = 0;
  var bits = 0;
  final key = <int>[];
  for (final char in secret.split('')) {
    buffer = (buffer << 5) | alphabet.indexOf(char);
    bits += 5;
    if (bits >= 8) {
      key.add((buffer >> (bits - 8)) & 0xff);
      bits -= 8;
    }
  }
  final counter = now.millisecondsSinceEpoch ~/ 1000 ~/ 30;
  final message = ByteData(8)..setInt64(0, counter);
  final hash = Hmac(sha1, key).convert(message.buffer.asUint8List()).bytes;
  final offset = hash.last & 0x0f;
  final code =
      ((hash[offset] & 0x7f) << 24) |
      (hash[offset + 1] << 16) |
      (hash[offset + 2] << 8) |
      hash[offset + 3];
  return (code % 1000000).toString().padLeft(6, '0');
}

Future<void> _loadFonts() async {
  Future<void> load(String family, String path) async {
    final loader = FontLoader(family)
      ..addFont(
        Future.value(ByteData.sublistView(File(path).readAsBytesSync())),
      );
    await loader.load();
  }

  await load('Inter', 'assets/fonts/inter/Inter-Variable.ttf');
  final flutterRoot =
      Platform.environment['FLUTTER_ROOT'] ??
      File(Platform.resolvedExecutable)
          .parent
          .parent
          .parent
          .parent
          .parent
          .parent
          .path;
  await load(
    'MaterialIcons',
    '$flutterRoot/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf',
  );
}

void main() {
  tearDown(resetDependencies);

  Future<void> settle(WidgetTester tester, [int rounds = 15]) async {
    for (var i = 0; i < rounds; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 100)),
      );
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  Future<void> shot(WidgetTester tester, String name) async {
    await tester.runAsync(() async {
      final layer = tester.binding.renderViews.first.debugLayer! as OffsetLayer;
      final image = await layer.toImage(Offset.zero & tester.view.physicalSize);
      final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      final file = File('$_shots/$name.png')..createSync(recursive: true);
      file.writeAsBytesSync(bytes!.buffer.asUint8List());
    });
  }

  testWidgets('yönetim paneli backend ile uçtan uca çalışır', (tester) async {
    // flutter_test her testte HTTP'yi engeller; bu araç gerçek sunucuya bağlanır.
    HttpOverrides.global = null;
    tester.view
      ..physicalSize = const Size(1440, 960)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.runAsync(_loadFonts);

    await TestDependencies.setUp(
      appConfig: TestDependencies.config(apiBaseUrl: _api),
      transport: PlatformHttpTransport.new,
      preferences: {'settings.language_code': 'tr'},
    );
    getIt<AuthBloc>().add(const AuthEvent.started());
    await tester.pumpWidget(const VakifAtlasAdminApp());
    await settle(tester);
    final router = getIt<AppRouter>().router;
    expect(router.state.uri.path, '/sign-in');
    await shot(tester, '01_sign_in');

    await tester.enterText(
      find.widgetWithText(TextField, 'Kurumsal e-posta'),
      'vgm@vakifatlas.dev',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Şifre'),
      'VgmPersonel2026!',
    );
    await tester.tap(find.text('Devam et'));
    await settle(tester, 20);
    expect(find.text('İki adımlı doğrulama'), findsWidgets);
    await shot(tester, '02_mfa');

    await tester.enterText(
      find.byType(TextField).first,
      totp(_totpSecret, DateTime.now()),
    );
    await tester.tap(find.text('Doğrula ve giriş yap'));
    await settle(tester, 25);
    expect(router.state.uri.path, '/', reason: 'MFA sonrası panoya geçilir');
    await shot(tester, '03_dashboard');

    // Canlı API'den ilk kayıt (liste `{items}` veya dizi).
    Future<Map<String, dynamic>?> first(String path) async {
      final client = HttpClient();
      final request = await client.getUrl(Uri.parse('$_api$path'));
      final token = await getIt<SecureStorageService>().getAccessToken();
      request.headers.set('Authorization', 'Bearer $token');
      final response = await request.close();
      final json = jsonDecode(await response.transform(utf8.decoder).join());
      final items = json is List
          ? json
          : (json as Map<String, dynamic>)['items'] as List<dynamic>;
      return items.isEmpty ? null : items.first as Map<String, dynamic>;
    }

    Future<Map<String, dynamic>> record(String path) async {
      final client = HttpClient();
      final request = await client.getUrl(Uri.parse('$_api$path'));
      final token = await getIt<SecureStorageService>().getAccessToken();
      request.headers.set('Authorization', 'Bearer $token');
      final response = await request.close();
      return jsonDecode(await response.transform(utf8.decoder).join())
          as Map<String, dynamic>;
    }

    final work = (await tester.runAsync(() => first('catalog/admin/works')))!;
    final complex = await tester.runAsync(
      () => first('catalog/admin/complexes'),
    );

    for (final (name, path) in [
      ('04_reports', '/civil-protection?status=open&sort=urgency'),
      ('06_moderation', '/moderation?queue=all'),
      ('08_feedback', '/feedback'),
      ('10_catalog', '/catalog'),
      ('11_catalog_editor', '/catalog/${work['key']}'),
      ('12_staff', '/staff'),
      ('13_audit', '/audit'),
      ('14_profile', '/profile'),
      ('15_settings', '/settings'),
    ]) {
      router.go(path);
      await settle(tester, 20);
      await shot(tester, name);
      expect(tester.takeException(), isNull, reason: path);
    }

    // Külliye ayrı kayıttır: yapının düzenleyicisinden açılır, yapılar
    // külliyenin sekmesinden listeden seçilir.
    if (complex != null) {
      final complexKey = complex['key'] as String;
      final detail = await tester.runAsync(
        () => record('catalog/admin/complexes/$complexKey'),
      );
      final first0 =
          (detail!['works'] as List<dynamic>).first as Map<String, dynamic>;
      final member = first0['key'] as String;
      router.go('/catalog/$member');
      await settle(tester, 20);
      await shot(tester, '16_member_editor');
      await tester.tap(find.text('Külliyeyi aç'));
      await settle(tester, 20);
      expect(router.state.uri.path, '/catalog/$complexKey');
      await tester.tap(find.text('Külliye yapıları'));
      await settle(tester);
      await tester.tap(find.text('Yapı ekle'));
      await settle(tester, 20);
      // Katalog büyük: bağlı yapı aranarak bulunur.
      await tester.enterText(
        find.descendant(
          of: find.byType(SearchField),
          matching: find.byType(TextField),
        ),
        first0['title'] as String? ?? member,
      );
      await settle(tester, 20);
      expect(find.text('Bu külliyede zaten var'), findsWidgets);
      await shot(tester, '17_members_picker');
      await tester.tap(find.text('Vazgeç'));
      await settle(tester);
    }

    // Ayrıntı panelleri: kuyruğun ilk kaydı.
    Future<String?> firstId(String path) async =>
        (await first(path))?['id'] as String?;

    for (final (name, list, route) in [
      (
        '05_report_detail',
        'civil-protection/admin/reports?status=open',
        '/civil-protection/',
      ),
      ('07_memory_detail', 'memories/admin/memories', '/moderation/'),
      ('09_feedback_detail', 'feedback/admin', '/feedback/'),
    ]) {
      final id = await tester.runAsync(() => firstId(list));
      if (id == null) {
        continue;
      }
      router.go('$route$id');
      await settle(tester, 20);
      await shot(tester, name);
      expect(tester.takeException(), isNull, reason: route);
    }

    getIt<AuthBloc>().add(const AuthEvent.logoutRequested());
    await settle(tester);
    expect(router.state.uri.path, '/sign-in');
    await tester.pumpWidget(const SizedBox.shrink());
    // Seyreltme / yenileme zamanlayıcıları boşaltılır.
    await tester.pump(const Duration(minutes: 3));
  });
}
