import 'dart:async';

import 'package:dio/dio.dart';
import 'package:vakif_atlas_admin/core/error/error_mapper.dart';
import 'package:vakif_atlas_admin/core/error/exceptions.dart';
import 'package:vakif_atlas_admin/core/network/network_status.dart';
import 'package:vakif_atlas_admin/core/observability/telemetry_service.dart';

/// HTTP hatalarını uygulama içi [AppException] tiplerine dönüştürür ve
/// beklenmeyen hataları telemetriye bildirir (TRD §4.4).
///
/// Dönüştürülmüş istisna `DioException.error` alanında taşınır; Data
/// katmanı `ErrorMapper.toFailure` ile `Failure` tipine çevirir.
///
/// Bağlantı hataları cihazın ağ durumuna göre ayrılır: cihaz çevrimdışıysa
/// (veya ad çözümlenemiyorsa) "internet yok", değilse "sunucuya
/// ulaşılamıyor".
class ErrorInterceptor extends Interceptor {
  ErrorInterceptor(this._telemetry, this._network);

  final TelemetryService _telemetry;
  final NetworkStatus _network;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // İç içe tekrar denemelerde (auth/retry) hata zaten dönüştürülmüş ve
    // raporlanmış olabilir; aynı hata ikinci kez raporlanmaz.
    final alreadyMapped = err.error is AppException;
    final mapped = ErrorMapper.exceptionFromDio(err);
    final exception = alreadyMapped ? mapped : await _classify(err, mapped);

    if (!alreadyMapped && _shouldReport(exception)) {
      unawaited(
        _telemetry.recordError(
          exception,
          err.stackTrace,
          reason:
              '${err.requestOptions.method} ${err.requestOptions.uri.path} '
              '→ ${err.response?.statusCode ?? err.type.name}',
        ),
      );
    }

    handler.next(err.copyWith(error: exception));
  }

  Future<AppException> _classify(
    DioException err,
    AppException exception,
  ) async {
    if (exception is! NetworkException) {
      return exception;
    }
    // Ad çözümlenemiyorsa arayüz açık olsa da internet yoktur (Wi-Fi'ye
    // bağlı ama çıkışı olmayan ağ).
    final unresolvable = err.error.toString().contains('Failed host lookup');
    if (unresolvable || !await _network.refresh()) {
      return const NetworkException(NetworkExceptionType.offline);
    }
    return exception;
  }

  /// Kullanıcı kaynaklı (4xx) ve bağlantı hataları raporlanmaz; sunucu,
  /// güvenlik ve sınıflandırılamayan hatalar raporlanır.
  static bool _shouldReport(AppException exception) {
    return switch (exception) {
      ServerException(:final statusCode) => statusCode >= 500,
      SecurityException() => true,
      UnexpectedException() => true,
      NetworkException() ||
      CacheException() ||
      RequestCancelledException() => false,
    };
  }
}
