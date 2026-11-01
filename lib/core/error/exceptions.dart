/// Data katmanında oluşan teknik istisnalar.
///
/// Yalnızca Data katmanında fırlatılır ve yakalanır; `ErrorMapper` ile
/// `Failure` tiplerine dönüştürülmeden üst katmanlara sızdırılmaz.
sealed class AppException implements Exception {
  const AppException();
}

/// Sunucu 2xx dışı bir durum koduyla yanıt verdi.
final class ServerException extends AppException {
  const ServerException({
    required this.statusCode,
    this.errorCode,
    this.retryAfter,
  });

  final int statusCode;

  /// Yanıt gövdesindeki makine okunur hata kodu (ör. `invalid_credentials`).
  final String? errorCode;

  /// 429 / 423 yanıtlarında `Retry-After` başlığı veya gövdedeki
  /// `retryAfter` (saniye) alanı.
  final Duration? retryAfter;

  @override
  String toString() =>
      'ServerException(statusCode: $statusCode, errorCode: $errorCode, '
      'retryAfter: $retryAfter)';
}

enum NetworkExceptionType {
  /// Sunucu zamanında yanıt vermedi.
  timeout,

  /// Sunucuya bağlanılamadı (kapalı, reddetti) — cihaz çevrimiçi.
  noConnection,

  /// Cihaz çevrimdışı (ağ arayüzü yok veya ad çözümlenemiyor).
  offline,
}

/// İstek sunucuya ulaşamadı veya zaman aşımına uğradı.
final class NetworkException extends AppException {
  const NetworkException(this.type);

  final NetworkExceptionType type;

  @override
  String toString() => 'NetworkException(type: $type)';
}

/// Yerel depolama (secure storage, tercihler, önbellek) hatası.
final class CacheException extends AppException {
  const CacheException(this.operation);

  /// Başarısız olan işlemin kısa tanımı (PII içermez).
  final String operation;

  @override
  String toString() => 'CacheException(operation: $operation)';
}

enum SecurityExceptionType { sslPinningFailed, deviceIntegrityViolated }

/// SSL pinning doğrulaması veya cihaz bütünlüğü kontrolü başarısız.
final class SecurityException extends AppException {
  const SecurityException(this.type);

  final SecurityExceptionType type;

  @override
  String toString() => 'SecurityException(type: $type)';
}

/// İstek kullanıcı veya eşzamanlılık kuralı (ör. `restartable`) ile iptal edildi.
final class RequestCancelledException extends AppException {
  const RequestCancelledException();

  @override
  String toString() => 'RequestCancelledException()';
}

/// Sınıflandırılamayan teknik hata.
final class UnexpectedException extends AppException {
  const UnexpectedException(this.cause);

  final Object? cause;

  @override
  String toString() => 'UnexpectedException(cause: ${cause.runtimeType})';
}
