import 'package:flutter/painting.dart';
import 'package:vakif_atlas_admin/core/theme/tokens/app_spacing.dart';

/// Gölge ve kenarlık token'ları (Design System §2.5).
abstract final class AppShadows {
  /// Koyu temalarda bulanık gölge yerine ince kenarlık tercih edilir.
  ///
  /// [color] tema renginden (`AppColorScheme.outlineVariant`) verilir.
  static BoxDecoration cardBorder({required Color color}) => BoxDecoration(
    border: Border.all(color: color, width: AppSizes.borderThin),
    borderRadius: BorderRadius.circular(AppRadius.sm),
  );

  /// Açık temalar için gerçek gölge.
  static const List<BoxShadow> cardShadow = [
    BoxShadow(color: Color(0x14000000), blurRadius: 8, offset: Offset(0, 2)),
    BoxShadow(color: Color(0x0A000000), blurRadius: 2),
  ];
}
