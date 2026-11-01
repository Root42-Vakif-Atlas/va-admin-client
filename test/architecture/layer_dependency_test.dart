import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Clean Architecture bağımlılık kurallarını kaynak kod üzerinden doğrular.
///
/// - Domain dosyaları "saf Dart" olmalıdır: yalnızca izinli `dart:`
///   kütüphanelerini ve yine saf Dart olan proje dosyalarını içe aktarabilir.
/// - Presentation hiçbir feature'ın Data katmanını içe aktaramaz.
/// - `core/` feature'lara bağımlı olamaz (kompozisyon kökleri hariç).
void main() {
  final graph = _ImportGraph.load(Directory('lib'));

  test('Domain katmanı saf Dart kodudur', () {
    final violations = <String>[];
    for (final file in graph.files.where(_isDomainFile)) {
      for (final dependency in graph.importsOf(file)) {
        if (!graph.isPure(dependency)) {
          violations.add('$file → $dependency');
        }
      }
    }
    expect(violations, isEmpty, reason: violations.join('\n'));
  });

  test('Domain, Data veya Presentation katmanını içe aktarmaz', () {
    final violations = [
      for (final file in graph.files.where(_isDomainFile))
        for (final dependency in graph.importsOf(file))
          if (dependency.contains('/data/') ||
              dependency.contains('/presentation/'))
            '$file → $dependency',
    ];
    expect(violations, isEmpty, reason: violations.join('\n'));
  });

  test('Presentation, Data katmanını içe aktarmaz', () {
    final violations = [
      for (final file in graph.files.where((f) => f.contains('/presentation/')))
        for (final dependency in graph.importsOf(file))
          if (dependency.startsWith('lib/features/') &&
              dependency.contains('/data/'))
            '$file → $dependency',
    ];
    expect(violations, isEmpty, reason: violations.join('\n'));
  });

  test('core/ yalnızca kompozisyon köklerinde feature içe aktarır', () {
    const compositionRoots = ['lib/core/di/', 'lib/core/router/'];
    final violations = [
      for (final file in graph.files.where(
        (f) =>
            f.startsWith('lib/core/') &&
            !compositionRoots.any((root) => f.startsWith(root)),
      ))
        for (final dependency in graph.importsOf(file))
          if (dependency.startsWith('lib/features/')) '$file → $dependency',
    ];
    expect(violations, isEmpty, reason: violations.join('\n'));
  });

  test('Çekirdek fonksiyonel tipler saf Dart kodudur', () {
    for (final file in const [
      'lib/core/utils/either.dart',
      'lib/core/utils/typedefs.dart',
      'lib/core/error/failures.dart',
      'lib/core/usecase/usecase.dart',
      'lib/core/utils/turkish_text.dart',
    ]) {
      expect(graph.isPure(file), isTrue, reason: file);
    }
  });
}

bool _isDomainFile(String path) =>
    path.startsWith('lib/features/') && path.contains('/domain/');

class _ImportGraph {
  _ImportGraph(this._imports);

  factory _ImportGraph.load(Directory root) {
    final imports = <String, Set<String>>{};
    final dartFiles = root
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'));

    for (final file in dartFiles) {
      final path = _normalize(file.path);
      final source = file.readAsStringSync();
      imports[path] = {
        for (final match in _directive.allMatches(source))
          _resolve(match.group(1)!, path),
      };
    }
    return _ImportGraph(imports);
  }

  static final RegExp _directive = RegExp(
    r'''^\s*(?:import|export)\s+['"]([^'"]+)['"]''',
    multiLine: true,
  );

  static const String _packagePrefix = 'package:vakif_atlas_admin/';

  static const Set<String> _pureDartLibraries = {
    'dart:async',
    'dart:collection',
    'dart:convert',
    'dart:core',
    'dart:math',
    'dart:typed_data',
  };

  final Map<String, Set<String>> _imports;
  final Map<String, bool> _purity = {};

  Iterable<String> get files => _imports.keys;

  Set<String> importsOf(String file) => _imports[file] ?? const {};

  /// Bir dosya, yalnızca izinli `dart:` kütüphanelerini ve saf proje
  /// dosyalarını içe aktarıyorsa saf Dart kabul edilir.
  bool isPure(String file) {
    if (file.startsWith('dart:')) {
      return _pureDartLibraries.contains(file);
    }
    if (!file.startsWith('lib/')) {
      return false;
    }
    final cached = _purity[file];
    if (cached != null) {
      return cached;
    }
    // Döngüsel içe aktarmalarda sonsuz özyinelemeyi önler.
    _purity[file] = true;
    final pure = importsOf(file).every(isPure);
    _purity[file] = pure;
    return pure;
  }

  static String _normalize(String path) =>
      path.replaceAll(r'\', '/').replaceFirst(RegExp(r'^\./'), '');

  static String _resolve(String uri, String fromFile) {
    if (uri.startsWith('dart:')) {
      return uri;
    }
    if (uri.startsWith(_packagePrefix)) {
      return 'lib/${uri.substring(_packagePrefix.length)}';
    }
    if (uri.startsWith('package:')) {
      return uri;
    }
    final base = Uri.file(fromFile);
    return _normalize(base.resolve(uri).toFilePath());
  }
}
