import 'package:vakif_atlas_admin/core/security/device_integrity.dart';

/// Masaüstü (macOS, Windows, Linux) bütünlük denetimi.
///
/// Masaüstünde güvenilir root/jailbreak veya kanca tespiti yoktur (ADR 2:
/// mobil özel servisler NoOp'a düşer). Yönetim istemcisinin güvencesi
/// sunucudadır: ayrı personel audience'ı, zorunlu TOTP, kısa oturum ve rol
/// politikaları.
final class NoOpIntegrityProbe implements IntegrityProbe {
  const NoOpIntegrityProbe();

  @override
  Future<Set<IntegrityThreat>> detect() async => const {};
}
