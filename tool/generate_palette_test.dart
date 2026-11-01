// Marka renklerinden (#21172B mor, #AC8058 bronz, #FFF4E4 fildişi) HCT tonal
// paletlerini üretir ve `app_colors.dart`'a yazılacak sabitleri yazdırır.
// Çalıştırma: flutter test tool/generate_palette_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:material_color_utilities/material_color_utilities.dart';

String hex(int argb) =>
    '0x${argb.toRadixString(16).toUpperCase().padLeft(8, '0')}';

void main() {
  test('palette', () {
    final brand = Hct.fromInt(0xFF21172B);
    final bronze = Hct.fromInt(0xFFAC8058);
    // ignore: avoid_print
    print(
      'brand hue ${brand.hue.toStringAsFixed(1)} chroma ${brand.chroma.toStringAsFixed(1)} tone ${brand.tone.toStringAsFixed(1)}',
    );
    // ignore: avoid_print
    print(
      'bronze hue ${bronze.hue.toStringAsFixed(1)} chroma ${bronze.chroma.toStringAsFixed(1)} tone ${bronze.tone.toStringAsFixed(1)}',
    );
    final groups = <String, (double, List<int>)>{
      'purple': (30, [10, 20, 30, 40, 80, 90, 95]),
      'darkPurple': (brand.chroma, [5, 10, 12, 17, 22, 25]),
      'neutral': (4, [90, 92, 94, 96, 98]),
      'neutralVariant': (8, [10, 30, 50, 60, 80, 90]),
      'bronze': (bronze.chroma, [40, 50, 75, 85]),
    };
    for (final MapEntry(key: name, value: (chroma, tones)) in groups.entries) {
      final palette = TonalPalette.of(
        name == 'bronze' ? bronze.hue : brand.hue,
        chroma,
      );
      for (final tone in tones) {
        // ignore: avoid_print
        print(
          'static const Color $name$tone = Color(${hex(palette.get(tone))});',
        );
      }
    }
  });
}
