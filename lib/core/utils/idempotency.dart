import 'dart:math';

/// Oluşturma isteğinin tekrar güvenliği için anahtar (128 bit, onaltılık).
/// İstek nesnesi başına bir kez üretilir; ağ tekrarı ve çift tıklama aynı
/// anahtarı taşır, sunucu ilk yanıtı döndürür (`Idempotency-Key`).
String newIdempotencyKey() {
  final random = Random.secure();
  return [
    for (var i = 0; i < 16; i++)
      random.nextInt(256).toRadixString(16).padLeft(2, '0'),
  ].join();
}
