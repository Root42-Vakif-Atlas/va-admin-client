import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas_admin/core/network/api_guard.dart';
import 'package:vakif_atlas_admin/core/network/network_constants.dart';
import 'package:vakif_atlas_admin/core/network/preconditions.dart';
import 'package:vakif_atlas_admin/core/utils/paged.dart';
import 'package:vakif_atlas_admin/core/utils/turkish_text.dart';
import 'package:vakif_atlas_admin/core/utils/typedefs.dart';
import 'package:vakif_atlas_admin/core/utils/versioned.dart';
import 'package:vakif_atlas_admin/features/catalog/domain/catalog_entities.dart';
import 'package:vakif_atlas_admin/features/catalog/domain/catalog_repository.dart';
import 'package:vakif_atlas_admin/features/catalog/domain/turkish_provinces.dart';

/// `catalog/admin/works` (eserler, sayfalı) ve `catalog/admin/complexes`
/// (külliyeler, ayrı kayıt; sayfasız). Düzenleyicide külliye `complex`
/// türündeki taslaktır; istekler türe göre ilgili kaynağa gider.
@LazySingleton(as: CatalogRepository)
class CatalogRepositoryImpl implements CatalogRepository {
  CatalogRepositoryImpl(@Named(DioNames.api) this._dio);

  final Dio _dio;

  static const String _base = 'catalog/admin';
  static const int pageSize = 50;

  /// Eser listesi sorgusu; `complex` türü eser türü değildir, gönderilmez.
  static Map<String, Object> query(CatalogFilter filter, String? cursor) {
    final categories = [
      for (final category in filter.categories)
        if (category != MonumentCategory.complex) category.name,
    ];
    return {
      if (filter.query.isNotEmpty) 'q': filter.query,
      if (categories.isNotEmpty) 'category': categories.join(','),
      if (filter.periods.isNotEmpty)
        'period': filter.periods.map((p) => p.name).join(','),
      'publication': filter.publication?.name ?? 'all',
      'sort': filter.sort.name,
      'location': ?filter.location?.name,
      'limit': pageSize,
      'cursor': ?cursor,
    };
  }

  // ---------------------------------------------------------------------
  // Okuma
  // ---------------------------------------------------------------------

  static String _string(Object? value) => value as String? ?? '';

  static Map<String, dynamic>? _map(Object? value) =>
      value as Map<String, dynamic>?;

  static Publication _publication(Object? value) =>
      value == 'archived' ? Publication.archived : Publication.published;

  static MonumentText _text(Map<String, dynamic>? json) => MonumentText(
    name: _string(json?['title']),
    shortDescriptionTitle: _string(json?['shortDescriptionTitle']),
    shortDescription: _string(json?['shortDescription']),
    history: _string(json?['history']),
    constructionDate: _string(json?['constructionDate']),
    founder: _string(json?['founder']),
    architect: _string(json?['architect']),
    nickname: _string(json?['nickname']),
    slug: _string(json?['slug']),
  );

  /// `AdminImage`; [part] bölüm görselinde bölüm sırası.
  static MonumentImage _image(Map<String, dynamic> json, {int? part}) {
    final attribution = _map(json['attribution']);
    final translations = _map(json['translations']);
    final tr = _map(translations?['tr']);
    final en = _map(translations?['en']);
    return MonumentImage(
      url: json['url'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      sha256: json['sha256'] as String?,
      originUrl: json['originUrl'] as String?,
      altTr: _string(tr?['altText']),
      altEn: _string(en?['altText']),
      titleTr: _string(tr?['title']),
      titleEn: _string(en?['title']),
      author: _string(attribution?['author']),
      license: _string(attribution?['license']),
      sourceName: _string(attribution?['sourceName']),
      sourceUrl: _string(attribution?['sourceUrl']),
      mirrored: json['mirrored'] as bool? ?? false,
      part: part,
    );
  }

  static List<MonumentImage> _images(Object? json, {int? part}) => [
    for (final image
        in (json as List<dynamic>? ?? const []).cast<Map<String, dynamic>>())
      _image(image, part: part),
  ];

  static (double?, double?) _location(Object? json) {
    final location = _map(json);
    return (
      (location?['latitude'] as num?)?.toDouble(),
      (location?['longitude'] as num?)?.toDouble(),
    );
  }

  /// `AdminWorkDetail`: bölüm görselleri düz listeye bölüm sırasıyla
  /// ([MonumentImage.part]) eklenir.
  static CatalogMonument parseWork(Map<String, dynamic> json) {
    final translations = _map(json['translations']);
    final complex = _map(json['complex']);
    final parts = (json['parts'] as List<dynamic>? ?? const [])
        .cast<Map<String, dynamic>>();
    final (latitude, longitude) = _location(json['location']);
    return CatalogMonument(
      draft: MonumentDraft(
        id: json['key'] as String,
        category: MonumentCategory.fromWire(json['category'] as String),
        categoryAuto: !(json['categoryOverridden'] as bool? ?? false),
        period: MonumentPeriod.fromWire(json['period'] as String),
        cityCode: (json['cityCode'] as num).toInt(),
        district: _string(json['district']),
        address: _string(json['address']),
        latitude: latitude,
        longitude: longitude,
        unesco: json['isUnescoWorldHeritage'] as bool? ?? false,
        isActive: json['isActive'] as bool? ?? true,
        tr: _text(_map(translations?['tr'])),
        en: _text(_map(translations?['en'])),
        parts: [
          for (final part in parts)
            MonumentPart(
              titleTr: _string(
                _map(_map(part['translations'])?['tr'])?['title'],
              ),
              titleEn: _string(
                _map(_map(part['translations'])?['en'])?['title'],
              ),
              descriptionTr: _string(
                _map(_map(part['translations'])?['tr'])?['description'],
              ),
              descriptionEn: _string(
                _map(_map(part['translations'])?['en'])?['description'],
              ),
            ),
        ],
        images: [
          ..._images(json['images']),
          for (final (index, part) in parts.indexed)
            ..._images(part['images'], part: index),
        ],
        complexId: _string(complex?['key']),
        complexOrder: (complex?['position'] as num?)?.toInt(),
      ),
      complexName: complex?['name'] as String?,
      publication: _publication(json['publication']),
      archivedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  /// `AdminComplexDetail`: `complex` türünde taslak + yapılar (sırasıyla).
  static CatalogMonument parseComplex(Map<String, dynamic> json) {
    final name = _map(json['name']);
    final (latitude, longitude) = _location(json['location']);
    return CatalogMonument(
      draft: MonumentDraft(
        id: json['key'] as String,
        category: MonumentCategory.complex,
        categoryAuto: false,
        cityCode: (json['cityCode'] as num).toInt(),
        district: _string(json['district']),
        address: _string(json['address']),
        latitude: latitude,
        longitude: longitude,
        isActive: json['isActive'] as bool? ?? true,
        tr: MonumentText(name: _string(name?['tr'])),
        en: MonumentText(name: _string(name?['en'])),
        images: _images(json['images']),
      ),
      members: [
        for (final member
            in (json['works'] as List<dynamic>? ?? const [])
                .cast<Map<String, dynamic>>())
          ComplexMember(
            id: member['key'] as String,
            name: member['title'] as String? ?? member['key'] as String,
            order: (member['position'] as num?)?.toInt(),
            archived: member['publication'] == 'archived',
          ),
      ],
      publication: _publication(json['publication']),
      archivedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  static CatalogMonumentSummary _workSummary(Map<String, dynamic> item) {
    final title = _map(item['title']);
    final city = _map(item['city']);
    final complex = _map(item['complex']);
    return CatalogMonumentSummary(
      id: item['key'] as String,
      nameTr: _string(title?['tr']),
      nameEn: title?['en'] as String?,
      category: MonumentCategory.fromWire(item['category'] as String),
      period: MonumentPeriod.fromWire(item['period'] as String),
      city: _string(city?['name']),
      district: _string(item['district']),
      thumbnailUrl: item['thumbnailUrl'] as String?,
      imageCount: (item['imageCount'] as num?)?.toInt() ?? 0,
      complexId: complex?['key'] as String?,
      complexName: complex?['name'] as String?,
      publication: _publication(item['publication']),
      updatedAt: DateTime.parse(item['updatedAt'] as String),
      hasLocation: item['hasLocation'] as bool? ?? false,
    );
  }

  static CatalogMonumentSummary _complexSummary(Map<String, dynamic> item) {
    final name = _map(item['name']);
    return CatalogMonumentSummary(
      id: item['key'] as String,
      nameTr: _string(name?['tr']),
      nameEn: name?['en'] as String?,
      category: MonumentCategory.complex,
      period: MonumentPeriod.other,
      city: TurkishProvinces.nameOf((item['cityCode'] as num?)?.toInt()),
      district: _string(item['district']),
      imageCount: 0,
      memberCount: (item['workCount'] as num?)?.toInt() ?? 0,
      publication: _publication(item['publication']),
      updatedAt: DateTime.parse(item['updatedAt'] as String),
      hasLocation: item['hasLocation'] as bool? ?? false,
    );
  }

  /// Külliye listesi sayfasızdır (az kayıt); metin, yayın ve konum
  /// süzgeçleri burada uygulanır.
  static bool _complexMatches(CatalogMonumentSummary complex, CatalogFilter f) {
    final terms = TurkishText.fold(f.query)
        .split(RegExp(r'\s+'))
        .where((t) => t.isNotEmpty);
    final haystack = TurkishText.fold(
      '${complex.nameTr} ${complex.nameEn ?? ''} ${complex.id} '
      '${complex.city} ${complex.district}',
    );
    return terms.every(haystack.contains) &&
        (f.publication == null || f.publication == complex.publication) &&
        switch (f.location) {
          null => true,
          LocationFilter.present => complex.hasLocation,
          LocationFilter.missing => !complex.hasLocation,
        };
  }

  // ---------------------------------------------------------------------
  // Yazma gövdeleri
  // ---------------------------------------------------------------------

  static String? _optional(String value) =>
      value.trim().isEmpty ? null : value.trim();

  static Map<String, Object?>? _locationBody(MonumentDraft draft) =>
      draft.hasLocation
      ? {'latitude': draft.latitude, 'longitude': draft.longitude}
      : null;

  /// `AdminImageInput`: içerik adresli dosya, değilse kaynak adresi.
  static Map<String, Object?> imageBody(MonumentImage image) => {
    if (image.sha256 != null)
      'sha256': image.sha256
    else
      'url': image.originUrl ?? image.url,
    'attribution': {
      'author': _optional(image.author),
      'license': _optional(image.license),
      'sourceName': _optional(image.sourceName),
      'sourceUrl': _optional(image.sourceUrl),
    },
    'translations': {
      'tr': {
        'altText': _optional(image.altTr),
        'title': _optional(image.titleTr),
      },
      'en': {
        'altText': _optional(image.altEn),
        'title': _optional(image.titleEn),
      },
    },
  };

  /// `AdminWorkInput`. Üyelik külliyeden yönetilir, burada gönderilmez.
  static Map<String, Object?> workBody(
    MonumentDraft draft, {
    required bool creating,
  }) {
    Map<String, Object?>? text(MonumentText t) {
      final fields = {
        'slug': _optional(t.slug),
        'title': _optional(t.name),
        'nickname': _optional(t.nickname),
        'shortDescriptionTitle': _optional(t.shortDescriptionTitle),
        'shortDescription': _optional(t.shortDescription),
        'history': _optional(t.history),
        'constructionDate': _optional(t.constructionDate),
        'founder': _optional(t.founder),
        'architect': _optional(t.architect),
      };
      return fields.values.every((v) => v == null) ? null : fields;
    }

    return {
      if (creating) 'key': draft.id.trim(),
      'cityCode': draft.cityCode,
      'district': _optional(draft.district),
      'address': _optional(draft.address),
      'category': draft.categoryAuto ? null : draft.category.name,
      'period': draft.period.name,
      'isUnescoWorldHeritage': draft.unesco,
      'location': _locationBody(draft),
      'isActive': draft.isActive,
      'translations': {'tr': text(draft.tr), 'en': text(draft.en)},
      'images': [
        for (final image in draft.images)
          if (image.part == null) imageBody(image),
      ],
      'parts': [
        for (final (index, part) in draft.parts.indexed)
          {
            'translations': {
              'tr': {
                'title': _optional(part.titleTr),
                'description': _optional(part.descriptionTr),
              },
              'en': {
                'title': _optional(part.titleEn),
                'description': _optional(part.descriptionEn),
              },
            },
            'images': [
              for (final image in draft.images)
                if (image.part == index) imageBody(image),
            ],
          },
      ],
    };
  }

  /// `AdminComplexInput`. Yapılar ayrıca (`PUT complexes/{key}/works`).
  static Map<String, Object?> complexBody(
    MonumentDraft draft, {
    required bool creating,
  }) => {
    if (creating) 'key': draft.id.trim(),
    'name': {'tr': _optional(draft.tr.name), 'en': _optional(draft.en.name)},
    'cityCode': draft.cityCode,
    'district': _optional(draft.district),
    'address': _optional(draft.address),
    'location': _locationBody(draft),
    'isActive': draft.isActive,
    'images': [for (final image in draft.images) imageBody(image)],
  };

  static Map<String, Object?> body(
    MonumentDraft draft, {
    required bool creating,
  }) => draft.isComplex
      ? complexBody(draft, creating: creating)
      : workBody(draft, creating: creating);

  // ---------------------------------------------------------------------
  // İstekler
  // ---------------------------------------------------------------------

  static String _collection({required bool complex}) =>
      complex ? '$_base/complexes' : '$_base/works';

  static String _record(
    String id, {
    required bool complex,
    String suffix = '',
  }) => '${_collection(complex: complex)}/${Uri.encodeComponent(id)}$suffix';

  Versioned<CatalogMonument> _versioned(
    Response<Map<String, dynamic>> response, {
    required bool complex,
  }) => Versioned(
    complex ? parseComplex(response.data!) : parseWork(response.data!),
    Preconditions.etagOf(response),
  );

  @override
  ResultFuture<Paged<CatalogMonumentSummary>> list(
    CatalogFilter filter, {
    String? cursor,
  }) => guardApi(() async {
    final wantsComplexes =
        (filter.categories.isEmpty ||
            filter.categories.contains(MonumentCategory.complex)) &&
        filter.periods.isEmpty;
    final wantsWorks =
        filter.categories.any((c) => c != MonumentCategory.complex) ||
        filter.categories.isEmpty;

    // Külliyeler (sayfasız) ilk sayfanın başında; toplamın her sayfada aynı
    // kalması için sayıları her sayfada alınır (küçük liste).
    final complexes = <CatalogMonumentSummary>[];
    if (wantsComplexes) {
      final response = await _dio.get<List<dynamic>>('$_base/complexes');
      complexes.addAll([
        for (final item in response.data!.cast<Map<String, dynamic>>())
          if (_complexSummary(item) case final complex
              when _complexMatches(complex, filter))
            complex,
      ]);
    }
    if (!wantsWorks) {
      return Paged(items: complexes, total: complexes.length);
    }
    final response = await _dio.get<Map<String, dynamic>>(
      '$_base/works',
      queryParameters: query(filter, cursor),
    );
    final json = response.data!;
    final total = (json['total'] as num).toInt();
    return Paged(
      items: [
        if (cursor == null) ...complexes,
        for (final item
            in (json['items'] as List<dynamic>).cast<Map<String, dynamic>>())
          _workSummary(item),
      ],
      total: total + complexes.length,
      nextCursor: json['nextCursor'] as String?,
    );
  });

  /// Anahtar bir eserin değilse (404) külliye olarak denenir.
  @override
  ResultFuture<Versioned<CatalogMonument>> get(String id) => guardApi(() async {
    try {
      return _versioned(
        await _dio.get<Map<String, dynamic>>(_record(id, complex: false)),
        complex: false,
      );
    } on DioException catch (error) {
      if (error.response?.statusCode != 404) {
        rethrow;
      }
      return _versioned(
        await _dio.get<Map<String, dynamic>>(_record(id, complex: true)),
        complex: true,
      );
    }
  });

  @override
  ResultFuture<Versioned<CatalogMonument>> create(
    MonumentDraft draft, {
    required String idempotencyKey,
  }) => guardApi(
    () async => _versioned(
      await _dio.post<Map<String, dynamic>>(
        _collection(complex: draft.isComplex),
        data: body(draft, creating: true),
        options: Preconditions.idempotent(idempotencyKey),
      ),
      complex: draft.isComplex,
    ),
  );

  @override
  ResultFuture<Versioned<CatalogMonument>> update(
    MonumentDraft draft, {
    required String etag,
  }) => guardApi(
    () async => _versioned(
      await _dio.put<Map<String, dynamic>>(
        _record(draft.id, complex: draft.isComplex),
        data: body(draft, creating: false),
        options: Preconditions.ifMatch(etag),
      ),
      complex: draft.isComplex,
    ),
  );

  @override
  ResultFuture<Versioned<CatalogMonument>> setPublication(
    String id, {
    required bool complex,
    required String etag,
    required Publication publication,
  }) => guardApi(() async {
    final options = Preconditions.ifMatch(etag);
    final response = publication == Publication.archived
        ? await _dio.delete<Map<String, dynamic>>(
            _record(id, complex: complex),
            options: options,
          )
        : await _dio.post<Map<String, dynamic>>(
            _record(id, complex: complex, suffix: '/restore'),
            options: options,
          );
    return _versioned(response, complex: complex);
  });

  @override
  ResultFuture<Versioned<CatalogMonument>> setComplexMembers(
    String complexId, {
    required String etag,
    required List<String> memberIds,
  }) => guardApi(
    () async => _versioned(
      await _dio.put<Map<String, dynamic>>(
        _record(complexId, complex: true, suffix: '/works'),
        data: {'workKeys': memberIds},
        options: Preconditions.ifMatch(etag),
      ),
      complex: true,
    ),
  );

  /// İçerik adresli yükleme (`PUT imports/images/{sha256}`): kayıtta
  /// `sha256` ile başvurulur ve sonraki kayıtlarda da aynı özetle yeniden
  /// gönderilebilir (bilet yüklemesinin kalıcı bir başvurusu yoktur).
  /// Aynı dosya zaten varsa sunucu 200 döner.
  @override
  ResultFuture<String> uploadImage(PreparedImage image) => guardApi(() async {
    final hash = sha256.convert(image.bytes).toString();
    await _dio.put<void>(
      '$_base/imports/images/$hash',
      data: Stream.fromIterable([image.bytes]),
      options: Options(
        headers: {
          Headers.contentTypeHeader: 'image/jpeg',
          Headers.contentLengthHeader: image.bytes.length,
        },
      ),
    );
    return hash;
  });
}
