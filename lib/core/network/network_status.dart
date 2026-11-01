import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';

/// Cihazın ağa bağlı olup olmadığı (uçak modu, Wi-Fi/hücresel kapalı).
///
/// Sunucuya erişimden bağımsızdır: cihaz çevrimiçiyken başarısız olan
/// istek "sunucuya ulaşılamıyor", çevrimdışıyken "internet yok" olarak
/// ayrılır (`ErrorInterceptor`). Ayrıca bağlantı geri geldiğinde bekleyen
/// değişikliklerin eşitlenmesini tetikler.
abstract interface class NetworkStatus {
  /// Son bilinen durum; ilk denetim bitmeden iyimser olarak `true`.
  bool get isOnline;

  /// Durum değiştikçe yayınlar (aynı değer tekrarlanmaz).
  Stream<bool> get changes;

  /// Durumu yeniden denetler ve döner.
  Future<bool> refresh();

  Future<void> dispose();
}

@LazySingleton(as: NetworkStatus)
class DeviceNetworkStatus implements NetworkStatus {
  DeviceNetworkStatus(this._connectivity) {
    _subscription = _connectivity.onConnectivityChanged.listen(_update);
    unawaited(refresh());
  }

  final Connectivity _connectivity;
  final StreamController<bool> _changes = StreamController<bool>.broadcast();
  late final StreamSubscription<List<ConnectivityResult>> _subscription;
  bool _isOnline = true;

  @override
  bool get isOnline => _isOnline;

  @override
  Stream<bool> get changes => _changes.stream;

  @override
  Future<bool> refresh() async {
    try {
      _update(await _connectivity.checkConnectivity());
    } on Exception {
      // Eklentinin desteklenmediği ortamda çevrimiçi varsayılır; istek
      // hatası yine "sunucuya ulaşılamıyor" olarak gösterilir.
    }
    return _isOnline;
  }

  void _update(List<ConnectivityResult> interfaces) {
    final online = interfaces.any(
      (result) => result != ConnectivityResult.none,
    );
    if (online == _isOnline) {
      return;
    }
    _isOnline = online;
    _changes.add(online);
  }

  @override
  @disposeMethod
  Future<void> dispose() async {
    await _subscription.cancel();
    await _changes.close();
  }
}
