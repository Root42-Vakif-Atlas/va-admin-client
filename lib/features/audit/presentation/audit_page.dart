import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakif_atlas_admin/core/keyboard/app_shortcuts.dart';
import 'package:vakif_atlas_admin/core/l10n/failure_messages.dart';
import 'package:vakif_atlas_admin/core/l10n/formatters.dart';
import 'package:vakif_atlas_admin/core/l10n/l10n.dart';
import 'package:vakif_atlas_admin/core/theme/theme_context.dart';
import 'package:vakif_atlas_admin/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas_admin/features/audit/domain/audit_entry.dart';
import 'package:vakif_atlas_admin/features/audit/presentation/audit_cubit.dart';
import 'package:vakif_atlas_admin/shared/paging/paged_list_cubit.dart';
import 'package:vakif_atlas_admin/shared/widgets/molecules/filter_menu.dart';
import 'package:vakif_atlas_admin/shared/widgets/molecules/search_field.dart';
import 'package:vakif_atlas_admin/shared/widgets/organisms/paged_list.dart';
import 'package:vakif_atlas_admin/shared/widgets/templates/admin_page.dart';

typedef _AuditState = PagedListState<AuditEntry, AuditFilter>;

extension AuditLabels on AppLocalizations {
  String auditService(String service) => switch (service) {
    'identity' => auditServiceIdentity,
    'catalog' => auditServiceCatalog,
    'civil-protection' => auditServiceCivilProtection,
    'memories' => auditServiceMemories,
    'feedback' => auditServiceFeedback,
    _ => service,
  };

  /// Bilinen işlemler okunur metne çevrilir; yenisi kodla gösterilir.
  String auditAction(String action) => switch (action) {
    'staff.signed-in' => auditActionSignedIn,
    'staff.mfa-enrolled' => auditActionMfaEnrolled,
    'staff.recovery-code-used' => auditActionRecoveryUsed,
    'staff.recovery-codes-regenerated' => auditActionRecoveryRegenerated,
    'staff.password-changed' => auditActionPasswordChanged,
    'staff.invited' => auditActionStaffInvited,
    'staff.roles-updated' => auditActionStaffRoles,
    'staff.disabled' => auditActionStaffDisabled,
    'staff.enabled' => auditActionStaffEnabled,
    'staff.mfa-reset' => auditActionStaffMfaReset,
    'staff.sessions-revoked' => auditActionStaffSessions,
    'report.status-changed' => auditActionReportStatus,
    'memory.approved' => auditActionMemoryApproved,
    'memory.rejected' => auditActionMemoryRejected,
    'feedback.triaged' => auditActionFeedbackTriaged,
    'monument.created' => auditActionMonumentCreated,
    'monument.updated' => auditActionMonumentUpdated,
    'monument.archived' => auditActionMonumentArchived,
    'monument.restored' => auditActionMonumentRestored,
    'complex.members-updated' => auditActionComplexMembers,
    _ => action,
  };
}

/// Merkezi denetim kaydı (yalnızca yönetici): en yeni önce, süzgeçli.
class AuditPage extends StatefulWidget {
  const AuditPage({super.key});

  @override
  State<AuditPage> createState() => _AuditPageState();
}

class _AuditPageState extends State<AuditPage> {
  final _searchFocus = FocusNode();

  @override
  void dispose() {
    _searchFocus.dispose();
    super.dispose();
  }

  Future<void> _pickRange(AuditFilter filter) async {
    final cubit = context.read<AuditCubit>();
    final now = DateTime.now();
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2026),
      lastDate: now,
      initialDateRange: filter.from == null
          ? DateTimeRange(
              start: now.subtract(const Duration(days: 7)),
              end: now,
            )
          : DateTimeRange(
              start: filter.from!,
              end: filter.to!.subtract(const Duration(days: 1)),
            ),
    );
    if (range == null) {
      return;
    }
    unawaited(
      cubit.load(
        AuditFilter(
          service: filter.service,
          targetId: filter.targetId,
          from: DateTime(range.start.year, range.start.month, range.start.day),
          to: DateTime(range.end.year, range.end.month, range.end.day + 1),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<AuditCubit>();
    return Actions(
      actions: {
        FocusSearchIntent: CallbackAction<FocusSearchIntent>(
          onInvoke: (_) => _searchFocus.requestFocus(),
        ),
        RefreshIntent: CallbackAction<RefreshIntent>(
          onInvoke: (_) => unawaited(cubit.refresh()),
        ),
      },
      child: Focus(
        autofocus: true,
        child: AdminPage(
          title: l10n.auditTitle,
          subtitle: l10n.auditSubtitle,
          actions: [
            OutlinedButton(
              onPressed: () => unawaited(cubit.refresh()),
              child: Text(l10n.dashboardRefresh),
            ),
          ],
          toolbar: BlocBuilder<AuditCubit, _AuditState>(
            buildWhen: (previous, current) => previous.filter != current.filter,
            builder: (context, state) {
              final filter = state.filter;
              return FilterToolbar(
                searchWidth: 280,
                search: SearchField(
                  label: l10n.auditTargetSearch,
                  initialValue: filter.targetId,
                  focusNode: _searchFocus,
                  onChanged: (id) => unawaited(
                    cubit.load(
                      AuditFilter(
                        service: cubit.state.filter.service,
                        targetId: id,
                        from: cubit.state.filter.from,
                        to: cubit.state.filter.to,
                      ),
                    ),
                  ),
                ),
                children: [
                  FilterMenu<String>(
                    label: l10n.auditFilterService,
                    multiple: false,
                    options: [
                      for (final service in auditServices)
                        FilterOption(service, l10n.auditService(service)),
                    ],
                    selected: {?filter.service},
                    onChanged: (selected) => unawaited(
                      cubit.load(
                        AuditFilter(
                          service: selected.isEmpty ? null : selected.first,
                          targetId: filter.targetId,
                          from: filter.from,
                          to: filter.to,
                        ),
                      ),
                    ),
                  ),
                  ToolbarMenuButton(
                    label: l10n.auditFilterDate,
                    active: filter.from != null,
                    value: filter.from == null
                        ? null
                        : '${context.formatDate(filter.from!)} – '
                              '${context.formatDate(filter.to!.subtract(const Duration(days: 1)))}',
                    onPressed: () => unawaited(_pickRange(filter)),
                  ),
                  if (!filter.isDefault)
                    TextButton(
                      onPressed: () =>
                          unawaited(cubit.load(const AuditFilter())),
                      child: Text(l10n.commonClearFilters),
                    ),
                ],
              );
            },
          ),
          child: BlocBuilder<AuditCubit, _AuditState>(
            builder: (context, state) => PagedList<AuditEntry>(
              items: state.items,
              total: state.total,
              isLoading: state.loading,
              isLoadingMore: state.loadingMore,
              hasMore: state.hasMore,
              onLoadMore: () => unawaited(cubit.loadMore()),
              onRetry: () => unawaited(cubit.refresh()),
              errorMessage: state.failure?.toUserMessage(l10n),
              itemBuilder: (context, entry, _) => _AuditRow(entry: entry),
            ),
          ),
        ),
      ),
    );
  }
}

class _AuditRow extends StatelessWidget {
  const _AuditRow({required this.entry});

  final AuditEntry entry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.outlineVariant)),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        childrenPadding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          0,
          AppSpacing.lg,
          AppSpacing.md,
        ),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        title: Text(
          '${entry.actorName ?? entry.actorId} · ${l10n.auditAction(entry.action)}',
          style: context.textStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            fontVariations: const [FontVariation('wght', 600)],
          ),
        ),
        subtitle: Text(
          '${context.formatDateTime(entry.at)} · ${l10n.auditService(entry.service)} · '
          '${entry.targetType} ${entry.targetId}',
          style: context.textStyles.bodySmall,
        ),
        children: [
          Text(l10n.auditChanges, style: context.textStyles.labelLarge),
          const SizedBox(height: AppSpacing.xxs),
          if (entry.changes.isEmpty)
            Text(l10n.auditNoChanges, style: context.textStyles.bodyMedium)
          else
            for (final MapEntry(:key, :value) in entry.changes.entries)
              SelectableText(
                '$key: ${value ?? '—'}',
                style: context.textStyles.bodyMedium,
              ),
          if (entry.correlationId case final id?) ...[
            const SizedBox(height: AppSpacing.xs),
            SelectableText(
              l10n.auditCorrelation(id),
              style: context.textStyles.bodySmall,
            ),
          ],
        ],
      ),
    );
  }
}
