import 'package:vakif_atlas_admin/core/utils/either.dart';
import 'package:vakif_atlas_admin/core/utils/typedefs.dart';
import 'package:vakif_atlas_admin/features/settings/domain/entities/app_settings.dart';

abstract interface class SettingsRepository {
  /// Açılışta yüklenmiş tercihler (senkron okunur).
  AppSettings load();

  ResultFuture<Unit> save(AppSettings settings);
}
