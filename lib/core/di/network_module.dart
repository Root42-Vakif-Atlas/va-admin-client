import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:uuid/uuid.dart';
import 'package:vakif_atlas_admin/core/network/dio_factory.dart';
import 'package:vakif_atlas_admin/core/network/http_transport.dart';
import 'package:vakif_atlas_admin/core/network/interceptors/auth_interceptor.dart';
import 'package:vakif_atlas_admin/core/network/interceptors/correlation_interceptor.dart';
import 'package:vakif_atlas_admin/core/network/interceptors/error_interceptor.dart';
import 'package:vakif_atlas_admin/core/network/interceptors/logging_interceptor.dart';
import 'package:vakif_atlas_admin/core/network/interceptors/retry_interceptor.dart';
import 'package:vakif_atlas_admin/core/network/network_constants.dart';
import 'package:vakif_atlas_admin/core/network/network_status.dart';
import 'package:vakif_atlas_admin/core/network/session_events.dart';
import 'package:vakif_atlas_admin/core/observability/app_logger.dart';
import 'package:vakif_atlas_admin/core/observability/telemetry_service.dart';
import 'package:vakif_atlas_admin/core/security/device_integrity_service.dart';
import 'package:vakif_atlas_admin/core/storage/preferences_service.dart';
import 'package:vakif_atlas_admin/core/storage/secure_storage_service.dart';

/// Ağ istemcilerinin kompozisyonu (TRD §4).
///
/// Interceptor sırası: Logging → Correlation → Auth → Error → Retry.
@module
abstract class NetworkModule {
  @lazySingleton
  CorrelationInterceptor correlationInterceptor(
    Uuid uuid,
    PackageInfo packageInfo,
    PreferencesService preferences,
    DeviceIntegrityService deviceIntegrity,
  ) {
    return CorrelationInterceptor(
      uuid: uuid,
      packageInfo: packageInfo,
      languageCode: () => _requestLanguage(preferences.languageCode),
      deviceIntegrity: () => deviceIntegrity.requestHeaderValue,
    );
  }

  @lazySingleton
  @Named(DioNames.api)
  Dio apiDio(
    DioFactory factory,
    AppLogger logger,
    TelemetryService telemetry,
    CorrelationInterceptor correlation,
    SecureStorageService storage,
    AuthTokenRefresher refresher,
    SessionEvents sessionEvents,
    NetworkStatus network,
  ) {
    final dio = factory.create();
    dio.interceptors.addAll([
      LoggingInterceptor(logger),
      correlation,
      AuthInterceptor(
        dio: dio,
        storage: storage,
        refresher: refresher,
        sessionEvents: sessionEvents,
      ),
      ErrorInterceptor(telemetry, network),
      RetryInterceptor(dio: dio),
    ]);
    return dio;
  }

  @lazySingleton
  @Named(DioNames.bare)
  Dio bareDio(
    DioFactory factory,
    AppLogger logger,
    TelemetryService telemetry,
    CorrelationInterceptor correlation,
    NetworkStatus network,
  ) {
    final dio = factory.create();
    dio.interceptors.addAll([
      LoggingInterceptor(logger),
      correlation,
      ErrorInterceptor(telemetry, network),
    ]);
    return dio;
  }

  @lazySingleton
  @Named(DioNames.storage)
  Dio storageDio(
    DioFactory factory,
    AppLogger logger,
    TelemetryService telemetry,
    NetworkStatus network,
  ) {
    // Ön imzalı adresler nesne deposunun alan adına gider; API pin'leri
    // orada eşleşmez (ayrı `STORAGE_SSL_PINS`).
    final dio = factory.create(
      sendTimeout: NetworkConstants.uploadTimeout,
      scope: TransportScope.storage,
    );
    dio.interceptors.addAll([
      LoggingInterceptor(logger),
      ErrorInterceptor(telemetry, network),
    ]);
    return dio;
  }

  @lazySingleton
  @Named(DioNames.probe)
  Dio probeDio(DioFactory factory) => factory.create(
    connectTimeout: NetworkConstants.probeTimeout,
    receiveTimeout: NetworkConstants.probeTimeout,
  );

  static const Set<String> _supportedLanguages = {'tr', 'en'};

  static String _requestLanguage(String? preferred) {
    final candidate =
        preferred ?? PlatformDispatcher.instance.locale.languageCode;
    return _supportedLanguages.contains(candidate) ? candidate : 'tr';
  }
}
