import 'package:flutter/widgets.dart';
import 'package:vakif_atlas_admin/core/theme/tokens/app_spacing.dart';

/// Pencere sınıfı (Material 3 pencere boyut sınıfları; Design System §4.1).
///
/// Karar her zaman **pencere** genişliğinden verilir (içerik alanından
/// değil): kabuk, sayfa başlığı ve ana-detay düzeni aynı sınıfı görür ve
/// birbiriyle çelişmez.
enum WindowClass {
  /// < 600 px: telefon. Kenar çubuğu çekmecede, tek sütun.
  compact,

  /// 600–1023 px: tablet / dar pencere. Daraltılmış kenar çubuğu, tek sütun.
  medium,

  /// ≥ 1024 px: masaüstü / geniş web. Liste ve ayrıntı yan yana.
  expanded;

  static WindowClass of(double width) => width < AppBreakpoints.medium
      ? compact
      : width < AppBreakpoints.split
      ? medium
      : expanded;
}

/// Duyarlı düzen kısayolları.
extension ResponsiveContext on BuildContext {
  /// Yalnızca genişlik değişince yeniden çizer (`MediaQuery.sizeOf`).
  WindowClass get windowClass => WindowClass.of(MediaQuery.sizeOf(this).width);

  bool get isCompact => windowClass == WindowClass.compact;

  /// Liste ve ayrıntı yan yana mı (ADR A5).
  bool get isSplitView => windowClass == WindowClass.expanded;

  /// Sayfa kenar boşluğu: telefonda 16, diğerlerinde 24 px.
  double get pageGutter => isCompact ? AppSpacing.md : AppSpacing.lg;
}

/// Alanları genişse yan yana, darsa alt alta dizer (form satırları).
///
/// Karar kapsayıcının genişliğinden verilir: aynı satır geniş pencerede
/// dar bir sütunda da doğru dizilir.
class ResponsiveFieldRow extends StatelessWidget {
  const ResponsiveFieldRow({
    required this.children,
    this.minFieldWidth = 240,
    this.spacing = AppSpacing.md,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.flex,
    super.key,
  });

  final List<Widget> children;

  /// Alan başına en küçük genişlik; sığmazsa alt alta dizilir.
  final double minFieldWidth;
  final double spacing;
  final CrossAxisAlignment crossAxisAlignment;

  /// Yan yana dizilimde alan oranları (varsayılan eşit).
  final List<int>? flex;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final needed =
          children.length * minFieldWidth + (children.length - 1) * spacing;
      if (constraints.maxWidth < needed) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final (index, child) in children.indexed) ...[
              if (index > 0) SizedBox(height: spacing),
              child,
            ],
          ],
        );
      }
      return Row(
        crossAxisAlignment: crossAxisAlignment,
        children: [
          for (final (index, child) in children.indexed) ...[
            if (index > 0) SizedBox(width: spacing),
            Expanded(flex: flex?[index] ?? 1, child: child),
          ],
        ],
      );
    },
  );
}
