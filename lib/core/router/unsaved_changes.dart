import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

/// Açık formda kaydedilmemiş değişiklik var mı. Düzenleyici günceller;
/// yönlendirici rotadan çıkarken (`GoRoute.onExit`: kenar çubuğu, geri,
/// derin bağlantı) onay ister.
@lazySingleton
class UnsavedChanges {
  final ValueNotifier<bool> dirty = ValueNotifier(false);

  bool get isDirty => dirty.value;

  void set({required bool dirty}) => this.dirty.value = dirty;

  @disposeMethod
  void dispose() => dirty.dispose();
}
