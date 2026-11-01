import 'package:flutter/painting.dart';
import 'package:vakif_atlas_admin/core/theme/tokens/app_colors.dart';

/// Açılış (launch) yüzeyinin sabit marka renkleri.
///
/// İşletim sisteminin açılış ekranı (Android SplashScreen, iOS
/// LaunchScreen) uygulama teması çözülmeden çizilir; Flutter açılış ekranı
/// bu ekranla piksel düzeyinde eşleşmek için temadan bağımsız aynı renkleri
/// kullanır (docs/plans/plan-4.md: "amblem + #081F1D zemin"). Native
/// karşılıkları: `android/app/src/main/res/values/colors.xml`
/// (`splash_background`) ve `ios/Runner/Base.lproj/LaunchScreen.storyboard`.
///
/// Çiftler `test/core/theme/contrast_test.dart` ile doğrulanır.
abstract final class LaunchColors {
  static const Color background = AppColors.nightPurple;

  /// Başlık ve amblem kemeri (≥ 7:1).
  static const Color foreground = AppColors.warmIvory;

  /// İkincil metin (≥ 7:1).
  static const Color foregroundMuted = AppColors.warmIvoryDimmed;

  /// Amblemdeki pusula ve eşik (grafik, ≥ 3:1).
  static const Color accent = AppColors.agedBronze;
}
