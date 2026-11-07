import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakif_atlas_admin/core/keyboard/app_shortcuts.dart';
import 'package:vakif_atlas_admin/core/l10n/formatters.dart';
import 'package:vakif_atlas_admin/core/l10n/l10n.dart';
import 'package:vakif_atlas_admin/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas_admin/features/auth/domain/entities/staff_role.dart';
import 'package:vakif_atlas_admin/features/catalog/domain/catalog_entities.dart';
import 'package:vakif_atlas_admin/features/catalog/presentation/widgets/catalog_labels.dart';
import 'package:vakif_atlas_admin/features/civil_protection/domain/entities/damage_report.dart';
import 'package:vakif_atlas_admin/features/civil_protection/presentation/widgets/report_labels.dart';
import 'package:vakif_atlas_admin/features/dashboard/domain/entities/dashboard_summary.dart';
import 'package:vakif_atlas_admin/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:vakif_atlas_admin/features/feedback/domain/feedback_entry.dart';
import 'package:vakif_atlas_admin/features/feedback/presentation/feedback_labels.dart';
import 'package:vakif_atlas_admin/shared/widgets/organisms/metric_widgets.dart';
import 'package:vakif_atlas_admin/shared/widgets/templates/admin_page.dart';
import 'package:vakif_atlas_admin/shared/widgets/templates/status_message_view.dart';
import 'package:vakif_atlas_admin/core/theme/responsive.dart';

/// Hedef kuyruk (süzgeçli).
enum DashboardTarget {
  criticalReports,
  openReports,
  strongEvidenceReports,
  unverifiedEvidenceReports,
  suspiciousEvidenceReports,
  pendingEvidenceReports,
  pendingMemories,
  reportedMemories,
  autoRejectedMemories,
  newFeedback,
  catalog,
}

/// Pano: üstte rolün açtığı bölümlerin ana göstergeleri (tek şerit), altında
/// bölüm başına döküm (durum, aciliyet, konu, tür). Göstergeler ve döküm
/// satırları ilgili kuyruğa süzgeçle götürür. Özet kabuk seviyesindeki
/// `DashboardCubit`'ten okunur.
class DashboardPage extends StatelessWidget {
  const DashboardPage({
    required this.displayName,
    required this.onOpen,
    super.key,
  });

  final String displayName;
  final ValueChanged<DashboardTarget> onOpen;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<DashboardCubit>().state;
    final cubit = context.read<DashboardCubit>();
    final allowed = state.permissions;
    final summary = state.summary;
    bool failed(StaffPermission permission) =>
        state.failures.containsKey(permission);

    final metrics = <Widget>[
      if (allowed.contains(StaffPermission.civilProtection))
        _reportsMetric(context, summary.reports, failed),
      if (allowed.contains(StaffPermission.memories))
        _moderationMetric(context, summary.moderation, failed),
      if (allowed.contains(StaffPermission.feedback))
        _feedbackMetric(context, summary.feedback, failed),
      if (allowed.contains(StaffPermission.catalog))
        _catalogMetric(context, summary.catalog, failed),
    ];
    final panels = <Widget>[
      if (summary.reports case final reports?)
        _ReportsPanel(summary: reports, onOpen: onOpen),
      if (summary.moderation case final moderation?)
        _ModerationPanel(summary: moderation, onOpen: onOpen),
      if (summary.feedback case final feedback?)
        _FeedbackPanel(summary: feedback, onOpen: onOpen),
      if (summary.catalog case final catalog?)
        _CatalogPanel(summary: catalog, onOpen: onOpen),
    ];

    return Actions(
      actions: {
        RefreshIntent: CallbackAction<RefreshIntent>(
          onInvoke: (_) => unawaited(cubit.refresh()),
        ),
      },
      child: Focus(
        autofocus: true,
        child: AdminPage(
          title: l10n.dashboardGreeting(displayName),
          subtitle: state.updatedAt == null
              ? null
              : l10n.dashboardUpdatedAt(
                  context.formatDateTime(state.updatedAt!),
                ),
          dividerBelowHeader: false,
          actions: [
            Tooltip(
              message: AppShortcuts.label('R'),
              child: OutlinedButton(
                onPressed: state.loading
                    ? null
                    : () => unawaited(cubit.refresh()),
                child: state.loading
                    ? const SizedBox.square(
                        dimension: AppSizes.iconSm,
                        child: CircularProgressIndicator(
                          strokeWidth: AppSizes.spinnerStroke,
                        ),
                      )
                    : Text(l10n.dashboardRefresh),
              ),
            ),
          ],
          child: metrics.isEmpty
              ? StatusMessageView(
                  title: l10n.dashboardTitle,
                  message: l10n.dashboardNoSections,
                )
              : SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    context.pageGutter,
                    AppSpacing.xs,
                    context.pageGutter,
                    AppSpacing.lg,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      MetricStrip(metrics: metrics),
                      if (panels.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.lg),
                        PanelGrid(panels: panels),
                      ],
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _reportsMetric(
    BuildContext context,
    ReportsSummary? summary,
    bool Function(StaffPermission) failed,
  ) {
    final l10n = context.l10n;
    final critical = summary?.critical ?? 0;
    return MetricTile(
      label: l10n.dashboardMetricOpenReports,
      value: summary?.open,
      failed: summary == null && failed(StaffPermission.civilProtection),
      caption: summary == null
          ? null
          : critical > 0
          ? l10n.dashboardReportsCritical(critical)
          : l10n.dashboardReportsNoCritical,
      captionTone: critical > 0
          ? MetricCaptionTone.danger
          : MetricCaptionTone.muted,
      onTap: () => onOpen(
        critical > 0
            ? DashboardTarget.criticalReports
            : DashboardTarget.openReports,
      ),
    );
  }

  Widget _moderationMetric(
    BuildContext context,
    ModerationSummary? summary,
    bool Function(StaffPermission) failed,
  ) {
    final l10n = context.l10n;
    return MetricTile(
      label: l10n.dashboardMetricModeration,
      value: summary?.actionable,
      failed: summary == null && failed(StaffPermission.memories),
      caption: summary == null
          ? null
          : '${l10n.dashboardModerationPending(summary.pending)} · '
                '${l10n.dashboardModerationReported(summary.reported)}',
      onTap: () => onOpen(
        (summary?.pending ?? 0) > 0 || (summary?.reported ?? 0) == 0
            ? DashboardTarget.pendingMemories
            : DashboardTarget.reportedMemories,
      ),
    );
  }

  Widget _feedbackMetric(
    BuildContext context,
    FeedbackSummary? summary,
    bool Function(StaffPermission) failed,
  ) {
    final l10n = context.l10n;
    final average = summary?.averageRating;
    return MetricTile(
      label: l10n.dashboardMetricFeedback,
      value: summary?.newCount,
      failed: summary == null && failed(StaffPermission.feedback),
      caption: summary == null
          ? null
          : average == null
          ? l10n.dashboardFeedbackNoRating
          : l10n.dashboardFeedbackRating(
              context.formatDecimal(average),
              summary.ratingCount,
            ),
      onTap: () => onOpen(DashboardTarget.newFeedback),
    );
  }

  Widget _catalogMetric(
    BuildContext context,
    CatalogSummary? summary,
    bool Function(StaffPermission) failed,
  ) {
    final l10n = context.l10n;
    return MetricTile(
      label: l10n.dashboardMetricCatalog,
      value: summary?.published,
      failed: summary == null && failed(StaffPermission.catalog),
      caption: summary == null
          ? null
          : l10n.dashboardCatalogArchived(summary.archived),
      onTap: () => onOpen(DashboardTarget.catalog),
    );
  }
}

class _ReportsPanel extends StatelessWidget {
  const _ReportsPanel({required this.summary, required this.onOpen});

  final ReportsSummary summary;
  final ValueChanged<DashboardTarget> onOpen;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BreakdownPanel(
      title: l10n.dashboardReportsTitle,
      actionLabel: l10n.dashboardOpenQueue,
      onAction: () => onOpen(DashboardTarget.openReports),
      sections: [
        Breakdown(
          title: l10n.dashboardOpenByUrgency,
          entries: [
            for (final urgency in ReportUrgency.values)
              BreakdownEntry(
                urgency.label(l10n),
                summary.openByUrgency[urgency.wireName] ?? 0,
                emphasis: urgency == ReportUrgency.critical,
                onTap: urgency == ReportUrgency.critical
                    ? () => onOpen(DashboardTarget.criticalReports)
                    : null,
              ),
          ],
        ),
        if (summary.openByEvidence.isNotEmpty)
          Breakdown(
            title: l10n.dashboardOpenByEvidence,
            entries: [
              for (final (level, target) in const [
                (EvidenceLevel.strong, DashboardTarget.strongEvidenceReports),
                (
                  EvidenceLevel.unverified,
                  DashboardTarget.unverifiedEvidenceReports,
                ),
                (
                  EvidenceLevel.suspicious,
                  DashboardTarget.suspiciousEvidenceReports,
                ),
                (EvidenceLevel.pending, DashboardTarget.pendingEvidenceReports),
              ])
                BreakdownEntry(
                  level.label(l10n),
                  summary.openByEvidence[level.wireName] ?? 0,
                  emphasis: level == EvidenceLevel.suspicious,
                  onTap: () => onOpen(target),
                ),
            ],
          ),
        Breakdown(
          title: l10n.dashboardByStatus,
          entries: [
            for (final status in ReportStatus.values)
              BreakdownEntry(
                status.label(l10n),
                summary.byStatus[status.wireName] ?? 0,
              ),
          ],
        ),
      ],
    );
  }
}

class _ModerationPanel extends StatelessWidget {
  const _ModerationPanel({required this.summary, required this.onOpen});

  final ModerationSummary summary;
  final ValueChanged<DashboardTarget> onOpen;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BreakdownPanel(
      title: l10n.dashboardModerationTitle,
      actionLabel: l10n.dashboardOpenQueue,
      onAction: () => onOpen(DashboardTarget.pendingMemories),
      sections: [
        Breakdown(
          title: l10n.dashboardByStatus,
          entries: [
            BreakdownEntry(
              l10n.memoryStatusPending,
              summary.pending,
              onTap: () => onOpen(DashboardTarget.pendingMemories),
            ),
            BreakdownEntry(
              l10n.dashboardModerationReportedLabel,
              summary.reported,
              onTap: () => onOpen(DashboardTarget.reportedMemories),
            ),
            BreakdownEntry(
              l10n.memoryHiddenByReports,
              summary.hiddenByReports,
              emphasis: true,
            ),
            BreakdownEntry(l10n.memoryStatusApproved, summary.approved),
            BreakdownEntry(l10n.memoryStatusRejected, summary.rejected),
            BreakdownEntry(
              l10n.dashboardModerationAutoRejected,
              summary.autoRejected24h,
              onTap: () => onOpen(DashboardTarget.autoRejectedMemories),
            ),
            BreakdownEntry(
              l10n.dashboardModerationUnscored,
              summary.unscored,
              emphasis: true,
            ),
          ],
        ),
      ],
    );
  }
}

class _FeedbackPanel extends StatelessWidget {
  const _FeedbackPanel({required this.summary, required this.onOpen});

  final FeedbackSummary summary;
  final ValueChanged<DashboardTarget> onOpen;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BreakdownPanel(
      title: l10n.dashboardFeedbackTitle,
      actionLabel: l10n.dashboardOpenQueue,
      onAction: () => onOpen(DashboardTarget.newFeedback),
      sections: [
        Breakdown(
          title: l10n.dashboardByStatus,
          entries: [
            for (final status in FeedbackStatus.values)
              BreakdownEntry(
                status.label(l10n),
                summary.byStatus[status.wireName] ?? 0,
                onTap: status == FeedbackStatus.newEntry
                    ? () => onOpen(DashboardTarget.newFeedback)
                    : null,
              ),
          ],
        ),
        Breakdown(
          title: l10n.dashboardByTopic,
          entries: [
            for (final category in FeedbackCategory.values)
              BreakdownEntry(
                category.label(l10n),
                summary.byCategory[category.wireName] ?? 0,
              ),
          ],
        ),
      ],
    );
  }
}

class _CatalogPanel extends StatelessWidget {
  const _CatalogPanel({required this.summary, required this.onOpen});

  final CatalogSummary summary;
  final ValueChanged<DashboardTarget> onOpen;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final categories = [
      for (final category in MonumentCategory.values)
        if ((summary.byCategory[category.name] ?? 0) > 0)
          BreakdownEntry(
            category.label(l10n),
            summary.byCategory[category.name]!,
          ),
    ]..sort((a, b) => b.count.compareTo(a.count));
    return BreakdownPanel(
      title: l10n.dashboardCatalogTitle,
      actionLabel: l10n.dashboardOpenCatalog,
      onAction: () => onOpen(DashboardTarget.catalog),
      sections: [
        FactList(
          title: l10n.dashboardCatalogState,
          entries: [
            (
              l10n.publicationPublished,
              context.formatNumber(summary.published),
            ),
            (l10n.publicationArchived, context.formatNumber(summary.archived)),
            (
              l10n.dashboardCatalogNoImages,
              context.formatNumber(summary.withoutImages),
            ),
            (l10n.dashboardCatalogVersionLabel, summary.version),
          ],
        ),
        if (categories.isNotEmpty)
          Breakdown(title: l10n.dashboardByCategory, entries: categories),
      ],
    );
  }
}
