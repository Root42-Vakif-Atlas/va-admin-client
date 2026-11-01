import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakif_atlas_admin/core/keyboard/app_shortcuts.dart';
import 'package:vakif_atlas_admin/core/l10n/failure_messages.dart';
import 'package:vakif_atlas_admin/core/l10n/l10n.dart';
import 'package:vakif_atlas_admin/features/civil_protection/domain/entities/damage_report.dart';
import 'package:vakif_atlas_admin/features/civil_protection/presentation/cubit/reports_cubits.dart';
import 'package:vakif_atlas_admin/features/civil_protection/presentation/widgets/report_labels.dart';
import 'package:vakif_atlas_admin/features/civil_protection/presentation/widgets/report_tile.dart';
import 'package:vakif_atlas_admin/shared/paging/paged_list_cubit.dart';
import 'package:vakif_atlas_admin/shared/widgets/molecules/filter_menu.dart';
import 'package:vakif_atlas_admin/shared/widgets/molecules/search_field.dart';
import 'package:vakif_atlas_admin/shared/widgets/organisms/paged_list.dart';
import 'package:vakif_atlas_admin/shared/widgets/templates/admin_page.dart';
import 'package:vakif_atlas_admin/shared/widgets/templates/master_detail_layout.dart';
import 'package:vakif_atlas_admin/shared/widgets/templates/status_message_view.dart';

/// Sivil Koruma kuyruğu + seçili raporun ayrıntısı.
class ReportsPage extends StatefulWidget {
  const ReportsPage({
    required this.selectedId,
    required this.detailBuilder,
    required this.onSelect,
    super.key,
  });

  final String? selectedId;

  /// Kompozisyon kökü ayrıntı panelini (cubit'iyle) kurar.
  final Widget Function(String id) detailBuilder;

  /// `null` → seçimi kaldır.
  final ValueChanged<String?> onSelect;

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  final _searchFocus = FocusNode();

  @override
  void dispose() {
    _searchFocus.dispose();
    super.dispose();
  }

  void _update(ReportFilter Function(ReportFilter) change) {
    final cubit = context.read<ReportsQueueCubit>();
    unawaited(cubit.load(change(cubit.state.filter)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<ReportsQueueCubit>();
    return Actions(
      actions: {
        FocusSearchIntent: CallbackAction<FocusSearchIntent>(
          onInvoke: (_) => _searchFocus.requestFocus(),
        ),
        RefreshIntent: CallbackAction<RefreshIntent>(
          onInvoke: (_) => unawaited(cubit.refresh()),
        ),
        CloseDetailIntent: CallbackAction<CloseDetailIntent>(
          onInvoke: (_) => widget.onSelect(null),
        ),
      },
      child: Focus(
        autofocus: true,
        child: AdminPage(
          title: l10n.reportsTitle,
          subtitle: l10n.reportsSubtitle,
          actions: [
            Tooltip(
              message: AppShortcuts.label('R'),
              child: OutlinedButton(
                onPressed: () => unawaited(cubit.refresh()),
                child: Text(l10n.dashboardRefresh),
              ),
            ),
          ],
          toolbar:
              BlocBuilder<
                ReportsQueueCubit,
                PagedListState<DamageReport, ReportFilter>
              >(
                buildWhen: (previous, current) =>
                    previous.filter != current.filter,
                builder: (context, state) => _Filters(
                  filter: state.filter,
                  searchFocus: _searchFocus,
                  onChanged: _update,
                ),
              ),
          child: MasterDetailLayout(
            masterLabel: l10n.reportsListLabel,
            detailLabel: l10n.reportsDetailLabel,
            master:
                BlocBuilder<
                  ReportsQueueCubit,
                  PagedListState<DamageReport, ReportFilter>
                >(
                  builder: (context, state) => PagedList<DamageReport>(
                    items: state.items,
                    total: state.total,
                    isLoading: state.loading,
                    isLoadingMore: state.loadingMore,
                    hasMore: state.hasMore,
                    onLoadMore: () => unawaited(cubit.loadMore()),
                    onRetry: () => unawaited(cubit.refresh()),
                    errorMessage: state.failure?.toUserMessage(l10n),
                    emptyMessage: l10n.reportsEmpty,
                    itemBuilder: (context, report, _) => ReportTile(
                      report: report,
                      selected: report.id == widget.selectedId,
                      onTap: () => widget.onSelect(report.id),
                    ),
                  ),
                ),
            detail: widget.selectedId == null
                ? null
                : KeyedSubtree(
                    key: ValueKey(widget.selectedId),
                    child: widget.detailBuilder(widget.selectedId!),
                  ),
            placeholder: StatusMessageView(
              title: l10n.reportsDetailLabel,
              message: l10n.commonSelectPrompt,
            ),
          ),
        ),
      ),
    );
  }
}

class _Filters extends StatelessWidget {
  const _Filters({
    required this.filter,
    required this.searchFocus,
    required this.onChanged,
  });

  final ReportFilter filter;
  final FocusNode searchFocus;
  final void Function(ReportFilter Function(ReportFilter)) onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return FilterToolbar(
      children: [
        SizedBox(
          width: 320,
          child: SearchField(
            label: l10n.reportsSearch,
            initialValue: filter.query,
            focusNode: searchFocus,
            onChanged: (query) => onChanged((f) => f.copyWith(query: query)),
          ),
        ),
        FilterMenu<Object>(
          label: l10n.reportsFilterStatus,
          options: [
            FilterOption<Object>('open', l10n.reportsFilterOpen),
            for (final status in ReportStatus.values)
              FilterOption<Object>(status, status.label(l10n)),
          ],
          selected: {if (filter.openOnly) 'open', ...filter.statuses},
          onChanged: (selected) => onChanged(
            (f) => f.copyWith(
              openOnly: selected.contains('open'),
              statuses: selected.whereType<ReportStatus>().toSet(),
            ),
          ),
        ),
        FilterMenu<ReportUrgency>(
          label: l10n.reportsFilterUrgency,
          options: [
            for (final urgency in ReportUrgency.values)
              FilterOption(urgency, urgency.label(l10n)),
          ],
          selected: filter.urgencies,
          onChanged: (selected) =>
              onChanged((f) => f.copyWith(urgencies: selected)),
        ),
        FilterMenu<ReportCategory>(
          label: l10n.reportsFilterCategory,
          options: [
            for (final category in ReportCategory.values)
              FilterOption(category, category.label(l10n)),
          ],
          selected: filter.categories,
          onChanged: (selected) =>
              onChanged((f) => f.copyWith(categories: selected)),
        ),
        FilterMenu<EvidenceLevel>(
          label: l10n.reportsFilterEvidence,
          options: [
            for (final level in EvidenceLevel.values)
              FilterOption(level, level.label(l10n)),
          ],
          selected: filter.evidence,
          onChanged: (selected) =>
              onChanged((f) => f.copyWith(evidence: selected)),
        ),
        SortMenu<ReportSort>(
          label: l10n.reportsSort,
          value: filter.sort,
          onChanged: (sort) => onChanged((f) => f.copyWith(sort: sort)),
          options: [
            FilterOption(ReportSort.newest, l10n.reportsSortNewest),
            FilterOption(ReportSort.oldest, l10n.reportsSortOldest),
            FilterOption(ReportSort.urgency, l10n.reportsSortUrgency),
            FilterOption(ReportSort.evidence, l10n.reportsSortEvidence),
          ],
        ),
        if (!filter.isDefault)
          TextButton(
            onPressed: () => onChanged((_) => const ReportFilter()),
            child: Text(l10n.commonClearFilters),
          ),
      ],
    );
  }
}
