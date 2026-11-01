import 'package:flutter/material.dart';
import 'package:vakif_atlas_admin/core/theme/theme_context.dart';
import 'package:vakif_atlas_admin/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas_admin/shared/widgets/atoms/app_icon.dart';
import 'package:vakif_atlas_admin/shared/widgets/atoms/app_text.dart';

enum InlineMessageType { info, success, warning, error }

/// Form ve sayfa içi durum mesajı.
///
/// Durum yalnızca renkle değil, ikon + metin ile gösterilir (WCAG 1.4.1);
/// mesaj canlı bölge (live region) olarak işaretlendiğinden göründüğünde
/// ekran okuyucu tarafından okunur (WCAG 4.1.3).
class InlineMessage extends StatelessWidget {
  const InlineMessage({
    required this.message,
    this.type = InlineMessageType.info,
    super.key,
  });

  final String message;
  final InlineMessageType type;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final (icon, accent) = switch (type) {
      InlineMessageType.info => (Icons.info_outline, colors.info),
      InlineMessageType.success => (Icons.check_circle_outline, colors.success),
      InlineMessageType.warning => (
        Icons.warning_amber_outlined,
        colors.warning,
      ),
      InlineMessageType.error => (Icons.error_outline, colors.error),
    };

    return Semantics(
      container: true,
      liveRegion: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.isHighContrast
              ? colors.surfaceVariant
              : Color.alphaBlend(
                  accent.withValues(alpha: 0.08),
                  colors.surfaceElevated,
                ),
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: colors.isHighContrast ? Border.all(color: accent) : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppIcon.decorative(
                icon,
                color: accent,
                size: AppSizes.iconInline,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: AppText(message)),
            ],
          ),
        ),
      ),
    );
  }
}
