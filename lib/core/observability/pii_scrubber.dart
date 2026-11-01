/// Loglara ve telemetriye gidecek verilerden kişisel/hassas bilgileri
/// temizler (TRD §11 — PII Scrubbing).
///
/// Şifre, kimlik numarası, JWT/erişim anahtarı, e-posta ve açık konum
/// bilgisi asla dışarı yazılmaz.
abstract final class PiiScrubber {
  static const String mask = '***';

  static const Set<String> _sensitiveKeys = {
    'password',
    'newpassword',
    'currentpassword',
    'confirmpassword',
    'code',
    'otp',
    'verificationcode',
    'displayname',
    'token',
    'accesstoken',
    'refreshtoken',
    'idtoken',
    'authorization',
    'cookie',
    'set-cookie',
    'tckn',
    'identitynumber',
    'nationalid',
    'email',
    'phone',
    'phonenumber',
    'latitude',
    'longitude',
    'lat',
    'lng',
    'lon',
    'location',
    'coordinates',
  };

  static final RegExp _jwt = RegExp(
    r'eyJ[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+',
  );
  static final RegExp _bearer = RegExp(r'Bearer\s+\S+', caseSensitive: false);
  static final RegExp _email = RegExp(
    r'[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}',
  );

  /// [value] içindeki hassas alanları özyinelemeli olarak maskeler.
  static Object? scrub(Object? value) {
    return switch (value) {
      final Map<Object?, Object?> map => {
        for (final MapEntry(:key, value: entry) in map.entries)
          key: isSensitiveKey(key) ? mask : scrub(entry),
      },
      final Iterable<Object?> list => [for (final item in list) scrub(item)],
      final String text => scrubText(text),
      _ => value,
    };
  }

  /// Serbest metindeki JWT, Bearer anahtarı ve e-posta adreslerini maskeler.
  static String scrubText(String text) {
    return text
        .replaceAll(_bearer, 'Bearer $mask')
        .replaceAll(_jwt, mask)
        .replaceAll(_email, mask);
  }

  static bool isSensitiveKey(Object? key) {
    if (key is! String) {
      return false;
    }
    final normalized = key.toLowerCase().replaceAll('_', '');
    return _sensitiveKeys.contains(normalized);
  }
}
