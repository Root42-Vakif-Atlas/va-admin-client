import 'package:flutter/material.dart';
import 'package:vakif_atlas_admin/core/a11y/reduce_motion.dart';
import 'package:vakif_atlas_admin/core/theme/theme_context.dart';
import 'package:vakif_atlas_admin/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas_admin/shared/widgets/atoms/app_icon.dart';
import 'package:vakif_atlas_admin/shared/widgets/atoms/app_text.dart';

/// Sayfa yüklenirken gösterilen ortalanmış durum.
///
/// Etiket canlı bölge olarak okunur (WCAG 4.1.3); hareket azaltma açıkken
/// dönen gösterge yerine sabit ikon kullanılır.
class LoadingStatusView extends StatelessWidget {
  const LoadingStatusView({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Center(
      child: Semantics(
        container: true,
        liveRegion: true,
        label: label,
        excludeSemantics: true,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (context.reduceMotion)
              AppIcon.decorative(
                Icons.hourglass_top,
                size: AppSizes.iconLg,
                color: colors.accentText,
              )
            else
              CircularProgressIndicator(color: colors.accentText),
            const SizedBox(height: AppSpacing.md),
            AppText(label, color: colors.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}
