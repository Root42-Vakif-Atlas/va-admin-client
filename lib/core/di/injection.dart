import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas_admin/core/config/app_config.dart';
import 'package:vakif_atlas_admin/core/di/injection.config.dart';

/// Uygulama genelindeki servis bulucu.
final GetIt getIt = GetIt.instance;

/// Ortama uygun DI grafiğini kurar (TRD §2).
///
/// [config] grafiğe ilk olarak kaydedilir; ortam anotasyonları
/// (`@dev`, `@Environment('staging')`, `@prod`) `config.environment` ile
/// filtrelenir.
@InjectableInit(
  preferRelativeImports: false,
  ignoreUnregisteredTypes: [AppConfig],
)
Future<void> configureDependencies(AppConfig config) async {
  getIt.registerSingleton<AppConfig>(config);
  await getIt.init(environment: config.environment.name);
}

/// Testler arasında DI grafiğini sıfırlar.
Future<void> resetDependencies() => getIt.reset();
