import 'package:flutter/material.dart';
import 'package:vakif_atlas_admin/core/theme/tokens/app_spacing.dart';

/// Etkileşimli öğenin dokunma alanını görsel boyutundan bağımsız olarak
/// en az 48×48 dp'ye genişletir (WCAG 2.5.8).
///
/// [onTap] verildiğinde genişletilmiş alanın tamamı dokunmaya yanıt verir ve
/// ekran okuyucuya buton olarak bildirilir.
class AccessibleTouchTarget extends StatelessWidget {
  const AccessibleTouchTarget({
    required this.child,
    this.onTap,
    this.semanticsLabel,
    this.minSize = const Size(AppSizes.minTouchTarget, AppSizes.minTouchTarget),
    super.key,
  });

  final Widget child;
  final VoidCallback? onTap;

  /// Verildiğinde alt öğelerin semantiği bu etiketle değiştirilir.
  final String? semanticsLabel;

  final Size minSize;

  @override
  Widget build(BuildContext context) {
    final target = ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: minSize.width,
        minHeight: minSize.height,
      ),
      child: Center(widthFactor: 1, heightFactor: 1, child: child),
    );

    if (onTap == null) {
      if (semanticsLabel == null) {
        return target;
      }
      return Semantics(
        label: semanticsLabel,
        excludeSemantics: true,
        child: target,
      );
    }

    return Semantics(
      container: true,
      button: true,
      label: semanticsLabel,
      excludeSemantics: semanticsLabel != null,
      onTap: onTap,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: target,
      ),
    );
  }
}
