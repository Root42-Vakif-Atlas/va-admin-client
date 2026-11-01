import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakif_atlas_admin/core/keyboard/app_shortcuts.dart';
import 'package:vakif_atlas_admin/core/l10n/failure_messages.dart';
import 'package:vakif_atlas_admin/core/l10n/formatters.dart';
import 'package:vakif_atlas_admin/core/l10n/l10n.dart';
import 'package:vakif_atlas_admin/core/theme/theme_context.dart';
import 'package:vakif_atlas_admin/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas_admin/features/feedback/domain/feedback_entry.dart';
import 'package:vakif_atlas_admin/features/feedback/presentation/feedback_cubits.dart';
import 'package:vakif_atlas_admin/features/feedback/presentation/feedback_labels.dart';
import 'package:vakif_atlas_admin/shared/paging/paged_list_cubit.dart';
import 'package:vakif_atlas_admin/shared/widgets/molecules/filter_menu.dart';
import 'package:vakif_atlas_admin/shared/widgets/molecules/search_field.dart';
import 'package:vakif_atlas_admin/shared/widgets/organisms/paged_list.dart';
import 'package:vakif_atlas_admin/shared/widgets/templates/admin_page.dart';
import 'package:vakif_atlas_admin/shared/widgets/templates/master_detail_layout.dart';
import 'package:vakif_atlas_admin/shared/widgets/templates/status_message_view.dart';

typedef _ListState = PagedListState<FeedbackEntry, FeedbackFilter>;

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({
    required this.selectedId,
    required this.detailBuilder,
    required this.onSelect,
    super.key,
  });

  final String? selectedId;
  final Widget Function(String id) detailBuilder;
  final ValueChanged<String?> onSelect;

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final _searchFocus = FocusNode();

  @override
  void dispose() {
    _searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<FeedbackListCubit>();
    void update(FeedbackFilter Function(FeedbackFilter) change) =>
        unawaited(cubit.load(change(cubit.state.filter)));
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
          title: l10n.feedbackTitle,
          subtitle: l10n.feedbackSubtitle,
          actions: [
            OutlinedButton(
              onPressed: () => unawaited(cubit.refresh()),
              child: Text(l10n.dashboardRefresh),
            ),
          ],
          toolbar: BlocBuilder<FeedbackListCubit, _ListState>(
            buildWhen: (previous, current) => previous.filter != current.filter,
            builder: (context, state) {
              final filter = state.filter;
              return FilterToolbar(
                children: [
                  SizedBox(
                    width: 320,
                    child: SearchField(
                      label: l10n.feedbackSearch,
                      initialValue: filter.query,
                      focusNode: _searchFocus,
                      onChanged: (query) =>
                          update((f) => f.copyWith(query: query)),
                    ),
                  ),
                  FilterMenu<FeedbackStatus>(
                    label: l10n.feedbackFilterStatus,
                    options: [
                      for (final status in FeedbackStatus.values)
                        FilterOption(status, status.label(l10n)),
                    ],
                    selected: filter.statuses,
                    onChanged: (selected) =>
                        update((f) => f.copyWith(statuses: selected)),
                  ),
                  FilterMenu<FeedbackCategory>(
                    label: l10n.feedbackFilterCategory,
                    options: [
                      for (final category in FeedbackCategory.values)
                        FilterOption(category, category.label(l10n)),
                    ],
                    selected: filter.categories,
                    onChanged: (selected) =>
                        update((f) => f.copyWith(categories: selected)),
                  ),
                  FilterMenu<int>(
                    label: l10n.feedbackFilterRating,
                    options: [
                      for (var rating = 1; rating <= 5; rating++)
                        FilterOption(rating, '$rating ★'),
                      FilterOption(0, l10n.feedbackNoRating),
                    ],
                    selected: filter.ratings,
                    onChanged: (selected) =>
                        update((f) => f.copyWith(ratings: selected)),
                  ),
                  if (!filter.isDefault)
                    TextButton(
                      onPressed: () => update((_) => const FeedbackFilter()),
                      child: Text(l10n.commonClearFilters),
                    ),
                ],
              );
            },
          ),
          child: MasterDetailLayout(
            masterLabel: l10n.feedbackListLabel,
            detailLabel: l10n.feedbackDetailLabel,
            master: BlocBuilder<FeedbackListCubit, _ListState>(
              builder: (context, state) => PagedList<FeedbackEntry>(
                items: state.items,
                total: state.total,
                isLoading: state.loading,
                isLoadingMore: state.loadingMore,
                hasMore: state.hasMore,
                onLoadMore: () => unawaited(cubit.loadMore()),
                onRetry: () => unawaited(cubit.refresh()),
                errorMessage: state.failure?.toUserMessage(l10n),
                itemBuilder: (context, entry, _) => _FeedbackTile(
                  entry: entry,
                  selected: entry.id == widget.selectedId,
                  onTap: () => widget.onSelect(entry.id),
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
              title: l10n.feedbackDetailLabel,
              message: l10n.commonSelectPrompt,
            ),
          ),
        ),
      ),
    );
  }
}

class _FeedbackTile extends StatelessWidget {
  const _FeedbackTile({
    required this.entry,
    required this.selected,
    required this.onTap,
  });

  final FeedbackEntry entry;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final rating = entry.rating;
    return Semantics(
      button: true,
      selected: selected,
      label: l10n.feedbackTileSemantics(
        entry.category.label(l10n),
        entry.status.label(l10n),
        context.formatDate(entry.createdAt),
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
                        entry.category.label(l10n),
                        style: context.textStyles.labelLarge,
                      ),
                    ),
                    if (rating != null) RatingStars(rating: rating),
                  ],
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  entry.message.isEmpty
                      ? l10n.feedbackEmptyMessage
                      : entry.message,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.textStyles.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    entry.status.chip(l10n),
                    const Spacer(),
                    Text(
                      context.formatDate(entry.createdAt),
                      style: context.textStyles.bodySmall,
                    ),
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
