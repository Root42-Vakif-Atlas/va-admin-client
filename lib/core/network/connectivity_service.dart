import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas_admin/core/network/network_constants.dart';

/// Gerçek internet erişimini denetler (TRD §4 — reachability).
///
/// Yalnızca Wi-Fi/hücresel arayüzün açık olmasına güvenilmez; API'nin
/// `health` uç noktasına kısa zaman aşımlı bir `HEAD` isteği gönderilir.
/// Sunucudan herhangi bir HTTP yanıtı gelmesi erişim olduğunu gösterir.
@lazySingleton
class ConnectivityService {
  ConnectivityService(this._connectivity, @Named(DioNames.probe) this._probe);

  final Connectivity _connectivity;
  final Dio _probe;

  Future<bool> hasInternetAccess() async {
    final interfaces = await _connectivity.checkConnectivity();
    if (interfaces.every((result) => result == ConnectivityResult.none)) {
      return false;
    }
    try {
      await _probe.head<void>(NetworkConstants.healthPath);
      return true;
    } on DioException catch (error) {
      return error.response != null;
    }
  }

  /// Ağ arayüzü değiştikçe gerçek erişim durumunu yayınlar.
  Stream<bool> get onStatusChange => _connectivity.onConnectivityChanged
      .asyncMap((_) => hasInternetAccess())
      .distinct();
}
