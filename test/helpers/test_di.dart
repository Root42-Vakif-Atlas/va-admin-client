import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mocktail/mocktail.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vakif_atlas_admin/core/a11y/a11y_announcer.dart';
import 'package:vakif_atlas_admin/core/config/app_config.dart';
import 'package:vakif_atlas_admin/core/config/app_environment.dart';
import 'package:vakif_atlas_admin/core/di/injection.dart';
import 'package:vakif_atlas_admin/core/network/http_transport.dart';
import 'package:vakif_atlas_admin/core/network/network_status.dart';

/// Bellek içi `FlutterSecureStorage` (platform kanalı gerektirmez).
class InMemorySecureStorage extends Mock implements FlutterSecureStorage {
  InMemorySecureStorage() {
    when(() => read(key: any(named: 'key'))).thenAnswer(
      (invocation) async => values[invocation.namedArguments[#key] as String],
    );
    when(
      () => write(
        key: any(named: 'key'),
        value: any(named: 'value'),
      ),
    ).thenAnswer((invocation) async {
      values[invocation.namedArguments[#key] as String] =
          invocation.namedArguments[#value] as String;
    });
    when(() => delete(key: any(named: 'key'))).thenAnswer(
      (invocation) async =>
          values.remove(invocation.namedArguments[#key] as String),
    );
    when(deleteAll).thenAnswer((_) async => values.clear());
  }

  final Map<String, String> values = {};
}

/// Elle değiştirilebilen cihaz ağ durumu (varsayılan: çevrimiçi).
final class FakeNetworkStatus implements NetworkStatus {
  final StreamController<bool> _changes = StreamController<bool>.broadcast();

  @override
  bool isOnline = true;

  @override
  Stream<bool> get changes => _changes.stream;

  @override
  Future<bool> refresh() async => isOnline;

  @override
  Future<void> dispose() => _changes.close();
}

/// Testlerde tam DI grafiği: ağ [transport] üzerinden (sahte backend veya
/// gerçek sunucu), platform eklentileri bellek içi, ekran okuyucu
/// duyuruları [announcements] listesine yazılır.
final class TestDependencies {
  TestDependencies._(this.secureStorage, this.announcements);

  final InMemorySecureStorage secureStorage;
  final List<String> announcements;

  static AppConfig config({
    String apiBaseUrl = 'https://mock.vakifatlas.invalid/v1/',
  }) => AppConfig.resolve(
    AppEnvironment.dev,
    overrides: AppConfigOverrides(apiBaseUrl: apiBaseUrl),
  );

  static Future<TestDependencies> setUp({
    required HttpTransport Function(AppConfig config) transport,
    AppConfig? appConfig,
    Map<String, Object> preferences = const {},
  }) async {
    SharedPreferences.setMockInitialValues(preferences);
    PackageInfo.setMockInitialValues(
      appName: 'Vakıf Atlas Yönetim',
      packageName: 'tr.gov.vgm.vakifAtlasAdmin',
      version: '1.0.0',
      buildNumber: '1',
      buildSignature: '',
    );
    final resolved = appConfig ?? config();
    await configureDependencies(resolved);
    final storage = InMemorySecureStorage();
    final announcements = <String>[];
    getIt
      ..allowReassignment = true
      ..registerSingleton<FlutterSecureStorage>(storage)
      ..registerSingleton<NetworkStatus>(FakeNetworkStatus())
      ..registerSingleton<HttpTransport>(transport(resolved))
      ..registerSingleton<A11yAnnouncer>(
        A11yAnnouncer.withSender(
          (_, message, _, _) async => announcements.add(message),
        ),
      );
    return TestDependencies._(storage, announcements);
  }
}
