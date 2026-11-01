import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:vakif_atlas_admin/core/error/exceptions.dart';
import 'package:vakif_atlas_admin/core/storage/local_db_service.dart';

/// Süre sınırlı (TTL) JSON önbelleği (TRD §10.B).
///
/// Harita pinleri, filtre kategorileri ve rotalar gibi yapısal veriler
/// burada saklanır. Süresi dolan kayıt okunurken silinir ve `null` döner.
@lazySingleton
class CacheStore {
  CacheStore(LocalDbService database) : this.withClock(database, DateTime.now);

  CacheStore.withClock(this._database, this._now);

  static const String boxName = 'cache_entries';
  static const String _valueField = 'value';
  static const String _expiresAtField = 'expiresAt';

  final LocalDbService _database;
  final DateTime Function() _now;

  /// [value] JSON'a dönüştürülebilir olmalıdır (Map, List, String, num, bool).
  Future<void> put(String key, Object? value, {required Duration ttl}) async {
    final box = await _database.openBox<String>(boxName);
    final envelope = jsonEncode({
      _valueField: value,
      _expiresAtField: _now().add(ttl).millisecondsSinceEpoch,
    });
    try {
      await box.put(key, envelope);
    } on Exception {
      throw const CacheException('cache.write');
    }
  }

  /// Geçerli kayıt yoksa veya süresi dolduysa `null` döner.
  Future<Object?> get(String key) async {
    final box = await _database.openBox<String>(boxName);
    final raw = box.get(key);
    if (raw == null) {
      return null;
    }

    final Object? decoded;
    try {
      decoded = jsonDecode(raw);
    } on FormatException {
      await box.delete(key);
      throw const CacheException('cache.decode');
    }

    if (decoded is! Map<String, dynamic> || decoded[_expiresAtField] is! int) {
      await box.delete(key);
      throw const CacheException('cache.decode');
    }

    final expiresAt = DateTime.fromMillisecondsSinceEpoch(
      decoded[_expiresAtField] as int,
    );
    if (!_now().isBefore(expiresAt)) {
      await box.delete(key);
      return null;
    }
    return decoded[_valueField];
  }

  Future<void> remove(String key) async {
    final box = await _database.openBox<String>(boxName);
    await box.delete(key);
  }

  Future<void> clear() async {
    final box = await _database.openBox<String>(boxName);
    await box.clear();
  }
}
