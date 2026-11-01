import 'package:vakif_atlas_admin/features/catalog/domain/catalog_entities.dart';

/// Düzenleyicinin alanları (hata eşlemesi ve odak için).
enum MonumentField {
  id,
  city,
  district,
  address,
  location,
  trName,
  trShortDescription,
  enName,
  enShortDescription,
  images,
  parts,
}

/// Sunucu kurallarının (`VgmValidator`, `CatalogAdminService`) istemci
/// kopyası: hata alan yanında gösterilir, sunucu yine son sözü söyler.
abstract final class MonumentValidation {
  /// VGM verisinde bir eserin (bölüm görselleriyle) 113 görseli var.
  static const int maxImages = 120;
  static const int maxParts = 100;
  static const int maxName = 200;
  static const int maxShortDescription = 1000;
  static const int maxAddress = 500;
  static const int maxDistrict = 100;
  static const int maxAltText = 150;
  static const int maxKey = 200;

  static final RegExp _id = RegExp(r'^[a-z0-9]+(-[a-z0-9]+)*$');

  /// Katalog anahtarı (`CatalogKey`): küçük harf, rakam, tek tire.
  static bool isValidId(String id) =>
      id.isNotEmpty && id.length <= maxKey && _id.hasMatch(id);

  /// Türkiye'yi kapsayan dikdörtgen (sunucu: `CatalogRegion`).
  static bool isInTurkey(double latitude, double longitude) =>
      latitude >= 35.5 &&
      latitude <= 42.5 &&
      longitude >= 25.5 &&
      longitude <= 45;

  static Set<MonumentField> validate(
    MonumentDraft draft, {
    required bool creating,
  }) {
    bool blank(String value) => value.trim().isEmpty;
    bool tooLong(String value, int max) => value.trim().length > max;
    final latitude = draft.latitude;
    final longitude = draft.longitude;
    return {
      if (creating && !isValidId(draft.id)) MonumentField.id,
      if (draft.cityCode == null) MonumentField.city,
      // Külliyenin ilçesi zorunlu; eserde VGM verisi ilçe taşımayabilir.
      if ((draft.isComplex && blank(draft.district)) ||
          tooLong(draft.district, maxDistrict))
        MonumentField.district,
      if (tooLong(draft.address, maxAddress)) MonumentField.address,
      // Konum isteğe bağlıdır (girilmeyen eser haritada görünmez); girilirse
      // iki alan da Türkiye'de.
      if ((latitude == null) != (longitude == null) ||
          (latitude != null &&
              longitude != null &&
              !isInTurkey(latitude, longitude)))
        MonumentField.location,
      if (blank(draft.tr.name) || tooLong(draft.tr.name, maxName))
        MonumentField.trName,
      if (tooLong(draft.tr.shortDescription, maxShortDescription))
        MonumentField.trShortDescription,
      if (tooLong(draft.en.name, maxName)) MonumentField.enName,
      if (tooLong(draft.en.shortDescription, maxShortDescription))
        MonumentField.enShortDescription,
      if (draft.parts.length > maxParts) MonumentField.parts,
      if (draft.images.length > maxImages ||
          draft.images.any(
            (i) => i.part != null && i.part! >= draft.parts.length,
          ) ||
          draft.images.any(
            (i) =>
                blank(i.altTr) ||
                tooLong(i.altTr, maxAltText) ||
                tooLong(i.altEn, maxAltText) ||
                (i.isNew && (blank(i.author) || blank(i.license))),
          ))
        MonumentField.images,
    };
  }

  /// Türkçe addan kimlik önerisi: "Rüstem Paşa Hamamı" → `rustem-pasa-hamami`.
  static String suggestId(String name) {
    const folds = {
      'ç': 'c',
      'ğ': 'g',
      'ı': 'i',
      'i̇': 'i',
      'ö': 'o',
      'ş': 's',
      'ü': 'u',
      'â': 'a',
      'î': 'i',
      'û': 'u',
    };
    final lower = name.toLowerCase();
    final buffer = StringBuffer();
    for (final rune in lower.runes) {
      final character = String.fromCharCode(rune);
      buffer.write(folds[character] ?? character);
    }
    return buffer
        .toString()
        .replaceAll(RegExp('[^a-z0-9]+'), '-')
        .replaceAll(RegExp('^-+|-+\$'), '');
  }
}
