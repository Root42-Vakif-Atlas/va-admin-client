import 'dart:async';

import 'package:flutter/foundation.dart';

/// Akışlardan herhangi biri değer yayınladığında GoRouter'ın yönlendirmeyi
/// yeniden değerlendirmesini sağlar (`refreshListenable`).
class RouterRefreshStream extends ChangeNotifier {
  RouterRefreshStream(Iterable<Stream<Object?>> streams) {
    _subscriptions = [
      for (final stream in streams) stream.listen((_) => notifyListeners()),
    ];
  }

  late final List<StreamSubscription<Object?>> _subscriptions;

  @override
  void dispose() {
    for (final subscription in _subscriptions) {
      unawaited(subscription.cancel());
    }
    super.dispose();
  }
}
