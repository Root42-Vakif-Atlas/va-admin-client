import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:vakif_atlas_admin/core/network/http_transport.dart';

/// Sahte backend'e gelen istek.
final class FakeRequest {
  const FakeRequest({
    required this.method,
    required this.path,
    required this.query,
    required this.headers,
    required this.body,
    required this.parameters,
  });

  final String method;
  final String path;
  final Map<String, String> query;
  final Map<String, String> headers;
  final Object? body;
  final Map<String, String> parameters;

  Map<String, dynamic> get json => body! as Map<String, dynamic>;
}

final class FakeResponse {
  const FakeResponse(this.status, [this.body, this.headers = const {}]);

  /// Sözleşmedeki hata gövdesi (problem+json + `code`).
  factory FakeResponse.error(int status, String code) =>
      FakeResponse(status, {'status': status, 'code': code});

  final int status;
  final Object? body;
  final Map<String, String> headers;
}

typedef FakeHandler = FakeResponse Function(FakeRequest request);

/// Testlerde ağa çıkmadan sözleşmeyle yanıt veren adaptör: uygulamanın
/// interceptor zinciri, DTO ayrıştırma ve hata eşleme birebir çalışır.
/// Yanıt başlıkları (`ETag`) ve gelen istekler ([requests]) desteklenir.
final class FakeBackend implements HttpClientAdapter {
  final List<
    (String method, RegExp pattern, List<String> names, FakeHandler handler)
  >
  _routes = [];
  final List<FakeRequest> requests = [];

  /// `path`: `catalog/admin/monuments/:id` biçimi (taban adrese göre).
  void on(String method, String path, FakeHandler handler) {
    final names = <String>[];
    final pattern = path.replaceAllMapped(RegExp(r':(\w+)'), (match) {
      names.add(match.group(1)!);
      return '([^/]+)';
    });
    // Sonradan tanımlanan yanıt öncekini ezer.
    _routes.insert(0, (
      method.toUpperCase(),
      RegExp('^$pattern\$'),
      names,
      handler,
    ));
  }

  FakeRequest? last(String method, String path) {
    for (final request in requests.reversed) {
      if (request.method == method && request.path == path) {
        return request;
      }
    }
    return null;
  }

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    Object? body;
    if (requestStream != null) {
      final bytes = await requestStream.expand((chunk) => chunk).toList();
      if (bytes.isNotEmpty) {
        final text = utf8.decode(bytes, allowMalformed: true);
        try {
          body = jsonDecode(text);
        } on FormatException {
          body = bytes;
        }
      }
    }
    final base = Uri.parse(options.baseUrl).path;
    final full = options.uri.path;
    final path = (full.startsWith(base) ? full.substring(base.length) : full)
        .replaceFirst(RegExp('^/+'), '');
    for (final (method, pattern, names, handler) in _routes) {
      final match = pattern.firstMatch(path);
      if (method != options.method.toUpperCase() || match == null) {
        continue;
      }
      final request = FakeRequest(
        method: method,
        path: path,
        query: options.uri.queryParameters,
        headers: {
          for (final MapEntry(:key, :value) in options.headers.entries)
            key.toLowerCase(): '$value',
        },
        body: body,
        parameters: {
          for (var i = 0; i < names.length; i++)
            names[i]: Uri.decodeComponent(match.group(i + 1)!),
        },
      );
      requests.add(request);
      final response = handler(request);
      return ResponseBody.fromString(
        response.body == null ? '' : jsonEncode(response.body),
        response.status,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
          for (final MapEntry(:key, :value) in response.headers.entries)
            key.toLowerCase(): [value],
        },
      );
    }
    return ResponseBody.fromString(
      jsonEncode({'code': 'not_found'}),
      404,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

/// Tüm `Dio` istemcilerini [backend]'e bağlar.
final class FakeHttpTransport implements HttpTransport {
  const FakeHttpTransport(this.backend);

  final FakeBackend backend;

  @override
  HttpClientAdapter createAdapter({
    TransportScope scope = TransportScope.api,
  }) => backend;
}

/// Seed personeli (`auth/staff/me` biçimi).
Map<String, dynamic> staffJson({
  String id = 'usr_staff_001',
  String name = 'Akın Bezatoğlu',
  List<String> roles = const ['vgm_admin'],
}) => {
  'id': id,
  'displayName': name,
  'email': 'vgm@vakifatlas.dev',
  'roles': roles,
  'mfaEnrolledAt': '2026-10-01T10:00:00Z',
  'lastLoginAt': '2026-10-22T08:00:00Z',
  'recoveryCodesRemaining': 10,
};

/// `auth/staff/login` + `mfa/verify` (kod 123456) uçlarını kurar.
void stubStaffSignIn(
  FakeBackend backend, {
  List<String> roles = const ['vgm_admin'],
}) {
  backend
    ..on('POST', 'auth/staff/login', (request) {
      final json = request.json;
      return json['password'] == 'doğru-şifre-1234'
          ? const FakeResponse(200, {
              'mfa': 'required',
              'mfaToken': 'mfa-token',
              'expiresIn': 300,
            })
          : FakeResponse.error(401, 'invalid_credentials');
    })
    ..on('POST', 'auth/staff/mfa/verify', (request) {
      if (request.json['code'] != '123456' &&
          request.json['recoveryCode'] == null) {
        return FakeResponse.error(400, 'invalid_mfa_code');
      }
      return FakeResponse(200, {
        'accessToken': 'access',
        'refreshToken': 'refresh',
        'expiresIn': 600,
        'user': staffJson(roles: roles),
        'recoveryCodes': null,
      });
    })
    ..on('POST', 'auth/logout', (_) => const FakeResponse(204))
    ..on(
      'GET',
      'auth/staff/me',
      (_) => FakeResponse(200, staffJson(roles: roles)),
    );
}
