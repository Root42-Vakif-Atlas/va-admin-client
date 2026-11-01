import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:vakif_atlas_admin/app.dart';
import 'package:vakif_atlas_admin/bootstrap_sequence.dart';
import 'package:vakif_atlas_admin/core/config/app_config.dart';
import 'package:vakif_atlas_admin/core/config/app_environment.dart';
import 'package:vakif_atlas_admin/core/security/device_integrity.dart';

/// Tüm entrypoint'lerin (`main_dev`, `main_staging`, `main_prod`) ortak
/// başlatma fonksiyonu (TRD §12). Yakalanamayan hatalar `runZonedGuarded`,
/// framework hataları `FlutterError.onError` üzerinden aynı işleyiciye
/// yönlendirilir; açılış dizisi başarısız olursa [StartupFailedApp].
Future<void> bootstrap(AppEnvironment environment) async {
  await runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      final IntegrityVerdict verdict;
      try {
        final config = AppConfig.resolve(environment);
        verdict = await BootstrapSequence.standard(config).run();
      } on Object catch (error, stackTrace) {
        FlutterError.reportError(
          FlutterErrorDetails(
            exception: error,
            stack: stackTrace,
            library: 'bootstrap',
          ),
        );
        runApp(const StartupFailedApp());
        return;
      }
      runApp(
        verdict == IntegrityVerdict.block
            ? const SecurityBlockedApp()
            : const VakifAtlasAdminApp(),
      );
    },
    (error, stackTrace) => FlutterError.reportError(
      FlutterErrorDetails(
        exception: error,
        stack: stackTrace,
        library: 'bootstrap',
      ),
    ),
  );
}
