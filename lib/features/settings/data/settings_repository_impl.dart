import 'package:injectable/injectable.dart';
import 'package:vakif_atlas_admin/core/error/failures.dart';
import 'package:vakif_atlas_admin/core/storage/preferences_service.dart';
import 'package:vakif_atlas_admin/core/utils/either.dart';
import 'package:vakif_atlas_admin/core/utils/typedefs.dart';
import 'package:vakif_atlas_admin/features/settings/domain/entities/app_settings.dart';
import 'package:vakif_atlas_admin/features/settings/domain/repositories/settings_repository.dart';

@LazySingleton(as: SettingsRepository)
class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl(this._preferences);

  final PreferencesService _preferences;

  @override
  AppSettings load() => AppSettings(
    themePreference: _preferences.themePreference,
    highContrast: _preferences.highContrast,
    languageCode: _preferences.languageCode,
    textScaleFactor: _preferences.textScaleFactor,
    reduceMotion: _preferences.reduceMotion,
    navigationExtended: _preferences.navigationExtended,
  );

  @override
  ResultFuture<Unit> save(AppSettings settings) async {
    try {
      await _preferences.setThemePreference(settings.themePreference);
      await _preferences.setHighContrast(enabled: settings.highContrast);
      await _preferences.setLanguageCode(settings.languageCode);
      await _preferences.setTextScaleFactor(settings.textScaleFactor);
      await _preferences.setReduceMotion(enabled: settings.reduceMotion);
      await _preferences.setNavigationExtended(
        extended: settings.navigationExtended,
      );
      return const Right(unit);
    } on Exception {
      return const Left(CacheFailure());
    }
  }
}
