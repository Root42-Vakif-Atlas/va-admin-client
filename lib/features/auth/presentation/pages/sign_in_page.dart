import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vakif_atlas_admin/core/a11y/a11y_announcer.dart';
import 'package:vakif_atlas_admin/core/l10n/failure_messages.dart';
import 'package:vakif_atlas_admin/core/l10n/l10n.dart';
import 'package:vakif_atlas_admin/core/theme/theme_context.dart';
import 'package:vakif_atlas_admin/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas_admin/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vakif_atlas_admin/features/auth/presentation/cubit/staff_sign_in_cubit.dart';
import 'package:vakif_atlas_admin/features/auth/presentation/widgets/auth_layout.dart';
import 'package:vakif_atlas_admin/features/auth/presentation/widgets/one_time_code_field.dart';
import 'package:vakif_atlas_admin/shared/widgets/atoms/app_button.dart';
import 'package:vakif_atlas_admin/shared/widgets/molecules/app_snack_bar.dart';
import 'package:vakif_atlas_admin/shared/widgets/molecules/app_text_field.dart';
import 'package:vakif_atlas_admin/shared/widgets/molecules/inline_message.dart';

/// Personel girişi: e-posta + şifre → Authenticator kodu (veya kurtarma
/// kodu); ilk girişte Authenticator kurulumu ve kurtarma kodları. Her adım
/// değişimi ve hata ekran okuyucuya duyurulur (WCAG 4.1.3).
class SignInPage extends StatelessWidget {
  const SignInPage({required this.onForgotPassword, super.key});

  final VoidCallback onForgotPassword;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocListener<StaffSignInCubit, StaffSignInState>(
      listenWhen: (previous, current) =>
          previous.step != current.step ||
          (current.failure != null && previous.failure != current.failure),
      listener: (context, state) {
        final announcer = context.read<A11yAnnouncer>();
        final failure = state.failure;
        if (failure != null) {
          unawaited(
            announcer.announce(failure.toUserMessage(l10n), assertive: true),
          );
          return;
        }
        final title = switch (state.step) {
          SignInStep.credentials => l10n.signInTitle,
          SignInStep.verify => l10n.signInMfaTitle,
          SignInStep.enroll => l10n.enrollTitle,
          SignInStep.recoveryCodes => l10n.recoveryTitle,
        };
        unawaited(announcer.announce(title));
      },
      child: AuthLayout(
        child: BlocBuilder<StaffSignInCubit, StaffSignInState>(
          buildWhen: (previous, current) => previous.step != current.step,
          builder: (context, state) => switch (state.step) {
            SignInStep.credentials => _CredentialsStep(
              onForgotPassword: onForgotPassword,
            ),
            SignInStep.verify => const _VerifyStep(),
            SignInStep.enroll => const _EnrollStep(),
            SignInStep.recoveryCodes => const _RecoveryCodesStep(),
          },
        ),
      ),
    );
  }
}

class _FailureMessage extends StatelessWidget {
  const _FailureMessage();

  @override
  Widget build(BuildContext context) {
    final failure = context.select<StaffSignInCubit, Object?>(
      (cubit) => cubit.state.failure,
    );
    if (failure == null) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: InlineMessage(
        type: InlineMessageType.error,
        message: context.read<StaffSignInCubit>().state.failure!.toUserMessage(
          context.l10n,
        ),
      ),
    );
  }
}

class _CredentialsStep extends StatefulWidget {
  const _CredentialsStep({required this.onForgotPassword});

  final VoidCallback onForgotPassword;

  @override
  State<_CredentialsStep> createState() => _CredentialsStepState();
}

class _CredentialsStepState extends State<_CredentialsStep> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  String? _emailError;
  String? _passwordError;

  static final RegExp _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  void _submit() {
    final l10n = context.l10n;
    setState(() {
      _emailError = _emailPattern.hasMatch(_email.text.trim())
          ? null
          : l10n.signInEmailInvalid;
      _passwordError = _password.text.isEmpty
          ? l10n.signInPasswordRequired
          : null;
    });
    if (_emailError != null || _passwordError != null) {
      return;
    }
    TextInput.finishAutofillContext();
    unawaited(
      context.read<StaffSignInCubit>().submitCredentials(
        email: _email.text,
        password: _password.text,
      ),
    );
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final submitting = context.select<StaffSignInCubit, bool>(
      (cubit) => cubit.state.submitting,
    );
    final reason = context.select<AuthBloc, GuestReason>(
      (bloc) => switch (bloc.state) {
        AuthGuest(:final reason) => reason,
        _ => GuestReason.none,
      },
    );
    return AutofillGroup(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AuthHeading(title: l10n.signInTitle, body: l10n.signInSubtitle),
          if (reason != GuestReason.none) ...[
            InlineMessage(
              type: InlineMessageType.warning,
              message: reason == GuestReason.idle
                  ? l10n.sessionIdleMessage
                  : l10n.sessionExpiredMessage,
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          const _FailureMessage(),
          AppTextField(
            label: l10n.signInEmail,
            controller: _email,
            errorText: _emailError,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.username, AutofillHints.email],
            enabled: !submitting,
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            label: l10n.signInPassword,
            controller: _password,
            errorText: _passwordError,
            isPassword: true,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.password],
            onSubmitted: (_) => _submit(),
            enabled: !submitting,
          ),
          const SizedBox(height: AppSpacing.lg),
          AppButton.primary(
            label: l10n.signInSubmit,
            isLoading: submitting,
            expand: true,
            onPressed: submitting ? null : _submit,
          ),
          const SizedBox(height: AppSpacing.sm),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton(
              onPressed: submitting ? null : widget.onForgotPassword,
              child: Text(l10n.signInForgotPassword),
            ),
          ),
        ],
      ),
    );
  }
}

class _VerifyStep extends StatefulWidget {
  const _VerifyStep();

  @override
  State<_VerifyStep> createState() => _VerifyStepState();
}

class _VerifyStepState extends State<_VerifyStep> {
  final _code = TextEditingController();
  String? _error;

  void _submit() {
    final cubit = context.read<StaffSignInCubit>();
    final recovery = cubit.state.useRecoveryCode;
    if (!isCompleteCode(_code.text, recovery: recovery)) {
      setState(
        () => _error = recovery
            ? context.l10n.signInRecoveryInvalid
            : context.l10n.signInMfaCodeInvalid,
      );
      return;
    }
    setState(() => _error = null);
    unawaited(cubit.verify(_code.text));
  }

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<StaffSignInCubit>().state;
    final recovery = state.useRecoveryCode;
    final minutes = state.challenge?.expiresAt
        .difference(DateTime.now())
        .inMinutes
        .clamp(1, 60);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AuthHeading(
          title: l10n.signInMfaTitle,
          body: recovery ? l10n.recoveryBody : l10n.signInMfaBody,
        ),
        const _FailureMessage(),
        OneTimeCodeField(
          key: ValueKey(recovery),
          controller: _code,
          recovery: recovery,
          autofocus: true,
          label: recovery ? l10n.signInRecoveryCode : l10n.signInMfaCode,
          hint: recovery ? l10n.signInRecoveryHint : null,
          errorText: _error,
          enabled: !state.submitting,
          onSubmitted: (_) => _submit(),
        ),
        if (minutes != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            l10n.signInExpiresIn(minutes),
            style: context.textStyles.bodySmall,
          ),
        ],
        const SizedBox(height: AppSpacing.lg),
        AppButton.primary(
          label: l10n.signInMfaVerify,
          isLoading: state.submitting,
          expand: true,
          onPressed: state.submitting ? null : _submit,
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.xs,
          children: [
            TextButton(
              onPressed: state.submitting
                  ? null
                  : () {
                      _code.clear();
                      setState(() => _error = null);
                      context.read<StaffSignInCubit>().toggleRecoveryCode();
                    },
              child: Text(
                recovery ? l10n.signInUseAuthenticator : l10n.signInUseRecovery,
              ),
            ),
            TextButton(
              onPressed: state.submitting
                  ? null
                  : context.read<StaffSignInCubit>().restart,
              child: Text(l10n.signInBack),
            ),
          ],
        ),
      ],
    );
  }
}

class _EnrollStep extends StatefulWidget {
  const _EnrollStep();

  @override
  State<_EnrollStep> createState() => _EnrollStepState();
}

class _EnrollStepState extends State<_EnrollStep> {
  final _code = TextEditingController();
  String? _error;

  void _submit() {
    if (!isCompleteCode(_code.text, recovery: false)) {
      setState(() => _error = context.l10n.signInMfaCodeInvalid);
      return;
    }
    setState(() => _error = null);
    unawaited(context.read<StaffSignInCubit>().confirmEnrollment(_code.text));
  }

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<StaffSignInCubit>().state;
    final enrollment = state.enrollment;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AuthHeading(title: l10n.enrollTitle, body: l10n.enrollBody),
        const _FailureMessage(),
        if (enrollment == null)
          const Center(child: CircularProgressIndicator())
        else ...[
          Center(
            child: Semantics(
              image: true,
              label: l10n.enrollQrSemantics,
              child: DecoratedBox(
                // Tarayıcılar için tema ne olursa olsun beyaz zemin, siyah kod.
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  child: QrImageView(
                    data: enrollment.otpauthUri,
                    size: AppSizes.qrCode,
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            l10n.enrollAccount(enrollment.account),
            style: context.textStyles.bodySmall,
          ),
          const SizedBox(height: AppSpacing.xs),
          _SecretTile(secret: enrollment.secret),
          const SizedBox(height: AppSpacing.lg),
          OneTimeCodeField(
            controller: _code,
            label: l10n.enrollConfirmCode,
            errorText: _error,
            enabled: !state.submitting,
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppButton.primary(
            label: l10n.enrollConfirm,
            isLoading: state.submitting,
            expand: true,
            onPressed: state.submitting ? null : _submit,
          ),
        ],
        const SizedBox(height: AppSpacing.sm),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: TextButton(
            onPressed: state.submitting
                ? null
                : context.read<StaffSignInCubit>().restart,
            child: Text(l10n.signInBack),
          ),
        ),
      ],
    );
  }
}

class _SecretTile extends StatelessWidget {
  const _SecretTile({required this.secret});

  final String secret;

  /// Okunabilirlik için 4'lü gruplar (yapıştırmada boşluklar yok sayılır).
  String get _grouped => [
    for (var i = 0; i < secret.length; i += 4)
      secret.substring(i, i + 4 > secret.length ? secret.length : i + 4),
  ].join(' ');

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Row(
          children: [
            Expanded(
              child: MergeSemantics(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.enrollSecretLabel,
                      style: context.textStyles.labelMedium,
                    ),
                    SelectableText(
                      _grouped,
                      style: context.textStyles.titleMedium.copyWith(
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              tooltip: l10n.commonCopy,
              icon: const Icon(Icons.copy_outlined),
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: secret));
                if (context.mounted) {
                  AppSnackBar.show(context, message: l10n.commonCopied);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _RecoveryCodesStep extends StatefulWidget {
  const _RecoveryCodesStep();

  @override
  State<_RecoveryCodesStep> createState() => _RecoveryCodesStepState();
}

class _RecoveryCodesStepState extends State<_RecoveryCodesStep> {
  bool _acknowledged = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final codes = context.select<StaffSignInCubit, List<String>>(
      (cubit) => cubit.state.recoveryCodes,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AuthHeading(title: l10n.recoveryTitle, body: l10n.recoveryBody),
        RecoveryCodesGrid(codes: codes),
        const SizedBox(height: AppSpacing.md),
        CheckboxListTile(
          value: _acknowledged,
          onChanged: (value) => setState(() => _acknowledged = value ?? false),
          title: Text(l10n.recoveryAcknowledge),
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        ),
        const SizedBox(height: AppSpacing.md),
        AppButton.primary(
          label: l10n.recoveryContinue,
          expand: true,
          onPressed: _acknowledged
              ? context.read<StaffSignInCubit>().finishEnrollment
              : null,
        ),
      ],
    );
  }
}

/// Kurtarma kodları (eşit genişlikli ızgara) + "Tümünü kopyala".
class RecoveryCodesGrid extends StatelessWidget {
  const RecoveryCodesGrid({required this.codes, super.key});

  final List<String> codes;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: context.colors.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              spacing: AppSpacing.lg,
              runSpacing: AppSpacing.xs,
              children: [
                for (final code in codes)
                  SelectableText(
                    code,
                    style: context.textStyles.titleMedium.copyWith(
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton(
                onPressed: () async {
                  await Clipboard.setData(
                    ClipboardData(text: codes.join('\n')),
                  );
                  if (context.mounted) {
                    AppSnackBar.show(context, message: l10n.commonCopied);
                  }
                },
                child: Text(l10n.recoveryCopyAll),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
