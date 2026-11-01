import 'package:flutter/material.dart';
import 'package:vakif_atlas_admin/core/theme/theme_context.dart';
import 'package:vakif_atlas_admin/core/theme/tokens/app_spacing.dart';

enum StatusTone { neutral, info, success, warning, danger, accent }

/// Durum etiketi: düşük doygunluklu zemin üzerinde durum renginde metin.
/// Durumu metnin kendisi söyler; renk yalnızca taramayı kolaylaştırır
/// (WCAG 1.4.1). Ekran okuyucu [semanticsLabel] veya [label]'ı okur.
class StatusChip extends StatelessWidget {
  const StatusChip({
    required this.label,
    this.tone = StatusTone.neutral,
    this.semanticsLabel,
    super.key,
  });

  final String label;
  final StatusTone tone;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final foreground = switch (tone) {
      StatusTone.neutral => colors.onSurfaceVariant,
      StatusTone.info => colors.info,
      StatusTone.success => colors.success,
      StatusTone.warning => colors.warning,
      StatusTone.danger => colors.error,
      StatusTone.accent => colors.accentText,
    };
    final background = tone == StatusTone.neutral
        ? colors.surfaceVariant
        : Color.alphaBlend(
            foreground.withValues(alpha: 0.1),
            colors.surfaceElevated,
          );
    return Semantics(
      label: semanticsLabel ?? label,
      excludeSemantics: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.isHighContrast ? null : background,
          borderRadius: BorderRadius.circular(AppRadius.xs),
          border: colors.isHighContrast ? Border.all(color: foreground) : null,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xs - 2,
            vertical: 2,
          ),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textStyles.labelMedium.copyWith(color: foreground),
          ),
        ),
      ),
    );
  }
}
