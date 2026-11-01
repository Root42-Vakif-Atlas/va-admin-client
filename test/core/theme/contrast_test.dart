import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas_admin/core/theme/contrast.dart';
import 'package:vakif_atlas_admin/core/theme/extensions/app_color_scheme.dart';
import 'package:vakif_atlas_admin/core/theme/launch_colors.dart';

/// Her temanın semantik renk çiftlerini WCAG 2.2 eşiklerine karşı doğrular.
void main() {
  test('kontrast hesaplayıcı bilinen değerleri üretir', () {
    expect(
      Contrast.ratio(const Color(0xFF000000), const Color(0xFFFFFFFF)),
      closeTo(21, 0.01),
    );
    expect(
      Contrast.ratio(const Color(0xFFFFFFFF), const Color(0xFFFFFFFF)),
      closeTo(1, 0.01),
    );
  });

  const schemes = {
    'dark': AppColorScheme.dark,
    'light': AppColorScheme.light,
    'sidebar': AppColorScheme.sidebar,
    'highContrastDark': AppColorScheme.highContrastDark,
    'highContrastLight': AppColorScheme.highContrastLight,
  };

  for (final MapEntry(key: name, value: c) in schemes.entries) {
    group('$name teması', () {
      final textMinimum = c.isHighContrast
          ? Contrast.enhanced
          : Contrast.normalText;

      final textPairs = <String, (Color, Color)>{
        'onSurface / surface': (c.onSurface, c.surface),
        'onSurface / surfaceVariant': (c.onSurface, c.surfaceVariant),
        'onSurfaceVariant / surface': (c.onSurfaceVariant, c.surface),
        'onSurfaceVariant / surfaceVariant': (
          c.onSurfaceVariant,
          c.surfaceVariant,
        ),
        'onPrimary / primary': (c.onPrimary, c.primary),
        'onPrimaryContainer / primaryContainer': (
          c.onPrimaryContainer,
          c.primaryContainer,
        ),
        'onSecondaryContainer / secondaryContainer': (
          c.onSecondaryContainer,
          c.secondaryContainer,
        ),
        'onSurface / surfaceElevated': (c.onSurface, c.surfaceElevated),
        'onSurfaceVariant / surfaceElevated': (
          c.onSurfaceVariant,
          c.surfaceElevated,
        ),
        'accentText / surfaceElevated': (c.accentText, c.surfaceElevated),
        'onBrandAccent / brandAccent': (c.onBrandAccent, c.brandAccent),
        'onComplexAccent / complexAccent': (c.onComplexAccent, c.complexAccent),
        'accentText / surface': (c.accentText, c.surface),
        'accentText / surfaceVariant': (c.accentText, c.surfaceVariant),
        'error / surface': (c.error, c.surface),
        'error / surfaceVariant': (c.error, c.surfaceVariant),
        'onError / error': (c.onError, c.error),
        'success / surface': (c.success, c.surface),
        'warning / surface': (c.warning, c.surface),
        'info / surface': (c.info, c.surface),
      };

      for (final MapEntry(key: pair, value: (fg, bg)) in textPairs.entries) {
        test('$pair ≥ $textMinimum:1', () {
          expect(Contrast.ratio(fg, bg), greaterThanOrEqualTo(textMinimum));
        });
      }

      test('outline / surface ≥ 3:1 (WCAG 1.4.11)', () {
        expect(
          Contrast.ratio(c.outline, c.surface),
          greaterThanOrEqualTo(Contrast.largeTextOrGraphic),
        );
        expect(
          Contrast.ratio(c.outline, c.surfaceVariant),
          greaterThanOrEqualTo(Contrast.largeTextOrGraphic),
        );
      });

      test('marka vurgusu (pin, motif) her zeminde ≥ 3:1 (WCAG 1.4.11)', () {
        for (final background in [c.surface, c.surfaceElevated]) {
          expect(
            Contrast.ratio(c.brandAccent, background),
            greaterThanOrEqualTo(Contrast.largeTextOrGraphic),
          );
        }
      });

      test('külliye vurgusu her zeminde ≥ 3:1 (WCAG 1.4.11)', () {
        for (final background in [c.surface, c.surfaceElevated]) {
          expect(
            Contrast.ratio(c.complexAccent, background),
            greaterThanOrEqualTo(Contrast.largeTextOrGraphic),
          );
        }
      });

      // Renk tek ayırt edici değildir (şekil + rozet + etiket). Standart
      // temalarda iki işaretçi parlaklıkla da ayrışır; yüksek kontrastta
      // ikisi de en parlak/koyu tonlarda olduğundan ayrım ton (sarı–mavi)
      // ve şekille yapılır.
      test('külliye ve eser vurguları parlaklıkla ayrışır (≥ 1.5:1)', () {
        expect(
          Contrast.ratio(c.complexAccent, c.brandAccent),
          greaterThanOrEqualTo(1.5),
        );
      }, skip: c.isHighContrast);

      test('outline / surfaceElevated ≥ 3:1 (WCAG 1.4.11)', () {
        expect(
          Contrast.ratio(c.outline, c.surfaceElevated),
          greaterThanOrEqualTo(Contrast.largeTextOrGraphic),
        );
      });

      test('primary dolgu / surface ≥ 3:1 (WCAG 1.4.11)', () {
        expect(
          Contrast.ratio(c.primary, c.surface),
          greaterThanOrEqualTo(Contrast.largeTextOrGraphic),
        );
      });
    });
  }

  group('açılış ekranı (temadan bağımsız)', () {
    test('metin ≥ 7:1 (yüksek kontrast kullanıcısı için de)', () {
      for (final foreground in [
        LaunchColors.foreground,
        LaunchColors.foregroundMuted,
      ]) {
        expect(
          Contrast.ratio(foreground, LaunchColors.background),
          greaterThanOrEqualTo(Contrast.enhanced),
        );
      }
    });

    test('amblem vurgusu ≥ 3:1 (WCAG 1.4.11)', () {
      expect(
        Contrast.ratio(LaunchColors.accent, LaunchColors.background),
        greaterThanOrEqualTo(Contrast.largeTextOrGraphic),
      );
    });
  });
}
