import 'package:flutter/material.dart';
import 'package:vakif_atlas_admin/core/l10n/formatters.dart';
import 'package:vakif_atlas_admin/core/l10n/l10n.dart';
import 'package:vakif_atlas_admin/core/theme/theme_context.dart';
import 'package:vakif_atlas_admin/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas_admin/features/civil_protection/domain/entities/damage_report.dart';
import 'package:vakif_atlas_admin/features/civil_protection/presentation/widgets/report_labels.dart';

/// Kuyruk satırı: kayıt numarası, eser, durum, aciliyet, YZ kanıt etiketi
/// (değerlendirildiyse), tarih.
class ReportTile extends StatelessWidget {
  const ReportTile({
    required this.report,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final DamageReport report;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    return Semantics(
      button: true,
      selected: selected,
      label: [
        l10n.reportTileSemantics(
          report.referenceCode,
          report.monument.name,
          report.status.label(l10n),
          report.urgency.label(l10n),
        ),
        if (report.evidence case final evidence?)
          l10n.evidenceChipSemantics(evidence.level.label(l10n)),
      ].join(', '),
      excludeSemantics: true,
      child: Material(
        color: selected ? colors.secondaryContainer : Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: colors.outlineVariant)),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        report.referenceCode,
                        style: context.textStyles.labelLarge.copyWith(
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ),
                    Text(
                      context.formatDate(report.createdAt),
                      style: context.textStyles.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  report.monument.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textStyles.titleMedium,
                ),
                Text(
                  '${report.category.label(l10n)} · ${report.monument.city}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textStyles.bodySmall,
                ),
                const SizedBox(height: AppSpacing.xs),
                Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xxs,
                  children: [
                    report.status.chip(l10n),
                    report.urgency.chip(l10n),
                    if (report.evidence case final evidence?)
                      evidence.level.chip(l10n),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
