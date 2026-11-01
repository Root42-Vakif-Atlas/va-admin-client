import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

/// Üçüncü parti servislerin DI kayıtları.
@module
abstract class RegisterModule {
  /// Tercihler açılışta bir kez yüklenir, sonrasında senkron okunur.
  @preResolve
  Future<SharedPreferences> get sharedPreferences =>
      SharedPreferences.getInstance();

  @preResolve
  Future<PackageInfo> get packageInfo => PackageInfo.fromPlatform();

  /// Platformun güvenli anahtar deposu: macOS Keychain (yalnızca bu cihaz),
  /// Windows Credential Manager (DPAPI), Linux libsecret (Secret Service).
  @lazySingleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage(
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
    // Data protection keychain, `keychain-access-groups` yetkisi ve takım
    // kimliğiyle imzalama ister; geçici (ad-hoc) imzalı geliştirme
    // derlemelerinde eski (login) keychain kullanılır. Kurum imzalı dağıtımda
    // `true` yapılıp yetki eklenebilir.
    mOptions: MacOsOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
      usesDataProtectionKeychain: false,
    ),
  );

  @lazySingleton
  Connectivity get connectivity => Connectivity();

  @lazySingleton
  Uuid get uuid => const Uuid();
}
