import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakif_atlas_admin/core/keyboard/app_shortcuts.dart';
import 'package:vakif_atlas_admin/core/l10n/failure_messages.dart';
import 'package:vakif_atlas_admin/core/l10n/formatters.dart';
import 'package:vakif_atlas_admin/core/l10n/l10n.dart';
import 'package:vakif_atlas_admin/core/theme/responsive.dart';
import 'package:vakif_atlas_admin/core/theme/theme_context.dart';
import 'package:vakif_atlas_admin/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas_admin/features/moderation/domain/entities/moderated_memory.dart';
import 'package:vakif_atlas_admin/features/moderation/presentation/cubit/moderation_cubits.dart';
import 'package:vakif_atlas_admin/features/moderation/presentation/widgets/moderation_labels.dart';
import 'package:vakif_atlas_admin/shared/paging/paged_list_cubit.dart';
import 'package:vakif_atlas_admin/shared/widgets/molecules/filter_menu.dart';
import 'package:vakif_atlas_admin/shared/widgets/molecules/search_field.dart';
import 'package:vakif_atlas_admin/shared/widgets/organisms/paged_list.dart';
import 'package:vakif_atlas_admin/shared/widgets/templates/admin_page.dart';
import 'package:vakif_atlas_admin/shared/widgets/templates/master_detail_layout.dart';
import 'package:vakif_atlas_admin/shared/widgets/templates/status_message_view.dart';

typedef _QueueState = PagedListState<ModeratedMemory, ModerationFilter>;

/// Moderasyon kuyrukları (bekleyen / bildirilen / kaldırılan / tümü) +
/// seçili anının ayrıntısı.
class ModerationPage extends StatefulWidget {
  const ModerationPage({
    required this.selectedId,
    required this.detailBuilder,
    required this.onSelect,
    required this.onOpenMetrics,
    super.key,
  });

  final String? selectedId;
  final Widget Function(String id) detailBuilder;
  final ValueChanged<String?> onSelect;

  /// YZ moderasyon metrikleri sayfası.
  final VoidCallback onOpenMetrics;

  @override
  State<ModerationPage> createState() => _ModerationPageState();
}

class _ModerationPageState extends State<ModerationPage> {
  final _searchFocus = FocusNode();

  @override
  void dispose() {
    _searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<ModerationQueueCubit>();
    return Actions(
      actions: {
        FocusSearchIntent: CallbackAction<FocusSearchIntent>(
          onInvoke: (_) => _searchFocus.requestFocus(),
        ),
        RefreshIntent: CallbackAction<RefreshIntent>(
          onInvoke: (_) => unawaited(cubit.refresh()),
        ),
        DismissIntent: CloseDetailAction(() => widget.onSelect(null)),
      },
      child: Focus(
        autofocus: true,
        child: AdminPage(
          showHeader: context.isSplitView || widget.selectedId == null,
          title: l10n.moderationTitle,
          subtitle: l10n.moderationSubtitle,
          actions: [
            OutlinedButton(
              onPressed: widget.onOpenMetrics,
              child: Text(l10n.moderationMetricsAction),
            ),
            OutlinedButton(
              onPressed: () => unawaited(cubit.refresh()),
              child: Text(l10n.dashboardRefresh),
            ),
          ],
          toolbar: BlocBuilder<ModerationQueueCubit, _QueueState>(
            buildWhen: (previous, current) => previous.filter != current.filter,
            builder: (context, state) => FilterToolbar(
              search: SearchField(
                label: l10n.moderationSearch,
                initialValue: state.filter.query,
                focusNode: _searchFocus,
                onChanged: (query) => unawaited(
                  cubit.load(cubit.state.filter.copyWith(query: query)),
                ),
              ),
              children: [
                SegmentedButton<ModerationQueue>(
                  showSelectedIcon: false,
                  segments: [
                    ButtonSegment(
                      value: ModerationQueue.pending,
                      label: Text(l10n.moderationQueuePending),
                    ),
                    ButtonSegment(
                      value: ModerationQueue.reported,
                      label: Text(l10n.moderationQueueReported),
                    ),
                    ButtonSegment(
                      value: ModerationQueue.autoRejected,
                      label: Text(l10n.moderationQueueAutoRejected),
                    ),
                    ButtonSegment(
                      value: ModerationQueue.rejected,
                      label: Text(l10n.moderationQueueRejected),
                    ),
                    ButtonSegment(
                      value: ModerationQueue.all,
                      label: Text(l10n.moderationQueueAll),
                    ),
                  ],
                  selected: {state.filter.queue},
                  onSelectionChanged: (selection) => unawaited(
                    cubit.load(state.filter.copyWith(queue: selection.first)),
                  ),
                ),
                if (state.filter.queue == ModerationQueue.pending)
                  SortMenu<ModerationSort>(
                    label: l10n.moderationSortLabel,
                    value: state.filter.sort,
                    options: [
                      FilterOption(
                        ModerationSort.oldest,
                        l10n.moderationSortOldest,
                      ),
                      FilterOption(
                        ModerationSort.aiScore,
                        l10n.moderationSortAiScore,
                      ),
                    ],
                    onChanged: (sort) => unawaited(
                      cubit.load(state.filter.copyWith(sort: sort)),
                    ),
                  ),
              ],
            ),
          ),
          child: MasterDetailLayout(
            onCloseDetail: () => widget.onSelect(null),
            masterLabel: l10n.moderationListLabel,
            detailLabel: l10n.moderationDetailLabel,
            master: BlocBuilder<ModerationQueueCubit, _QueueState>(
              builder: (context, state) => PagedList<ModeratedMemory>(
                items: state.items,
                total: state.total,
                isLoading: state.loading,
                isLoadingMore: state.loadingMore,
                hasMore: state.hasMore,
                onLoadMore: () => unawaited(cubit.loadMore()),
                onRetry: () => unawaited(cubit.refresh()),
                errorMessage: state.failure?.toUserMessage(l10n),
                emptyMessage: switch (state.filter.queue) {
                  ModerationQueue.pending => l10n.moderationEmptyPending,
                  ModerationQueue.reported => l10n.moderationEmptyReported,
                  ModerationQueue.autoRejected =>
                    l10n.moderationEmptyAutoRejected,
                  _ => null,
                },
                itemBuilder: (context, memory, _) => _MemoryTile(
                  memory: memory,
                  selected: memory.id == widget.selectedId,
                  onTap: () => widget.onSelect(memory.id),
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
              title: l10n.moderationDetailLabel,
              message: l10n.commonSelectPrompt,
            ),
          ),
        ),
      ),
    );
  }
}

class _MemoryTile extends StatelessWidget {
  const _MemoryTile({
    required this.memory,
    required this.selected,
    required this.onTap,
  });

  final ModeratedMemory memory;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final reports = memory.reportsChip(l10n);
    final ai = memory.aiChip(l10n, Localizations.localeOf(context).toString());
    return Semantics(
      button: true,
      selected: selected,
      label: l10n.memoryTileSemantics(
        memory.monumentName,
        memory.authorName,
        [memory.statusLabel(l10n), ?ai?.label].join(', '),
      ),
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
                        memory.monumentName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.textStyles.titleMedium,
                      ),
                    ),
                    Text(
                      context.formatDate(memory.createdAt),
                      style: context.textStyles.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  memory.text,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.textStyles.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(memory.authorName, style: context.textStyles.bodySmall),
                const SizedBox(height: AppSpacing.xs),
                Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xxs,
                  children: [memory.statusChip(l10n), ?ai, ?reports],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
