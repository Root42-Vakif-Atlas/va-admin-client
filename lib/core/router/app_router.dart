import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:vakif_atlas_admin/core/l10n/l10n.dart';
import 'package:vakif_atlas_admin/core/di/injection.dart';
import 'package:vakif_atlas_admin/core/router/guards/auth_guard.dart';
import 'package:vakif_atlas_admin/core/router/router_refresh_stream.dart';
import 'package:vakif_atlas_admin/core/router/routes.dart';
import 'package:vakif_atlas_admin/core/router/unsaved_changes.dart';
import 'package:vakif_atlas_admin/features/audit/presentation/audit_cubit.dart';
import 'package:vakif_atlas_admin/features/audit/presentation/audit_page.dart';
import 'package:vakif_atlas_admin/features/auth/domain/entities/staff_role.dart';
import 'package:vakif_atlas_admin/features/auth/domain/entities/staff_user.dart';
import 'package:vakif_atlas_admin/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vakif_atlas_admin/features/auth/presentation/cubit/password_reset_cubit.dart';
import 'package:vakif_atlas_admin/features/auth/presentation/cubit/staff_sign_in_cubit.dart';
import 'package:vakif_atlas_admin/features/auth/presentation/pages/password_reset_page.dart';
import 'package:vakif_atlas_admin/features/auth/presentation/pages/sign_in_page.dart';
import 'package:vakif_atlas_admin/features/catalog/domain/catalog_entities.dart';
import 'package:vakif_atlas_admin/features/catalog/presentation/catalog_cubits.dart';
import 'package:vakif_atlas_admin/features/catalog/presentation/catalog_import_cubit.dart';
import 'package:vakif_atlas_admin/features/catalog/presentation/pages/catalog_import_page.dart';
import 'package:vakif_atlas_admin/features/catalog/presentation/pages/catalog_editor_page.dart';
import 'package:vakif_atlas_admin/features/catalog/presentation/pages/catalog_list_page.dart';
import 'package:vakif_atlas_admin/features/civil_protection/domain/entities/damage_report.dart';
import 'package:vakif_atlas_admin/features/civil_protection/presentation/cubit/reports_cubits.dart';
import 'package:vakif_atlas_admin/features/civil_protection/presentation/pages/report_detail_panel.dart';
import 'package:vakif_atlas_admin/features/civil_protection/presentation/pages/reports_page.dart';
import 'package:vakif_atlas_admin/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:vakif_atlas_admin/features/feedback/domain/feedback_entry.dart';
import 'package:vakif_atlas_admin/features/feedback/presentation/feedback_cubits.dart';
import 'package:vakif_atlas_admin/features/feedback/presentation/feedback_detail_panel.dart';
import 'package:vakif_atlas_admin/features/feedback/presentation/feedback_page.dart';
import 'package:vakif_atlas_admin/features/moderation/domain/entities/moderated_memory.dart';
import 'package:vakif_atlas_admin/features/moderation/presentation/cubit/moderation_cubits.dart';
import 'package:vakif_atlas_admin/features/moderation/presentation/pages/memory_detail_panel.dart';
import 'package:vakif_atlas_admin/features/moderation/presentation/pages/moderation_metrics_page.dart';
import 'package:vakif_atlas_admin/features/moderation/presentation/pages/moderation_page.dart';
import 'package:vakif_atlas_admin/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:vakif_atlas_admin/features/profile/presentation/profile_cubit.dart';
import 'package:vakif_atlas_admin/features/profile/presentation/profile_page.dart';
import 'package:vakif_atlas_admin/features/settings/presentation/pages/settings_page.dart';
import 'package:vakif_atlas_admin/features/shell/presentation/admin_shell.dart';
import 'package:vakif_atlas_admin/features/staff/presentation/staff_cubits.dart';
import 'package:vakif_atlas_admin/features/staff/presentation/staff_detail_panel.dart';
import 'package:vakif_atlas_admin/features/staff/presentation/staff_page.dart';
import 'package:vakif_atlas_admin/shared/widgets/molecules/admin_dialogs.dart';
import 'package:vakif_atlas_admin/shared/widgets/templates/not_found_page.dart';
import 'package:vakif_atlas_admin/shared/widgets/templates/splash_view.dart';

/// Rota tanımları ve kompozisyon kökü: ekran BLoC'ları burada sağlanır
/// (ADR 11: sayfalar `getIt` çağırmaz).
///
/// Ana-detay bölümlerinde liste rotası ile kayıt rotası (`/x` ve `/x/:id`)
/// aynı sayfa anahtarını paylaşır: seçim değişince sayfa yeniden kurulmaz,
/// liste durumu (süzgeç, kaydırma, yüklenen sayfalar) korunur.
@lazySingleton
class AppRouter {
  AppRouter(this._auth, this._packageInfo, this._unsaved);

  final AuthBloc _auth;
  final PackageInfo _packageInfo;
  final UnsavedChanges _unsaved;

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> _shellKey = GlobalKey<NavigatorState>();

  StaffUser? get _user => switch (_auth.state) {
    AuthAuthenticated(:final user) => user,
    _ => null,
  };

  late final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: AppRoutes.dashboard,
    refreshListenable: RouterRefreshStream([_auth.stream]),
    redirect: (context, state) => AuthGuard.redirect(_auth.state, state.uri),
    errorBuilder: (context, state) =>
        NotFoundPage(onGoHome: () => router.go(AppRoutes.dashboard)),
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: SplashView()),
      ),
      GoRoute(
        path: AppRoutes.signIn,
        pageBuilder: (context, state) => NoTransitionPage(
          child: BlocProvider(
            create: (_) => getIt<StaffSignInCubit>(),
            child: SignInPage(
              onForgotPassword: () =>
                  unawaited(router.push(AppRoutes.passwordReset)),
            ),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.passwordReset,
        pageBuilder: (context, state) => NoTransitionPage(
          child: BlocProvider(
            create: (_) => getIt<PasswordResetCubit>(),
            child: PasswordResetPage(
              onBackToSignIn: () =>
                  router.canPop() ? router.pop() : router.go(AppRoutes.signIn),
            ),
          ),
        ),
      ),
      ShellRoute(
        navigatorKey: _shellKey,
        builder: (context, state, child) => BlocProvider(
          create: (_) => getIt<DashboardCubit>()..start(_permissionsOf(_user)),
          child: _ShellHost(
            location: state.uri.toString(),
            onNavigate: router.go,
            child: child,
          ),
        ),
        routes: [
          GoRoute(
            path: AppRoutes.dashboard,
            pageBuilder: (context, state) => NoTransitionPage(
              key: const ValueKey('dashboard'),
              child: DashboardPage(
                displayName: _user?.displayName ?? '',
                onOpen: (target) => router.go(_dashboardTarget(target)),
              ),
            ),
          ),
          GoRoute(
            path: AppRoutes.catalog,
            pageBuilder: (context, state) => NoTransitionPage(
              key: const ValueKey('catalog'),
              child: BlocProvider(
                create: (_) => getIt<CatalogListCubit>()
                  ..load(
                    state.uri.queryParameters['location'] == 'missing'
                        ? const CatalogFilter(location: LocationFilter.missing)
                        : const CatalogFilter(),
                  ),
                child: CatalogListPage(
                  onOpen: (id) =>
                      unawaited(router.push(AppRoutes.catalogEntry(id))),
                  onCreate: () => unawaited(router.push(AppRoutes.catalogNew)),
                  onImport: () =>
                      unawaited(router.push(AppRoutes.catalogImport)),
                ),
              ),
            ),
          ),
          GoRoute(
            path: AppRoutes.catalogNew,
            onExit: _confirmLeaveEditor,
            pageBuilder: (context, state) => _editorPage(null),
          ),
          // `/catalog/:id`'den önce eşlenir.
          GoRoute(
            path: AppRoutes.catalogImport,
            onExit: _confirmLeaveImport,
            pageBuilder: (context, state) => NoTransitionPage(
              key: const ValueKey('catalog-import'),
              child: BlocProvider.value(
                value: _import ??= getIt<CatalogImportCubit>(),
                child: CatalogImportPage(
                  onBack: () => router.go(AppRoutes.catalog),
                  // Bitince konumu girilecek eserler süzgeçli listede açılır.
                  onOpenCatalog: () =>
                      router.go('${AppRoutes.catalog}?location=missing'),
                ),
              ),
            ),
          ),
          GoRoute(
            path: '${AppRoutes.catalog}/:id',
            onExit: _confirmLeaveEditor,
            pageBuilder: (context, state) =>
                _editorPage(state.pathParameters['id']),
          ),
          GoRoute(
            path: AppRoutes.reports,
            pageBuilder: (context, state) => _reportsPage(state, null),
          ),
          GoRoute(
            path: '${AppRoutes.reports}/:id',
            pageBuilder: (context, state) =>
                _reportsPage(state, state.pathParameters['id']),
          ),
          GoRoute(
            path: AppRoutes.moderation,
            pageBuilder: (context, state) => _moderationPage(state, null),
          ),
          GoRoute(
            path: AppRoutes.moderationMetrics,
            pageBuilder: (context, state) => NoTransitionPage(
              key: const ValueKey('moderation-metrics'),
              child: BlocProvider(
                create: (_) => getIt<ModerationMetricsCubit>()..load(),
                child: ModerationMetricsPage(
                  onBack: () => router.go(AppRoutes.moderation),
                  onOpenQueue: (queue) => router.go(
                    Uri(
                      path: AppRoutes.moderation,
                      queryParameters: {'queue': queue.name},
                    ).toString(),
                  ),
                ),
              ),
            ),
          ),
          GoRoute(
            path: '${AppRoutes.moderation}/:id',
            pageBuilder: (context, state) =>
                _moderationPage(state, state.pathParameters['id']),
          ),
          GoRoute(
            path: AppRoutes.staff,
            pageBuilder: (context, state) => _staffPage(null),
          ),
          GoRoute(
            path: '${AppRoutes.staff}/:id',
            pageBuilder: (context, state) =>
                _staffPage(state.pathParameters['id']),
          ),
          GoRoute(
            path: AppRoutes.audit,
            pageBuilder: (context, state) => NoTransitionPage(
              key: const ValueKey('audit'),
              child: BlocProvider(
                create: (_) => getIt<AuditCubit>(param1: null)..load(),
                child: const AuditPage(),
              ),
            ),
          ),
          GoRoute(
            path: AppRoutes.feedback,
            pageBuilder: (context, state) => _feedbackPage(state, null),
          ),
          GoRoute(
            path: AppRoutes.profile,
            pageBuilder: (context, state) => NoTransitionPage(
              key: const ValueKey('profile'),
              child: BlocProvider(
                create: (_) => getIt<ProfileCubit>(),
                child: const ProfilePage(),
              ),
            ),
          ),
          GoRoute(
            path: AppRoutes.settings,
            pageBuilder: (context, state) => NoTransitionPage(
              key: const ValueKey('settings'),
              child: SettingsPage(
                appVersion: _packageInfo.buildNumber.isEmpty
                    ? _packageInfo.version
                    : '${_packageInfo.version}+${_packageInfo.buildNumber}',
              ),
            ),
          ),
          GoRoute(
            path: '${AppRoutes.feedback}/:id',
            pageBuilder: (context, state) =>
                _feedbackPage(state, state.pathParameters['id']),
          ),
        ],
      ),
    ],
  );

  /// Eser düzenleyicisi (yeni veya kayıtlı).
  Page<void> _editorPage(String? id) => NoTransitionPage(
    key: ValueKey('catalog-editor-${id ?? 'new'}'),
    child: BlocProvider(
      create: (_) {
        final cubit = getIt<CatalogEditorCubit>(param1: id);
        unawaited(cubit.load());
        return cubit;
      },
      child: CatalogEditorPage(
        onBack: () =>
            router.canPop() ? router.pop() : router.go(AppRoutes.catalog),
        onCreated: (created) {
          _unsaved.set(dirty: false);
          unawaited(router.replace<void>(AppRoutes.catalogEntry(created)));
        },
        onDirtyChanged: (dirty) => _unsaved.set(dirty: dirty),
        onOpenEntry: (id) =>
            unawaited(router.push<void>(AppRoutes.catalogEntry(id))),
      ),
    ),
  );

  /// Kaydedilmemiş değişiklik varsa çıkış onayı.
  /// Sayfadan çıkışta korunur (görsel yükleme yarıda kalır); bitmiş veya
  /// başlamamış içe aktarım için cubit bırakılır.
  CatalogImportCubit? _import;

  Future<bool> _confirmLeaveImport(
    BuildContext context,
    GoRouterState state,
  ) async {
    final cubit = _import;
    if (cubit == null || !cubit.state.running) {
      unawaited(_import?.close());
      _import = null;
      return true;
    }
    final l10n = context.l10n;
    final leave = await showConfirmDialog(
      context,
      title: l10n.importLeaveTitle,
      message: l10n.importLeaveMessage,
      confirmLabel: l10n.importCancel,
    );
    if (leave) {
      // Sürmekte olan yüklemeler bitince durur; sonuç sayfaya dönünce görünür.
      cubit.cancel();
    }
    return leave;
  }

  Future<bool> _confirmLeaveEditor(
    BuildContext context,
    GoRouterState state,
  ) async {
    if (!_unsaved.isDirty) {
      return true;
    }
    final discard = await showDiscardChangesDialog(context);
    if (discard) {
      _unsaved.set(dirty: false);
    }
    return discard;
  }

  /// Sivil Koruma: kuyruk + seçili rapor (aynı sayfa anahtarı).
  Page<void> _reportsPage(GoRouterState state, String? selectedId) =>
      NoTransitionPage(
        key: const ValueKey('reports'),
        child: BlocProvider(
          create: (_) => getIt<ReportsQueueCubit>(
            param1: _reportFilter(state.uri.queryParameters),
          )..load(),
          child: Builder(
            builder: (context) => ReportsPage(
              selectedId: selectedId,
              onSelect: (id) => router.go(
                id == null ? AppRoutes.reports : AppRoutes.report(id),
              ),
              detailBuilder: (id) => BlocProvider(
                create: (_) => getIt<ReportDetailCubit>(param1: id)..load(),
                child: ReportDetailPanel(
                  onClose: () => router.go(AppRoutes.reports),
                  onChanged: (report) {
                    context.read<ReportsQueueCubit>().replace(report);
                    unawaited(context.read<DashboardCubit>().refresh());
                  },
                ),
              ),
            ),
          ),
        ),
      );

  /// Anı moderasyonu: kuyruk + seçili anı.
  Page<void> _moderationPage(GoRouterState state, String? selectedId) =>
      NoTransitionPage(
        key: const ValueKey('moderation'),
        child: BlocProvider(
          create: (_) => getIt<ModerationQueueCubit>(
            param1: ModerationFilter(
              queue: ModerationQueue.fromName(
                state.uri.queryParameters['queue'],
              ),
            ),
          )..load(),
          child: Builder(
            builder: (context) => ModerationPage(
              selectedId: selectedId,
              onOpenMetrics: () => router.go(AppRoutes.moderationMetrics),
              onSelect: (id) => router.go(
                id == null ? AppRoutes.moderation : AppRoutes.memory(id),
              ),
              detailBuilder: (id) => BlocProvider(
                create: (_) => getIt<MemoryDetailCubit>(param1: id)..load(),
                child: MemoryDetailPanel(
                  onClose: () => router.go(AppRoutes.moderation),
                  onChanged: (memory) {
                    context.read<ModerationQueueCubit>().replace(memory);
                    unawaited(context.read<DashboardCubit>().refresh());
                  },
                ),
              ),
            ),
          ),
        ),
      );

  /// Personel yönetimi (yalnızca yönetici).
  Page<void> _staffPage(String? selectedId) => NoTransitionPage(
    key: const ValueKey('staff'),
    child: BlocProvider(
      create: (_) => getIt<StaffListCubit>()..load(),
      child: Builder(
        builder: (context) => StaffPage(
          selectedId: selectedId,
          inviteCubitBuilder: () => getIt<StaffInviteCubit>(),
          onSelect: (id) => router.go(
            id == null ? AppRoutes.staff : AppRoutes.staffMember(id),
          ),
          detailBuilder: (id) => BlocProvider(
            create: (_) => getIt<StaffDetailCubit>(param1: id)..load(),
            child: StaffDetailPanel(
              currentUserId: _user?.id ?? '',
              onClose: () => router.go(AppRoutes.staff),
              onChanged: context.read<StaffListCubit>().replace,
            ),
          ),
        ),
      ),
    ),
  );

  /// Geri bildirim: liste + seçili kayıt.
  Page<void> _feedbackPage(GoRouterState state, String? selectedId) =>
      NoTransitionPage(
        key: const ValueKey('feedback'),
        child: BlocProvider(
          create: (_) => getIt<FeedbackListCubit>(
            param1: FeedbackFilter(
              statuses: {
                for (final status in FeedbackStatus.values)
                  if (state.uri.queryParameters['status'] == status.wireName)
                    status,
              },
            ),
          )..load(),
          child: Builder(
            builder: (context) => FeedbackPage(
              selectedId: selectedId,
              onSelect: (id) => router.go(
                id == null ? AppRoutes.feedback : AppRoutes.feedbackEntry(id),
              ),
              detailBuilder: (id) => BlocProvider(
                create: (_) => getIt<FeedbackDetailCubit>(param1: id)..load(),
                child: FeedbackDetailPanel(
                  onClose: () => router.go(AppRoutes.feedback),
                  onChanged: (entry) {
                    context.read<FeedbackListCubit>().replace(entry);
                    unawaited(context.read<DashboardCubit>().refresh());
                  },
                ),
              ),
            ),
          ),
        ),
      );

  static ReportFilter _reportFilter(Map<String, String> query) => ReportFilter(
    openOnly: query['status'] == 'open',
    urgencies: {
      for (final urgency in ReportUrgency.values)
        if (query['urgency'] == urgency.wireName) urgency,
    },
    evidence: {
      for (final level in EvidenceLevel.values)
        if ((query['evidence'] ?? '').split(',').contains(level.wireName))
          level,
    },
    sort: ReportSort.values.firstWhere(
      (sort) => sort.name == query['sort'],
      orElse: () => ReportSort.newest,
    ),
  );

  static Set<StaffPermission> _permissionsOf(StaffUser? user) => {
    for (final permission in StaffPermission.values)
      if (user?.can(permission) ?? false) permission,
  };

  static String _dashboardTarget(DashboardTarget target) => switch (target) {
    DashboardTarget.criticalReports => Uri(
      path: AppRoutes.reports,
      queryParameters: {'status': 'open', 'urgency': 'critical'},
    ).toString(),
    DashboardTarget.openReports => Uri(
      path: AppRoutes.reports,
      queryParameters: {'status': 'open', 'sort': 'urgency'},
    ).toString(),
    DashboardTarget.strongEvidenceReports ||
    DashboardTarget.unverifiedEvidenceReports ||
    DashboardTarget.suspiciousEvidenceReports ||
    DashboardTarget.pendingEvidenceReports => Uri(
      path: AppRoutes.reports,
      queryParameters: {
        'status': 'open',
        'evidence': switch (target) {
          DashboardTarget.strongEvidenceReports => EvidenceLevel.strong,
          DashboardTarget.suspiciousEvidenceReports => EvidenceLevel.suspicious,
          DashboardTarget.pendingEvidenceReports => EvidenceLevel.pending,
          _ => EvidenceLevel.unverified,
        }.wireName,
        'sort': 'evidence',
      },
    ).toString(),
    DashboardTarget.pendingMemories => Uri(
      path: AppRoutes.moderation,
      queryParameters: {'queue': 'pending'},
    ).toString(),
    DashboardTarget.reportedMemories => Uri(
      path: AppRoutes.moderation,
      queryParameters: {'queue': 'reported'},
    ).toString(),
    DashboardTarget.autoRejectedMemories => Uri(
      path: AppRoutes.moderation,
      queryParameters: {'queue': 'autoRejected'},
    ).toString(),
    DashboardTarget.newFeedback => Uri(
      path: AppRoutes.feedback,
      queryParameters: {'status': 'new'},
    ).toString(),
    DashboardTarget.catalog => AppRoutes.catalog,
  };
}

/// Kabuğu oturuma bağlar: roller değişince özet yeniden başlatılır, rozetler
/// özetten okunur.
class _ShellHost extends StatelessWidget {
  const _ShellHost({
    required this.location,
    required this.onNavigate,
    required this.child,
  });

  final String location;
  final ValueChanged<String> onNavigate;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          current is AuthAuthenticated &&
          (previous is! AuthAuthenticated ||
              previous.user.roles.length != current.user.roles.length ||
              !previous.user.roles.containsAll(current.user.roles)),
      listener: (context, state) => unawaited(
        context.read<DashboardCubit>().start(
          AppRouter._permissionsOf((state as AuthAuthenticated).user),
        ),
      ),
      child: BlocSelector<DashboardCubit, DashboardState, Map<String, int>>(
        selector: (state) => state.badges,
        builder: (context, badges) => AdminShell(
          location: location,
          onNavigate: onNavigate,
          badges: badges,
          child: child,
        ),
      ),
    );
  }
}
