import 'package:flutter/material.dart';
import 'package:vakif_atlas_admin/core/theme/theme_context.dart';
import 'package:vakif_atlas_admin/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas_admin/shared/widgets/atoms/app_icon.dart';

/// İkon + metinden oluşan, etkileşimsiz bilgi etiketi (yapı türü, dönem,
/// yapım tarihi).
///
/// Bilgi yalnızca renkle verilmez (WCAG 1.4.1); ekran okuyucu bağlamıyla
/// birlikte okur (ör. "Dönem: Osmanlı").
class InfoChip extends StatelessWidget {
  const InfoChip({
    required this.icon,
    required this.label,
    required this.semanticsLabel,
    super.key,
  });

  final IconData icon;
  final String label;
  final String semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      label: semanticsLabel,
      excludeSemantics: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          border: Border.all(
            color: colors.outlineVariant,
            width: AppSizes.borderThin,
          ),
          borderRadius: BorderRadius.circular(AppRadius.xs),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xs,
            vertical: AppSpacing.xxs,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppIcon.decorative(
                icon,
                size: AppSizes.iconSm,
                color: colors.accentText,
              ),
              const SizedBox(width: AppSpacing.xxs),
              Flexible(
                child: Text(label, style: context.textStyles.labelMedium),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
