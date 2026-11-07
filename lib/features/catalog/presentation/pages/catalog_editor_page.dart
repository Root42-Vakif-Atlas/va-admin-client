import 'dart:async';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakif_atlas_admin/core/a11y/a11y_announcer.dart';
import 'package:vakif_atlas_admin/core/error/failures.dart';
import 'package:vakif_atlas_admin/core/keyboard/app_shortcuts.dart';
import 'package:vakif_atlas_admin/core/l10n/failure_messages.dart';
import 'package:vakif_atlas_admin/core/l10n/formatters.dart';
import 'package:vakif_atlas_admin/core/l10n/l10n.dart';
import 'package:vakif_atlas_admin/core/theme/theme_context.dart';
import 'package:vakif_atlas_admin/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas_admin/features/catalog/domain/catalog_entities.dart';
import 'package:vakif_atlas_admin/features/catalog/domain/monument_validation.dart';
import 'package:vakif_atlas_admin/features/catalog/domain/turkish_provinces.dart';
import 'package:vakif_atlas_admin/features/catalog/presentation/catalog_cubits.dart';
import 'package:vakif_atlas_admin/features/catalog/presentation/widgets/catalog_labels.dart';
import 'package:vakif_atlas_admin/features/catalog/presentation/widgets/monument_picker.dart';
import 'package:vakif_atlas_admin/shared/widgets/atoms/app_network_image.dart';
import 'package:vakif_atlas_admin/shared/widgets/molecules/admin_dialogs.dart';
import 'package:vakif_atlas_admin/shared/widgets/molecules/app_snack_bar.dart';
import 'package:vakif_atlas_admin/shared/widgets/molecules/detail_section.dart';
import 'package:vakif_atlas_admin/shared/widgets/molecules/inline_message.dart';
import 'package:vakif_atlas_admin/shared/widgets/molecules/status_chip.dart';
import 'package:vakif_atlas_admin/shared/widgets/templates/admin_page.dart';
import 'package:vakif_atlas_admin/shared/widgets/templates/loading_status_view.dart';
import 'package:vakif_atlas_admin/shared/widgets/templates/status_message_view.dart';
import 'package:vakif_atlas_admin/core/theme/responsive.dart';

/// Eser düzenleyicisi (oluşturma ve düzenleme). Kaydedilmemiş değişiklik
/// [onDirtyChanged] ile yönlendiriciye bildirilir (çıkışta onay).
class CatalogEditorPage extends StatefulWidget {
  const CatalogEditorPage({
    required this.onBack,
    required this.onCreated,
    required this.onDirtyChanged,
    required this.onOpenEntry,
    super.key,
  });

  final VoidCallback onBack;
  final ValueChanged<String> onCreated;
  final ValueChanged<bool> onDirtyChanged;

  /// Başka bir kaydı açar (eserin külliyesi).
  final ValueChanged<String> onOpenEntry;

  @override
  State<CatalogEditorPage> createState() => _CatalogEditorPageState();
}

class _CatalogEditorPageState extends State<CatalogEditorPage> {
  /// "Geri al" sonrası alanlar kayıtlı değerlerle yeniden kurulur.
  int _resets = 0;

  @override
  void dispose() {
    widget.onDirtyChanged(false);
    super.dispose();
  }

  Future<void> _save() async {
    final cubit = context.read<CatalogEditorCubit>();
    final wasCreating = cubit.state.creating;
    final saved = await cubit.save();
    if (!mounted) {
      return;
    }
    final l10n = context.l10n;
    if (!saved) {
      if (cubit.state.showErrors && cubit.state.errors.isNotEmpty) {
        unawaited(
          context.read<A11yAnnouncer>().announce(
            l10n.editorErrorsSummary,
            assertive: true,
          ),
        );
      }
      return;
    }
    AppSnackBar.show(context, message: l10n.editorSaved);
    unawaited(context.read<A11yAnnouncer>().announce(l10n.editorSaved));
    if (wasCreating) {
      widget.onCreated(cubit.state.saved!.value.id);
    }
  }

  Future<void> _togglePublication(CatalogMonument monument) async {
    final l10n = context.l10n;
    final cubit = context.read<CatalogEditorCubit>();
    final archiving = monument.publication == Publication.published;
    if (archiving) {
      final confirmed = await showConfirmDialog(
        context,
        title: l10n.editorArchiveConfirmTitle,
        message: l10n.editorArchiveConfirmBody,
        confirmLabel: l10n.editorArchive,
        destructive: true,
      );
      if (!confirmed) {
        return;
      }
    }
    final done = await cubit.setPublication(
      archiving ? Publication.archived : Publication.published,
    );
    if (done && mounted) {
      AppSnackBar.show(context, message: l10n.editorPublicationChanged);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocConsumer<CatalogEditorCubit, CatalogEditorState>(
      listenWhen: (previous, current) =>
          previous.dirty != current.dirty ||
          (current.actionFailure != null &&
              previous.actionFailure != current.actionFailure),
      listener: (context, state) async {
        widget.onDirtyChanged(state.dirty);
        final cubit = context.read<CatalogEditorCubit>();
        if (state.actionFailure is StaleDataFailure) {
          final reload = await showStaleDataDialog(context);
          cubit.clearActionFailure();
          if (reload) {
            await cubit.load();
            setState(() => _resets++);
          }
        }
      },
      builder: (context, state) {
        if (state.loading && state.saved == null) {
          return LoadingStatusView(label: l10n.commonLoading);
        }
        if (!state.creating && state.saved == null) {
          return StatusMessageView(
            tone: StatusMessageTone.error,
            title: l10n.commonLoadError,
            message:
                state.loadFailure?.toUserMessage(l10n) ?? l10n.errorUnexpected,
            actionLabel: l10n.commonRetry,
            onAction: () =>
                unawaited(context.read<CatalogEditorCubit>().load()),
          );
        }
        final saved = state.saved?.value;
        final errors = state.showErrors
            ? state.errors
            : const <MonumentField>{};
        final complex = state.draft.category == MonumentCategory.complex;
        final tabs = <(String, Set<MonumentField>, Widget)>[
          (
            l10n.editorTabGeneral,
            {
              MonumentField.id,
              MonumentField.city,
              MonumentField.district,
              MonumentField.address,
              MonumentField.location,
            },
            _GeneralTab(
              state: state,
              errors: errors,
              onOpenEntry: widget.onOpenEntry,
            ),
          ),
          (
            l10n.editorTabTurkish,
            {MonumentField.trName, MonumentField.trShortDescription},
            _TextTab(turkish: true, state: state, errors: errors),
          ),
          (
            l10n.editorTabEnglish,
            {MonumentField.enName, MonumentField.enShortDescription},
            _TextTab(turkish: false, state: state, errors: errors),
          ),
          // Külliye kaydı bölüm ve uzun metin taşımaz.
          if (!complex)
            (
              l10n.editorTabParts,
              {MonumentField.parts},
              _PartsTab(state: state, errors: errors),
            ),
          (
            l10n.editorTabImages,
            {MonumentField.images},
            _ImagesTab(state: state, errors: errors),
          ),
          if (complex)
            (
              l10n.editorTabMembers,
              const <MonumentField>{},
              _MembersTab(state: state),
            ),
        ];
        return Actions(
          actions: {
            SaveIntent: CallbackAction<SaveIntent>(
              onInvoke: (_) => unawaited(_save()),
            ),
          },
          child: Focus(
            autofocus: true,
            child: DefaultTabController(
              key: ValueKey(tabs.length),
              length: tabs.length,
              child: AdminPage(
                title: state.draft.tr.name.trim().isEmpty
                    ? l10n.editorNewTitle
                    : state.draft.tr.name,
                subtitle: saved?.id,
                actions: [
                  TextButton(
                    onPressed: widget.onBack,
                    child: Text(l10n.editorBack),
                  ),
                  if (state.dirty && !state.creating)
                    TextButton(
                      onPressed: state.busy
                          ? null
                          : () {
                              context.read<CatalogEditorCubit>().discard();
                              setState(() => _resets++);
                            },
                      child: Text(l10n.editorDiscard),
                    ),
                  if (saved != null)
                    OutlinedButton(
                      onPressed: state.busy
                          ? null
                          : () => unawaited(_togglePublication(saved)),
                      child: Text(
                        saved.publication == Publication.published
                            ? l10n.editorArchive
                            : l10n.editorRestore,
                      ),
                    ),
                  Tooltip(
                    message: AppShortcuts.label('S'),
                    child: FilledButton(
                      onPressed: state.busy || !state.dirty
                          ? null
                          : () => unawaited(_save()),
                      child: state.saving
                          ? const SizedBox.square(
                              dimension: AppSizes.iconSm,
                              child: CircularProgressIndicator(
                                strokeWidth: AppSizes.spinnerStroke,
                              ),
                            )
                          : Text(l10n.editorSave),
                    ),
                  ),
                ],
                toolbar: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Wrap(
                      spacing: AppSpacing.xs,
                      runSpacing: AppSpacing.xs,
                      children: [
                        if (saved != null) saved.publication.chip(l10n),
                        if (state.dirty)
                          StatusChip(
                            label: l10n.editorUnsaved,
                            tone: StatusTone.warning,
                          ),
                      ],
                    ),
                    if (saved?.archivedAt case final at?) ...[
                      const SizedBox(height: AppSpacing.xs),
                      InlineMessage(
                        message: l10n.editorArchivedNotice(
                          context.formatDate(at),
                        ),
                      ),
                    ],
                    if (errors.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.xs),
                      InlineMessage(
                        type: InlineMessageType.error,
                        message: l10n.editorErrorsSummary,
                      ),
                    ],
                    if (state.actionFailure case final failure?
                        when failure is! StaleDataFailure) ...[
                      const SizedBox(height: AppSpacing.xs),
                      InlineMessage(
                        type: InlineMessageType.error,
                        message: failure.toUserMessage(l10n),
                      ),
                    ],
                    TabBar(
                      isScrollable: true,
                      tabAlignment: TabAlignment.start,
                      tabs: [
                        for (final (label, fields, _) in tabs)
                          Tab(
                            child: Semantics(
                              label: fields.any(errors.contains)
                                  ? l10n.editorTabHasErrors(label)
                                  : label,
                              excludeSemantics: true,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (fields.any(errors.contains)) ...[
                                    Icon(
                                      Icons.error_outline,
                                      size: AppSizes.iconSm,
                                      color: context.colors.error,
                                    ),
                                    const SizedBox(width: AppSpacing.xxs),
                                  ],
                                  Text(label),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                child: KeyedSubtree(
                  key: ValueKey('${state.saved?.etag}-$_resets'),
                  child: TabBarView(
                    children: [
                      for (final (_, _, tab) in tabs)
                        SingleChildScrollView(
                          padding: EdgeInsets.all(context.pageGutter),
                          child: Align(
                            alignment: AlignmentDirectional.topStart,
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxWidth: AppSizes.detailMaxWidth,
                              ),
                              child: tab,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Taslağa bağlı metin alanı (kendi denetleyicisi; değişiklik cubit'e akar).
class _BoundField extends StatefulWidget {
  const _BoundField({
    required this.label,
    required this.initial,
    required this.onChanged,
    this.helper,
    this.error,
    this.maxLines = 1,
    this.maxLength,
    this.enabled = true,
    this.keyboardType,
    this.inputFormatters,
  });

  final String label;
  final String initial;
  final ValueChanged<String> onChanged;
  final String? helper;
  final String? error;
  final int maxLines;
  final int? maxLength;
  final bool enabled;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  @override
  State<_BoundField> createState() => _BoundFieldState();
}

class _BoundFieldState extends State<_BoundField> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initial,
  );

  @override
  void didUpdateWidget(_BoundField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Dışarıdan gelen değer (ör. "Addan öner") alana yansır.
    if (widget.initial != _controller.text &&
        widget.initial != oldWidget.initial) {
      _controller.text = widget.initial;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: TextField(
        controller: _controller,
        enabled: widget.enabled,
        minLines: widget.maxLines > 1 ? 3 : 1,
        maxLines: widget.maxLines,
        maxLength: widget.maxLength,
        keyboardType: widget.keyboardType,
        inputFormatters: widget.inputFormatters,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          labelText: widget.label,
          helperText: widget.helper,
          helperMaxLines: 3,
          errorText: widget.error,
          alignLabelWithHint: widget.maxLines > 1,
        ),
      ),
    );
  }
}

class _GeneralTab extends StatelessWidget {
  const _GeneralTab({
    required this.state,
    required this.errors,
    required this.onOpenEntry,
  });

  final CatalogEditorState state;
  final Set<MonumentField> errors;
  final ValueChanged<String> onOpenEntry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<CatalogEditorCubit>();
    final draft = state.draft;
    final complex = draft.isComplex;
    final required = l10n.editorFieldRequired;
    String? error(MonumentField field, String message) =>
        errors.contains(field) ? message : null;
    final decimal = [FilteringTextInputFormatter.allow(RegExp(r'[0-9.\-]'))];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Eser ve külliye ayrı kayıtlardır; tür yalnızca oluştururken seçilir.
        if (state.creating) ...[
          Text(l10n.editorFieldKind, style: context.textStyles.labelLarge),
          const SizedBox(height: AppSpacing.xs),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: SegmentedButton<bool>(
              segments: [
                ButtonSegment(value: false, label: Text(l10n.editorKindWork)),
                ButtonSegment(value: true, label: Text(l10n.editorKindComplex)),
              ],
              selected: {complex},
              onSelectionChanged: (selection) => cubit.edit(
                (d) => selection.first
                    ? d.copyWith(
                        category: MonumentCategory.complex,
                        categoryAuto: false,
                      )
                    : d.copyWith(
                        category: MonumentCategory.mosque,
                        categoryAuto: true,
                      ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _BoundField(
                label: l10n.editorFieldId,
                initial: draft.id,
                enabled: state.creating,
                helper: l10n.editorFieldIdHelp,
                error: error(MonumentField.id, l10n.editorFieldIdError),
                onChanged: (value) =>
                    cubit.edit((d) => d.copyWith(id: value.trim())),
              ),
            ),
            if (state.creating) ...[
              const SizedBox(width: AppSpacing.sm),
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.xs),
                child: OutlinedButton(
                  onPressed: draft.tr.name.trim().isEmpty
                      ? null
                      : () => cubit.edit(
                          (d) => d.copyWith(
                            id: MonumentValidation.suggestId(d.tr.name),
                          ),
                        ),
                  child: Text(l10n.editorSuggestId),
                ),
              ),
            ],
          ],
        ),
        if (!complex) ...[
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: draft.categoryAuto,
            title: Text(l10n.editorCategoryAuto),
            subtitle: Text(l10n.editorCategoryAutoHelp),
            onChanged: (value) =>
                cubit.edit((d) => d.copyWith(categoryAuto: value)),
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.md,
            children: [
              DropdownMenu<MonumentCategory>(
                label: Text(l10n.editorFieldCategory),
                initialSelection: draft.category,
                enabled: !draft.categoryAuto,
                width: 280,
                onSelected: (category) {
                  if (category != null) {
                    cubit.edit((d) => d.copyWith(category: category));
                  }
                },
                dropdownMenuEntries: [
                  for (final category in MonumentCategory.values)
                    if (category != MonumentCategory.complex)
                      DropdownMenuEntry(
                        value: category,
                        label: category.label(l10n),
                      ),
                ],
              ),
              DropdownMenu<MonumentPeriod>(
                label: Text(l10n.editorFieldPeriod),
                initialSelection: draft.period,
                width: 280,
                onSelected: (period) {
                  if (period != null) {
                    cubit.edit((d) => d.copyWith(period: period));
                  }
                },
                dropdownMenuEntries: [
                  for (final period in MonumentPeriod.values)
                    DropdownMenuEntry(value: period, label: period.label(l10n)),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        ResponsiveFieldRow(
          children: [
            DropdownMenu<int>(
              label: Text(l10n.editorFieldCity),
              initialSelection: draft.cityCode,
              expandedInsets: EdgeInsets.zero,
              enableFilter: true,
              requestFocusOnTap: true,
              errorText: error(MonumentField.city, required),
              onSelected: (code) {
                if (code != null) {
                  cubit.edit((d) => d.copyWith(cityCode: code));
                }
              },
              dropdownMenuEntries: [
                for (final MapEntry(key: code, value: name)
                    in TurkishProvinces.names.entries)
                  DropdownMenuEntry(value: code, label: name),
              ],
            ),
            _BoundField(
              label: l10n.editorFieldDistrict,
              initial: draft.district,
              maxLength: MonumentValidation.maxDistrict,
              error: error(MonumentField.district, required),
              onChanged: (value) =>
                  cubit.edit((d) => d.copyWith(district: value)),
            ),
          ],
        ),
        _BoundField(
          label: l10n.editorFieldAddress,
          initial: draft.address,
          maxLength: MonumentValidation.maxAddress,
          maxLines: 3,
          onChanged: (value) => cubit.edit((d) => d.copyWith(address: value)),
        ),
        ResponsiveFieldRow(
          children: [
            _BoundField(
              label: l10n.editorFieldLatitude,
              initial: draft.latitude?.toString() ?? '',
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
                signed: true,
              ),
              inputFormatters: decimal,
              helper: l10n.editorFieldLocationHelp,
              error: error(
                MonumentField.location,
                l10n.editorFieldLocationError,
              ),
              onChanged: (value) => cubit.edit(
                (d) => d.copyWith(latitude: () => double.tryParse(value)),
              ),
            ),
            _BoundField(
              label: l10n.editorFieldLongitude,
              initial: draft.longitude?.toString() ?? '',
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
                signed: true,
              ),
              inputFormatters: decimal,
              onChanged: (value) => cubit.edit(
                (d) => d.copyWith(longitude: () => double.tryParse(value)),
              ),
            ),
          ],
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          value: draft.isActive,
          title: Text(l10n.editorFieldActive),
          subtitle: Text(l10n.editorFieldActiveHelp),
          onChanged: (value) => cubit.edit((d) => d.copyWith(isActive: value)),
        ),
        if (!complex) ...[
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: draft.unesco,
            title: Text(l10n.editorFieldUnesco),
            onChanged: (value) => cubit.edit((d) => d.copyWith(unesco: value)),
          ),
          const SizedBox(height: AppSpacing.md),
          _ComplexField(state: state, onOpen: onOpenEntry),
        ],
      ],
    );
  }
}

/// Eserin bağlı olduğu külliye (salt okunur): üyelik ve sıra külliyenin
/// "Külliye yapıları" sekmesinden düzenlenir (`PUT complexes/{key}/works`).
class _ComplexField extends StatelessWidget {
  const _ComplexField({required this.state, required this.onOpen});

  final CatalogEditorState state;
  final ValueChanged<String> onOpen;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final styles = context.textStyles;
    final draft = state.draft;
    final id = draft.complexId;
    final selected = id.isNotEmpty;
    final name = selected ? (state.saved?.value.complexName ?? id) : null;
    final position = draft.complexOrder;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: l10n.editorFieldComplex,
          helperText: l10n.editorComplexMembershipHelp,
          helperMaxLines: 2,
        ),
        child: Row(
          children: [
            Expanded(
              child: MergeSemantics(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name ?? l10n.editorComplexNone,
                      style: selected
                          ? styles.bodyLarge.copyWith(
                              fontWeight: FontWeight.w600,
                              fontVariations: const [
                                FontVariation('wght', 600),
                              ],
                            )
                          : styles.bodyLarge.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                    ),
                    if (selected)
                      Text(
                        position == null
                            ? id
                            : '$id · ${l10n.editorComplexPosition(position + 1)}',
                        style: styles.bodySmall,
                      ),
                  ],
                ),
              ),
            ),
            if (selected)
              OutlinedButton(
                onPressed: () => onOpen(id),
                child: Text(l10n.editorComplexOpen),
              ),
          ],
        ),
      ),
    );
  }
}

class _TextTab extends StatelessWidget {
  const _TextTab({
    required this.turkish,
    required this.state,
    required this.errors,
  });

  final bool turkish;
  final CatalogEditorState state;
  final Set<MonumentField> errors;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<CatalogEditorCubit>();
    final text = turkish ? state.draft.tr : state.draft.en;
    void update(MonumentText Function(MonumentText) change) => cubit.edit(
      (d) =>
          turkish ? d.copyWith(tr: change(d.tr)) : d.copyWith(en: change(d.en)),
    );
    String? error(MonumentField tr, MonumentField en) =>
        errors.contains(turkish ? tr : en) ? l10n.editorFieldRequired : null;
    final name = _BoundField(
      label: l10n.editorFieldName,
      initial: text.name,
      maxLength: MonumentValidation.maxName,
      error: error(MonumentField.trName, MonumentField.enName),
      onChanged: (value) => update((t) => t.copyWith(name: value)),
    );
    // Külliyenin yalnızca adı dile bağlıdır.
    if (state.draft.isComplex) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [name],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        name,
        _BoundField(
          label: l10n.editorFieldNickname,
          initial: text.nickname,
          maxLength: MonumentValidation.maxName,
          onChanged: (value) => update((t) => t.copyWith(nickname: value)),
        ),
        _BoundField(
          label: l10n.editorFieldShortDescriptionTitle,
          initial: text.shortDescriptionTitle,
          maxLength: MonumentValidation.maxName,
          onChanged: (value) =>
              update((t) => t.copyWith(shortDescriptionTitle: value)),
        ),
        _BoundField(
          label: l10n.editorFieldShortDescription,
          initial: text.shortDescription,
          maxLines: 3,
          maxLength: MonumentValidation.maxShortDescription,
          helper: l10n.editorFieldShortDescriptionHelp,
          error: error(
            MonumentField.trShortDescription,
            MonumentField.enShortDescription,
          ),
          onChanged: (value) =>
              update((t) => t.copyWith(shortDescription: value)),
        ),
        _BoundField(
          label: l10n.editorFieldHistory,
          initial: text.history,
          maxLines: 10,
          onChanged: (value) => update((t) => t.copyWith(history: value)),
        ),
        ResponsiveFieldRow(
          children: [
            _BoundField(
              label: l10n.editorFieldConstructionDate,
              initial: text.constructionDate,
              onChanged: (value) =>
                  update((t) => t.copyWith(constructionDate: value)),
            ),
            _BoundField(
              label: l10n.editorFieldFounder,
              initial: text.founder,
              onChanged: (value) => update((t) => t.copyWith(founder: value)),
            ),
            _BoundField(
              label: l10n.editorFieldArchitect,
              initial: text.architect,
              onChanged: (value) => update((t) => t.copyWith(architect: value)),
            ),
          ],
        ),
      ],
    );
  }
}

/// Bölümler (VGM verisi): başlık ve metin iki dilde; Türkçe metin zorunlu.
/// Bölüm silinince ona bağlı görseller eser görseline döner.
class _PartsTab extends StatelessWidget {
  const _PartsTab({required this.state, required this.errors});

  final CatalogEditorState state;
  final Set<MonumentField> errors;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<CatalogEditorCubit>();
    final parts = state.draft.parts;
    void update(int index, MonumentPart Function(MonumentPart) change) =>
        cubit.edit(
          (d) => d.copyWith(
            parts: [
              for (var i = 0; i < d.parts.length; i++)
                i == index ? change(d.parts[i]) : d.parts[i],
            ],
          ),
        );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.editorPartsHelp, style: context.textStyles.bodyMedium),
        const SizedBox(height: AppSpacing.md),
        if (errors.contains(MonumentField.parts)) ...[
          InlineMessage(
            type: InlineMessageType.error,
            message: l10n.editorPartsError,
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        if (parts.isEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Text(l10n.editorPartsEmpty),
          ),
        for (var index = 0; index < parts.length; index++)
          DetailSection(
            key: ValueKey('part-$index-${parts.length}'),
            title: l10n.editorPartTitle(index + 1),
            trailing: TextButton(
              onPressed: state.busy ? null : () => cubit.removePart(index),
              child: Text(l10n.editorPartRemove),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ResponsiveFieldRow(
                  children: [
                    _BoundField(
                      label: l10n.editorPartFieldTitleTr,
                      initial: parts[index].titleTr,
                      maxLength: MonumentValidation.maxName,
                      onChanged: (value) =>
                          update(index, (p) => p.copyWith(titleTr: value)),
                    ),
                    _BoundField(
                      label: l10n.editorPartFieldTitleEn,
                      initial: parts[index].titleEn,
                      maxLength: MonumentValidation.maxName,
                      onChanged: (value) =>
                          update(index, (p) => p.copyWith(titleEn: value)),
                    ),
                  ],
                ),
                _BoundField(
                  label: l10n.editorPartFieldDescriptionTr,
                  initial: parts[index].descriptionTr,
                  maxLines: 12,
                  error:
                      errors.contains(MonumentField.parts) &&
                          parts[index].descriptionTr.trim().isEmpty
                      ? l10n.editorFieldRequired
                      : null,
                  onChanged: (value) =>
                      update(index, (p) => p.copyWith(descriptionTr: value)),
                ),
                _BoundField(
                  label: l10n.editorPartFieldDescriptionEn,
                  initial: parts[index].descriptionEn,
                  maxLines: 12,
                  onChanged: (value) =>
                      update(index, (p) => p.copyWith(descriptionEn: value)),
                ),
              ],
            ),
          ),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: OutlinedButton(
            onPressed: state.busy || parts.length >= MonumentValidation.maxParts
                ? null
                : () => cubit.edit(
                    (d) =>
                        d.copyWith(parts: [...d.parts, const MonumentPart()]),
                  ),
            child: Text(l10n.editorPartAdd),
          ),
        ),
      ],
    );
  }
}

class _ImagesTab extends StatelessWidget {
  const _ImagesTab({required this.state, required this.errors});

  final CatalogEditorState state;
  final Set<MonumentField> errors;

  Future<void> _pick(BuildContext context) async {
    final cubit = context.read<CatalogEditorCubit>();
    final files = await openFiles(
      acceptedTypeGroups: [
        XTypeGroup(
          label: context.l10n.editorImagesFileType,
          extensions: const ['jpg', 'jpeg', 'png', 'webp'],
          uniformTypeIdentifiers: const [
            'public.jpeg',
            'public.png',
            'org.webmproject.webp',
          ],
          mimeTypes: const ['image/jpeg', 'image/png', 'image/webp'],
        ),
      ],
    );
    if (files.isEmpty) {
      return;
    }
    final room = MonumentValidation.maxImages - cubit.state.draft.images.length;
    final bytes = [
      for (final file in files.take(room)) await file.readAsBytes(),
    ];
    await cubit.addImages(bytes);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<CatalogEditorCubit>();
    final images = state.draft.images;
    final uploadFailure = state.uploadFailure;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.editorImagesHelp, style: context.textStyles.bodyMedium),
        const SizedBox(height: AppSpacing.md),
        if (errors.contains(MonumentField.images)) ...[
          InlineMessage(
            type: InlineMessageType.error,
            message: l10n.editorImagesError,
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        if (uploadFailure != null) ...[
          InlineMessage(
            type: InlineMessageType.error,
            message: l10n.editorImagesUploadError(
              uploadFailure is ServerFailure &&
                      uploadFailure.code == 'invalid_image'
                  ? l10n.editorImagesInvalid
                  : uploadFailure.toUserMessage(l10n),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        Row(
          children: [
            FilledButton.tonal(
              onPressed:
                  state.uploading > 0 ||
                      images.length >= MonumentValidation.maxImages
                  ? null
                  : () => unawaited(_pick(context)),
              child: Text(l10n.editorImagesAdd),
            ),
            if (state.uploading > 0) ...[
              const SizedBox(width: AppSpacing.md),
              const SizedBox.square(
                dimension: AppSizes.spinner,
                child: CircularProgressIndicator(
                  strokeWidth: AppSizes.spinnerStroke,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Semantics(
                liveRegion: true,
                child: Text(l10n.editorImagesUploading(state.uploading)),
              ),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        if (images.isEmpty)
          Text(l10n.editorImagesEmpty, style: context.textStyles.bodyMedium)
        else
          for (final (index, image) in images.indexed)
            Padding(
              key: ValueKey(image.key),
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: _ImageCard(
                image: image,
                index: index,
                count: images.length,
                showErrors: errors.contains(MonumentField.images),
                onChanged: (change) => cubit.updateImage(index, change),
                onMove: (delta) => cubit.moveImage(index, index + delta),
                onRemove: () => cubit.removeImage(index),
              ),
            ),
      ],
    );
  }
}

class _ImageCard extends StatelessWidget {
  const _ImageCard({
    required this.image,
    required this.index,
    required this.count,
    required this.showErrors,
    required this.onChanged,
    required this.onMove,
    required this.onRemove,
  });

  final MonumentImage image;
  final int index;
  final int count;
  final bool showErrors;
  final void Function(MonumentImage Function(MonumentImage)) onChanged;
  final ValueChanged<int> onMove;
  final VoidCallback onRemove;

  static const double _preview = 160;

  /// Bu genişliğin altında önizleme alanların üstündedir.

  static const double _stackBelow = 520;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final required = l10n.editorFieldRequired;
    String? missing(String value) =>
        showErrors && value.trim().isEmpty ? required : null;
    final preview = image.previewBytes;
    return DetailSection(
      title: l10n.editorImageSemantics(index + 1, count),
      trailing: Wrap(
        spacing: AppSpacing.xxs,
        children: [
          if (index == 0)
            StatusChip(label: l10n.editorImageCover, tone: StatusTone.accent),
          if (image.isNew)
            StatusChip(label: l10n.editorImageNew, tone: StatusTone.info),
          if (image.mirrored) StatusChip(label: l10n.editorImageMirrored),
          if (image.part case final part?)
            StatusChip(label: l10n.editorImagePart(part + 1)),
          IconButton(
            tooltip: l10n.editorImageMoveUp,
            onPressed: index == 0 ? null : () => onMove(-1),
            icon: const Icon(Icons.arrow_upward),
          ),
          IconButton(
            tooltip: l10n.editorImageMoveDown,
            onPressed: index == count - 1 ? null : () => onMove(1),
            icon: const Icon(Icons.arrow_downward),
          ),
          IconButton(
            tooltip: l10n.editorImageRemove,
            onPressed: onRemove,
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      // Dar kartta önizleme alanların üstüne geçer.
      child: LayoutBuilder(
        builder: (context, constraints) {
          final thumbnail = ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.sm),
            child: SizedBox(
              width: _preview,
              height: _preview * 0.75,
              child: preview != null
                  ? Image.memory(
                      Uint8List.fromList(preview),
                      fit: BoxFit.cover,
                      semanticLabel: image.altTr,
                    )
                  : AppNetworkImage(
                      url: image.thumbnailUrl ?? image.url ?? '',
                      semanticsLabel: image.altTr,
                    ),
            ),
          );
          final fields = Column(
            children: [
              _BoundField(
                label: l10n.editorImageAltTr,
                initial: image.altTr,
                maxLength: 250,
                error: missing(image.altTr),
                onChanged: (value) =>
                    onChanged((i) => i.copyWith(altTr: value)),
              ),
              _BoundField(
                label: l10n.editorImageAltEn,
                initial: image.altEn,
                maxLength: 250,
                error: missing(image.altEn),
                onChanged: (value) =>
                    onChanged((i) => i.copyWith(altEn: value)),
              ),
              ResponsiveFieldRow(
                children: [
                  _BoundField(
                    label: l10n.editorImageAuthor,
                    initial: image.author,
                    error: missing(image.author),
                    onChanged: (value) =>
                        onChanged((i) => i.copyWith(author: value)),
                  ),
                  _BoundField(
                    label: l10n.editorImageLicense,
                    initial: image.license,
                    error: missing(image.license),
                    onChanged: (value) =>
                        onChanged((i) => i.copyWith(license: value)),
                  ),
                ],
              ),
              ResponsiveFieldRow(
                children: [
                  _BoundField(
                    label: l10n.editorImageSourceName,
                    initial: image.sourceName,
                    onChanged: (value) =>
                        onChanged((i) => i.copyWith(sourceName: value)),
                  ),
                  _BoundField(
                    label: l10n.editorImageSourceUrl,
                    initial: image.sourceUrl,
                    keyboardType: TextInputType.url,
                    onChanged: (value) =>
                        onChanged((i) => i.copyWith(sourceUrl: value)),
                  ),
                ],
              ),
            ],
          );
          if (constraints.maxWidth < _stackBelow) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                thumbnail,
                const SizedBox(height: AppSpacing.md),
                fields,
              ],
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              thumbnail,
              const SizedBox(width: AppSpacing.md),
              Expanded(child: fields),
            ],
          );
        },
      ),
    );
  }
}

class _MembersTab extends StatefulWidget {
  const _MembersTab({required this.state});

  final CatalogEditorState state;

  @override
  State<_MembersTab> createState() => _MembersTabState();
}

class _MembersTabState extends State<_MembersTab> {
  late List<({String id, String name, bool archived})> _members = _fromSaved();

  List<({String id, String name, bool archived})> _fromSaved() => [
    for (final member
        in widget.state.saved?.value.members ?? const <ComplexMember>[])
      (id: member.id, name: member.name, archived: member.archived),
  ];

  bool get _changed {
    final saved = _fromSaved();
    return saved.length != _members.length ||
        [for (var i = 0; i < saved.length; i++) saved[i].id != _members[i].id]
            .any((d) => d);
  }

  void _move(int index, int delta) {
    final target = index + delta;
    if (target < 0 || target >= _members.length) {
      return;
    }
    setState(() {
      final member = _members.removeAt(index);
      _members.insert(target, member);
    });
  }

  Future<void> _add() async {
    final cubit = context.read<CatalogEditorCubit>();
    final picked = await showMembersPicker(
      context,
      search: cubit.searchMemberCandidates,
      complexId: widget.state.saved!.value.id,
      memberIds: {for (final m in _members) m.id},
    );
    if (picked.isEmpty || !mounted) {
      return;
    }
    setState(
      () => _members = [
        ..._members,
        for (final option in picked)
          (
            id: option.id,
            name: option.nameTr,
            archived: option.publication == Publication.archived,
          ),
      ],
    );
  }

  Future<void> _save() async {
    final l10n = context.l10n;
    final saved = await context.read<CatalogEditorCubit>().setMembers([
      for (final m in _members) m.id,
    ]);
    if (saved && mounted) {
      setState(() => _members = _fromSaved());
      AppSnackBar.show(context, message: l10n.editorMembersSaved);
      unawaited(
        context.read<A11yAnnouncer>().announce(l10n.editorMembersSaved),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    if (widget.state.saved == null || widget.state.creating) {
      return InlineMessage(message: l10n.editorMembersSaveFirst);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.editorMembersHelp, style: context.textStyles.bodyMedium),
        const SizedBox(height: AppSpacing.md),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: OutlinedButton(
            onPressed: widget.state.busy ? null : () => unawaited(_add()),
            child: Text(l10n.editorMembersAdd),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        if (_members.isEmpty)
          Text(l10n.editorMembersEmpty, style: context.textStyles.bodyMedium)
        else
          for (final (index, member) in _members.indexed)
            ListTile(
              key: ValueKey(member.id),
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.editorMemberOrder(index + 1, member.name)),
              subtitle: Text(
                member.archived
                    ? '${member.id} · ${l10n.editorMemberArchived}'
                    : member.id,
              ),
              trailing: Wrap(
                children: [
                  IconButton(
                    tooltip: l10n.editorImageMoveUp,
                    onPressed: index == 0 ? null : () => _move(index, -1),
                    icon: const Icon(Icons.arrow_upward),
                  ),
                  IconButton(
                    tooltip: l10n.editorImageMoveDown,
                    onPressed: index == _members.length - 1
                        ? null
                        : () => _move(index, 1),
                    icon: const Icon(Icons.arrow_downward),
                  ),
                  IconButton(
                    tooltip: l10n.editorMemberRemove,
                    onPressed: () => setState(
                      () => _members = [..._members]..removeAt(index),
                    ),
                    icon: const Icon(Icons.link_off),
                  ),
                ],
              ),
            ),
        const SizedBox(height: AppSpacing.md),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: FilledButton(
            onPressed: _changed && !widget.state.busy
                ? () => unawaited(_save())
                : null,
            child: Text(l10n.editorMembersSave),
          ),
        ),
      ],
    );
  }
}
