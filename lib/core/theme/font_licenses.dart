import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Paketlenmiş fontların SIL Open Font License metinlerini uygulamanın
/// lisans sayfasına (`showLicensePage`) ekler.
abstract final class FontLicenses {
  static const Map<String, String> _licenseAssets = {
    'Inter': 'assets/fonts/inter/OFL.txt',
  };

  static void register() {
    LicenseRegistry.addLicense(() async* {
      for (final entry in _licenseAssets.entries) {
        final text = await rootBundle.loadString(entry.value);
        yield LicenseEntryWithLineBreaks([entry.key], text);
      }
    });
  }
}
