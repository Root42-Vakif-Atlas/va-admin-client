import 'dart:math' as math;

import 'package:dio/dio.dart';
import 'package:vakif_atlas_admin/core/network/network_constants.dart';

/// Geçici hatalarda idempotent istekleri üstel bekleme (exponential backoff)
/// ile tekrarlar (TRD §4.5).
///
/// Yalnızca `GET`, `HEAD`, `OPTIONS` istekleri; bağlantı kopması, zaman
/// aşımı ve `5xx` yanıtlarında tekrarlanır. Bekleme süresi
/// `baseDelay × 2^deneme + jitter` formülüyle hesaplanır.
class RetryInterceptor extends Interceptor {
  RetryInterceptor({
    required this._dio,
    this.maxRetries = 3,
    this.baseDelay = const Duration(milliseconds: 500),
    this.maxJitter = const Duration(milliseconds: 250),
    math.Random? random,
    Future<void> Function(Duration delay)? wait,
  }) : _random = random ?? math.Random(),
       _wait = wait ?? _defaultWait;

  final Dio _dio;
  final int maxRetries;
  final Duration baseDelay;
  final Duration maxJitter;
  final math.Random _random;
  final Future<void> Function(Duration delay) _wait;

  static const Set<String> _idempotentMethods = {'GET', 'HEAD', 'OPTIONS'};

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final options = err.requestOptions;
    final attempt = (options.extra[RequestExtras.retryAttempt] as int?) ?? 0;

    if (attempt >= maxRetries || !_isRetryable(err)) {
      handler.next(err);
      return;
    }

    await _wait(delayFor(attempt));

    try {
      final response = await _dio.fetch<dynamic>(
        options.copyWith(
          extra: {...options.extra, RequestExtras.retryAttempt: attempt + 1},
        ),
      );
      handler.resolve(response);
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }

  /// [attempt] (0 tabanlı) için bekleme süresi.
  Duration delayFor(int attempt) {
    final exponential = baseDelay * math.pow(2, attempt).toInt();
    final jitter = maxJitter.inMilliseconds == 0
        ? Duration.zero
        : Duration(milliseconds: _random.nextInt(maxJitter.inMilliseconds));
    return exponential + jitter;
  }

  bool _isRetryable(DioException err) {
    if (!_idempotentMethods.contains(err.requestOptions.method.toUpperCase())) {
      return false;
    }
    return switch (err.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.connectionError => true,
      DioExceptionType.badResponse => (err.response?.statusCode ?? 0) >= 500,
      DioExceptionType.transformTimeout ||
      DioExceptionType.badCertificate ||
      DioExceptionType.cancel ||
      DioExceptionType.unknown => false,
    };
  }

  static Future<void> _defaultWait(Duration delay) =>
      Future<void>.delayed(delay);
}
