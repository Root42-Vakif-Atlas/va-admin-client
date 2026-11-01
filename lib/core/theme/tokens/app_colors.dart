import 'package:flutter/painting.dart';

/// Primitif renk token'ları (Vakıf Atlas Yönetim).
///
/// Arayüz kodunda doğrudan KULLANILMAZ; yalnızca tema fabrikaları
/// (`AppColorScheme`) bu değerlerden semantik renkleri üretir.
/// Her tema eşlemesi `test/core/theme/contrast_test.dart` ile WCAG 2.2
/// kontrast eşiklerine karşı doğrulanır.
///
/// Kurumsal ve sade palet (A1): yüzeyler nötr gri (yalnızca çok düşük mor
/// tonlu), marka Gece Moru yalnızca kenar çubuğunda ve birincil eylemde,
/// renk yalnızca durum bilgisinde (yayında, aciliyet, hata) kullanılır.
abstract final class AppColors {
  // ── Brand Core ──────────────────────────────────────────────
  /// Gece Moru — kurumsal renk: kenar çubuğu, giriş paneli, birincil eylem.
  static const Color nightPurple = Color(0xFF21172B);

  /// Kenar çubuğunda seçili satır ve ayraç.
  static const Color nightPurpleRaised = Color(0xFF332840);

  /// Kenar çubuğunda üzerine gelme / ince ayraç.
  static const Color nightPurpleLine = Color(0xFF3D3249);

  /// Koyu zeminde ana metin.
  static const Color warmIvory = Color(0xFFF6F3F8);
  static const Color warmIvoryDimmed = Color(0xFFC3BBCB);

  /// Eski Bronz — yalnızca amblem (logo). Arayüz vurgusu olarak kullanılmaz.
  static const Color agedBronze = Color(0xFFAC8058);

  /// İznik çini mavisi — külliye grafiği.
  static const Color iznikBlue = Color(0xFF1D4E89);
  static const Color iznikBlueLight = Color(0xFF9DBDF0);

  // ── Mor (marka) tonları ─────────────────────────────────────
  static const Color purple30 = Color(0xFF4F3D63);
  static const Color purple80 = Color(0xFFD3C4E4);
  static const Color purple95 = Color(0xFFF1EDF5);

  // ── Nötr gri (açık tema) ────────────────────────────────────
  static const Color white = Color(0xFFFFFFFF);
  static const Color gray50 = Color(0xFFF7F7F8);
  static const Color gray100 = Color(0xFFF0EFF2);
  static const Color gray150 = Color(0xFFEAE9ED);
  static const Color gray200 = Color(0xFFE2E1E5);
  static const Color gray500 = Color(0xFF7F7C86);
  static const Color gray600 = Color(0xFF57535E);
  static const Color gray900 = Color(0xFF19171D);

  // ── Nötr gri (koyu tema) ────────────────────────────────────
  static const Color ink950 = Color(0xFF131216);
  static const Color ink900 = Color(0xFF1B1A1F);
  static const Color ink850 = Color(0xFF232227);
  static const Color ink800 = Color(0xFF2C2A31);
  static const Color ink700 = Color(0xFF38363E);
  static const Color ink400 = Color(0xFF8D8995);
  static const Color ink300 = Color(0xFFB8B4BF);
  static const Color ink100 = Color(0xFFECEAF0);

  // ── Semantic Status (Light) ─────────────────────────────────
  static const Color success = Color(0xFF1E6B3E);
  static const Color warning = Color(0xFF8A5300);
  static const Color error = Color(0xFFB3261E);
  static const Color info = Color(0xFF1F5A86);

  // ── Semantic Status (Dark) ──────────────────────────────────
  static const Color successOnDark = Color(0xFF6FCB94);
  static const Color warningOnDark = Color(0xFFE6B14E);
  static const Color errorOnDark = Color(0xFFFF8A80);
  static const Color infoOnDark = Color(0xFF8CC2EC);

  // ── High Contrast Dark ──────────────────────────────────────
  static const Color hcBlack = Color(0xFF000000);
  static const Color hcSurfaceDark = Color(0xFF111111);
  static const Color hcSurfaceDarkElevated = Color(0xFF1C1C1C);
  static const Color hcWhite = Color(0xFFFFFFFF);
  static const Color hcGreyLight = Color(0xFFDDDDDD);
  static const Color hcAccent = Color(0xFFFFD700);
  static const Color hcErrorOnDark = Color(0xFFFF8A8A);
  static const Color hcSuccessOnDark = Color(0xFF5CE08A);
  static const Color hcWarningOnDark = Color(0xFFFFC24D);
  static const Color hcInfoOnDark = Color(0xFF7FD4FF);
  static const Color hcComplexOnDark = Color(0xFF66CCFF);

  // ── High Contrast Light ─────────────────────────────────────
  static const Color hcSurfaceLight = Color(0xFFF0F0F0);
  static const Color hcGreyDark = Color(0xFF222222);
  static const Color hcAccentOnLight = Color(0xFF4A0072);
  static const Color hcComplexOnLight = Color(0xFF0033AA);
  static const Color hcError = Color(0xFFA00000);
  static const Color hcWarning = Color(0xFF5C3D00);
  static const Color hcInfo = Color(0xFF00466B);
}
