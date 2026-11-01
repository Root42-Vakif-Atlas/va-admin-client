import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakif_atlas_admin/core/a11y/a11y_announcer.dart';
import 'package:vakif_atlas_admin/core/error/failures.dart';
import 'package:vakif_atlas_admin/core/l10n/failure_messages.dart';
import 'package:vakif_atlas_admin/core/l10n/formatters.dart';
import 'package:vakif_atlas_admin/core/l10n/l10n.dart';
import 'package:vakif_atlas_admin/core/theme/theme_context.dart';
import 'package:vakif_atlas_admin/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas_admin/core/utils/list_equality.dart';
import 'package:vakif_atlas_admin/features/auth/domain/entities/staff_role.dart';
import 'package:vakif_atlas_admin/features/auth/presentation/widgets/role_labels.dart';
import 'package:vakif_atlas_admin/features/staff/domain/staff_member.dart';
import 'package:vakif_atlas_admin/features/staff/presentation/staff_cubits.dart';
import 'package:vakif_atlas_admin/shared/paging/record_cubit.dart';
import 'package:vakif_atlas_admin/shared/widgets/molecules/account_avatar.dart';
import 'package:vakif_atlas_admin/shared/widgets/molecules/admin_dialogs.dart';
import 'package:vakif_atlas_admin/shared/widgets/molecules/app_snack_bar.dart';
import 'package:vakif_atlas_admin/shared/widgets/molecules/detail_section.dart';
import 'package:vakif_atlas_admin/shared/widgets/molecules/inline_message.dart';
import 'package:vakif_atlas_admin/shared/widgets/molecules/status_chip.dart';
import 'package:vakif_atlas_admin/shared/widgets/templates/loading_status_view.dart';
import 'package:vakif_atlas_admin/shared/widgets/templates/status_message_view.dart';

class StaffDetailPanel extends StatelessWidget {
  const StaffDetailPanel({
    required this.currentUserId,
    required this.onClose,
    required this.onChanged,
    super.key,
  });

  /// Oturumdaki yönetici: kendi hesabında riskli işlemler kapalıdır (sunucu
  /// da reddeder).
  final String currentUserId;
  final VoidCallback onClose;
  final ValueChanged<StaffMember> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocConsumer<StaffDetailCubit, RecordState<StaffMember>>(
      listenWhen: (previous, current) =>
          previous.savedCount != current.savedCount ||
          (current.actionFailure != null &&
              previous.actionFailure != current.actionFailure),
      listener: (context, state) async {
        final cubit = context.read<StaffDetailCubit>();
        if (state.actionFailure is StaleDataFailure) {
          final reload = await showStaleDataDialog(context);
          cubit.clearActionFailure();
          if (reload) {
            await cubit.load();
          }
          return;
        }
        final member = state.value;
        if (state.actionFailure != null || member == null || !context.mounted) {
          return;
        }
        onChanged(member);
        AppSnackBar.show(context, message: l10n.staffActionDone);
        unawaited(context.read<A11yAnnouncer>().announce(l10n.staffActionDone));
      },
      builder: (context, state) {
        final member = state.value;
        if (state.loading && member == null) {
          return LoadingStatusView(label: l10n.commonLoading);
        }
        if (member == null) {
          return StatusMessageView(
            tone: StatusMessageTone.error,
            title: l10n.commonLoadError,
            message:
                state.loadFailure?.toUserMessage(l10n) ?? l10n.errorUnexpected,
            actionLabel: l10n.commonRetry,
            onAction: () => unawaited(context.read<StaffDetailCubit>().load()),
          );
        }
        final self = member.id == currentUserId;
        final failure = state.actionFailure is StaleDataFailure
            ? null
            : state.actionFailure;
        return ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Row(
              children: [
                AccountAvatar(
                  displayName: member.displayName,
                  size: AppSizes.avatarLarge,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Semantics(
                        header: true,
                        child: Text(
                          member.displayName,
                          style: context.textStyles.headlineMedium,
                        ),
                      ),
                      SelectableText(
                        member.email,
                        style: context.textStyles.bodyMedium,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Wrap(
                        spacing: AppSpacing.xs,
                        children: [
                          if (self)
                            StatusChip(
                              label: l10n.staffYou,
                              tone: StatusTone.accent,
                            ),
                          StatusChip(
                            label: member.disabled
                                ? l10n.staffStatusDisabled
                                : l10n.staffStatusActive,
                            tone: member.disabled
                                ? StatusTone.danger
                                : StatusTone.success,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: l10n.commonClose,
                  onPressed: onClose,
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            if (failure != null) ...[
              const SizedBox(height: AppSpacing.md),
              InlineMessage(
                type: InlineMessageType.error,
                message: failure.toUserMessage(l10n),
              ),
            ],
            if (self) ...[
              const SizedBox(height: AppSpacing.md),
              InlineMessage(message: l10n.staffSelfNote),
            ],
            const SizedBox(height: AppSpacing.lg),
            DetailSection(
              title: l10n.staffSectionAccount,
              child: KeyValueList(
                entries: [
                  (
                    l10n.staffLastLogin,
                    member.lastLoginAt == null
                        ? l10n.staffNever
                        : context.formatDateTime(member.lastLoginAt!),
                  ),
                  (l10n.staffCreatedAt, context.formatDate(member.createdAt)),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            DetailSection(
              title: l10n.staffRoles,
              child: _RolesForm(
                key: ValueKey(Object.hashAllUnordered(member.roles)),
                member: member,
                self: self,
                saving: state.saving,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            DetailSection(
              title: l10n.staffSectionSecurity,
              child: _SecurityActions(
                member: member,
                self: self,
                saving: state.saving,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _RolesForm extends StatefulWidget {
  const _RolesForm({
    required this.member,
    required this.self,
    required this.saving,
    super.key,
  });

  final StaffMember member;
  final bool self;
  final bool saving;

  @override
  State<_RolesForm> createState() => _RolesFormState();
}

class _RolesFormState extends State<_RolesForm> {
  late final Set<StaffRole> _roles = {...widget.member.roles};

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final changed = !setEquals(_roles, widget.member.roles);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final role in StaffRole.values)
          CheckboxListTile(
            value: _roles.contains(role),
            contentPadding: EdgeInsets.zero,
            title: Text(role.label(l10n)),
            subtitle: Text(role.description(l10n)),
            // Yönetici kendi yönetici rolünü kaldıramaz.
            onChanged: widget.saving || (widget.self && role == StaffRole.admin)
                ? null
                : (selected) => setState(
                    () => selected ?? false
                        ? _roles.add(role)
                        : _roles.remove(role),
                  ),
          ),
        const SizedBox(height: AppSpacing.sm),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: FilledButton(
            onPressed: changed && !widget.saving
                ? () => unawaited(
                    context.read<StaffDetailCubit>().setRoles(_roles),
                  )
                : null,
            child: Text(l10n.staffRolesSave),
          ),
        ),
      ],
    );
  }
}

class _SecurityActions extends StatelessWidget {
  const _SecurityActions({
    required this.member,
    required this.self,
    required this.saving,
  });

  final StaffMember member;
  final bool self;
  final bool saving;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<StaffDetailCubit>();
    Future<void> confirmThen(
      String title,
      String body,
      String label,
      Future<void> Function() action, {
      bool destructive = false,
    }) async {
      final confirmed = await showConfirmDialog(
        context,
        title: title,
        message: body,
        confirmLabel: label,
        destructive: destructive,
      );
      if (confirmed) {
        await action();
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              member.mfaEnrolled
                  ? Icons.verified_user_outlined
                  : Icons.gpp_maybe_outlined,
              color: member.mfaEnrolled
                  ? context.colors.success
                  : context.colors.warning,
            ),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: Text(
                member.mfaEnrolled
                    ? l10n.staffMfaEnrolled(
                        context.formatDate(member.mfaEnrolledAt!),
                      )
                    : l10n.staffMfaNotEnrolled,
                style: context.textStyles.bodyMedium,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: [
            OutlinedButton(
              onPressed: saving
                  ? null
                  : () => unawaited(
                      confirmThen(
                        l10n.staffRevokeConfirmTitle,
                        l10n.staffRevokeConfirmBody,
                        l10n.staffRevokeSessions,
                        cubit.revokeSessions,
                      ),
                    ),
              child: Text(l10n.staffRevokeSessions),
            ),
            if (!self && member.mfaEnrolled)
              OutlinedButton(
                onPressed: saving
                    ? null
                    : () => unawaited(
                        confirmThen(
                          l10n.staffResetMfaConfirmTitle,
                          l10n.staffResetMfaConfirmBody,
                          l10n.staffResetMfa,
                          cubit.resetMfa,
                          destructive: true,
                        ),
                      ),
                child: Text(l10n.staffResetMfa),
              ),
            if (!self)
              member.disabled
                  ? FilledButton.tonal(
                      onPressed: saving
                          ? null
                          : () => unawaited(cubit.setDisabled(disabled: false)),
                      child: Text(l10n.staffEnable),
                    )
                  : OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: context.colors.error,
                        side: BorderSide(color: context.colors.error),
                      ),
                      onPressed: saving
                          ? null
                          : () => unawaited(
                              confirmThen(
                                l10n.staffDisableConfirmTitle,
                                l10n.staffDisableConfirmBody,
                                l10n.staffDisable,
                                () => cubit.setDisabled(disabled: true),
                                destructive: true,
                              ),
                            ),
                      child: Text(l10n.staffDisable),
                    ),
          ],
        ),
      ],
    );
  }
}
