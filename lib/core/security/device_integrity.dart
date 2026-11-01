import 'package:vakif_atlas_admin/core/config/app_environment.dart';

/// Tespit edilebilen cihaz/uygulama bütünlüğü tehditleri.
enum IntegrityThreat {
  /// Root (Android) veya jailbreak (iOS).
  rootOrJailbreak,

  /// Emülatör / simülatör.
  emulator,

  /// Çalışma anında debugger bağlı.
  debuggerAttached,

  /// Frida vb. kanca (hooking) / tersine mühendislik araçları.
  hookingFramework,

  /// Uygulama imzası beklenen imzayla eşleşmiyor (yeniden paketleme).
  tampered,

  /// Android geliştirici seçenekleri açık.
  developerMode,

  /// Cihaz trafiği bir proxy üzerinden yönlendiriliyor.
  proxy,
}

/// Bütünlük kontrolü sonucunda uygulanacak tepki.
enum IntegrityVerdict {
  /// Tehdit yok veya yalnızca telemetriye bildirilir.
  trusted,

  /// Kullanıcı uyarılır; istekler sunucuya işaretlenerek gönderilir.
  warn,

  /// Uygulama güvenli olmayan ortamda çalıştırılmaz.
  block,
}

/// Bütünlük kontrolü raporu.
final class DeviceIntegrityReport {
  const DeviceIntegrityReport({required this.threats, required this.verdict});

  /// Kontrol henüz çalışmadı.
  static const DeviceIntegrityReport unchecked = DeviceIntegrityReport(
    threats: {},
    verdict: IntegrityVerdict.trusted,
  );

  final Set<IntegrityThreat> threats;
  final IntegrityVerdict verdict;

  bool get isClean => threats.isEmpty;
}

/// Tehdit türüne göre tepki politikası (OWASP MASVS-RESILIENCE).
///
/// İstemci tarafı kontroller atlatılabilir olduğundan nihai yetkilendirme
/// kararı sunucudadır; istemci şüpheli durumu `X-Device-Integrity` başlığıyla
/// bildirir.
///
/// | Ortam         | Tehdit                                   | Tepki   |
/// |---------------|------------------------------------------|---------|
/// | dev / staging | hepsi                                    | trusted (yalnızca log) |
/// | prod          | tampered, hookingFramework, debugger     | block   |
/// | prod          | rootOrJailbreak                          | warn    |
/// | prod          | emulator, developerMode, proxy           | trusted (telemetri) |
abstract final class DeviceIntegrityPolicy {
  static const Set<IntegrityThreat> _blocking = {
    IntegrityThreat.tampered,
    IntegrityThreat.hookingFramework,
    IntegrityThreat.debuggerAttached,
  };

  static IntegrityVerdict evaluate(
    Set<IntegrityThreat> threats,
    AppEnvironment environment,
  ) {
    if (environment != AppEnvironment.prod) {
      return IntegrityVerdict.trusted;
    }
    if (threats.any(_blocking.contains)) {
      return IntegrityVerdict.block;
    }
    if (threats.contains(IntegrityThreat.rootOrJailbreak)) {
      return IntegrityVerdict.warn;
    }
    return IntegrityVerdict.trusted;
  }
}

/// Platforma özgü tehdit tespiti.
abstract interface class IntegrityProbe {
  Future<Set<IntegrityThreat>> detect();
}
