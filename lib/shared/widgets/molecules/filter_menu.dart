import 'package:flutter/material.dart';
import 'package:vakif_atlas_admin/core/l10n/l10n.dart';
import 'package:vakif_atlas_admin/core/theme/theme_context.dart';
import 'package:vakif_atlas_admin/core/theme/tokens/app_spacing.dart';

/// Süzgeç seçeneği.
@immutable
class FilterOption<T> {
  const FilterOption(this.value, this.label, {this.count});

  final T value;
  final String label;

  /// Sunucudan gelen eşleşme sayısı (biliniyorsa).
  final int? count;
}

/// Liste araç çubuğu: arama, süzgeç menüleri ve sıralama tek satırda
/// (sığmazsa alt satıra kayar). Süzgeçler açılır menü olduğundan liste
/// alanını daraltmaz.
class FilterToolbar extends StatelessWidget {
  const FilterToolbar({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: AppSpacing.xs,
    runSpacing: AppSpacing.xs,
    crossAxisAlignment: WrapCrossAlignment.center,
    children: children,
  );
}

/// Adlandırılmış süzgeç (çok veya tek seçim) — araç çubuğunda kompakt
/// düğme, seçenekler açılır menüde. Düğme etiketi seçimi metinle söyler
/// ("Tür: Cami", "Tür: 2 seçili"); seçenekler onay kutusu semantiği taşır.
class FilterMenu<T> extends StatelessWidget {
  const FilterMenu({
    required this.label,
    required this.options,
    required this.selected,
    required this.onChanged,
    this.multiple = true,
    super.key,
  });

  final String label;
  final List<FilterOption<T>> options;
  final Set<T> selected;
  final ValueChanged<Set<T>> onChanged;

  /// `false` → tek seçim (seçili seçeneğe tekrar basmak seçimi kaldırır).
  final bool multiple;

  String _optionLabel(FilterOption<T> option) =>
      option.count == null ? option.label : '${option.label} (${option.count})';

  void _toggle(T value) {
    final next = multiple ? {...selected} : <T>{};
    if (selected.contains(value)) {
      next.remove(value);
    } else {
      next.add(value);
    }
    onChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final chosen = [
      for (final option in options)
        if (selected.contains(option.value)) option,
    ];
    final summary = switch (chosen.length) {
      0 => null,
      1 => chosen.single.label,
      final count => l10n.filterSelectedCount(count),
    };
    return MenuAnchor(
      menuChildren: [
        for (final option in options)
          CheckboxMenuButton(
            value: selected.contains(option.value),
            closeOnActivate: !multiple,
            onChanged: (_) => _toggle(option.value),
            child: Text(_optionLabel(option)),
          ),
        if (selected.isNotEmpty) ...[
          const Divider(height: AppSpacing.xs),
          MenuItemButton(
            onPressed: () => onChanged(<T>{}),
            child: Text(l10n.filterClearSelection),
          ),
        ],
      ],
      builder: (context, controller, _) => ToolbarMenuButton(
        label: label,
        value: summary,
        active: summary != null,
        onPressed: () =>
            controller.isOpen ? controller.close() : controller.open(),
      ),
    );
  }
}

/// Tek seçimli sıralama menüsü ("Sıralama: En yeni").
class SortMenu<T> extends StatelessWidget {
  const SortMenu({
    required this.label,
    required this.options,
    required this.value,
    required this.onChanged,
    super.key,
  });

  final String label;
  final List<FilterOption<T>> options;
  final T value;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final current = options.firstWhere(
      (option) => option.value == value,
      orElse: () => options.first,
    );
    return MenuAnchor(
      menuChildren: [
        for (final option in options)
          RadioMenuButton<T>(
            value: option.value,
            groupValue: value,
            onChanged: (selected) {
              if (selected != null) {
                onChanged(selected);
              }
            },
            child: Text(option.label),
          ),
      ],
      builder: (context, controller, _) => ToolbarMenuButton(
        label: label,
        value: current.label,
        onPressed: () =>
            controller.isOpen ? controller.close() : controller.open(),
      ),
    );
  }
}

/// Araç çubuğundaki menü düğmesi: "Etiket: değer ▾". Etkin süzgeç düşük
/// vurgulu zeminle ve değerin yazılmasıyla belirtilir (yalnızca renk değil).
class ToolbarMenuButton extends StatelessWidget {
  const ToolbarMenuButton({
    required this.label,
    required this.onPressed,
    this.value,
    this.active = false,
    super.key,
  });

  final String label;
  final String? value;
  final bool active;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final styles = context.textStyles;
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(0, AppSizes.toolbarHeight),
        padding: const EdgeInsets.only(
          left: AppSpacing.sm,
          right: AppSpacing.xs,
        ),
        backgroundColor: active
            ? colors.secondaryContainer
            : colors.surfaceElevated,
        side: BorderSide(
          color: active ? colors.outline : colors.outlineVariant,
          width: colors.isHighContrast
              ? AppSizes.borderThick
              : AppSizes.borderThin,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: value == null ? label : '$label: ',
                  style: styles.labelLarge.copyWith(
                    color: value == null || !active
                        ? colors.onSurfaceVariant
                        : colors.onSurface,
                    fontWeight: FontWeight.w500,
                    fontVariations: const [FontVariation('wght', 500)],
                  ),
                ),
                if (value != null)
                  TextSpan(
                    text: value,
                    style: styles.labelLarge.copyWith(color: colors.onSurface),
                  ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.xxs),
          Icon(
            Icons.expand_more,
            size: AppSizes.iconInline,
            color: colors.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}
