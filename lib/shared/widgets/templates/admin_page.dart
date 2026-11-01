import 'package:flutter/material.dart';
import 'package:vakif_atlas_admin/core/theme/theme_context.dart';
import 'package:vakif_atlas_admin/core/theme/tokens/app_spacing.dart';

/// Yönetim sayfası iskeleti: başlık (sayfanın ilk başlık düğümü), isteğe
/// bağlı açıklama ve eylemler; altında gövde. Kabuğun içinde çizilir.
class AdminPage extends StatelessWidget {
  const AdminPage({
    required this.title,
    required this.child,
    this.subtitle,
    this.actions = const [],
    this.toolbar,
    this.dividerBelowHeader = true,
    super.key,
  });

  final String title;
  final String? subtitle;
  final List<Widget> actions;

  /// Başlığın altında, gövdenin üstünde (arama, süzgeçler).
  final Widget? toolbar;

  /// `false` → gövde kendi çerçevesini çizer (ör. tablo kartı).
  final bool dividerBelowHeader;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Material(
      color: colors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.sm,
            ),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.sm,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Semantics(
                      header: true,
                      child: Text(
                        title,
                        style: context.textStyles.headlineMedium,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        subtitle!,
                        style: context.textStyles.bodyMedium.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
                if (actions.isNotEmpty)
                  Wrap(
                    spacing: AppSpacing.xs,
                    runSpacing: AppSpacing.xs,
                    children: actions,
                  ),
              ],
            ),
          ),
          if (toolbar != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                0,
                AppSpacing.lg,
                AppSpacing.sm,
              ),
              child: toolbar,
            ),
          if (dividerBelowHeader)
            Divider(height: AppSizes.borderThin, color: colors.outlineVariant),
          Expanded(child: child),
        ],
      ),
    );
  }
}
