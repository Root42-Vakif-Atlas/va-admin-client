// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Vakıf Atlas Yönetim';

  @override
  String get appBrandSubtitle => 'VGM Yönetim Paneli';

  @override
  String get errorInvalidRequest =>
      'Gönderilen istek geçersiz. Lütfen girdiğiniz bilgileri kontrol edin.';

  @override
  String get errorNotFound =>
      'Kayıt bulunamadı veya bu işlem için yetkiniz yok.';

  @override
  String get errorServerUnavailable =>
      'Sunucu şu anda geçici olarak hizmet veremiyor. Lütfen birazdan tekrar deneyin.';

  @override
  String get errorUnexpected =>
      'Beklenmeyen bir hata oluştu. Lütfen tekrar deneyin.';

  @override
  String get errorUnauthorized =>
      'Oturum süreniz doldu veya bu işlem için yetkiniz bulunmuyor.';

  @override
  String get errorTooManyRequests =>
      'Çok fazla deneme yapıldı. Lütfen biraz sonra tekrar deneyin.';

  @override
  String errorTooManyRequestsRetry(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'Çok fazla deneme yapıldı. $minutes dakika sonra tekrar deneyin.',
      one: 'Çok fazla deneme yapıldı. 1 dakika sonra tekrar deneyin.',
    );
    return '$_temp0';
  }

  @override
  String get errorOffline =>
      'İnternet bağlantınız yok. Bağlantınızı kontrol edip tekrar deneyin.';

  @override
  String get errorServerUnreachable =>
      'Vakıf Atlas sunucusuna şu anda ulaşılamıyor. İnternet bağlantınız çalışıyor; lütfen birazdan tekrar deneyin.';

  @override
  String get errorCacheRead => 'Yerel veri okunamadı.';

  @override
  String get errorSecurityViolation => 'Güvenli bağlantı doğrulanamadı.';

  @override
  String get errorInvalidCredentials =>
      'E-posta adresi veya şifre hatalı. Bilgilerinizi kontrol edip tekrar deneyin.';

  @override
  String get errorInvalidMfaCode =>
      'Doğrulama kodu hatalı. Authenticator uygulamanızdaki güncel kodu girin.';

  @override
  String get errorMfaExpired =>
      'Giriş adımının süresi doldu. Lütfen yeniden giriş yapın.';

  @override
  String get errorInvalidVerificationCode =>
      'Kod hatalı. E-postanızdaki 6 haneli kodu kontrol edip tekrar deneyin.';

  @override
  String get errorVerificationCodeExpired =>
      'Kodun süresi doldu veya çok fazla hatalı deneme yapıldı. Yeni bir kod isteyin.';

  @override
  String get errorWeakPassword =>
      'Bu şifre güvenlik kurallarını karşılamıyor. Daha uzun ve tahmin edilmesi zor bir şifre seçin.';

  @override
  String get errorInvalidCurrentPassword => 'Mevcut şifreniz hatalı.';

  @override
  String get errorStaleData =>
      'Bu kayıt siz incelerken başka bir personel tarafından değiştirildi. Güncel hâlini yükleyip tekrar deneyin.';

  @override
  String get errorConflictTransition =>
      'Bu durum geçişi artık geçerli değil. Kaydı yenileyin.';

  @override
  String get errorConflictMonumentExists =>
      'Bu kimlikle kayıtlı bir eser zaten var. Farklı bir kimlik seçin.';

  @override
  String get errorConflictComplexMembers =>
      'Külliye yapıları kuralına uymuyor: yapısı olan külliye kaldırılamaz, yapılar başka külliye olamaz.';

  @override
  String get errorConflictLastAdmin =>
      'Sistemde etkin en az bir yönetici kalmalıdır.';

  @override
  String get errorConflictSelf =>
      'Kendi yönetici yetkinizi kaldıramaz veya kendinizi devre dışı bırakamazsınız.';

  @override
  String get errorConflictInProgress =>
      'Aynı işlem hâlâ sürüyor. Birkaç saniye sonra tekrar deneyin.';

  @override
  String get errorConflictStaffExists =>
      'Bu e-posta adresi zaten personel olarak kayıtlı.';

  @override
  String badgeOverflow(int max) {
    return '$max+';
  }

  @override
  String buttonLoadingSemantics(String label) {
    return '$label, yükleniyor';
  }

  @override
  String get passwordShow => 'Şifreyi göster';

  @override
  String get passwordHide => 'Şifreyi gizle';

  @override
  String get a11yImageHidden => 'Görsel gizlendi';

  @override
  String get galleryImageError => 'Görsel yüklenemedi';

  @override
  String get notFoundTitle => 'Sayfa bulunamadı';

  @override
  String get notFoundBody =>
      'Aradığınız sayfa taşınmış veya kaldırılmış olabilir.';

  @override
  String get notFoundAction => 'Panoya dön';

  @override
  String get featurePendingHeading => 'Yakında';

  @override
  String featurePendingBody(String feature) {
    return '$feature bir sonraki sürümde kullanıma açılacak.';
  }

  @override
  String get offlineBannerMessage =>
      'Çevrimdışısınız. Değişiklikler bağlantı gelene kadar kaydedilemez.';

  @override
  String get offlineAnnouncement => 'İnternet bağlantısı kesildi';

  @override
  String get onlineAnnouncement => 'İnternet bağlantısı geri geldi';

  @override
  String get privacyOverlaySemantics => 'Vakıf Atlas Yönetim, içerik gizlendi';

  @override
  String get splashLoadingSemantics => 'Vakıf Atlas Yönetim açılıyor';

  @override
  String get commonRetry => 'Tekrar dene';

  @override
  String get commonCancel => 'Vazgeç';

  @override
  String get commonSave => 'Kaydet';

  @override
  String get commonClose => 'Kapat';

  @override
  String get commonConfirm => 'Onayla';

  @override
  String get commonReload => 'Yeniden yükle';

  @override
  String get commonLoading => 'Yükleniyor';

  @override
  String get commonLoadMore => 'Daha fazla yükle';

  @override
  String get commonSearch => 'Ara';

  @override
  String get commonClearFilters => 'Süzgeçleri temizle';

  @override
  String get commonAll => 'Tümü';

  @override
  String get commonBack => 'Geri';

  @override
  String get commonCopy => 'Kopyala';

  @override
  String get commonCopied => 'Panoya kopyalandı';

  @override
  String get commonEdit => 'Düzenle';

  @override
  String get commonNone => '—';

  @override
  String get commonYes => 'Evet';

  @override
  String get commonNo => 'Hayır';

  @override
  String commonResultCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sonuç',
      one: '1 sonuç',
      zero: 'Sonuç yok',
    );
    return '$_temp0';
  }

  @override
  String commonShownOfTotal(int shown, int total) {
    return '$shown / $total gösteriliyor';
  }

  @override
  String get commonEmptyTitle => 'Kayıt yok';

  @override
  String get commonEmptyFiltered => 'Seçili süzgeçlere uyan kayıt yok.';

  @override
  String get commonLoadError => 'Veriler yüklenemedi';

  @override
  String get commonSelectPrompt =>
      'Ayrıntıları görmek için listeden bir kayıt seçin.';

  @override
  String get commonUnsavedTitle => 'Kaydedilmemiş değişiklikler';

  @override
  String get commonUnsavedBody =>
      'Yaptığınız değişiklikler kaybolacak. Çıkmak istiyor musunuz?';

  @override
  String get commonDiscard => 'Değişiklikleri at';

  @override
  String get commonStaleTitle => 'Kayıt değişti';

  @override
  String get searchClear => 'Aramayı temizle';

  @override
  String get navLabel => 'Ana gezinme';

  @override
  String get navDashboard => 'Pano';

  @override
  String get navCatalog => 'Katalog';

  @override
  String get navCivilProtection => 'Sivil Koruma';

  @override
  String get navModeration => 'Anı Moderasyonu';

  @override
  String get navFeedback => 'Geri Bildirim';

  @override
  String get navStaff => 'Personel';

  @override
  String get navAudit => 'Denetim Kaydı';

  @override
  String get navProfile => 'Profilim';

  @override
  String get navSettings => 'Ayarlar';

  @override
  String get navSignOut => 'Çıkış yap';

  @override
  String get navCollapse => 'Kenar çubuğunu daralt';

  @override
  String get navExpand => 'Kenar çubuğunu genişlet';

  @override
  String navAccountMenu(String name) {
    return 'Hesap menüsü, $name';
  }

  @override
  String navBadgeSemantics(String label, int count) {
    return '$label, $count bekleyen';
  }

  @override
  String get roleAdmin => 'Yönetici';

  @override
  String get signOutConfirmTitle => 'Çıkış yapılsın mı?';

  @override
  String get signOutConfirmBody =>
      'Bu cihazdaki personel oturumunuz kapatılacak.';

  @override
  String get sessionExpiredMessage =>
      'Oturumunuz sona erdi. Lütfen yeniden giriş yapın.';

  @override
  String get sessionIdleMessage =>
      '24 saat işlem yapılmadığı için oturumunuz güvenlik amacıyla kapatıldı.';

  @override
  String get signInTitle => 'Personel girişi';

  @override
  String get signInSubtitle =>
      'VGM personeli için yönetim paneli. Erişim rolünüze göre açılır.';

  @override
  String get signInEmail => 'Kurumsal e-posta';

  @override
  String get signInPassword => 'Şifre';

  @override
  String get signInSubmit => 'Devam et';

  @override
  String get signInForgotPassword => 'Şifremi unuttum';

  @override
  String get signInEmailInvalid => 'Geçerli bir e-posta adresi girin.';

  @override
  String get signInPasswordRequired => 'Şifrenizi girin.';

  @override
  String get signInMfaTitle => 'İki adımlı doğrulama';

  @override
  String get signInMfaBody =>
      'Authenticator uygulamanızdaki 6 haneli kodu girin.';

  @override
  String get signInMfaCode => 'Doğrulama kodu';

  @override
  String get signInMfaCodeInvalid => '6 haneli kodu girin.';

  @override
  String get signInMfaVerify => 'Doğrula ve giriş yap';

  @override
  String get signInUseRecovery => 'Kurtarma kodu kullan';

  @override
  String get signInUseAuthenticator => 'Authenticator kodu kullan';

  @override
  String get signInRecoveryCode => 'Kurtarma kodu';

  @override
  String get signInRecoveryHint => 'XXXX-XXXX';

  @override
  String get signInRecoveryInvalid =>
      'Kurtarma kodu 8 karakterdir (XXXX-XXXX).';

  @override
  String get signInBack => 'Farklı hesapla giriş';

  @override
  String signInExpiresIn(int minutes) {
    return 'Bu adım $minutes dakika geçerlidir.';
  }

  @override
  String get enrollTitle => 'Authenticator kurulumu';

  @override
  String get enrollBody =>
      'Yönetici hesapları iki adımlı doğrulama gerektirir. Google Authenticator, Microsoft Authenticator gibi bir uygulamayla QR kodu tarayın veya kurulum anahtarını elle girin.';

  @override
  String get enrollQrSemantics =>
      'Authenticator kurulum QR kodu. Tarayamıyorsanız aşağıdaki kurulum anahtarını kullanın.';

  @override
  String get enrollSecretLabel => 'Kurulum anahtarı';

  @override
  String enrollAccount(String account) {
    return 'Hesap: $account';
  }

  @override
  String get enrollConfirmCode => 'Uygulamada görünen kod';

  @override
  String get enrollConfirm => 'Kurulumu tamamla';

  @override
  String get recoveryTitle => 'Kurtarma kodlarınız';

  @override
  String get recoveryBody =>
      'Authenticator uygulamanıza erişemezseniz bu kodlardan biriyle giriş yapabilirsiniz. Her kod bir kez kullanılır. Kodları güvenli bir yerde saklayın; bir daha gösterilmeyecek.';

  @override
  String get recoveryCopyAll => 'Tümünü kopyala';

  @override
  String get recoveryAcknowledge => 'Kodları güvenli bir yere kaydettim';

  @override
  String get recoveryContinue => 'Panele geç';

  @override
  String get resetTitle => 'Şifre belirle / sıfırla';

  @override
  String get resetBody =>
      'Kurumsal e-posta adresinizi girin. Hesabınız varsa 6 haneli bir kod göndereceğiz.';

  @override
  String get resetSendCode => 'Kod gönder';

  @override
  String get resetCodeSent =>
      'Kod gönderildi. E-postanızdaki kodu ve yeni şifrenizi girin.';

  @override
  String get resetCode => 'E-postadaki kod';

  @override
  String get resetNewPassword => 'Yeni şifre';

  @override
  String get resetPasswordHint =>
      'En az 12 karakter. Uzun bir parola cümlesi en güvenlisidir.';

  @override
  String get resetPasswordTooShort => 'Şifre en az 12 karakter olmalıdır.';

  @override
  String get resetSubmit => 'Şifreyi kaydet';

  @override
  String get resetDone => 'Şifreniz kaydedildi. Şimdi giriş yapabilirsiniz.';

  @override
  String get resetBackToSignIn => 'Girişe dön';

  @override
  String get dashboardTitle => 'Pano';

  @override
  String dashboardGreeting(String name) {
    return 'Hoş geldiniz, $name';
  }

  @override
  String dashboardUpdatedAt(String time) {
    return 'Son güncelleme: $time';
  }

  @override
  String get dashboardRefresh => 'Yenile';

  @override
  String get dashboardSectionError => 'Bu bölümün özeti alınamadı.';

  @override
  String get dashboardReportsTitle => 'Sivil Koruma bildirimleri';

  @override
  String dashboardReportsCritical(int count) {
    return '$count kritik';
  }

  @override
  String get dashboardModerationTitle => 'Anı Köşesi moderasyonu';

  @override
  String dashboardModerationPending(int count) {
    return '$count onay bekliyor';
  }

  @override
  String dashboardModerationReported(int count) {
    return '$count bildirilen anı';
  }

  @override
  String get dashboardFeedbackTitle => 'Geri bildirim';

  @override
  String dashboardFeedbackRating(String rating, int count) {
    return 'Ortalama puan $rating ($count değerlendirme)';
  }

  @override
  String get dashboardFeedbackNoRating => 'Henüz puan verilmedi';

  @override
  String get dashboardCatalogTitle => 'Katalog';

  @override
  String dashboardCatalogArchived(int count) {
    return '$count yayından kaldırıldı';
  }

  @override
  String get dashboardNoSections =>
      'Rolünüz henüz bir yönetim bölümü açmıyor. Yetki için VGM yöneticinize başvurun.';

  @override
  String get reportsTitle => 'Sivil Koruma incelemesi';

  @override
  String get reportsSubtitle =>
      'Vatandaşların eserlerde gördüğü hasar bildirimleri. Durum değişikliği vatandaşa notuyla birlikte gösterilir.';

  @override
  String get reportsSearch => 'Kayıt numarası (SK-2026-…)';

  @override
  String get reportsListLabel => 'Bildirim kuyruğu';

  @override
  String get reportsDetailLabel => 'Bildirim ayrıntısı';

  @override
  String get reportsFilterStatus => 'Durum';

  @override
  String get reportsFilterUrgency => 'Aciliyet';

  @override
  String get reportsFilterCategory => 'Hasar türü';

  @override
  String get reportsFilterOpen => 'Açık';

  @override
  String get reportsSort => 'Sıralama';

  @override
  String get reportsSortNewest => 'En yeni';

  @override
  String get reportsSortOldest => 'En eski';

  @override
  String get reportsSortUrgency => 'Aciliyete göre';

  @override
  String get reportsEmpty => 'Bu süzgeçlere uyan bildirim yok.';

  @override
  String get reportStatusReceived => 'Alındı';

  @override
  String get reportStatusInReview => 'İnceleniyor';

  @override
  String get reportStatusForwarded => 'Yetkili birime iletildi';

  @override
  String get reportStatusResolved => 'Sonuçlandı';

  @override
  String get reportStatusClosed => 'Kapatıldı';

  @override
  String get urgencyCritical => 'Kritik';

  @override
  String get urgencyHigh => 'Yüksek';

  @override
  String get urgencyMedium => 'Orta';

  @override
  String get urgencyLow => 'Düşük';

  @override
  String urgencyLabel(String level) {
    return 'Aciliyet: $level';
  }

  @override
  String get categoryStructuralDamage => 'Yapısal hasar';

  @override
  String get categoryCollapseRisk => 'Çökme riski';

  @override
  String get categoryVandalism => 'Vandalizm';

  @override
  String get categoryTheft => 'Hırsızlık';

  @override
  String get categoryFireOrWater => 'Yangın / su hasarı';

  @override
  String get categoryUnauthorizedWork => 'İzinsiz müdahale';

  @override
  String get categoryOther => 'Diğer';

  @override
  String get verificationNotProvided => 'Konum paylaşılmadı';

  @override
  String verificationOnSite(int distance) {
    return 'Yerinde (esere $distance m)';
  }

  @override
  String verificationDistant(int distance) {
    return 'Uzakta (esere $distance m)';
  }

  @override
  String get reportSectionSummary => 'Bildirim';

  @override
  String get reportSectionPhotos => 'Fotoğraflar';

  @override
  String get reportSectionLocation => 'Konum';

  @override
  String get reportSectionHistory => 'Süreç';

  @override
  String get reportSectionAction => 'Durumu güncelle';

  @override
  String get reportMonument => 'Eser';

  @override
  String get reportPlace => 'Yer';

  @override
  String get reportCategory => 'Hasar türü';

  @override
  String get reportCreatedAt => 'Bildirim tarihi';

  @override
  String get reportReference => 'Kayıt numarası';

  @override
  String get reportAnonymized =>
      'Bildiren hesabını sildi; kayıt kişiyle bağlantısız korunuyor.';

  @override
  String get reportNoPhotos => 'Fotoğraf eklenmemiş.';

  @override
  String reportPhotoSemantics(int index, int count) {
    return 'Bildirim fotoğrafı $index / $count';
  }

  @override
  String reportCoordinates(String latitude, String longitude, int accuracy) {
    return '$latitude, $longitude (±$accuracy m)';
  }

  @override
  String get reportCopyCoordinates => 'Koordinatları kopyala';

  @override
  String get reportOpenMap => 'OpenStreetMap\'te aç';

  @override
  String get reportLocationRetention =>
      'Ham konum yalnızca VGM incelemesi içindir; rapor sonuçlandıktan 90 gün sonra silinir.';

  @override
  String reportHistoryBy(String name) {
    return '$name tarafından';
  }

  @override
  String reportHistoryNoteCitizen(String note) {
    return 'Vatandaşa not: $note';
  }

  @override
  String reportHistoryNoteInternal(String note) {
    return 'İç not: $note';
  }

  @override
  String get reportFinalStatus =>
      'Bu bildirim sonuçlandı; durumu artık değiştirilemez.';

  @override
  String get reportNextStatus => 'Yeni durum';

  @override
  String get reportNoteCitizen => 'Vatandaşa not (isteğe bağlı)';

  @override
  String get reportNoteCitizenHelp =>
      'Bildirimlerim ekranında görünür. Kişisel veri yazmayın.';

  @override
  String get reportNoteInternal => 'İç not (yalnızca personel)';

  @override
  String get reportNoteTooLong => 'Not en fazla 1000 karakter olabilir.';

  @override
  String get reportUpdate => 'Durumu güncelle';

  @override
  String reportUpdated(String status) {
    return 'Bildirim durumu güncellendi: $status';
  }

  @override
  String get reportConfirmFinalTitle => 'Bildirim sonuçlandırılsın mı?';

  @override
  String reportConfirmFinalBody(String status) {
    return '\"$status\" sonuç durumudur; sonra değiştirilemez ve ham konum saklama süresi başlar.';
  }

  @override
  String reportTileSemantics(
    String reference,
    String monument,
    String status,
    String urgency,
  ) {
    return '$reference, $monument, $status, aciliyet $urgency';
  }

  @override
  String get moderationTitle => 'Anı Köşesi moderasyonu';

  @override
  String get moderationSubtitle =>
      'Onay bekleyen anılar ve kullanıcı bildirimleri (şikâyetler). 3 farklı bildirim alan anı inceleme bitene kadar herkese gizlenir.';

  @override
  String get moderationSearch => 'Metin veya yazar ara';

  @override
  String get moderationListLabel => 'Moderasyon kuyruğu';

  @override
  String get moderationDetailLabel => 'Anı ayrıntısı';

  @override
  String get moderationQueuePending => 'Onay bekleyen';

  @override
  String get moderationQueueReported => 'Bildirilen';

  @override
  String get moderationQueueRejected => 'Yayından kaldırılan';

  @override
  String get moderationQueueAll => 'Tümü';

  @override
  String get moderationEmptyPending => 'Onay bekleyen anı yok.';

  @override
  String get moderationEmptyReported => 'Açık bildirimi olan anı yok.';

  @override
  String get memoryStatusApproved => 'Yayında';

  @override
  String get memoryStatusPending => 'Onay bekliyor';

  @override
  String get memoryStatusRejected => 'Yayından kaldırıldı';

  @override
  String get memoryHiddenByReports => 'Bildirimlerle gizlendi';

  @override
  String memoryOpenReports(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count açık bildirim',
      one: '1 açık bildirim',
    );
    return '$_temp0';
  }

  @override
  String get reasonOffensive => 'Saldırgan / hakaret';

  @override
  String get reasonInappropriate => 'Uygunsuz içerik';

  @override
  String get reasonSpam => 'Spam / reklam';

  @override
  String get reasonPersonalInfo => 'Kişisel bilgi içeriyor';

  @override
  String get reasonUnrelated => 'Eserle ilgisiz';

  @override
  String get reasonOther => 'Diğer';

  @override
  String memoryTileSemantics(String monument, String author, String status) {
    return '$monument, $author, $status';
  }

  @override
  String get memorySectionContent => 'Anı';

  @override
  String get memorySectionReports => 'Bildirimler';

  @override
  String get memorySectionModeration => 'Moderasyon kararı';

  @override
  String get memoryAuthor => 'Yazar';

  @override
  String get memoryMonument => 'Eser';

  @override
  String get memoryDate => 'Anı tarihi';

  @override
  String get memorySharedAt => 'Paylaşım';

  @override
  String get memoryNoReports => 'Bu anı için bildirim yok.';

  @override
  String get memoryReportResolutionOpen => 'Açık';

  @override
  String get memoryReportResolutionUpheld => 'Haklı bulundu';

  @override
  String get memoryReportResolutionDismissed => 'Yersiz bulundu';

  @override
  String memoryLastDecision(String name, String date) {
    return 'Son karar: $name, $date';
  }

  @override
  String memoryPhotoSemantics(int index, int count) {
    return 'Anı fotoğrafı $index / $count';
  }

  @override
  String get decisionApprove => 'Yayınla';

  @override
  String get decisionKeep => 'Bildirimleri reddet, yayında tut';

  @override
  String get decisionRestore => 'Geri yükle';

  @override
  String get decisionReject => 'Yayından kaldır';

  @override
  String get decisionReason => 'Kaldırma nedeni';

  @override
  String get decisionReasonRequired => 'Kaldırma nedeni seçin.';

  @override
  String get decisionNote => 'İç not (isteğe bağlı, yazara gösterilmez)';

  @override
  String get decisionRejectConfirmTitle => 'Anı yayından kaldırılsın mı?';

  @override
  String get decisionRejectConfirmBody =>
      'Anı herkese gizlenir; açık bildirimler haklı sayılır. Kararı daha sonra geri yükleyerek değiştirebilirsiniz.';

  @override
  String decisionSaved(String status) {
    return 'Moderasyon kararı kaydedildi: $status';
  }

  @override
  String get feedbackTitle => 'Geri bildirim';

  @override
  String get feedbackSubtitle =>
      'Vatandaş uygulamasından gelen öneri, hata ve erişilebilirlik bildirimleri.';

  @override
  String get feedbackSearch => 'Mesajda ara';

  @override
  String get feedbackListLabel => 'Geri bildirim listesi';

  @override
  String get feedbackDetailLabel => 'Geri bildirim ayrıntısı';

  @override
  String get feedbackFilterStatus => 'Durum';

  @override
  String get feedbackFilterCategory => 'Konu';

  @override
  String get feedbackFilterRating => 'Puan';

  @override
  String get feedbackNoRating => 'Puansız';

  @override
  String get feedbackStatusNew => 'Yeni';

  @override
  String get feedbackStatusInProgress => 'İşlemde';

  @override
  String get feedbackStatusDone => 'Tamamlandı';

  @override
  String get feedbackStatusDismissed => 'Gereksiz';

  @override
  String get feedbackCategorySuggestion => 'Öneri';

  @override
  String get feedbackCategoryBug => 'Hata';

  @override
  String get feedbackCategoryAccessibility => 'Erişilebilirlik';

  @override
  String get feedbackCategoryContent => 'Eser bilgisi';

  @override
  String get feedbackCategoryOther => 'Diğer';

  @override
  String feedbackRatingValue(int rating) {
    return '$rating / 5 yıldız';
  }

  @override
  String get feedbackEmptyMessage => '(Yalnızca puan verildi)';

  @override
  String get feedbackSectionMessage => 'Mesaj';

  @override
  String get feedbackSectionContext => 'Bağlam';

  @override
  String get feedbackSectionTriage => 'Triaj';

  @override
  String get feedbackAppVersion => 'Uygulama sürümü';

  @override
  String get feedbackPlatform => 'Platform';

  @override
  String get feedbackLanguage => 'Dil';

  @override
  String get feedbackSender => 'Gönderen';

  @override
  String get feedbackFromAccount => 'Oturum açık hesap';

  @override
  String get feedbackFromGuest => 'Misafir';

  @override
  String get feedbackReceivedAt => 'Alındı';

  @override
  String feedbackHandledBy(String name, String date) {
    return 'Son işlem: $name, $date';
  }

  @override
  String get feedbackStaffNote => 'İç not (gönderene gösterilmez)';

  @override
  String get feedbackSaveTriage => 'Kaydet';

  @override
  String feedbackTriaged(String status) {
    return 'Geri bildirim durumu: $status';
  }

  @override
  String feedbackTileSemantics(String category, String status, String date) {
    return '$category, $status, $date';
  }

  @override
  String get staffTitle => 'Personel';

  @override
  String get staffSubtitle =>
      'Yönetim paneline erişen VGM personeli ve rolleri. Her rol yalnızca kendi bölümünü açar.';

  @override
  String get staffSearch => 'Ad veya e-posta ara';

  @override
  String get staffListLabel => 'Personel listesi';

  @override
  String get staffDetailLabel => 'Personel ayrıntısı';

  @override
  String get staffFilterRole => 'Rol';

  @override
  String get staffFilterStatus => 'Durum';

  @override
  String get staffStatusActive => 'Etkin';

  @override
  String get staffStatusDisabled => 'Devre dışı';

  @override
  String get staffInvite => 'Personel davet et';

  @override
  String get staffInviteTitle => 'Personel davet et';

  @override
  String get staffInviteBody =>
      'Davet edilen kişiye e-posta gönderilir; şifresini \"Şifremi unuttum\" ile belirler ve ilk girişte Authenticator kurar.';

  @override
  String get staffInviteName => 'Ad soyad';

  @override
  String get staffInviteNameRequired => 'Ad soyad girin.';

  @override
  String get staffInviteRolesRequired => 'En az bir rol seçin.';

  @override
  String get staffInviteSend => 'Davet gönder';

  @override
  String staffInvited(String name) {
    return '$name davet edildi';
  }

  @override
  String get staffRoles => 'Roller';

  @override
  String get staffRolesSave => 'Rolleri kaydet';

  @override
  String get staffRolesSaved =>
      'Roller kaydedildi; personelin açık oturumları sonlandırıldı.';

  @override
  String get staffSectionAccount => 'Hesap';

  @override
  String get staffSectionSecurity => 'Güvenlik';

  @override
  String staffMfaEnrolled(String date) {
    return 'İki adımlı doğrulama kurulu ($date)';
  }

  @override
  String get staffMfaNotEnrolled =>
      'İki adımlı doğrulama henüz kurulmadı (ilk girişte kurulur)';

  @override
  String get staffLastLogin => 'Son giriş';

  @override
  String get staffNever => 'Hiç giriş yapmadı';

  @override
  String get staffCreatedAt => 'Eklenme';

  @override
  String get staffYou => 'Siz';

  @override
  String get staffDisable => 'Erişimi devre dışı bırak';

  @override
  String get staffEnable => 'Erişimi etkinleştir';

  @override
  String get staffDisableConfirmTitle => 'Personel erişimi kapatılsın mı?';

  @override
  String get staffDisableConfirmBody =>
      'Kişi yönetim paneline giremez ve açık oturumları hemen sonlanır. Vatandaş hesabı etkilenmez.';

  @override
  String get staffResetMfa => 'Authenticator\'ı sıfırla';

  @override
  String get staffResetMfaConfirmTitle => 'Authenticator sıfırlansın mı?';

  @override
  String get staffResetMfaConfirmBody =>
      'Kurtarma kodları geçersiz olur; kişi sonraki girişte iki adımlı doğrulamayı yeniden kurar. Kimliğini başka bir kanaldan doğruladıktan sonra yapın.';

  @override
  String get staffRevokeSessions => 'Oturumları sonlandır';

  @override
  String get staffRevokeConfirmTitle => 'Tüm oturumlar sonlandırılsın mı?';

  @override
  String get staffRevokeConfirmBody =>
      'Kişinin açık yönetim paneli oturumları kapanır; yeniden giriş yapması gerekir.';

  @override
  String get staffActionDone => 'İşlem tamamlandı';

  @override
  String get staffSelfNote =>
      'Kendi hesabınızda rol kaldırma ve devre dışı bırakma kapalıdır.';

  @override
  String staffTileSemantics(String name, String roles, String status) {
    return '$name, $roles, $status';
  }

  @override
  String get auditTitle => 'Denetim kaydı';

  @override
  String get auditSubtitle =>
      'Tüm servislerdeki personel işlemleri: kim, ne zaman, hangi kayıtta, neyi değiştirdi.';

  @override
  String get auditFilterService => 'Servis';

  @override
  String get auditTargetSearch => 'Kayıt kimliği';

  @override
  String get auditDateRange => 'Tarih aralığı';

  @override
  String get auditColumnTime => 'Zaman';

  @override
  String get auditColumnActor => 'Personel';

  @override
  String get auditColumnAction => 'İşlem';

  @override
  String get auditColumnTarget => 'Kayıt';

  @override
  String get auditChanges => 'Değişiklikler';

  @override
  String auditCorrelation(String id) {
    return 'İzleme kimliği: $id';
  }

  @override
  String get auditNoChanges => 'Ek bilgi yok';

  @override
  String get auditServiceIdentity => 'Kimlik';

  @override
  String get auditServiceCatalog => 'Katalog';

  @override
  String get auditServiceCivilProtection => 'Sivil Koruma';

  @override
  String get auditServiceMemories => 'Anı Köşesi';

  @override
  String get auditServiceFeedback => 'Geri bildirim';

  @override
  String get auditActionSignedIn => 'Panele giriş yaptı';

  @override
  String get auditActionMfaEnrolled => 'İki adımlı doğrulamayı kurdu';

  @override
  String get auditActionRecoveryUsed => 'Kurtarma kodu kullandı';

  @override
  String get auditActionRecoveryRegenerated => 'Kurtarma kodlarını yeniledi';

  @override
  String get auditActionPasswordChanged => 'Şifresini değiştirdi';

  @override
  String get auditActionStaffInvited => 'Personel davet etti';

  @override
  String get auditActionStaffRoles => 'Personel rollerini değiştirdi';

  @override
  String get auditActionStaffDisabled => 'Personel erişimini kapattı';

  @override
  String get auditActionStaffEnabled => 'Personel erişimini açtı';

  @override
  String get auditActionStaffMfaReset => 'Authenticator\'ı sıfırladı';

  @override
  String get auditActionStaffSessions => 'Oturumları sonlandırdı';

  @override
  String get auditActionReportStatus => 'Bildirim durumunu değiştirdi';

  @override
  String get auditActionMemoryApproved => 'Anıyı onayladı / yayında tuttu';

  @override
  String get auditActionMemoryRejected => 'Anıyı yayından kaldırdı';

  @override
  String get auditActionFeedbackTriaged => 'Geri bildirimi işledi';

  @override
  String get auditActionMonumentCreated => 'Eser ekledi';

  @override
  String get auditActionMonumentUpdated => 'Eseri güncelledi';

  @override
  String get auditActionMonumentArchived => 'Eseri yayından kaldırdı';

  @override
  String get auditActionMonumentRestored => 'Eseri yeniden yayınladı';

  @override
  String get auditActionComplexMembers => 'Külliye yapılarını düzenledi';

  @override
  String get profileTitle => 'Profilim';

  @override
  String get profileSectionAccount => 'Hesap';

  @override
  String get profileSectionRoles => 'Rollerim';

  @override
  String get profileSectionSecurity => 'Güvenlik';

  @override
  String get profileSectionPassword => 'Şifre değiştir';

  @override
  String get profileRolesHelp => 'Roller VGM yöneticisi tarafından atanır.';

  @override
  String profileMfaOn(String date) {
    return 'İki adımlı doğrulama açık (kurulum: $date)';
  }

  @override
  String profileRecoveryRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kurtarma kodu kaldı.',
      one: '1 kurtarma kodu kaldı.',
      zero: 'Kullanılabilir kurtarma kodu kalmadı.',
    );
    return '$_temp0';
  }

  @override
  String get profileRecoveryLow =>
      'Kurtarma kodlarınız azaldı. Authenticator erişimini kaybetmeden yenileyin.';

  @override
  String get profileRegenerate => 'Kurtarma kodlarını yenile';

  @override
  String get profileRegenerateTitle => 'Kurtarma kodlarını yenile';

  @override
  String get profileRegenerateBody =>
      'Eski kodlar geçersiz olur. Onaylamak için Authenticator uygulamanızdaki güncel kodu girin.';

  @override
  String get profileRegenerateConfirm => 'Yenile';

  @override
  String get profileCurrentPassword => 'Mevcut şifre';

  @override
  String get profilePasswordSaved =>
      'Şifreniz değiştirildi; diğer oturumlarınız kapatıldı.';

  @override
  String get profileSignOut => 'Çıkış yap';

  @override
  String get settingsTitle => 'Ayarlar';

  @override
  String get settingsSectionAppearance => 'Görünüm';

  @override
  String get settingsSectionLanguage => 'Dil';

  @override
  String get settingsSectionAccessibility => 'Erişilebilirlik';

  @override
  String get settingsSectionAbout => 'Hakkında';

  @override
  String get settingsThemeSystem => 'Cihaz ayarı';

  @override
  String get settingsThemeLight => 'Açık';

  @override
  String get settingsThemeDark => 'Koyu';

  @override
  String get settingsHighContrast => 'Yüksek kontrast';

  @override
  String get settingsHighContrastHelp =>
      'Metin ve çizgiler için en az 7:1 kontrast.';

  @override
  String get settingsLanguageSystem => 'Cihaz dili';

  @override
  String get settingsTextScale => 'Metin boyutu';

  @override
  String settingsTextScaleValue(int percent) {
    return '%$percent';
  }

  @override
  String get settingsReduceMotion => 'Hareketi azalt';

  @override
  String get settingsReduceMotionHelp =>
      'Geçiş ve kayma animasyonlarını kapatır.';

  @override
  String get settingsShortcuts => 'Klavye kısayolları';

  @override
  String get settingsShortcutSearch => 'Aramaya git';

  @override
  String get settingsShortcutNew => 'Yeni kayıt';

  @override
  String get settingsShortcutSave => 'Kaydet';

  @override
  String get settingsShortcutRefresh => 'Yenile';

  @override
  String get settingsShortcutClose => 'Ayrıntıyı kapat';

  @override
  String settingsVersion(String version) {
    return 'Sürüm $version';
  }

  @override
  String get settingsAboutBody =>
      'Vakıflar Genel Müdürlüğü personeli için Vakıf Atlas yönetim istemcisi. Root42 tarafından geliştirilmiştir.';

  @override
  String get catalogTitle => 'Katalog';

  @override
  String get catalogSubtitle =>
      'VGM onaylı vakıf eserleri. Değişiklikler vatandaş uygulamasına ve haritaya hemen yansır.';

  @override
  String get catalogSearch => 'Ad, il, bani veya kimlik ara';

  @override
  String get catalogNew => 'Yeni eser';

  @override
  String get catalogFilterCategory => 'Tür';

  @override
  String get catalogFilterPeriod => 'Dönem';

  @override
  String get catalogFilterPublication => 'Yayın';

  @override
  String get catalogSortName => 'Ada göre';

  @override
  String get catalogSortUpdated => 'Son güncellenen';

  @override
  String get publicationPublished => 'Yayında';

  @override
  String get publicationArchived => 'Yayından kaldırıldı';

  @override
  String get categoryMosque => 'Cami';

  @override
  String get categoryComplex => 'Külliye';

  @override
  String get categoryMadrasa => 'Medrese';

  @override
  String get categoryInn => 'Han';

  @override
  String get categoryCaravanserai => 'Kervansaray';

  @override
  String get categoryBath => 'Hamam';

  @override
  String get categoryFountain => 'Çeşme';

  @override
  String get categoryTomb => 'Türbe';

  @override
  String get categoryHospital => 'Darüşşifa';

  @override
  String get categoryImaret => 'İmaret';

  @override
  String get categoryMonumentOther => 'Diğer';

  @override
  String get periodSeljuk => 'Selçuklu';

  @override
  String get periodBeylik => 'Beylikler';

  @override
  String get periodOttoman => 'Osmanlı';

  @override
  String get periodOther => 'Diğer';

  @override
  String catalogImageCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count görsel',
      one: '1 görsel',
      zero: 'Görsel yok',
    );
    return '$_temp0';
  }

  @override
  String catalogMemberCount(int count) {
    return '$count yapı';
  }

  @override
  String catalogPartOf(String name) {
    return '$name içinde';
  }

  @override
  String catalogRowSemantics(
    String name,
    String category,
    String city,
    String publication,
  ) {
    return '$name, $category, $city, $publication';
  }

  @override
  String get editorNewTitle => 'Yeni eser';

  @override
  String get editorBack => 'Kataloğa dön';

  @override
  String get editorTabGeneral => 'Genel';

  @override
  String get editorTabTurkish => 'Türkçe';

  @override
  String get editorTabEnglish => 'İngilizce';

  @override
  String get editorTabImages => 'Görseller';

  @override
  String get editorTabMembers => 'Külliye yapıları';

  @override
  String editorTabHasErrors(String tab) {
    return '$tab, düzeltilmesi gereken alanlar var';
  }

  @override
  String get editorSave => 'Kaydet';

  @override
  String get editorSaved => 'Eser kaydedildi';

  @override
  String get editorDiscard => 'Değişiklikleri geri al';

  @override
  String get editorUnsaved => 'Kaydedilmemiş değişiklikler var';

  @override
  String get editorErrorsSummary =>
      'Kaydetmeden önce işaretli alanları düzeltin.';

  @override
  String get editorArchive => 'Yayından kaldır';

  @override
  String get editorRestore => 'Yeniden yayınla';

  @override
  String get editorArchiveConfirmTitle => 'Eser yayından kaldırılsın mı?';

  @override
  String get editorArchiveConfirmBody =>
      'Eser vatandaş uygulamasında ve haritada görünmez; rotalar, kayıtlar ve anılar \"katalogdan kalkmış\" gösterir. Daha sonra yeniden yayınlanabilir.';

  @override
  String editorArchivedNotice(String date) {
    return 'Bu eser yayında değil ($date).';
  }

  @override
  String get editorPublicationChanged => 'Yayın durumu güncellendi';

  @override
  String get editorFieldId => 'Kimlik (adres)';

  @override
  String get editorFieldIdHelp =>
      'Küçük harf, rakam ve tire; kaydedildikten sonra değiştirilemez. Örn. selimiye-camii';

  @override
  String get editorFieldIdError =>
      '3–120 karakter; yalnızca küçük harf, rakam ve tek tire.';

  @override
  String get editorSuggestId => 'Addan öner';

  @override
  String get editorFieldCategory => 'Tür';

  @override
  String get editorFieldPeriod => 'Dönem';

  @override
  String get editorFieldCity => 'İl';

  @override
  String get editorFieldDistrict => 'İlçe';

  @override
  String get editorFieldAddress => 'Adres';

  @override
  String get editorFieldLatitude => 'Enlem';

  @override
  String get editorFieldLongitude => 'Boylam';

  @override
  String get editorFieldLocationError =>
      'Türkiye sınırları içinde geçerli bir koordinat girin (ondalık derece).';

  @override
  String get editorFieldLocationHelp =>
      'Ondalık derece (WGS 84), örn. 41.6781 / 26.5594.';

  @override
  String get editorFieldUnesco => 'UNESCO Dünya Mirası';

  @override
  String get editorFieldComplex => 'Bağlı olduğu külliye';

  @override
  String get editorFieldComplexHelp =>
      'Eser bir külliyenin yapısıysa listeden seçin; değilse bağımsız bırakın. Külliye türündeki eser başka külliyeye bağlanamaz.';

  @override
  String get editorFieldComplexError =>
      'Seçilen külliye geçersiz. Listeden yeniden seçin.';

  @override
  String get editorFieldComplexOrder => 'Külliyedeki sıra';

  @override
  String get editorFieldRequired => 'Bu alan zorunludur.';

  @override
  String get editorFieldName => 'Ad';

  @override
  String get editorFieldShortDescription => 'Kısa tanıtım';

  @override
  String get editorFieldShortDescriptionHelp =>
      'Liste ve kartlarda görünür (en fazla 1000 karakter).';

  @override
  String get editorFieldDescription => 'Açıklama';

  @override
  String get editorFieldDescriptionHelp => 'Paragrafları boş satırla ayırın.';

  @override
  String get editorFieldHistory => 'Tarihçe';

  @override
  String get editorFieldConstructionDate => 'Yapım tarihi';

  @override
  String get editorFieldFounder => 'Bani (yaptıran)';

  @override
  String get editorFieldArchitect => 'Mimar';

  @override
  String get editorImagesHelp =>
      'İlk görsel kapak görselidir. Her görsel için iki dilde alternatif metin, yazar ve lisans zorunludur (atıf). En fazla 10 görsel.';

  @override
  String get editorImagesAdd => 'Görsel ekle';

  @override
  String editorImagesUploading(int count) {
    return '$count görsel hazırlanıyor ve yükleniyor…';
  }

  @override
  String editorImagesUploadError(String reason) {
    return 'Görsel yüklenemedi: $reason';
  }

  @override
  String get editorImagesInvalid =>
      'Dosya okunamadı veya desteklenmeyen biçimde.';

  @override
  String get editorImagesError =>
      'Her görsel için alternatif metin (TR/EN), yazar ve lisans girin.';

  @override
  String get editorImagesEmpty => 'Henüz görsel yok.';

  @override
  String get editorImageCover => 'Kapak';

  @override
  String get editorImageNew => 'Yeni';

  @override
  String get editorImageMirrored => 'Kurum deposunda';

  @override
  String get editorImageAltTr => 'Alternatif metin (TR)';

  @override
  String get editorImageAltEn => 'Alternatif metin (EN)';

  @override
  String get editorImageAuthor => 'Yazar';

  @override
  String get editorImageLicense => 'Lisans';

  @override
  String get editorImageSourceName => 'Kaynak';

  @override
  String get editorImageSourceUrl => 'Kaynak adresi';

  @override
  String get editorImageMoveUp => 'Yukarı taşı';

  @override
  String get editorImageMoveDown => 'Aşağı taşı';

  @override
  String get editorImageRemove => 'Görseli kaldır';

  @override
  String editorImageSemantics(int index, int count) {
    return 'Görsel $index / $count';
  }

  @override
  String get editorImagesFileType => 'Görseller';

  @override
  String get editorMembersHelp =>
      'Yapıların küratörlü sırası (cami genelde ilk). Yapı eklemek için listeden seçin; sıralama ve üyelik kaydedildiğinde külliyenin yerleşim alanı yeniden hesaplanır.';

  @override
  String get editorMembersSaveFirst =>
      'Yapılar, külliye kaydedildikten sonra düzenlenebilir.';

  @override
  String get editorMembersAdd => 'Yapı ekle';

  @override
  String get editorMembersSave => 'Yapıları kaydet';

  @override
  String get editorMembersSaved => 'Külliye yapıları kaydedildi';

  @override
  String get editorMembersEmpty => 'Bu külliyeye bağlı yapı yok.';

  @override
  String get editorMemberRemove => 'Külliyeden çıkar';

  @override
  String get editorMemberArchived => 'yayında değil';

  @override
  String editorMemberOrder(int index, String name) {
    return '$index. $name';
  }

  @override
  String get appBrandName => 'Vakıf Atlas';

  @override
  String filterSelectedCount(int count) {
    return '$count seçili';
  }

  @override
  String get filterClearSelection => 'Seçimi temizle';

  @override
  String get catalogColumnName => 'Eser';

  @override
  String get catalogColumnCategory => 'Tür';

  @override
  String get catalogColumnPeriod => 'Dönem';

  @override
  String get catalogColumnLocation => 'Konum';

  @override
  String get catalogColumnImages => 'Görsel';

  @override
  String get catalogColumnStatus => 'Durum';

  @override
  String get catalogColumnUpdated => 'Güncellendi';

  @override
  String get dashboardMetricOpenReports => 'Açık hasar bildirimi';

  @override
  String get dashboardMetricModeration => 'İşlem bekleyen anı';

  @override
  String get dashboardMetricFeedback => 'Yeni geri bildirim';

  @override
  String get dashboardMetricCatalog => 'Yayındaki eser';

  @override
  String get dashboardReportsNoCritical => 'Kritik bildirim yok';

  @override
  String get dashboardOpenQueue => 'Kuyruğu aç';

  @override
  String get dashboardOpenCatalog => 'Kataloğu aç';

  @override
  String get dashboardByStatus => 'Duruma göre';

  @override
  String get dashboardOpenByUrgency => 'Açık bildirimler, aciliyete göre';

  @override
  String get dashboardByTopic => 'Konuya göre';

  @override
  String get dashboardByCategory => 'Türe göre';

  @override
  String get dashboardModerationReportedLabel => 'Bildirilen';

  @override
  String get dashboardCatalogState => 'Yayın durumu';

  @override
  String get dashboardCatalogNoImages => 'Görseli olmayan';

  @override
  String get dashboardCatalogVersionLabel => 'Katalog sürümü';

  @override
  String get auditFilterDate => 'Tarih';

  @override
  String get editorFieldComplexOrderHelp => 'Külliye sayfasındaki yapı sırası.';

  @override
  String get editorComplexNone => 'Bağımsız eser (külliyeye bağlı değil)';

  @override
  String get editorComplexChoose => 'Külliye seç';

  @override
  String get editorComplexChange => 'Değiştir';

  @override
  String get editorComplexClear => 'Bağlantıyı kaldır';

  @override
  String get editorFieldShortDescriptionTitle => 'Kısa tanıtım başlığı';

  @override
  String get editorFieldKind => 'Kayıt türü';

  @override
  String get editorKindWork => 'Eser';

  @override
  String get editorKindComplex => 'Külliye';

  @override
  String get editorCategoryAuto => 'Türü addan belirle';

  @override
  String get editorCategoryAutoHelp =>
      'Tür, Türkçe addaki son yapı sözcüğünden türetilir (ör. “… Camii Şadırvanı” → çeşme). Kapatıp elle seçebilirsiniz.';

  @override
  String get editorFieldActive => 'Etkin';

  @override
  String get editorFieldActiveHelp =>
      'Kapalıyken kayıt vatandaş uygulamasında görünmez.';

  @override
  String get editorComplexOpen => 'Külliyeyi aç';

  @override
  String get editorComplexMembershipHelp =>
      'Külliye üyeliği ve sırası, külliyenin “Külliye yapıları” sekmesinden düzenlenir.';

  @override
  String editorComplexPosition(int position) {
    return 'Külliyedeki sıra: $position';
  }

  @override
  String get pickerComplexTitle => 'Külliye seç';

  @override
  String get pickerComplexSearch => 'Külliye adı, il veya kimlik ara';

  @override
  String get pickerMembersTitle => 'Külliyeye yapı ekle';

  @override
  String get pickerMembersSearch => 'Eser adı, il veya kimlik ara';

  @override
  String get pickerMembersHelp =>
      'Birden fazla yapı seçebilirsiniz. Başka bir külliyedeki yapı, yapılar kaydedildiğinde bu külliyeye taşınır.';

  @override
  String pickerResultCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kayıt',
      one: '1 kayıt',
      zero: 'Kayıt yok',
    );
    return '$_temp0';
  }

  @override
  String pickerSelectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count yapı seçildi',
      zero: 'Seçim yok',
    );
    return '$_temp0';
  }

  @override
  String pickerAdd(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count yapıyı ekle',
      zero: 'Ekle',
    );
    return '$_temp0';
  }

  @override
  String get pickerAlreadyMember => 'Bu külliyede zaten var';

  @override
  String get pickerCurrent => 'Şu anki seçim';

  @override
  String pickerInOtherComplex(String name) {
    return 'Şu an $name içinde, eklenirse taşınır';
  }

  @override
  String get roleEditor => 'Editör';

  @override
  String get roleModerator => 'Moderatör';

  @override
  String get roleAdminDescription =>
      'Tüm bölümler, personel yönetimi ve denetim kaydı';

  @override
  String get roleEditorDescription =>
      'Yalnızca katalog: eser ekleme, düzenleme, yayından kaldırma ve külliye ilişkileri';

  @override
  String get roleModeratorDescription =>
      'Yalnızca kullanıcı içeriği: Anı Köşesi, Sivil Koruma bildirimleri ve geri bildirim';

  @override
  String get settingsReduceMotionLocked =>
      'Cihazınızda hareketi azaltma açık; uygulama buna her zaman uyar. Kapatmak için sistem ayarlarını kullanın.';

  @override
  String get moderationQueueAutoRejected => 'YZ\'nin kaldırdıkları';

  @override
  String get moderationEmptyAutoRejected => 'YZ\'nin kaldırdığı anı yok.';

  @override
  String get moderationSortLabel => 'Sıra';

  @override
  String get moderationSortOldest => 'En eski önce';

  @override
  String get moderationSortAiScore => 'En yüksek YZ skoru önce';

  @override
  String get moderationMetricsAction => 'YZ metrikleri';

  @override
  String get aiVerdictApprove => 'YZ: uygun';

  @override
  String get aiVerdictReview => 'YZ: incelenmeli';

  @override
  String get aiVerdictReject => 'YZ: kaldırıldı';

  @override
  String get aiVerdictUnscored => 'YZ: skorlanamadı';

  @override
  String aiChip(String verdict, String score) {
    return '$verdict · $score';
  }

  @override
  String aiChipWithCategory(String verdict, String score, String category) {
    return '$verdict · $score · $category';
  }

  @override
  String get aiCategoryToxicity => 'Genel zararlılık';

  @override
  String get aiCategorySevereToxicity => 'Ağır zararlılık';

  @override
  String get aiCategoryObscene => 'Müstehcen dil / küfür';

  @override
  String get aiCategoryIdentityAttack => 'Kimliğe saldırı';

  @override
  String get aiCategoryInsult => 'Hakaret';

  @override
  String get aiCategoryThreat => 'Tehdit';

  @override
  String get aiCategorySexualExplicit => 'Cinsel içerik';

  @override
  String get aiReviewCauseScore => 'Skor inceleme bandında';

  @override
  String get aiReviewCauseLanguage => 'Model bu dili desteklemiyor';

  @override
  String get aiReviewCausePhotos => 'Fotoğraflı anılar incelenir';

  @override
  String get aiReviewCauseUnscored => 'Moderasyon servisine ulaşılamadı';

  @override
  String get memorySectionAi => 'Yapay zekâ değerlendirmesi';

  @override
  String get aiVerdictLabel => 'Öneri';

  @override
  String get aiScoreLabel => 'Genel skor (0–1)';

  @override
  String get aiTopCategoryLabel => 'Belirgin kategori';

  @override
  String get aiReviewCauseLabel => 'İnceleme nedeni';

  @override
  String get aiLexiconLabel => 'Türkçe sözlük eşleşmesi';

  @override
  String get aiLexiconYes => 'Var — skor sözlükle yükseltildi';

  @override
  String get aiLexiconNo => 'Yok';

  @override
  String get aiModelLabel => 'Model';

  @override
  String get aiScoredAtLabel => 'Değerlendirme zamanı';

  @override
  String get aiCategoryScores => 'Kategori skorları';

  @override
  String get aiNotAssessed => 'Bu anı YZ moderasyonu açılmadan paylaşıldı.';

  @override
  String get aiActorName => 'YZ moderasyonu';

  @override
  String get decisionRestoreAi => 'Geri yükle (YZ kararını geri al)';

  @override
  String get dashboardModerationAutoRejected => 'YZ\'nin kaldırdıkları (24 sa)';

  @override
  String get dashboardModerationUnscored => 'Skorlanamayan';

  @override
  String get moderationMetricsTitle => 'YZ moderasyon metrikleri';

  @override
  String moderationMetricsSubtitle(
    String model,
    String approve,
    String reject,
  ) {
    return 'Model $model · otomatik yayın < $approve · inceleme $approve–$reject · otomatik kaldırma ≥ $reject';
  }

  @override
  String get moderationMetricsPeriod => 'Dönem';

  @override
  String moderationMetricsDays(int count) {
    return 'Son $count gün';
  }

  @override
  String get moderationMetricsBack => 'Kuyruğa dön';

  @override
  String moderationMetricsModeOff(String mode) {
    return 'YZ moderasyonu kapalı (mod: $mode). Metrikler yalnızca YZ modunda dolar.';
  }

  @override
  String get metricsShared => 'Paylaşılan anı';

  @override
  String get metricsAutoApproved => 'Otomatik yayınlanan';

  @override
  String get metricsReview => 'İncelemeye düşen';

  @override
  String get metricsAutoRejected => 'Otomatik kaldırılan';

  @override
  String get metricsUnscored => 'Skorlanamayan';

  @override
  String metricsShareOfTotal(String percent) {
    return 'Toplamın %$percent\'i';
  }

  @override
  String get metricsHumanReviewTitle => 'İnsan incelemesi';

  @override
  String get metricsWaiting => 'Kuyrukta bekleyen';

  @override
  String get metricsOldestWaiting => 'En eski bekleyen';

  @override
  String get metricsDecided => 'Karara bağlanan (inceleme bandı)';

  @override
  String get metricsReviewApproved => 'Yayınlanan';

  @override
  String get metricsReviewRejected => 'Kaldırılan';

  @override
  String get metricsMedianDecision => 'Medyan karar süresi';

  @override
  String metricsMinutes(int count) {
    return '$count dk';
  }

  @override
  String metricsHours(int hours, int minutes) {
    return '$hours sa $minutes dk';
  }

  @override
  String metricsDaysDuration(int count) {
    return '$count gün';
  }

  @override
  String get metricsAccuracyTitle => 'Doğruluk (personel düzeltmeleri)';

  @override
  String get metricsAutoRejectRestored => 'Geri yüklenen otomatik kaldırma';

  @override
  String get metricsAutoApproveRemoved => 'Sonradan kaldırılan otomatik yayın';

  @override
  String get metricsOverrideRate => 'YZ kaldırmalarında geri alma oranı';

  @override
  String get metricsReviewApprovalRate => 'İncelemede yayınlanma oranı';

  @override
  String metricsPercent(String percent) {
    return '%$percent';
  }

  @override
  String get metricsHistogramTitle => 'Skor dağılımı ve bugünkü durum';

  @override
  String metricsBinLabel(
    String from,
    String to,
    int approved,
    int pending,
    int rejected,
  ) {
    return '$from–$to · $approved yayında · $pending bekleyen · $rejected kaldırılan';
  }

  @override
  String get metricsCategoriesTitle => 'İncelenen ve kaldırılanlarda kategori';

  @override
  String get metricsModelTitle => 'Model ve eşikler';

  @override
  String get metricsModelVersion => 'Model sürümü';

  @override
  String get metricsApproveThreshold => 'Otomatik yayın';

  @override
  String get metricsRejectThreshold => 'Otomatik kaldırma';

  @override
  String get metricsPhotoRule => 'Fotoğraflı anılar';

  @override
  String get metricsPhotoRuleReview => 'İncelemeye gönderilir';

  @override
  String get metricsPhotoRuleText => 'Metne göre karar';

  @override
  String get metricsLatencyP50 => 'Skorlama süresi (medyan)';

  @override
  String get metricsLatencyP95 => 'Skorlama süresi (p95)';

  @override
  String metricsMs(int count) {
    return '$count ms';
  }

  @override
  String get metricsDailyTitle => 'Günlük karar dağılımı';

  @override
  String metricsDayLine(int approved, int review, int rejected) {
    return '$approved yayın · $review inceleme · $rejected kaldırma';
  }

  @override
  String get metricsNoData => 'Bu dönemde YZ\'nin değerlendirdiği anı yok.';

  @override
  String get editorTabParts => 'Bölümler';

  @override
  String get editorPartsHelp =>
      'VGM verisindeki bölümler (ör. cami ve medrese kısımları). Uygulamada eser sayfasında ayrı başlıklarla gösterilir; Türkçe metin zorunludur, İngilizce boşsa Türkçe gösterilir.';

  @override
  String get editorPartsEmpty => 'Bölüm yok.';

  @override
  String get editorPartsError => 'Her bölümün Türkçe metni olmalıdır.';

  @override
  String editorPartTitle(int index) {
    return 'Bölüm $index';
  }

  @override
  String get editorPartRemove => 'Bölümü kaldır';

  @override
  String get editorPartAdd => 'Bölüm ekle';

  @override
  String get editorPartFieldTitleTr => 'Başlık (Türkçe)';

  @override
  String get editorPartFieldTitleEn => 'Başlık (İngilizce)';

  @override
  String get editorPartFieldDescriptionTr => 'Metin (Türkçe)';

  @override
  String get editorPartFieldDescriptionEn => 'Metin (İngilizce)';

  @override
  String get editorFieldNickname => 'Halk arasındaki adı';

  @override
  String editorImagePart(int index) {
    return 'Bölüm $index';
  }

  @override
  String get catalogFilterLocation => 'Konum';

  @override
  String get catalogLocationPresent => 'Konumu girilmiş';

  @override
  String get catalogLocationMissing => 'Konumu eksik';

  @override
  String get catalogNoLocation => 'Konum yok';

  @override
  String get catalogImport => 'İçe aktar';

  @override
  String get errorConflictImportImages =>
      'Bazı görseller henüz yüklenmedi. İçe aktarımı yeniden başlatın; yalnızca eksik görseller gönderilir.';

  @override
  String get importTitle => 'VGM verisini içe aktar';

  @override
  String get importSubtitle =>
      'Eser ve külliye verisi (JSON) ile görsellerini kataloğa aktarır';

  @override
  String get importSourceTitle => 'Kaynak klasör';

  @override
  String get importSourceHelp =>
      'Veri dosyasını (root42-veri.json) ve images klasörünü içeren klasörü seçin. Görsel yolları veri dosyasına göredir.';

  @override
  String get importNoFolder => 'Klasör seçilmedi';

  @override
  String get importPickFolder => 'Klasör seç';

  @override
  String get importChangeFolder => 'Klasörü değiştir';

  @override
  String get importNoJson => 'Klasörde veri dosyası (.json) bulunamadı.';

  @override
  String get importJsonFile => 'Veri dosyası';

  @override
  String importLocalSummary(int count, String megabytes) {
    return '$count görsel dosyası okundu ($megabytes MB).';
  }

  @override
  String get importReading =>
      'Dosyalar okunuyor ve görsel özetleri hesaplanıyor…';

  @override
  String get importPlanning => 'Sunucu dosyayı denetliyor…';

  @override
  String get importPlanTitle => 'İçe aktarım planı';

  @override
  String get importStatusValid => 'Geçerli';

  @override
  String get importStatusInvalid => 'Hatalı';

  @override
  String get importStatusCommitted => 'Tamamlandı';

  @override
  String get importCountComplexes => 'Külliye';

  @override
  String get importCountWorks => 'Eser';

  @override
  String get importCountParts => 'Bölüm';

  @override
  String get importCountImages => 'Görsel';

  @override
  String importCountImagesValue(int total, int unique) {
    return '$total ($unique farklı dosya)';
  }

  @override
  String get importCountNew => 'Eklenecek kayıt';

  @override
  String get importCountExisting => 'Güncellenecek kayıt';

  @override
  String get importCountMissingImages => 'Yüklenecek görsel';

  @override
  String get importMergeNotice =>
      'Var olan kayıtlarda panelde girilen konum, tarihçe, bani, mimar ve düzeltilmiş tür/dönem korunur. Veri dosyasında konum olmadığından yeni eserler konumu girilene kadar haritada görünmez.';

  @override
  String get importStart => 'İçe aktar';

  @override
  String importStartWithImages(int count) {
    return '$count görseli yükle ve içe aktar';
  }

  @override
  String get importCancel => 'Durdur';

  @override
  String get importCancelling => 'Sürmekte olan yüklemeler bitince durulacak…';

  @override
  String get importProgressTitle => 'İlerleme';

  @override
  String importUploadProgress(int done, int total) {
    return '$done / $total görsel yüklendi';
  }

  @override
  String importUploadFailed(int count) {
    return '$count görsel yüklenemedi. Yeniden başlatınca yalnızca eksikler gönderilir.';
  }

  @override
  String get importCommitting => 'Kayıtlar kataloğa yazılıyor…';

  @override
  String get importResultTitle => 'Sonuç';

  @override
  String get importResultCreated => 'Eklenen eser';

  @override
  String get importResultUpdated => 'Güncellenen eser';

  @override
  String get importResultComplexesCreated => 'Eklenen külliye';

  @override
  String get importResultComplexesUpdated => 'Güncellenen külliye';

  @override
  String get importResultVersion => 'Katalog sürümü';

  @override
  String get importOpenMissingLocation => 'Konumu eksik eserleri aç';

  @override
  String importErrorsTitle(int count) {
    return 'Hatalar ($count)';
  }

  @override
  String importWarningsTitle(int count) {
    return 'Uyarılar ($count)';
  }

  @override
  String importMoreIssues(int count) {
    return '… ve $count bulgu daha';
  }

  @override
  String get importPlanReady => 'Dosya geçerli; içe aktarım planı hazır.';

  @override
  String get importPlanInvalid => 'Dosyada hatalar var; içe aktarılamaz.';

  @override
  String get importDone => 'İçe aktarım tamamlandı.';

  @override
  String get importLeaveTitle => 'İçe aktarım sürüyor';

  @override
  String get importLeaveMessage =>
      'Sayfadan çıkarsanız yükleme durur. Yüklenen görseller saklanır; yeniden başlatınca kalanlar gönderilir.';

  @override
  String get importIssueInvalidJson => 'Dosya şemaya uygun JSON değil';

  @override
  String get importIssueMissingFile => 'Görsel dosyası bulunamadı';

  @override
  String get importIssueFileTooLarge => 'Görsel 5 MB\'tan büyük';

  @override
  String get importIssueFormatVersion => 'Desteklenmeyen biçim sürümü';

  @override
  String get importIssueRequired => 'Zorunlu alan boş';

  @override
  String get importIssueTooLong => 'Alan çok uzun';

  @override
  String get importIssueInvalidKey =>
      'Geçersiz anahtar (küçük harf, rakam ve tire; en çok 111 karakter)';

  @override
  String get importIssueDuplicateKey => 'Anahtar birden çok kez kullanılmış';

  @override
  String get importIssueSlug => 'Geçersiz veya tekrarlanan kısa ad (slug)';

  @override
  String get importIssueUnknownCity => 'Bilinmeyen il kodu';

  @override
  String get importIssueInvalidSrc => 'Geçersiz görsel yolu';

  @override
  String get importIssueTooManyImages => 'Çok fazla görsel';

  @override
  String get importIssueUnknownMember => 'Külliyedeki eser dosyada yok';

  @override
  String get importIssueMemberTwice => 'Eser iki külliyede birden';

  @override
  String get importIssueMemberCity => 'Eserin ili külliyeninkinden farklı';

  @override
  String get importIssueDuplicateMember => 'Külliyede aynı eser iki kez';

  @override
  String get importWarningRenamed =>
      'Külliye anahtarı bir eserle aynı; kimliği değiştirildi';

  @override
  String get importWarningCategory => 'Tür addan çıkarılamadı (Diğer)';

  @override
  String get importWarningDuplicateTitle => 'Aynı adda başka eser var';

  @override
  String get importWarningNoDistrict => 'İlçe adresten çıkarılamadı';

  @override
  String get importWarningNoImages => 'Görseli yok';

  @override
  String get reportsFilterEvidence => 'YZ kanıtı';

  @override
  String get reportsSortEvidence => 'Aciliyet, sonra YZ kanıtı';

  @override
  String get reportSectionEvidence => 'Yapay zekâ kanıt değerlendirmesi';

  @override
  String get evidenceLevelStrong => 'Kanıt güçlü';

  @override
  String get evidenceLevelUnverified => 'Doğrulanamadı';

  @override
  String get evidenceLevelSuspicious => 'Şüpheli';

  @override
  String get evidenceLevelPending => 'Değerlendirilmedi';

  @override
  String evidenceChip(String level) {
    return 'YZ: $level';
  }

  @override
  String evidenceChipSemantics(String level) {
    return 'Yapay zekâ kanıt etiketi: $level';
  }

  @override
  String get evidenceLevelLabel => 'Etiket';

  @override
  String get evidenceHelpStrong =>
      'Olumsuz işaret yok; en az iki bağımsız kanıt ya da bir bağımsız kanıt ve hasar tarif eden açıklama var. Önce bakılabilir.';

  @override
  String get evidenceHelpUnverified =>
      'Olumsuz işaret yok ama kanıt zayıf. Normal inceleme.';

  @override
  String get evidenceHelpSuspicious =>
      'Somut olumsuz işaret var ya da açıklama hasar tarif etmiyor ve hiçbir destek yok. Dikkatli bakın; aciliyet sırası değişmez.';

  @override
  String get evidenceHelpPending =>
      'Bildirim henüz skorlanmadı; arka planda değerlendirilir (moderasyon servisi kapalıysa 24 saat boyunca yeniden denenir).';

  @override
  String get evidenceDisclaimer =>
      'Etiket yalnızca yardımcıdır: durumu değiştirmez ve vatandaşa gösterilmez. YZ bildirimin doğru olup olmadığını bilemez, yalnızca kanıtın gücünü ölçer.';

  @override
  String get evidenceSupports => 'Destekleyen';

  @override
  String get evidenceUndermines => 'Zayıflatan';

  @override
  String get evidenceNeutral => 'Bilgi';

  @override
  String evidenceReasonSemantics(String effect, String reason) {
    return '$effect: $reason';
  }

  @override
  String evidenceLocationOnSite(int distance) {
    return 'Konum yerinde: esere $distance m';
  }

  @override
  String evidenceLocationDistant(int distance) {
    return 'Konum eserden uzak: $distance m';
  }

  @override
  String get evidenceLocationNotProvided => 'Konum eklenmemiş';

  @override
  String evidenceCorroborated(int count) {
    return 'Son 14 günde $count başka hesaptan aynı esere bildirim';
  }

  @override
  String evidencePhotoMatches(String score) {
    return 'Fotoğraf eserin katalog görsellerine benziyor (benzerlik $score)';
  }

  @override
  String evidencePhotoLowSimilarity(String score) {
    return 'Fotoğraf katalog görsellerine benzemiyor (benzerlik $score); hasar yakın çekimi olabilir, olumsuz sayılmaz';
  }

  @override
  String get evidencePhotoNone => 'Fotoğraf eklenmemiş';

  @override
  String evidencePhotoUnreadable(int count) {
    return '$count fotoğraf okunamadı';
  }

  @override
  String evidencePhotoCatalogCopy(String score) {
    return 'Fotoğraf bir katalog görselinin kopyası olabilir (benzerlik $score)';
  }

  @override
  String evidencePhotoNsfw(String score) {
    return 'Müstehcen fotoğraf (olasılık $score)';
  }

  @override
  String evidenceTextDescribesDamage(String score) {
    return 'Açıklama hasar tarif ediyor (skor $score)';
  }

  @override
  String evidenceTextWeakDamage(String score) {
    return 'Açıklamanın hasar tarifi belirsiz (skor $score)';
  }

  @override
  String evidenceTextNotDamage(String score) {
    return 'Açıklama hasar tarif etmiyor (skor $score)';
  }

  @override
  String evidenceTextAbusive(String score) {
    return 'Açıklamada hakaret / zararlı dil (skor $score)';
  }

  @override
  String evidenceTextSpam(String signals) {
    return 'Açıklama spam kuralına uyuyor: $signals';
  }

  @override
  String evidenceTextContact(String signals) {
    return 'Açıklamada iletişim bilgisi var ($signals); kişisel veri olabilir';
  }

  @override
  String evidenceCategorySuggested(String category) {
    return 'Açıklama başka bir türe daha yakın: $category (yalnızca öneri)';
  }

  @override
  String evidenceUrgencyUnsupported(String urgency) {
    return 'Aciliyet \"$urgency\" ama bağımsız kanıt yok (sıra değişmez)';
  }

  @override
  String evidenceUnknown(String code) {
    return 'Diğer sinyal: $code';
  }

  @override
  String get dashboardOpenByEvidence => 'Açık bildirimler, YZ kanıtına göre';

  @override
  String get aiSpamSignalContact => 'iletişim bilgisi';

  @override
  String get aiSpamSignalPromotion => 'ticari teklif';

  @override
  String get aiSpamSignalScam => 'dolandırıcılık kalıbı';

  @override
  String get aiCategoryNsfw => 'Müstehcen fotoğraf';

  @override
  String get aiCategoryUnrelated => 'Eserle ilgisiz';

  @override
  String get aiCategorySpam => 'Spam / reklam';

  @override
  String get aiReviewCauseNsfw => 'Fotoğraf müstehcen olabilir';

  @override
  String get aiReviewCauseSpam => 'İletişim bilgisi var (olası spam)';

  @override
  String get aiReviewCauseUnrelated => 'Fotoğraf esere benzemiyor';

  @override
  String get aiReviewCauseContext => 'Metnin eserle bağlamı zayıf';

  @override
  String get aiSpamLabel => 'Spam skoru';

  @override
  String get aiSpamSignalsLabel => 'Eşleşen spam kuralları';

  @override
  String get aiRelevanceLabel => 'Metnin eserle bağlamı';

  @override
  String get aiNsfwLabel => 'Müstehcenlik (en yüksek fotoğraf)';

  @override
  String get aiSimilarityLabel => 'Esere benzerlik (en düşük fotoğraf)';

  @override
  String get aiVisionModelLabel => 'Görsel model';

  @override
  String get aiContextModelLabel => 'Bağlam indeksi';

  @override
  String get aiPhotoScores => 'Fotoğraf skorları';

  @override
  String aiPhotoLabel(int index) {
    return 'Fotoğraf $index';
  }

  @override
  String aiPhotoScoresValue(String nsfw, String similarity) {
    return 'müstehcenlik $nsfw · esere benzerlik $similarity';
  }

  @override
  String get aiPhotoNoReference => 'referans görseli yok';

  @override
  String get aiPhotoUnreadable => 'okunamadı';
}
