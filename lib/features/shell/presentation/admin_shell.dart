import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakif_atlas_admin/core/l10n/l10n.dart';
import 'package:vakif_atlas_admin/core/router/routes.dart';
import 'package:vakif_atlas_admin/core/theme/app_theme.dart';
import 'package:vakif_atlas_admin/core/theme/theme_context.dart';
import 'package:vakif_atlas_admin/core/theme/tokens/app_durations.dart';
import 'package:vakif_atlas_admin/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas_admin/core/theme/tokens/app_typography.dart';
import 'package:vakif_atlas_admin/core/a11y/reduce_motion.dart';
import 'package:vakif_atlas_admin/features/auth/domain/entities/staff_role.dart';
import 'package:vakif_atlas_admin/features/auth/domain/entities/staff_user.dart';
import 'package:vakif_atlas_admin/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vakif_atlas_admin/features/auth/presentation/widgets/role_labels.dart';
import 'package:vakif_atlas_admin/features/settings/presentation/cubit/app_settings_cubit.dart';
import 'package:vakif_atlas_admin/shared/widgets/atoms/brand_emblem.dart';
import 'package:vakif_atlas_admin/shared/widgets/molecules/account_avatar.dart';
import 'package:vakif_atlas_admin/shared/widgets/molecules/admin_dialogs.dart';

/// Kenar gezinmesindeki bölüm.
@immutable
class ShellSection {
  const ShellSection({
    required this.route,
    required this.icon,
    required this.label,
    this.permission,
    this.badgeCount = 0,
  });

  final String route;
  final IconData icon;
  final String label;

  /// `null` → her personele açık.
  final StaffPermission? permission;

  /// Bekleyen iş sayısı (pano özetinden); 0 → rozet yok.
  final int badgeCount;
}

/// Yönetim kabuğu: kenar gezinmesi (rol bazlı bölümler, hesap menüsü) +
/// sayfa. Kenar çubuğu her temada Gece Moru zeminle çizilir
/// (`AppTheme.sidebar`); yüksek kontrastta yüksek kontrast koyu tema.
class AdminShell extends StatelessWidget {
  const AdminShell({
    required this.location,
    required this.onNavigate,
    required this.child,
    this.badges = const {},
    super.key,
  });

  /// Geçerli yol (seçili bölüm bundan türetilir).
  final String location;
  final ValueChanged<String> onNavigate;

  /// Bölüm kökü → bekleyen iş sayısı.
  final Map<String, int> badges;
  final Widget child;

  static List<ShellSection> sections(
    AppLocalizations l10n,
    Map<String, int> badges,
  ) => [
    ShellSection(
      route: AppRoutes.dashboard,
      icon: Icons.space_dashboard_outlined,
      label: l10n.navDashboard,
    ),
    ShellSection(
      route: AppRoutes.catalog,
      icon: Icons.account_balance_outlined,
      label: l10n.navCatalog,
      permission: StaffPermission.catalog,
    ),
    ShellSection(
      route: AppRoutes.reports,
      icon: Icons.health_and_safety_outlined,
      label: l10n.navCivilProtection,
      permission: StaffPermission.civilProtection,
      badgeCount: badges[AppRoutes.reports] ?? 0,
    ),
    ShellSection(
      route: AppRoutes.moderation,
      icon: Icons.forum_outlined,
      label: l10n.navModeration,
      permission: StaffPermission.memories,
      badgeCount: badges[AppRoutes.moderation] ?? 0,
    ),
    ShellSection(
      route: AppRoutes.feedback,
      icon: Icons.rate_review_outlined,
      label: l10n.navFeedback,
      permission: StaffPermission.feedback,
      badgeCount: badges[AppRoutes.feedback] ?? 0,
    ),
    ShellSection(
      route: AppRoutes.staff,
      icon: Icons.badge_outlined,
      label: l10n.navStaff,
      permission: StaffPermission.staff,
    ),
    ShellSection(
      route: AppRoutes.audit,
      icon: Icons.history_edu_outlined,
      label: l10n.navAudit,
      permission: StaffPermission.audit,
    ),
  ];

  static bool isSelected(String route, String location) {
    final path = Uri.parse(location).path;
    return route == AppRoutes.dashboard
        ? path == AppRoutes.dashboard
        : path == route || path.startsWith('$route/');
  }

  @override
  Widget build(BuildContext context) {
    final user = context.select<AuthBloc, StaffUser?>(
      (bloc) => switch (bloc.state) {
        AuthAuthenticated(:final user) => user,
        _ => null,
      },
    );
    final extendedPreference = context.select<AppSettingsCubit, bool>(
      (cubit) => cubit.state.navigationExtended,
    );
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Dar pencerede etiketler sığmaz: kenar çubuğu otomatik daralır.
          final extended =
              extendedPreference &&
              constraints.maxWidth >= AppBreakpoints.split;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Sidebar(
                user: user,
                extended: extended,
                canExtend: constraints.maxWidth >= AppBreakpoints.split,
                location: location,
                badges: badges,
                onNavigate: onNavigate,
              ),
              Expanded(child: FocusTraversalGroup(child: child)),
            ],
          );
        },
      ),
    );
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar({
    required this.user,
    required this.extended,
    required this.canExtend,
    required this.location,
    required this.badges,
    required this.onNavigate,
  });

  final StaffUser? user;
  final bool extended;
  final bool canExtend;
  final String location;
  final Map<String, int> badges;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final highContrast = context.colors.isHighContrast;
    final sections = AdminShell.sections(l10n, badges)
        .where(
          (s) => s.permission == null || (user?.can(s.permission!) ?? false),
        )
        .toList();
    return Theme(
      data: highContrast ? AppTheme.highContrastDark() : AppTheme.sidebar(),
      child: Builder(
        builder: (context) {
          final colors = context.colors;
          return AnimatedContainer(
            duration: context.motionDuration(AppDurations.normal),
            width: extended
                ? AppSizes.sidebarExtended
                : AppSizes.sidebarCollapsed,
            color: colors.surface,
            child: Semantics(
              container: true,
              explicitChildNodes: true,
              label: l10n.navLabel,
              child: SafeArea(
                right: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _Brand(extended: extended),
                    Divider(
                      height: AppSizes.borderThin,
                      color: colors.outlineVariant,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.xs,
                        ),
                        children: [
                          for (final section in sections)
                            _NavItem(
                              section: section,
                              extended: extended,
                              selected: AdminShell.isSelected(
                                section.route,
                                location,
                              ),
                              onTap: () => onNavigate(section.route),
                            ),
                        ],
                      ),
                    ),
                    if (canExtend)
                      Align(
                        alignment: extended
                            ? AlignmentDirectional.centerEnd
                            : Alignment.center,
                        child: IconButton(
                          tooltip: extended ? l10n.navCollapse : l10n.navExpand,
                          icon: Icon(
                            extended
                                ? Icons.keyboard_double_arrow_left
                                : Icons.keyboard_double_arrow_right,
                          ),
                          onPressed: () => unawaited(
                            context
                                .read<AppSettingsCubit>()
                                .setNavigationExtended(extended: !extended),
                          ),
                        ),
                      ),
                    Divider(
                      height: AppSizes.borderThin,
                      color: colors.outlineVariant,
                    ),
                    if (user != null)
                      _AccountTile(
                        user: user!,
                        extended: extended,
                        onNavigate: onNavigate,
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Brand extends StatelessWidget {
  const _Brand({required this.extended});

  final bool extended;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md + AppSpacing.xxs,
      ),
      child: Semantics(
        label: l10n.appTitle,
        excludeSemantics: true,
        child: Row(
          mainAxisAlignment: extended
              ? MainAxisAlignment.start
              : MainAxisAlignment.center,
          children: [
            const BrandEmblem(size: AppSizes.iconLg),
            if (extended) ...[
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.appBrandName,
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      softWrap: false,
                      style: context.textStyles.titleMedium,
                    ),
                    Text(
                      l10n.appBrandSubtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textStyles.labelSmall.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.section,
    required this.extended,
    required this.selected,
    required this.onTap,
  });

  final ShellSection section;
  final bool extended;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final count = section.badgeCount;
    final semanticsLabel = count > 0
        ? l10n.navBadgeSemantics(section.label, count)
        : section.label;
    final countText = count > 99 ? '99+' : '$count';
    final icon = Badge(
      isLabelVisible: count > 0 && !extended,
      backgroundColor: colors.primary,
      textColor: colors.onPrimary,
      label: Text(countText),
      child: Icon(
        section.icon,
        size: AppSizes.iconInline,
        color: selected ? colors.onPrimaryContainer : colors.onSurfaceVariant,
      ),
    );
    final content = Container(
      height: AppSizes.minTouchTarget - AppSpacing.xxs,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      decoration: BoxDecoration(
        color: selected ? colors.primaryContainer : null,
        borderRadius: BorderRadius.circular(AppRadius.sm - 2),
        border: selected && colors.isHighContrast
            ? Border.all(color: colors.onSurface)
            : null,
      ),
      child: Row(
        mainAxisAlignment: extended
            ? MainAxisAlignment.start
            : MainAxisAlignment.center,
        children: [
          icon,
          if (extended) ...[
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                section.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textStyles.bodyMedium.copyWith(
                  color: selected
                      ? colors.onPrimaryContainer
                      : colors.onSurfaceVariant,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  fontVariations: [FontVariation('wght', selected ? 600 : 500)],
                ),
              ),
            ),
            if (count > 0)
              Text(
                countText,
                style: context.textStyles.labelMedium.copyWith(
                  color: colors.onSurfaceVariant,
                  fontFeatures: AppTypography.tabularFigures,
                ),
              ),
          ],
        ],
      ),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs / 2),
      child: Tooltip(
        message: extended ? '' : section.label,
        child: Semantics(
          button: true,
          selected: selected,
          label: semanticsLabel,
          excludeSemantics: true,
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              onTap: onTap,
              child: content,
            ),
          ),
        ),
      ),
    );
  }
}

enum _AccountAction { profile, settings, signOut }

class _AccountTile extends StatelessWidget {
  const _AccountTile({
    required this.user,
    required this.extended,
    required this.onNavigate,
  });

  final StaffUser user;
  final bool extended;
  final ValueChanged<String> onNavigate;

  Future<void> _onSelected(BuildContext context, _AccountAction action) async {
    switch (action) {
      case _AccountAction.profile:
        onNavigate(AppRoutes.profile);
      case _AccountAction.settings:
        onNavigate(AppRoutes.settings);
      case _AccountAction.signOut:
        final l10n = context.l10n;
        final bloc = context.read<AuthBloc>();
        final confirmed = await showConfirmDialog(
          context,
          title: l10n.signOutConfirmTitle,
          message: l10n.signOutConfirmBody,
          confirmLabel: l10n.navSignOut,
        );
        if (confirmed) {
          bloc.add(const AuthEvent.logoutRequested());
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final role = primaryRole(user.roles);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xs),
      child: PopupMenuButton<_AccountAction>(
        tooltip: l10n.navAccountMenu(user.displayName),
        position: PopupMenuPosition.over,
        onSelected: (action) => unawaited(_onSelected(context, action)),
        itemBuilder: (context) => [
          PopupMenuItem(
            value: _AccountAction.profile,
            child: ListTile(
              leading: const Icon(Icons.person_outline),
              title: Text(l10n.navProfile),
            ),
          ),
          PopupMenuItem(
            value: _AccountAction.settings,
            child: ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: Text(l10n.navSettings),
            ),
          ),
          const PopupMenuDivider(),
          PopupMenuItem(
            value: _AccountAction.signOut,
            child: ListTile(
              leading: const Icon(Icons.logout),
              title: Text(l10n.navSignOut),
            ),
          ),
        ],
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xs),
          child: Row(
            mainAxisAlignment: extended
                ? MainAxisAlignment.start
                : MainAxisAlignment.center,
            children: [
              AccountAvatar(
                displayName: user.displayName,
                size: AppSizes.iconLg + AppSpacing.xxs,
              ),
              if (extended) ...[
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.textStyles.labelLarge,
                      ),
                      if (role != null)
                        Text(
                          role.label(l10n),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.textStyles.bodySmall,
                        ),
                    ],
                  ),
                ),
                Icon(
                  Icons.unfold_more,
                  size: AppSizes.iconInline,
                  color: context.colors.onSurfaceVariant,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
