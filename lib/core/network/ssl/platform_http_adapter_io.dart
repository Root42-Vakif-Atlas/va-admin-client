import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:vakif_atlas_admin/core/error/exceptions.dart';
import 'package:vakif_atlas_admin/core/network/network_constants.dart';
import 'package:vakif_atlas_admin/core/network/ssl/spki_hash.dart';

/// Mobil ve masaüstü için SSL pinning destekli HTTP adaptörü (TRD §4).
///
/// [enablePinning] `true` ise sunucu sertifikasının SPKI SHA-256 özeti
/// [pins] listesindeki değerlerden biriyle eşleşmelidir. Denetim TLS el
/// sıkışmasının hemen ardından, **istek gönderilmeden** bağlantı fabrikasında
/// yapılır (Dio'nun `validateCertificate`'i yanıt geldikten sonra çalışır;
/// o noktada anahtar ve gövde sunucuya gitmiş olur). Eşleşmezse bağlantı
/// kapatılır ve istek `SecurityException(sslPinningFailed)` ile reddedilir.
/// Geçersiz zincirli sertifikalar her durumda reddedilir.
///
/// Vekil sunucu (proxy) üzerinden giden bağlantıda TLS tüneli `HttpClient`
/// içinde kurulduğundan el sıkışma denetimi yapılamaz; o durumda yanıt
/// sonrası `validateCertificate` denetimi yine uygulanır.
HttpClientAdapter createPlatformHttpAdapter({
  required bool enablePinning,
  required List<String> pins,
}) {
  bool isPinned(X509Certificate? certificate) {
    if (certificate == null) {
      return false;
    }
    final hash = SpkiHash.fromCertificateDer(certificate.der);
    return hash != null && pins.contains(hash);
  }

  return IOHttpClientAdapter(
    createHttpClient: () {
      final client = HttpClient()..badCertificateCallback = (_, _, _) => false;
      if (enablePinning) {
        client.connectionFactory = (uri, proxyHost, proxyPort) =>
            _connect(uri, proxyHost, proxyPort, isPinned);
      }
      return client;
    },
    validateCertificate: (certificate, host, port) =>
        !enablePinning || isPinned(certificate),
  );
}

Future<ConnectionTask<Socket>> _connect(
  Uri uri,
  String? proxyHost,
  int? proxyPort,
  bool Function(X509Certificate?) isPinned,
) async {
  if (proxyHost != null && proxyPort != null) {
    return Socket.startConnect(proxyHost, proxyPort);
  }
  if (uri.scheme != 'https') {
    return Socket.startConnect(uri.host, uri.port);
  }
  final task = await SecureSocket.startConnect(uri.host, uri.port);
  final socket = task.socket
      .timeout(
        NetworkConstants.connectTimeout,
        onTimeout: () {
          task.cancel();
          // Dio "timed out" iletisini bağlantı zaman aşımına eşler.
          throw const SocketException('Connection timed out');
        },
      )
      .then<Socket>((socket) {
        if (!isPinned(socket.peerCertificate)) {
          socket.destroy();
          throw const SecurityException(SecurityExceptionType.sslPinningFailed);
        }
        return socket;
      });
  return ConnectionTask.fromSocket(socket, task.cancel);
}
