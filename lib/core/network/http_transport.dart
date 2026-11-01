import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas_admin/core/config/app_config.dart';
import 'package:vakif_atlas_admin/core/network/ssl/platform_http_adapter.dart';

/// `Dio` istemcilerinin ağ taşıma katmanı.
///
/// Uygulama her ortamda gerçek sunucuya (`AppConfig.apiBaseUrl`) bağlanır;
/// testler bu arayüzü bellek içi sahte sunucuyla değiştirir.
abstract interface class HttpTransport {
  HttpClientAdapter createAdapter({TransportScope scope = TransportScope.api});
}

/// Bağlantının hedefi; SSL pin kümesini belirler.
enum TransportScope {
  /// API sunucusu (`API_BASE_URL`): `SSL_PINS`.
  api,

  /// Nesne deposu (ön imzalı yükleme / indirme adresleri):
  /// `STORAGE_SSL_PINS`; boşsa yalnızca sistem güven deposu.
  storage,
}

/// SSL pinning destekli platform adaptörü.
@LazySingleton(as: HttpTransport)
class PlatformHttpTransport implements HttpTransport {
  PlatformHttpTransport(this._config);

  final AppConfig _config;

  @override
  HttpClientAdapter createAdapter({TransportScope scope = TransportScope.api}) {
    final pins = switch (scope) {
      TransportScope.api => _config.sslPinSha256Hashes,
      TransportScope.storage => _config.storageSslPinSha256Hashes,
    };
    return createPlatformHttpAdapter(
      enablePinning: _config.enableSslPinning && pins.isNotEmpty,
      pins: pins,
    );
  }
}
