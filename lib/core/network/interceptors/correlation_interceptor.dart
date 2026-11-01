import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:uuid/uuid.dart';
import 'package:vakif_atlas_admin/core/network/network_constants.dart';

/// Uçtan uca izlenebilirlik için her isteğe başlık ekler (TRD §4.2).
///
/// - `X-Correlation-Id`: istek başına benzersiz UUID (tekrar denemelerde
///   korunur).
/// - `Accept-Language`: aktif uygulama dili (istek açıkça bir dil
///   belirtmişse o korunur).
/// - `X-App-Version`, `X-Platform`: istemci sürümü ve platformu.
/// - `X-Device-Integrity`: cihaz bütünlüğü durumu (bilindiğinde).
class CorrelationInterceptor extends Interceptor {
  CorrelationInterceptor({
    required this._uuid,
    required PackageInfo packageInfo,
    required this._languageCode,
    this._deviceIntegrity,
  }) : _appVersion = '${packageInfo.version}+${packageInfo.buildNumber}';

  final Uuid _uuid;
  final String _appVersion;
  final String Function() _languageCode;
  final String? Function()? _deviceIntegrity;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final headers = options.headers
      ..putIfAbsent(NetworkConstants.correlationIdHeader, _uuid.v4)
      ..[Headers.acceptHeader] = Headers.jsonContentType
      ..putIfAbsent(NetworkConstants.acceptLanguageHeader, _languageCode)
      ..[NetworkConstants.appVersionHeader] = _appVersion
      ..[NetworkConstants.platformHeader] = defaultTargetPlatform.name;

    final integrity = _deviceIntegrity?.call();
    if (integrity != null) {
      headers[NetworkConstants.deviceIntegrityHeader] = integrity;
    }
    handler.next(options);
  }
}
