import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakif_atlas_admin/core/a11y/a11y_announcer.dart';
import 'package:vakif_atlas_admin/core/a11y/app_text_scaler.dart';
import 'package:vakif_atlas_admin/core/a11y/haptic_feedback_service.dart';
import 'package:vakif_atlas_admin/core/config/app_config.dart';
import 'package:vakif_atlas_admin/core/config/app_environment.dart';
import 'package:vakif_atlas_admin/core/di/injection.dart';
import 'package:vakif_atlas_admin/core/keyboard/app_shortcuts.dart';
import 'package:vakif_atlas_admin/core/l10n/l10n.dart';
import 'package:vakif_atlas_admin/core/network/network_status.dart';
import 'package:vakif_atlas_admin/core/router/app_router.dart';
import 'package:vakif_atlas_admin/core/session/idle_timer.dart';
import 'package:vakif_atlas_admin/core/theme/app_theme.dart';
import 'package:vakif_atlas_admin/core/theme/extensions/app_color_scheme.dart';
import 'package:vakif_atlas_admin/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vakif_atlas_admin/features/settings/domain/entities/app_settings.dart';
import 'package:vakif_atlas_admin/features/settings/presentation/cubit/app_settings_cubit.dart';
import 'package:vakif_atlas_admin/shared/widgets/organisms/offline_banner.dart';
import 'package:vakif_atlas_admin/shared/widgets/templates/status_message_view.dart';

/// Tema varyantları bir kez üretilir ve yeniden kullanılır.
abstract final class _Themes {
  static final Map<AppColorScheme, ThemeData> _cache = {};

  static ThemeData of(AppColorScheme colors) =>
      _cache.putIfAbsent(colors, () => AppTheme.fromColors(colors));
}

/// Vakıf Atlas Yönetim kök widget'ı: global durum yöneticilerini ve
/// erişilebilirlik servislerini ağaca sağlar; tema, dil, metin ölçeği ve
/// hareket azaltmayı tercihlere göre uygular.
class VakifAtlasAdminApp extends StatelessWidget {
  const VakifAtlasAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<A11yAnnouncer>.value(value: getIt<A11yAnnouncer>()),
        RepositoryProvider<HapticFeedbackService>.value(
          value: getIt<HapticFeedbackService>(),
        ),
        RepositoryProvider<NetworkStatus>.value(value: getIt<NetworkStatus>()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AppSettingsCubit>.value(
            value: getIt<AppSettingsCubit>(),
          ),
          BlocProvider<AuthBloc>.value(value: getIt<AuthBloc>()),
        ],
        child: _AppView(config: getIt<AppConfig>(), router: getIt<AppRouter>()),
      ),
    );
  }
}

class _AppView extends StatelessWidget {
  const _AppView({required this.config, required this.router});

  final AppConfig config;
  final AppRouter router;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppSettingsCubit, AppSettings>(
      builder: (context, settings) {
        final highContrast = settings.highContrast;
        return MaterialApp.router(
          onGenerateTitle: (context) => context.l10n.appTitle,
          debugShowCheckedModeBanner: config.environment == AppEnvironment.dev,
          theme: _Themes.of(
            highContrast
                ? AppColorScheme.highContrastLight
                : AppColorScheme.light,
          ),
          darkTheme: _Themes.of(
            highContrast
                ? AppColorScheme.highContrastDark
                : AppColorScheme.dark,
          ),
          // İşletim sisteminin "kontrastı artır" ayarı da desteklenir.
          highContrastTheme: _Themes.of(AppColorScheme.highContrastLight),
          highContrastDarkTheme: _Themes.of(AppColorScheme.highContrastDark),
          themeMode: settings.themeMode,
          locale: settings.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          routerConfig: router.router,
          shortcuts: {...WidgetsApp.defaultShortcuts, ...AppShortcuts.bindings},
          builder: (context, child) =>
              _AppShell(router: router, settings: settings, child: child!),
        );
      },
    );
  }
}

/// Tüm rotaları saran erişilebilirlik, bağlantı ve oturum katmanları.
class _AppShell extends StatelessWidget {
  const _AppShell({
    required this.router,
    required this.settings,
    required this.child,
  });

  final AppRouter router;
  final AppSettings settings;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final authenticated = context.select<AuthBloc, bool>(
      (bloc) => bloc.state is AuthAuthenticated,
    );
    return MediaQuery(
      data: mediaQuery.copyWith(
        textScaler: AppTextScaler.resolve(
          mediaQuery.textScaler,
          settings.textScaleFactor,
        ),
        // Uygulama içi tercih cihaz ayarına eklenir (WCAG 2.3.3).
        disableAnimations:
            mediaQuery.disableAnimations || settings.reduceMotion,
      ),
      child: IdleTimer(
        enabled: authenticated,
        onTimeout: () =>
            context.read<AuthBloc>().add(const AuthEvent.idleTimeout()),
        child: OfflineBanner(
          network: context.read<NetworkStatus>(),
          onAnnounce: (message, {required offline}) => unawaited(
            context.read<A11yAnnouncer>().announce(message, assertive: offline),
          ),
          child: _SessionNotifications(router: router, child: child),
        ),
      ),
    );
  }
}

/// Oturumun beklenmedik sona ermesini erişilebilir biçimde bildirir; giriş
/// ekranı nedeni ayrıca gösterir.
class _SessionNotifications extends StatelessWidget {
  const _SessionNotifications({required this.router, required this.child});

  final AppRouter router;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          previous is AuthAuthenticated &&
          current is AuthGuest &&
          current.reason != GuestReason.none,
      listener: (context, state) {
        final l10n = context.l10n;
        final message = (state as AuthGuest).reason == GuestReason.idle
            ? l10n.sessionIdleMessage
            : l10n.sessionExpiredMessage;
        unawaited(
          context.read<A11yAnnouncer>().announce(message, assertive: true),
        );
      },
      child: child,
    );
  }
}

/// Engelleyici güvenlik ihlali (yalnızca prod mobil politikası; masaüstünde
/// bütünlük denetimi NoOp olduğundan pratikte gösterilmez).
class SecurityBlockedApp extends StatelessWidget {
  const SecurityBlockedApp({super.key});

  @override
  Widget build(BuildContext context) => const _StartupMessageApp(
    icon: Icons.gpp_bad_outlined,
    titleTr: 'Güvenli olmayan ortam',
    titleEn: 'Unsafe environment',
    messageTr: 'Vakıf Atlas Yönetim bu ortamda çalıştırılamaz.',
    messageEn: 'Vakıf Atlas Management cannot run in this environment.',
  );
}

/// Açılış dizisi başarısız olduysa (yapılandırma, DI).
class StartupFailedApp extends StatelessWidget {
  const StartupFailedApp({super.key});

  @override
  Widget build(BuildContext context) => const _StartupMessageApp(
    icon: Icons.error_outline,
    titleTr: 'Uygulama başlatılamadı',
    titleEn: 'The app could not start',
    messageTr:
        'Lütfen uygulamayı kapatıp yeniden açın. Sorun sürerse VGM Bilgi '
        'İşlem birimine başvurun.',
    messageEn:
        'Please close and reopen the app. If the problem persists, '
        'contact the VGM IT unit.',
  );
}

/// DI ve yerelleştirme olmadan çalışan sade hata ekranı (cihaz diline göre
/// TR/EN).
class _StartupMessageApp extends StatelessWidget {
  const _StartupMessageApp({
    required this.icon,
    required this.titleTr,
    required this.titleEn,
    required this.messageTr,
    required this.messageEn,
  });

  final IconData icon;
  final String titleTr;
  final String titleEn;
  final String messageTr;
  final String messageEn;

  @override
  Widget build(BuildContext context) {
    final english =
        WidgetsBinding.instance.platformDispatcher.locale.languageCode == 'en';
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      home: Scaffold(
        body: StatusMessageView(
          tone: StatusMessageTone.error,
          title: english ? titleEn : titleTr,
          message: english ? messageEn : messageTr,
        ),
      ),
    );
  }
}
