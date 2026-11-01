import 'package:flutter/material.dart';
import 'package:vakif_atlas_admin/core/theme/brand_emblem_shape.dart';
import 'package:vakif_atlas_admin/core/theme/theme_context.dart';

/// Vakıf Atlas amblemi (uygulama simgesindeki logo): sivri kemerli kapı,
/// içinde baklava dilimi ve altın eşik (Brand Reference §1).
///
/// Geometri [BrandEmblemShape]'tedir; native açılış görselleri de bu
/// çizimden üretilir (`tool/generate_brand_assets_test.dart`). Dekoratiftir;
/// anlamı çevresindeki metin taşır, bu yüzden ekran okuyucudan gizlenir.
class BrandEmblem extends StatelessWidget {
  const BrandEmblem({
    required this.size,
    this.frameColor,
    this.accentColor,
    super.key,
  });

  final double size;

  /// Kemer ve baklava dilimi. Varsayılan: tema `primary`.
  final Color? frameColor;

  /// Altın eşik. Varsayılan: tema `brandAccent`.
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ExcludeSemantics(
      child: CustomPaint(
        size: Size.square(size),
        painter: BrandEmblemPainter(
          frameColor: frameColor ?? colors.primary,
          accentColor: accentColor ?? colors.brandAccent,
        ),
      ),
    );
  }
}

/// [BrandEmblem] çizimi ([BrandEmblemShape] birim kare geometrisi).
class BrandEmblemPainter extends CustomPainter {
  const BrandEmblemPainter({
    required this.frameColor,
    required this.accentColor,
  });

  final Color frameColor;
  final Color accentColor;

  @override
  void paint(Canvas canvas, Size size) {
    final unit = size.shortestSide;
    canvas
      ..save()
      ..translate((size.width - unit) / 2, (size.height - unit) / 2)
      ..scale(unit)
      ..drawPath(_path(BrandEmblemShape.frame), Paint()..color = frameColor)
      ..drawPath(_path(BrandEmblemShape.accent), Paint()..color = accentColor)
      ..restore();
  }

  static Path _path(List<List<EmblemPathCommand>> contours) {
    final path = Path();
    for (final contour in contours) {
      for (final command in contour) {
        switch (command) {
          case EmblemMoveTo(:final x, :final y):
            path.moveTo(x, y);
          case EmblemLineTo(:final x, :final y):
            path.lineTo(x, y);
          case EmblemCubicTo(
            :final x1,
            :final y1,
            :final x2,
            :final y2,
            :final x,
            :final y,
          ):
            path.cubicTo(x1, y1, x2, y2, x, y);
          case EmblemClose():
            path.close();
        }
      }
    }
    return path;
  }

  @override
  bool shouldRepaint(BrandEmblemPainter oldDelegate) =>
      oldDelegate.frameColor != frameColor ||
      oldDelegate.accentColor != accentColor;
}
