import 'package:flutter/material.dart';
import 'package:vakif_atlas_admin/core/a11y/reduce_motion.dart';
import 'package:vakif_atlas_admin/core/l10n/l10n.dart';
import 'package:vakif_atlas_admin/core/theme/theme_context.dart';
import 'package:vakif_atlas_admin/core/theme/tokens/app_spacing.dart';

enum AppButtonVariant { primary, secondary, ghost, destructive }

/// Tasarım sisteminin buton bileşeni (Design System §6.1).
///
/// - Minimum 48×48 dp dokunma alanı (tema `minimumSize`).
/// - Etiket %200 metin ölçeğinde taşmadan alt satıra kayar.
/// - Ekran okuyucu etiketi görünür etiketle tutarlıdır (WCAG 2.5.3);
///   yükleme sırasında "işlem sürüyor" bilgisi eklenir.
class AppButton extends StatelessWidget {
  const AppButton.primary({
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.semanticsLabel,
    this.expand = false,
    super.key,
  }) : variant = AppButtonVariant.primary;

  const AppButton.secondary({
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.semanticsLabel,
    this.expand = false,
    super.key,
  }) : variant = AppButtonVariant.secondary;

  const AppButton.ghost({
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.semanticsLabel,
    this.expand = false,
    super.key,
  }) : variant = AppButtonVariant.ghost;

  const AppButton.destructive({
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.semanticsLabel,
    this.expand = false,
    super.key,
  }) : variant = AppButtonVariant.destructive;

  final AppButtonVariant variant;
  final String label;

  /// `null` ise buton devre dışıdır.
  final VoidCallback? onPressed;

  final IconData? icon;
  final bool isLoading;

  /// Görünür etiketten farklı bir ekran okuyucu etiketi gerekiyorsa.
  /// Görünür etiketi içermelidir (WCAG 2.5.3 Label in Name).
  final String? semanticsLabel;

  /// `true` ise buton bulunduğu alanın tüm genişliğini kaplar.
  final bool expand;

  bool get _enabled => onPressed != null && !isLoading;

  @override
  Widget build(BuildContext context) {
    final spokenLabel = semanticsLabel ?? label;
    final content = Semantics(
      label: isLoading
          ? context.l10n.buttonLoadingSemantics(spokenLabel)
          : spokenLabel,
      excludeSemantics: true,
      child: _ButtonContent(label: label, icon: icon, isLoading: isLoading),
    );
    final callback = _enabled ? onPressed : null;

    final button = switch (variant) {
      AppButtonVariant.primary => FilledButton(
        onPressed: callback,
        child: content,
      ),
      AppButtonVariant.destructive => FilledButton(
        onPressed: callback,
        style: FilledButton.styleFrom(
          backgroundColor: context.colors.error,
          foregroundColor: context.colors.onError,
        ),
        child: content,
      ),
      AppButtonVariant.secondary => OutlinedButton(
        onPressed: callback,
        child: content,
      ),
      AppButtonVariant.ghost => TextButton(onPressed: callback, child: content),
    };

    if (!expand) {
      return button;
    }
    return SizedBox(width: double.infinity, child: button);
  }
}

class _ButtonContent extends StatelessWidget {
  const _ButtonContent({
    required this.label,
    required this.icon,
    required this.isLoading,
  });

  final String label;
  final IconData? icon;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final leading = isLoading
        ? const _LoadingIndicator()
        : icon == null
        ? null
        : Icon(icon, size: AppSizes.iconInline);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (leading != null) ...[leading, const SizedBox(width: AppSpacing.xs)],
        Flexible(child: Text(label, textAlign: TextAlign.center)),
      ],
    );
  }
}

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    final color = DefaultTextStyle.of(context).style.color;
    if (context.reduceMotion) {
      return Icon(Icons.hourglass_top, size: AppSizes.spinner, color: color);
    }
    return SizedBox.square(
      dimension: AppSizes.spinner,
      child: CircularProgressIndicator(
        strokeWidth: AppSizes.spinnerStroke,
        color: color,
      ),
    );
  }
}
