import 'package:vakif_atlas_admin/core/utils/list_equality.dart';
import 'package:vakif_atlas_admin/features/catalog/domain/turkish_provinces.dart';

enum MonumentCategory {
  mosque,
  complex,
  madrasa,
  inn,
  caravanserai,
  bath,
  fountain,
  tomb,
  hospital,
  imaret,
  other;

  static MonumentCategory fromWire(String value) =>
      values.firstWhere((c) => c.name == value, orElse: () => other);
}

enum MonumentPeriod {
  seljuk,
  beylik,
  ottoman,
  other;

  static MonumentPeriod fromWire(String value) =>
      values.firstWhere((p) => p.name == value, orElse: () => other);
}

enum Publication { published, archived }

/// Dil başına eser metni (Türkçe ve İngilizce ayrı düzenlenir). Uzun metin
/// bölümlerdedir ([MonumentPart]); ayrı bir açıklama alanı yoktur.
final class MonumentText {
  const MonumentText({
    this.name = '',
    this.shortDescriptionTitle = '',
    this.shortDescription = '',
    this.history = '',
    this.constructionDate = '',
    this.founder = '',
    this.architect = '',
    this.nickname = '',
    this.slug = '',
  });

  /// Ad (sunucuda `title`).
  final String name;
  final String shortDescriptionTitle;
  final String shortDescription;
  final String history;
  final String constructionDate;
  final String founder;
  final String architect;

  /// Halk arasındaki adı (VGM verisi; isteğe bağlı).
  final String nickname;

  /// Dilin adres parçası (yalnızca İngilizcede anlamlı; Türkçede anahtar).
  /// Düzenlenmez, kayıtta olduğu gibi geri gönderilir.
  final String slug;

  MonumentText copyWith({
    String? name,
    String? shortDescriptionTitle,
    String? shortDescription,
    String? history,
    String? constructionDate,
    String? founder,
    String? architect,
    String? nickname,
  }) => MonumentText(
    name: name ?? this.name,
    shortDescriptionTitle: shortDescriptionTitle ?? this.shortDescriptionTitle,
    shortDescription: shortDescription ?? this.shortDescription,
    history: history ?? this.history,
    constructionDate: constructionDate ?? this.constructionDate,
    founder: founder ?? this.founder,
    architect: architect ?? this.architect,
    nickname: nickname ?? this.nickname,
    slug: slug,
  );

  @override
  bool operator ==(Object other) =>
      other is MonumentText &&
      other.nickname == nickname &&
      other.name == name &&
      other.shortDescriptionTitle == shortDescriptionTitle &&
      other.shortDescription == shortDescription &&
      other.history == history &&
      other.constructionDate == constructionDate &&
      other.founder == founder &&
      other.architect == architect &&
      other.slug == slug;

  @override
  int get hashCode => Object.hash(
    name,
    shortDescriptionTitle,
    shortDescription,
    history,
    constructionDate,
    founder,
    architect,
    nickname,
    slug,
  );
}

/// Eser bölümü (VGM verisi: ör. cami ve medrese kısımları). Türkçe metin
/// zorunlu; İngilizce boşsa uygulamada Türkçe gösterilir.
final class MonumentPart {
  const MonumentPart({
    this.titleTr = '',
    this.titleEn = '',
    this.descriptionTr = '',
    this.descriptionEn = '',
  });

  final String titleTr;
  final String titleEn;
  final String descriptionTr;
  final String descriptionEn;

  MonumentPart copyWith({
    String? titleTr,
    String? titleEn,
    String? descriptionTr,
    String? descriptionEn,
  }) => MonumentPart(
    titleTr: titleTr ?? this.titleTr,
    titleEn: titleEn ?? this.titleEn,
    descriptionTr: descriptionTr ?? this.descriptionTr,
    descriptionEn: descriptionEn ?? this.descriptionEn,
  );

  @override
  bool operator ==(Object other) =>
      other is MonumentPart &&
      other.titleTr == titleTr &&
      other.titleEn == titleEn &&
      other.descriptionTr == descriptionTr &&
      other.descriptionEn == descriptionEn;

  @override
  int get hashCode =>
      Object.hash(titleTr, titleEn, descriptionTr, descriptionEn);
}

/// Görsel. Sunucuya kaynağıyla gönderilir: içerik adresli dosya ([sha256];
/// içe aktarılan ve panelden yüklenen görseller) veya başka yerdeki adres
/// ([originUrl]; sunucu kopyalar). Türkçe alternatif metin zorunludur
/// (WCAG 1.1.1); yeni görselde künye (yazar, lisans) zorunludur.
final class MonumentImage {
  const MonumentImage({
    this.url,
    this.thumbnailUrl,
    this.sha256,
    this.originUrl,
    this.previewBytes,
    this.altTr = '',
    this.altEn = '',
    this.author = '',
    this.license = '',
    this.sourceName = '',
    this.sourceUrl = '',
    this.mirrored = false,
    this.titleTr = '',
    this.titleEn = '',
    this.part,
  });

  final String? url;
  final String? thumbnailUrl;

  /// İçerik adresli dosyanın SHA-256'sı (`PUT imports/images/{sha256}`).
  final String? sha256;

  /// Adresle eklenmiş görselin kaynağı.
  final String? originUrl;

  /// Yeni yüklenen görselin cihazdaki önizlemesi (kaydedilene kadar).
  final List<int>? previewBytes;
  final String altTr;
  final String altEn;
  final String author;
  final String license;
  final String sourceName;
  final String sourceUrl;
  final bool mirrored;
  final String titleTr;
  final String titleEn;

  /// Bölüm görseli: [MonumentDraft.parts] içindeki sıra; eser görselinde `null`.
  final int? part;

  /// Bu oturumda yüklendi (kaydedilene kadar önizlemesi cihazda).
  bool get isNew => previewBytes != null;

  /// Listedeki kimlik (yeniden sıralama ve anahtar).
  String get key => sha256 ?? originUrl ?? url ?? '';

  MonumentImage copyWith({
    String? altTr,
    String? altEn,
    String? author,
    String? license,
    String? sourceName,
    String? sourceUrl,
    int? Function()? part,
  }) => MonumentImage(
    url: url,
    thumbnailUrl: thumbnailUrl,
    sha256: sha256,
    originUrl: originUrl,
    previewBytes: previewBytes,
    altTr: altTr ?? this.altTr,
    altEn: altEn ?? this.altEn,
    author: author ?? this.author,
    license: license ?? this.license,
    sourceName: sourceName ?? this.sourceName,
    sourceUrl: sourceUrl ?? this.sourceUrl,
    mirrored: mirrored,
    titleTr: titleTr,
    titleEn: titleEn,
    part: part == null ? this.part : part(),
  );

  @override
  bool operator ==(Object other) =>
      other is MonumentImage &&
      other.key == key &&
      other.altTr == altTr &&
      other.altEn == altEn &&
      other.author == author &&
      other.license == license &&
      other.sourceName == sourceName &&
      other.sourceUrl == sourceUrl &&
      other.part == part;

  @override
  int get hashCode => Object.hash(
    key,
    altTr,
    altEn,
    author,
    license,
    sourceName,
    sourceUrl,
    part,
  );
}

/// Eserin (veya külliyenin: [category] `complex`) düzenlenebilir alanları
/// (oluşturma ve tam değiştirme).
final class MonumentDraft {
  const MonumentDraft({
    this.id = '',
    this.category = MonumentCategory.mosque,
    this.categoryAuto = true,
    this.period = MonumentPeriod.other,
    this.cityCode,
    this.district = '',
    this.address = '',
    this.latitude,
    this.longitude,
    this.unesco = false,
    this.isActive = true,
    this.tr = const MonumentText(),
    this.en = const MonumentText(),
    this.images = const [],
    this.complexId = '',
    this.complexOrder,
    this.parts = const [],
  });

  final String id;
  final MonumentCategory category;

  /// Tür Türkçe addan türetilir (sunucuya `category: null`); elle seçilen
  /// tür addan bağımsız kalır.
  final bool categoryAuto;
  final MonumentPeriod period;

  /// İl plaka kodu (zorunlu).
  final int? cityCode;
  final String district;
  final String address;
  final double? latitude;
  final double? longitude;
  final bool unesco;

  /// Etkin değilse yayından kaldırılmış gibi herkese açık uçlarda görünmez.
  final bool isActive;
  final MonumentText tr;
  final MonumentText en;
  final List<MonumentImage> images;

  /// Üyesi olduğu külliye (boş → bağımsız eser). Salt okunur: üyelik
  /// külliyenin yapı listesinden düzenlenir (`PUT complexes/{key}/works`).
  final String complexId;
  final int? complexOrder;

  /// Bölümler (VGM verisi); bölüm görselleri [MonumentImage.part] ile bağlıdır.
  final List<MonumentPart> parts;

  bool get isComplex => category == MonumentCategory.complex;

  String get city => TurkishProvinces.nameOf(cityCode);

  /// Konumu girilmemiş eser haritada ve rota planlayıcıda görünmez.
  bool get hasLocation => latitude != null && longitude != null;

  MonumentDraft copyWith({
    String? id,
    MonumentCategory? category,
    bool? categoryAuto,
    MonumentPeriod? period,
    int? cityCode,
    String? district,
    String? address,
    double? Function()? latitude,
    double? Function()? longitude,
    bool? unesco,
    bool? isActive,
    MonumentText? tr,
    MonumentText? en,
    List<MonumentImage>? images,
    List<MonumentPart>? parts,
  }) => MonumentDraft(
    id: id ?? this.id,
    category: category ?? this.category,
    categoryAuto: categoryAuto ?? this.categoryAuto,
    period: period ?? this.period,
    cityCode: cityCode ?? this.cityCode,
    district: district ?? this.district,
    address: address ?? this.address,
    latitude: latitude == null ? this.latitude : latitude(),
    longitude: longitude == null ? this.longitude : longitude(),
    unesco: unesco ?? this.unesco,
    isActive: isActive ?? this.isActive,
    tr: tr ?? this.tr,
    en: en ?? this.en,
    images: images ?? this.images,
    complexId: complexId,
    complexOrder: complexOrder,
    parts: parts ?? this.parts,
  );

  @override
  bool operator ==(Object other) =>
      other is MonumentDraft &&
      other.id == id &&
      other.category == category &&
      other.categoryAuto == categoryAuto &&
      other.period == period &&
      other.cityCode == cityCode &&
      other.district == district &&
      other.address == address &&
      other.latitude == latitude &&
      other.longitude == longitude &&
      other.unesco == unesco &&
      other.isActive == isActive &&
      other.tr == tr &&
      other.en == en &&
      elementsEqual(other.images, images) &&
      other.complexId == complexId &&
      other.complexOrder == complexOrder &&
      elementsEqual(other.parts, parts);

  @override
  int get hashCode => Object.hash(
    id,
    category,
    categoryAuto,
    period,
    cityCode,
    district,
    address,
    latitude,
    longitude,
    unesco,
    isActive,
    tr,
    en,
    Object.hashAll(images),
    complexId,
    complexOrder,
    Object.hashAll(parts),
  );
}

final class ComplexMember {
  const ComplexMember({
    required this.id,
    required this.name,
    required this.archived,
    this.order,
  });

  final String id;
  final String name;
  final int? order;
  final bool archived;
}

/// Kayıtlı eser (yönetim görünümü).
final class CatalogMonument {
  const CatalogMonument({
    required this.draft,
    required this.publication,
    required this.updatedAt,
    this.complexName,
    this.members,
    this.archivedAt,
  });

  final MonumentDraft draft;
  final Publication publication;
  final DateTime updatedAt;
  final DateTime? archivedAt;

  /// Üyesi olduğu külliyenin Türkçe adı.
  final String? complexName;

  /// Külliyede yapılar (küratörlü sırayla); külliye değilse `null`.
  final List<ComplexMember>? members;

  String get id => draft.id;

  @override
  bool operator ==(Object other) =>
      other is CatalogMonument &&
      other.draft == draft &&
      other.publication == publication &&
      other.updatedAt == updatedAt;

  @override
  int get hashCode => Object.hash(draft, publication, updatedAt);
}

/// Liste satırı.
final class CatalogMonumentSummary {
  const CatalogMonumentSummary({
    required this.id,
    required this.nameTr,
    required this.category,
    required this.period,
    required this.city,
    required this.district,
    required this.imageCount,
    required this.publication,
    required this.updatedAt,
    this.nameEn,
    this.thumbnailUrl,
    this.complexId,
    this.complexName,
    this.memberCount,
    this.hasLocation = true,
  });

  final String id;
  final String nameTr;
  final String? nameEn;
  final MonumentCategory category;
  final MonumentPeriod period;
  final String city;
  final String district;
  final String? thumbnailUrl;
  final int imageCount;
  final String? complexId;
  final String? complexName;
  final int? memberCount;
  final Publication publication;
  final DateTime updatedAt;
  final bool hasLocation;
}

enum CatalogSort { name, updated }

/// Konum süzgeci: VGM verisi koordinat taşımaz, konumu girilecek eserler listelenir.
enum LocationFilter { present, missing }

final class CatalogFilter {
  const CatalogFilter({
    this.query = '',
    this.categories = const {},
    this.periods = const {},
    this.publication,
    this.sort = CatalogSort.name,
    this.location,
  });

  final String query;
  final Set<MonumentCategory> categories;
  final Set<MonumentPeriod> periods;

  /// `null` → tümü.
  final Publication? publication;
  final CatalogSort sort;

  /// `null` → tümü.
  final LocationFilter? location;

  bool get isDefault =>
      query.isEmpty &&
      categories.isEmpty &&
      periods.isEmpty &&
      publication == null &&
      location == null &&
      sort == CatalogSort.name;

  CatalogFilter copyWith({
    String? query,
    Set<MonumentCategory>? categories,
    Set<MonumentPeriod>? periods,
    Publication? Function()? publication,
    CatalogSort? sort,
    LocationFilter? Function()? location,
  }) => CatalogFilter(
    query: query ?? this.query,
    categories: categories ?? this.categories,
    periods: periods ?? this.periods,
    publication: publication == null ? this.publication : publication(),
    sort: sort ?? this.sort,
    location: location == null ? this.location : location(),
  );

  @override
  bool operator ==(Object other) =>
      other is CatalogFilter &&
      other.location == location &&
      other.query == query &&
      setEquals(other.categories, categories) &&
      setEquals(other.periods, periods) &&
      other.publication == publication &&
      other.sort == sort;

  @override
  int get hashCode => Object.hash(
    query,
    Object.hashAllUnordered(categories),
    Object.hashAllUnordered(periods),
    publication,
    sort,
    location,
  );
}

/// Hazırlanmış (küçültülmüş, EXIF'i silinmiş) JPEG.
final class PreparedImage {
  const PreparedImage({
    required this.bytes,
    required this.width,
    required this.height,
  });

  final List<int> bytes;
  final int width;
  final int height;
}
