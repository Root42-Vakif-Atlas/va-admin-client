import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas_admin/features/catalog/domain/catalog_entities.dart';
import 'package:vakif_atlas_admin/features/catalog/domain/catalog_repository.dart';

/// Görseli ayrı isolate'te çözer, en çok [maxEdge] piksele küçültür ve JPEG
/// olarak yeniden kodlar: EXIF/GPS dahil tüm meta veri düşer (sunucu da
/// yeniden işler). PNG/WebP/HEIC dışı biçimler `image` paketinin
/// desteklediği ölçüdedir.
@LazySingleton(as: ImagePreparer)
class ImagePreparerImpl implements ImagePreparer {
  static const int maxEdge = 2400;
  static const int quality = 88;

  @override
  Future<PreparedImage?> prepare(List<int> bytes) =>
      compute(_prepare, Uint8List.fromList(bytes));

  static PreparedImage? _prepare(Uint8List bytes) {
    final decoded = img.decodeImage(bytes);
    if (decoded == null) {
      return null;
    }
    final oriented = img.bakeOrientation(decoded);
    final longest = oriented.width > oriented.height
        ? oriented.width
        : oriented.height;
    final resized = longest > maxEdge
        ? img.copyResize(
            oriented,
            width: oriented.width >= oriented.height ? maxEdge : null,
            height: oriented.height > oriented.width ? maxEdge : null,
            interpolation: img.Interpolation.average,
          )
        : oriented;
    // Meta veri taşınmaz: yeni görüntü yalnızca piksellerden kodlanır.
    resized.exif = img.ExifData();
    final jpeg = img.encodeJpg(resized, quality: quality);
    return PreparedImage(
      bytes: jpeg,
      width: resized.width,
      height: resized.height,
    );
  }
}
