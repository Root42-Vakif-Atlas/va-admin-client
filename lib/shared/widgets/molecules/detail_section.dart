import 'package:flutter/material.dart';
import 'package:vakif_atlas_admin/core/theme/theme_context.dart';
import 'package:vakif_atlas_admin/core/theme/tokens/app_spacing.dart';

/// Ayrıntı panelinde başlıklı bölüm (kart).
class DetailSection extends StatelessWidget {
  const DetailSection({
    required this.title,
    required this.child,
    this.trailing,
    super.key,
  });

  /// Bu genişliğin altında [trailing] başlığın altına iner.
  static const double _stackTrailingBelow = 480;

  final String title;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    // Material yüzeyi: içteki liste satırlarının dokunma efektleri görünür.
    return Material(
      color: colors.surfaceElevated,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        side: BorderSide(
          color: colors.isHighContrast ? colors.outline : colors.outlineVariant,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final heading = Semantics(
                  header: true,
                  child: Text(title, style: context.textStyles.titleMedium),
                );
                final trailing = this.trailing;
                if (trailing == null) {
                  return heading;
                }
                // Dar kartta eylemler başlığı ezmesin: alt satıra geçer.
                if (constraints.maxWidth < _stackTrailingBelow) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      heading,
                      const SizedBox(height: AppSpacing.xs),
                      trailing,
                    ],
                  );
                }
                return Row(
                  children: [
                    Expanded(child: heading),
                    trailing,
                  ],
                );
              },
            ),
            const SizedBox(height: AppSpacing.sm),
            child,
          ],
        ),
      ),
    );
  }
}

/// Etiket–değer satırları (künye). Her satır tek semantik düğümdür.
class KeyValueList extends StatelessWidget {
  const KeyValueList({required this.entries, super.key});

  final List<(String label, String value)> entries;

  @override
  Widget build(BuildContext context) {
    final styles = context.textStyles;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final (label, value) in entries)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
            child: MergeSemantics(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final labelWidget = Text(
                    label,
                    style: styles.labelMedium.copyWith(
                      color: context.colors.onSurfaceVariant,
                    ),
                  );
                  final valueWidget = SelectableText(
                    value,
                    style: styles.bodyMedium,
                  );
                  if (constraints.maxWidth < 420) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [labelWidget, valueWidget],
                    );
                  }
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: 160, child: labelWidget),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(child: valueWidget),
                    ],
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}
