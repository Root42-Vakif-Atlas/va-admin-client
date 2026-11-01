import 'package:flutter/painting.dart';

/// Uygulamada paketlenmiş font ailesi.
abstract final class AppFonts {
  static const String inter = 'Inter';
}

/// Tipografi token'ları (Design System §2.2).
///
/// Yönetim istemcisinde marka yazısı dahil tüm metin tek ailedir (Inter):
/// kurumsal, tutarlı görünüm. Sayılar tablo ve özetlerde [tabularFigures]
/// ile hizalanır.
///
/// Renk içermez; renk tema tarafından `AppTextTheme` ile uygulanır.
/// Fontlar değişken (variable) olduğundan ağırlık hem [FontWeight] hem de
/// `wght` ekseniyle belirtilir. Satır yüksekliği `lineHeight / fontSize`.
abstract final class AppTypography {
  /// Sabit genişlikli rakamlar: sütunlarda ve özet sayılarında hizalama.
  static const List<FontFeature> tabularFigures = [
    FontFeature.tabularFigures(),
  ];

  static const TextStyle displayLarge = TextStyle(
    fontFamily: AppFonts.inter,
    fontSize: 40,
    height: 48 / 40,
    letterSpacing: -0.8,
    fontWeight: FontWeight.w600,
    fontVariations: [FontVariation('wght', 600)],
  );

  /// Özet (KPI) sayıları.
  static const TextStyle displayMedium = TextStyle(
    fontFamily: AppFonts.inter,
    fontSize: 32,
    height: 40 / 32,
    letterSpacing: -0.6,
    fontWeight: FontWeight.w600,
    fontVariations: [FontVariation('wght', 600)],
    fontFeatures: tabularFigures,
  );

  static const TextStyle headlineLarge = TextStyle(
    fontFamily: AppFonts.inter,
    fontSize: 28,
    height: 36 / 28,
    letterSpacing: -0.4,
    fontWeight: FontWeight.w600,
    fontVariations: [FontVariation('wght', 600)],
  );

  /// Sayfa başlığı.
  static const TextStyle headlineMedium = TextStyle(
    fontFamily: AppFonts.inter,
    fontSize: 22,
    height: 30 / 22,
    letterSpacing: -0.3,
    fontWeight: FontWeight.w600,
    fontVariations: [FontVariation('wght', 600)],
  );

  /// Üst çubuk (AppBar) sayfa başlığı: `titleLarge`'dan büyük ve kalın.
  static const double appBarTitleSize = 22;
  static const double appBarTitleHeight = 28 / 22;

  static const TextStyle titleLarge = TextStyle(
    fontFamily: AppFonts.inter,
    fontSize: 18,
    height: 26 / 18,
    letterSpacing: -0.2,
    fontWeight: FontWeight.w600,
    fontVariations: [FontVariation('wght', 600)],
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: AppFonts.inter,
    fontSize: 15,
    height: 22 / 15,
    fontWeight: FontWeight.w600,
    fontVariations: [FontVariation('wght', 600)],
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: AppFonts.inter,
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w400,
    fontVariations: [FontVariation('wght', 400)],
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: AppFonts.inter,
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w400,
    fontVariations: [FontVariation('wght', 400)],
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: AppFonts.inter,
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w400,
    fontVariations: [FontVariation('wght', 400)],
  );

  static const TextStyle labelLarge = TextStyle(
    fontFamily: AppFonts.inter,
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w600,
    fontVariations: [FontVariation('wght', 600)],
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: AppFonts.inter,
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w500,
    fontVariations: [FontVariation('wght', 500)],
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: AppFonts.inter,
    fontSize: 11,
    height: 16 / 11,
    letterSpacing: 0.2,
    fontWeight: FontWeight.w500,
    fontVariations: [FontVariation('wght', 500)],
  );
}
