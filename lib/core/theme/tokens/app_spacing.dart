/// 4pt / 8pt grid boşluk token'ları (Design System §2.3).
abstract final class AppSpacing {
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
  static const double x3l = 64;
  static const double x4l = 80;
}

/// Köşe yarıçapı token'ları.
///
/// `circular(30+)` / `StadiumBorder` marka diliyle uyumsuzdur, kullanılmaz.
abstract final class AppRadius {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
}

/// Bileşen boyut token'ları.
abstract final class AppSizes {
  /// WCAG 2.5.8 / Material: minimum dokunma hedefi (dp).
  static const double minTouchTarget = 48;

  /// Liste araç çubuğundaki arama alanı ve menü düğmeleri (masaüstü).
  static const double toolbarHeight = 40;

  /// Tablo satırındaki eser küçük görseli.
  static const double tableThumbnail = 40;

  static const double iconSm = 16;

  /// Buton ve satır içi metinle birlikte kullanılan ikon.
  static const double iconInline = 20;
  static const double iconMd = 24;
  static const double iconLg = 32;
  static const double iconXl = 48;

  static const double borderThin = 1;
  static const double borderThick = 2;

  /// Seçili harita pini gibi güçlü vurgu kenarlığı.
  static const double borderHeavy = 3;

  static const double spinner = 20;
  static const double spinnerStroke = 2;

  /// Pusula/karo motifinin kenar uzunluğu.
  static const double diamond = 8;

  static const double badgeMinSize = 20;

  /// Okunabilir satır uzunluğu için içerik sütununun maksimum genişliği.
  static const double maxContentWidth = 560;

  /// Yönetim kabuğu: kenar gezinmesi (geniş / dar) ve ana-detay ölçüleri.
  static const double sidebarExtended = 264;
  static const double sidebarCollapsed = 80;
  static const double masterPane = 440;
  static const double detailMaxWidth = 960;
  static const double formMaxWidth = 720;
  static const double dialogWidth = 480;

  /// Kayıt seçici diyaloğu (arama + liste).
  static const double pickerWidth = 640;

  /// Düzenleyicide "Külliyedeki sıra" sayı alanı.
  static const double complexOrderField = 240;
  static const double summaryCardMinWidth = 240;

  /// Pano döküm panelinin en küçük genişliği (iki sütuna bölünme sınırı).
  static const double breakdownPanelMinWidth = 380;
  static const double qrCode = 200;

  /// Ayarlar → Hakkında'daki uygulama simgesi.
  static const double aboutIcon = 72;

  /// Boş durum / hata görünümünde ikonu taşıyan dairenin çapı.
  static const double statusBadge = 96;

  /// Liste içindeki kompakt boş durumda ikon dairesinin çapı.
  static const double statusBadgeCompact = 64;

  /// Boş durum / hata metninin en geniş satırı (kısa, ortalı metin).
  static const double statusTextWidth = 400;

  /// Hesap menüsü başlığındaki büyük profil görseli.
  static const double avatarLarge = 64;

  /// Liste ve önizleme kartlarındaki eser küçük görseli.
  static const double thumbnail = 72;

  /// Açılış ekranındaki amblem kutusu. Native açılış görselleri
  /// (`tool/generate_brand_assets_test.dart`) aynı boyutta üretilir; Android
  /// 12+ simge alanının 192 dp'lik görünür dairesine sığar.
  static const double splashEmblem = 160;
}

/// Duyarlı (responsive) kırılım noktaları (Design System §4.1).
abstract final class AppBreakpoints {
  /// Masaüstü ana-detay düzeni: liste ve ayrıntı yan yana (pencere
  /// genişliği; `WindowClass.expanded`).
  static const double split = 1024;

  /// Bu genişliğin altı `Compact` (telefon).
  static const double medium = 600;

  /// Bu genişlik ve üzeri `Expanded` (büyük tablet / masaüstü).
  static const double expanded = 840;

  /// Kenar çubuğu bu pencere genişliğinden itibaren etiketli açılabilir;
  /// altında simge şeridine daralır (içerik ana-detaya yer bırakır).
  static const double sidebarExtended = 1280;
}
