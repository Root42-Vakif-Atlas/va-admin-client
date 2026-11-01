import 'package:flutter/material.dart';
import 'package:vakif_atlas_admin/core/theme/extensions/app_color_scheme.dart';
import 'package:vakif_atlas_admin/core/theme/tokens/app_typography.dart';

/// Tema rengi uygulanmış tipografi token'ları.
///
/// Arayüz kodu stilleri yalnızca bu extension üzerinden okur:
/// `context.textStyles.bodyLarge`.
@immutable
class AppTextTheme extends ThemeExtension<AppTextTheme> {
  const AppTextTheme({
    required this.displayLarge,
    required this.displayMedium,
    required this.headlineLarge,
    required this.headlineMedium,
    required this.titleLarge,
    required this.titleMedium,
    required this.bodyLarge,
    required this.bodyMedium,
    required this.bodySmall,
    required this.labelLarge,
    required this.labelMedium,
    required this.labelSmall,
  });

  /// [AppTypography] token'larına [colors] ile renk uygular.
  factory AppTextTheme.fromColors(AppColorScheme colors) {
    TextStyle primary(TextStyle style) =>
        style.copyWith(color: colors.onSurface);
    TextStyle secondary(TextStyle style) =>
        style.copyWith(color: colors.onSurfaceVariant);

    return AppTextTheme(
      displayLarge: primary(AppTypography.displayLarge),
      displayMedium: primary(AppTypography.displayMedium),
      headlineLarge: primary(AppTypography.headlineLarge),
      headlineMedium: primary(AppTypography.headlineMedium),
      titleLarge: primary(AppTypography.titleLarge),
      titleMedium: primary(AppTypography.titleMedium),
      bodyLarge: primary(AppTypography.bodyLarge),
      bodyMedium: primary(AppTypography.bodyMedium),
      bodySmall: secondary(AppTypography.bodySmall),
      labelLarge: primary(AppTypography.labelLarge),
      labelMedium: primary(AppTypography.labelMedium),
      labelSmall: secondary(AppTypography.labelSmall),
    );
  }

  final TextStyle displayLarge;
  final TextStyle displayMedium;
  final TextStyle headlineLarge;
  final TextStyle headlineMedium;
  final TextStyle titleLarge;
  final TextStyle titleMedium;
  final TextStyle bodyLarge;
  final TextStyle bodyMedium;
  final TextStyle bodySmall;
  final TextStyle labelLarge;
  final TextStyle labelMedium;
  final TextStyle labelSmall;

  /// Material bileşenlerinin de aynı token'ları kullanması için
  /// eşdeğer [TextTheme].
  TextTheme toMaterialTextTheme() {
    return TextTheme(
      displayLarge: displayLarge,
      displayMedium: displayMedium,
      displaySmall: headlineLarge,
      headlineLarge: headlineLarge,
      headlineMedium: headlineMedium,
      headlineSmall: titleLarge,
      titleLarge: titleLarge,
      titleMedium: titleMedium,
      titleSmall: labelLarge,
      bodyLarge: bodyLarge,
      bodyMedium: bodyMedium,
      bodySmall: bodySmall,
      labelLarge: labelLarge,
      labelMedium: labelMedium,
      labelSmall: labelSmall,
    );
  }

  @override
  AppTextTheme copyWith({
    TextStyle? displayLarge,
    TextStyle? displayMedium,
    TextStyle? headlineLarge,
    TextStyle? headlineMedium,
    TextStyle? titleLarge,
    TextStyle? titleMedium,
    TextStyle? bodyLarge,
    TextStyle? bodyMedium,
    TextStyle? bodySmall,
    TextStyle? labelLarge,
    TextStyle? labelMedium,
    TextStyle? labelSmall,
  }) {
    return AppTextTheme(
      displayLarge: displayLarge ?? this.displayLarge,
      displayMedium: displayMedium ?? this.displayMedium,
      headlineLarge: headlineLarge ?? this.headlineLarge,
      headlineMedium: headlineMedium ?? this.headlineMedium,
      titleLarge: titleLarge ?? this.titleLarge,
      titleMedium: titleMedium ?? this.titleMedium,
      bodyLarge: bodyLarge ?? this.bodyLarge,
      bodyMedium: bodyMedium ?? this.bodyMedium,
      bodySmall: bodySmall ?? this.bodySmall,
      labelLarge: labelLarge ?? this.labelLarge,
      labelMedium: labelMedium ?? this.labelMedium,
      labelSmall: labelSmall ?? this.labelSmall,
    );
  }

  @override
  AppTextTheme lerp(ThemeExtension<AppTextTheme>? other, double t) {
    if (other is! AppTextTheme) {
      return this;
    }
    TextStyle mix(TextStyle a, TextStyle b) => TextStyle.lerp(a, b, t)!;
    return AppTextTheme(
      displayLarge: mix(displayLarge, other.displayLarge),
      displayMedium: mix(displayMedium, other.displayMedium),
      headlineLarge: mix(headlineLarge, other.headlineLarge),
      headlineMedium: mix(headlineMedium, other.headlineMedium),
      titleLarge: mix(titleLarge, other.titleLarge),
      titleMedium: mix(titleMedium, other.titleMedium),
      bodyLarge: mix(bodyLarge, other.bodyLarge),
      bodyMedium: mix(bodyMedium, other.bodyMedium),
      bodySmall: mix(bodySmall, other.bodySmall),
      labelLarge: mix(labelLarge, other.labelLarge),
      labelMedium: mix(labelMedium, other.labelMedium),
      labelSmall: mix(labelSmall, other.labelSmall),
    );
  }
}
