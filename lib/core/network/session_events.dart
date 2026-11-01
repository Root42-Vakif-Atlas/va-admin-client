import 'dart:async';

import 'package:injectable/injectable.dart';

/// Oturum olaylarını feature'lar arasında yayınlar.
///
/// - Token yenileme başarısız olduğunda `AuthInterceptor`
///   [notifySessionExpired] çağırır; kimlik doğrulama katmanı bu akışı
///   dinleyerek oturumu kapatır.
/// - Oturum açılınca / kapanınca kimlik doğrulama katmanı
///   [notifyAccountChanged] çağırır; sahipliği hesaba göre değişen veriler
///   (rotalar, kaydedilen eserler) kendini yeniler. Feature'lar kimlik
///   doğrulamaya bağımlı olmasın diye çekirdektedir.
/// - Hesap silinince [notifyAccountDeleted]; cihazdaki kişisel önbellekler
///   (ör. dışa aktarım arşivi) silinir (KVKK md. 7).
@lazySingleton
class SessionEvents {
  final StreamController<void> _expired = StreamController<void>.broadcast();
  final StreamController<String?> _account =
      StreamController<String?>.broadcast();
  final StreamController<String> _deleted =
      StreamController<String>.broadcast();

  Stream<void> get onSessionExpired => _expired.stream;

  /// Oturumdaki hesabın kimliği; `null` → misafir.
  Stream<String?> get onAccountChanged => _account.stream;

  /// Silinen hesabın kimliği.
  Stream<String> get onAccountDeleted => _deleted.stream;

  void notifySessionExpired() {
    if (!_expired.isClosed) {
      _expired.add(null);
    }
  }

  void notifyAccountChanged(String? userId) {
    if (!_account.isClosed) {
      _account.add(userId);
    }
  }

  void notifyAccountDeleted(String userId) {
    if (!_deleted.isClosed) {
      _deleted.add(userId);
    }
  }

  @disposeMethod
  Future<void> dispose() async {
    await _expired.close();
    await _account.close();
    await _deleted.close();
  }
}

/// Süresi dolan erişim anahtarını yenileyen sözleşme.
///
/// Kimlik doğrulama feature'ının Data katmanı tarafından uygulanır;
/// böylece ağ çekirdeği feature'a bağımlı olmaz.
abstract interface class AuthTokenRefresher {
  /// Başarılıysa yeni erişim anahtarını, aksi halde `null` döndürür.
  Future<String?> refreshAccessToken();
}
