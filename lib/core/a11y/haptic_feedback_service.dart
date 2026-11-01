import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

/// İşitme veya görme kısıtı olan kullanıcılar için birbirinden ayırt
/// edilebilir titreşim desenleri üretir (TRD §7).
///
/// | Olay        | Desen                         |
/// |-------------|-------------------------------|
/// | success     | hafif → orta (yükselen)       |
/// | warning     | orta × 2                      |
/// | error       | güçlü × 3                     |
/// | selection   | tek seçim tıkı                |
/// | mapPinTap   | tek güçlü darbe               |
///
/// Kullanıcı titreşimi ayarlardan kapattıysa ([enabled] `false`) hiçbir
/// desen çalınmaz.
@lazySingleton
class HapticFeedbackService {
  HapticFeedbackService() : this.withDelay(_wait);

  /// Testlerde desen aralıklarını beklemeden doğrulamak için.
  HapticFeedbackService.withDelay(this._delay);

  static const Duration patternGap = Duration(milliseconds: 90);

  final Future<void> Function(Duration duration) _delay;

  /// Kullanıcı tercihi (`AppSettingsCubit` eşitler).
  bool enabled = true;

  Future<void> success() =>
      _pattern([HapticFeedback.lightImpact, HapticFeedback.mediumImpact]);

  Future<void> warning() =>
      _pattern([HapticFeedback.mediumImpact, HapticFeedback.mediumImpact]);

  Future<void> error() => _pattern([
    HapticFeedback.heavyImpact,
    HapticFeedback.heavyImpact,
    HapticFeedback.heavyImpact,
  ]);

  Future<void> selection() => _pattern([HapticFeedback.selectionClick]);

  Future<void> mapPinTap() => _pattern([HapticFeedback.heavyImpact]);

  Future<void> _pattern(List<Future<void> Function()> pulses) async {
    if (!enabled) {
      return;
    }
    for (var index = 0; index < pulses.length; index++) {
      if (index > 0) {
        await _delay(patternGap);
      }
      await pulses[index]();
    }
  }

  static Future<void> _wait(Duration duration) =>
      Future<void>.delayed(duration);
}
