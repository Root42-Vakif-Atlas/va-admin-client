import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

/// Sistem metin ölçeğini uygulama içi çarpanla birleştirir (TRD §6).
///
/// `(settings.textScaleFactor × sistem ölçeği).clamp(1.0, 2.0)`
///
/// Android 14+'ın doğrusal olmayan ölçeklemesi korunur: sistem ölçekleyicisi
/// değiştirilmez, yalnızca sonucu çarpılır ve sınırlandırılır.
abstract final class AppTextScaler {
  static const double minScale = 1;
  static const double maxScale = 2;

  static TextScaler resolve(TextScaler system, double appFactor) {
    return _ProductTextScaler(
      system,
      appFactor,
    ).clamp(minScaleFactor: minScale, maxScaleFactor: maxScale);
  }
}

@immutable
final class _ProductTextScaler extends TextScaler {
  const _ProductTextScaler(this._base, this._factor);

  final TextScaler _base;
  final double _factor;

  @override
  double scale(double fontSize) => _base.scale(fontSize) * _factor;

  @override
  // ignore: deprecated_member_use
  double get textScaleFactor => _base.textScaleFactor * _factor;

  @override
  bool operator ==(Object other) =>
      other is _ProductTextScaler &&
      other._base == _base &&
      other._factor == _factor;

  @override
  int get hashCode => Object.hash(_base, _factor);
}
