import 'package:injectable/injectable.dart';
import 'package:vakif_atlas_admin/core/config/app_config.dart';
import 'package:vakif_atlas_admin/core/observability/app_logger.dart';
import 'package:vakif_atlas_admin/core/observability/telemetry_service.dart';
import 'package:vakif_atlas_admin/core/security/device_integrity.dart';
import 'package:vakif_atlas_admin/core/security/platform_integrity_probe.dart';

/// Uygulama açılışında cihaz ve uygulama bütünlüğünü denetler (TRD §10.A).
///
/// Sonuç [DeviceIntegrityPolicy] ile değerlendirilir; şüpheli durum
/// telemetriye bildirilir ve API isteklerine başlık olarak eklenir.
@lazySingleton
class DeviceIntegrityService {
  DeviceIntegrityService(
    AppConfig config,
    AppLogger logger,
    TelemetryService telemetry,
  ) : this.withProbe(
        probe: const NoOpIntegrityProbe(),
        config: config,
        logger: logger,
        telemetry: telemetry,
      );

  DeviceIntegrityService.withProbe({
    required this._probe,
    required this._config,
    required this._logger,
    required this._telemetry,
  });

  /// Sunucuya bildirilen değer (`X-Device-Integrity`).
  static const String compromisedHeaderValue = 'compromised';

  final IntegrityProbe _probe;
  final AppConfig _config;
  final AppLogger _logger;
  final TelemetryService _telemetry;

  DeviceIntegrityReport _report = DeviceIntegrityReport.unchecked;

  DeviceIntegrityReport get report => _report;

  /// Root/jailbreak veya engelleyici bir tehdit varsa istek başlığı değeri.
  String? get requestHeaderValue {
    final compromised =
        _report.verdict != IntegrityVerdict.trusted ||
        _report.threats.contains(IntegrityThreat.rootOrJailbreak);
    return compromised ? compromisedHeaderValue : null;
  }

  Future<DeviceIntegrityReport> initializeSecurityChecks() async {
    Set<IntegrityThreat> threats;
    try {
      threats = await _probe.detect();
    } on Exception catch (error, stackTrace) {
      // Kontrol yapılamaması tek başına tehdit sayılmaz; izlenir.
      _logger.warning('Cihaz bütünlüğü kontrolü yapılamadı');
      await _telemetry.recordError(
        error,
        stackTrace,
        reason: 'device_integrity.check_failed',
      );
      threats = const {};
    }

    final verdict = DeviceIntegrityPolicy.evaluate(
      threats,
      _config.environment,
    );
    _report = DeviceIntegrityReport(threats: threats, verdict: verdict);

    if (threats.isNotEmpty) {
      final names = threats.map((threat) => threat.name).join(', ');
      _logger.warning('Cihaz bütünlüğü tehditleri: $names → ${verdict.name}');
      _telemetry.addBreadcrumb('device_integrity: $names → ${verdict.name}');
    }
    return _report;
  }
}
