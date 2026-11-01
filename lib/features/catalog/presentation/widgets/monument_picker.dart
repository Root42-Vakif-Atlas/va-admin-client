import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vakif_atlas_admin/core/l10n/failure_messages.dart';
import 'package:vakif_atlas_admin/core/l10n/l10n.dart';
import 'package:vakif_atlas_admin/core/theme/theme_context.dart';
import 'package:vakif_atlas_admin/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas_admin/core/utils/paged.dart';
import 'package:vakif_atlas_admin/core/utils/typedefs.dart';
import 'package:vakif_atlas_admin/features/catalog/domain/catalog_entities.dart';
import 'package:vakif_atlas_admin/features/catalog/presentation/widgets/catalog_labels.dart';
import 'package:vakif_atlas_admin/shared/widgets/molecules/search_field.dart';
import 'package:vakif_atlas_admin/shared/widgets/organisms/paged_list.dart';

/// Katalogda arama (sunucu tarafı, imleçli): sorgu → sayfa.
typedef MonumentSearch = ResultFuture<Paged<CatalogMonumentSummary>> Function(
  String query,
  String? cursor,
);

/// Eserin bağlanacağı külliyeyi seçer (tek seçim; satıra dokunmak seçer).
/// Liste açılır açılmaz tüm külliyeleri gösterir, arama daraltır.
Future<CatalogMonumentSummary?> showComplexPicker(
  BuildContext context, {
  required MonumentSearch search,
  String? selectedId,
}) {
  final l10n = context.l10n;
  return showDialog<CatalogMonumentSummary>(
    context: context,
    builder: (_) => _MonumentPickerDialog(
      title: l10n.pickerComplexTitle,
      searchLabel: l10n.pickerComplexSearch,
      search: search,
      multiple: false,
      currentId: selectedId,
    ),
  );
}

/// Külliyeye eklenecek yapıları seçer (çoklu seçim). [memberIds] zaten
/// bağlı yapılardır (seçilemez); başka külliyedeki yapı işaretlenir, kayıtta
/// bu külliyeye taşınır.
Future<List<CatalogMonumentSummary>> showMembersPicker(
  BuildContext context, {
  required MonumentSearch search,
  required String complexId,
  required Set<String> memberIds,
}) async {
  final l10n = context.l10n;
  final result = await showDialog<List<CatalogMonumentSummary>>(
    context: context,
    builder: (_) => _MonumentPickerDialog(
      title: l10n.pickerMembersTitle,
      searchLabel: l10n.pickerMembersSearch,
      help: l10n.pickerMembersHelp,
      search: search,
      multiple: true,
      currentId: complexId,
      disabledIds: memberIds,
    ),
  );
  return result ?? const [];
}

class _MonumentPickerDialog extends StatefulWidget {
  const _MonumentPickerDialog({
    required this.title,
    required this.searchLabel,
    required this.search,
    required this.multiple,
    this.help,
    this.currentId,
    this.disabledIds = const {},
  });

  final String title;
  final String searchLabel;
  final String? help;
  final MonumentSearch search;
  final bool multiple;

  /// Tek seçimde şu anki seçim; çoklu seçimde düzenlenen külliye.
  final String? currentId;
  final Set<String> disabledIds;

  @override
  State<_MonumentPickerDialog> createState() => _MonumentPickerDialogState();
}

class _MonumentPickerDialogState extends State<_MonumentPickerDialog> {
  final _searchFocus = FocusNode();
  final Map<String, CatalogMonumentSummary> _selected = {};
  List<CatalogMonumentSummary> _items = const [];
  String _query = '';
  String? _cursor;
  int _total = 0;
  bool _loading = true;
  bool _loadingMore = false;
  String? _error;

  /// Eski aramanın geç gelen yanıtı yok sayılır.
  int _generation = 0;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _searchFocus.requestFocus(),
    );
  }

  @override
  void dispose() {
    _searchFocus.dispose();
    super.dispose();
  }

  Future<void> _load({bool more = false}) async {
    final generation = more ? _generation : ++_generation;
    setState(() {
      if (more) {
        _loadingMore = true;
      } else {
        _loading = true;
        _error = null;
      }
    });
    final result = await widget.search(_query, more ? _cursor : null);
    if (!mounted || generation != _generation) {
      return;
    }
    final l10n = context.l10n;
    setState(() {
      _loading = false;
      _loadingMore = false;
      result.fold((failure) => _error = failure.toUserMessage(l10n), (page) {
        _items = more ? [..._items, ...page.items] : page.items;
        _cursor = page.nextCursor;
        _total = page.total;
      });
    });
  }

  void _onSearch(String query) {
    _query = query;
    unawaited(_load());
  }

  void _toggle(CatalogMonumentSummary item) {
    if (!widget.multiple) {
      Navigator.of(context).pop(item);
      return;
    }
    setState(() {
      if (_selected.remove(item.id) == null) {
        _selected[item.id] = item;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final styles = context.textStyles;
    final height = MediaQuery.sizeOf(context).height;
    return Dialog(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: AppSizes.pickerWidth,
          maxHeight: (height * 0.85).clamp(360, 720),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.sm,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Semantics(
                    header: true,
                    child: Text(widget.title, style: styles.titleLarge),
                  ),
                  if (widget.help case final help?) ...[
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      help,
                      style: styles.bodyMedium.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.md),
                  SearchField(
                    label: widget.searchLabel,
                    focusNode: _searchFocus,
                    onChanged: _onSearch,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Semantics(
                    liveRegion: true,
                    child: Text(
                      _loading ? '' : l10n.pickerResultCount(_total),
                      style: styles.labelMedium.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: AppSizes.borderThin, color: colors.outlineVariant),
            Expanded(
              child: PagedList<CatalogMonumentSummary>(
                items: _items,
                total: _total,
                isLoading: _loading,
                isLoadingMore: _loadingMore,
                hasMore: _cursor != null,
                showSummary: false,
                padding: EdgeInsets.zero,
                errorMessage: _error,
                onLoadMore: () => unawaited(_load(more: true)),
                onRetry: () => unawaited(_load()),
                itemBuilder: (context, item, _) => _PickerRow(
                  item: item,
                  multiple: widget.multiple,
                  current: item.id == widget.currentId,
                  disabled:
                      widget.disabledIds.contains(item.id) ||
                      (widget.multiple && item.id == widget.currentId),
                  selected: _selected.containsKey(item.id),
                  movesFrom:
                      widget.multiple &&
                          item.complexId != null &&
                          item.complexId != widget.currentId
                      ? item.complexName ?? item.complexId
                      : null,
                  onTap: () => _toggle(item),
                ),
              ),
            ),
            Divider(height: AppSizes.borderThin, color: colors.outlineVariant),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                children: [
                  if (widget.multiple)
                    Expanded(
                      child: Text(
                        l10n.pickerSelectedCount(_selected.length),
                        style: styles.bodyMedium.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    )
                  else
                    const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(l10n.commonCancel),
                  ),
                  if (widget.multiple) ...[
                    const SizedBox(width: AppSpacing.xs),
                    FilledButton(
                      onPressed: _selected.isEmpty
                          ? null
                          : () =>
                                Navigator.of(context)
                                    .pop(_selected.values.toList()),
                      child: Text(l10n.pickerAdd(_selected.length)),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PickerRow extends StatelessWidget {
  const _PickerRow({
    required this.item,
    required this.multiple,
    required this.current,
    required this.disabled,
    required this.selected,
    required this.onTap,
    this.movesFrom,
  });

  final CatalogMonumentSummary item;
  final bool multiple;

  /// Tek seçimde şu anki külliye.
  final bool current;

  /// Zaten bu külliyede (seçilemez).
  final bool disabled;
  final bool selected;

  /// Başka külliyenin yapısı: seçilirse oradan taşınır.
  final String? movesFrom;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final styles = context.textStyles;
    final details = [
      [item.district, item.city].where((s) => s.isNotEmpty).join(', '),
      if (item.memberCount case final count?) l10n.catalogMemberCount(count),
      item.id,
    ].where((s) => s.isNotEmpty).join(' · ');
    final note = switch ((disabled, current, movesFrom)) {
      (true, _, _) => l10n.pickerAlreadyMember,
      (_, true, _) => l10n.pickerCurrent,
      (_, _, final from?) => l10n.pickerInOtherComplex(from),
      _ => null,
    };
    final row = Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          if (multiple) ...[
            ExcludeSemantics(
              child: Checkbox(
                value: disabled || selected,
                onChanged: disabled ? null : (_) => onTap(),
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.nameTr,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: styles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    fontVariations: const [FontVariation('wght', 600)],
                    color: disabled ? colors.onSurfaceVariant : null,
                  ),
                ),
                Text(
                  details,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: styles.bodySmall,
                ),
                if (note != null)
                  Text(
                    note,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: styles.bodySmall.copyWith(
                      color: movesFrom != null && !disabled && !current
                          ? colors.warning
                          : colors.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          if (item.publication == Publication.archived)
            item.publication.chip(l10n),
        ],
      ),
    );
    return Semantics(
      button: !multiple,
      checked: multiple ? disabled || selected : null,
      selected: current,
      enabled: !disabled,
      label: [item.nameTr, details, ?note].join(', '),
      excludeSemantics: true,
      child: Material(
        color: selected || (current && !multiple)
            ? colors.secondaryContainer
            : Colors.transparent,
        child: InkWell(
          onTap: disabled ? null : onTap,
          hoverColor: colors.surfaceVariant,
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: colors.outlineVariant)),
            ),
            child: row,
          ),
        ),
      ),
    );
  }
}
