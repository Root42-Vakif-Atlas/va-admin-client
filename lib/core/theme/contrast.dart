import 'package:flutter/painting.dart';

/// WCAG 2.2 kontrast oranı hesaplayıcı.
abstract final class Contrast {
  /// Normal metin için minimum oran (1.4.3).
  static const double normalText = 4.5;

  /// Büyük metin ve grafik bileşenler için minimum oran (1.4.3 / 1.4.11).
  static const double largeTextOrGraphic = 3;

  /// Yüksek kontrast temaları için minimum oran (1.4.6).
  static const double enhanced = 7;

  /// İki opak renk arasındaki kontrast oranı (1:1 – 21:1).
  ///
  /// Yarı saydam [foreground], [background] üzerine karıştırılarak ölçülür.
  static double ratio(Color foreground, Color background) {
    final blended = Color.alphaBlend(foreground, background);
    final a = blended.computeLuminance();
    final b = background.computeLuminance();
    final lighter = a > b ? a : b;
    final darker = a > b ? b : a;
    return (lighter + 0.05) / (darker + 0.05);
  }
}
