import 'package:flutter/material.dart';
import 'package:vakif_atlas_admin/core/theme/responsive.dart';
import 'package:vakif_atlas_admin/core/theme/theme_context.dart';
import 'package:vakif_atlas_admin/core/theme/tokens/app_spacing.dart';

/// Yönetim sayfası iskeleti: başlık (sayfanın ilk başlık düğümü), isteğe
/// bağlı açıklama ve eylemler; altında gövde. Kabuğun içinde çizilir.
///
/// Kenar boşluğu pencereye göre değişir (telefonda 16, diğerlerinde 24 px);
/// telefonda açıklama gizlenir (başlık kabuk çubuğunda da yazılıdır) ve
/// başlık bir boy küçülür.
class AdminPage extends StatelessWidget {
  const AdminPage({
    required this.title,
    required this.child,
    this.subtitle,
    this.actions = const [],
    this.toolbar,
    this.dividerBelowHeader = true,
    this.showHeader = true,
    super.key,
  });

  final String title;
  final String? subtitle;
  final List<Widget> actions;

  /// Başlığın altında, gövdenin üstünde (arama, süzgeçler).
  final Widget? toolbar;

  /// `false` → gövde kendi çerçevesini çizer (ör. tablo kartı).
  final bool dividerBelowHeader;

  /// `false` → başlık, eylemler ve araç çubuğu çizilmez; gövde tüm alanı
  /// kullanır (dar pencerede tam sayfa ayrıntı).
  final bool showHeader;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final gutter = context.pageGutter;
    final compact = context.isCompact;
    if (!showHeader) {
      return Material(color: colors.surface, child: child);
    }
    return Material(
      color: colors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(gutter, gutter, gutter, AppSpacing.sm),
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
                        style: compact
                            ? context.textStyles.titleLarge
                            : context.textStyles.headlineMedium,
                      ),
                    ),
                    if (subtitle != null && !compact) ...[
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
              padding: EdgeInsets.fromLTRB(gutter, 0, gutter, AppSpacing.sm),
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
