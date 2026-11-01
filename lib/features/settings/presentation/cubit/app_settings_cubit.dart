import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas_admin/core/theme/theme_preference.dart';
import 'package:vakif_atlas_admin/features/settings/domain/entities/app_settings.dart';
import 'package:vakif_atlas_admin/features/settings/domain/repositories/settings_repository.dart';

/// Tüm tercihlerin tek durumu; değişiklik anında uygulanır, ardından
/// kaydedilir (kayıt hatası arayüzü engellemez).
@lazySingleton
class AppSettingsCubit extends Cubit<AppSettings> {
  AppSettingsCubit(this._repository) : super(_repository.load());

  final SettingsRepository _repository;

  Future<void> _update(AppSettings settings) async {
    if (settings == state) {
      return;
    }
    emit(settings);
    await _repository.save(settings);
  }

  Future<void> setThemePreference(ThemePreference value) =>
      _update(state.copyWith(themePreference: value));

  Future<void> setHighContrast({required bool enabled}) =>
      _update(state.copyWith(highContrast: enabled));

  Future<void> setLanguageCode(String? languageCode) =>
      _update(state.copyWith(languageCode: languageCode));

  Future<void> setTextScaleFactor(double value) =>
      _update(state.copyWith(textScaleFactor: value.clamp(1, 2).toDouble()));

  Future<void> setReduceMotion({required bool enabled}) =>
      _update(state.copyWith(reduceMotion: enabled));

  Future<void> setNavigationExtended({required bool extended}) =>
      _update(state.copyWith(navigationExtended: extended));
}

extension AppSettingsPresentation on AppSettings {
  ThemeMode get themeMode => switch (themePreference) {
    ThemePreference.system => ThemeMode.system,
    ThemePreference.light => ThemeMode.light,
    ThemePreference.dark => ThemeMode.dark,
  };

  Locale? get locale => languageCode == null ? null : Locale(languageCode!);
}
