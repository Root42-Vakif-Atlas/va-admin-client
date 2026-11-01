/// Domain katmanına taşınan, kullanıcıya anlamlı hata tipleri.
///
/// Data katmanındaki teknik istisnalar `ErrorMapper` ile bu tiplere
/// dönüştürülür; Presentation katmanı yalnızca [Failure] görür.
/// Kullanıcı mesajı eşlemesi: `failure_l10n.dart`.
sealed class Failure {
  const Failure();
}

/// Sunucu kaynaklı hatanın sınıfı (TRD §9 hata tablosu).
enum ServerFailureKind {
  /// 400 — Gönderilen istek geçersiz.
  invalidRequest,

  /// 404 — İstenen kaynak bulunamadı.
  notFound,

  /// 5xx — Sunucu geçici olarak hizmet veremiyor.
  unavailable,

  /// Tabloda karşılığı olmayan diğer HTTP durum kodları.
  unknown,
}

/// HTTP 400 / 404 / 5xx ve diğer sunucu hataları.
final class ServerFailure extends Failure {
  const ServerFailure({required this.kind, this.statusCode, this.code});

  final ServerFailureKind kind;
  final int? statusCode;

  /// Sözleşmedeki makine okunur kod (`invalid_monument` …); yoksa `null`.
  final String? code;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServerFailure &&
          other.kind == kind &&
          other.statusCode == statusCode &&
          other.code == code;

  @override
  int get hashCode => Object.hash(ServerFailure, kind, statusCode, code);

  @override
  String toString() =>
      'ServerFailure(kind: $kind, statusCode: $statusCode, code: $code)';
}

/// Çakışan değişikliğin nedeni (HTTP 409).
enum ConflictReason {
  /// Durum geçişi artık geçerli değil (ör. rapor başkası tarafından kapatıldı).
  invalidTransition,

  /// Aynı kimlikte eser zaten var.
  monumentExists,

  /// Külliye yapıları kuralı (yapısı olan külliye kaldırılamaz vb.).
  complexMembers,

  /// Sistemde etkin en az bir yönetici kalmalı.
  lastAdmin,

  /// Yönetici kendi yetkisini kaldıramaz / kendini devre dışı bırakamaz.
  cannotModifySelf,

  /// Aynı istek hâlâ işleniyor (Idempotency-Key).
  requestInProgress,

  /// Personel zaten kayıtlı.
  staffExists,

  /// İçe aktarım onayı: bazı görseller henüz yüklenmedi.
  importImagesMissing,

  unknown,
}

/// HTTP 409 — istek kaynağın güncel durumuyla çelişiyor.
final class ConflictFailure extends Failure {
  const ConflictFailure(this.reason);

  final ConflictReason reason;

  @override
  bool operator ==(Object other) =>
      other is ConflictFailure && other.reason == reason;

  @override
  int get hashCode => Object.hash(ConflictFailure, reason);

  @override
  String toString() => 'ConflictFailure($reason)';
}

/// HTTP 412 / 428 — kayıt siz düzenlerken başka biri tarafından değiştirildi
/// (`If-Match` eşleşmedi). Kullanıcı güncel kaydı yeniden yükler.
final class StaleDataFailure extends Failure {
  const StaleDataFailure();

  @override
  bool operator ==(Object other) => other is StaleDataFailure;

  @override
  int get hashCode => (StaleDataFailure).hashCode;

  @override
  String toString() => 'StaleDataFailure()';
}

/// HTTP 401 / 403 — oturum süresi doldu veya yetki yok.
final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure();

  @override
  bool operator ==(Object other) => other is UnauthorizedFailure;

  @override
  int get hashCode => (UnauthorizedFailure).hashCode;

  @override
  String toString() => 'UnauthorizedFailure()';
}

/// Kimlik doğrulama akışlarına özgü hata nedeni.
///
/// Sunucunun makine okunur hata kodlarından (`{"code": "..."}`) eşlenir.
enum AuthFailureReason {
  /// Giriş: e-posta veya şifre hatalı ya da hesap personel değil
  /// (hangisi olduğu söylenmez).
  invalidCredentials,

  /// İki adımlı doğrulama kodu veya kurtarma kodu hatalı.
  invalidMfaCode,

  /// Giriş biletinin süresi doldu veya deneme hakkı bitti; yeniden giriş.
  mfaExpired,

  /// Doğrulama / sıfırlama kodu hatalı.
  invalidVerificationCode,

  /// Kodun süresi doldu veya deneme hakkı bitti; yeni kod istenmeli.
  verificationCodeExpired,

  /// Sunucu şifreyi güvenlik politikasına uygun bulmadı.
  weakPassword,

  /// Şifre değiştirme / hesap silme: mevcut şifre hatalı.
  invalidCurrentPassword,
}

/// Kimlik doğrulama akışı hatası.
final class AuthFailure extends Failure {
  const AuthFailure(this.reason, {this.retryAfter});

  final AuthFailureReason reason;

  /// Sunucunun bildirdiği bekleme süresi (bilinmiyorsa `null`).
  final Duration? retryAfter;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthFailure &&
          other.reason == reason &&
          other.retryAfter == retryAfter;

  @override
  int get hashCode => Object.hash(AuthFailure, reason, retryAfter);

  @override
  String toString() => 'AuthFailure($reason, retryAfter: $retryAfter)';
}

/// HTTP 429 / 423 — hız sınırı aşıldı veya hesap geçici olarak kilitlendi.
final class TooManyRequestsFailure extends Failure {
  const TooManyRequestsFailure({this.retryAfter});

  /// Sunucunun bildirdiği bekleme süresi (bilinmiyorsa `null`).
  final Duration? retryAfter;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TooManyRequestsFailure && other.retryAfter == retryAfter;

  @override
  int get hashCode => Object.hash(TooManyRequestsFailure, retryAfter);

  @override
  String toString() => 'TooManyRequestsFailure(retryAfter: $retryAfter)';
}

/// İsteğin neden sunucuya ulaşamadığı.
enum NetworkFailureKind {
  /// Cihazın internet bağlantısı yok.
  offline,

  /// Cihaz çevrimiçi ama sunucu yanıt vermiyor / bağlantıyı reddediyor.
  serverUnreachable,
}

/// İstek sunucuya ulaşamadı: çevrimdışı veya sunucuya erişilemiyor.
final class NetworkFailure extends Failure {
  const NetworkFailure({this.kind = NetworkFailureKind.serverUnreachable});

  final NetworkFailureKind kind;

  bool get isOffline => kind == NetworkFailureKind.offline;

  @override
  bool operator ==(Object other) =>
      other is NetworkFailure && other.kind == kind;

  @override
  int get hashCode => Object.hash(NetworkFailure, kind);

  @override
  String toString() => 'NetworkFailure($kind)';
}

/// Yerel veri okunamadı veya yazılamadı.
final class CacheFailure extends Failure {
  const CacheFailure();

  @override
  bool operator ==(Object other) => other is CacheFailure;

  @override
  int get hashCode => (CacheFailure).hashCode;

  @override
  String toString() => 'CacheFailure()';
}

/// SSL pinning veya cihaz bütünlüğü doğrulanamadı.
final class SecurityViolationFailure extends Failure {
  const SecurityViolationFailure();

  @override
  bool operator ==(Object other) => other is SecurityViolationFailure;

  @override
  int get hashCode => (SecurityViolationFailure).hashCode;

  @override
  String toString() => 'SecurityViolationFailure()';
}

/// Sınıflandırılamayan beklenmeyen hata (ör. bozuk yanıt gövdesi).
final class UnexpectedFailure extends Failure {
  const UnexpectedFailure();

  @override
  bool operator ==(Object other) => other is UnexpectedFailure;

  @override
  int get hashCode => (UnexpectedFailure).hashCode;

  @override
  String toString() => 'UnexpectedFailure()';
}
