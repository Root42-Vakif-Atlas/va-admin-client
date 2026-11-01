import 'package:vakif_atlas_admin/core/utils/typedefs.dart';

/// Sunucunun veya yerel okumanın bulgusu: [path] dosyadaki yer
/// (`works[12].images[0].src`), [code] sabit kod (`missing_file`, `invalid_key` …).
final class ImportIssue {
  const ImportIssue({required this.path, required this.code, this.detail});

  final String path;
  final String code;
  final String? detail;

  @override
  bool operator ==(Object other) =>
      other is ImportIssue &&
      other.path == path &&
      other.code == code &&
      other.detail == detail;

  @override
  int get hashCode => Object.hash(path, code, detail);
}

final class ImportCounts {
  const ImportCounts({
    required this.complexes,
    required this.works,
    required this.parts,
    required this.images,
    required this.uniqueImages,
    required this.created,
    required this.existing,
  });

  final int complexes;
  final int works;
  final int parts;
  final int images;
  final int uniqueImages;

  /// Katalogda olmayan (eklenecek) ve var olan (güncellenecek) kayıtlar.
  final int created;
  final int existing;
}

final class ImportResult {
  const ImportResult({
    required this.created,
    required this.updated,
    required this.createdComplexes,
    required this.updatedComplexes,
    required this.catalogVersion,
  });

  /// Eklenen / güncellenen eserler.
  final int created;
  final int updated;
  final int createdComplexes;
  final int updatedComplexes;
  final String catalogVersion;
}

/// Sunucunun içe aktarım planı (ön denetim; sunucu durumsuzdur, plan
/// saklanmaz). Hata varsa [valid] `false`; geçerliyse [missingImages] depoda
/// olmayan görsel özetleridir. Onaydan sonra [result] dolar.
final class ImportPlan {
  const ImportPlan({
    required this.valid,
    required this.missingImages,
    required this.errors,
    required this.warnings,
    required this.warningCount,
    this.counts,
    this.result,
  });

  final bool valid;
  final ImportCounts? counts;
  final List<String> missingImages;
  final List<ImportIssue> errors;
  final List<ImportIssue> warnings;

  /// Toplam uyarı (yanıtta en çok 500'ü listelenir).
  final int warningCount;
  final ImportResult? result;

  bool get committed => result != null;
}

/// Yerelde okunmuş VGM klasörü: dosya metni, her görsel yolunun SHA-256'sı
/// ve özet → dosya eşlemesi (yükleme için).
final class SeedFolder {
  const SeedFolder({
    required this.jsonPath,
    required this.json,
    required this.hashes,
    required this.files,
    required this.issues,
  });

  final String jsonPath;
  final String json;

  /// `src` → SHA-256.
  final Map<String, String> hashes;

  /// SHA-256 → okunacak dosya.
  final Map<String, SeedImageFile> files;

  /// Yerel sorunlar (eksik/çok büyük/okunamayan dosya); varsa sunucuya gönderilmez.
  final List<ImportIssue> issues;

  int get totalBytes => files.values.fold(0, (sum, f) => sum + f.byteSize);
}

final class SeedImageFile {
  const SeedImageFile({
    required this.path,
    required this.byteSize,
    required this.contentType,
  });

  final String path;
  final int byteSize;
  final String contentType;
}

/// Seçilen klasörü okur (dosya sistemi, isolate'te özet hesabı).
abstract interface class SeedFolderReader {
  /// Klasördeki VGM veri dosyaları (`*.schema.json` hariç).
  Future<List<String>> jsonFiles(String folder);

  ResultFuture<SeedFolder> read(String jsonPath);
}

/// VGM verisinin içe aktarımı (`catalog/admin/imports`, ADR 59).
abstract interface class CatalogImportRepository {
  /// `POST imports/validate`: dosya + görsel özetleri → plan.
  ResultFuture<ImportPlan> plan(SeedFolder folder);

  /// İçerik adresli görsel (`PUT imports/images/{sha256}`); zaten varsa da başarılı.
  ResultFuture<void> uploadImage(String sha256, SeedImageFile file);

  /// `POST imports/commit`: aynı gövde; tüm dosya tek işlemde yazılır.
  /// Görsel eksikse 409 (plan yenilenir), geçersizse 400 plan gövdesiyle.
  ResultFuture<ImportPlan> commit(
    SeedFolder folder, {
    required String idempotencyKey,
  });
}
