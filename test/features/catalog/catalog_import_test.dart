import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas_admin/core/di/injection.dart';
import 'package:vakif_atlas_admin/features/catalog/data/seed_folder_reader_impl.dart';
import 'package:vakif_atlas_admin/features/catalog/presentation/catalog_import_cubit.dart';

import '../../helpers/test_di.dart';
import '../../support/fake_backend.dart';

/// VGM verisinin içe aktarımı (ADR 59): klasör okuma, plan, görsel yükleme, onay.
void main() {
  late FakeBackend backend;
  late Directory folder;
  final photo = List<int>.generate(2048, (i) => i % 251);
  final sha = sha256.convert(photo).toString();

  Map<String, Object?> data({String src = 'images/works/yesil-camii/1.jpg'}) =>
      {
        'formatVersion': 1,
        'complexes': <Object>[],
        'works': [
          {
            'key': 'yesil-camii',
            'cityCode': 16,
            'translations': {
              'tr': {'title': 'Yeşil Camii'},
            },
            'images': [
              {'src': src},
              // Aynı dosya iki yolda: bir kez yüklenir.
              {'src': 'images/works/yesil-camii/2.jpg'},
            ],
          },
        ],
      };

  /// `ImportPlan` (sunucu durumsuzdur: plan kimliği yok).
  Map<String, Object?> plan({List<String>? missing, Object? result}) => {
    'valid': true,
    'counts': {
      'complexes': 0,
      'works': 1,
      'parts': 0,
      'images': 2,
      'uniqueImages': 1,
      'newWorks': 1,
      'existingWorks': 0,
    },
    'missingImages': missing ?? [sha],
    'errors': <Object>[],
    'warnings': [
      {'path': 'works[0].address', 'code': 'no_district'},
    ],
    'warningCount': 1,
    'result': ?result,
  };

  setUp(() async {
    backend = FakeBackend();
    await TestDependencies.setUp(transport: (_) => FakeHttpTransport(backend));
    folder = await Directory.systemTemp.createTemp('vgm-import');
    final images = Directory('${folder.path}/images/works/yesil-camii')
      ..createSync(recursive: true);
    File('${images.path}/1.jpg').writeAsBytesSync(photo);
    File('${images.path}/2.jpg').writeAsBytesSync(photo);
    File('${folder.path}/root42-veri.schema.json').writeAsStringSync('{}');
  });

  tearDown(() async {
    await resetDependencies();
    await folder.delete(recursive: true);
  });

  test('klasörü okur, planı alır, eksik görseli yükler ve onaylar', () async {
    File('${folder.path}/root42-veri.json')
        .writeAsStringSync(jsonEncode(data()));
    backend
      ..on(
        'POST',
        'catalog/admin/imports/validate',
        (_) => FakeResponse(200, plan()),
      )
      ..on(
        'PUT',
        'catalog/admin/imports/images/:sha',
        (_) => FakeResponse(201, {'sha256': sha}),
      )
      ..on(
        'POST',
        'catalog/admin/imports/commit',
        (_) => FakeResponse(
          200,
          plan(
            missing: [],
            result: {
              'createdComplexes': 0,
              'updatedComplexes': 0,
              'createdWorks': 1,
              'updatedWorks': 0,
              'catalogVersion': '3',
            },
          ),
        ),
      );
    final cubit = getIt<CatalogImportCubit>();

    // Şema dosyası aday sayılmaz: tek veri dosyası kendiliğinden okunur.
    await cubit.selectFolder(folder.path);
    expect(cubit.state.jsonFiles, hasLength(1));
    expect(cubit.state.stage, ImportStage.planned);
    expect(cubit.state.seed!.files, hasLength(1));
    final request = backend.last('POST', 'catalog/admin/imports/validate')!;
    final body = request.body! as Map<String, dynamic>;
    expect((body['file'] as Map)['works'], hasLength(1));
    expect(body['images'], {
      'images/works/yesil-camii/1.jpg': sha,
      'images/works/yesil-camii/2.jpg': sha,
    });
    expect(cubit.state.plan!.warnings.single.code, 'no_district');

    await cubit.start();

    final upload = backend.last('PUT', 'catalog/admin/imports/images/$sha')!;
    expect(upload.headers['content-type'], 'image/jpeg');
    expect(upload.body, photo);
    expect(cubit.state.stage, ImportStage.done);
    expect(cubit.state.uploaded, 1);
    expect(cubit.state.plan!.result!.created, 1);
    // Onay aynı gövdeyi (dosya + özetler) yeniden gönderir.
    final commit = backend.last('POST', 'catalog/admin/imports/commit')!;
    expect(commit.headers['idempotency-key'], isNotEmpty);
    expect((commit.body! as Map<String, dynamic>)['images'], body['images']);
    await cubit.close();
  });

  test(
    'eksik görsel dosyası sunucuya gitmeden hata olarak gösterilir',
    () async {
      File('${folder.path}/root42-veri.json').writeAsStringSync(
        jsonEncode(data(src: 'images/works/yesil-camii/yok.jpg')),
      );
      final cubit = getIt<CatalogImportCubit>();

      await cubit.selectFolder(folder.path);

      expect(cubit.state.plan!.valid, isFalse);
      expect(cubit.state.plan!.errors.single.code, 'missing_file');
      expect(cubit.state.canStart, isFalse);
      expect(backend.requests, isEmpty);
      await cubit.close();
    },
  );

  test('yüklenemeyen görselde onaya geçilmez, plan yenilenir', () async {
    File('${folder.path}/root42-veri.json')
        .writeAsStringSync(jsonEncode(data()));
    backend
      ..on(
        'POST',
        'catalog/admin/imports/validate',
        (_) => FakeResponse(200, plan()),
      )
      ..on(
        'PUT',
        'catalog/admin/imports/images/:sha',
        (_) => FakeResponse.error(400, 'invalid_upload'),
      );
    final cubit = getIt<CatalogImportCubit>();
    await cubit.selectFolder(folder.path);

    await cubit.start();

    expect(cubit.state.stage, ImportStage.planned);
    expect(cubit.state.uploadFailed, 1);
    expect(cubit.state.failure, isNotNull);
    expect(backend.last('POST', 'catalog/admin/imports/commit'), isNull);
    // İlk plan + yenileme.
    expect(
      backend.requests.where((r) => r.path == 'catalog/admin/imports/validate'),
      hasLength(2),
    );
    await cubit.close();
  });

  test('görsel yolları külliye, eser ve bölümlerden toplanır', () {
    final sources = [
      for (final (path, src) in SeedFolderReaderImpl.sources({
        'complexes': [
          {
            'images': [
              {'src': 'images/complexes/k/1.jpg'},
            ],
          },
        ],
        'works': [
          {
            'images': [
              {'src': 'images/works/w/1.jpg'},
            ],
            'parts': [
              {
                'images': [
                  {'src': 'images/works/w/bolum-1-1.webp'},
                ],
              },
            ],
          },
        ],
      }))
        '$path=$src',
    ];
    expect(sources, [
      'complexes[0].images[0].src=images/complexes/k/1.jpg',
      'works[0].images[0].src=images/works/w/1.jpg',
      'works[0].parts[0].images[0].src=images/works/w/bolum-1-1.webp',
    ]);
  });
}
