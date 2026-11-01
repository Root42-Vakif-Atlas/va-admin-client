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
  static String etagOf(Response<dynamic> response) {
    final etag = response.headers.value(NetworkConstants.etagHeader);
    if (etag == null || etag.isEmpty) {
      throw const UnexpectedException('missing ETag');
    }
    return etag;
  }
}
