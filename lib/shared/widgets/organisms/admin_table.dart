import 'package:flutter/material.dart';
import 'package:vakif_atlas_admin/core/theme/theme_context.dart';
import 'package:vakif_atlas_admin/core/theme/tokens/app_spacing.dart';

/// Tablo sütunu: esnek ([flex]) veya sabit genişlikli ([width]).
@immutable
class AdminTableColumn {
  const AdminTableColumn({
    required this.label,
    this.flex = 1,
    this.width,
    this.numeric = false,
    this.sorted = false,
    this.sortDescending = false,
    this.onSort,
    this.sortTooltip,
  });

  final String label;
  final int flex;
  final double? width;

  /// Sayı/tarih sütunu: sağa hizalı.
  final bool numeric;

  /// Liste bu sütuna göre sıralı.
  final bool sorted;
  final bool sortDescending;

  /// `null` → sütun sıralanamaz.
  final VoidCallback? onSort;
  final String? sortTooltip;
}

/// Kenarlıklı tablo çerçevesi: sabit başlık satırı, kaydırılan gövde ve
/// isteğe bağlı alt bilgi.
class AdminTable extends StatelessWidget {
  const AdminTable({
    required this.columns,
    required this.body,
    this.footer,
    super.key,
  });

  final List<AdminTableColumn> columns;
  final Widget body;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surfaceElevated,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(
          color: colors.isHighContrast ? colors.outline : colors.outlineVariant,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _HeaderRow(columns: columns),
            Expanded(child: body),
            if (footer != null)
              DecoratedBox(
                decoration: BoxDecoration(
                  color: colors.surfaceVariant,
                  border: Border(top: BorderSide(color: colors.outlineVariant)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.xs,
                  ),
                  child: DefaultTextStyle.merge(
                    style: context.textStyles.labelMedium.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                    child: footer!,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Sütunlara göre hücre dizilimi (başlık ve satırlar aynı ölçüyü kullanır).
class AdminTableCells extends StatelessWidget {
  const AdminTableCells({
    required this.columns,
    required this.cells,
    super.key,
  });

  final List<AdminTableColumn> columns;
  final List<Widget> cells;

  @override
  Widget build(BuildContext context) {
    assert(columns.length == cells.length, 'her sütun için tek hücre');
    return Row(
      children: [
        for (final (index, column) in columns.indexed) ...[
          if (index > 0) const SizedBox(width: AppSpacing.md),
          if (column.width case final width?)
            SizedBox(width: width, child: _align(column, cells[index]))
          else
            Expanded(flex: column.flex, child: _align(column, cells[index])),
        ],
      ],
    );
  }

  static Widget _align(AdminTableColumn column, Widget cell) => Align(
    alignment: column.numeric
        ? AlignmentDirectional.centerEnd
        : AlignmentDirectional.centerStart,
    child: cell,
  );
}

class _HeaderRow extends StatelessWidget {
  const _HeaderRow({required this.columns});

  final List<AdminTableColumn> columns;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final style = context.textStyles.labelMedium.copyWith(
      color: colors.onSurfaceVariant,
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surfaceVariant,
        border: Border(bottom: BorderSide(color: colors.outlineVariant)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: SizedBox(
          height: AppSizes.toolbarHeight,
          child: AdminTableCells(
            columns: columns,
            cells: [
              for (final column in columns)
                column.onSort == null
                    ? Semantics(
                        header: true,
                        child: Text(
                          column.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: style,
                        ),
                      )
                    : _SortableHeader(column: column, style: style),
            ],
          ),
        ),
      ),
    );
  }
}

class _SortableHeader extends StatelessWidget {
  const _SortableHeader({required this.column, required this.style});

  final AdminTableColumn column;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final active = column.sorted;
    return Semantics(
      header: true,
      button: true,
      selected: active,
      label: column.label,
      hint: column.sortTooltip,
      excludeSemantics: true,
      child: Tooltip(
        message: column.sortTooltip ?? '',
        child: InkWell(
          onTap: column.onSort,
          borderRadius: BorderRadius.circular(AppRadius.xs),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    column.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: active
                        ? style.copyWith(color: colors.onSurface)
                        : style,
                  ),
                ),
                if (active) ...[
                  const SizedBox(width: AppSpacing.xxs),
                  Icon(
                    column.sortDescending
                        ? Icons.arrow_downward
                        : Icons.arrow_upward,
                    size: AppSizes.iconSm - 2,
                    color: colors.onSurface,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Tıklanabilir tablo satırı: üzerine gelince ve seçiliyken nötr zemin.
class AdminTableRow extends StatelessWidget {
  const AdminTableRow({
    required this.columns,
    required this.cells,
    required this.semanticsLabel,
    this.onTap,
    this.selected = false,
    super.key,
  });

  final List<AdminTableColumn> columns;
  final List<Widget> cells;
  final String semanticsLabel;
  final VoidCallback? onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      button: onTap != null,
      selected: selected,
      label: semanticsLabel,
      excludeSemantics: true,
      child: Material(
        color: selected ? colors.secondaryContainer : Colors.transparent,
        child: InkWell(
          onTap: onTap,
          hoverColor: colors.surfaceVariant,
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: colors.outlineVariant)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs + 2,
              ),
              child: AdminTableCells(columns: columns, cells: cells),
            ),
          ),
        ),
      ),
    );
  }
}
