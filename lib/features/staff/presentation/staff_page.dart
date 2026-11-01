import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakif_atlas_admin/core/a11y/a11y_announcer.dart';
import 'package:vakif_atlas_admin/core/keyboard/app_shortcuts.dart';
import 'package:vakif_atlas_admin/core/l10n/failure_messages.dart';
import 'package:vakif_atlas_admin/core/l10n/l10n.dart';
import 'package:vakif_atlas_admin/core/utils/idempotency.dart';
import 'package:vakif_atlas_admin/core/theme/theme_context.dart';
import 'package:vakif_atlas_admin/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas_admin/features/auth/domain/entities/staff_role.dart';
import 'package:vakif_atlas_admin/features/auth/presentation/widgets/role_labels.dart';
import 'package:vakif_atlas_admin/features/staff/domain/staff_member.dart';
import 'package:vakif_atlas_admin/features/staff/presentation/staff_cubits.dart';
import 'package:vakif_atlas_admin/shared/paging/paged_list_cubit.dart';
import 'package:vakif_atlas_admin/shared/widgets/molecules/account_avatar.dart';
import 'package:vakif_atlas_admin/shared/widgets/molecules/app_snack_bar.dart';
import 'package:vakif_atlas_admin/shared/widgets/molecules/inline_message.dart';
import 'package:vakif_atlas_admin/shared/widgets/molecules/filter_menu.dart';
import 'package:vakif_atlas_admin/shared/widgets/molecules/search_field.dart';
import 'package:vakif_atlas_admin/shared/widgets/molecules/status_chip.dart';
import 'package:vakif_atlas_admin/shared/widgets/organisms/paged_list.dart';
import 'package:vakif_atlas_admin/shared/widgets/templates/admin_page.dart';
import 'package:vakif_atlas_admin/shared/widgets/templates/master_detail_layout.dart';
import 'package:vakif_atlas_admin/shared/widgets/templates/status_message_view.dart';

typedef _ListState = PagedListState<StaffMember, StaffFilter>;

/// Personel listesi + seçili personel; davet diyaloğu (Cmd/Ctrl + N).
class StaffPage extends StatefulWidget {
  const StaffPage({
    required this.selectedId,
    required this.detailBuilder,
    required this.inviteCubitBuilder,
    required this.onSelect,
    super.key,
  });

  final String? selectedId;
  final Widget Function(String id) detailBuilder;

  /// Kompozisyon kökü davet cubit'ini sağlar.
  final StaffInviteCubit Function() inviteCubitBuilder;
  final ValueChanged<String?> onSelect;

  @override
  State<StaffPage> createState() => _StaffPageState();
}

class _StaffPageState extends State<StaffPage> {
  final _searchFocus = FocusNode();

  @override
  void dispose() {
    _searchFocus.dispose();
    super.dispose();
  }

  Future<void> _invite() async {
    final list = context.read<StaffListCubit>();
    final member = await showDialog<StaffMember>(
      context: context,
      builder: (_) => BlocProvider(
        create: (_) => widget.inviteCubitBuilder(),
        child: const _InviteDialog(),
      ),
    );
    if (member == null || !mounted) {
      return;
    }
    list.prepend(member);
    final message = context.l10n.staffInvited(member.displayName);
    AppSnackBar.show(context, message: message);
    unawaited(context.read<A11yAnnouncer>().announce(message));
    widget.onSelect(member.id);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<StaffListCubit>();
    void update(StaffFilter filter) => unawaited(cubit.load(filter));
    return Actions(
      actions: {
        FocusSearchIntent: CallbackAction<FocusSearchIntent>(
          onInvoke: (_) => _searchFocus.requestFocus(),
        ),
        CreateItemIntent: CallbackAction<CreateItemIntent>(
          onInvoke: (_) => unawaited(_invite()),
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
          title: l10n.staffTitle,
          subtitle: l10n.staffSubtitle,
          actions: [
            Tooltip(
              message: AppShortcuts.label('N'),
              child: FilledButton(
                onPressed: () => unawaited(_invite()),
                child: Text(l10n.staffInvite),
              ),
            ),
          ],
          toolbar: BlocBuilder<StaffListCubit, _ListState>(
            buildWhen: (previous, current) => previous.filter != current.filter,
            builder: (context, state) {
              final filter = state.filter;
              return Wrap(
                spacing: AppSpacing.md,
                runSpacing: AppSpacing.sm,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  SizedBox(
                    width: 320,
                    child: SearchField(
                      label: l10n.staffSearch,
                      initialValue: filter.query,
                      focusNode: _searchFocus,
                      onChanged: (query) =>
                          update(cubit.state.filter.copyWith(query: query)),
                    ),
                  ),
                  FilterMenu<StaffRole>(
                    label: l10n.staffFilterRole,
                    multiple: false,
                    options: [
                      for (final role in StaffRole.values)
                        FilterOption(role, role.label(l10n)),
                    ],
                    selected: {?filter.role},
                    onChanged: (selected) => update(
                      cubit.state.filter.copyWith(
                        role: () => selected.isEmpty ? null : selected.first,
                      ),
                    ),
                  ),
                  SegmentedButton<StaffStatusFilter>(
                    showSelectedIcon: false,
                    segments: [
                      ButtonSegment(
                        value: StaffStatusFilter.all,
                        label: Text(l10n.commonAll),
                      ),
                      ButtonSegment(
                        value: StaffStatusFilter.active,
                        label: Text(l10n.staffStatusActive),
                      ),
                      ButtonSegment(
                        value: StaffStatusFilter.disabled,
                        label: Text(l10n.staffStatusDisabled),
                      ),
                    ],
                    selected: {filter.status},
                    onSelectionChanged: (selection) => update(
                      cubit.state.filter.copyWith(status: selection.first),
                    ),
                  ),
                ],
              );
            },
          ),
          child: MasterDetailLayout(
            masterLabel: l10n.staffListLabel,
            detailLabel: l10n.staffDetailLabel,
            master: BlocBuilder<StaffListCubit, _ListState>(
              builder: (context, state) => PagedList<StaffMember>(
                items: state.items,
                total: state.total,
                isLoading: state.loading,
                isLoadingMore: state.loadingMore,
                hasMore: state.hasMore,
                onLoadMore: () => unawaited(cubit.loadMore()),
                onRetry: () => unawaited(cubit.refresh()),
                errorMessage: state.failure?.toUserMessage(l10n),
                itemBuilder: (context, member, _) => _StaffTile(
                  member: member,
                  selected: member.id == widget.selectedId,
                  onTap: () => widget.onSelect(member.id),
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
              title: l10n.staffDetailLabel,
              message: l10n.commonSelectPrompt,
            ),
          ),
        ),
      ),
    );
  }
}

class _StaffTile extends StatelessWidget {
  const _StaffTile({
    required this.member,
    required this.selected,
    required this.onTap,
  });

  final StaffMember member;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final roles = [
      for (final role in StaffRole.values)
        if (member.roles.contains(role)) role.label(l10n),
    ].join(', ');
    final status = member.disabled
        ? l10n.staffStatusDisabled
        : l10n.staffStatusActive;
    return Semantics(
      button: true,
      selected: selected,
      label: l10n.staffTileSemantics(member.displayName, roles, status),
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
            child: Row(
              children: [
                AccountAvatar(
                  displayName: member.displayName,
                  size: AppSizes.iconXl - AppSpacing.xs,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        member.displayName,
                        style: context.textStyles.titleMedium,
                      ),
                      Text(member.email, style: context.textStyles.bodySmall),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(roles, style: context.textStyles.bodyMedium),
                    ],
                  ),
                ),
                if (member.disabled)
                  StatusChip(
                    label: l10n.staffStatusDisabled,
                    tone: StatusTone.danger,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InviteDialog extends StatefulWidget {
  const _InviteDialog();

  @override
  State<_InviteDialog> createState() => _InviteDialogState();
}

class _InviteDialogState extends State<_InviteDialog> {
  final _email = TextEditingController();
  final _name = TextEditingController();
  final Set<StaffRole> _roles = {};

  /// Diyalog başına bir anahtar: tekrar gönderim aynı daveti döndürür.
  final String _idempotencyKey = newIdempotencyKey();
  String? _emailError;
  String? _nameError;
  String? _rolesError;

  static final RegExp _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  @override
  void dispose() {
    _email.dispose();
    _name.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final l10n = context.l10n;
    setState(() {
      _emailError = _emailPattern.hasMatch(_email.text.trim())
          ? null
          : l10n.signInEmailInvalid;
      _nameError = _name.text.trim().isEmpty
          ? l10n.staffInviteNameRequired
          : null;
      _rolesError = _roles.isEmpty ? l10n.staffInviteRolesRequired : null;
    });
    if (_emailError != null || _nameError != null || _rolesError != null) {
      return;
    }
    final navigator = Navigator.of(context);
    final member = await context.read<StaffInviteCubit>().invite(
      StaffInvitation(
        email: _email.text,
        displayName: _name.text,
        roles: _roles,
        idempotencyKey: _idempotencyKey,
      ),
    );
    if (member != null) {
      navigator.pop(member);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<StaffInviteCubit>().state;
    return AlertDialog(
      title: Text(l10n.staffInviteTitle),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppSizes.dialogWidth),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.staffInviteBody, style: context.textStyles.bodyMedium),
              const SizedBox(height: AppSpacing.md),
              if (state.failure != null) ...[
                InlineMessage(
                  type: InlineMessageType.error,
                  message: state.failure!.toUserMessage(l10n),
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
              TextField(
                controller: _name,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: l10n.staffInviteName,
                  errorText: _nameError,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: l10n.signInEmail,
                  errorText: _emailError,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(l10n.staffRoles, style: context.textStyles.labelLarge),
              for (final role in StaffRole.values)
                CheckboxListTile(
                  value: _roles.contains(role),
                  contentPadding: EdgeInsets.zero,
                  title: Text(role.label(l10n)),
                  subtitle: Text(role.description(l10n)),
                  onChanged: (selected) => setState(() {
                    selected ?? false ? _roles.add(role) : _roles.remove(role);
                    _rolesError = null;
                  }),
                ),
              if (_rolesError != null)
                Text(
                  _rolesError!,
                  style: context.textStyles.bodySmall.copyWith(
                    color: context.colors.error,
                  ),
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: state.sending ? null : () => Navigator.of(context).pop(),
          child: Text(l10n.commonCancel),
        ),
        FilledButton(
          onPressed: state.sending ? null : () => unawaited(_send()),
          child: Text(l10n.staffInviteSend),
        ),
      ],
    );
  }
}
