import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakif_atlas_admin/core/a11y/a11y_announcer.dart';
import 'package:vakif_atlas_admin/core/l10n/failure_messages.dart';
import 'package:vakif_atlas_admin/core/l10n/formatters.dart';
import 'package:vakif_atlas_admin/core/l10n/l10n.dart';
import 'package:vakif_atlas_admin/core/theme/theme_context.dart';
import 'package:vakif_atlas_admin/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas_admin/features/auth/domain/entities/staff_role.dart';
import 'package:vakif_atlas_admin/features/auth/domain/entities/staff_user.dart';
import 'package:vakif_atlas_admin/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vakif_atlas_admin/features/auth/presentation/pages/sign_in_page.dart';
import 'package:vakif_atlas_admin/features/auth/presentation/widgets/one_time_code_field.dart';
import 'package:vakif_atlas_admin/features/auth/presentation/widgets/role_labels.dart';
import 'package:vakif_atlas_admin/features/profile/presentation/profile_cubit.dart';
import 'package:vakif_atlas_admin/shared/widgets/atoms/role_badge.dart';
import 'package:vakif_atlas_admin/shared/widgets/molecules/account_avatar.dart';
import 'package:vakif_atlas_admin/shared/widgets/molecules/admin_dialogs.dart';
import 'package:vakif_atlas_admin/shared/widgets/molecules/app_snack_bar.dart';
import 'package:vakif_atlas_admin/shared/widgets/molecules/app_text_field.dart';
import 'package:vakif_atlas_admin/shared/widgets/molecules/detail_section.dart';
import 'package:vakif_atlas_admin/shared/widgets/molecules/inline_message.dart';
import 'package:vakif_atlas_admin/shared/widgets/templates/admin_page.dart';

/// Personelin kendi profili: hesap, roller, güvenlik (MFA, kurtarma kodları)
/// ve şifre değiştirme.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final user = context.select<AuthBloc, StaffUser?>(
      (bloc) => switch (bloc.state) {
        AuthAuthenticated(:final user) => user,
        _ => null,
      },
    );
    if (user == null) {
      return const SizedBox.shrink();
    }
    return BlocListener<ProfileCubit, ProfileState>(
      listenWhen: (previous, current) =>
          previous.passwordChanges != current.passwordChanges,
      listener: (context, state) {
        AppSnackBar.show(context, message: l10n.profilePasswordSaved);
        unawaited(
          context.read<A11yAnnouncer>().announce(l10n.profilePasswordSaved),
        );
      },
      child: AdminPage(
        title: l10n.profileTitle,
        actions: [
          OutlinedButton(
            onPressed: () async {
              final bloc = context.read<AuthBloc>();
              final confirmed = await showConfirmDialog(
                context,
                title: l10n.signOutConfirmTitle,
                message: l10n.signOutConfirmBody,
                confirmLabel: l10n.profileSignOut,
              );
              if (confirmed) {
                bloc.add(const AuthEvent.logoutRequested());
              }
            },
            child: Text(l10n.profileSignOut),
          ),
        ],
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Align(
            alignment: AlignmentDirectional.topStart,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppSizes.formMaxWidth,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DetailSection(
                    title: l10n.profileSectionAccount,
                    child: Row(
                      children: [
                        AccountAvatar(
                          displayName: user.displayName,
                          size: AppSizes.avatarLarge,
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.displayName,
                                style: context.textStyles.titleLarge,
                              ),
                              SelectableText(
                                user.email,
                                style: context.textStyles.bodyMedium,
                              ),
                              if (user.lastLoginAt != null)
                                Text(
                                  '${l10n.staffLastLogin}: ${context.formatDateTime(user.lastLoginAt!)}',
                                  style: context.textStyles.bodySmall,
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  DetailSection(
                    title: l10n.profileSectionRoles,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: AppSpacing.xs,
                          runSpacing: AppSpacing.xs,
                          children: [
                            for (final role in StaffRole.values)
                              if (user.roles.contains(role))
                                RoleBadge(label: role.label(l10n)),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          l10n.profileRolesHelp,
                          style: context.textStyles.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  DetailSection(
                    title: l10n.profileSectionSecurity,
                    child: _SecuritySection(user: user),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  DetailSection(
                    title: l10n.profileSectionPassword,
                    child: const _PasswordForm(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SecuritySection extends StatelessWidget {
  const _SecuritySection({required this.user});

  final StaffUser user;

  static const int _lowThreshold = 3;

  Future<void> _regenerate(BuildContext context) async {
    final cubit = context.read<ProfileCubit>();
    final codes = await showDialog<bool>(
      context: context,
      builder: (_) =>
          BlocProvider.value(value: cubit, child: const _RegenerateDialog()),
    );
    if (codes != true || !context.mounted) {
      return;
    }
    final l10n = context.l10n;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.recoveryTitle),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppSizes.dialogWidth),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.recoveryBody),
              const SizedBox(height: AppSpacing.md),
              RecoveryCodesGrid(codes: cubit.state.recoveryCodes),
            ],
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.recoveryAcknowledge),
          ),
        ],
      ),
    );
    cubit.dismissRecoveryCodes();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final remaining = user.recoveryCodesRemaining;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.profileMfaOn(
            user.mfaEnrolledAt == null
                ? '—'
                : context.formatDate(user.mfaEnrolledAt!),
          ),
          style: context.textStyles.bodyMedium,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          l10n.profileRecoveryRemaining(remaining),
          style: context.textStyles.bodyMedium,
        ),
        if (remaining <= _lowThreshold) ...[
          const SizedBox(height: AppSpacing.xs),
          InlineMessage(
            type: InlineMessageType.warning,
            message: l10n.profileRecoveryLow,
          ),
        ],
        const SizedBox(height: AppSpacing.sm),
        OutlinedButton(
          onPressed: () => unawaited(_regenerate(context)),
          child: Text(l10n.profileRegenerate),
        ),
      ],
    );
  }
}

class _RegenerateDialog extends StatefulWidget {
  const _RegenerateDialog();

  @override
  State<_RegenerateDialog> createState() => _RegenerateDialogState();
}

class _RegenerateDialogState extends State<_RegenerateDialog> {
  final _code = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!isCompleteCode(_code.text, recovery: false)) {
      setState(() => _error = context.l10n.signInMfaCodeInvalid);
      return;
    }
    final navigator = Navigator.of(context);
    if (await context.read<ProfileCubit>().regenerateRecoveryCodes(
      _code.text,
    )) {
      navigator.pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<ProfileCubit>().state;
    final failure = state.failed == ProfileAction.recoveryCodes
        ? state.failure
        : null;
    final running = state.running == ProfileAction.recoveryCodes;
    return AlertDialog(
      title: Text(l10n.profileRegenerateTitle),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppSizes.dialogWidth),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.profileRegenerateBody),
            const SizedBox(height: AppSpacing.md),
            if (failure != null) ...[
              InlineMessage(
                type: InlineMessageType.error,
                message: failure.toUserMessage(l10n),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
            OneTimeCodeField(
              controller: _code,
              autofocus: true,
              label: l10n.signInMfaCode,
              errorText: _error,
              enabled: !running,
              onSubmitted: (_) => unawaited(_submit()),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: running ? null : () => Navigator.of(context).pop(false),
          child: Text(l10n.commonCancel),
        ),
        FilledButton(
          onPressed: running ? null : () => unawaited(_submit()),
          child: Text(l10n.profileRegenerateConfirm),
        ),
      ],
    );
  }
}

class _PasswordForm extends StatefulWidget {
  const _PasswordForm();

  @override
  State<_PasswordForm> createState() => _PasswordFormState();
}

class _PasswordFormState extends State<_PasswordForm> {
  final _current = TextEditingController();
  final _next = TextEditingController();
  String? _nextError;

  @override
  void dispose() {
    _current.dispose();
    _next.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = context.l10n;
    setState(
      () => _nextError = _next.text.length >= 12
          ? null
          : l10n.resetPasswordTooShort,
    );
    if (_nextError != null) {
      return;
    }
    final saved = await context.read<ProfileCubit>().changePassword(
      currentPassword: _current.text,
      newPassword: _next.text,
    );
    if (saved) {
      _current.clear();
      _next.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<ProfileCubit>().state;
    final running = state.running == ProfileAction.password;
    final failure = state.failed == ProfileAction.password
        ? state.failure
        : null;
    return AutofillGroup(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (failure != null) ...[
            InlineMessage(
              type: InlineMessageType.error,
              message: failure.toUserMessage(l10n),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
          AppTextField(
            label: l10n.profileCurrentPassword,
            controller: _current,
            isPassword: true,
            autofillHints: const [AutofillHints.password],
            enabled: !running,
          ),
          const SizedBox(height: AppSpacing.sm),
          AppTextField(
            label: l10n.resetNewPassword,
            controller: _next,
            isPassword: true,
            helperText: l10n.resetPasswordHint,
            errorText: _nextError,
            autofillHints: const [AutofillHints.newPassword],
            onSubmitted: (_) => unawaited(_submit()),
            enabled: !running,
          ),
          const SizedBox(height: AppSpacing.md),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: FilledButton(
              onPressed: running ? null : () => unawaited(_submit()),
              child: Text(l10n.commonSave),
            ),
          ),
        ],
      ),
    );
  }
}
