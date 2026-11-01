/// Ağ katmanı sabitleri.
abstract final class NetworkConstants {
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration sendTimeout = Duration(seconds: 20);

  /// Fotoğraf yüklemesi (≤ 5 MB) yavaş mobil bağlantıda da tamamlansın.
  static const Duration uploadTimeout = Duration(seconds: 90);
  static const Duration receiveTimeout = Duration(seconds: 20);
  static const Duration probeTimeout = Duration(seconds: 5);

  static const String correlationIdHeader = 'X-Correlation-Id';
  static const String appVersionHeader = 'X-App-Version';
  static const String platformHeader = 'X-Platform';
  static const String deviceIntegrityHeader = 'X-Device-Integrity';
  static const String authorizationHeader = 'Authorization';

  /// İçerik dili. İstek kendi değerini verirse (ör. katalog içeriği arayüz
  /// dilinde istendiğinde) korunur; aksi halde aktif uygulama dili eklenir.
  static const String acceptLanguageHeader = 'Accept-Language';

  /// İyimser eşzamanlılık: yanıttaki kaynak sürümü ve değiştiren istekte
  /// beklenen sürüm (RFC 9110 §13).
  static const String etagHeader = 'ETag';
  static const String ifMatchHeader = 'If-Match';

  /// Oluşturma isteğinin tekrar güvenliği (aynı anahtar → ilk yanıt).
  static const String idempotencyKeyHeader = 'Idempotency-Key';

  /// Erişilebilirlik (reachability) denetimi için uç nokta.
  static const String healthPath = 'health';
}

/// `RequestOptions.extra` anahtarları.
abstract final class RequestExtras {
  /// `true` ise istek Bearer anahtarı eklenmeden gönderilir (giriş, kayıt).
  static const String skipAuth = 'skipAuth';

  /// 401 sonrası yenilenmiş anahtarla tekrar denendiğini işaretler.
  static const String authRetried = 'authRetried';

  /// Retry interceptor'ın deneme sayacı.
  static const String retryAttempt = 'retryAttempt';

  /// Loglama için isteğin başlangıç zamanı.
  static const String startedAt = 'startedAt';
}

/// DI'daki adlandırılmış `Dio` örnekleri.
abstract final class DioNames {
  /// Tüm interceptor zincirine sahip ana API istemcisi.
  static const String api = 'apiDio';

  /// Auth interceptor'ı olmayan istemci (token yenileme isteği için).
  static const String bare = 'bareDio';

  /// Bağlantı denetimi için interceptor'sız, kısa zaman aşımlı istemci.
  static const String probe = 'probeDio';

  /// Ön imzalı nesne deposu adreslerine yükleme: Bearer anahtarı, kimlik
  /// veya cihaz başlıkları taşımaz.
  static const String storage = 'storageDio';
}
