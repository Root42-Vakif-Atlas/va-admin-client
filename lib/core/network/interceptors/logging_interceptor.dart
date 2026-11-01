import 'package:dio/dio.dart';
import 'package:vakif_atlas_admin/core/network/network_constants.dart';
import 'package:vakif_atlas_admin/core/observability/app_logger.dart';
import 'package:vakif_atlas_admin/core/observability/pii_scrubber.dart';

/// İstek ve yanıtları yapılandırılmış biçimde loglar (TRD §4.1).
///
/// Çıktı seviyesi ortama göre `AppLogger` tarafından belirlenir (prod'da
/// kapalı). Gövde, sorgu parametreleri ve başlıklar PII temizlenerek yazılır;
/// yanıt gövdeleri boyut ve gizlilik nedeniyle loglanmaz.
class LoggingInterceptor extends Interceptor {
  LoggingInterceptor(this._logger);

  final AppLogger _logger;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra[RequestExtras.startedAt] = DateTime.now();
    _logger.debug(
      '→ ${options.method} ${options.uri.path}',
      context: {
        'query': options.queryParameters,
        'headers': options.headers,
        'body': options.data is Map ? options.data : null,
      },
    );
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    _logger.debug(
      '← ${response.statusCode} ${response.requestOptions.method} '
      '${response.requestOptions.uri.path}',
      context: {'durationMs': _elapsed(response.requestOptions)},
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logger.warning(
      '✕ ${err.response?.statusCode ?? err.type.name} '
      '${err.requestOptions.method} ${err.requestOptions.uri.path}',
      context: {
        'durationMs': _elapsed(err.requestOptions),
        'error': PiiScrubber.scrubText('${err.error ?? err.message}'),
      },
    );
    handler.next(err);
  }

  static int? _elapsed(RequestOptions options) {
    final startedAt = options.extra[RequestExtras.startedAt];
    return startedAt is DateTime
        ? DateTime.now().difference(startedAt).inMilliseconds
        : null;
  }
}
