import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakif_atlas_admin/core/a11y/a11y_announcer.dart';
import 'package:vakif_atlas_admin/core/l10n/failure_messages.dart';
import 'package:vakif_atlas_admin/core/l10n/l10n.dart';
import 'package:vakif_atlas_admin/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas_admin/features/auth/presentation/cubit/password_reset_cubit.dart';
import 'package:vakif_atlas_admin/features/auth/presentation/widgets/auth_layout.dart';
import 'package:vakif_atlas_admin/features/auth/presentation/widgets/one_time_code_field.dart';
import 'package:vakif_atlas_admin/shared/widgets/atoms/app_button.dart';
import 'package:vakif_atlas_admin/shared/widgets/molecules/app_text_field.dart';
import 'package:vakif_atlas_admin/shared/widgets/molecules/inline_message.dart';

/// Şifre belirleme / sıfırlama: e-posta → (e-postadaki kod + yeni şifre).
/// Davet edilen personel ilk şifresini de burada belirler.
class PasswordResetPage extends StatefulWidget {
  const PasswordResetPage({required this.onBackToSignIn, super.key});

  final VoidCallback onBackToSignIn;

  @override
  State<PasswordResetPage> createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage> {
  final _email = TextEditingController();
  final _code = TextEditingController();
  final _password = TextEditingController();
  String? _emailError;
  String? _codeError;
  String? _passwordError;

  /// Sunucu politikasıyla aynı alt sınır (ADR 12); ayrıntılı kural sunucuda.
  static const int _minPasswordLength = 12;

  static final RegExp _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  @override
  void dispose() {
    _email.dispose();
    _code.dispose();
    _password.dispose();
    super.dispose();
  }

  void _requestCode() {
    final valid = _emailPattern.hasMatch(_email.text.trim());
    setState(
      () => _emailError = valid ? null : context.l10n.signInEmailInvalid,
    );
    if (valid) {
      unawaited(context.read<PasswordResetCubit>().requestCode(_email.text));
    }
  }

  void _reset() {
    final l10n = context.l10n;
    setState(() {
      _codeError = isCompleteCode(_code.text, recovery: false)
          ? null
          : l10n.signInMfaCodeInvalid;
      _passwordError = _password.text.length >= _minPasswordLength
          ? null
          : l10n.resetPasswordTooShort;
    });
    if (_codeError == null && _passwordError == null) {
      unawaited(
        context.read<PasswordResetCubit>().reset(
          code: _code.text,
          newPassword: _password.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocListener<PasswordResetCubit, PasswordResetState>(
      listenWhen: (previous, current) =>
          previous.step != current.step ||
          (current.failure != null && previous.failure != current.failure),
      listener: (context, state) {
        final message =
            state.failure?.toUserMessage(l10n) ??
            switch (state.step) {
              PasswordResetStep.request => l10n.resetTitle,
              PasswordResetStep.confirm => l10n.resetCodeSent,
              PasswordResetStep.done => l10n.resetDone,
            };
        unawaited(
          context.read<A11yAnnouncer>().announce(
            message,
            assertive: state.failure != null,
          ),
        );
      },
      child: AuthLayout(
        child: BlocBuilder<PasswordResetCubit, PasswordResetState>(
          builder: (context, state) {
            final failure = state.failure;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AuthHeading(title: l10n.resetTitle, body: l10n.resetBody),
                if (failure != null) ...[
                  InlineMessage(
                    type: InlineMessageType.error,
                    message: failure.toUserMessage(l10n),
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
                ...switch (state.step) {
                  PasswordResetStep.request => [
                    AppTextField(
                      label: l10n.signInEmail,
                      controller: _email,
                      errorText: _emailError,
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [AutofillHints.email],
                      onSubmitted: (_) => _requestCode(),
                      enabled: !state.submitting,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    AppButton.primary(
                      label: l10n.resetSendCode,
                      isLoading: state.submitting,
                      expand: true,
                      onPressed: state.submitting ? null : _requestCode,
                    ),
                  ],
                  PasswordResetStep.confirm => [
                    InlineMessage(message: l10n.resetCodeSent),
                    const SizedBox(height: AppSpacing.md),
                    OneTimeCodeField(
                      controller: _code,
                      label: l10n.resetCode,
                      errorText: _codeError,
                      autofocus: true,
                      enabled: !state.submitting,
                      onSubmitted: (_) => _reset(),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppTextField(
                      label: l10n.resetNewPassword,
                      controller: _password,
                      isPassword: true,
                      helperText: l10n.resetPasswordHint,
                      errorText: _passwordError,
                      autofillHints: const [AutofillHints.newPassword],
                      onSubmitted: (_) => _reset(),
                      enabled: !state.submitting,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    AppButton.primary(
                      label: l10n.resetSubmit,
                      isLoading: state.submitting,
                      expand: true,
                      onPressed: state.submitting ? null : _reset,
                    ),
                  ],
                  PasswordResetStep.done => [
                    InlineMessage(
                      type: InlineMessageType.success,
                      message: l10n.resetDone,
                    ),
                  ],
                },
                const SizedBox(height: AppSpacing.sm),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: TextButton(
                    onPressed: widget.onBackToSignIn,
                    child: Text(l10n.resetBackToSignIn),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
