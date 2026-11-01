import 'package:injectable/injectable.dart';
import 'package:vakif_atlas_admin/core/config/app_environment.dart';

/// Uzak hata ve performans izleme sözleşmesi (TRD §11).
///
/// Gönderilen hiçbir veri PII içermemelidir; çağıranlar mesajları
/// `PiiScrubber` ile temizler.
abstract interface class TelemetryService {
  Future<void> init(AppEnvironment environment);

  Future<void> recordError(
    Object error,
    StackTrace? stackTrace, {
    bool fatal = false,
    String? reason,
  });

  /// Hata raporuna eklenecek kısa olay izi (ekran geçişi, işlem adı).
  void addBreadcrumb(String message);
}

/// Uzak telemetri devre dışıyken kullanılan implementasyon.
///
/// Firebase yapılandırma dosyaları (`google-services.json`,
/// `GoogleService-Info.plist`) projeye eklenene kadar tüm ortamlarda
/// kullanılır. Firebase entegrasyonu, aynı sözleşmeyi uygulayan ve
/// `staging`/`prod` ortamlarına kaydedilen ayrı bir sınıfla eklenir.
@LazySingleton(as: TelemetryService)
class DisabledTelemetryService implements TelemetryService {
  @override
  Future<void> init(AppEnvironment environment) async {}

  @override
  Future<void> recordError(
    Object error,
    StackTrace? stackTrace, {
    bool fatal = false,
    String? reason,
  }) async {}

  @override
  void addBreadcrumb(String message) {}
}
