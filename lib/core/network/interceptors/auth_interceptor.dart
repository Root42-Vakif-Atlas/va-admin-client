import 'package:dio/dio.dart';
import 'package:vakif_atlas_admin/core/network/network_constants.dart';
import 'package:vakif_atlas_admin/core/network/session_events.dart';
import 'package:vakif_atlas_admin/core/storage/secure_storage_service.dart';

/// Bearer anahtarı ekler ve süresi dolan oturumu yeniler (TRD §4.3).
///
/// Aynı anda 401 alan istekler tek bir yenileme işlemini paylaşır
/// (single-flight); yenileme sürerken başlayan yeni istekler de bu işlemin
/// bitmesini bekler. Yenilenmiş anahtarla istek bir kez tekrarlanır;
/// sunucu yenilemeyi reddederse [SessionEvents.notifySessionExpired] ile
/// oturum (paylaşılan yenileme başına bir kez) sonlandırılır. Yenileme ağ
/// hatasıyla biterse oturum korunur ve ağ hatası iletilir. Anahtarsız
/// (misafir) isteğin 401'i yenileme tetiklemez.
///
/// `QueuedInterceptor` bilinçli olarak kullanılmaz: tekrarlanan istek yine
/// 401 alırsa kuyruk kendi hatasını bekleyerek kilitlenir.
/// Yenileme isteği bu interceptor'ı içermeyen ayrı bir `Dio` ile yapılır.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required this._dio,
    required this._storage,
    required this._refresher,
    required this._sessionEvents,
  });

  final Dio _dio;
  final SecureStorageService _storage;
  final AuthTokenRefresher _refresher;
  final SessionEvents _sessionEvents;

  static const String _bearerPrefix = 'Bearer ';

  Future<String?>? _refreshInFlight;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.extra[RequestExtras.skipAuth] == true) {
      handler.next(options);
      return;
    }
    try {
      final pendingRefresh = _refreshInFlight;
      if (pendingRefresh != null) {
        await pendingRefresh;
      }
      final token = await _storage.getAccessToken();
      if (token != null) {
        options.headers[NetworkConstants.authorizationHeader] =
            '$_bearerPrefix$token';
      }
      handler.next(options);
    } on Exception catch (error) {
      handler.reject(DioException(requestOptions: options, error: error), true);
    }
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final options = err.requestOptions;
    final isUnauthorized = err.response?.statusCode == 401;
    if (!isUnauthorized ||
        options.extra[RequestExtras.skipAuth] == true ||
        options.extra[RequestExtras.authRetried] == true) {
      handler.next(err);
      return;
    }

    final failedToken = _tokenFrom(options);
    if (failedToken == null) {
      handler.next(err);
      return;
    }

    try {
      final currentToken = await _storage.getAccessToken();

      // Başka bir istek anahtarı zaten yenilemiş olabilir.
      final freshToken = currentToken != null && currentToken != failedToken
          ? currentToken
          : await _refreshOnce();

      if (freshToken == null) {
        handler.next(err);
        return;
      }

      // Başlık tekrar isteğinde `onRequest` tarafından depodaki güncel
      // anahtarla yeniden kurulur; ham anahtar burada kopyalanmaz.
      final retryHeaders = Map<String, dynamic>.of(options.headers)
        ..remove(NetworkConstants.authorizationHeader);
      final response = await _dio.fetch<dynamic>(
        options.copyWith(
          headers: retryHeaders,
          extra: {...options.extra, RequestExtras.authRetried: true},
        ),
      );
      handler.resolve(response);
    } on DioException catch (error) {
      // Tekrar isteğinin hatası ya da geçici yenileme hatası (ağ, 5xx):
      // oturum korunur, hata olduğu gibi iletilir.
      handler.next(error);
    } on Exception {
      handler.next(err);
    }
  }

  Future<String?> _refreshOnce() {
    return _refreshInFlight ??= _refresher
        .refreshAccessToken()
        .then((token) {
          if (token == null) {
            _sessionEvents.notifySessionExpired();
          }
          return token;
        })
        .whenComplete(() => _refreshInFlight = null);
  }

  static String? _tokenFrom(RequestOptions options) {
    final header = options.headers[NetworkConstants.authorizationHeader];
    if (header is String && header.startsWith(_bearerPrefix)) {
      return header.substring(_bearerPrefix.length);
    }
    return null;
  }
}
