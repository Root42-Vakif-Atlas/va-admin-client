import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakif_atlas_admin/core/config/app_config.dart';
import 'package:vakif_atlas_admin/core/di/injection.dart' as di;
import 'package:vakif_atlas_admin/core/observability/app_bloc_observer.dart';
import 'package:vakif_atlas_admin/core/observability/app_logger.dart';
import 'package:vakif_atlas_admin/core/observability/telemetry_service.dart';
import 'package:vakif_atlas_admin/core/security/device_integrity.dart';
import 'package:vakif_atlas_admin/core/security/device_integrity_service.dart';
import 'package:vakif_atlas_admin/core/theme/font_licenses.dart';
import 'package:vakif_atlas_admin/features/auth/presentation/bloc/auth_bloc.dart';

/// Başlatma sırası (`runApp` hariç; TRD §12):
///
/// 1. `WidgetsFlutterBinding.ensureInitialized()` — `bootstrap()` içinde
/// 2. [configureDependencies] — ortama uygun DI grafiği
/// 3. [installObservers] — `Bloc.observer` + global hata işleyicisi + font
///    lisansları
/// 4. [runSecurityChecks] — cihaz bütünlüğü (masaüstünde NoOp)
/// 5. [initTelemetry] — hata ve performans izleme
///
/// Ardından kayıtlı personel oturumu geri yüklenir ([restoreSession]).
/// Adımlar fonksiyon olarak verildiğinden sıra testlerle doğrulanabilir.
class BootstrapSequence {
  const BootstrapSequence({
    required this.configureDependencies,
    required this.installObservers,
    required this.runSecurityChecks,
    required this.initTelemetry,
    required this.restoreSession,
  });

  factory BootstrapSequence.standard(AppConfig config) {
    return BootstrapSequence(
      configureDependencies: () => di.configureDependencies(config),
      installObservers: () {
        Bloc.observer = di.getIt<AppBlocObserver>();
        FlutterError.onError = _globalErrorHandler(
          logger: di.getIt<AppLogger>(),
          telemetry: di.getIt<TelemetryService>(),
        );
        FontLicenses.register();
      },
      runSecurityChecks: () =>
          di.getIt<DeviceIntegrityService>().initializeSecurityChecks(),
      initTelemetry: () =>
          di.getIt<TelemetryService>().init(config.environment),
      restoreSession: () => di.getIt<AuthBloc>().add(const AuthEvent.started()),
    );
  }

  final Future<void> Function() configureDependencies;
  final void Function() installObservers;
  final Future<DeviceIntegrityReport> Function() runSecurityChecks;
  final Future<void> Function() initTelemetry;
  final void Function() restoreSession;

  /// Sırayı çalıştırır ve cihaz bütünlüğü kararını döndürür. Engelleyici
  /// tehditte oturum geri yüklenmez.
  Future<IntegrityVerdict> run() async {
    await configureDependencies();
    installObservers();
    final integrity = await runSecurityChecks();
    await initTelemetry();
    if (integrity.verdict != IntegrityVerdict.block) {
      restoreSession();
    }
    return integrity.verdict;
  }

  static FlutterExceptionHandler _globalErrorHandler({
    required AppLogger logger,
    required TelemetryService telemetry,
  }) {
    return (details) {
      logger.error(
        details.exceptionAsString(),
        error: details.exception,
        stackTrace: details.stack,
      );
      telemetry.recordError(
        details.exception,
        details.stack,
        fatal: !details.silent,
        reason: details.library,
      );
      if (kDebugMode) {
        FlutterError.presentError(details);
      }
    };
  }
}
