import 'package:dio/dio.dart';

/// Web için tarayıcının yerleşik HTTP adaptörü.
///
/// Tarayıcılar uygulama koduna sertifika erişimi vermediğinden web'de SSL
/// pinning uygulanamaz; TLS doğrulaması tarayıcı tarafından yapılır.
HttpClientAdapter createPlatformHttpAdapter({
  required bool enablePinning,
  required List<String> pins,
}) {
  return HttpClientAdapter();
}
