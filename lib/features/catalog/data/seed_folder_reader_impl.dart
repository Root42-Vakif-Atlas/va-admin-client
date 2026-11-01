import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as p;
import 'package:vakif_atlas_admin/core/error/failures.dart';
import 'package:vakif_atlas_admin/core/utils/either.dart';
import 'package:vakif_atlas_admin/core/utils/typedefs.dart';
import 'package:vakif_atlas_admin/features/catalog/domain/catalog_import.dart';

/// VGM klasörünü okur: veri dosyası + görsel yolları (`src`, dosyaya göre
/// göreli) → SHA-256. Özetler isolate'te hesaplanır (~350 MB, arayüz donmaz).
@LazySingleton(as: SeedFolderReader)
class SeedFolderReaderImpl implements SeedFolderReader {
  /// Şema: görsel başına en çok 5 MB.
  static const int maxImageBytes = 5 * 1024 * 1024;

  @override
  Future<List<String>> jsonFiles(String folder) async {
    final directory = Directory(folder);
    if (!directory.existsSync()) {
      return const [];
    }
    final files = [
      for (final entity in directory.listSync())
        if (entity is File &&
            entity.path.toLowerCase().endsWith('.json') &&
            !entity.path.toLowerCase().endsWith('.schema.json'))
          entity.path,
    ]..sort();
    return files;
  }

  @override
  ResultFuture<SeedFolder> read(String jsonPath) async {
    try {
      final json = await File(jsonPath).readAsString();
      final folder = await compute(_scan, (jsonPath: jsonPath, json: json));
      return Right(folder);
    } on FileSystemException {
      return const Left(CacheFailure());
    } on FormatException {
      return Right(
        SeedFolder(
          jsonPath: jsonPath,
          json: '',
          hashes: const {},
          files: const {},
          issues: const [ImportIssue(path: r'$', code: 'invalid_json')],
        ),
      );
    }
  }

  static SeedFolder _scan(({String jsonPath, String json}) input) {
    final root = jsonDecode(input.json);
    if (root is! Map<String, dynamic>) {
      throw const FormatException('root');
    }
    final base = p.dirname(input.jsonPath);
    final hashes = <String, String>{};
    final files = <String, SeedImageFile>{};
    final issues = <ImportIssue>[];
    for (final (path, src) in sources(root)) {
      if (hashes.containsKey(src)) {
        continue;
      }
      // Yol klasör dışına çıkamaz (şema da yalnızca [a-z0-9-/] izin verir).
      final file = File(p.normalize(p.join(base, src)));
      if (src.contains('..') || p.isAbsolute(src) || !file.existsSync()) {
        issues.add(ImportIssue(path: path, code: 'missing_file', detail: src));
        continue;
      }
      final size = file.lengthSync();
      if (size > maxImageBytes) {
        issues.add(
          ImportIssue(path: path, code: 'file_too_large', detail: src),
        );
        continue;
      }
      final sha = sha256.convert(file.readAsBytesSync()).toString();
      hashes[src] = sha;
      files.putIfAbsent(
        sha,
        () => SeedImageFile(
          path: file.path,
          byteSize: size,
          contentType: contentType(src),
        ),
      );
    }
    return SeedFolder(
      jsonPath: input.jsonPath,
      json: input.json,
      hashes: hashes,
      files: files,
      issues: issues,
    );
  }

  /// Dosyadaki her görselin yeri ve yolu (külliyeler, eserler, bölümler).
  @visibleForTesting
  static Iterable<(String, String)> sources(Map<String, dynamic> root) sync* {
    Iterable<(String, String)> images(Object? list, String path) sync* {
      if (list is! List) {
        return;
      }
      for (var i = 0; i < list.length; i++) {
        final src = (list[i] as Map?)?['src'];
        if (src is String) {
          yield ('$path[$i].src', src);
        }
      }
    }

    final complexes = root['complexes'];
    if (complexes is List) {
      for (var i = 0; i < complexes.length; i++) {
        yield* images(
          (complexes[i] as Map?)?['images'],
          'complexes[$i].images',
        );
      }
    }
    final works = root['works'];
    if (works is List) {
      for (var i = 0; i < works.length; i++) {
        final work = works[i] as Map?;
        yield* images(work?['images'], 'works[$i].images');
        final parts = work?['parts'];
        if (parts is List) {
          for (var j = 0; j < parts.length; j++) {
            yield* images(
              (parts[j] as Map?)?['images'],
              'works[$i].parts[$j].images',
            );
          }
        }
      }
    }
  }

  @visibleForTesting
  static String contentType(String src) => switch (p.extension(src)) {
    '.png' => 'image/png',
    '.webp' => 'image/webp',
    _ => 'image/jpeg',
  };
}
