import 'package:flutter/material.dart';
import 'package:vakif_atlas_admin/core/l10n/l10n.dart';
import 'package:vakif_atlas_admin/core/theme/tokens/app_spacing.dart';

/// Onay diyaloğu; geri dönüşü zor işlemler için (WCAG 3.3.4). `true` →
/// onaylandı.
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
  bool destructive = false,
}) async {
  final l10n = context.l10n;
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppSizes.dialogWidth),
        child: Text(message),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.commonCancel),
        ),
        FilledButton(
          style: destructive
              ? FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Theme.of(context).colorScheme.onError,
                )
              : null,
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return result ?? false;
}

/// Kayıt başkası tarafından değiştirildi (412): güncel hâli yükleme önerisi.
/// `true` → yeniden yükle.
Future<bool> showStaleDataDialog(BuildContext context) async {
  final l10n = context.l10n;
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      icon: const Icon(Icons.sync_problem_outlined),
      title: Text(l10n.commonStaleTitle),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppSizes.dialogWidth),
        child: Text(l10n.errorStaleData),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.commonClose),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(l10n.commonReload),
        ),
      ],
    ),
  );
  return result ?? false;
}

/// Kaydedilmemiş değişiklikler varken çıkış onayı. `true` → değişiklikleri at.
Future<bool> showDiscardChangesDialog(BuildContext context) {
  final l10n = context.l10n;
  return showConfirmDialog(
    context,
    title: l10n.commonUnsavedTitle,
    message: l10n.commonUnsavedBody,
    confirmLabel: l10n.commonDiscard,
    destructive: true,
  );
}
