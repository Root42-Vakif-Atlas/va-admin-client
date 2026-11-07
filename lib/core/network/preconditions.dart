import 'package:dio/dio.dart';
import 'package:vakif_atlas_admin/core/error/exceptions.dart';
import 'package:vakif_atlas_admin/core/network/network_constants.dart';

/// Yönetim uçlarının ortak HTTP kuralları (sunucu: `ServiceDefaults/Admin`).
abstract final class Preconditions {
  /// Değiştiren istek: okunan sürüm `If-Match` ile gönderilir.
  static Options ifMatch(String etag) =>
      Options(headers: {NetworkConstants.ifMatchHeader: etag});

  /// Oluşturma isteği: tekrar denemede aynı anahtar (ilk yanıt döner).
  /// Anahtar istek nesnesi başına bir kez üretilip saklanmalıdır.
  static Options idempotent(String key) =>
      Options(headers: {NetworkConstants.idempotencyKeyHeader: key});

  /// Yanıttaki güçlü `ETag`; yoksa sözleşme ihlalidir.
  ///
  /// Sunucu her zaman güçlü `ETag` üretir; ancak sıkıştıran ara katman
  /// (Cloudflare, nginx `gzip`) gövdeyi değiştirdiğinde onu zayıfa çevirir
  /// (`W/"…"`). Zayıf değer `If-Match`'te güçlü karşılaştırmayı geçemez ve
  /// her yazma 412 ile reddedilirdi; bu yüzden önek atılır ([strong]).
  static String etagOf(Response<dynamic> response) {
    final etag = strong(response.headers.value(NetworkConstants.etagHeader));
    if (etag == null) {
      throw const UnexpectedException('missing ETag');
    }
    return etag;
  }

  /// `W/"x"` → `"x"`; boşsa `null`.
  static String? strong(String? etag) {
    final value = etag?.trim();
    if (value == null || value.isEmpty) {
      return null;
    }
    return value.startsWith('W/') ? value.substring(2) : value;
  }
}
