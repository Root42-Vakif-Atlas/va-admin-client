import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas_admin/core/config/app_config.dart';
import 'package:vakif_atlas_admin/core/network/http_transport.dart';
import 'package:vakif_atlas_admin/core/network/network_constants.dart';

/// Ortam konfigürasyonuna göre yapılandırılmış `Dio` örnekleri üretir.
///
/// Tüm istemciler [HttpTransport] üzerinden `AppConfig.apiBaseUrl`'deki
/// sunucuya bağlanır.
@lazySingleton
class DioFactory {
  DioFactory(this._config, this._transport);

  final AppConfig _config;
  final HttpTransport _transport;

  Dio create({
    Duration connectTimeout = NetworkConstants.connectTimeout,
    Duration receiveTimeout = NetworkConstants.receiveTimeout,
    Duration sendTimeout = NetworkConstants.sendTimeout,
    TransportScope scope = TransportScope.api,
  }) {
    final dio = Dio(
      BaseOptions(
        baseUrl: _config.apiBaseUrl.toString(),
        connectTimeout: connectTimeout,
        sendTimeout: sendTimeout,
        receiveTimeout: receiveTimeout,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
      ),
    );
    dio.httpClientAdapter = _transport.createAdapter(scope: scope);
    return dio;
  }
}
