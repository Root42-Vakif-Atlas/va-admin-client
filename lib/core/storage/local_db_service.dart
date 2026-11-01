import 'dart:async';

import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas_admin/core/error/exceptions.dart';

/// Yapısal veri önbelleği için yerel veritabanı (Hive CE).
///
/// Veritabanı ilk kutu açılışında tembel (lazy) olarak başlatılır; böylece
/// uygulama açılışını geciktirmez.
@lazySingleton
class LocalDbService {
  LocalDbService() : this.withInitializer(() => Hive.initFlutter(_directory));

  /// Testlerde geçici dizinle başlatmak için.
  LocalDbService.withInitializer(this._initialize);

  static const String _directory = 'vakif_atlas_db';

  final Future<void> Function() _initialize;
  Future<void>? _initialization;

  Future<Box<T>> openBox<T>(String name) async {
    try {
      await (_initialization ??= _initialize());
      if (Hive.isBoxOpen(name)) {
        return Hive.box<T>(name);
      }
      return await Hive.openBox<T>(name);
    } on Exception {
      _initialization = null;
      throw const CacheException('local_db.open');
    }
  }

  /// Önceki sürümlerde uygulama içindeki sahte sunucunun (mock API) cihaza
  /// yazdığı, artık kullanılmayan kutular: demo hesaplar (şifre özetleri),
  /// rotalar, anılar, raporlar, XP defteri. Veriler artık yalnızca
  /// backend'dedir.
  static const List<String> legacyBoxes = [
    'mock_auth_users',
    'mock_routes',
    'mock_memories',
    'mock_damage_reports',
    'mock_gamification',
  ];

  /// [legacyBoxes]'ı diskten siler; başarısız olursa sonraki açılışta
  /// yeniden denenir (hata fırlatmaz).
  Future<void> deleteLegacyBoxes() async {
    try {
      await (_initialization ??= _initialize());
      for (final name in legacyBoxes) {
        if (await Hive.boxExists(name)) {
          await Hive.deleteBoxFromDisk(name);
        }
      }
    } on Exception {
      _initialization = null;
    }
  }

  @disposeMethod
  Future<void> close() => Hive.close();
}
