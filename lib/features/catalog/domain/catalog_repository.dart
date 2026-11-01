import 'package:vakif_atlas_admin/core/utils/paged.dart';
import 'package:vakif_atlas_admin/core/utils/typedefs.dart';
import 'package:vakif_atlas_admin/core/utils/versioned.dart';
import 'package:vakif_atlas_admin/features/catalog/domain/catalog_entities.dart';

/// Katalog yönetimi (`catalog/admin/*`). Silme yumuşaktır (yayından
/// kaldırma); değiştiren istekler okunan sürümü (`If-Match`) taşır.
abstract interface class CatalogRepository {
  ResultFuture<Paged<CatalogMonumentSummary>> list(
    CatalogFilter filter, {
    String? cursor,
  });

  ResultFuture<Versioned<CatalogMonument>> get(String id);

  ResultFuture<Versioned<CatalogMonument>> create(
    MonumentDraft draft, {
    required String idempotencyKey,
  });

  ResultFuture<Versioned<CatalogMonument>> update(
    MonumentDraft draft, {
    required String etag,
  });

  /// [complex]: kayıt bir külliye (`complexes/{key}`), değilse eser.
  ResultFuture<Versioned<CatalogMonument>> setPublication(
    String id, {
    required bool complex,
    required String etag,
    required Publication publication,
  });

  ResultFuture<Versioned<CatalogMonument>> setComplexMembers(
    String complexId, {
    required String etag,
    required List<String> memberIds,
  });

  /// İçerik adresli yükleme; dönen SHA-256 kayıtta görselin kaynağıdır.
  ResultFuture<String> uploadImage(PreparedImage image);
}

/// Seçilen görsel dosyasını yüklemeye hazırlar (cihazda, ağ yok).
abstract interface class ImagePreparer {
  /// Okunamayan / desteklenmeyen dosyada `null`.
  Future<PreparedImage?> prepare(List<int> bytes);
}
