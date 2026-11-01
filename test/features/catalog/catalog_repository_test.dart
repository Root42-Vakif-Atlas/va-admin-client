import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas_admin/core/di/injection.dart';
import 'package:vakif_atlas_admin/features/catalog/domain/catalog_entities.dart';
import 'package:vakif_atlas_admin/features/catalog/domain/catalog_repository.dart';

import '../../helpers/test_di.dart';
import '../../support/fake_backend.dart';

/// `catalog/admin/works` ve `catalog/admin/complexes` sözleşmesi: gövdeler
/// sunucunun `AdminWorkDetail` / `AdminComplexDetail` yanıtlarıyla aynıdır.
void main() {
  late FakeBackend backend;
  late CatalogRepository repository;

  Map<String, Object?> image(String sha, {Object? partTitle}) => {
    'mediaId': 1,
    'sha256': sha,
    'originUrl': null,
    'url': 'http://localhost:8080/v1/media/catalog/_import/$sha.jpg',
    'thumbnailUrl':
        'http://localhost:8080/v1/media/catalog/_import/$sha-thumb.jpg',
    'mirrored': true,
    'mirrorError': null,
    'attribution': {
      'author': 'Vakıflar Genel Müdürlüğü',
      'license': 'VGM',
      'sourceName': 'Vakıflar Genel Müdürlüğü',
      'sourceUrl': null,
    },
    'translations': {
      'tr': {'altText': 'Görsel $sha', 'title': partTitle},
      'en': {'altText': 'Image $sha', 'title': null},
    },
  };

  final work = <String, Object?>{
    'key': 'emir-sultan-camii',
    'cityCode': 16,
    'district': 'Yıldırım',
    'address': 'Emirsultan Mahallesi',
    'category': 'mosque',
    'categoryOverridden': false,
    'period': 'other',
    'isUnescoWorldHeritage': false,
    'location': null,
    'isActive': true,
    'translations': {
      'tr': {
        'slug': null,
        'title': 'Emir Sultan Camii',
        'nickname': null,
        'shortDescriptionTitle': null,
        'shortDescription': 'Kısa',
        'history': null,
        'constructionDate': null,
        'founder': null,
        'architect': null,
      },
      'en': {
        'slug': 'emir-sultan-mosque',
        'title': 'Emir Sultan Mosque',
        'nickname': null,
        'shortDescriptionTitle': null,
        'shortDescription': null,
        'history': null,
        'constructionDate': null,
        'founder': null,
        'architect': null,
      },
    },
    'images': [image('a' * 64)],
    'parts': [
      {
        'translations': {
          'tr': {'title': 'Cami', 'description': 'Metin'},
          'en': null,
        },
        'images': [image('b' * 64)],
      },
    ],
    'complex': {
      'key': 'emir-sultan-kulliyesi',
      'name': 'Emir Sultan Külliyesi',
      'position': 0,
    },
    'publication': 'published',
    'deletedAt': null,
    'updatedAt': '2026-10-31T12:56:24.799753+00:00',
  };

  final complex = <String, Object?>{
    'key': 'emir-sultan-kulliyesi',
    'name': {'tr': 'Emir Sultan Külliyesi', 'en': 'Emir Sultan Complex'},
    'cityCode': 16,
    'district': 'Yıldırım',
    'address': 'Yıldırım/Bursa',
    'location': null,
    'isActive': true,
    'images': [image('c' * 64)],
    'works': [
      {
        'key': 'emir-sultan-camii',
        'title': 'Emir Sultan Camii',
        'position': 0,
        'isActive': true,
        'hasLocation': false,
        'publication': 'published',
      },
    ],
    'publication': 'published',
    'deletedAt': null,
    'updatedAt': '2026-10-31T12:56:24.799753+00:00',
  };

  setUp(() async {
    backend = FakeBackend();
    await TestDependencies.setUp(transport: (_) => FakeHttpTransport(backend));
    repository = getIt<CatalogRepository>();
  });

  tearDown(resetDependencies);

  test('eser detayı: çeviriler, bölüm görselleri, külliye üyeliği', () async {
    backend.on(
      'GET',
      'catalog/admin/works/:key',
      (_) => FakeResponse(200, work, {'ETag': '"1"'}),
    );

    final record = (await repository.get('emir-sultan-camii')).getOrNull()!;

    final draft = record.value.draft;
    expect(record.etag, '"1"');
    expect(draft.isComplex, isFalse);
    expect(draft.categoryAuto, isTrue);
    expect(draft.city, 'Bursa');
    expect(draft.tr.name, 'Emir Sultan Camii');
    expect(draft.en.slug, 'emir-sultan-mosque');
    expect(draft.parts.single.titleTr, 'Cami');
    expect([for (final i in draft.images) i.part], [null, 0]);
    expect(draft.images.first.sha256, 'a' * 64);
    expect(draft.complexId, 'emir-sultan-kulliyesi');
    expect(record.value.complexName, 'Emir Sultan Külliyesi');
  });

  test('kaydetme gövdesi AdminWorkInput biçimindedir', () async {
    backend
      ..on(
        'GET',
        'catalog/admin/works/:key',
        (_) => FakeResponse(200, work, {'ETag': '"1"'}),
      )
      ..on(
        'PUT',
        'catalog/admin/works/:key',
        (_) => FakeResponse(200, work, {'ETag': '"2"'}),
      );
    final record = (await repository.get('emir-sultan-camii')).getOrNull()!;
    final draft = record.value.draft.copyWith(
      categoryAuto: false,
      category: MonumentCategory.tomb,
    );

    await repository.update(draft, etag: record.etag);

    final request = backend.last(
      'PUT',
      'catalog/admin/works/emir-sultan-camii',
    )!;
    expect(request.headers['if-match'], '"1"');
    final body = request.json;
    expect(body.containsKey('key'), isFalse);
    expect(body['cityCode'], 16);
    expect(body['category'], 'tomb');
    expect(body.containsKey('complex'), isFalse);
    final translations = body['translations'] as Map<String, dynamic>;
    expect((translations['en'] as Map)['slug'], 'emir-sultan-mosque');
    expect((body['images'] as List).single, {
      'sha256': 'a' * 64,
      'attribution': {
        'author': 'Vakıflar Genel Müdürlüğü',
        'license': 'VGM',
        'sourceName': 'Vakıflar Genel Müdürlüğü',
        'sourceUrl': null,
      },
      'translations': {
        'tr': {'altText': 'Görsel ${'a' * 64}', 'title': null},
        'en': {'altText': 'Image ${'a' * 64}', 'title': null},
      },
    });
    final part = (body['parts'] as List).single as Map<String, dynamic>;
    expect((part['images'] as List).single, containsPair('sha256', 'b' * 64));
  });

  test('eser olmayan anahtar külliye olarak açılır; yapılar ayrıca', () async {
    backend
      ..on(
        'GET',
        'catalog/admin/complexes/:key',
        (_) => FakeResponse(200, complex, {'ETag': '"5"'}),
      )
      ..on(
        'PUT',
        'catalog/admin/complexes/:key/works',
        (_) => FakeResponse(200, complex, {'ETag': '"6"'}),
      );

    final record = (await repository.get('emir-sultan-kulliyesi')).getOrNull()!;
    expect(record.value.draft.isComplex, isTrue);
    expect(record.value.draft.tr.name, 'Emir Sultan Külliyesi');
    expect(record.value.members!.single.id, 'emir-sultan-camii');

    await repository.setComplexMembers(
      'emir-sultan-kulliyesi',
      etag: record.etag,
      memberIds: ['emir-sultan-camii', 'emir-sultan-turbesi'],
    );
    expect(
      backend
          .last('PUT', 'catalog/admin/complexes/emir-sultan-kulliyesi/works')!
          .json,
      {
        'workKeys': ['emir-sultan-camii', 'emir-sultan-turbesi'],
      },
    );
  });

  test('liste: külliyeler ilk sayfada, eserler sayfalı', () async {
    backend
      ..on(
        'GET',
        'catalog/admin/complexes',
        (_) => const FakeResponse(200, [
          {
            'key': 'emir-sultan-kulliyesi',
            'name': {'tr': 'Emir Sultan Külliyesi', 'en': null},
            'cityCode': 16,
            'district': 'Yıldırım',
            'workCount': 4,
            'hasLocation': false,
            'isActive': true,
            'publication': 'published',
            'updatedAt': '2026-10-31T12:56:24Z',
          },
        ]),
      )
      ..on(
        'GET',
        'catalog/admin/works',
        (_) => const FakeResponse(200, {
          'items': [
            {
              'key': 'abdal-mehmed-camii',
              'title': {
                'tr': 'Abdal Mehmed Camii',
                'en': 'Abdal Mehmed Mosque',
              },
              'category': 'mosque',
              'period': 'other',
              'city': {'code': 16, 'name': 'Bursa'},
              'district': 'Osmangazi',
              'thumbnailUrl': null,
              'imageCount': 3,
              'hasLocation': false,
              'complex': null,
              'isActive': true,
              'publication': 'published',
              'updatedAt': '2026-10-31T12:56:24Z',
            },
          ],
          'total': 340,
          'nextCursor': 'c2',
        }),
      );

    final first = (await repository.list(const CatalogFilter())).getOrNull()!;
    expect(first.items.map((i) => i.id), [
      'emir-sultan-kulliyesi',
      'abdal-mehmed-camii',
    ]);
    expect(first.items.first.memberCount, 4);
    expect(first.items.first.city, 'Bursa');
    expect(first.total, 341);

    final next = (await repository.list(
      const CatalogFilter(),
      cursor: 'c2',
    )).getOrNull()!;
    expect(next.items.map((i) => i.id), ['abdal-mehmed-camii']);
    expect(next.total, 341);

    // Yalnızca eser türleri: külliye listesi istenmez, `complex` gönderilmez.
    backend.requests.clear();
    await repository.list(
      const CatalogFilter(categories: {MonumentCategory.mosque}),
    );
    expect(backend.requests.map((r) => r.path), ['catalog/admin/works']);
    expect(backend.requests.single.query['category'], 'mosque');
  });
}
