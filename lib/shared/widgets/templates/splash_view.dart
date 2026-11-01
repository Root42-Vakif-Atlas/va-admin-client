import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vakif_atlas_admin/core/a11y/reduce_motion.dart';
import 'package:vakif_atlas_admin/core/l10n/l10n.dart';
import 'package:vakif_atlas_admin/core/theme/launch_colors.dart';
import 'package:vakif_atlas_admin/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas_admin/shared/widgets/atoms/brand_emblem.dart';

/// Oturum geri yüklenirken gösterilen marka açılış ekranı.
///
/// İşletim sisteminin açılış ekranıyla (Android SplashScreen API / iOS
/// LaunchScreen) aynı zemin ve aynı boyut/konumdaki amblemi gösterir; geçiş
/// fark edilmez. Metin yoktur (yalnızca logo). Yükleme göstergesi yalnızca açılış [progressDelay]'den uzun sürerse
/// gösterilir; kısa açılışlarda yanıp sönme olmaz.
class SplashView extends StatefulWidget {
  const SplashView({super.key});

  static const Duration progressDelay = Duration(milliseconds: 400);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with ReduceMotionMixin {
  Timer? _progressTimer;
  bool _showProgress = false;

  @override
  void initState() {
    super.initState();
    _progressTimer = Timer(SplashView.progressDelay, () {
      if (mounted) {
        setState(() => _showProgress = true);
      }
    });
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: LaunchColors.background,
      ),
      child: Scaffold(
        backgroundColor: LaunchColors.background,
        body: Semantics(
          label: l10n.splashLoadingSemantics,
          liveRegion: true,
          excludeSemantics: true,
          child: Stack(
            children: [
              // Amblem tam ekranın ortasındadır (native açılışla aynı yer).
              const Center(
                child: BrandEmblem(
                  key: Key('splash_emblem'),
                  size: AppSizes.splashEmblem,
                  frameColor: LaunchColors.foreground,
                  accentColor: LaunchColors.accent,
                ),
              ),
              if (_showProgress)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: AppSpacing.xxl,
                  child: SafeArea(
                    top: false,
                    child: Center(
                      child: reduceMotion
                          ? const Icon(
                              Icons.hourglass_top,
                              key: Key('splash_progress'),
                              color: LaunchColors.foregroundMuted,
                            )
                          : const SizedBox.square(
                              dimension: AppSizes.iconLg,
                              child: CircularProgressIndicator(
                                key: Key('splash_progress'),
                                strokeWidth: AppSizes.spinnerStroke,
                                color: LaunchColors.foreground,
                              ),
                            ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
