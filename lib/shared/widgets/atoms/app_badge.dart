import 'package:flutter/material.dart';
import 'package:vakif_atlas_admin/core/l10n/l10n.dart';
import 'package:vakif_atlas_admin/core/theme/theme_context.dart';
import 'package:vakif_atlas_admin/core/theme/tokens/app_spacing.dart';

/// Rozet, seviye ve sayı göstergesi.
///
/// Görünen kısa metin yerine ekran okuyucuya [semanticsLabel] okunur
/// (ör. "3" yerine "3 yeni bildirim").
class AppBadge extends StatelessWidget {
  const AppBadge({
    required String this.label,
    required this.semanticsLabel,
    super.key,
  }) : count = null,
       maxCount = 0;

  /// [count], [maxCount] değerini aşarsa "99+" biçiminde gösterilir.
  const AppBadge.count({
    required int this.count,
    required this.semanticsLabel,
    this.maxCount = 99,
    super.key,
  }) : label = null;

  final String? label;
  final int? count;
  final int maxCount;
  final String semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final value = count;
    final text = value == null
        ? label!
        : value > maxCount
        ? context.l10n.badgeOverflow(maxCount)
        : '$value';

    return Semantics(
      label: semanticsLabel,
      excludeSemantics: true,
      child: Container(
        constraints: const BoxConstraints(
          minWidth: AppSizes.badgeMinSize,
          minHeight: AppSizes.badgeMinSize,
        ),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: colors.primary,
          borderRadius: BorderRadius.circular(AppRadius.xs),
        ),
        child: Text(
          text,
          style: context.textStyles.labelMedium.copyWith(
            color: colors.onPrimary,
          ),
        ),
      ),
    );
  }
}
