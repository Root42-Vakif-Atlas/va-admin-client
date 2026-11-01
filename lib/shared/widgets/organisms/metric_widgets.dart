import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:vakif_atlas_admin/core/l10n/formatters.dart';
import 'package:vakif_atlas_admin/core/l10n/l10n.dart';
import 'package:vakif_atlas_admin/core/theme/theme_context.dart';
import 'package:vakif_atlas_admin/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas_admin/core/theme/tokens/app_typography.dart';

// Pano ve moderasyon metrikleri ortak bileşenleri (A12): gösterge şeridi,
// döküm panelleri (oranlı çubuk + sayı), etiket–değer listesi.

enum MetricCaptionTone { muted, danger }

/// Ana gösterge: etiket, büyük sayı, kısa açıklama. Tamamı tek düğmedir.
class MetricTile extends StatelessWidget {
  const MetricTile({
    required this.label,
    required this.value,
    this.onTap,
    this.caption,
    this.captionTone = MetricCaptionTone.muted,
    this.failed = false,
    super.key,
  });

  final String label;
  final int? value;
  final String? caption;
  final MetricCaptionTone captionTone;
  final bool failed;

  /// Boşsa gösterge salt bilgidir (düğme değildir).
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final styles = context.textStyles;
    final number = value == null ? '–' : context.formatNumber(value!);
    final note = failed ? l10n.dashboardSectionError : caption;
    final noteColor = failed || captionTone == MetricCaptionTone.danger
        ? colors.error
        : colors.onSurfaceVariant;
    final content = Padding(
      padding: const EdgeInsets.all(AppSpacing.md + AppSpacing.xxs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: styles.labelLarge.copyWith(
              color: colors.onSurfaceVariant,
              fontWeight: FontWeight.w500,
              fontVariations: const [FontVariation('wght', 500)],
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(number, style: styles.displayMedium),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            note ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: styles.bodySmall.copyWith(color: noteColor),
          ),
        ],
      ),
    );
    final semanticsLabel = [label, number, ?note].join(', ');
    if (onTap == null) {
      return Semantics(
        label: semanticsLabel,
        excludeSemantics: true,
        child: content,
      );
    }
    return Semantics(
      button: true,
      label: semanticsLabel,
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        hoverColor: colors.surfaceVariant,
        child: content,
      ),
    );
  }
}

/// Göstergeler tek kartta yan yana, aralarında ince ayraç; dar pencerede
/// ikişerli satırlar.
class MetricStrip extends StatelessWidget {
  const MetricStrip({required this.metrics, super.key});

  final List<Widget> metrics;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final divider = BorderSide(color: colors.outlineVariant);
    return SurfaceCard(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final perRow = constraints.maxWidth >= metrics.length * 200
              ? metrics.length
              : math.min(2, metrics.length);
          final rows = <List<Widget>>[
            for (var i = 0; i < metrics.length; i += perRow)
              metrics.sublist(i, math.min(i + perRow, metrics.length)),
          ];
          return Column(
            children: [
              for (final (rowIndex, row) in rows.indexed)
                DecoratedBox(
                  decoration: BoxDecoration(
                    border: rowIndex == 0 ? null : Border(top: divider),
                  ),
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (var i = 0; i < perRow; i++)
                          Expanded(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                border: i == 0 ? null : Border(left: divider),
                              ),
                              child: i < row.length
                                  ? row[i]
                                  : const SizedBox.shrink(),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

/// Döküm panelleri: geniş pencerede iki sütun.
class PanelGrid extends StatelessWidget {
  const PanelGrid({required this.panels, super.key});

  final List<Widget> panels;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns =
            constraints.maxWidth >=
                2 * AppSizes.breakdownPanelMinWidth + AppSpacing.lg
            ? 2
            : 1;
        final width =
            (constraints.maxWidth - (columns - 1) * AppSpacing.lg) / columns;
        return Wrap(
          spacing: AppSpacing.lg,
          runSpacing: AppSpacing.lg,
          children: [
            for (final panel in panels) SizedBox(width: width, child: panel),
          ],
        );
      },
    );
  }
}

class SurfaceCard extends StatelessWidget {
  const SurfaceCard({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Material(
      color: colors.surfaceElevated,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        side: BorderSide(
          color: colors.isHighContrast ? colors.outline : colors.outlineVariant,
        ),
      ),
      child: child,
    );
  }
}

/// Başlıklı döküm paneli; başlıkta kuyruğa giden bağlantı.
class BreakdownPanel extends StatelessWidget {
  const BreakdownPanel({
    required this.title,
    required this.sections,
    this.actionLabel,
    this.onAction,
    super.key,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;
  final List<Widget> sections;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md + AppSpacing.xxs,
              AppSpacing.xs,
              AppSpacing.xs,
              AppSpacing.xs,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Semantics(
                    header: true,
                    child: Text(title, style: context.textStyles.titleMedium),
                  ),
                ),
                if (actionLabel case final label?)
                  TextButton(onPressed: onAction, child: Text(label))
                else
                  const SizedBox(height: AppSizes.minTouchTarget),
              ],
            ),
          ),
          Divider(height: AppSizes.borderThin, color: colors.outlineVariant),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md + AppSpacing.xxs,
              AppSpacing.md,
              AppSpacing.md + AppSpacing.xxs,
              AppSpacing.md,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final (index, section) in sections.indexed) ...[
                  if (index > 0) const SizedBox(height: AppSpacing.lg),
                  section,
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Bir döküm satırı.
@immutable
class BreakdownEntry {
  const BreakdownEntry(
    this.label,
    this.count, {
    this.emphasis = false,
    this.onTap,
  });

  final String label;
  final int count;

  /// Kritik değer: çubuk hata renginde (etiket zaten durumu söyler).
  final bool emphasis;
  final VoidCallback? onTap;
}

/// Alt başlık + yatay çubuklu sayı listesi. Çubuk uzunluğu en büyük değere
/// oranlıdır; sayı ve etiket her zaman metin olarak yazılır.
class Breakdown extends StatelessWidget {
  const Breakdown({required this.title, required this.entries, super.key});

  final String title;
  final List<BreakdownEntry> entries;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final styles = context.textStyles;
    final maximum = entries.fold<int>(0, (m, e) => math.max(m, e.count));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: styles.labelMedium.copyWith(color: colors.onSurfaceVariant),
        ),
        const SizedBox(height: AppSpacing.xs),
        for (final entry in entries)
          _BarRow(
            label: entry.label,
            value: context.formatNumber(entry.count),
            fraction: maximum == 0 ? 0 : entry.count / maximum,
            emphasis: entry.emphasis && entry.count > 0,
            onTap: entry.onTap,
          ),
      ],
    );
  }
}

/// 0–1 olasılıklar (ör. YZ kategori skorları): çubuk mutlak ölçekte,
/// [emphasisFrom] ve üstü hata renginde; değer metin olarak yazılır.
class ScoreBreakdown extends StatelessWidget {
  const ScoreBreakdown({
    required this.title,
    required this.entries,
    required this.formatScore,
    this.emphasisFrom,
    super.key,
  });

  final String title;
  final List<(String, double)> entries;
  final String Function(double) formatScore;
  final double? emphasisFrom;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: context.textStyles.labelMedium.copyWith(
            color: colors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        for (final (label, score) in entries)
          _BarRow(
            label: label,
            value: formatScore(score),
            fraction: score,
            emphasis: emphasisFrom != null && score >= emphasisFrom!,
          ),
      ],
    );
  }
}

class _BarRow extends StatelessWidget {
  const _BarRow({
    required this.label,
    required this.value,
    required this.fraction,
    this.emphasis = false,
    this.onTap,
  });

  final String label;
  final String value;
  final double fraction;
  final bool emphasis;
  final VoidCallback? onTap;

  static const double _barHeight = 6;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final styles = context.textStyles;
    final barColor = emphasis ? colors.error : colors.accentText;
    final row = Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs + 2),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: styles.bodyMedium,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            flex: 6,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(_barHeight / 2),
              child: SizedBox(
                height: _barHeight,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ColoredBox(color: colors.surfaceVariant),
                    ),
                    FractionallySizedBox(
                      widthFactor: fraction.clamp(0, 1),
                      heightFactor: 1,
                      child: ColoredBox(color: barColor),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          SizedBox(
            width: AppSpacing.xxl,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: styles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                fontVariations: const [FontVariation('wght', 600)],
                fontFeatures: AppTypography.tabularFigures,
              ),
            ),
          ),
        ],
      ),
    );
    final semanticsLabel = '$label: $value';
    // container: her çubuk ayrı düğüm (yoksa bölüm başlığına birleşip tek
    // uzun etiket olarak okunuyordu).
    if (onTap == null) {
      return Semantics(
        container: true,
        label: semanticsLabel,
        excludeSemantics: true,
        child: row,
      );
    }
    return Semantics(
      container: true,
      button: true,
      label: semanticsLabel,
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.xs),
        child: row,
      ),
    );
  }
}

/// Etiket–değer satırları (sayı olmayan bilgiler, ör. katalog sürümü).
class FactList extends StatelessWidget {
  const FactList({required this.title, required this.entries, super.key});

  final String title;
  final List<(String, String)> entries;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final styles = context.textStyles;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: styles.labelMedium.copyWith(color: colors.onSurfaceVariant),
        ),
        const SizedBox(height: AppSpacing.xs),
        for (final (label, value) in entries)
          MergeSemantics(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
              child: Row(
                children: [
                  Expanded(child: Text(label, style: styles.bodyMedium)),
                  Text(
                    value,
                    style: styles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      fontVariations: const [FontVariation('wght', 600)],
                      fontFeatures: AppTypography.tabularFigures,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
