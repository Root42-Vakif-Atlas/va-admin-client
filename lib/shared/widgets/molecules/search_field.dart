import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vakif_atlas_admin/core/keyboard/app_shortcuts.dart';
import 'package:vakif_atlas_admin/core/l10n/l10n.dart';
import 'package:vakif_atlas_admin/core/theme/theme_context.dart';
import 'package:vakif_atlas_admin/core/theme/tokens/app_spacing.dart';

/// Seyreltilmiş (350 ms) arama alanı; temizle düğmesi ve kısayol ipucuyla.
/// Sayfa [focusNode]'u `FocusSearchIntent` eylemine bağlar (Cmd/Ctrl + F).
class SearchField extends StatefulWidget {
  const SearchField({
    required this.label,
    required this.onChanged,
    this.initialValue = '',
    this.focusNode,
    this.debounce = const Duration(milliseconds: 350),
    super.key,
  });

  final String label;
  final String initialValue;
  final ValueChanged<String> onChanged;
  final FocusNode? focusNode;
  final Duration debounce;

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initialValue,
  );
  Timer? _timer;

  void _schedule(String value) {
    _timer?.cancel();
    _timer = Timer(widget.debounce, () => widget.onChanged(value.trim()));
    setState(() {});
  }

  void _clear() {
    _timer?.cancel();
    _controller.clear();
    widget.onChanged('');
    setState(() {});
    widget.focusNode?.requestFocus();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    return TextField(
      controller: _controller,
      focusNode: widget.focusNode,
      onChanged: _schedule,
      onSubmitted: (value) {
        _timer?.cancel();
        widget.onChanged(value.trim());
      },
      textInputAction: TextInputAction.search,
      style: context.textStyles.bodyMedium,
      decoration: InputDecoration(
        hintText: widget.label,
        isDense: true,
        // 20 px satır + 2 × 10 px = araç çubuğu yüksekliği (40 px).
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: (AppSizes.toolbarHeight - 20) / 2,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: BorderSide(color: colors.outlineVariant),
        ),
        prefixIcon: Icon(
          Icons.search,
          size: AppSizes.iconInline,
          color: colors.onSurfaceVariant,
        ),
        prefixIconConstraints: const BoxConstraints(
          minWidth: AppSpacing.xl + AppSpacing.xxs,
        ),
        suffixIcon: _controller.text.isEmpty
            ? Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: ExcludeSemantics(
                  child: Text(
                    AppShortcuts.label('F'),
                    style: context.textStyles.labelMedium.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ),
              )
            : IconButton(
                tooltip: l10n.searchClear,
                onPressed: _clear,
                iconSize: AppSizes.iconInline,
                icon: const Icon(Icons.close),
              ),
        suffixIconConstraints: const BoxConstraints(),
      ),
    );
  }
}
