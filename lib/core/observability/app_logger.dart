import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:vakif_atlas_admin/core/config/app_config.dart';
import 'package:vakif_atlas_admin/core/config/app_environment.dart';
import 'package:vakif_atlas_admin/core/observability/pii_scrubber.dart';

/// Ortam bazlı uygulama logger'ı (TRD §11).
///
/// | Ortam     | Çıktı                                   |
/// |-----------|-----------------------------------------|
/// | `dev`     | Renkli, detaylı (`PrettyPrinter`)       |
/// | `staging` | Zaman damgalı sade (`SimplePrinter`)    |
/// | `prod`    | Tamamen kapalı (sızıntı önleme)         |
///
/// Tüm mesajlar ve bağlam verileri [PiiScrubber] ile temizlenir.
@lazySingleton
class AppLogger {
  AppLogger(AppConfig config) : this.withLogger(_create(config.environment));

  AppLogger.withLogger(this._logger);

  final Logger _logger;

  static Logger _create(AppEnvironment environment) {
    return switch (environment) {
      AppEnvironment.dev => Logger(
        filter: DevelopmentFilter(),
        printer: PrettyPrinter(methodCount: 0, errorMethodCount: 8),
        level: Level.trace,
      ),
      AppEnvironment.staging => Logger(
        filter: ProductionFilter(),
        printer: SimplePrinter(printTime: true, colors: false),
        level: Level.info,
      ),
      AppEnvironment.prod => Logger(
        filter: ProductionFilter(),
        printer: SimplePrinter(colors: false),
        level: Level.off,
      ),
    };
  }

  void debug(String message, {Map<String, Object?>? context}) =>
      _logger.d(_format(message, context));

  void info(String message, {Map<String, Object?>? context}) =>
      _logger.i(_format(message, context));

  void warning(String message, {Map<String, Object?>? context}) =>
      _logger.w(_format(message, context));

  void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?>? context,
  }) {
    _logger.e(
      _format(message, context),
      error: error == null ? null : PiiScrubber.scrubText(error.toString()),
      stackTrace: stackTrace,
    );
  }

  static String _format(String message, Map<String, Object?>? context) {
    final safeMessage = PiiScrubber.scrubText(message);
    if (context == null || context.isEmpty) {
      return safeMessage;
    }
    return '$safeMessage ${PiiScrubber.scrub(context)}';
  }
}
