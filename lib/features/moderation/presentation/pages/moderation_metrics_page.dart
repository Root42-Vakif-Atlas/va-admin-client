import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakif_atlas_admin/core/keyboard/app_shortcuts.dart';
import 'package:vakif_atlas_admin/core/l10n/failure_messages.dart';
import 'package:vakif_atlas_admin/core/l10n/formatters.dart';
import 'package:vakif_atlas_admin/core/l10n/l10n.dart';
import 'package:vakif_atlas_admin/core/theme/theme_context.dart';
import 'package:vakif_atlas_admin/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas_admin/features/moderation/domain/entities/moderated_memory.dart';
import 'package:vakif_atlas_admin/features/moderation/domain/entities/moderation_metrics.dart';
import 'package:vakif_atlas_admin/features/moderation/presentation/cubit/moderation_cubits.dart';
import 'package:vakif_atlas_admin/features/moderation/presentation/widgets/moderation_labels.dart';
import 'package:vakif_atlas_admin/shared/widgets/molecules/filter_menu.dart';
import 'package:vakif_atlas_admin/shared/widgets/organisms/metric_widgets.dart';
import 'package:vakif_atlas_admin/shared/widgets/templates/admin_page.dart';
import 'package:vakif_atlas_admin/shared/widgets/templates/loading_status_view.dart';
import 'package:vakif_atlas_admin/shared/widgets/templates/status_message_view.dart';
import 'package:vakif_atlas_admin/core/theme/responsive.dart';

/// YZ moderasyon metrikleri (ADR 58): karar dağılımı, insan incelemesi,
/// personel düzeltmeleri (doğruluk vekili), skor histogramı, kategori ve
/// gecikme. Eşikler sunucu yapılandırmasından okunur (salt bilgi).
class ModerationMetricsPage extends StatelessWidget {
  const ModerationMetricsPage({
    required this.onBack,
    required this.onOpenQueue,
    super.key,
  });

  final VoidCallback onBack;

  /// Göstergeden ilgili kuyruğa (`pending` / `autoRejected`).
  final ValueChanged<ModerationQueue> onOpenQueue;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<ModerationMetricsCubit>();
    return BlocBuilder<ModerationMetricsCubit, ModerationMetricsState>(
      builder: (context, state) {
        final metrics = state.metrics;
        final locale = Localizations.localeOf(context).toString();
        String score(double value) => formatAiScore(value, locale);
        return Actions(
          actions: {
            RefreshIntent: CallbackAction<RefreshIntent>(
              onInvoke: (_) => unawaited(cubit.load()),
            ),
          },
          child: Focus(
            autofocus: true,
            child: AdminPage(
              title: l10n.moderationMetricsTitle,
              subtitle: metrics == null
                  ? null
                  : l10n.moderationMetricsSubtitle(
                      metrics.modelVersion ?? '–',
                      score(metrics.thresholds.approveBelow),
                      score(metrics.thresholds.rejectFrom),
                    ),
              dividerBelowHeader: false,
              actions: [
                SortMenu<int>(
                  label: l10n.moderationMetricsPeriod,
                  value: state.days,
                  options: [
                    for (final days in ModerationMetricsCubit.periods)
                      FilterOption(days, l10n.moderationMetricsDays(days)),
                  ],
                  onChanged: (days) => unawaited(cubit.load(days)),
                ),
                OutlinedButton(
                  onPressed: state.loading
                      ? null
                      : () => unawaited(cubit.load()),
                  child: Text(l10n.dashboardRefresh),
                ),
                OutlinedButton(
                  onPressed: onBack,
                  child: Text(l10n.moderationMetricsBack),
                ),
              ],
              child: switch ((metrics, state.failure)) {
                (null, final failure?) => StatusMessageView(
                  tone: StatusMessageTone.error,
                  title: l10n.commonLoadError,
                  message: failure.toUserMessage(l10n),
                  actionLabel: l10n.commonRetry,
                  onAction: () => unawaited(cubit.load()),
                ),
                (null, _) => LoadingStatusView(label: l10n.commonLoading),
                (final metrics?, _) => _MetricsBody(
                  metrics: metrics,
                  formatScore: score,
                  onOpenQueue: onOpenQueue,
                ),
              },
            ),
          ),
        );
      },
    );
  }
}

class _MetricsBody extends StatelessWidget {
  const _MetricsBody({
    required this.metrics,
    required this.formatScore,
    required this.onOpenQueue,
  });

  final ModerationMetrics metrics;
  final String Function(double) formatScore;
  final ValueChanged<ModerationQueue> onOpenQueue;

  String _percent(BuildContext context, int part, int whole) =>
      whole == 0 ? '–' : context.formatDecimal(part * 100 / whole);

  String _duration(BuildContext context, int? minutes) {
    final l10n = context.l10n;
    return switch (minutes) {
      null => '–',
      < 60 => l10n.metricsMinutes(minutes),
      < 1440 => l10n.metricsHours(minutes ~/ 60, minutes % 60),
      _ => l10n.metricsDaysDuration(minutes ~/ 1440),
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final totals = metrics.totals;
    final review = metrics.humanReview;
    final overrides = metrics.overrides;
    final handled = totals.handled;
    String share(int count) =>
        l10n.metricsShareOfTotal(_percent(context, count, handled));

    final panels = <Widget>[
      BreakdownPanel(
        title: l10n.metricsHumanReviewTitle,
        actionLabel: l10n.dashboardOpenQueue,
        onAction: () => onOpenQueue(ModerationQueue.pending),
        sections: [
          FactList(
            title: l10n.metricsHumanReviewTitle,
            entries: [
              (l10n.metricsWaiting, context.formatNumber(review.waiting)),
              (
                l10n.metricsOldestWaiting,
                _duration(context, review.oldestWaitingMinutes),
              ),
              (l10n.metricsDecided, context.formatNumber(review.decided)),
              (
                l10n.metricsReviewApproved,
                context.formatNumber(review.approved),
              ),
              (
                l10n.metricsReviewRejected,
                context.formatNumber(review.rejected),
              ),
              (
                l10n.metricsMedianDecision,
                _duration(context, review.medianDecisionMinutes),
              ),
            ],
          ),
        ],
      ),
      BreakdownPanel(
        title: l10n.metricsAccuracyTitle,
        actionLabel: l10n.moderationQueueAutoRejected,
        onAction: () => onOpenQueue(ModerationQueue.autoRejected),
        sections: [
          FactList(
            title: l10n.metricsAccuracyTitle,
            entries: [
              (
                l10n.metricsAutoRejectRestored,
                context.formatNumber(overrides.autoRejectRestored),
              ),
              (
                l10n.metricsOverrideRate,
                l10n.metricsPercent(
                  _percent(
                    context,
                    overrides.autoRejectRestored,
                    totals.autoRejected,
                  ),
                ),
              ),
              (
                l10n.metricsAutoApproveRemoved,
                context.formatNumber(overrides.autoApproveRemoved),
              ),
              (
                l10n.metricsReviewApprovalRate,
                l10n.metricsPercent(
                  _percent(context, review.approved, review.decided),
                ),
              ),
            ],
          ),
        ],
      ),
      BreakdownPanel(
        title: l10n.metricsHistogramTitle,
        sections: [
          Breakdown(
            title: l10n.metricsHistogramTitle,
            entries: [
              for (final bin in metrics.histogram.reversed)
                BreakdownEntry(
                  l10n.metricsBinLabel(
                    formatScore(bin.from),
                    formatScore(bin.to),
                    bin.approved,
                    bin.pending,
                    bin.rejected,
                  ),
                  bin.total,
                  emphasis: bin.from >= metrics.thresholds.rejectFrom - 0.1,
                ),
            ],
          ),
        ],
      ),
      BreakdownPanel(
        title: l10n.metricsCategoriesTitle,
        sections: [
          Breakdown(
            title: l10n.metricsCategoriesTitle,
            entries: [
              for (final MapEntry(:key, :value) in metrics.categories.entries)
                BreakdownEntry(key.label(l10n), value),
            ],
          ),
        ],
      ),
      BreakdownPanel(
        title: l10n.metricsModelTitle,
        sections: [
          FactList(
            title: l10n.metricsModelTitle,
            entries: [
              (l10n.metricsModelVersion, metrics.modelVersion ?? '–'),
              (
                l10n.metricsApproveThreshold,
                '< ${formatScore(metrics.thresholds.approveBelow)}',
              ),
              (
                l10n.metricsRejectThreshold,
                '≥ ${formatScore(metrics.thresholds.rejectFrom)}',
              ),
              (
                l10n.metricsPhotoRule,
                metrics.thresholds.reviewPhotos
                    ? l10n.metricsPhotoRuleReview
                    : l10n.metricsPhotoRuleText,
              ),
              (
                l10n.metricsLatencyP50,
                metrics.latency.p50Ms == null
                    ? '–'
                    : l10n.metricsMs(metrics.latency.p50Ms!),
              ),
              (
                l10n.metricsLatencyP95,
                metrics.latency.p95Ms == null
                    ? '–'
                    : l10n.metricsMs(metrics.latency.p95Ms!),
              ),
            ],
          ),
        ],
      ),
      BreakdownPanel(
        title: l10n.metricsDailyTitle,
        sections: [
          FactList(
            title: l10n.metricsDailyTitle,
            entries: [
              for (final day in metrics.daily.reversed.take(14))
                (
                  context.formatDate(day.date),
                  l10n.metricsDayLine(
                    day.autoApproved,
                    day.review,
                    day.autoRejected,
                  ),
                ),
            ],
          ),
        ],
      ),
    ];

    return ListView(
      padding: EdgeInsets.all(context.pageGutter),
      children: [
        if (metrics.mode != 'ai') ...[
          Text(
            l10n.moderationMetricsModeOff(metrics.mode),
            style: context.textStyles.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        MetricStrip(
          metrics: [
            MetricTile(label: l10n.metricsShared, value: totals.shared),
            MetricTile(
              label: l10n.metricsAutoApproved,
              value: totals.autoApproved,
              caption: share(totals.autoApproved),
            ),
            MetricTile(
              label: l10n.metricsReview,
              value: totals.review,
              caption: share(totals.review),
              onTap: () => onOpenQueue(ModerationQueue.pending),
            ),
            MetricTile(
              label: l10n.metricsAutoRejected,
              value: totals.autoRejected,
              caption: share(totals.autoRejected),
              onTap: () => onOpenQueue(ModerationQueue.autoRejected),
            ),
            MetricTile(
              label: l10n.metricsUnscored,
              value: totals.unscored,
              caption: share(totals.unscored),
              captionTone: totals.unscored > 0
                  ? MetricCaptionTone.danger
                  : MetricCaptionTone.muted,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        if (handled == 0)
          StatusMessageView(
            title: l10n.moderationMetricsTitle,
            message: l10n.metricsNoData,
          )
        else
          PanelGrid(panels: panels),
      ],
    );
  }
}
