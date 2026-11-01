import 'package:flutter/foundation.dart';
import 'package:vakif_atlas_admin/core/config/app_environment.dart';

/// Ortam bazlı çalışma zamanı konfigürasyonu.
///
/// Değerler önce `--dart-define-from-file=config/<env>.json` ile verilen
/// tanımlardan, yoksa ortam varsayılanlarından okunur. Uygulama her ortamda
/// gerçek backend'e (`API_BASE_URL`, vatandaş uygulamasıyla aynı gateway)
/// bağlanır; yerel geliştirmede `config/dev.json` → `backend/deploy/compose`.
/// Masaüstünde flavor yoktur; ortam entrypoint'le (`main_<env>.dart`) seçilir.
@immutable
final class AppConfig {
  const AppConfig._({
    required this.environment,
    required this.apiBaseUrl,
    required this.enableSslPinning,
    required this.sslPinSha256Hashes,
    required this.storageSslPinSha256Hashes,
  });

  /// [environment] için konfigürasyonu çözer ve doğrular.
  ///
  /// Geçersiz bir konfigürasyonda uygulama açılışta
  /// [InvalidAppConfigError] ile durdurulur (fail-fast).
  factory AppConfig.resolve(
    AppEnvironment environment, {
    AppConfigOverrides? overrides,
  }) {
    final values = overrides ?? AppConfigOverrides.fromDartDefines();
    final enableSslPinning = environment != AppEnvironment.dev;
    final sslPins = values.sslPinSha256Hashes ?? const <String>[];
    final storagePins = values.storageSslPinSha256Hashes ?? const <String>[];
    final isProd = environment == AppEnvironment.prod;

    final rawBaseUrl = values.apiBaseUrl;
    if (rawBaseUrl == null) {
      throw InvalidAppConfigError(
        'API_BASE_URL tanımlı değil. '
        'config/${environment.name}.json dosyasında belirtin.',
      );
    }

    if (enableSslPinning && sslPins.isEmpty) {
      throw InvalidAppConfigError(
        '${environment.name} ortamında SSL pinning zorunludur. '
        'config/${environment.name}.json dosyasında SSL_PINS belirtin.',
      );
    }

    // Sertifika yenilenirken uygulama kilitlenmesin: prod'da etkin pin'e ek
    // en az bir yedek pin zorunludur.
    if (isProd && sslPins.length < 2) {
      throw InvalidAppConfigError(
        'prod ortamında SSL_PINS en az iki özet içermelidir (etkin + yedek).',
      );
    }
    if (isProd && storagePins.length == 1) {
      throw InvalidAppConfigError(
        'STORAGE_SSL_PINS verildiyse en az iki özet içermelidir '
        '(etkin + yedek).',
      );
    }

    return AppConfig._(
      environment: environment,
      apiBaseUrl: _parseBaseUrl(rawBaseUrl, environment),
      enableSslPinning: enableSslPinning,
      sslPinSha256Hashes: List.unmodifiable(sslPins),
      storageSslPinSha256Hashes: List.unmodifiable(storagePins),
    );
  }

  final AppEnvironment environment;

  /// Tüm API isteklerinin göreli olarak çözüldüğü kök adres (`/` ile biter).
  final Uri apiBaseUrl;

  final bool enableSslPinning;

  /// Sunucu açık anahtarlarının (SPKI) Base64 kodlu SHA-256 özetleri.
  final List<String> sslPinSha256Hashes;

  /// Nesne deposu (ön imzalı yükleme adresleri) için SPKI özetleri. Boşsa
  /// depo bağlantısında pinning yapılmaz (sistem güven deposu + TLS).
  final List<String> storageSslPinSha256Hashes;

  static Uri _parseBaseUrl(String raw, AppEnvironment environment) {
    final uri = Uri.tryParse(raw);
    final isHttps = uri?.scheme == 'https';
    final isHttp = uri?.scheme == 'http';
    if (uri == null || uri.host.isEmpty || !(isHttps || isHttp)) {
      throw InvalidAppConfigError('API_BASE_URL geçerli bir adres değil: $raw');
    }
    if (isHttp && environment != AppEnvironment.dev) {
      throw InvalidAppConfigError(
        '${environment.name} ortamında API_BASE_URL https olmalıdır: $raw',
      );
    }
    return uri.path.endsWith('/') ? uri : uri.replace(path: '${uri.path}/');
  }
}

/// Derleme zamanında `--dart-define` ile verilen konfigürasyon değerleri.
///
/// `null` olan alanlar için [AppConfig.resolve] ortam varsayılanını kullanır.
@immutable
final class AppConfigOverrides {
  const AppConfigOverrides({
    this.apiBaseUrl,
    this.sslPinSha256Hashes,
    this.storageSslPinSha256Hashes,
  });

  factory AppConfigOverrides.fromDartDefines() {
    const apiBaseUrl = String.fromEnvironment(apiBaseUrlKey);
    const sslPins = String.fromEnvironment(sslPinsKey);
    const storagePins = String.fromEnvironment(storageSslPinsKey);

    return AppConfigOverrides(
      apiBaseUrl: apiBaseUrl.isEmpty ? null : apiBaseUrl,
      sslPinSha256Hashes: sslPins.isEmpty ? null : parseSslPins(sslPins),
      storageSslPinSha256Hashes: storagePins.isEmpty
          ? null
          : parseSslPins(storagePins),
    );
  }

  static const String apiBaseUrlKey = 'API_BASE_URL';
  static const String sslPinsKey = 'SSL_PINS';
  static const String storageSslPinsKey = 'STORAGE_SSL_PINS';

  static final RegExp _sha256Base64 = RegExp(r'^[A-Za-z0-9+/]{43}=$');

  final String? apiBaseUrl;
  final List<String>? sslPinSha256Hashes;
  final List<String>? storageSslPinSha256Hashes;

  /// Virgülle ayrılmış Base64 SHA-256 özetlerini ayrıştırır.
  ///
  /// Yedek pin (sertifika yenileme için) en az ikinci değer olarak verilmelidir.
  static List<String> parseSslPins(String raw) {
    final pins = raw
        .split(',')
        .map((pin) => pin.trim())
        .where((pin) => pin.isNotEmpty)
        .toList(growable: false);
    for (final pin in pins) {
      if (!_sha256Base64.hasMatch(pin)) {
        throw InvalidAppConfigError(
          'SSL_PINS içinde geçersiz SHA-256 Base64 özeti: $pin',
        );
      }
    }
    return pins;
  }
}

/// Geliştirici hatası: ortam konfigürasyonu eksik veya tutarsız.
///
/// Yakalanması amaçlanmaz; uygulamanın yanlış konfigürasyonla
/// açılmasını engeller.
final class InvalidAppConfigError extends Error {
  InvalidAppConfigError(this.message);

  final String message;

  @override
  String toString() => 'InvalidAppConfigError: $message';
}
