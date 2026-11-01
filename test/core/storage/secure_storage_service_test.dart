import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vakif_atlas_admin/core/error/exceptions.dart';
import 'package:vakif_atlas_admin/core/storage/secure_storage_service.dart';

import '../../helpers/test_di.dart';

/// macOS eski keychain'i imzası değişen uygulamaya her öğe erişiminde şifre
/// sorar; oturum tek öğede tutulur ve bir kez okunur.
void main() {
  late InMemorySecureStorage keychain;
  late SecureStorageService storage;

  setUp(() {
    keychain = InMemorySecureStorage();
    storage = SecureStorageService(keychain);
  });

  test('oturumun tüm değerleri tek öğeye tek yazımla kaydedilir', () async {
    await storage.saveTokens(accessToken: 'a1', refreshToken: 'r1');
    await storage.write('admin.auth.session_user', '{"id":"usr"}');

    expect(keychain.values.keys, [SecureStorageService.sessionKey]);
    expect(jsonDecode(keychain.values[SecureStorageService.sessionKey]!), {
      'access_token': 'a1',
      'refresh_token': 'r1',
      'admin.auth.session_user': '{"id":"usr"}',
    });
    verify(
      () => keychain.write(
        key: SecureStorageService.sessionKey,
        value: any(named: 'value'),
      ),
    ).called(2);
  });

  test(
    'eşzamanlı okumalar keychain\'e tek kez gider, sonrası bellekten',
    () async {
      keychain.values[SecureStorageService.sessionKey] = jsonEncode({
        'access_token': 'a1',
        'refresh_token': 'r1',
      });
      final fresh = SecureStorageService(keychain);

      final results = await Future.wait([
        fresh.getAccessToken(),
        fresh.getRefreshToken(),
        fresh.read('admin.auth.session_user'),
      ]);
      await fresh.getAccessToken();

      expect(results, ['a1', 'r1', null]);
      verify(() => keychain.read(key: SecureStorageService.sessionKey))
          .called(1);
    },
  );

  test('değişmeyen değer yazılmaz; oturum silinince öğe kaldırılır', () async {
    await storage.saveTokens(accessToken: 'a1', refreshToken: 'r1');
    await storage.saveTokens(accessToken: 'a1', refreshToken: 'r1');
    verify(
      () => keychain.write(
        key: SecureStorageService.sessionKey,
        value: any(named: 'value'),
      ),
    ).called(1);

    await storage.deleteTokens();
    expect(keychain.values, isEmpty);
    expect(await storage.getRefreshToken(), isNull);
  });

  test('eski sürümün ayrı öğeleri okunmaz (her biri şifre sorardı)', () async {
    keychain.values['admin.auth.access_token'] = 'legacy';
    expect(await storage.getAccessToken(), isNull);
    verifyNever(() => keychain.read(key: 'admin.auth.access_token'));
  });

  test('bozuk içerik oturumsuz sayılır', () async {
    keychain.values[SecureStorageService.sessionKey] = '[1, 2]';
    expect(await SecureStorageService(keychain).getAccessToken(), isNull);
  });

  test(
    'keychain hatası CacheException olur ve sonraki yazımı kilitlemez',
    () async {
      var calls = 0;
      when(
        () => keychain.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenAnswer((invocation) async {
        if (calls++ == 0) {
          throw Exception('User canceled'); // keychain şifre penceresi iptal
        }
        keychain.values[invocation.namedArguments[#key] as String] =
            invocation.namedArguments[#value] as String;
      });
      final failing = SecureStorageService(keychain);
      await expectLater(
        failing.saveAccessToken('a1'),
        throwsA(isA<CacheException>()),
      );
      await failing.saveAccessToken('a2');
      expect(await failing.getAccessToken(), 'a2');
    },
  );
}
