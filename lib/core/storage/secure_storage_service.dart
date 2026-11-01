import 'dart:async';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas_admin/core/error/exceptions.dart';

/// Şifreli anahtar deposu (macOS Keychain / Windows Credential Manager /
/// libsecret).
///
/// Oturumun tüm değerleri (erişim/yenileme anahtarı, personel profili)
/// **tek bir** keychain öğesinde JSON olarak tutulur ve açılışta bir kez
/// okunup bellekte saklanır. macOS'un eski (login) keychain'i her öğe
/// erişiminde uygulamanın imzasını öğenin erişim listesiyle karşılaştırır;
/// imza değişince (her geliştirme derlemesi) erişim başına şifre sorar. Ayrı
/// öğeler ve her istekte okuma bu soruyu açılışta 3, her yenilemede 3 kez
/// tekrarlatıyordu; tek öğe + bellek kopyası ile en çok bir kez sorulur
/// (bkz. `vakif_atlas_admin/CLAUDE.md` A2). Hatalar [CacheException] olarak
/// fırlatılır.
@lazySingleton
class SecureStorageService {
  SecureStorageService(this._storage);

  final FlutterSecureStorage _storage;

  /// Tek keychain öğesi. Eski sürümün ayrı öğeleri (`admin.auth.access_token`
  /// vb.) okunmaz: okumak her biri için yeniden şifre sordurur; oturum en
  /// fazla 12 saat geçerli olduğundan bir kez yeniden giriş yeterlidir.
  static const String sessionKey = 'admin.auth.session.v2';

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  Map<String, String>? _values;
  Future<Map<String, String>>? _loading;

  /// Yazmalar sırayla: eşzamanlı yenileme + profil kaydı birbirini ezmez.
  Future<void> _writes = Future.value();

  Future<String?> getAccessToken() => read(_accessTokenKey);

  Future<String?> getRefreshToken() => read(_refreshTokenKey);

  Future<void> saveAccessToken(String token) =>
      _update((values) => values[_accessTokenKey] = token);

  Future<void> saveRefreshToken(String token) =>
      _update((values) => values[_refreshTokenKey] = token);

  /// İki anahtar tek keychain yazımıyla kaydedilir.
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) => _update((values) {
    values[_accessTokenKey] = accessToken;
    values[_refreshTokenKey] = refreshToken;
  });

  Future<void> deleteTokens() => _update(
    (values) => values
      ..remove(_accessTokenKey)
      ..remove(_refreshTokenKey),
  );

  Future<String?> read(String key) async => (await _load())[key];

  Future<void> write(String key, String value) =>
      _update((values) => values[key] = value);

  Future<void> delete(String key) => _update((values) => values.remove(key));

  /// Oturum kapatma veya güvenlik ihlalinde tüm hassas verileri siler.
  Future<void> clearAll() => _update((values) => values.clear());

  /// İlk erişimde tek okuma; eşzamanlı çağrılar aynı okumayı paylaşır
  /// (açılışta kimlik bloğu ve ağ katmanı birlikte okuyor).
  Future<Map<String, String>> _load() {
    if (_values case final values?) {
      return Future.value(values);
    }
    return _loading ??= () async {
      try {
        final raw = await _storage.read(key: sessionKey);
        final values = raw == null
            ? <String, String>{}
            : (jsonDecode(raw) as Map<String, dynamic>).cast<String, String>();
        return _values = values;
      } on Exception {
        throw const CacheException('secure_storage.read');
      } on TypeError {
        // Bozuk içerik: oturum yok sayılır (yeniden giriş).
        return _values = <String, String>{};
      } finally {
        _loading = null;
      }
    }();
  }

  Future<void> _update(void Function(Map<String, String> values) change) {
    final next = _writes.then((_) async {
      final values = await _load();
      final before = Map.of(values);
      change(values);
      if (_sameEntries(before, values)) {
        return;
      }
      try {
        if (values.isEmpty) {
          await _storage.delete(key: sessionKey);
        } else {
          await _storage.write(key: sessionKey, value: jsonEncode(values));
        }
      } on Exception {
        throw const CacheException('secure_storage.write');
      }
    });
    // Başarısız yazım sonraki yazımları kilitlemez; hata çağırana iletilir.
    _writes = next.catchError((_) {});
    return next;
  }

  static bool _sameEntries(Map<String, String> a, Map<String, String> b) =>
      a.length == b.length && a.entries.every((e) => b[e.key] == e.value);
}
