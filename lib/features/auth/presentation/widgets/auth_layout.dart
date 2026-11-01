import 'package:flutter/material.dart';
import 'package:vakif_atlas_admin/core/l10n/l10n.dart';
import 'package:vakif_atlas_admin/core/theme/app_theme.dart';
import 'package:vakif_atlas_admin/core/theme/theme_context.dart';
import 'package:vakif_atlas_admin/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas_admin/shared/widgets/atoms/brand_emblem.dart';

/// Giriş ekranlarının düzeni: geniş pencerede solda marka paneli (Gece Moru
/// zemin, kenar çubuğuyla aynı tema), sağda form; dar pencerede yalnızca
/// form.
class AuthLayout extends StatelessWidget {
  const AuthLayout({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      backgroundColor: colors.surface,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= AppBreakpoints.split;
          final form = Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: AppSizes.dialogWidth,
                ),
                child: FocusTraversalGroup(child: child),
              ),
            ),
          );
          if (!wide) {
            return SafeArea(child: form);
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Expanded(flex: 5, child: _BrandPanel()),
              Expanded(flex: 6, child: SafeArea(child: form)),
            ],
          );
        },
      ),
    );
  }
}

class _BrandPanel extends StatelessWidget {
  const _BrandPanel();

  @override
  Widget build(BuildContext context) {
    final highContrast = context.colors.isHighContrast;
    final theme = highContrast
        ? AppTheme.highContrastDark()
        : AppTheme.sidebar();
    final l10n = context.l10n;
    return Theme(
      data: theme,
      child: Builder(
        builder: (context) {
          final colors = context.colors;
          return ColoredBox(
            color: colors.surface,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const BrandEmblem(size: AppSizes.iconXl),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    l10n.appBrandName,
                    style: context.textStyles.headlineLarge,
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    l10n.appBrandSubtitle,
                    style: context.textStyles.titleMedium.copyWith(
                      color: colors.onSurfaceVariant,
                      fontWeight: FontWeight.w400,
                      fontVariations: const [FontVariation('wght', 400)],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Form kartının başlığı (sayfanın ilk başlık düğümü).
class AuthHeading extends StatelessWidget {
  const AuthHeading({required this.title, this.body, super.key});

  final String title;
  final String? body;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          child: Text(title, style: context.textStyles.headlineMedium),
        ),
        if (body != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            body!,
            style: context.textStyles.bodyMedium.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}
