import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakif_atlas_admin/core/keyboard/app_shortcuts.dart';
import 'package:vakif_atlas_admin/core/l10n/failure_messages.dart';
import 'package:vakif_atlas_admin/core/l10n/formatters.dart';
import 'package:vakif_atlas_admin/core/l10n/l10n.dart';
import 'package:vakif_atlas_admin/core/theme/theme_context.dart';
import 'package:vakif_atlas_admin/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas_admin/features/catalog/domain/catalog_entities.dart';
import 'package:vakif_atlas_admin/features/catalog/presentation/catalog_cubits.dart';
import 'package:vakif_atlas_admin/features/catalog/presentation/widgets/catalog_labels.dart';
import 'package:vakif_atlas_admin/shared/paging/paged_list_cubit.dart';
import 'package:vakif_atlas_admin/shared/widgets/atoms/app_network_image.dart';
import 'package:vakif_atlas_admin/core/theme/tokens/app_typography.dart';
import 'package:vakif_atlas_admin/shared/widgets/molecules/filter_menu.dart';
import 'package:vakif_atlas_admin/shared/widgets/molecules/search_field.dart';
import 'package:vakif_atlas_admin/shared/widgets/organisms/admin_table.dart';
import 'package:vakif_atlas_admin/shared/widgets/organisms/paged_list.dart';
import 'package:vakif_atlas_admin/shared/widgets/templates/admin_page.dart';
import 'package:vakif_atlas_admin/core/theme/responsive.dart';

typedef _ListState = PagedListState<CatalogMonumentSummary, CatalogFilter>;

/// Katalog tablosu (yayında + yayından kaldırılmış): sütun başlığından
/// sıralama, araç çubuğunda arama ve süzgeç menüleri; satır düzenleyiciyi
/// açar. Dar pencerede ikincil sütunlar (dönem, görsel) gizlenir.
class CatalogListPage extends StatefulWidget {
  const CatalogListPage({
    required this.onOpen,
    required this.onCreate,
    required this.onImport,
    super.key,
  });

  final ValueChanged<String> onOpen;
  final VoidCallback onCreate;

  /// VGM verisinin içe aktarımı (`/catalog/import`).
  final VoidCallback onImport;

  @override
  State<CatalogListPage> createState() => _CatalogListPageState();
}

class _CatalogListPageState extends State<CatalogListPage> {
  /// Bu genişliğin altında dönem ve görsel sütunları gizlenir.
  static const double _wideTable = 960;

  /// Bu genişliğin altında (telefon / dar tablet) tablo iki sütundur: ad
  /// (altında tür · il) ve durum.
  static const double _compactTable = 720;

  static bool get _folderImportSupported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.macOS ||
          defaultTargetPlatform == TargetPlatform.windows ||
          defaultTargetPlatform == TargetPlatform.linux);

  final _searchFocus = FocusNode();

  @override
  void dispose() {
    _searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<CatalogListCubit>();
    void update(CatalogFilter Function(CatalogFilter) change) =>
        unawaited(cubit.load(change(cubit.state.filter)));
    return Actions(
      actions: {
        FocusSearchIntent: CallbackAction<FocusSearchIntent>(
          onInvoke: (_) => _searchFocus.requestFocus(),
        ),
        CreateItemIntent: CallbackAction<CreateItemIntent>(
          onInvoke: (_) => widget.onCreate(),
        ),
        RefreshIntent: CallbackAction<RefreshIntent>(
          onInvoke: (_) => unawaited(cubit.refresh()),
        ),
      },
      child: Focus(
        autofocus: true,
        child: AdminPage(
          title: l10n.catalogTitle,
          subtitle: l10n.catalogSubtitle,
          dividerBelowHeader: false,
          actions: [
            // Klasör seçimi (`getDirectoryPath`) ve yerel dosya okuma yalnızca
            // masaüstünde var; web ve mobilde içe aktarma sunulmaz.
            if (_folderImportSupported)
              OutlinedButton(
                onPressed: widget.onImport,
                child: Text(l10n.catalogImport),
              ),
            Tooltip(
              message: AppShortcuts.label('N'),
              child: FilledButton(
                onPressed: widget.onCreate,
                child: Text(l10n.catalogNew),
              ),
            ),
          ],
          toolbar: BlocBuilder<CatalogListCubit, _ListState>(
            buildWhen: (previous, current) => previous.filter != current.filter,
            builder: (context, state) {
              final filter = state.filter;
              return FilterToolbar(
                search: SearchField(
                  label: l10n.catalogSearch,
                  initialValue: filter.query,
                  focusNode: _searchFocus,
                  onChanged: (query) => update((f) => f.copyWith(query: query)),
                ),
                children: [
                  FilterMenu<Publication>(
                    label: l10n.catalogFilterPublication,
                    multiple: false,
                    options: [
                      for (final publication in Publication.values)
                        FilterOption(publication, publication.label(l10n)),
                    ],
                    selected: {?filter.publication},
                    onChanged: (selected) => update(
                      (f) => f.copyWith(
                        publication: () =>
                            selected.isEmpty ? null : selected.first,
                      ),
                    ),
                  ),
                  FilterMenu<MonumentCategory>(
                    label: l10n.catalogFilterCategory,
                    options: [
                      for (final category in MonumentCategory.values)
                        FilterOption(category, category.label(l10n)),
                    ],
                    selected: filter.categories,
                    onChanged: (selected) =>
                        update((f) => f.copyWith(categories: selected)),
                  ),
                  FilterMenu<MonumentPeriod>(
                    label: l10n.catalogFilterPeriod,
                    options: [
                      for (final period in MonumentPeriod.values)
                        FilterOption(period, period.label(l10n)),
                    ],
                    selected: filter.periods,
                    onChanged: (selected) =>
                        update((f) => f.copyWith(periods: selected)),
                  ),
                  FilterMenu<LocationFilter>(
                    label: l10n.catalogFilterLocation,
                    multiple: false,
                    options: [
                      FilterOption(
                        LocationFilter.missing,
                        l10n.catalogLocationMissing,
                      ),
                      FilterOption(
                        LocationFilter.present,
                        l10n.catalogLocationPresent,
                      ),
                    ],
                    selected: {?filter.location},
                    onChanged: (selected) => update(
                      (f) => f.copyWith(
                        location: () =>
                            selected.isEmpty ? null : selected.first,
                      ),
                    ),
                  ),
                  if (!filter.isDefault)
                    TextButton(
                      onPressed: () => update((_) => const CatalogFilter()),
                      child: Text(l10n.commonClearFilters),
                    ),
                ],
              );
            },
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              context.pageGutter,
              AppSpacing.xs,
              context.pageGutter,
              AppSpacing.lg,
            ),
            child: BlocBuilder<CatalogListCubit, _ListState>(
              builder: (context, state) => LayoutBuilder(
                builder: (context, constraints) {
                  final wide = constraints.maxWidth >= _wideTable;
                  final compact = constraints.maxWidth < _compactTable;
                  final sort = state.filter.sort;
                  final columns = [
                    AdminTableColumn(
                      label: l10n.catalogColumnName,
                      flex: 5,
                      sorted: sort == CatalogSort.name,
                      sortTooltip: l10n.catalogSortName,
                      onSort: () =>
                          update((f) => f.copyWith(sort: CatalogSort.name)),
                    ),
                    if (!compact)
                      AdminTableColumn(
                        label: l10n.catalogColumnCategory,
                        flex: 3,
                      ),
                    if (wide)
                      AdminTableColumn(
                        label: l10n.catalogColumnPeriod,
                        flex: 2,
                      ),
                    if (!compact)
                      AdminTableColumn(
                        label: l10n.catalogColumnLocation,
                        flex: 3,
                      ),
                    if (wide)
                      AdminTableColumn(
                        label: l10n.catalogColumnImages,
                        width: 64,
                        numeric: true,
                      ),
                    AdminTableColumn(
                      label: l10n.catalogColumnStatus,
                      width: compact ? 112 : 136,
                    ),
                    if (!compact)
                      AdminTableColumn(
                        label: l10n.catalogColumnUpdated,
                        width: 104,
                        numeric: true,
                        sorted: sort == CatalogSort.updated,
                        sortDescending: true,
                        sortTooltip: l10n.catalogSortUpdated,
                        onSort: () => update(
                          (f) => f.copyWith(sort: CatalogSort.updated),
                        ),
                      ),
                  ];
                  return AdminTable(
                    columns: columns,
                    footer: state.items.isEmpty
                        ? null
                        : Semantics(
                            liveRegion: true,
                            child: Text(
                              l10n.commonShownOfTotal(
                                state.items.length,
                                state.total,
                              ),
                            ),
                          ),
                    body: PagedList<CatalogMonumentSummary>(
                      items: state.items,
                      total: state.total,
                      isLoading: state.loading,
                      isLoadingMore: state.loadingMore,
                      hasMore: state.hasMore,
                      showSummary: false,
                      padding: EdgeInsets.zero,
                      onLoadMore: () => unawaited(cubit.loadMore()),
                      onRetry: () => unawaited(cubit.refresh()),
                      errorMessage: state.failure?.toUserMessage(l10n),
                      itemBuilder: (context, monument, _) => _MonumentRow(
                        monument: monument,
                        columns: columns,
                        wide: wide,
                        compact: compact,
                        onTap: () => widget.onOpen(monument.id),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MonumentRow extends StatelessWidget {
  const _MonumentRow({
    required this.monument,
    required this.columns,
    required this.wide,
    required this.compact,
    required this.onTap,
  });

  final CatalogMonumentSummary monument;
  final List<AdminTableColumn> columns;
  final bool wide;

  /// İki sütunlu dar tablo: tür ve il adın altında.
  final bool compact;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final styles = context.textStyles;
    final thumbnail = monument.thumbnailUrl;
    final secondary = styles.bodySmall;
    final complexLine = switch (monument) {
      CatalogMonumentSummary(memberCount: final count?) =>
        l10n.catalogMemberCount(count),
      CatalogMonumentSummary(complexName: final name?) => l10n.catalogPartOf(
        name,
      ),
      _ => null,
    };
    final imageCount = monument.imageCount;
    return AdminTableRow(
      columns: columns,
      onTap: onTap,
      semanticsLabel: l10n.catalogRowSemantics(
        monument.nameTr,
        monument.category.label(l10n),
        monument.city,
        monument.publication.label(l10n),
      ),
      cells: [
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.xs),
              child: SizedBox.square(
                dimension: AppSizes.tableThumbnail,
                child: thumbnail == null
                    ? ColoredBox(color: colors.surfaceVariant)
                    : AppNetworkImage(url: thumbnail),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    monument.nameTr,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: styles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      fontVariations: const [FontVariation('wght', 600)],
                    ),
                  ),
                  Text(
                    compact
                        ? [
                            monument.category.label(l10n),
                            monument.city,
                            if (!monument.hasLocation) l10n.catalogNoLocation,
                          ].join(' · ')
                        : monument.id,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: secondary,
                  ),
                ],
              ),
            ),
          ],
        ),
        if (!compact)
          _TwoLine(
            primary: monument.category.label(l10n),
            secondary: complexLine,
          ),
        if (wide)
          Text(
            monument.period.label(l10n),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: styles.bodyMedium,
          ),
        if (!compact)
          _TwoLine(
            primary: monument.city,
            // Konumu girilmemiş eser haritada görünmez: satırda belirtilir.
            secondary: monument.hasLocation
                ? monument.district
                : [
                    if (monument.district.isNotEmpty) monument.district,
                    l10n.catalogNoLocation,
                  ].join(' · '),
          ),
        if (wide)
          Text(
            context.formatNumber(imageCount),
            style: styles.bodyMedium.copyWith(
              color: imageCount == 0 ? colors.warning : null,
              fontFeatures: AppTypography.tabularFigures,
            ),
            semanticsLabel: l10n.catalogImageCount(imageCount),
          ),
        monument.publication.chip(l10n),
        if (!compact)
          Text(
            context.formatDate(monument.updatedAt),
            maxLines: 1,
            style: styles.bodySmall.copyWith(
              fontFeatures: AppTypography.tabularFigures,
            ),
          ),
      ],
    );
  }
}

/// Hücrede birincil değer + altında ikincil açıklama.
class _TwoLine extends StatelessWidget {
  const _TwoLine({required this.primary, this.secondary});

  final String primary;
  final String? secondary;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        primary,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: context.textStyles.bodyMedium,
      ),
      if (secondary case final text? when text.isNotEmpty)
        Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.textStyles.bodySmall,
        ),
    ],
  );
}
