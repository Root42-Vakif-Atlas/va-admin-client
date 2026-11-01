/// Animasyon süre token'ları (Design System §2.4).
///
/// Hareket azaltma etkinse tüm süreler [instant] ile değiştirilir
/// (`ReduceMotion` extension'ı).
abstract final class AppDurations {
  static const Duration instant = Duration.zero;
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 250);
  static const Duration medium = Duration(milliseconds: 350);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration verySlow = Duration(milliseconds: 800);
}
