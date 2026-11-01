import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas_admin/core/network/api_guard.dart';
import 'package:vakif_atlas_admin/core/network/network_constants.dart';
import 'package:vakif_atlas_admin/core/network/preconditions.dart';
import 'package:vakif_atlas_admin/core/utils/typedefs.dart';
import 'package:vakif_atlas_admin/features/catalog/domain/catalog_import.dart';

@LazySingleton(as: CatalogImportRepository)
class CatalogImportRepositoryImpl implements CatalogImportRepository {
  CatalogImportRepositoryImpl(@Named(DioNames.api) this._dio);

  final Dio _dio;

  static const String _base = 'catalog/admin/imports';

  /// ~6 MB dosyanın gönderimi ve 750+ kaydın tek işlemde yazımı olağan
  /// istek sürelerinden uzundur.
  static const Duration _long = Duration(minutes: 3);

  static ImportIssue _issue(Map<String, dynamic> json) => ImportIssue(
    path: json['path'] as String,
    code: json['code'] as String,
    detail: json['detail'] as String?,
  );

  static ImportPlan parse(Map<String, dynamic> json) {
    final counts = json['counts'] as Map<String, dynamic>?;
    final result = json['result'] as Map<String, dynamic>?;
    List<ImportIssue> issues(String key) => [
      for (final item
          in (json[key] as List<dynamic>? ?? const [])
              .cast<Map<String, dynamic>>())
        _issue(item),
    ];
    return ImportPlan(
      valid: json['valid'] as bool,
      counts: counts == null
          ? null
          : ImportCounts(
              complexes: counts['complexes'] as int,
              works: counts['works'] as int,
              parts: counts['parts'] as int,
              images: counts['images'] as int,
              uniqueImages: counts['uniqueImages'] as int,
              created: counts['newWorks'] as int,
              existing: counts['existingWorks'] as int,
            ),
      missingImages: (json['missingImages'] as List<dynamic>? ?? const [])
          .cast<String>(),
      errors: issues('errors'),
      warnings: issues('warnings'),
      warningCount: json['warningCount'] as int? ?? 0,
      result: result == null
          ? null
          : ImportResult(
              created: result['createdWorks'] as int,
              updated: result['updatedWorks'] as int,
              createdComplexes: result['createdComplexes'] as int,
              updatedComplexes: result['updatedComplexes'] as int,
              catalogVersion: result['catalogVersion'] as String,
            ),
    );
  }

  /// Dosya olduğu gibi gönderilir (sunucu şemayı katı uygular); JSON metni
  /// yeniden kodlanmadan gövdeye yerleştirilir.
  static String _body(SeedFolder folder) {
    final hashes = StringBuffer('{');
    var first = true;
    for (final entry in folder.hashes.entries) {
      hashes
        ..write(first ? '' : ',')
        ..write('"${_escape(entry.key)}":"${entry.value}"');
      first = false;
    }
    hashes.write('}');
    return '{"file":${folder.json},"images":$hashes}';
  }

  @override
  ResultFuture<ImportPlan> plan(SeedFolder folder) => guardApi(() async {
    final response = await _dio.post<Map<String, dynamic>>(
      '$_base/validate',
      data: _body(folder),
      options: Options(
        contentType: Headers.jsonContentType,
        sendTimeout: _long,
        receiveTimeout: _long,
      ),
    );
    return parse(response.data!);
  });

  @override
  ResultFuture<void> uploadImage(String sha256, SeedImageFile file) =>
      guardApi(() async {
        final bytes = await File(file.path).readAsBytes();
        await _dio.put<void>(
          '$_base/images/$sha256',
          data: Stream.fromIterable([bytes]),
          options: Options(
            sendTimeout: _long,
            receiveTimeout: _long,
            headers: {
              Headers.contentTypeHeader: file.contentType,
              Headers.contentLengthHeader: bytes.length,
            },
          ),
        );
      });

  /// Eksik görselde (409) plan gövdesi döner: hata değil, güncel plan olarak
  /// gösterilir (yalnızca eksikler yeniden yüklenir).
  @override
  ResultFuture<ImportPlan> commit(
    SeedFolder folder, {
    required String idempotencyKey,
  }) => guardApi(() async {
    final response = await _dio.post<Map<String, dynamic>>(
      '$_base/commit',
      data: _body(folder),
      options: Preconditions.idempotent(idempotencyKey).copyWith(
        contentType: Headers.jsonContentType,
        sendTimeout: _long,
        receiveTimeout: _long,
        validateStatus: (status) =>
            status != null && (status < 300 || status == 409),
      ),
    );
    return parse(response.data!);
  });

  /// Görsel yolu şemaya göre yalnızca `[a-z0-9-/.]`; yine de JSON için kaçışlanır.
  static String _escape(String value) =>
      value.replaceAll(r'\', r'\\').replaceAll('"', r'\"');
}
