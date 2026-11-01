import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas_admin/core/observability/app_logger.dart';
import 'package:vakif_atlas_admin/core/observability/telemetry_service.dart';

/// Tüm BLoC/Cubit durum geçişlerini ve hatalarını merkezi olarak izler.
///
/// Durumlar kullanıcı verisi (e-posta, konum) içerebileceğinden içerikleri
/// değil yalnızca tip adları loglanır.
@lazySingleton
class AppBlocObserver extends BlocObserver {
  AppBlocObserver(this._logger, this._telemetry);

  final AppLogger _logger;
  final TelemetryService _telemetry;

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    final transition =
        '${bloc.runtimeType}: ${change.currentState.runtimeType} → '
        '${change.nextState.runtimeType}';
    _logger.debug(transition);
    _telemetry.addBreadcrumb(transition);
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    _logger.error(
      '${bloc.runtimeType} hata verdi',
      error: error,
      stackTrace: stackTrace,
    );
    _telemetry.recordError(
      error,
      stackTrace,
      reason: '${bloc.runtimeType}.onError',
    );
    super.onError(bloc, error, stackTrace);
  }
}
