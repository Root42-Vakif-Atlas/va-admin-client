// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:package_info_plus/package_info_plus.dart' as _i655;
import 'package:shared_preferences/shared_preferences.dart' as _i460;
import 'package:uuid/uuid.dart' as _i706;
import 'package:vakif_atlas_admin/core/a11y/a11y_announcer.dart' as _i465;
import 'package:vakif_atlas_admin/core/a11y/haptic_feedback_service.dart'
    as _i158;
import 'package:vakif_atlas_admin/core/config/app_config.dart' as _i874;
import 'package:vakif_atlas_admin/core/di/network_module.dart' as _i63;
import 'package:vakif_atlas_admin/core/di/register_module.dart' as _i580;
import 'package:vakif_atlas_admin/core/network/connectivity_service.dart'
    as _i1068;
import 'package:vakif_atlas_admin/core/network/dio_factory.dart' as _i844;
import 'package:vakif_atlas_admin/core/network/http_transport.dart' as _i958;
import 'package:vakif_atlas_admin/core/network/interceptors/correlation_interceptor.dart'
    as _i65;
import 'package:vakif_atlas_admin/core/network/network_status.dart' as _i464;
import 'package:vakif_atlas_admin/core/network/session_events.dart' as _i325;
import 'package:vakif_atlas_admin/core/observability/app_bloc_observer.dart'
    as _i752;
import 'package:vakif_atlas_admin/core/observability/app_logger.dart' as _i18;
import 'package:vakif_atlas_admin/core/observability/telemetry_service.dart'
    as _i632;
import 'package:vakif_atlas_admin/core/router/app_router.dart' as _i321;
import 'package:vakif_atlas_admin/core/router/unsaved_changes.dart' as _i796;
import 'package:vakif_atlas_admin/core/security/device_integrity_service.dart'
    as _i846;
import 'package:vakif_atlas_admin/core/storage/cache_store.dart' as _i14;
import 'package:vakif_atlas_admin/core/storage/local_db_service.dart' as _i312;
import 'package:vakif_atlas_admin/core/storage/preferences_service.dart'
    as _i156;
import 'package:vakif_atlas_admin/core/storage/secure_storage_service.dart'
    as _i654;
import 'package:vakif_atlas_admin/features/audit/data/audit_repository_impl.dart'
    as _i152;
import 'package:vakif_atlas_admin/features/audit/domain/audit_entry.dart'
    as _i155;
import 'package:vakif_atlas_admin/features/audit/domain/audit_repository.dart'
    as _i642;
import 'package:vakif_atlas_admin/features/audit/presentation/audit_cubit.dart'
    as _i466;
import 'package:vakif_atlas_admin/features/auth/data/repositories/auth_repository_impl.dart'
    as _i903;
import 'package:vakif_atlas_admin/features/auth/data/sources/auth_local_data_source.dart'
    as _i736;
import 'package:vakif_atlas_admin/features/auth/data/sources/auth_remote_data_source.dart'
    as _i187;
import 'package:vakif_atlas_admin/features/auth/domain/repositories/auth_repository.dart'
    as _i639;
import 'package:vakif_atlas_admin/features/auth/presentation/bloc/auth_bloc.dart'
    as _i766;
import 'package:vakif_atlas_admin/features/auth/presentation/cubit/password_reset_cubit.dart'
    as _i346;
import 'package:vakif_atlas_admin/features/auth/presentation/cubit/staff_sign_in_cubit.dart'
    as _i901;
import 'package:vakif_atlas_admin/features/catalog/data/catalog_import_repository_impl.dart'
    as _i510;
import 'package:vakif_atlas_admin/features/catalog/data/catalog_repository_impl.dart'
    as _i362;
import 'package:vakif_atlas_admin/features/catalog/data/image_preparer_impl.dart'
    as _i1043;
import 'package:vakif_atlas_admin/features/catalog/data/seed_folder_reader_impl.dart'
    as _i1;
import 'package:vakif_atlas_admin/features/catalog/domain/catalog_import.dart'
    as _i449;
import 'package:vakif_atlas_admin/features/catalog/domain/catalog_repository.dart'
    as _i802;
import 'package:vakif_atlas_admin/features/catalog/presentation/catalog_cubits.dart'
    as _i628;
import 'package:vakif_atlas_admin/features/catalog/presentation/catalog_import_cubit.dart'
    as _i492;
import 'package:vakif_atlas_admin/features/civil_protection/data/reports_repository_impl.dart'
    as _i273;
import 'package:vakif_atlas_admin/features/civil_protection/domain/entities/damage_report.dart'
    as _i698;
import 'package:vakif_atlas_admin/features/civil_protection/domain/repositories/reports_repository.dart'
    as _i814;
import 'package:vakif_atlas_admin/features/civil_protection/presentation/cubit/reports_cubits.dart'
    as _i387;
import 'package:vakif_atlas_admin/features/dashboard/data/dashboard_repository_impl.dart'
    as _i413;
import 'package:vakif_atlas_admin/features/dashboard/domain/repositories/dashboard_repository.dart'
    as _i821;
import 'package:vakif_atlas_admin/features/dashboard/presentation/cubit/dashboard_cubit.dart'
    as _i33;
import 'package:vakif_atlas_admin/features/feedback/data/feedback_repository_impl.dart'
    as _i596;
import 'package:vakif_atlas_admin/features/feedback/domain/feedback_entry.dart'
    as _i806;
import 'package:vakif_atlas_admin/features/feedback/domain/feedback_repository.dart'
    as _i504;
import 'package:vakif_atlas_admin/features/feedback/presentation/feedback_cubits.dart'
    as _i575;
import 'package:vakif_atlas_admin/features/moderation/data/moderation_repository_impl.dart'
    as _i964;
import 'package:vakif_atlas_admin/features/moderation/domain/entities/moderated_memory.dart'
    as _i613;
import 'package:vakif_atlas_admin/features/moderation/domain/repositories/moderation_repository.dart'
    as _i235;
import 'package:vakif_atlas_admin/features/moderation/presentation/cubit/moderation_cubits.dart'
    as _i532;
import 'package:vakif_atlas_admin/features/profile/presentation/profile_cubit.dart'
    as _i550;
import 'package:vakif_atlas_admin/features/settings/data/settings_repository_impl.dart'
    as _i293;
import 'package:vakif_atlas_admin/features/settings/domain/repositories/settings_repository.dart'
    as _i1049;
import 'package:vakif_atlas_admin/features/settings/presentation/cubit/app_settings_cubit.dart'
    as _i536;
import 'package:vakif_atlas_admin/features/staff/data/staff_repository_impl.dart'
    as _i744;
import 'package:vakif_atlas_admin/features/staff/domain/staff_repository.dart'
    as _i234;
import 'package:vakif_atlas_admin/features/staff/presentation/staff_cubits.dart'
    as _i332;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    final networkModule = _$NetworkModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.sharedPreferences,
      preResolve: true,
    );
    await gh.factoryAsync<_i655.PackageInfo>(
      () => registerModule.packageInfo,
      preResolve: true,
    );
    gh.lazySingleton<_i465.A11yAnnouncer>(() => _i465.A11yAnnouncer());
    gh.lazySingleton<_i158.HapticFeedbackService>(
      () => _i158.HapticFeedbackService(),
    );
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => registerModule.secureStorage,
    );
    gh.lazySingleton<_i895.Connectivity>(() => registerModule.connectivity);
    gh.lazySingleton<_i706.Uuid>(() => registerModule.uuid);
    gh.lazySingleton<_i325.SessionEvents>(
      () => _i325.SessionEvents(),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i796.UnsavedChanges>(
      () => _i796.UnsavedChanges(),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i312.LocalDbService>(
      () => _i312.LocalDbService(),
      dispose: (i) => i.close(),
    );
    gh.lazySingleton<_i802.ImagePreparer>(() => _i1043.ImagePreparerImpl());
    gh.lazySingleton<_i14.CacheStore>(
      () => _i14.CacheStore(gh<_i312.LocalDbService>()),
    );
    gh.lazySingleton<_i654.SecureStorageService>(
      () => _i654.SecureStorageService(gh<_i558.FlutterSecureStorage>()),
    );
    gh.lazySingleton<_i449.SeedFolderReader>(() => _i1.SeedFolderReaderImpl());
    gh.lazySingleton<_i632.TelemetryService>(
      () => _i632.DisabledTelemetryService(),
    );
    gh.lazySingleton<_i156.PreferencesService>(
      () => _i156.PreferencesService(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i1049.SettingsRepository>(
      () => _i293.SettingsRepositoryImpl(gh<_i156.PreferencesService>()),
    );
    gh.lazySingleton<_i958.HttpTransport>(
      () => _i958.PlatformHttpTransport(gh<_i874.AppConfig>()),
    );
    gh.lazySingleton<_i844.DioFactory>(
      () => _i844.DioFactory(gh<_i874.AppConfig>(), gh<_i958.HttpTransport>()),
    );
    gh.lazySingleton<_i18.AppLogger>(
      () => _i18.AppLogger(gh<_i874.AppConfig>()),
    );
    gh.lazySingleton<_i736.AuthLocalDataSource>(
      () => _i736.AuthLocalDataSourceImpl(gh<_i654.SecureStorageService>()),
    );
    gh.lazySingleton<_i361.Dio>(
      () => networkModule.probeDio(gh<_i844.DioFactory>()),
      instanceName: 'probeDio',
    );
    gh.lazySingleton<_i464.NetworkStatus>(
      () => _i464.DeviceNetworkStatus(gh<_i895.Connectivity>()),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i361.Dio>(
      () => networkModule.storageDio(
        gh<_i844.DioFactory>(),
        gh<_i18.AppLogger>(),
        gh<_i632.TelemetryService>(),
        gh<_i464.NetworkStatus>(),
      ),
      instanceName: 'storageDio',
    );
    gh.lazySingleton<_i536.AppSettingsCubit>(
      () => _i536.AppSettingsCubit(gh<_i1049.SettingsRepository>()),
    );
    gh.lazySingleton<_i846.DeviceIntegrityService>(
      () => _i846.DeviceIntegrityService(
        gh<_i874.AppConfig>(),
        gh<_i18.AppLogger>(),
        gh<_i632.TelemetryService>(),
      ),
    );
    gh.lazySingleton<_i752.AppBlocObserver>(
      () => _i752.AppBlocObserver(
        gh<_i18.AppLogger>(),
        gh<_i632.TelemetryService>(),
      ),
    );
    gh.lazySingleton<_i1068.ConnectivityService>(
      () => _i1068.ConnectivityService(
        gh<_i895.Connectivity>(),
        gh<_i361.Dio>(instanceName: 'probeDio'),
      ),
    );
    gh.lazySingleton<_i65.CorrelationInterceptor>(
      () => networkModule.correlationInterceptor(
        gh<_i706.Uuid>(),
        gh<_i655.PackageInfo>(),
        gh<_i156.PreferencesService>(),
        gh<_i846.DeviceIntegrityService>(),
      ),
    );
    gh.lazySingleton<_i361.Dio>(
      () => networkModule.bareDio(
        gh<_i844.DioFactory>(),
        gh<_i18.AppLogger>(),
        gh<_i632.TelemetryService>(),
        gh<_i65.CorrelationInterceptor>(),
        gh<_i464.NetworkStatus>(),
      ),
      instanceName: 'bareDio',
    );
    gh.lazySingleton<_i187.AuthTokenRemoteDataSource>(
      () => _i187.AuthTokenRemoteDataSourceImpl(
        gh<_i361.Dio>(instanceName: 'bareDio'),
      ),
    );
    gh.lazySingleton<_i325.AuthTokenRefresher>(
      () => _i903.AuthTokenRefresherImpl(
        gh<_i187.AuthTokenRemoteDataSource>(),
        gh<_i736.AuthLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i361.Dio>(
      () => networkModule.apiDio(
        gh<_i844.DioFactory>(),
        gh<_i18.AppLogger>(),
        gh<_i632.TelemetryService>(),
        gh<_i65.CorrelationInterceptor>(),
        gh<_i654.SecureStorageService>(),
        gh<_i325.AuthTokenRefresher>(),
        gh<_i325.SessionEvents>(),
        gh<_i464.NetworkStatus>(),
      ),
      instanceName: 'apiDio',
    );
    gh.lazySingleton<_i642.AuditRepository>(
      () => _i152.AuditRepositoryImpl(gh<_i361.Dio>(instanceName: 'apiDio')),
    );
    gh.lazySingleton<_i187.AuthRemoteDataSource>(
      () =>
          _i187.AuthRemoteDataSourceImpl(gh<_i361.Dio>(instanceName: 'apiDio')),
    );
    gh.factoryParam<_i466.AuditCubit, _i155.AuditFilter?, dynamic>(
      (initial, _) => _i466.AuditCubit(gh<_i642.AuditRepository>(), initial),
    );
    gh.lazySingleton<_i814.ReportsRepository>(
      () => _i273.ReportsRepositoryImpl(gh<_i361.Dio>(instanceName: 'apiDio')),
    );
    gh.lazySingleton<_i235.ModerationRepository>(
      () =>
          _i964.ModerationRepositoryImpl(gh<_i361.Dio>(instanceName: 'apiDio')),
    );
    gh.factoryParam<
      _i532.ModerationQueueCubit,
      _i613.ModerationFilter?,
      dynamic
    >(
      (initial, _) =>
          _i532.ModerationQueueCubit(gh<_i235.ModerationRepository>(), initial),
    );
    gh.lazySingleton<_i449.CatalogImportRepository>(
      () => _i510.CatalogImportRepositoryImpl(
        gh<_i361.Dio>(instanceName: 'apiDio'),
      ),
    );
    gh.factory<_i532.ModerationMetricsCubit>(
      () => _i532.ModerationMetricsCubit(gh<_i235.ModerationRepository>()),
    );
    gh.factoryParam<_i387.ReportsQueueCubit, _i698.ReportFilter?, dynamic>(
      (initial, _) =>
          _i387.ReportsQueueCubit(gh<_i814.ReportsRepository>(), initial),
    );
    gh.factoryParam<_i387.ReportDetailCubit, String, dynamic>(
      (id, _) => _i387.ReportDetailCubit(gh<_i814.ReportsRepository>(), id),
    );
    gh.lazySingleton<_i639.AuthRepository>(
      () => _i903.AuthRepositoryImpl(
        gh<_i187.AuthRemoteDataSource>(),
        gh<_i736.AuthLocalDataSource>(),
        gh<_i325.SessionEvents>(),
      ),
    );
    gh.factoryParam<_i532.MemoryDetailCubit, String, dynamic>(
      (id, _) => _i532.MemoryDetailCubit(gh<_i235.ModerationRepository>(), id),
    );
    gh.lazySingleton<_i234.StaffRepository>(
      () => _i744.StaffRepositoryImpl(gh<_i361.Dio>(instanceName: 'apiDio')),
    );
    gh.factoryParam<_i332.StaffDetailCubit, String, dynamic>(
      (id, _) => _i332.StaffDetailCubit(gh<_i234.StaffRepository>(), id),
    );
    gh.lazySingleton<_i504.FeedbackRepository>(
      () => _i596.FeedbackRepositoryImpl(gh<_i361.Dio>(instanceName: 'apiDio')),
    );
    gh.lazySingleton<_i802.CatalogRepository>(
      () => _i362.CatalogRepositoryImpl(gh<_i361.Dio>(instanceName: 'apiDio')),
    );
    gh.lazySingleton<_i821.DashboardRepository>(
      () =>
          _i413.DashboardRepositoryImpl(gh<_i361.Dio>(instanceName: 'apiDio')),
    );
    gh.factory<_i492.CatalogImportCubit>(
      () => _i492.CatalogImportCubit(
        gh<_i449.CatalogImportRepository>(),
        gh<_i449.SeedFolderReader>(),
      ),
    );
    gh.lazySingleton<_i766.AuthBloc>(
      () => _i766.AuthBloc(gh<_i639.AuthRepository>()),
    );
    gh.factory<_i346.PasswordResetCubit>(
      () => _i346.PasswordResetCubit(gh<_i639.AuthRepository>()),
    );
    gh.factory<_i901.StaffSignInCubit>(
      () => _i901.StaffSignInCubit(gh<_i639.AuthRepository>()),
    );
    gh.factory<_i550.ProfileCubit>(
      () => _i550.ProfileCubit(gh<_i639.AuthRepository>()),
    );
    gh.factoryParam<_i575.FeedbackDetailCubit, String, dynamic>(
      (id, _) => _i575.FeedbackDetailCubit(gh<_i504.FeedbackRepository>(), id),
    );
    gh.factory<_i332.StaffListCubit>(
      () => _i332.StaffListCubit(gh<_i234.StaffRepository>()),
    );
    gh.factory<_i332.StaffInviteCubit>(
      () => _i332.StaffInviteCubit(gh<_i234.StaffRepository>()),
    );
    gh.factoryParam<_i575.FeedbackListCubit, _i806.FeedbackFilter?, dynamic>(
      (initial, _) =>
          _i575.FeedbackListCubit(gh<_i504.FeedbackRepository>(), initial),
    );
    gh.factory<_i628.CatalogListCubit>(
      () => _i628.CatalogListCubit(gh<_i802.CatalogRepository>()),
    );
    gh.lazySingleton<_i321.AppRouter>(
      () => _i321.AppRouter(
        gh<_i766.AuthBloc>(),
        gh<_i655.PackageInfo>(),
        gh<_i796.UnsavedChanges>(),
      ),
    );
    gh.factory<_i33.DashboardCubit>(
      () => _i33.DashboardCubit(gh<_i821.DashboardRepository>()),
    );
    gh.factoryParam<_i628.CatalogEditorCubit, String?, dynamic>(
      (_id, _) => _i628.CatalogEditorCubit(
        gh<_i802.CatalogRepository>(),
        gh<_i802.ImagePreparer>(),
        _id,
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i580.RegisterModule {}

class _$NetworkModule extends _i63.NetworkModule {}
