import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas_admin/core/error/exceptions.dart';
import 'package:vakif_atlas_admin/core/network/preconditions.dart';

Response<dynamic> _response(Map<String, List<String>> headers) => Response(
  requestOptions: RequestOptions(),
  headers: Headers.fromMap(headers),
);

void main() {
  group('Preconditions.etagOf', () {
    test('güçlü ETag olduğu gibi döner', () {
      expect(
        Preconditions.etagOf(
          _response({
            'etag': ['"abc"'],
          }),
        ),
        '"abc"',
      );
    });

    test('sıkıştıran ara katmanın zayıflattığı ETag güçlüye çevrilir', () {
      expect(
        Preconditions.etagOf(
          _response({
            'etag': ['W/"abc"'],
          }),
        ),
        '"abc"',
      );
    });

    test('ETag yoksa sözleşme ihlalidir', () {
      expect(
        () => Preconditions.etagOf(_response({})),
        throwsA(isA<UnexpectedException>()),
      );
    });
  });
}
