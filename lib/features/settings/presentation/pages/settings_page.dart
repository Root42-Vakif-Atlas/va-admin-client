import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakif_atlas_admin/core/keyboard/app_shortcuts.dart';
import 'package:vakif_atlas_admin/core/l10n/l10n.dart';
import 'package:vakif_atlas_admin/core/theme/extensions/app_color_scheme.dart';
import 'package:vakif_atlas_admin/core/theme/theme_context.dart';
import 'package:vakif_atlas_admin/core/theme/theme_preference.dart';
import 'package:vakif_atlas_admin/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas_admin/features/settings/domain/entities/app_settings.dart';
import 'package:vakif_atlas_admin/features/settings/presentation/cubit/app_settings_cubit.dart';
import 'package:vakif_atlas_admin/shared/widgets/atoms/brand_emblem.dart';
import 'package:vakif_atlas_admin/shared/widgets/molecules/detail_section.dart';
import 'package:vakif_atlas_admin/shared/widgets/templates/admin_page.dart';

/// Görünüm, dil ve temel erişilebilirlik tercihleri (anında uygulanır) +
/// klavye kısayolları ve sürüm.
class SettingsPage extends StatelessWidget {
  const SettingsPage({required this.appVersion, super.key});

  final String appVersion;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final settings = context.watch<AppSettingsCubit>().state;
    final cubit = context.read<AppSettingsCubit>();
    // Cihazın kendi ayarı: kökteki MediaQuery uygulama ayarıyla OR'landığı
    // için değer oradan okunmaz (aksi halde anahtar açılınca kendini
    // kilitliyordu); yalnızca bağımlılık kurulur ki cihaz ayarı değişince
    // sayfa yeniden çizilsin.
    MediaQuery.disableAnimationsOf(context);
    final deviceReduceMotion = MediaQueryData.fromView(View.of(context))
        .disableAnimations;
    return AdminPage(
      title: l10n.settingsTitle,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Align(
          alignment: AlignmentDirectional.topStart,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: AppSizes.formMaxWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DetailSection(
                  title: l10n.settingsSectionAppearance,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SegmentedButton<ThemePreference>(
                        segments: [
                          ButtonSegment(
                            value: ThemePreference.system,
                            label: Text(l10n.settingsThemeSystem),
                          ),
                          ButtonSegment(
                            value: ThemePreference.light,
                            label: Text(l10n.settingsThemeLight),
                          ),
                          ButtonSegment(
                            value: ThemePreference.dark,
                            label: Text(l10n.settingsThemeDark),
                          ),
                        ],
                        selected: {settings.themePreference},
                        onSelectionChanged: (selection) => unawaited(
                          cubit.setThemePreference(selection.first),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        value: settings.highContrast,
                        title: Text(l10n.settingsHighContrast),
                        subtitle: Text(l10n.settingsHighContrastHelp),
                        onChanged: (enabled) =>
                            unawaited(cubit.setHighContrast(enabled: enabled)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                DetailSection(
                  title: l10n.settingsSectionLanguage,
                  child: SegmentedButton<String?>(
                    segments: [
                      ButtonSegment(
                        value: null,
                        label: Text(l10n.settingsLanguageSystem),
                      ),
                      const ButtonSegment(value: 'tr', label: Text('Türkçe')),
                      const ButtonSegment(value: 'en', label: Text('English')),
                    ],
                    selected: {settings.languageCode},
                    onSelectionChanged: (selection) =>
                        unawaited(cubit.setLanguageCode(selection.first)),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                DetailSection(
                  title: l10n.settingsSectionAccessibility,
                  child: _AccessibilitySettings(
                    settings: settings,
                    deviceReduceMotion: deviceReduceMotion,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                DetailSection(
                  title: l10n.settingsShortcuts,
                  child: KeyValueList(
                    entries: [
                      (l10n.settingsShortcutSearch, AppShortcuts.label('F')),
                      (l10n.settingsShortcutNew, AppShortcuts.label('N')),
                      (l10n.settingsShortcutSave, AppShortcuts.label('S')),
                      (
                        l10n.settingsShortcutRefresh,
                        '${AppShortcuts.label('R')} · F5',
                      ),
                      (l10n.settingsShortcutClose, 'Esc'),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                DetailSection(
                  title: l10n.settingsSectionAbout,
                  child: MergeSemantics(
                    child: Row(
                      children: [
                        DecoratedBox(
                          decoration: BoxDecoration(
                            color: AppColorScheme.sidebar.surface,
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                          // Marka zemini (Gece Moru) üzerinde açık kemer +
                          // bronz eşik: uygulama simgesiyle aynı.
                          child: Padding(
                            padding: const EdgeInsets.all(AppSpacing.sm),
                            child: BrandEmblem(
                              size: AppSizes.iconXl,
                              frameColor: AppColorScheme.sidebar.primary,
                              accentColor: AppColorScheme.sidebar.brandAccent,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.appTitle,
                                style: context.textStyles.titleMedium,
                              ),
                              Text(
                                l10n.settingsVersion(appVersion),
                                style: context.textStyles.bodySmall,
                              ),
                              const SizedBox(height: AppSpacing.xxs),
                              Text(
                                l10n.settingsAboutBody,
                                style: context.textStyles.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AccessibilitySettings extends StatelessWidget {
  const _AccessibilitySettings({
    required this.settings,
    required this.deviceReduceMotion,
  });

  final AppSettings settings;
  final bool deviceReduceMotion;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<AppSettingsCubit>();
    final percent = (settings.textScaleFactor * 100).round();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.settingsTextScale, style: context.textStyles.labelLarge),
        Row(
          children: [
            Expanded(
              child: Slider(
                value: settings.textScaleFactor,
                min: 1,
                max: 2,
                divisions: 4,
                label: l10n.settingsTextScaleValue(percent),
                semanticFormatterCallback: (value) =>
                    l10n.settingsTextScaleValue((value * 100).round()),
                onChanged: (value) =>
                    unawaited(cubit.setTextScaleFactor(value)),
              ),
            ),
            SizedBox(
              width: 56,
              child: Text(
                l10n.settingsTextScaleValue(percent),
                textAlign: TextAlign.end,
                style: context.textStyles.labelLarge,
              ),
            ),
          ],
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          // Cihazda açıksa kilitli açık (cihaz ayarı OR uygulama ayarı).
          value: settings.reduceMotion || deviceReduceMotion,
          title: Text(l10n.settingsReduceMotion),
          subtitle: Text(
            deviceReduceMotion
                ? l10n.settingsReduceMotionLocked
                : l10n.settingsReduceMotionHelp,
          ),
          onChanged: deviceReduceMotion
              ? null
              : (enabled) => unawaited(cubit.setReduceMotion(enabled: enabled)),
        ),
      ],
    );
  }
}
