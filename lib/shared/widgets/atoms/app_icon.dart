import 'package:flutter/material.dart';
import 'package:vakif_atlas_admin/core/theme/tokens/app_spacing.dart';

/// Semantik etiketli ikon sarmalayıcı (Design System §8).
///
/// Anlam taşıyan ikonlar [AppIcon] ile etiketlenir; yanında aynı anlamı
/// taşıyan metin bulunan süs ikonları [AppIcon.decorative] ile ekran
/// okuyucudan gizlenir (WCAG 1.1.1).
class AppIcon extends StatelessWidget {
  const AppIcon(
    this.icon, {
    required String this.semanticsLabel,
    this.size,
    this.color,
    super.key,
  });

  const AppIcon.decorative(this.icon, {this.size, this.color, super.key})
    : semanticsLabel = null;

  final IconData icon;
  final String? semanticsLabel;
  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final glyph = Icon(
      icon,
      size: size ?? AppSizes.iconMd,
      color: color,
      semanticLabel: semanticsLabel,
    );
    return semanticsLabel == null ? ExcludeSemantics(child: glyph) : glyph;
  }
}
