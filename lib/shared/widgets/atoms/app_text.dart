import 'package:flutter/material.dart';
import 'package:vakif_atlas_admin/core/a11y/accessibility_scope.dart';
import 'package:vakif_atlas_admin/core/theme/extensions/app_text_theme.dart';
import 'package:vakif_atlas_admin/core/theme/theme_context.dart';

/// Tipografi rolleri (Design System §2.2).
enum AppTextRole {
  displayLarge,
  displayMedium,
  headlineLarge,
  headlineMedium,
  titleLarge,
  titleMedium,
  bodyLarge,
  bodyMedium,
  bodySmall,
  labelLarge,
  labelMedium,
  labelSmall;

  TextStyle resolve(AppTextTheme theme) => switch (this) {
    displayLarge => theme.displayLarge,
    displayMedium => theme.displayMedium,
    headlineLarge => theme.headlineLarge,
    headlineMedium => theme.headlineMedium,
    titleLarge => theme.titleLarge,
    titleMedium => theme.titleMedium,
    bodyLarge => theme.bodyLarge,
    bodyMedium => theme.bodyMedium,
    bodySmall => theme.bodySmall,
    labelLarge => theme.labelLarge,
    labelMedium => theme.labelMedium,
    labelSmall => theme.labelSmall,
  };
}

/// Token tabanlı metin bileşeni.
///
/// [isHeading] başlıkları ekran okuyucu başlık gezinmesine dahil eder
/// (WCAG 2.4.6 / 1.3.1).
class AppText extends StatelessWidget {
  const AppText(
    this.data, {
    this.role = AppTextRole.bodyLarge,
    this.color,
    this.textAlign,
    this.maxLines,
    this.semanticsLabel,
    this.isHeading = false,
    super.key,
  });

  final String data;
  final AppTextRole role;
  final Color? color;
  final TextAlign? textAlign;

  /// Varsayılan olarak sınırsızdır; metin ölçeği büyüdükçe satır sayısı artar.
  final int? maxLines;

  final String? semanticsLabel;
  final bool isHeading;

  @override
  Widget build(BuildContext context) {
    final style = role.resolve(context.textStyles);
    // Erişilebilirlik → "Sola hizala": ortalanmış ve sağa / iki yana yaslı
    // metin satır başından başlar (okuma sırası izlenebilir kalır).
    final align =
        AccessibilityScope.of(context).alignLeft &&
            textAlign != null &&
            textAlign != TextAlign.start &&
            textAlign != TextAlign.left
        ? TextAlign.start
        : textAlign;
    final text = Text(
      data,
      style: color == null ? style : style.copyWith(color: color),
      textAlign: align,
      maxLines: maxLines,
      overflow: maxLines == null ? null : TextOverflow.ellipsis,
      semanticsLabel: semanticsLabel,
    );
    return isHeading ? Semantics(header: true, child: text) : text;
  }
}
