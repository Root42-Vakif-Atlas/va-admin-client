import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:vakif_atlas_admin/core/error/exceptions.dart';
import 'package:vakif_atlas_admin/core/storage/secure_storage_service.dart';
import 'package:vakif_atlas_admin/features/auth/data/dtos/auth_dtos.dart';

/// Personel oturumunun şifreli yerel deposu (Keychain / Credential Manager /
/// libsecret). Anahtarlar ve profil (e-posta PII içerdiğinden) yalnızca
/// `SecureStorageService` içindedir.
abstract interface class AuthLocalDataSource {
  Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
    required StaffUserDto user,
  });

  /// Oturum her açıldığında / kapandığında artar. Yenileme başlarken okunur;
  /// yenileme sürerken oturum değiştiyse yeni anahtarlar yazılmaz (ADR 51).
  int get sessionEpoch;

  Future<bool> saveRefreshedTokens({
    required String accessToken,
    required String refreshToken,
    required int epoch,
  });

  Future<void> saveUser(StaffUserDto user);

  Future<String?> readRefreshToken();

  Future<String?> readAccessToken();

  Future<StaffUserDto?> readCachedUser();

  Future<void> clearSession();
}

@LazySingleton(as: AuthLocalDataSource)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  AuthLocalDataSourceImpl(this._storage);

  final SecureStorageService _storage;

  static const String _userKey = 'admin.auth.session_user';

  int _epoch = 0;

  @override
  int get sessionEpoch => _epoch;

  @override
  Future<bool> saveRefreshedTokens({
    required String accessToken,
    required String refreshToken,
    required int epoch,
  }) async {
    if (epoch != _epoch) {
      return false;
    }
    await _storage.saveTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
    return true;
  }

  @override
  Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
    required StaffUserDto user,
  }) async {
    _epoch++;
    await _storage.saveTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
    await saveUser(user);
  }

  @override
  Future<void> saveUser(StaffUserDto user) =>
      _storage.write(_userKey, jsonEncode(user.toJson()));

  @override
  Future<String?> readAccessToken() => _storage.getAccessToken();

  @override
  Future<String?> readRefreshToken() => _storage.getRefreshToken();

  @override
  Future<StaffUserDto?> readCachedUser() async {
    final raw = await _storage.read(_userKey);
    if (raw == null) {
      return null;
    }
    try {
      return StaffUserDto.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } on Object {
      await _storage.delete(_userKey);
      throw const CacheException('auth.cached_user.decode');
    }
  }

  @override
  Future<void> clearSession() async {
    _epoch++;
    await _storage.deleteTokens();
    await _storage.delete(_userKey);
  }
}
