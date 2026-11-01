import 'package:vakif_atlas_admin/core/theme/theme_preference.dart';

/// Uygulama genelindeki görünüm ve erişilebilirlik tercihleri (WCAG 2.2 AA
/// temel düzeyi: tema, yüksek kontrast, dil, metin ölçeği, hareketi azalt).
final class AppSettings {
  const AppSettings({
    this.themePreference = ThemePreference.system,
    this.highContrast = false,
    this.languageCode,
    this.textScaleFactor = 1,
    this.reduceMotion = false,
    this.navigationExtended = true,
  });

  final ThemePreference themePreference;
  final bool highContrast;

  /// `null` → cihaz dili.
  final String? languageCode;

  /// Sistem ölçeğiyle çarpılır (1.0–2.0).
  final double textScaleFactor;
  final bool reduceMotion;

  /// Kenar gezinmesi etiketli (geniş) mi.
  final bool navigationExtended;

  static const Object _unset = Object();

  AppSettings copyWith({
    ThemePreference? themePreference,
    bool? highContrast,
    Object? languageCode = _unset,
    double? textScaleFactor,
    bool? reduceMotion,
    bool? navigationExtended,
  }) => AppSettings(
    themePreference: themePreference ?? this.themePreference,
    highContrast: highContrast ?? this.highContrast,
    languageCode: identical(languageCode, _unset)
        ? this.languageCode
        : languageCode as String?,
    textScaleFactor: textScaleFactor ?? this.textScaleFactor,
    reduceMotion: reduceMotion ?? this.reduceMotion,
    navigationExtended: navigationExtended ?? this.navigationExtended,
  );

  @override
  bool operator ==(Object other) =>
      other is AppSettings &&
      other.themePreference == themePreference &&
      other.highContrast == highContrast &&
      other.languageCode == languageCode &&
      other.textScaleFactor == textScaleFactor &&
      other.reduceMotion == reduceMotion &&
      other.navigationExtended == navigationExtended;

  @override
  int get hashCode => Object.hash(
    themePreference,
    highContrast,
    languageCode,
    textScaleFactor,
    reduceMotion,
    navigationExtended,
  );
}
