import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vakif_atlas_admin/core/error/exceptions.dart';
import 'package:vakif_atlas_admin/core/theme/theme_preference.dart';

/// Hafif anahtar-değer kullanıcı tercihleri (TRD §10.B).
///
/// Değerler uygulama açılışında bir kez yüklenir ve senkron okunur.
/// Yazma hataları [CacheException] olarak fırlatılır. Kişisel veri (e-posta,
/// personel kimliği) burada saklanmaz.
@lazySingleton
class PreferencesService {
  PreferencesService(this._preferences);

  final SharedPreferences _preferences;

  static const String _themeKey = 'settings.theme';
  static const String _highContrastKey = 'settings.high_contrast';
  static const String _languageKey = 'settings.language_code';
  static const String _textScaleKey = 'settings.text_scale';
  static const String _reduceMotionKey = 'settings.reduce_motion';
  static const String _railExtendedKey = 'layout.navigation_extended';

  /// İlk açılışta cihazın açık/koyu ayarı izlenir (platform kuralı).
  static const ThemePreference defaultTheme = ThemePreference.system;
  static const double minTextScale = 1;
  static const double maxTextScale = 2;

  ThemePreference get themePreference =>
      _enumByName(ThemePreference.values, _preferences.getString(_themeKey)) ??
      defaultTheme;

  bool get highContrast => _preferences.getBool(_highContrastKey) ?? false;

  /// `null` → cihaz dili kullanılır.
  String? get languageCode => _preferences.getString(_languageKey);

  /// Uygulama içi metin ölçeği çarpanı (sistem ölçeğiyle çarpılır).
  double get textScaleFactor =>
      (_preferences.getDouble(_textScaleKey) ?? minTextScale).clamp(
        minTextScale,
        maxTextScale,
      );

  /// Cihaz ayarına ek olarak uygulama içinde hareketi azaltma.
  bool get reduceMotion => _preferences.getBool(_reduceMotionKey) ?? false;

  /// Kenar gezinmesi geniş (etiketli) mi; varsayılan geniş.
  bool get navigationExtended => _preferences.getBool(_railExtendedKey) ?? true;

  Future<void> setThemePreference(ThemePreference value) =>
      _guard(() => _preferences.setString(_themeKey, value.name));

  Future<void> setHighContrast({required bool enabled}) =>
      _guard(() => _preferences.setBool(_highContrastKey, enabled));

  Future<void> setLanguageCode(String? languageCode) => _guard(
    () => languageCode == null
        ? _preferences.remove(_languageKey)
        : _preferences.setString(_languageKey, languageCode),
  );

  Future<void> setTextScaleFactor(double value) => _guard(
    () => _preferences.setDouble(
      _textScaleKey,
      value.clamp(minTextScale, maxTextScale),
    ),
  );

  Future<void> setReduceMotion({required bool enabled}) =>
      _guard(() => _preferences.setBool(_reduceMotionKey, enabled));

  Future<void> setNavigationExtended({required bool extended}) =>
      _guard(() => _preferences.setBool(_railExtendedKey, extended));

  static Future<void> _guard(Future<bool> Function() write) async {
    final bool succeeded;
    try {
      succeeded = await write();
    } on Exception {
      throw const CacheException('preferences.write');
    }
    if (!succeeded) {
      throw const CacheException('preferences.write');
    }
  }

  static T? _enumByName<T extends Enum>(List<T> values, String? name) {
    for (final value in values) {
      if (value.name == name) {
        return value;
      }
    }
    return null;
  }
}
