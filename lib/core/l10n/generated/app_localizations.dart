import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('tr'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In tr, this message translates to:
  /// **'Vakıf Atlas Yönetim'**
  String get appTitle;

  /// No description provided for @appBrandSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'VGM Yönetim Paneli'**
  String get appBrandSubtitle;

  /// No description provided for @errorInvalidRequest.
  ///
  /// In tr, this message translates to:
  /// **'Gönderilen istek geçersiz. Lütfen girdiğiniz bilgileri kontrol edin.'**
  String get errorInvalidRequest;

  /// No description provided for @errorNotFound.
  ///
  /// In tr, this message translates to:
  /// **'Kayıt bulunamadı veya bu işlem için yetkiniz yok.'**
  String get errorNotFound;

  /// No description provided for @errorServerUnavailable.
  ///
  /// In tr, this message translates to:
  /// **'Sunucu şu anda geçici olarak hizmet veremiyor. Lütfen birazdan tekrar deneyin.'**
  String get errorServerUnavailable;

  /// No description provided for @errorUnexpected.
  ///
  /// In tr, this message translates to:
  /// **'Beklenmeyen bir hata oluştu. Lütfen tekrar deneyin.'**
  String get errorUnexpected;

  /// No description provided for @errorUnauthorized.
  ///
  /// In tr, this message translates to:
  /// **'Oturum süreniz doldu veya bu işlem için yetkiniz bulunmuyor.'**
  String get errorUnauthorized;

  /// No description provided for @errorTooManyRequests.
  ///
  /// In tr, this message translates to:
  /// **'Çok fazla deneme yapıldı. Lütfen biraz sonra tekrar deneyin.'**
  String get errorTooManyRequests;

  /// No description provided for @errorTooManyRequestsRetry.
  ///
  /// In tr, this message translates to:
  /// **'{minutes, plural, =1{Çok fazla deneme yapıldı. 1 dakika sonra tekrar deneyin.} other{Çok fazla deneme yapıldı. {minutes} dakika sonra tekrar deneyin.}}'**
  String errorTooManyRequestsRetry(int minutes);

  /// No description provided for @errorOffline.
  ///
  /// In tr, this message translates to:
  /// **'İnternet bağlantınız yok. Bağlantınızı kontrol edip tekrar deneyin.'**
  String get errorOffline;

  /// No description provided for @errorServerUnreachable.
  ///
  /// In tr, this message translates to:
  /// **'Vakıf Atlas sunucusuna şu anda ulaşılamıyor. İnternet bağlantınız çalışıyor; lütfen birazdan tekrar deneyin.'**
  String get errorServerUnreachable;

  /// No description provided for @errorCacheRead.
  ///
  /// In tr, this message translates to:
  /// **'Yerel veri okunamadı.'**
  String get errorCacheRead;

  /// No description provided for @errorSecurityViolation.
  ///
  /// In tr, this message translates to:
  /// **'Güvenli bağlantı doğrulanamadı.'**
  String get errorSecurityViolation;

  /// No description provided for @errorInvalidCredentials.
  ///
  /// In tr, this message translates to:
  /// **'E-posta adresi veya şifre hatalı. Bilgilerinizi kontrol edip tekrar deneyin.'**
  String get errorInvalidCredentials;

  /// No description provided for @errorInvalidMfaCode.
  ///
  /// In tr, this message translates to:
  /// **'Doğrulama kodu hatalı. Authenticator uygulamanızdaki güncel kodu girin.'**
  String get errorInvalidMfaCode;

  /// No description provided for @errorMfaExpired.
  ///
  /// In tr, this message translates to:
  /// **'Giriş adımının süresi doldu. Lütfen yeniden giriş yapın.'**
  String get errorMfaExpired;

  /// No description provided for @errorInvalidVerificationCode.
  ///
  /// In tr, this message translates to:
  /// **'Kod hatalı. E-postanızdaki 6 haneli kodu kontrol edip tekrar deneyin.'**
  String get errorInvalidVerificationCode;

  /// No description provided for @errorVerificationCodeExpired.
  ///
  /// In tr, this message translates to:
  /// **'Kodun süresi doldu veya çok fazla hatalı deneme yapıldı. Yeni bir kod isteyin.'**
  String get errorVerificationCodeExpired;

  /// No description provided for @errorWeakPassword.
  ///
  /// In tr, this message translates to:
  /// **'Bu şifre güvenlik kurallarını karşılamıyor. Daha uzun ve tahmin edilmesi zor bir şifre seçin.'**
  String get errorWeakPassword;

  /// No description provided for @errorInvalidCurrentPassword.
  ///
  /// In tr, this message translates to:
  /// **'Mevcut şifreniz hatalı.'**
  String get errorInvalidCurrentPassword;

  /// No description provided for @errorStaleData.
  ///
  /// In tr, this message translates to:
  /// **'Bu kayıt siz incelerken başka bir personel tarafından değiştirildi. Güncel hâlini yükleyip tekrar deneyin.'**
  String get errorStaleData;

  /// No description provided for @errorConflictTransition.
  ///
  /// In tr, this message translates to:
  /// **'Bu durum geçişi artık geçerli değil. Kaydı yenileyin.'**
  String get errorConflictTransition;

  /// No description provided for @errorConflictMonumentExists.
  ///
  /// In tr, this message translates to:
  /// **'Bu kimlikle kayıtlı bir eser zaten var. Farklı bir kimlik seçin.'**
  String get errorConflictMonumentExists;

  /// No description provided for @errorConflictComplexMembers.
  ///
  /// In tr, this message translates to:
  /// **'Külliye yapıları kuralına uymuyor: yapısı olan külliye kaldırılamaz, yapılar başka külliye olamaz.'**
  String get errorConflictComplexMembers;

  /// No description provided for @errorConflictLastAdmin.
  ///
  /// In tr, this message translates to:
  /// **'Sistemde etkin en az bir yönetici kalmalıdır.'**
  String get errorConflictLastAdmin;

  /// No description provided for @errorConflictSelf.
  ///
  /// In tr, this message translates to:
  /// **'Kendi yönetici yetkinizi kaldıramaz veya kendinizi devre dışı bırakamazsınız.'**
  String get errorConflictSelf;

  /// No description provided for @errorConflictInProgress.
  ///
  /// In tr, this message translates to:
  /// **'Aynı işlem hâlâ sürüyor. Birkaç saniye sonra tekrar deneyin.'**
  String get errorConflictInProgress;

  /// No description provided for @errorConflictStaffExists.
  ///
  /// In tr, this message translates to:
  /// **'Bu e-posta adresi zaten personel olarak kayıtlı.'**
  String get errorConflictStaffExists;

  /// No description provided for @badgeOverflow.
  ///
  /// In tr, this message translates to:
  /// **'{max}+'**
  String badgeOverflow(int max);

  /// No description provided for @buttonLoadingSemantics.
  ///
  /// In tr, this message translates to:
  /// **'{label}, yükleniyor'**
  String buttonLoadingSemantics(String label);

  /// No description provided for @passwordShow.
  ///
  /// In tr, this message translates to:
  /// **'Şifreyi göster'**
  String get passwordShow;

  /// No description provided for @passwordHide.
  ///
  /// In tr, this message translates to:
  /// **'Şifreyi gizle'**
  String get passwordHide;

  /// No description provided for @a11yImageHidden.
  ///
  /// In tr, this message translates to:
  /// **'Görsel gizlendi'**
  String get a11yImageHidden;

  /// No description provided for @galleryImageError.
  ///
  /// In tr, this message translates to:
  /// **'Görsel yüklenemedi'**
  String get galleryImageError;

  /// No description provided for @notFoundTitle.
  ///
  /// In tr, this message translates to:
  /// **'Sayfa bulunamadı'**
  String get notFoundTitle;

  /// No description provided for @notFoundBody.
  ///
  /// In tr, this message translates to:
  /// **'Aradığınız sayfa taşınmış veya kaldırılmış olabilir.'**
  String get notFoundBody;

  /// No description provided for @notFoundAction.
  ///
  /// In tr, this message translates to:
  /// **'Panoya dön'**
  String get notFoundAction;

  /// No description provided for @featurePendingHeading.
  ///
  /// In tr, this message translates to:
  /// **'Yakında'**
  String get featurePendingHeading;

  /// No description provided for @featurePendingBody.
  ///
  /// In tr, this message translates to:
  /// **'{feature} bir sonraki sürümde kullanıma açılacak.'**
  String featurePendingBody(String feature);

  /// No description provided for @offlineBannerMessage.
  ///
  /// In tr, this message translates to:
  /// **'Çevrimdışısınız. Değişiklikler bağlantı gelene kadar kaydedilemez.'**
  String get offlineBannerMessage;

  /// No description provided for @offlineAnnouncement.
  ///
  /// In tr, this message translates to:
  /// **'İnternet bağlantısı kesildi'**
  String get offlineAnnouncement;

  /// No description provided for @onlineAnnouncement.
  ///
  /// In tr, this message translates to:
  /// **'İnternet bağlantısı geri geldi'**
  String get onlineAnnouncement;

  /// No description provided for @privacyOverlaySemantics.
  ///
  /// In tr, this message translates to:
  /// **'Vakıf Atlas Yönetim, içerik gizlendi'**
  String get privacyOverlaySemantics;

  /// No description provided for @splashLoadingSemantics.
  ///
  /// In tr, this message translates to:
  /// **'Vakıf Atlas Yönetim açılıyor'**
  String get splashLoadingSemantics;

  /// No description provided for @commonRetry.
  ///
  /// In tr, this message translates to:
  /// **'Tekrar dene'**
  String get commonRetry;

  /// No description provided for @commonCancel.
  ///
  /// In tr, this message translates to:
  /// **'Vazgeç'**
  String get commonCancel;

  /// No description provided for @commonSave.
  ///
  /// In tr, this message translates to:
  /// **'Kaydet'**
  String get commonSave;

  /// No description provided for @commonClose.
  ///
  /// In tr, this message translates to:
  /// **'Kapat'**
  String get commonClose;

  /// No description provided for @commonConfirm.
  ///
  /// In tr, this message translates to:
  /// **'Onayla'**
  String get commonConfirm;

  /// No description provided for @commonReload.
  ///
  /// In tr, this message translates to:
  /// **'Yeniden yükle'**
  String get commonReload;

  /// No description provided for @commonLoading.
  ///
  /// In tr, this message translates to:
  /// **'Yükleniyor'**
  String get commonLoading;

  /// No description provided for @commonLoadMore.
  ///
  /// In tr, this message translates to:
  /// **'Daha fazla yükle'**
  String get commonLoadMore;

  /// No description provided for @commonSearch.
  ///
  /// In tr, this message translates to:
  /// **'Ara'**
  String get commonSearch;

  /// No description provided for @commonClearFilters.
  ///
  /// In tr, this message translates to:
  /// **'Süzgeçleri temizle'**
  String get commonClearFilters;

  /// No description provided for @commonAll.
  ///
  /// In tr, this message translates to:
  /// **'Tümü'**
  String get commonAll;

  /// No description provided for @commonBack.
  ///
  /// In tr, this message translates to:
  /// **'Geri'**
  String get commonBack;

  /// No description provided for @commonCopy.
  ///
  /// In tr, this message translates to:
  /// **'Kopyala'**
  String get commonCopy;

  /// No description provided for @commonCopied.
  ///
  /// In tr, this message translates to:
  /// **'Panoya kopyalandı'**
  String get commonCopied;

  /// No description provided for @commonEdit.
  ///
  /// In tr, this message translates to:
  /// **'Düzenle'**
  String get commonEdit;

  /// No description provided for @commonNone.
  ///
  /// In tr, this message translates to:
  /// **'—'**
  String get commonNone;

  /// No description provided for @commonYes.
  ///
  /// In tr, this message translates to:
  /// **'Evet'**
  String get commonYes;

  /// No description provided for @commonNo.
  ///
  /// In tr, this message translates to:
  /// **'Hayır'**
  String get commonNo;

  /// No description provided for @commonResultCount.
  ///
  /// In tr, this message translates to:
  /// **'{count, plural, =0{Sonuç yok} =1{1 sonuç} other{{count} sonuç}}'**
  String commonResultCount(int count);

  /// No description provided for @commonShownOfTotal.
  ///
  /// In tr, this message translates to:
  /// **'{shown} / {total} gösteriliyor'**
  String commonShownOfTotal(int shown, int total);

  /// No description provided for @commonEmptyTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kayıt yok'**
  String get commonEmptyTitle;

  /// No description provided for @commonEmptyFiltered.
  ///
  /// In tr, this message translates to:
  /// **'Seçili süzgeçlere uyan kayıt yok.'**
  String get commonEmptyFiltered;

  /// No description provided for @commonLoadError.
  ///
  /// In tr, this message translates to:
  /// **'Veriler yüklenemedi'**
  String get commonLoadError;

  /// No description provided for @commonSelectPrompt.
  ///
  /// In tr, this message translates to:
  /// **'Ayrıntıları görmek için listeden bir kayıt seçin.'**
  String get commonSelectPrompt;

  /// No description provided for @commonUnsavedTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kaydedilmemiş değişiklikler'**
  String get commonUnsavedTitle;

  /// No description provided for @commonUnsavedBody.
  ///
  /// In tr, this message translates to:
  /// **'Yaptığınız değişiklikler kaybolacak. Çıkmak istiyor musunuz?'**
  String get commonUnsavedBody;

  /// No description provided for @commonDiscard.
  ///
  /// In tr, this message translates to:
  /// **'Değişiklikleri at'**
  String get commonDiscard;

  /// No description provided for @commonStaleTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kayıt değişti'**
  String get commonStaleTitle;

  /// No description provided for @searchClear.
  ///
  /// In tr, this message translates to:
  /// **'Aramayı temizle'**
  String get searchClear;

  /// No description provided for @navLabel.
  ///
  /// In tr, this message translates to:
  /// **'Ana gezinme'**
  String get navLabel;

  /// No description provided for @navDashboard.
  ///
  /// In tr, this message translates to:
  /// **'Pano'**
  String get navDashboard;

  /// No description provided for @navCatalog.
  ///
  /// In tr, this message translates to:
  /// **'Katalog'**
  String get navCatalog;

  /// No description provided for @navCivilProtection.
  ///
  /// In tr, this message translates to:
  /// **'Sivil Koruma'**
  String get navCivilProtection;

  /// No description provided for @navModeration.
  ///
  /// In tr, this message translates to:
  /// **'Anı Moderasyonu'**
  String get navModeration;

  /// No description provided for @navFeedback.
  ///
  /// In tr, this message translates to:
  /// **'Geri Bildirim'**
  String get navFeedback;

  /// No description provided for @navStaff.
  ///
  /// In tr, this message translates to:
  /// **'Personel'**
  String get navStaff;

  /// No description provided for @navAudit.
  ///
  /// In tr, this message translates to:
  /// **'Denetim Kaydı'**
  String get navAudit;

  /// No description provided for @navProfile.
  ///
  /// In tr, this message translates to:
  /// **'Profilim'**
  String get navProfile;

  /// No description provided for @navSettings.
  ///
  /// In tr, this message translates to:
  /// **'Ayarlar'**
  String get navSettings;

  /// No description provided for @navSignOut.
  ///
  /// In tr, this message translates to:
  /// **'Çıkış yap'**
  String get navSignOut;

  /// No description provided for @navCollapse.
  ///
  /// In tr, this message translates to:
  /// **'Kenar çubuğunu daralt'**
  String get navCollapse;

  /// No description provided for @navExpand.
  ///
  /// In tr, this message translates to:
  /// **'Kenar çubuğunu genişlet'**
  String get navExpand;

  /// No description provided for @navAccountMenu.
  ///
  /// In tr, this message translates to:
  /// **'Hesap menüsü, {name}'**
  String navAccountMenu(String name);

  /// No description provided for @navBadgeSemantics.
  ///
  /// In tr, this message translates to:
  /// **'{label}, {count} bekleyen'**
  String navBadgeSemantics(String label, int count);

  /// No description provided for @roleAdmin.
  ///
  /// In tr, this message translates to:
  /// **'Yönetici'**
  String get roleAdmin;

  /// No description provided for @signOutConfirmTitle.
  ///
  /// In tr, this message translates to:
  /// **'Çıkış yapılsın mı?'**
  String get signOutConfirmTitle;

  /// No description provided for @signOutConfirmBody.
  ///
  /// In tr, this message translates to:
  /// **'Bu cihazdaki personel oturumunuz kapatılacak.'**
  String get signOutConfirmBody;

  /// No description provided for @sessionExpiredMessage.
  ///
  /// In tr, this message translates to:
  /// **'Oturumunuz sona erdi. Lütfen yeniden giriş yapın.'**
  String get sessionExpiredMessage;

  /// No description provided for @sessionIdleMessage.
  ///
  /// In tr, this message translates to:
  /// **'24 saat işlem yapılmadığı için oturumunuz güvenlik amacıyla kapatıldı.'**
  String get sessionIdleMessage;

  /// No description provided for @signInTitle.
  ///
  /// In tr, this message translates to:
  /// **'Personel girişi'**
  String get signInTitle;

  /// No description provided for @signInSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'VGM personeli için yönetim paneli. Erişim rolünüze göre açılır.'**
  String get signInSubtitle;

  /// No description provided for @signInEmail.
  ///
  /// In tr, this message translates to:
  /// **'Kurumsal e-posta'**
  String get signInEmail;

  /// No description provided for @signInPassword.
  ///
  /// In tr, this message translates to:
  /// **'Şifre'**
  String get signInPassword;

  /// No description provided for @signInSubmit.
  ///
  /// In tr, this message translates to:
  /// **'Devam et'**
  String get signInSubmit;

  /// No description provided for @signInForgotPassword.
  ///
  /// In tr, this message translates to:
  /// **'Şifremi unuttum'**
  String get signInForgotPassword;

  /// No description provided for @signInEmailInvalid.
  ///
  /// In tr, this message translates to:
  /// **'Geçerli bir e-posta adresi girin.'**
  String get signInEmailInvalid;

  /// No description provided for @signInPasswordRequired.
  ///
  /// In tr, this message translates to:
  /// **'Şifrenizi girin.'**
  String get signInPasswordRequired;

  /// No description provided for @signInMfaTitle.
  ///
  /// In tr, this message translates to:
  /// **'İki adımlı doğrulama'**
  String get signInMfaTitle;

  /// No description provided for @signInMfaBody.
  ///
  /// In tr, this message translates to:
  /// **'Authenticator uygulamanızdaki 6 haneli kodu girin.'**
  String get signInMfaBody;

  /// No description provided for @signInMfaCode.
  ///
  /// In tr, this message translates to:
  /// **'Doğrulama kodu'**
  String get signInMfaCode;

  /// No description provided for @signInMfaCodeInvalid.
  ///
  /// In tr, this message translates to:
  /// **'6 haneli kodu girin.'**
  String get signInMfaCodeInvalid;

  /// No description provided for @signInMfaVerify.
  ///
  /// In tr, this message translates to:
  /// **'Doğrula ve giriş yap'**
  String get signInMfaVerify;

  /// No description provided for @signInUseRecovery.
  ///
  /// In tr, this message translates to:
  /// **'Kurtarma kodu kullan'**
  String get signInUseRecovery;

  /// No description provided for @signInUseAuthenticator.
  ///
  /// In tr, this message translates to:
  /// **'Authenticator kodu kullan'**
  String get signInUseAuthenticator;

  /// No description provided for @signInRecoveryCode.
  ///
  /// In tr, this message translates to:
  /// **'Kurtarma kodu'**
  String get signInRecoveryCode;

  /// No description provided for @signInRecoveryHint.
  ///
  /// In tr, this message translates to:
  /// **'XXXX-XXXX'**
  String get signInRecoveryHint;

  /// No description provided for @signInRecoveryInvalid.
  ///
  /// In tr, this message translates to:
  /// **'Kurtarma kodu 8 karakterdir (XXXX-XXXX).'**
  String get signInRecoveryInvalid;

  /// No description provided for @signInBack.
  ///
  /// In tr, this message translates to:
  /// **'Farklı hesapla giriş'**
  String get signInBack;

  /// No description provided for @signInExpiresIn.
  ///
  /// In tr, this message translates to:
  /// **'Bu adım {minutes} dakika geçerlidir.'**
  String signInExpiresIn(int minutes);

  /// No description provided for @enrollTitle.
  ///
  /// In tr, this message translates to:
  /// **'Authenticator kurulumu'**
  String get enrollTitle;

  /// No description provided for @enrollBody.
  ///
  /// In tr, this message translates to:
  /// **'Yönetici hesapları iki adımlı doğrulama gerektirir. Google Authenticator, Microsoft Authenticator gibi bir uygulamayla QR kodu tarayın veya kurulum anahtarını elle girin.'**
  String get enrollBody;

  /// No description provided for @enrollQrSemantics.
  ///
  /// In tr, this message translates to:
  /// **'Authenticator kurulum QR kodu. Tarayamıyorsanız aşağıdaki kurulum anahtarını kullanın.'**
  String get enrollQrSemantics;

  /// No description provided for @enrollSecretLabel.
  ///
  /// In tr, this message translates to:
  /// **'Kurulum anahtarı'**
  String get enrollSecretLabel;

  /// No description provided for @enrollAccount.
  ///
  /// In tr, this message translates to:
  /// **'Hesap: {account}'**
  String enrollAccount(String account);

  /// No description provided for @enrollConfirmCode.
  ///
  /// In tr, this message translates to:
  /// **'Uygulamada görünen kod'**
  String get enrollConfirmCode;

  /// No description provided for @enrollConfirm.
  ///
  /// In tr, this message translates to:
  /// **'Kurulumu tamamla'**
  String get enrollConfirm;

  /// No description provided for @recoveryTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kurtarma kodlarınız'**
  String get recoveryTitle;

  /// No description provided for @recoveryBody.
  ///
  /// In tr, this message translates to:
  /// **'Authenticator uygulamanıza erişemezseniz bu kodlardan biriyle giriş yapabilirsiniz. Her kod bir kez kullanılır. Kodları güvenli bir yerde saklayın; bir daha gösterilmeyecek.'**
  String get recoveryBody;

  /// No description provided for @recoveryCopyAll.
  ///
  /// In tr, this message translates to:
  /// **'Tümünü kopyala'**
  String get recoveryCopyAll;

  /// No description provided for @recoveryAcknowledge.
  ///
  /// In tr, this message translates to:
  /// **'Kodları güvenli bir yere kaydettim'**
  String get recoveryAcknowledge;

  /// No description provided for @recoveryContinue.
  ///
  /// In tr, this message translates to:
  /// **'Panele geç'**
  String get recoveryContinue;

  /// No description provided for @resetTitle.
  ///
  /// In tr, this message translates to:
  /// **'Şifre belirle / sıfırla'**
  String get resetTitle;

  /// No description provided for @resetBody.
  ///
  /// In tr, this message translates to:
  /// **'Kurumsal e-posta adresinizi girin. Hesabınız varsa 6 haneli bir kod göndereceğiz.'**
  String get resetBody;

  /// No description provided for @resetSendCode.
  ///
  /// In tr, this message translates to:
  /// **'Kod gönder'**
  String get resetSendCode;

  /// No description provided for @resetCodeSent.
  ///
  /// In tr, this message translates to:
  /// **'Kod gönderildi. E-postanızdaki kodu ve yeni şifrenizi girin.'**
  String get resetCodeSent;

  /// No description provided for @resetCode.
  ///
  /// In tr, this message translates to:
  /// **'E-postadaki kod'**
  String get resetCode;

  /// No description provided for @resetNewPassword.
  ///
  /// In tr, this message translates to:
  /// **'Yeni şifre'**
  String get resetNewPassword;

  /// No description provided for @resetPasswordHint.
  ///
  /// In tr, this message translates to:
  /// **'En az 12 karakter. Uzun bir parola cümlesi en güvenlisidir.'**
  String get resetPasswordHint;

  /// No description provided for @resetPasswordTooShort.
  ///
  /// In tr, this message translates to:
  /// **'Şifre en az 12 karakter olmalıdır.'**
  String get resetPasswordTooShort;

  /// No description provided for @resetSubmit.
  ///
  /// In tr, this message translates to:
  /// **'Şifreyi kaydet'**
  String get resetSubmit;

  /// No description provided for @resetDone.
  ///
  /// In tr, this message translates to:
  /// **'Şifreniz kaydedildi. Şimdi giriş yapabilirsiniz.'**
  String get resetDone;

  /// No description provided for @resetBackToSignIn.
  ///
  /// In tr, this message translates to:
  /// **'Girişe dön'**
  String get resetBackToSignIn;

  /// No description provided for @dashboardTitle.
  ///
  /// In tr, this message translates to:
  /// **'Pano'**
  String get dashboardTitle;

  /// No description provided for @dashboardGreeting.
  ///
  /// In tr, this message translates to:
  /// **'Hoş geldiniz, {name}'**
  String dashboardGreeting(String name);

  /// No description provided for @dashboardUpdatedAt.
  ///
  /// In tr, this message translates to:
  /// **'Son güncelleme: {time}'**
  String dashboardUpdatedAt(String time);

  /// No description provided for @dashboardRefresh.
  ///
  /// In tr, this message translates to:
  /// **'Yenile'**
  String get dashboardRefresh;

  /// No description provided for @dashboardSectionError.
  ///
  /// In tr, this message translates to:
  /// **'Bu bölümün özeti alınamadı.'**
  String get dashboardSectionError;

  /// No description provided for @dashboardReportsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Sivil Koruma bildirimleri'**
  String get dashboardReportsTitle;

  /// No description provided for @dashboardReportsCritical.
  ///
  /// In tr, this message translates to:
  /// **'{count} kritik'**
  String dashboardReportsCritical(int count);

  /// No description provided for @dashboardModerationTitle.
  ///
  /// In tr, this message translates to:
  /// **'Anı Köşesi moderasyonu'**
  String get dashboardModerationTitle;

  /// No description provided for @dashboardModerationPending.
  ///
  /// In tr, this message translates to:
  /// **'{count} onay bekliyor'**
  String dashboardModerationPending(int count);

  /// No description provided for @dashboardModerationReported.
  ///
  /// In tr, this message translates to:
  /// **'{count} bildirilen anı'**
  String dashboardModerationReported(int count);

  /// No description provided for @dashboardFeedbackTitle.
  ///
  /// In tr, this message translates to:
  /// **'Geri bildirim'**
  String get dashboardFeedbackTitle;

  /// No description provided for @dashboardFeedbackRating.
  ///
  /// In tr, this message translates to:
  /// **'Ortalama puan {rating} ({count} değerlendirme)'**
  String dashboardFeedbackRating(String rating, int count);

  /// No description provided for @dashboardFeedbackNoRating.
  ///
  /// In tr, this message translates to:
  /// **'Henüz puan verilmedi'**
  String get dashboardFeedbackNoRating;

  /// No description provided for @dashboardCatalogTitle.
  ///
  /// In tr, this message translates to:
  /// **'Katalog'**
  String get dashboardCatalogTitle;

  /// No description provided for @dashboardCatalogArchived.
  ///
  /// In tr, this message translates to:
  /// **'{count} yayından kaldırıldı'**
  String dashboardCatalogArchived(int count);

  /// No description provided for @dashboardNoSections.
  ///
  /// In tr, this message translates to:
  /// **'Rolünüz henüz bir yönetim bölümü açmıyor. Yetki için VGM yöneticinize başvurun.'**
  String get dashboardNoSections;

  /// No description provided for @reportsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Sivil Koruma incelemesi'**
  String get reportsTitle;

  /// No description provided for @reportsSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Vatandaşların eserlerde gördüğü hasar bildirimleri. Durum değişikliği vatandaşa notuyla birlikte gösterilir.'**
  String get reportsSubtitle;

  /// No description provided for @reportsSearch.
  ///
  /// In tr, this message translates to:
  /// **'Kayıt numarası (SK-2026-…)'**
  String get reportsSearch;

  /// No description provided for @reportsListLabel.
  ///
  /// In tr, this message translates to:
  /// **'Bildirim kuyruğu'**
  String get reportsListLabel;

  /// No description provided for @reportsDetailLabel.
  ///
  /// In tr, this message translates to:
  /// **'Bildirim ayrıntısı'**
  String get reportsDetailLabel;

  /// No description provided for @reportsFilterStatus.
  ///
  /// In tr, this message translates to:
  /// **'Durum'**
  String get reportsFilterStatus;

  /// No description provided for @reportsFilterUrgency.
  ///
  /// In tr, this message translates to:
  /// **'Aciliyet'**
  String get reportsFilterUrgency;

  /// No description provided for @reportsFilterCategory.
  ///
  /// In tr, this message translates to:
  /// **'Hasar türü'**
  String get reportsFilterCategory;

  /// No description provided for @reportsFilterOpen.
  ///
  /// In tr, this message translates to:
  /// **'Açık'**
  String get reportsFilterOpen;

  /// No description provided for @reportsSort.
  ///
  /// In tr, this message translates to:
  /// **'Sıralama'**
  String get reportsSort;

  /// No description provided for @reportsSortNewest.
  ///
  /// In tr, this message translates to:
  /// **'En yeni'**
  String get reportsSortNewest;

  /// No description provided for @reportsSortOldest.
  ///
  /// In tr, this message translates to:
  /// **'En eski'**
  String get reportsSortOldest;

  /// No description provided for @reportsSortUrgency.
  ///
  /// In tr, this message translates to:
  /// **'Aciliyete göre'**
  String get reportsSortUrgency;

  /// No description provided for @reportsEmpty.
  ///
  /// In tr, this message translates to:
  /// **'Bu süzgeçlere uyan bildirim yok.'**
  String get reportsEmpty;

  /// No description provided for @reportStatusReceived.
  ///
  /// In tr, this message translates to:
  /// **'Alındı'**
  String get reportStatusReceived;

  /// No description provided for @reportStatusInReview.
  ///
  /// In tr, this message translates to:
  /// **'İnceleniyor'**
  String get reportStatusInReview;

  /// No description provided for @reportStatusForwarded.
  ///
  /// In tr, this message translates to:
  /// **'Yetkili birime iletildi'**
  String get reportStatusForwarded;

  /// No description provided for @reportStatusResolved.
  ///
  /// In tr, this message translates to:
  /// **'Sonuçlandı'**
  String get reportStatusResolved;

  /// No description provided for @reportStatusClosed.
  ///
  /// In tr, this message translates to:
  /// **'Kapatıldı'**
  String get reportStatusClosed;

  /// No description provided for @urgencyCritical.
  ///
  /// In tr, this message translates to:
  /// **'Kritik'**
  String get urgencyCritical;

  /// No description provided for @urgencyHigh.
  ///
  /// In tr, this message translates to:
  /// **'Yüksek'**
  String get urgencyHigh;

  /// No description provided for @urgencyMedium.
  ///
  /// In tr, this message translates to:
  /// **'Orta'**
  String get urgencyMedium;

  /// No description provided for @urgencyLow.
  ///
  /// In tr, this message translates to:
  /// **'Düşük'**
  String get urgencyLow;

  /// No description provided for @urgencyLabel.
  ///
  /// In tr, this message translates to:
  /// **'Aciliyet: {level}'**
  String urgencyLabel(String level);

  /// No description provided for @categoryStructuralDamage.
  ///
  /// In tr, this message translates to:
  /// **'Yapısal hasar'**
  String get categoryStructuralDamage;

  /// No description provided for @categoryCollapseRisk.
  ///
  /// In tr, this message translates to:
  /// **'Çökme riski'**
  String get categoryCollapseRisk;

  /// No description provided for @categoryVandalism.
  ///
  /// In tr, this message translates to:
  /// **'Vandalizm'**
  String get categoryVandalism;

  /// No description provided for @categoryTheft.
  ///
  /// In tr, this message translates to:
  /// **'Hırsızlık'**
  String get categoryTheft;

  /// No description provided for @categoryFireOrWater.
  ///
  /// In tr, this message translates to:
  /// **'Yangın / su hasarı'**
  String get categoryFireOrWater;

  /// No description provided for @categoryUnauthorizedWork.
  ///
  /// In tr, this message translates to:
  /// **'İzinsiz müdahale'**
  String get categoryUnauthorizedWork;

  /// No description provided for @categoryOther.
  ///
  /// In tr, this message translates to:
  /// **'Diğer'**
  String get categoryOther;

  /// No description provided for @verificationNotProvided.
  ///
  /// In tr, this message translates to:
  /// **'Konum paylaşılmadı'**
  String get verificationNotProvided;

  /// No description provided for @verificationOnSite.
  ///
  /// In tr, this message translates to:
  /// **'Yerinde (esere {distance} m)'**
  String verificationOnSite(int distance);

  /// No description provided for @verificationDistant.
  ///
  /// In tr, this message translates to:
  /// **'Uzakta (esere {distance} m)'**
  String verificationDistant(int distance);

  /// No description provided for @reportSectionSummary.
  ///
  /// In tr, this message translates to:
  /// **'Bildirim'**
  String get reportSectionSummary;

  /// No description provided for @reportSectionPhotos.
  ///
  /// In tr, this message translates to:
  /// **'Fotoğraflar'**
  String get reportSectionPhotos;

  /// No description provided for @reportSectionLocation.
  ///
  /// In tr, this message translates to:
  /// **'Konum'**
  String get reportSectionLocation;

  /// No description provided for @reportSectionHistory.
  ///
  /// In tr, this message translates to:
  /// **'Süreç'**
  String get reportSectionHistory;

  /// No description provided for @reportSectionAction.
  ///
  /// In tr, this message translates to:
  /// **'Durumu güncelle'**
  String get reportSectionAction;

  /// No description provided for @reportMonument.
  ///
  /// In tr, this message translates to:
  /// **'Eser'**
  String get reportMonument;

  /// No description provided for @reportPlace.
  ///
  /// In tr, this message translates to:
  /// **'Yer'**
  String get reportPlace;

  /// No description provided for @reportCategory.
  ///
  /// In tr, this message translates to:
  /// **'Hasar türü'**
  String get reportCategory;

  /// No description provided for @reportCreatedAt.
  ///
  /// In tr, this message translates to:
  /// **'Bildirim tarihi'**
  String get reportCreatedAt;

  /// No description provided for @reportReference.
  ///
  /// In tr, this message translates to:
  /// **'Kayıt numarası'**
  String get reportReference;

  /// No description provided for @reportAnonymized.
  ///
  /// In tr, this message translates to:
  /// **'Bildiren hesabını sildi; kayıt kişiyle bağlantısız korunuyor.'**
  String get reportAnonymized;

  /// No description provided for @reportNoPhotos.
  ///
  /// In tr, this message translates to:
  /// **'Fotoğraf eklenmemiş.'**
  String get reportNoPhotos;

  /// No description provided for @reportPhotoSemantics.
  ///
  /// In tr, this message translates to:
  /// **'Bildirim fotoğrafı {index} / {count}'**
  String reportPhotoSemantics(int index, int count);

  /// No description provided for @reportCoordinates.
  ///
  /// In tr, this message translates to:
  /// **'{latitude}, {longitude} (±{accuracy} m)'**
  String reportCoordinates(String latitude, String longitude, int accuracy);

  /// No description provided for @reportCopyCoordinates.
  ///
  /// In tr, this message translates to:
  /// **'Koordinatları kopyala'**
  String get reportCopyCoordinates;

  /// No description provided for @reportOpenMap.
  ///
  /// In tr, this message translates to:
  /// **'OpenStreetMap\'te aç'**
  String get reportOpenMap;

  /// No description provided for @reportLocationRetention.
  ///
  /// In tr, this message translates to:
  /// **'Ham konum yalnızca VGM incelemesi içindir; rapor sonuçlandıktan 90 gün sonra silinir.'**
  String get reportLocationRetention;

  /// No description provided for @reportHistoryBy.
  ///
  /// In tr, this message translates to:
  /// **'{name} tarafından'**
  String reportHistoryBy(String name);

  /// No description provided for @reportHistoryNoteCitizen.
  ///
  /// In tr, this message translates to:
  /// **'Vatandaşa not: {note}'**
  String reportHistoryNoteCitizen(String note);

  /// No description provided for @reportHistoryNoteInternal.
  ///
  /// In tr, this message translates to:
  /// **'İç not: {note}'**
  String reportHistoryNoteInternal(String note);

  /// No description provided for @reportFinalStatus.
  ///
  /// In tr, this message translates to:
  /// **'Bu bildirim sonuçlandı; durumu artık değiştirilemez.'**
  String get reportFinalStatus;

  /// No description provided for @reportNextStatus.
  ///
  /// In tr, this message translates to:
  /// **'Yeni durum'**
  String get reportNextStatus;

  /// No description provided for @reportNoteCitizen.
  ///
  /// In tr, this message translates to:
  /// **'Vatandaşa not (isteğe bağlı)'**
  String get reportNoteCitizen;

  /// No description provided for @reportNoteCitizenHelp.
  ///
  /// In tr, this message translates to:
  /// **'Bildirimlerim ekranında görünür. Kişisel veri yazmayın.'**
  String get reportNoteCitizenHelp;

  /// No description provided for @reportNoteInternal.
  ///
  /// In tr, this message translates to:
  /// **'İç not (yalnızca personel)'**
  String get reportNoteInternal;

  /// No description provided for @reportNoteTooLong.
  ///
  /// In tr, this message translates to:
  /// **'Not en fazla 1000 karakter olabilir.'**
  String get reportNoteTooLong;

  /// No description provided for @reportUpdate.
  ///
  /// In tr, this message translates to:
  /// **'Durumu güncelle'**
  String get reportUpdate;

  /// No description provided for @reportUpdated.
  ///
  /// In tr, this message translates to:
  /// **'Bildirim durumu güncellendi: {status}'**
  String reportUpdated(String status);

  /// No description provided for @reportConfirmFinalTitle.
  ///
  /// In tr, this message translates to:
  /// **'Bildirim sonuçlandırılsın mı?'**
  String get reportConfirmFinalTitle;

  /// No description provided for @reportConfirmFinalBody.
  ///
  /// In tr, this message translates to:
  /// **'\"{status}\" sonuç durumudur; sonra değiştirilemez ve ham konum saklama süresi başlar.'**
  String reportConfirmFinalBody(String status);

  /// No description provided for @reportTileSemantics.
  ///
  /// In tr, this message translates to:
  /// **'{reference}, {monument}, {status}, aciliyet {urgency}'**
  String reportTileSemantics(
    String reference,
    String monument,
    String status,
    String urgency,
  );

  /// No description provided for @moderationTitle.
  ///
  /// In tr, this message translates to:
  /// **'Anı Köşesi moderasyonu'**
  String get moderationTitle;

  /// No description provided for @moderationSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Onay bekleyen anılar ve kullanıcı bildirimleri (şikâyetler). 3 farklı bildirim alan anı inceleme bitene kadar herkese gizlenir.'**
  String get moderationSubtitle;

  /// No description provided for @moderationSearch.
  ///
  /// In tr, this message translates to:
  /// **'Metin veya yazar ara'**
  String get moderationSearch;

  /// No description provided for @moderationListLabel.
  ///
  /// In tr, this message translates to:
  /// **'Moderasyon kuyruğu'**
  String get moderationListLabel;

  /// No description provided for @moderationDetailLabel.
  ///
  /// In tr, this message translates to:
  /// **'Anı ayrıntısı'**
  String get moderationDetailLabel;

  /// No description provided for @moderationQueuePending.
  ///
  /// In tr, this message translates to:
  /// **'Onay bekleyen'**
  String get moderationQueuePending;

  /// No description provided for @moderationQueueReported.
  ///
  /// In tr, this message translates to:
  /// **'Bildirilen'**
  String get moderationQueueReported;

  /// No description provided for @moderationQueueRejected.
  ///
  /// In tr, this message translates to:
  /// **'Yayından kaldırılan'**
  String get moderationQueueRejected;

  /// No description provided for @moderationQueueAll.
  ///
  /// In tr, this message translates to:
  /// **'Tümü'**
  String get moderationQueueAll;

  /// No description provided for @moderationEmptyPending.
  ///
  /// In tr, this message translates to:
  /// **'Onay bekleyen anı yok.'**
  String get moderationEmptyPending;

  /// No description provided for @moderationEmptyReported.
  ///
  /// In tr, this message translates to:
  /// **'Açık bildirimi olan anı yok.'**
  String get moderationEmptyReported;

  /// No description provided for @memoryStatusApproved.
  ///
  /// In tr, this message translates to:
  /// **'Yayında'**
  String get memoryStatusApproved;

  /// No description provided for @memoryStatusPending.
  ///
  /// In tr, this message translates to:
  /// **'Onay bekliyor'**
  String get memoryStatusPending;

  /// No description provided for @memoryStatusRejected.
  ///
  /// In tr, this message translates to:
  /// **'Yayından kaldırıldı'**
  String get memoryStatusRejected;

  /// No description provided for @memoryHiddenByReports.
  ///
  /// In tr, this message translates to:
  /// **'Bildirimlerle gizlendi'**
  String get memoryHiddenByReports;

  /// No description provided for @memoryOpenReports.
  ///
  /// In tr, this message translates to:
  /// **'{count, plural, =1{1 açık bildirim} other{{count} açık bildirim}}'**
  String memoryOpenReports(int count);

  /// No description provided for @reasonOffensive.
  ///
  /// In tr, this message translates to:
  /// **'Saldırgan / hakaret'**
  String get reasonOffensive;

  /// No description provided for @reasonInappropriate.
  ///
  /// In tr, this message translates to:
  /// **'Uygunsuz içerik'**
  String get reasonInappropriate;

  /// No description provided for @reasonSpam.
  ///
  /// In tr, this message translates to:
  /// **'Spam / reklam'**
  String get reasonSpam;

  /// No description provided for @reasonPersonalInfo.
  ///
  /// In tr, this message translates to:
  /// **'Kişisel bilgi içeriyor'**
  String get reasonPersonalInfo;

  /// No description provided for @reasonUnrelated.
  ///
  /// In tr, this message translates to:
  /// **'Eserle ilgisiz'**
  String get reasonUnrelated;

  /// No description provided for @reasonOther.
  ///
  /// In tr, this message translates to:
  /// **'Diğer'**
  String get reasonOther;

  /// No description provided for @memoryTileSemantics.
  ///
  /// In tr, this message translates to:
  /// **'{monument}, {author}, {status}'**
  String memoryTileSemantics(String monument, String author, String status);

  /// No description provided for @memorySectionContent.
  ///
  /// In tr, this message translates to:
  /// **'Anı'**
  String get memorySectionContent;

  /// No description provided for @memorySectionReports.
  ///
  /// In tr, this message translates to:
  /// **'Bildirimler'**
  String get memorySectionReports;

  /// No description provided for @memorySectionModeration.
  ///
  /// In tr, this message translates to:
  /// **'Moderasyon kararı'**
  String get memorySectionModeration;

  /// No description provided for @memoryAuthor.
  ///
  /// In tr, this message translates to:
  /// **'Yazar'**
  String get memoryAuthor;

  /// No description provided for @memoryMonument.
  ///
  /// In tr, this message translates to:
  /// **'Eser'**
  String get memoryMonument;

  /// No description provided for @memoryDate.
  ///
  /// In tr, this message translates to:
  /// **'Anı tarihi'**
  String get memoryDate;

  /// No description provided for @memorySharedAt.
  ///
  /// In tr, this message translates to:
  /// **'Paylaşım'**
  String get memorySharedAt;

  /// No description provided for @memoryNoReports.
  ///
  /// In tr, this message translates to:
  /// **'Bu anı için bildirim yok.'**
  String get memoryNoReports;

  /// No description provided for @memoryReportResolutionOpen.
  ///
  /// In tr, this message translates to:
  /// **'Açık'**
  String get memoryReportResolutionOpen;

  /// No description provided for @memoryReportResolutionUpheld.
  ///
  /// In tr, this message translates to:
  /// **'Haklı bulundu'**
  String get memoryReportResolutionUpheld;

  /// No description provided for @memoryReportResolutionDismissed.
  ///
  /// In tr, this message translates to:
  /// **'Yersiz bulundu'**
  String get memoryReportResolutionDismissed;

  /// No description provided for @memoryLastDecision.
  ///
  /// In tr, this message translates to:
  /// **'Son karar: {name}, {date}'**
  String memoryLastDecision(String name, String date);

  /// No description provided for @memoryPhotoSemantics.
  ///
  /// In tr, this message translates to:
  /// **'Anı fotoğrafı {index} / {count}'**
  String memoryPhotoSemantics(int index, int count);

  /// No description provided for @decisionApprove.
  ///
  /// In tr, this message translates to:
  /// **'Yayınla'**
  String get decisionApprove;

  /// No description provided for @decisionKeep.
  ///
  /// In tr, this message translates to:
  /// **'Bildirimleri reddet, yayında tut'**
  String get decisionKeep;

  /// No description provided for @decisionRestore.
  ///
  /// In tr, this message translates to:
  /// **'Geri yükle'**
  String get decisionRestore;

  /// No description provided for @decisionReject.
  ///
  /// In tr, this message translates to:
  /// **'Yayından kaldır'**
  String get decisionReject;

  /// No description provided for @decisionReason.
  ///
  /// In tr, this message translates to:
  /// **'Kaldırma nedeni'**
  String get decisionReason;

  /// No description provided for @decisionReasonRequired.
  ///
  /// In tr, this message translates to:
  /// **'Kaldırma nedeni seçin.'**
  String get decisionReasonRequired;

  /// No description provided for @decisionNote.
  ///
  /// In tr, this message translates to:
  /// **'İç not (isteğe bağlı, yazara gösterilmez)'**
  String get decisionNote;

  /// No description provided for @decisionRejectConfirmTitle.
  ///
  /// In tr, this message translates to:
  /// **'Anı yayından kaldırılsın mı?'**
  String get decisionRejectConfirmTitle;

  /// No description provided for @decisionRejectConfirmBody.
  ///
  /// In tr, this message translates to:
  /// **'Anı herkese gizlenir; açık bildirimler haklı sayılır. Kararı daha sonra geri yükleyerek değiştirebilirsiniz.'**
  String get decisionRejectConfirmBody;

  /// No description provided for @decisionSaved.
  ///
  /// In tr, this message translates to:
  /// **'Moderasyon kararı kaydedildi: {status}'**
  String decisionSaved(String status);

  /// No description provided for @feedbackTitle.
  ///
  /// In tr, this message translates to:
  /// **'Geri bildirim'**
  String get feedbackTitle;

  /// No description provided for @feedbackSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Vatandaş uygulamasından gelen öneri, hata ve erişilebilirlik bildirimleri.'**
  String get feedbackSubtitle;

  /// No description provided for @feedbackSearch.
  ///
  /// In tr, this message translates to:
  /// **'Mesajda ara'**
  String get feedbackSearch;

  /// No description provided for @feedbackListLabel.
  ///
  /// In tr, this message translates to:
  /// **'Geri bildirim listesi'**
  String get feedbackListLabel;

  /// No description provided for @feedbackDetailLabel.
  ///
  /// In tr, this message translates to:
  /// **'Geri bildirim ayrıntısı'**
  String get feedbackDetailLabel;

  /// No description provided for @feedbackFilterStatus.
  ///
  /// In tr, this message translates to:
  /// **'Durum'**
  String get feedbackFilterStatus;

  /// No description provided for @feedbackFilterCategory.
  ///
  /// In tr, this message translates to:
  /// **'Konu'**
  String get feedbackFilterCategory;

  /// No description provided for @feedbackFilterRating.
  ///
  /// In tr, this message translates to:
  /// **'Puan'**
  String get feedbackFilterRating;

  /// No description provided for @feedbackNoRating.
  ///
  /// In tr, this message translates to:
  /// **'Puansız'**
  String get feedbackNoRating;

  /// No description provided for @feedbackStatusNew.
  ///
  /// In tr, this message translates to:
  /// **'Yeni'**
  String get feedbackStatusNew;

  /// No description provided for @feedbackStatusInProgress.
  ///
  /// In tr, this message translates to:
  /// **'İşlemde'**
  String get feedbackStatusInProgress;

  /// No description provided for @feedbackStatusDone.
  ///
  /// In tr, this message translates to:
  /// **'Tamamlandı'**
  String get feedbackStatusDone;

  /// No description provided for @feedbackStatusDismissed.
  ///
  /// In tr, this message translates to:
  /// **'Gereksiz'**
  String get feedbackStatusDismissed;

  /// No description provided for @feedbackCategorySuggestion.
  ///
  /// In tr, this message translates to:
  /// **'Öneri'**
  String get feedbackCategorySuggestion;

  /// No description provided for @feedbackCategoryBug.
  ///
  /// In tr, this message translates to:
  /// **'Hata'**
  String get feedbackCategoryBug;

  /// No description provided for @feedbackCategoryAccessibility.
  ///
  /// In tr, this message translates to:
  /// **'Erişilebilirlik'**
  String get feedbackCategoryAccessibility;

  /// No description provided for @feedbackCategoryContent.
  ///
  /// In tr, this message translates to:
  /// **'Eser bilgisi'**
  String get feedbackCategoryContent;

  /// No description provided for @feedbackCategoryOther.
  ///
  /// In tr, this message translates to:
  /// **'Diğer'**
  String get feedbackCategoryOther;

  /// No description provided for @feedbackRatingValue.
  ///
  /// In tr, this message translates to:
  /// **'{rating} / 5 yıldız'**
  String feedbackRatingValue(int rating);

  /// No description provided for @feedbackEmptyMessage.
  ///
  /// In tr, this message translates to:
  /// **'(Yalnızca puan verildi)'**
  String get feedbackEmptyMessage;

  /// No description provided for @feedbackSectionMessage.
  ///
  /// In tr, this message translates to:
  /// **'Mesaj'**
  String get feedbackSectionMessage;

  /// No description provided for @feedbackSectionContext.
  ///
  /// In tr, this message translates to:
  /// **'Bağlam'**
  String get feedbackSectionContext;

  /// No description provided for @feedbackSectionTriage.
  ///
  /// In tr, this message translates to:
  /// **'Triaj'**
  String get feedbackSectionTriage;

  /// No description provided for @feedbackAppVersion.
  ///
  /// In tr, this message translates to:
  /// **'Uygulama sürümü'**
  String get feedbackAppVersion;

  /// No description provided for @feedbackPlatform.
  ///
  /// In tr, this message translates to:
  /// **'Platform'**
  String get feedbackPlatform;

  /// No description provided for @feedbackLanguage.
  ///
  /// In tr, this message translates to:
  /// **'Dil'**
  String get feedbackLanguage;

  /// No description provided for @feedbackSender.
  ///
  /// In tr, this message translates to:
  /// **'Gönderen'**
  String get feedbackSender;

  /// No description provided for @feedbackFromAccount.
  ///
  /// In tr, this message translates to:
  /// **'Oturum açık hesap'**
  String get feedbackFromAccount;

  /// No description provided for @feedbackFromGuest.
  ///
  /// In tr, this message translates to:
  /// **'Misafir'**
  String get feedbackFromGuest;

  /// No description provided for @feedbackReceivedAt.
  ///
  /// In tr, this message translates to:
  /// **'Alındı'**
  String get feedbackReceivedAt;

  /// No description provided for @feedbackHandledBy.
  ///
  /// In tr, this message translates to:
  /// **'Son işlem: {name}, {date}'**
  String feedbackHandledBy(String name, String date);

  /// No description provided for @feedbackStaffNote.
  ///
  /// In tr, this message translates to:
  /// **'İç not (gönderene gösterilmez)'**
  String get feedbackStaffNote;

  /// No description provided for @feedbackSaveTriage.
  ///
  /// In tr, this message translates to:
  /// **'Kaydet'**
  String get feedbackSaveTriage;

  /// No description provided for @feedbackTriaged.
  ///
  /// In tr, this message translates to:
  /// **'Geri bildirim durumu: {status}'**
  String feedbackTriaged(String status);

  /// No description provided for @feedbackTileSemantics.
  ///
  /// In tr, this message translates to:
  /// **'{category}, {status}, {date}'**
  String feedbackTileSemantics(String category, String status, String date);

  /// No description provided for @staffTitle.
  ///
  /// In tr, this message translates to:
  /// **'Personel'**
  String get staffTitle;

  /// No description provided for @staffSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Yönetim paneline erişen VGM personeli ve rolleri. Her rol yalnızca kendi bölümünü açar.'**
  String get staffSubtitle;

  /// No description provided for @staffSearch.
  ///
  /// In tr, this message translates to:
  /// **'Ad veya e-posta ara'**
  String get staffSearch;

  /// No description provided for @staffListLabel.
  ///
  /// In tr, this message translates to:
  /// **'Personel listesi'**
  String get staffListLabel;

  /// No description provided for @staffDetailLabel.
  ///
  /// In tr, this message translates to:
  /// **'Personel ayrıntısı'**
  String get staffDetailLabel;

  /// No description provided for @staffFilterRole.
  ///
  /// In tr, this message translates to:
  /// **'Rol'**
  String get staffFilterRole;

  /// No description provided for @staffFilterStatus.
  ///
  /// In tr, this message translates to:
  /// **'Durum'**
  String get staffFilterStatus;

  /// No description provided for @staffStatusActive.
  ///
  /// In tr, this message translates to:
  /// **'Etkin'**
  String get staffStatusActive;

  /// No description provided for @staffStatusDisabled.
  ///
  /// In tr, this message translates to:
  /// **'Devre dışı'**
  String get staffStatusDisabled;

  /// No description provided for @staffInvite.
  ///
  /// In tr, this message translates to:
  /// **'Personel davet et'**
  String get staffInvite;

  /// No description provided for @staffInviteTitle.
  ///
  /// In tr, this message translates to:
  /// **'Personel davet et'**
  String get staffInviteTitle;

  /// No description provided for @staffInviteBody.
  ///
  /// In tr, this message translates to:
  /// **'Davet edilen kişiye e-posta gönderilir; şifresini \"Şifremi unuttum\" ile belirler ve ilk girişte Authenticator kurar.'**
  String get staffInviteBody;

  /// No description provided for @staffInviteName.
  ///
  /// In tr, this message translates to:
  /// **'Ad soyad'**
  String get staffInviteName;

  /// No description provided for @staffInviteNameRequired.
  ///
  /// In tr, this message translates to:
  /// **'Ad soyad girin.'**
  String get staffInviteNameRequired;

  /// No description provided for @staffInviteRolesRequired.
  ///
  /// In tr, this message translates to:
  /// **'En az bir rol seçin.'**
  String get staffInviteRolesRequired;

  /// No description provided for @staffInviteSend.
  ///
  /// In tr, this message translates to:
  /// **'Davet gönder'**
  String get staffInviteSend;

  /// No description provided for @staffInvited.
  ///
  /// In tr, this message translates to:
  /// **'{name} davet edildi'**
  String staffInvited(String name);

  /// No description provided for @staffRoles.
  ///
  /// In tr, this message translates to:
  /// **'Roller'**
  String get staffRoles;

  /// No description provided for @staffRolesSave.
  ///
  /// In tr, this message translates to:
  /// **'Rolleri kaydet'**
  String get staffRolesSave;

  /// No description provided for @staffRolesSaved.
  ///
  /// In tr, this message translates to:
  /// **'Roller kaydedildi; personelin açık oturumları sonlandırıldı.'**
  String get staffRolesSaved;

  /// No description provided for @staffSectionAccount.
  ///
  /// In tr, this message translates to:
  /// **'Hesap'**
  String get staffSectionAccount;

  /// No description provided for @staffSectionSecurity.
  ///
  /// In tr, this message translates to:
  /// **'Güvenlik'**
  String get staffSectionSecurity;

  /// No description provided for @staffMfaEnrolled.
  ///
  /// In tr, this message translates to:
  /// **'İki adımlı doğrulama kurulu ({date})'**
  String staffMfaEnrolled(String date);

  /// No description provided for @staffMfaNotEnrolled.
  ///
  /// In tr, this message translates to:
  /// **'İki adımlı doğrulama henüz kurulmadı (ilk girişte kurulur)'**
  String get staffMfaNotEnrolled;

  /// No description provided for @staffLastLogin.
  ///
  /// In tr, this message translates to:
  /// **'Son giriş'**
  String get staffLastLogin;

  /// No description provided for @staffNever.
  ///
  /// In tr, this message translates to:
  /// **'Hiç giriş yapmadı'**
  String get staffNever;

  /// No description provided for @staffCreatedAt.
  ///
  /// In tr, this message translates to:
  /// **'Eklenme'**
  String get staffCreatedAt;

  /// No description provided for @staffYou.
  ///
  /// In tr, this message translates to:
  /// **'Siz'**
  String get staffYou;

  /// No description provided for @staffDisable.
  ///
  /// In tr, this message translates to:
  /// **'Erişimi devre dışı bırak'**
  String get staffDisable;

  /// No description provided for @staffEnable.
  ///
  /// In tr, this message translates to:
  /// **'Erişimi etkinleştir'**
  String get staffEnable;

  /// No description provided for @staffDisableConfirmTitle.
  ///
  /// In tr, this message translates to:
  /// **'Personel erişimi kapatılsın mı?'**
  String get staffDisableConfirmTitle;

  /// No description provided for @staffDisableConfirmBody.
  ///
  /// In tr, this message translates to:
  /// **'Kişi yönetim paneline giremez ve açık oturumları hemen sonlanır. Vatandaş hesabı etkilenmez.'**
  String get staffDisableConfirmBody;

  /// No description provided for @staffResetMfa.
  ///
  /// In tr, this message translates to:
  /// **'Authenticator\'ı sıfırla'**
  String get staffResetMfa;

  /// No description provided for @staffResetMfaConfirmTitle.
  ///
  /// In tr, this message translates to:
  /// **'Authenticator sıfırlansın mı?'**
  String get staffResetMfaConfirmTitle;

  /// No description provided for @staffResetMfaConfirmBody.
  ///
  /// In tr, this message translates to:
  /// **'Kurtarma kodları geçersiz olur; kişi sonraki girişte iki adımlı doğrulamayı yeniden kurar. Kimliğini başka bir kanaldan doğruladıktan sonra yapın.'**
  String get staffResetMfaConfirmBody;

  /// No description provided for @staffRevokeSessions.
  ///
  /// In tr, this message translates to:
  /// **'Oturumları sonlandır'**
  String get staffRevokeSessions;

  /// No description provided for @staffRevokeConfirmTitle.
  ///
  /// In tr, this message translates to:
  /// **'Tüm oturumlar sonlandırılsın mı?'**
  String get staffRevokeConfirmTitle;

  /// No description provided for @staffRevokeConfirmBody.
  ///
  /// In tr, this message translates to:
  /// **'Kişinin açık yönetim paneli oturumları kapanır; yeniden giriş yapması gerekir.'**
  String get staffRevokeConfirmBody;

  /// No description provided for @staffActionDone.
  ///
  /// In tr, this message translates to:
  /// **'İşlem tamamlandı'**
  String get staffActionDone;

  /// No description provided for @staffSelfNote.
  ///
  /// In tr, this message translates to:
  /// **'Kendi hesabınızda rol kaldırma ve devre dışı bırakma kapalıdır.'**
  String get staffSelfNote;

  /// No description provided for @staffTileSemantics.
  ///
  /// In tr, this message translates to:
  /// **'{name}, {roles}, {status}'**
  String staffTileSemantics(String name, String roles, String status);

  /// No description provided for @auditTitle.
  ///
  /// In tr, this message translates to:
  /// **'Denetim kaydı'**
  String get auditTitle;

  /// No description provided for @auditSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Tüm servislerdeki personel işlemleri: kim, ne zaman, hangi kayıtta, neyi değiştirdi.'**
  String get auditSubtitle;

  /// No description provided for @auditFilterService.
  ///
  /// In tr, this message translates to:
  /// **'Servis'**
  String get auditFilterService;

  /// No description provided for @auditTargetSearch.
  ///
  /// In tr, this message translates to:
  /// **'Kayıt kimliği'**
  String get auditTargetSearch;

  /// No description provided for @auditDateRange.
  ///
  /// In tr, this message translates to:
  /// **'Tarih aralığı'**
  String get auditDateRange;

  /// No description provided for @auditColumnTime.
  ///
  /// In tr, this message translates to:
  /// **'Zaman'**
  String get auditColumnTime;

  /// No description provided for @auditColumnActor.
  ///
  /// In tr, this message translates to:
  /// **'Personel'**
  String get auditColumnActor;

  /// No description provided for @auditColumnAction.
  ///
  /// In tr, this message translates to:
  /// **'İşlem'**
  String get auditColumnAction;

  /// No description provided for @auditColumnTarget.
  ///
  /// In tr, this message translates to:
  /// **'Kayıt'**
  String get auditColumnTarget;

  /// No description provided for @auditChanges.
  ///
  /// In tr, this message translates to:
  /// **'Değişiklikler'**
  String get auditChanges;

  /// No description provided for @auditCorrelation.
  ///
  /// In tr, this message translates to:
  /// **'İzleme kimliği: {id}'**
  String auditCorrelation(String id);

  /// No description provided for @auditNoChanges.
  ///
  /// In tr, this message translates to:
  /// **'Ek bilgi yok'**
  String get auditNoChanges;

  /// No description provided for @auditServiceIdentity.
  ///
  /// In tr, this message translates to:
  /// **'Kimlik'**
  String get auditServiceIdentity;

  /// No description provided for @auditServiceCatalog.
  ///
  /// In tr, this message translates to:
  /// **'Katalog'**
  String get auditServiceCatalog;

  /// No description provided for @auditServiceCivilProtection.
  ///
  /// In tr, this message translates to:
  /// **'Sivil Koruma'**
  String get auditServiceCivilProtection;

  /// No description provided for @auditServiceMemories.
  ///
  /// In tr, this message translates to:
  /// **'Anı Köşesi'**
  String get auditServiceMemories;

  /// No description provided for @auditServiceFeedback.
  ///
  /// In tr, this message translates to:
  /// **'Geri bildirim'**
  String get auditServiceFeedback;

  /// No description provided for @auditActionSignedIn.
  ///
  /// In tr, this message translates to:
  /// **'Panele giriş yaptı'**
  String get auditActionSignedIn;

  /// No description provided for @auditActionMfaEnrolled.
  ///
  /// In tr, this message translates to:
  /// **'İki adımlı doğrulamayı kurdu'**
  String get auditActionMfaEnrolled;

  /// No description provided for @auditActionRecoveryUsed.
  ///
  /// In tr, this message translates to:
  /// **'Kurtarma kodu kullandı'**
  String get auditActionRecoveryUsed;

  /// No description provided for @auditActionRecoveryRegenerated.
  ///
  /// In tr, this message translates to:
  /// **'Kurtarma kodlarını yeniledi'**
  String get auditActionRecoveryRegenerated;

  /// No description provided for @auditActionPasswordChanged.
  ///
  /// In tr, this message translates to:
  /// **'Şifresini değiştirdi'**
  String get auditActionPasswordChanged;

  /// No description provided for @auditActionStaffInvited.
  ///
  /// In tr, this message translates to:
  /// **'Personel davet etti'**
  String get auditActionStaffInvited;

  /// No description provided for @auditActionStaffRoles.
  ///
  /// In tr, this message translates to:
  /// **'Personel rollerini değiştirdi'**
  String get auditActionStaffRoles;

  /// No description provided for @auditActionStaffDisabled.
  ///
  /// In tr, this message translates to:
  /// **'Personel erişimini kapattı'**
  String get auditActionStaffDisabled;

  /// No description provided for @auditActionStaffEnabled.
  ///
  /// In tr, this message translates to:
  /// **'Personel erişimini açtı'**
  String get auditActionStaffEnabled;

  /// No description provided for @auditActionStaffMfaReset.
  ///
  /// In tr, this message translates to:
  /// **'Authenticator\'ı sıfırladı'**
  String get auditActionStaffMfaReset;

  /// No description provided for @auditActionStaffSessions.
  ///
  /// In tr, this message translates to:
  /// **'Oturumları sonlandırdı'**
  String get auditActionStaffSessions;

  /// No description provided for @auditActionReportStatus.
  ///
  /// In tr, this message translates to:
  /// **'Bildirim durumunu değiştirdi'**
  String get auditActionReportStatus;

  /// No description provided for @auditActionMemoryApproved.
  ///
  /// In tr, this message translates to:
  /// **'Anıyı onayladı / yayında tuttu'**
  String get auditActionMemoryApproved;

  /// No description provided for @auditActionMemoryRejected.
  ///
  /// In tr, this message translates to:
  /// **'Anıyı yayından kaldırdı'**
  String get auditActionMemoryRejected;

  /// No description provided for @auditActionFeedbackTriaged.
  ///
  /// In tr, this message translates to:
  /// **'Geri bildirimi işledi'**
  String get auditActionFeedbackTriaged;

  /// No description provided for @auditActionMonumentCreated.
  ///
  /// In tr, this message translates to:
  /// **'Eser ekledi'**
  String get auditActionMonumentCreated;

  /// No description provided for @auditActionMonumentUpdated.
  ///
  /// In tr, this message translates to:
  /// **'Eseri güncelledi'**
  String get auditActionMonumentUpdated;

  /// No description provided for @auditActionMonumentArchived.
  ///
  /// In tr, this message translates to:
  /// **'Eseri yayından kaldırdı'**
  String get auditActionMonumentArchived;

  /// No description provided for @auditActionMonumentRestored.
  ///
  /// In tr, this message translates to:
  /// **'Eseri yeniden yayınladı'**
  String get auditActionMonumentRestored;

  /// No description provided for @auditActionComplexMembers.
  ///
  /// In tr, this message translates to:
  /// **'Külliye yapılarını düzenledi'**
  String get auditActionComplexMembers;

  /// No description provided for @profileTitle.
  ///
  /// In tr, this message translates to:
  /// **'Profilim'**
  String get profileTitle;

  /// No description provided for @profileSectionAccount.
  ///
  /// In tr, this message translates to:
  /// **'Hesap'**
  String get profileSectionAccount;

  /// No description provided for @profileSectionRoles.
  ///
  /// In tr, this message translates to:
  /// **'Rollerim'**
  String get profileSectionRoles;

  /// No description provided for @profileSectionSecurity.
  ///
  /// In tr, this message translates to:
  /// **'Güvenlik'**
  String get profileSectionSecurity;

  /// No description provided for @profileSectionPassword.
  ///
  /// In tr, this message translates to:
  /// **'Şifre değiştir'**
  String get profileSectionPassword;

  /// No description provided for @profileRolesHelp.
  ///
  /// In tr, this message translates to:
  /// **'Roller VGM yöneticisi tarafından atanır.'**
  String get profileRolesHelp;

  /// No description provided for @profileMfaOn.
  ///
  /// In tr, this message translates to:
  /// **'İki adımlı doğrulama açık (kurulum: {date})'**
  String profileMfaOn(String date);

  /// No description provided for @profileRecoveryRemaining.
  ///
  /// In tr, this message translates to:
  /// **'{count, plural, =0{Kullanılabilir kurtarma kodu kalmadı.} =1{1 kurtarma kodu kaldı.} other{{count} kurtarma kodu kaldı.}}'**
  String profileRecoveryRemaining(int count);

  /// No description provided for @profileRecoveryLow.
  ///
  /// In tr, this message translates to:
  /// **'Kurtarma kodlarınız azaldı. Authenticator erişimini kaybetmeden yenileyin.'**
  String get profileRecoveryLow;

  /// No description provided for @profileRegenerate.
  ///
  /// In tr, this message translates to:
  /// **'Kurtarma kodlarını yenile'**
  String get profileRegenerate;

  /// No description provided for @profileRegenerateTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kurtarma kodlarını yenile'**
  String get profileRegenerateTitle;

  /// No description provided for @profileRegenerateBody.
  ///
  /// In tr, this message translates to:
  /// **'Eski kodlar geçersiz olur. Onaylamak için Authenticator uygulamanızdaki güncel kodu girin.'**
  String get profileRegenerateBody;

  /// No description provided for @profileRegenerateConfirm.
  ///
  /// In tr, this message translates to:
  /// **'Yenile'**
  String get profileRegenerateConfirm;

  /// No description provided for @profileCurrentPassword.
  ///
  /// In tr, this message translates to:
  /// **'Mevcut şifre'**
  String get profileCurrentPassword;

  /// No description provided for @profilePasswordSaved.
  ///
  /// In tr, this message translates to:
  /// **'Şifreniz değiştirildi; diğer oturumlarınız kapatıldı.'**
  String get profilePasswordSaved;

  /// No description provided for @profileSignOut.
  ///
  /// In tr, this message translates to:
  /// **'Çıkış yap'**
  String get profileSignOut;

  /// No description provided for @settingsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Ayarlar'**
  String get settingsTitle;

  /// No description provided for @settingsSectionAppearance.
  ///
  /// In tr, this message translates to:
  /// **'Görünüm'**
  String get settingsSectionAppearance;

  /// No description provided for @settingsSectionLanguage.
  ///
  /// In tr, this message translates to:
  /// **'Dil'**
  String get settingsSectionLanguage;

  /// No description provided for @settingsSectionAccessibility.
  ///
  /// In tr, this message translates to:
  /// **'Erişilebilirlik'**
  String get settingsSectionAccessibility;

  /// No description provided for @settingsSectionAbout.
  ///
  /// In tr, this message translates to:
  /// **'Hakkında'**
  String get settingsSectionAbout;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In tr, this message translates to:
  /// **'Cihaz ayarı'**
  String get settingsThemeSystem;

  /// No description provided for @settingsThemeLight.
  ///
  /// In tr, this message translates to:
  /// **'Açık'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In tr, this message translates to:
  /// **'Koyu'**
  String get settingsThemeDark;

  /// No description provided for @settingsHighContrast.
  ///
  /// In tr, this message translates to:
  /// **'Yüksek kontrast'**
  String get settingsHighContrast;

  /// No description provided for @settingsHighContrastHelp.
  ///
  /// In tr, this message translates to:
  /// **'Metin ve çizgiler için en az 7:1 kontrast.'**
  String get settingsHighContrastHelp;

  /// No description provided for @settingsLanguageSystem.
  ///
  /// In tr, this message translates to:
  /// **'Cihaz dili'**
  String get settingsLanguageSystem;

  /// No description provided for @settingsTextScale.
  ///
  /// In tr, this message translates to:
  /// **'Metin boyutu'**
  String get settingsTextScale;

  /// No description provided for @settingsTextScaleValue.
  ///
  /// In tr, this message translates to:
  /// **'%{percent}'**
  String settingsTextScaleValue(int percent);

  /// No description provided for @settingsReduceMotion.
  ///
  /// In tr, this message translates to:
  /// **'Hareketi azalt'**
  String get settingsReduceMotion;

  /// No description provided for @settingsReduceMotionHelp.
  ///
  /// In tr, this message translates to:
  /// **'Geçiş ve kayma animasyonlarını kapatır.'**
  String get settingsReduceMotionHelp;

  /// No description provided for @settingsShortcuts.
  ///
  /// In tr, this message translates to:
  /// **'Klavye kısayolları'**
  String get settingsShortcuts;

  /// No description provided for @settingsShortcutSearch.
  ///
  /// In tr, this message translates to:
  /// **'Aramaya git'**
  String get settingsShortcutSearch;

  /// No description provided for @settingsShortcutNew.
  ///
  /// In tr, this message translates to:
  /// **'Yeni kayıt'**
  String get settingsShortcutNew;

  /// No description provided for @settingsShortcutSave.
  ///
  /// In tr, this message translates to:
  /// **'Kaydet'**
  String get settingsShortcutSave;

  /// No description provided for @settingsShortcutRefresh.
  ///
  /// In tr, this message translates to:
  /// **'Yenile'**
  String get settingsShortcutRefresh;

  /// No description provided for @settingsShortcutClose.
  ///
  /// In tr, this message translates to:
  /// **'Ayrıntıyı kapat'**
  String get settingsShortcutClose;

  /// No description provided for @settingsVersion.
  ///
  /// In tr, this message translates to:
  /// **'Sürüm {version}'**
  String settingsVersion(String version);

  /// No description provided for @settingsAboutBody.
  ///
  /// In tr, this message translates to:
  /// **'Vakıflar Genel Müdürlüğü personeli için Vakıf Atlas yönetim istemcisi. Root42 tarafından geliştirilmiştir.'**
  String get settingsAboutBody;

  /// No description provided for @catalogTitle.
  ///
  /// In tr, this message translates to:
  /// **'Katalog'**
  String get catalogTitle;

  /// No description provided for @catalogSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'VGM onaylı vakıf eserleri. Değişiklikler vatandaş uygulamasına ve haritaya hemen yansır.'**
  String get catalogSubtitle;

  /// No description provided for @catalogSearch.
  ///
  /// In tr, this message translates to:
  /// **'Ad, il, bani veya kimlik ara'**
  String get catalogSearch;

  /// No description provided for @catalogNew.
  ///
  /// In tr, this message translates to:
  /// **'Yeni eser'**
  String get catalogNew;

  /// No description provided for @catalogFilterCategory.
  ///
  /// In tr, this message translates to:
  /// **'Tür'**
  String get catalogFilterCategory;

  /// No description provided for @catalogFilterPeriod.
  ///
  /// In tr, this message translates to:
  /// **'Dönem'**
  String get catalogFilterPeriod;

  /// No description provided for @catalogFilterPublication.
  ///
  /// In tr, this message translates to:
  /// **'Yayın'**
  String get catalogFilterPublication;

  /// No description provided for @catalogSortName.
  ///
  /// In tr, this message translates to:
  /// **'Ada göre'**
  String get catalogSortName;

  /// No description provided for @catalogSortUpdated.
  ///
  /// In tr, this message translates to:
  /// **'Son güncellenen'**
  String get catalogSortUpdated;

  /// No description provided for @publicationPublished.
  ///
  /// In tr, this message translates to:
  /// **'Yayında'**
  String get publicationPublished;

  /// No description provided for @publicationArchived.
  ///
  /// In tr, this message translates to:
  /// **'Yayından kaldırıldı'**
  String get publicationArchived;

  /// No description provided for @categoryMosque.
  ///
  /// In tr, this message translates to:
  /// **'Cami'**
  String get categoryMosque;

  /// No description provided for @categoryComplex.
  ///
  /// In tr, this message translates to:
  /// **'Külliye'**
  String get categoryComplex;

  /// No description provided for @categoryMadrasa.
  ///
  /// In tr, this message translates to:
  /// **'Medrese'**
  String get categoryMadrasa;

  /// No description provided for @categoryInn.
  ///
  /// In tr, this message translates to:
  /// **'Han'**
  String get categoryInn;

  /// No description provided for @categoryCaravanserai.
  ///
  /// In tr, this message translates to:
  /// **'Kervansaray'**
  String get categoryCaravanserai;

  /// No description provided for @categoryBath.
  ///
  /// In tr, this message translates to:
  /// **'Hamam'**
  String get categoryBath;

  /// No description provided for @categoryFountain.
  ///
  /// In tr, this message translates to:
  /// **'Çeşme'**
  String get categoryFountain;

  /// No description provided for @categoryTomb.
  ///
  /// In tr, this message translates to:
  /// **'Türbe'**
  String get categoryTomb;

  /// No description provided for @categoryHospital.
  ///
  /// In tr, this message translates to:
  /// **'Darüşşifa'**
  String get categoryHospital;

  /// No description provided for @categoryImaret.
  ///
  /// In tr, this message translates to:
  /// **'İmaret'**
  String get categoryImaret;

  /// No description provided for @categoryMonumentOther.
  ///
  /// In tr, this message translates to:
  /// **'Diğer'**
  String get categoryMonumentOther;

  /// No description provided for @periodSeljuk.
  ///
  /// In tr, this message translates to:
  /// **'Selçuklu'**
  String get periodSeljuk;

  /// No description provided for @periodBeylik.
  ///
  /// In tr, this message translates to:
  /// **'Beylikler'**
  String get periodBeylik;

  /// No description provided for @periodOttoman.
  ///
  /// In tr, this message translates to:
  /// **'Osmanlı'**
  String get periodOttoman;

  /// No description provided for @periodOther.
  ///
  /// In tr, this message translates to:
  /// **'Diğer'**
  String get periodOther;

  /// No description provided for @catalogImageCount.
  ///
  /// In tr, this message translates to:
  /// **'{count, plural, =0{Görsel yok} =1{1 görsel} other{{count} görsel}}'**
  String catalogImageCount(int count);

  /// No description provided for @catalogMemberCount.
  ///
  /// In tr, this message translates to:
  /// **'{count} yapı'**
  String catalogMemberCount(int count);

  /// No description provided for @catalogPartOf.
  ///
  /// In tr, this message translates to:
  /// **'{name} içinde'**
  String catalogPartOf(String name);

  /// No description provided for @catalogRowSemantics.
  ///
  /// In tr, this message translates to:
  /// **'{name}, {category}, {city}, {publication}'**
  String catalogRowSemantics(
    String name,
    String category,
    String city,
    String publication,
  );

  /// No description provided for @editorNewTitle.
  ///
  /// In tr, this message translates to:
  /// **'Yeni eser'**
  String get editorNewTitle;

  /// No description provided for @editorBack.
  ///
  /// In tr, this message translates to:
  /// **'Kataloğa dön'**
  String get editorBack;

  /// No description provided for @editorTabGeneral.
  ///
  /// In tr, this message translates to:
  /// **'Genel'**
  String get editorTabGeneral;

  /// No description provided for @editorTabTurkish.
  ///
  /// In tr, this message translates to:
  /// **'Türkçe'**
  String get editorTabTurkish;

  /// No description provided for @editorTabEnglish.
  ///
  /// In tr, this message translates to:
  /// **'İngilizce'**
  String get editorTabEnglish;

  /// No description provided for @editorTabImages.
  ///
  /// In tr, this message translates to:
  /// **'Görseller'**
  String get editorTabImages;

  /// No description provided for @editorTabMembers.
  ///
  /// In tr, this message translates to:
  /// **'Külliye yapıları'**
  String get editorTabMembers;

  /// No description provided for @editorTabHasErrors.
  ///
  /// In tr, this message translates to:
  /// **'{tab}, düzeltilmesi gereken alanlar var'**
  String editorTabHasErrors(String tab);

  /// No description provided for @editorSave.
  ///
  /// In tr, this message translates to:
  /// **'Kaydet'**
  String get editorSave;

  /// No description provided for @editorSaved.
  ///
  /// In tr, this message translates to:
  /// **'Eser kaydedildi'**
  String get editorSaved;

  /// No description provided for @editorDiscard.
  ///
  /// In tr, this message translates to:
  /// **'Değişiklikleri geri al'**
  String get editorDiscard;

  /// No description provided for @editorUnsaved.
  ///
  /// In tr, this message translates to:
  /// **'Kaydedilmemiş değişiklikler var'**
  String get editorUnsaved;

  /// No description provided for @editorErrorsSummary.
  ///
  /// In tr, this message translates to:
  /// **'Kaydetmeden önce işaretli alanları düzeltin.'**
  String get editorErrorsSummary;

  /// No description provided for @editorArchive.
  ///
  /// In tr, this message translates to:
  /// **'Yayından kaldır'**
  String get editorArchive;

  /// No description provided for @editorRestore.
  ///
  /// In tr, this message translates to:
  /// **'Yeniden yayınla'**
  String get editorRestore;

  /// No description provided for @editorArchiveConfirmTitle.
  ///
  /// In tr, this message translates to:
  /// **'Eser yayından kaldırılsın mı?'**
  String get editorArchiveConfirmTitle;

  /// No description provided for @editorArchiveConfirmBody.
  ///
  /// In tr, this message translates to:
  /// **'Eser vatandaş uygulamasında ve haritada görünmez; rotalar, kayıtlar ve anılar \"katalogdan kalkmış\" gösterir. Daha sonra yeniden yayınlanabilir.'**
  String get editorArchiveConfirmBody;

  /// No description provided for @editorArchivedNotice.
  ///
  /// In tr, this message translates to:
  /// **'Bu eser yayında değil ({date}).'**
  String editorArchivedNotice(String date);

  /// No description provided for @editorPublicationChanged.
  ///
  /// In tr, this message translates to:
  /// **'Yayın durumu güncellendi'**
  String get editorPublicationChanged;

  /// No description provided for @editorFieldId.
  ///
  /// In tr, this message translates to:
  /// **'Kimlik (adres)'**
  String get editorFieldId;

  /// No description provided for @editorFieldIdHelp.
  ///
  /// In tr, this message translates to:
  /// **'Küçük harf, rakam ve tire; kaydedildikten sonra değiştirilemez. Örn. selimiye-camii'**
  String get editorFieldIdHelp;

  /// No description provided for @editorFieldIdError.
  ///
  /// In tr, this message translates to:
  /// **'3–120 karakter; yalnızca küçük harf, rakam ve tek tire.'**
  String get editorFieldIdError;

  /// No description provided for @editorSuggestId.
  ///
  /// In tr, this message translates to:
  /// **'Addan öner'**
  String get editorSuggestId;

  /// No description provided for @editorFieldCategory.
  ///
  /// In tr, this message translates to:
  /// **'Tür'**
  String get editorFieldCategory;

  /// No description provided for @editorFieldPeriod.
  ///
  /// In tr, this message translates to:
  /// **'Dönem'**
  String get editorFieldPeriod;

  /// No description provided for @editorFieldCity.
  ///
  /// In tr, this message translates to:
  /// **'İl'**
  String get editorFieldCity;

  /// No description provided for @editorFieldDistrict.
  ///
  /// In tr, this message translates to:
  /// **'İlçe'**
  String get editorFieldDistrict;

  /// No description provided for @editorFieldAddress.
  ///
  /// In tr, this message translates to:
  /// **'Adres'**
  String get editorFieldAddress;

  /// No description provided for @editorFieldLatitude.
  ///
  /// In tr, this message translates to:
  /// **'Enlem'**
  String get editorFieldLatitude;

  /// No description provided for @editorFieldLongitude.
  ///
  /// In tr, this message translates to:
  /// **'Boylam'**
  String get editorFieldLongitude;

  /// No description provided for @editorFieldLocationError.
  ///
  /// In tr, this message translates to:
  /// **'Türkiye sınırları içinde geçerli bir koordinat girin (ondalık derece).'**
  String get editorFieldLocationError;

  /// No description provided for @editorFieldLocationHelp.
  ///
  /// In tr, this message translates to:
  /// **'Ondalık derece (WGS 84), örn. 41.6781 / 26.5594.'**
  String get editorFieldLocationHelp;

  /// No description provided for @editorFieldUnesco.
  ///
  /// In tr, this message translates to:
  /// **'UNESCO Dünya Mirası'**
  String get editorFieldUnesco;

  /// No description provided for @editorFieldComplex.
  ///
  /// In tr, this message translates to:
  /// **'Bağlı olduğu külliye'**
  String get editorFieldComplex;

  /// No description provided for @editorFieldComplexHelp.
  ///
  /// In tr, this message translates to:
  /// **'Eser bir külliyenin yapısıysa listeden seçin; değilse bağımsız bırakın. Külliye türündeki eser başka külliyeye bağlanamaz.'**
  String get editorFieldComplexHelp;

  /// No description provided for @editorFieldComplexError.
  ///
  /// In tr, this message translates to:
  /// **'Seçilen külliye geçersiz. Listeden yeniden seçin.'**
  String get editorFieldComplexError;

  /// No description provided for @editorFieldComplexOrder.
  ///
  /// In tr, this message translates to:
  /// **'Külliyedeki sıra'**
  String get editorFieldComplexOrder;

  /// No description provided for @editorFieldRequired.
  ///
  /// In tr, this message translates to:
  /// **'Bu alan zorunludur.'**
  String get editorFieldRequired;

  /// No description provided for @editorFieldName.
  ///
  /// In tr, this message translates to:
  /// **'Ad'**
  String get editorFieldName;

  /// No description provided for @editorFieldShortDescription.
  ///
  /// In tr, this message translates to:
  /// **'Kısa tanıtım'**
  String get editorFieldShortDescription;

  /// No description provided for @editorFieldShortDescriptionHelp.
  ///
  /// In tr, this message translates to:
  /// **'Liste ve kartlarda görünür (en fazla 1000 karakter).'**
  String get editorFieldShortDescriptionHelp;

  /// No description provided for @editorFieldDescription.
  ///
  /// In tr, this message translates to:
  /// **'Açıklama'**
  String get editorFieldDescription;

  /// No description provided for @editorFieldDescriptionHelp.
  ///
  /// In tr, this message translates to:
  /// **'Paragrafları boş satırla ayırın.'**
  String get editorFieldDescriptionHelp;

  /// No description provided for @editorFieldHistory.
  ///
  /// In tr, this message translates to:
  /// **'Tarihçe'**
  String get editorFieldHistory;

  /// No description provided for @editorFieldConstructionDate.
  ///
  /// In tr, this message translates to:
  /// **'Yapım tarihi'**
  String get editorFieldConstructionDate;

  /// No description provided for @editorFieldFounder.
  ///
  /// In tr, this message translates to:
  /// **'Bani (yaptıran)'**
  String get editorFieldFounder;

  /// No description provided for @editorFieldArchitect.
  ///
  /// In tr, this message translates to:
  /// **'Mimar'**
  String get editorFieldArchitect;

  /// No description provided for @editorImagesHelp.
  ///
  /// In tr, this message translates to:
  /// **'İlk görsel kapak görselidir. Her görsel için iki dilde alternatif metin, yazar ve lisans zorunludur (atıf). En fazla 10 görsel.'**
  String get editorImagesHelp;

  /// No description provided for @editorImagesAdd.
  ///
  /// In tr, this message translates to:
  /// **'Görsel ekle'**
  String get editorImagesAdd;

  /// No description provided for @editorImagesUploading.
  ///
  /// In tr, this message translates to:
  /// **'{count} görsel hazırlanıyor ve yükleniyor…'**
  String editorImagesUploading(int count);

  /// No description provided for @editorImagesUploadError.
  ///
  /// In tr, this message translates to:
  /// **'Görsel yüklenemedi: {reason}'**
  String editorImagesUploadError(String reason);

  /// No description provided for @editorImagesInvalid.
  ///
  /// In tr, this message translates to:
  /// **'Dosya okunamadı veya desteklenmeyen biçimde.'**
  String get editorImagesInvalid;

  /// No description provided for @editorImagesError.
  ///
  /// In tr, this message translates to:
  /// **'Her görsel için alternatif metin (TR/EN), yazar ve lisans girin.'**
  String get editorImagesError;

  /// No description provided for @editorImagesEmpty.
  ///
  /// In tr, this message translates to:
  /// **'Henüz görsel yok.'**
  String get editorImagesEmpty;

  /// No description provided for @editorImageCover.
  ///
  /// In tr, this message translates to:
  /// **'Kapak'**
  String get editorImageCover;

  /// No description provided for @editorImageNew.
  ///
  /// In tr, this message translates to:
  /// **'Yeni'**
  String get editorImageNew;

  /// No description provided for @editorImageMirrored.
  ///
  /// In tr, this message translates to:
  /// **'Kurum deposunda'**
  String get editorImageMirrored;

  /// No description provided for @editorImageAltTr.
  ///
  /// In tr, this message translates to:
  /// **'Alternatif metin (TR)'**
  String get editorImageAltTr;

  /// No description provided for @editorImageAltEn.
  ///
  /// In tr, this message translates to:
  /// **'Alternatif metin (EN)'**
  String get editorImageAltEn;

  /// No description provided for @editorImageAuthor.
  ///
  /// In tr, this message translates to:
  /// **'Yazar'**
  String get editorImageAuthor;

  /// No description provided for @editorImageLicense.
  ///
  /// In tr, this message translates to:
  /// **'Lisans'**
  String get editorImageLicense;

  /// No description provided for @editorImageSourceName.
  ///
  /// In tr, this message translates to:
  /// **'Kaynak'**
  String get editorImageSourceName;

  /// No description provided for @editorImageSourceUrl.
  ///
  /// In tr, this message translates to:
  /// **'Kaynak adresi'**
  String get editorImageSourceUrl;

  /// No description provided for @editorImageMoveUp.
  ///
  /// In tr, this message translates to:
  /// **'Yukarı taşı'**
  String get editorImageMoveUp;

  /// No description provided for @editorImageMoveDown.
  ///
  /// In tr, this message translates to:
  /// **'Aşağı taşı'**
  String get editorImageMoveDown;

  /// No description provided for @editorImageRemove.
  ///
  /// In tr, this message translates to:
  /// **'Görseli kaldır'**
  String get editorImageRemove;

  /// No description provided for @editorImageSemantics.
  ///
  /// In tr, this message translates to:
  /// **'Görsel {index} / {count}'**
  String editorImageSemantics(int index, int count);

  /// No description provided for @editorImagesFileType.
  ///
  /// In tr, this message translates to:
  /// **'Görseller'**
  String get editorImagesFileType;

  /// No description provided for @editorMembersHelp.
  ///
  /// In tr, this message translates to:
  /// **'Yapıların küratörlü sırası (cami genelde ilk). Yapı eklemek için listeden seçin; sıralama ve üyelik kaydedildiğinde külliyenin yerleşim alanı yeniden hesaplanır.'**
  String get editorMembersHelp;

  /// No description provided for @editorMembersSaveFirst.
  ///
  /// In tr, this message translates to:
  /// **'Yapılar, külliye kaydedildikten sonra düzenlenebilir.'**
  String get editorMembersSaveFirst;

  /// No description provided for @editorMembersAdd.
  ///
  /// In tr, this message translates to:
  /// **'Yapı ekle'**
  String get editorMembersAdd;

  /// No description provided for @editorMembersSave.
  ///
  /// In tr, this message translates to:
  /// **'Yapıları kaydet'**
  String get editorMembersSave;

  /// No description provided for @editorMembersSaved.
  ///
  /// In tr, this message translates to:
  /// **'Külliye yapıları kaydedildi'**
  String get editorMembersSaved;

  /// No description provided for @editorMembersEmpty.
  ///
  /// In tr, this message translates to:
  /// **'Bu külliyeye bağlı yapı yok.'**
  String get editorMembersEmpty;

  /// No description provided for @editorMemberRemove.
  ///
  /// In tr, this message translates to:
  /// **'Külliyeden çıkar'**
  String get editorMemberRemove;

  /// No description provided for @editorMemberArchived.
  ///
  /// In tr, this message translates to:
  /// **'yayında değil'**
  String get editorMemberArchived;

  /// No description provided for @editorMemberOrder.
  ///
  /// In tr, this message translates to:
  /// **'{index}. {name}'**
  String editorMemberOrder(int index, String name);

  /// No description provided for @appBrandName.
  ///
  /// In tr, this message translates to:
  /// **'Vakıf Atlas'**
  String get appBrandName;

  /// No description provided for @filterSelectedCount.
  ///
  /// In tr, this message translates to:
  /// **'{count} seçili'**
  String filterSelectedCount(int count);

  /// No description provided for @filterClearSelection.
  ///
  /// In tr, this message translates to:
  /// **'Seçimi temizle'**
  String get filterClearSelection;

  /// No description provided for @catalogColumnName.
  ///
  /// In tr, this message translates to:
  /// **'Eser'**
  String get catalogColumnName;

  /// No description provided for @catalogColumnCategory.
  ///
  /// In tr, this message translates to:
  /// **'Tür'**
  String get catalogColumnCategory;

  /// No description provided for @catalogColumnPeriod.
  ///
  /// In tr, this message translates to:
  /// **'Dönem'**
  String get catalogColumnPeriod;

  /// No description provided for @catalogColumnLocation.
  ///
  /// In tr, this message translates to:
  /// **'Konum'**
  String get catalogColumnLocation;

  /// No description provided for @catalogColumnImages.
  ///
  /// In tr, this message translates to:
  /// **'Görsel'**
  String get catalogColumnImages;

  /// No description provided for @catalogColumnStatus.
  ///
  /// In tr, this message translates to:
  /// **'Durum'**
  String get catalogColumnStatus;

  /// No description provided for @catalogColumnUpdated.
  ///
  /// In tr, this message translates to:
  /// **'Güncellendi'**
  String get catalogColumnUpdated;

  /// No description provided for @dashboardMetricOpenReports.
  ///
  /// In tr, this message translates to:
  /// **'Açık hasar bildirimi'**
  String get dashboardMetricOpenReports;

  /// No description provided for @dashboardMetricModeration.
  ///
  /// In tr, this message translates to:
  /// **'İşlem bekleyen anı'**
  String get dashboardMetricModeration;

  /// No description provided for @dashboardMetricFeedback.
  ///
  /// In tr, this message translates to:
  /// **'Yeni geri bildirim'**
  String get dashboardMetricFeedback;

  /// No description provided for @dashboardMetricCatalog.
  ///
  /// In tr, this message translates to:
  /// **'Yayındaki eser'**
  String get dashboardMetricCatalog;

  /// No description provided for @dashboardReportsNoCritical.
  ///
  /// In tr, this message translates to:
  /// **'Kritik bildirim yok'**
  String get dashboardReportsNoCritical;

  /// No description provided for @dashboardOpenQueue.
  ///
  /// In tr, this message translates to:
  /// **'Kuyruğu aç'**
  String get dashboardOpenQueue;

  /// No description provided for @dashboardOpenCatalog.
  ///
  /// In tr, this message translates to:
  /// **'Kataloğu aç'**
  String get dashboardOpenCatalog;

  /// No description provided for @dashboardByStatus.
  ///
  /// In tr, this message translates to:
  /// **'Duruma göre'**
  String get dashboardByStatus;

  /// No description provided for @dashboardOpenByUrgency.
  ///
  /// In tr, this message translates to:
  /// **'Açık bildirimler, aciliyete göre'**
  String get dashboardOpenByUrgency;

  /// No description provided for @dashboardByTopic.
  ///
  /// In tr, this message translates to:
  /// **'Konuya göre'**
  String get dashboardByTopic;

  /// No description provided for @dashboardByCategory.
  ///
  /// In tr, this message translates to:
  /// **'Türe göre'**
  String get dashboardByCategory;

  /// No description provided for @dashboardModerationReportedLabel.
  ///
  /// In tr, this message translates to:
  /// **'Bildirilen'**
  String get dashboardModerationReportedLabel;

  /// No description provided for @dashboardCatalogState.
  ///
  /// In tr, this message translates to:
  /// **'Yayın durumu'**
  String get dashboardCatalogState;

  /// No description provided for @dashboardCatalogNoImages.
  ///
  /// In tr, this message translates to:
  /// **'Görseli olmayan'**
  String get dashboardCatalogNoImages;

  /// No description provided for @dashboardCatalogVersionLabel.
  ///
  /// In tr, this message translates to:
  /// **'Katalog sürümü'**
  String get dashboardCatalogVersionLabel;

  /// No description provided for @auditFilterDate.
  ///
  /// In tr, this message translates to:
  /// **'Tarih'**
  String get auditFilterDate;

  /// No description provided for @editorFieldComplexOrderHelp.
  ///
  /// In tr, this message translates to:
  /// **'Külliye sayfasındaki yapı sırası.'**
  String get editorFieldComplexOrderHelp;

  /// No description provided for @editorComplexNone.
  ///
  /// In tr, this message translates to:
  /// **'Bağımsız eser (külliyeye bağlı değil)'**
  String get editorComplexNone;

  /// No description provided for @editorComplexChoose.
  ///
  /// In tr, this message translates to:
  /// **'Külliye seç'**
  String get editorComplexChoose;

  /// No description provided for @editorComplexChange.
  ///
  /// In tr, this message translates to:
  /// **'Değiştir'**
  String get editorComplexChange;

  /// No description provided for @editorComplexClear.
  ///
  /// In tr, this message translates to:
  /// **'Bağlantıyı kaldır'**
  String get editorComplexClear;

  /// No description provided for @editorFieldShortDescriptionTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kısa tanıtım başlığı'**
  String get editorFieldShortDescriptionTitle;

  /// No description provided for @editorFieldKind.
  ///
  /// In tr, this message translates to:
  /// **'Kayıt türü'**
  String get editorFieldKind;

  /// No description provided for @editorKindWork.
  ///
  /// In tr, this message translates to:
  /// **'Eser'**
  String get editorKindWork;

  /// No description provided for @editorKindComplex.
  ///
  /// In tr, this message translates to:
  /// **'Külliye'**
  String get editorKindComplex;

  /// No description provided for @editorCategoryAuto.
  ///
  /// In tr, this message translates to:
  /// **'Türü addan belirle'**
  String get editorCategoryAuto;

  /// No description provided for @editorCategoryAutoHelp.
  ///
  /// In tr, this message translates to:
  /// **'Tür, Türkçe addaki son yapı sözcüğünden türetilir (ör. “… Camii Şadırvanı” → çeşme). Kapatıp elle seçebilirsiniz.'**
  String get editorCategoryAutoHelp;

  /// No description provided for @editorFieldActive.
  ///
  /// In tr, this message translates to:
  /// **'Etkin'**
  String get editorFieldActive;

  /// No description provided for @editorFieldActiveHelp.
  ///
  /// In tr, this message translates to:
  /// **'Kapalıyken kayıt vatandaş uygulamasında görünmez.'**
  String get editorFieldActiveHelp;

  /// No description provided for @editorComplexOpen.
  ///
  /// In tr, this message translates to:
  /// **'Külliyeyi aç'**
  String get editorComplexOpen;

  /// No description provided for @editorComplexMembershipHelp.
  ///
  /// In tr, this message translates to:
  /// **'Külliye üyeliği ve sırası, külliyenin “Külliye yapıları” sekmesinden düzenlenir.'**
  String get editorComplexMembershipHelp;

  /// No description provided for @editorComplexPosition.
  ///
  /// In tr, this message translates to:
  /// **'Külliyedeki sıra: {position}'**
  String editorComplexPosition(int position);

  /// No description provided for @pickerComplexTitle.
  ///
  /// In tr, this message translates to:
  /// **'Külliye seç'**
  String get pickerComplexTitle;

  /// No description provided for @pickerComplexSearch.
  ///
  /// In tr, this message translates to:
  /// **'Külliye adı, il veya kimlik ara'**
  String get pickerComplexSearch;

  /// No description provided for @pickerMembersTitle.
  ///
  /// In tr, this message translates to:
  /// **'Külliyeye yapı ekle'**
  String get pickerMembersTitle;

  /// No description provided for @pickerMembersSearch.
  ///
  /// In tr, this message translates to:
  /// **'Eser adı, il veya kimlik ara'**
  String get pickerMembersSearch;

  /// No description provided for @pickerMembersHelp.
  ///
  /// In tr, this message translates to:
  /// **'Birden fazla yapı seçebilirsiniz. Başka bir külliyedeki yapı, yapılar kaydedildiğinde bu külliyeye taşınır.'**
  String get pickerMembersHelp;

  /// No description provided for @pickerResultCount.
  ///
  /// In tr, this message translates to:
  /// **'{count, plural, =0{Kayıt yok} =1{1 kayıt} other{{count} kayıt}}'**
  String pickerResultCount(int count);

  /// No description provided for @pickerSelectedCount.
  ///
  /// In tr, this message translates to:
  /// **'{count, plural, =0{Seçim yok} other{{count} yapı seçildi}}'**
  String pickerSelectedCount(int count);

  /// No description provided for @pickerAdd.
  ///
  /// In tr, this message translates to:
  /// **'{count, plural, =0{Ekle} other{{count} yapıyı ekle}}'**
  String pickerAdd(int count);

  /// No description provided for @pickerAlreadyMember.
  ///
  /// In tr, this message translates to:
  /// **'Bu külliyede zaten var'**
  String get pickerAlreadyMember;

  /// No description provided for @pickerCurrent.
  ///
  /// In tr, this message translates to:
  /// **'Şu anki seçim'**
  String get pickerCurrent;

  /// No description provided for @pickerInOtherComplex.
  ///
  /// In tr, this message translates to:
  /// **'Şu an {name} içinde, eklenirse taşınır'**
  String pickerInOtherComplex(String name);

  /// No description provided for @roleEditor.
  ///
  /// In tr, this message translates to:
  /// **'Editör'**
  String get roleEditor;

  /// No description provided for @roleModerator.
  ///
  /// In tr, this message translates to:
  /// **'Moderatör'**
  String get roleModerator;

  /// No description provided for @roleAdminDescription.
  ///
  /// In tr, this message translates to:
  /// **'Tüm bölümler, personel yönetimi ve denetim kaydı'**
  String get roleAdminDescription;

  /// No description provided for @roleEditorDescription.
  ///
  /// In tr, this message translates to:
  /// **'Yalnızca katalog: eser ekleme, düzenleme, yayından kaldırma ve külliye ilişkileri'**
  String get roleEditorDescription;

  /// No description provided for @roleModeratorDescription.
  ///
  /// In tr, this message translates to:
  /// **'Yalnızca kullanıcı içeriği: Anı Köşesi, Sivil Koruma bildirimleri ve geri bildirim'**
  String get roleModeratorDescription;

  /// No description provided for @settingsReduceMotionLocked.
  ///
  /// In tr, this message translates to:
  /// **'Cihazınızda hareketi azaltma açık; uygulama buna her zaman uyar. Kapatmak için sistem ayarlarını kullanın.'**
  String get settingsReduceMotionLocked;

  /// No description provided for @moderationQueueAutoRejected.
  ///
  /// In tr, this message translates to:
  /// **'YZ\'nin kaldırdıkları'**
  String get moderationQueueAutoRejected;

  /// No description provided for @moderationEmptyAutoRejected.
  ///
  /// In tr, this message translates to:
  /// **'YZ\'nin kaldırdığı anı yok.'**
  String get moderationEmptyAutoRejected;

  /// No description provided for @moderationSortLabel.
  ///
  /// In tr, this message translates to:
  /// **'Sıra'**
  String get moderationSortLabel;

  /// No description provided for @moderationSortOldest.
  ///
  /// In tr, this message translates to:
  /// **'En eski önce'**
  String get moderationSortOldest;

  /// No description provided for @moderationSortAiScore.
  ///
  /// In tr, this message translates to:
  /// **'En yüksek YZ skoru önce'**
  String get moderationSortAiScore;

  /// No description provided for @moderationMetricsAction.
  ///
  /// In tr, this message translates to:
  /// **'YZ metrikleri'**
  String get moderationMetricsAction;

  /// No description provided for @aiVerdictApprove.
  ///
  /// In tr, this message translates to:
  /// **'YZ: uygun'**
  String get aiVerdictApprove;

  /// No description provided for @aiVerdictReview.
  ///
  /// In tr, this message translates to:
  /// **'YZ: incelenmeli'**
  String get aiVerdictReview;

  /// No description provided for @aiVerdictReject.
  ///
  /// In tr, this message translates to:
  /// **'YZ: kaldırıldı'**
  String get aiVerdictReject;

  /// No description provided for @aiVerdictUnscored.
  ///
  /// In tr, this message translates to:
  /// **'YZ: skorlanamadı'**
  String get aiVerdictUnscored;

  /// No description provided for @aiChip.
  ///
  /// In tr, this message translates to:
  /// **'{verdict} · {score}'**
  String aiChip(String verdict, String score);

  /// No description provided for @aiChipWithCategory.
  ///
  /// In tr, this message translates to:
  /// **'{verdict} · {score} · {category}'**
  String aiChipWithCategory(String verdict, String score, String category);

  /// No description provided for @aiCategoryToxicity.
  ///
  /// In tr, this message translates to:
  /// **'Genel zararlılık'**
  String get aiCategoryToxicity;

  /// No description provided for @aiCategorySevereToxicity.
  ///
  /// In tr, this message translates to:
  /// **'Ağır zararlılık'**
  String get aiCategorySevereToxicity;

  /// No description provided for @aiCategoryObscene.
  ///
  /// In tr, this message translates to:
  /// **'Müstehcen dil / küfür'**
  String get aiCategoryObscene;

  /// No description provided for @aiCategoryIdentityAttack.
  ///
  /// In tr, this message translates to:
  /// **'Kimliğe saldırı'**
  String get aiCategoryIdentityAttack;

  /// No description provided for @aiCategoryInsult.
  ///
  /// In tr, this message translates to:
  /// **'Hakaret'**
  String get aiCategoryInsult;

  /// No description provided for @aiCategoryThreat.
  ///
  /// In tr, this message translates to:
  /// **'Tehdit'**
  String get aiCategoryThreat;

  /// No description provided for @aiCategorySexualExplicit.
  ///
  /// In tr, this message translates to:
  /// **'Cinsel içerik'**
  String get aiCategorySexualExplicit;

  /// No description provided for @aiReviewCauseScore.
  ///
  /// In tr, this message translates to:
  /// **'Skor inceleme bandında'**
  String get aiReviewCauseScore;

  /// No description provided for @aiReviewCauseLanguage.
  ///
  /// In tr, this message translates to:
  /// **'Model bu dili desteklemiyor'**
  String get aiReviewCauseLanguage;

  /// No description provided for @aiReviewCausePhotos.
  ///
  /// In tr, this message translates to:
  /// **'Fotoğraflı anılar incelenir'**
  String get aiReviewCausePhotos;

  /// No description provided for @aiReviewCauseUnscored.
  ///
  /// In tr, this message translates to:
  /// **'Moderasyon servisine ulaşılamadı'**
  String get aiReviewCauseUnscored;

  /// No description provided for @memorySectionAi.
  ///
  /// In tr, this message translates to:
  /// **'Yapay zekâ değerlendirmesi'**
  String get memorySectionAi;

  /// No description provided for @aiVerdictLabel.
  ///
  /// In tr, this message translates to:
  /// **'Öneri'**
  String get aiVerdictLabel;

  /// No description provided for @aiScoreLabel.
  ///
  /// In tr, this message translates to:
  /// **'Genel skor (0–1)'**
  String get aiScoreLabel;

  /// No description provided for @aiTopCategoryLabel.
  ///
  /// In tr, this message translates to:
  /// **'Belirgin kategori'**
  String get aiTopCategoryLabel;

  /// No description provided for @aiReviewCauseLabel.
  ///
  /// In tr, this message translates to:
  /// **'İnceleme nedeni'**
  String get aiReviewCauseLabel;

  /// No description provided for @aiLexiconLabel.
  ///
  /// In tr, this message translates to:
  /// **'Türkçe sözlük eşleşmesi'**
  String get aiLexiconLabel;

  /// No description provided for @aiLexiconYes.
  ///
  /// In tr, this message translates to:
  /// **'Var — skor sözlükle yükseltildi'**
  String get aiLexiconYes;

  /// No description provided for @aiLexiconNo.
  ///
  /// In tr, this message translates to:
  /// **'Yok'**
  String get aiLexiconNo;

  /// No description provided for @aiModelLabel.
  ///
  /// In tr, this message translates to:
  /// **'Model'**
  String get aiModelLabel;

  /// No description provided for @aiScoredAtLabel.
  ///
  /// In tr, this message translates to:
  /// **'Değerlendirme zamanı'**
  String get aiScoredAtLabel;

  /// No description provided for @aiCategoryScores.
  ///
  /// In tr, this message translates to:
  /// **'Kategori skorları'**
  String get aiCategoryScores;

  /// No description provided for @aiNotAssessed.
  ///
  /// In tr, this message translates to:
  /// **'Bu anı YZ moderasyonu açılmadan paylaşıldı.'**
  String get aiNotAssessed;

  /// No description provided for @aiActorName.
  ///
  /// In tr, this message translates to:
  /// **'YZ moderasyonu'**
  String get aiActorName;

  /// No description provided for @decisionRestoreAi.
  ///
  /// In tr, this message translates to:
  /// **'Geri yükle (YZ kararını geri al)'**
  String get decisionRestoreAi;

  /// No description provided for @dashboardModerationAutoRejected.
  ///
  /// In tr, this message translates to:
  /// **'YZ\'nin kaldırdıkları (24 sa)'**
  String get dashboardModerationAutoRejected;

  /// No description provided for @dashboardModerationUnscored.
  ///
  /// In tr, this message translates to:
  /// **'Skorlanamayan'**
  String get dashboardModerationUnscored;

  /// No description provided for @moderationMetricsTitle.
  ///
  /// In tr, this message translates to:
  /// **'YZ moderasyon metrikleri'**
  String get moderationMetricsTitle;

  /// No description provided for @moderationMetricsSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Model {model} · otomatik yayın < {approve} · inceleme {approve}–{reject} · otomatik kaldırma ≥ {reject}'**
  String moderationMetricsSubtitle(String model, String approve, String reject);

  /// No description provided for @moderationMetricsPeriod.
  ///
  /// In tr, this message translates to:
  /// **'Dönem'**
  String get moderationMetricsPeriod;

  /// No description provided for @moderationMetricsDays.
  ///
  /// In tr, this message translates to:
  /// **'Son {count} gün'**
  String moderationMetricsDays(int count);

  /// No description provided for @moderationMetricsBack.
  ///
  /// In tr, this message translates to:
  /// **'Kuyruğa dön'**
  String get moderationMetricsBack;

  /// No description provided for @moderationMetricsModeOff.
  ///
  /// In tr, this message translates to:
  /// **'YZ moderasyonu kapalı (mod: {mode}). Metrikler yalnızca YZ modunda dolar.'**
  String moderationMetricsModeOff(String mode);

  /// No description provided for @metricsShared.
  ///
  /// In tr, this message translates to:
  /// **'Paylaşılan anı'**
  String get metricsShared;

  /// No description provided for @metricsAutoApproved.
  ///
  /// In tr, this message translates to:
  /// **'Otomatik yayınlanan'**
  String get metricsAutoApproved;

  /// No description provided for @metricsReview.
  ///
  /// In tr, this message translates to:
  /// **'İncelemeye düşen'**
  String get metricsReview;

  /// No description provided for @metricsAutoRejected.
  ///
  /// In tr, this message translates to:
  /// **'Otomatik kaldırılan'**
  String get metricsAutoRejected;

  /// No description provided for @metricsUnscored.
  ///
  /// In tr, this message translates to:
  /// **'Skorlanamayan'**
  String get metricsUnscored;

  /// No description provided for @metricsShareOfTotal.
  ///
  /// In tr, this message translates to:
  /// **'Toplamın %{percent}\'i'**
  String metricsShareOfTotal(String percent);

  /// No description provided for @metricsHumanReviewTitle.
  ///
  /// In tr, this message translates to:
  /// **'İnsan incelemesi'**
  String get metricsHumanReviewTitle;

  /// No description provided for @metricsWaiting.
  ///
  /// In tr, this message translates to:
  /// **'Kuyrukta bekleyen'**
  String get metricsWaiting;

  /// No description provided for @metricsOldestWaiting.
  ///
  /// In tr, this message translates to:
  /// **'En eski bekleyen'**
  String get metricsOldestWaiting;

  /// No description provided for @metricsDecided.
  ///
  /// In tr, this message translates to:
  /// **'Karara bağlanan (inceleme bandı)'**
  String get metricsDecided;

  /// No description provided for @metricsReviewApproved.
  ///
  /// In tr, this message translates to:
  /// **'Yayınlanan'**
  String get metricsReviewApproved;

  /// No description provided for @metricsReviewRejected.
  ///
  /// In tr, this message translates to:
  /// **'Kaldırılan'**
  String get metricsReviewRejected;

  /// No description provided for @metricsMedianDecision.
  ///
  /// In tr, this message translates to:
  /// **'Medyan karar süresi'**
  String get metricsMedianDecision;

  /// No description provided for @metricsMinutes.
  ///
  /// In tr, this message translates to:
  /// **'{count} dk'**
  String metricsMinutes(int count);

  /// No description provided for @metricsHours.
  ///
  /// In tr, this message translates to:
  /// **'{hours} sa {minutes} dk'**
  String metricsHours(int hours, int minutes);

  /// No description provided for @metricsDaysDuration.
  ///
  /// In tr, this message translates to:
  /// **'{count} gün'**
  String metricsDaysDuration(int count);

  /// No description provided for @metricsAccuracyTitle.
  ///
  /// In tr, this message translates to:
  /// **'Doğruluk (personel düzeltmeleri)'**
  String get metricsAccuracyTitle;

  /// No description provided for @metricsAutoRejectRestored.
  ///
  /// In tr, this message translates to:
  /// **'Geri yüklenen otomatik kaldırma'**
  String get metricsAutoRejectRestored;

  /// No description provided for @metricsAutoApproveRemoved.
  ///
  /// In tr, this message translates to:
  /// **'Sonradan kaldırılan otomatik yayın'**
  String get metricsAutoApproveRemoved;

  /// No description provided for @metricsOverrideRate.
  ///
  /// In tr, this message translates to:
  /// **'YZ kaldırmalarında geri alma oranı'**
  String get metricsOverrideRate;

  /// No description provided for @metricsReviewApprovalRate.
  ///
  /// In tr, this message translates to:
  /// **'İncelemede yayınlanma oranı'**
  String get metricsReviewApprovalRate;

  /// No description provided for @metricsPercent.
  ///
  /// In tr, this message translates to:
  /// **'%{percent}'**
  String metricsPercent(String percent);

  /// No description provided for @metricsHistogramTitle.
  ///
  /// In tr, this message translates to:
  /// **'Skor dağılımı ve bugünkü durum'**
  String get metricsHistogramTitle;

  /// No description provided for @metricsBinLabel.
  ///
  /// In tr, this message translates to:
  /// **'{from}–{to} · {approved} yayında · {pending} bekleyen · {rejected} kaldırılan'**
  String metricsBinLabel(
    String from,
    String to,
    int approved,
    int pending,
    int rejected,
  );

  /// No description provided for @metricsCategoriesTitle.
  ///
  /// In tr, this message translates to:
  /// **'İncelenen ve kaldırılanlarda kategori'**
  String get metricsCategoriesTitle;

  /// No description provided for @metricsModelTitle.
  ///
  /// In tr, this message translates to:
  /// **'Model ve eşikler'**
  String get metricsModelTitle;

  /// No description provided for @metricsModelVersion.
  ///
  /// In tr, this message translates to:
  /// **'Model sürümü'**
  String get metricsModelVersion;

  /// No description provided for @metricsApproveThreshold.
  ///
  /// In tr, this message translates to:
  /// **'Otomatik yayın'**
  String get metricsApproveThreshold;

  /// No description provided for @metricsRejectThreshold.
  ///
  /// In tr, this message translates to:
  /// **'Otomatik kaldırma'**
  String get metricsRejectThreshold;

  /// No description provided for @metricsPhotoRule.
  ///
  /// In tr, this message translates to:
  /// **'Fotoğraflı anılar'**
  String get metricsPhotoRule;

  /// No description provided for @metricsPhotoRuleReview.
  ///
  /// In tr, this message translates to:
  /// **'İncelemeye gönderilir'**
  String get metricsPhotoRuleReview;

  /// No description provided for @metricsPhotoRuleText.
  ///
  /// In tr, this message translates to:
  /// **'Metne göre karar'**
  String get metricsPhotoRuleText;

  /// No description provided for @metricsLatencyP50.
  ///
  /// In tr, this message translates to:
  /// **'Skorlama süresi (medyan)'**
  String get metricsLatencyP50;

  /// No description provided for @metricsLatencyP95.
  ///
  /// In tr, this message translates to:
  /// **'Skorlama süresi (p95)'**
  String get metricsLatencyP95;

  /// No description provided for @metricsMs.
  ///
  /// In tr, this message translates to:
  /// **'{count} ms'**
  String metricsMs(int count);

  /// No description provided for @metricsDailyTitle.
  ///
  /// In tr, this message translates to:
  /// **'Günlük karar dağılımı'**
  String get metricsDailyTitle;

  /// No description provided for @metricsDayLine.
  ///
  /// In tr, this message translates to:
  /// **'{approved} yayın · {review} inceleme · {rejected} kaldırma'**
  String metricsDayLine(int approved, int review, int rejected);

  /// No description provided for @metricsNoData.
  ///
  /// In tr, this message translates to:
  /// **'Bu dönemde YZ\'nin değerlendirdiği anı yok.'**
  String get metricsNoData;

  /// No description provided for @editorTabParts.
  ///
  /// In tr, this message translates to:
  /// **'Bölümler'**
  String get editorTabParts;

  /// No description provided for @editorPartsHelp.
  ///
  /// In tr, this message translates to:
  /// **'VGM verisindeki bölümler (ör. cami ve medrese kısımları). Uygulamada eser sayfasında ayrı başlıklarla gösterilir; Türkçe metin zorunludur, İngilizce boşsa Türkçe gösterilir.'**
  String get editorPartsHelp;

  /// No description provided for @editorPartsEmpty.
  ///
  /// In tr, this message translates to:
  /// **'Bölüm yok.'**
  String get editorPartsEmpty;

  /// No description provided for @editorPartsError.
  ///
  /// In tr, this message translates to:
  /// **'Her bölümün Türkçe metni olmalıdır.'**
  String get editorPartsError;

  /// No description provided for @editorPartTitle.
  ///
  /// In tr, this message translates to:
  /// **'Bölüm {index}'**
  String editorPartTitle(int index);

  /// No description provided for @editorPartRemove.
  ///
  /// In tr, this message translates to:
  /// **'Bölümü kaldır'**
  String get editorPartRemove;

  /// No description provided for @editorPartAdd.
  ///
  /// In tr, this message translates to:
  /// **'Bölüm ekle'**
  String get editorPartAdd;

  /// No description provided for @editorPartFieldTitleTr.
  ///
  /// In tr, this message translates to:
  /// **'Başlık (Türkçe)'**
  String get editorPartFieldTitleTr;

  /// No description provided for @editorPartFieldTitleEn.
  ///
  /// In tr, this message translates to:
  /// **'Başlık (İngilizce)'**
  String get editorPartFieldTitleEn;

  /// No description provided for @editorPartFieldDescriptionTr.
  ///
  /// In tr, this message translates to:
  /// **'Metin (Türkçe)'**
  String get editorPartFieldDescriptionTr;

  /// No description provided for @editorPartFieldDescriptionEn.
  ///
  /// In tr, this message translates to:
  /// **'Metin (İngilizce)'**
  String get editorPartFieldDescriptionEn;

  /// No description provided for @editorFieldNickname.
  ///
  /// In tr, this message translates to:
  /// **'Halk arasındaki adı'**
  String get editorFieldNickname;

  /// No description provided for @editorImagePart.
  ///
  /// In tr, this message translates to:
  /// **'Bölüm {index}'**
  String editorImagePart(int index);

  /// No description provided for @catalogFilterLocation.
  ///
  /// In tr, this message translates to:
  /// **'Konum'**
  String get catalogFilterLocation;

  /// No description provided for @catalogLocationPresent.
  ///
  /// In tr, this message translates to:
  /// **'Konumu girilmiş'**
  String get catalogLocationPresent;

  /// No description provided for @catalogLocationMissing.
  ///
  /// In tr, this message translates to:
  /// **'Konumu eksik'**
  String get catalogLocationMissing;

  /// No description provided for @catalogNoLocation.
  ///
  /// In tr, this message translates to:
  /// **'Konum yok'**
  String get catalogNoLocation;

  /// No description provided for @catalogImport.
  ///
  /// In tr, this message translates to:
  /// **'İçe aktar'**
  String get catalogImport;

  /// No description provided for @errorConflictImportImages.
  ///
  /// In tr, this message translates to:
  /// **'Bazı görseller henüz yüklenmedi. İçe aktarımı yeniden başlatın; yalnızca eksik görseller gönderilir.'**
  String get errorConflictImportImages;

  /// No description provided for @importTitle.
  ///
  /// In tr, this message translates to:
  /// **'VGM verisini içe aktar'**
  String get importTitle;

  /// No description provided for @importSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Eser ve külliye verisi (JSON) ile görsellerini kataloğa aktarır'**
  String get importSubtitle;

  /// No description provided for @importSourceTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kaynak klasör'**
  String get importSourceTitle;

  /// No description provided for @importSourceHelp.
  ///
  /// In tr, this message translates to:
  /// **'Veri dosyasını (root42-veri.json) ve images klasörünü içeren klasörü seçin. Görsel yolları veri dosyasına göredir.'**
  String get importSourceHelp;

  /// No description provided for @importNoFolder.
  ///
  /// In tr, this message translates to:
  /// **'Klasör seçilmedi'**
  String get importNoFolder;

  /// No description provided for @importPickFolder.
  ///
  /// In tr, this message translates to:
  /// **'Klasör seç'**
  String get importPickFolder;

  /// No description provided for @importChangeFolder.
  ///
  /// In tr, this message translates to:
  /// **'Klasörü değiştir'**
  String get importChangeFolder;

  /// No description provided for @importNoJson.
  ///
  /// In tr, this message translates to:
  /// **'Klasörde veri dosyası (.json) bulunamadı.'**
  String get importNoJson;

  /// No description provided for @importJsonFile.
  ///
  /// In tr, this message translates to:
  /// **'Veri dosyası'**
  String get importJsonFile;

  /// No description provided for @importLocalSummary.
  ///
  /// In tr, this message translates to:
  /// **'{count} görsel dosyası okundu ({megabytes} MB).'**
  String importLocalSummary(int count, String megabytes);

  /// No description provided for @importReading.
  ///
  /// In tr, this message translates to:
  /// **'Dosyalar okunuyor ve görsel özetleri hesaplanıyor…'**
  String get importReading;

  /// No description provided for @importPlanning.
  ///
  /// In tr, this message translates to:
  /// **'Sunucu dosyayı denetliyor…'**
  String get importPlanning;

  /// No description provided for @importPlanTitle.
  ///
  /// In tr, this message translates to:
  /// **'İçe aktarım planı'**
  String get importPlanTitle;

  /// No description provided for @importStatusValid.
  ///
  /// In tr, this message translates to:
  /// **'Geçerli'**
  String get importStatusValid;

  /// No description provided for @importStatusInvalid.
  ///
  /// In tr, this message translates to:
  /// **'Hatalı'**
  String get importStatusInvalid;

  /// No description provided for @importStatusCommitted.
  ///
  /// In tr, this message translates to:
  /// **'Tamamlandı'**
  String get importStatusCommitted;

  /// No description provided for @importCountComplexes.
  ///
  /// In tr, this message translates to:
  /// **'Külliye'**
  String get importCountComplexes;

  /// No description provided for @importCountWorks.
  ///
  /// In tr, this message translates to:
  /// **'Eser'**
  String get importCountWorks;

  /// No description provided for @importCountParts.
  ///
  /// In tr, this message translates to:
  /// **'Bölüm'**
  String get importCountParts;

  /// No description provided for @importCountImages.
  ///
  /// In tr, this message translates to:
  /// **'Görsel'**
  String get importCountImages;

  /// No description provided for @importCountImagesValue.
  ///
  /// In tr, this message translates to:
  /// **'{total} ({unique} farklı dosya)'**
  String importCountImagesValue(int total, int unique);

  /// No description provided for @importCountNew.
  ///
  /// In tr, this message translates to:
  /// **'Eklenecek kayıt'**
  String get importCountNew;

  /// No description provided for @importCountExisting.
  ///
  /// In tr, this message translates to:
  /// **'Güncellenecek kayıt'**
  String get importCountExisting;

  /// No description provided for @importCountMissingImages.
  ///
  /// In tr, this message translates to:
  /// **'Yüklenecek görsel'**
  String get importCountMissingImages;

  /// No description provided for @importMergeNotice.
  ///
  /// In tr, this message translates to:
  /// **'Var olan kayıtlarda panelde girilen konum, tarihçe, bani, mimar ve düzeltilmiş tür/dönem korunur. Veri dosyasında konum olmadığından yeni eserler konumu girilene kadar haritada görünmez.'**
  String get importMergeNotice;

  /// No description provided for @importStart.
  ///
  /// In tr, this message translates to:
  /// **'İçe aktar'**
  String get importStart;

  /// No description provided for @importStartWithImages.
  ///
  /// In tr, this message translates to:
  /// **'{count} görseli yükle ve içe aktar'**
  String importStartWithImages(int count);

  /// No description provided for @importCancel.
  ///
  /// In tr, this message translates to:
  /// **'Durdur'**
  String get importCancel;

  /// No description provided for @importCancelling.
  ///
  /// In tr, this message translates to:
  /// **'Sürmekte olan yüklemeler bitince durulacak…'**
  String get importCancelling;

  /// No description provided for @importProgressTitle.
  ///
  /// In tr, this message translates to:
  /// **'İlerleme'**
  String get importProgressTitle;

  /// No description provided for @importUploadProgress.
  ///
  /// In tr, this message translates to:
  /// **'{done} / {total} görsel yüklendi'**
  String importUploadProgress(int done, int total);

  /// No description provided for @importUploadFailed.
  ///
  /// In tr, this message translates to:
  /// **'{count} görsel yüklenemedi. Yeniden başlatınca yalnızca eksikler gönderilir.'**
  String importUploadFailed(int count);

  /// No description provided for @importCommitting.
  ///
  /// In tr, this message translates to:
  /// **'Kayıtlar kataloğa yazılıyor…'**
  String get importCommitting;

  /// No description provided for @importResultTitle.
  ///
  /// In tr, this message translates to:
  /// **'Sonuç'**
  String get importResultTitle;

  /// No description provided for @importResultCreated.
  ///
  /// In tr, this message translates to:
  /// **'Eklenen eser'**
  String get importResultCreated;

  /// No description provided for @importResultUpdated.
  ///
  /// In tr, this message translates to:
  /// **'Güncellenen eser'**
  String get importResultUpdated;

  /// No description provided for @importResultComplexesCreated.
  ///
  /// In tr, this message translates to:
  /// **'Eklenen külliye'**
  String get importResultComplexesCreated;

  /// No description provided for @importResultComplexesUpdated.
  ///
  /// In tr, this message translates to:
  /// **'Güncellenen külliye'**
  String get importResultComplexesUpdated;

  /// No description provided for @importResultVersion.
  ///
  /// In tr, this message translates to:
  /// **'Katalog sürümü'**
  String get importResultVersion;

  /// No description provided for @importOpenMissingLocation.
  ///
  /// In tr, this message translates to:
  /// **'Konumu eksik eserleri aç'**
  String get importOpenMissingLocation;

  /// No description provided for @importErrorsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Hatalar ({count})'**
  String importErrorsTitle(int count);

  /// No description provided for @importWarningsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Uyarılar ({count})'**
  String importWarningsTitle(int count);

  /// No description provided for @importMoreIssues.
  ///
  /// In tr, this message translates to:
  /// **'… ve {count} bulgu daha'**
  String importMoreIssues(int count);

  /// No description provided for @importPlanReady.
  ///
  /// In tr, this message translates to:
  /// **'Dosya geçerli; içe aktarım planı hazır.'**
  String get importPlanReady;

  /// No description provided for @importPlanInvalid.
  ///
  /// In tr, this message translates to:
  /// **'Dosyada hatalar var; içe aktarılamaz.'**
  String get importPlanInvalid;

  /// No description provided for @importDone.
  ///
  /// In tr, this message translates to:
  /// **'İçe aktarım tamamlandı.'**
  String get importDone;

  /// No description provided for @importLeaveTitle.
  ///
  /// In tr, this message translates to:
  /// **'İçe aktarım sürüyor'**
  String get importLeaveTitle;

  /// No description provided for @importLeaveMessage.
  ///
  /// In tr, this message translates to:
  /// **'Sayfadan çıkarsanız yükleme durur. Yüklenen görseller saklanır; yeniden başlatınca kalanlar gönderilir.'**
  String get importLeaveMessage;

  /// No description provided for @importIssueInvalidJson.
  ///
  /// In tr, this message translates to:
  /// **'Dosya şemaya uygun JSON değil'**
  String get importIssueInvalidJson;

  /// No description provided for @importIssueMissingFile.
  ///
  /// In tr, this message translates to:
  /// **'Görsel dosyası bulunamadı'**
  String get importIssueMissingFile;

  /// No description provided for @importIssueFileTooLarge.
  ///
  /// In tr, this message translates to:
  /// **'Görsel 5 MB\'tan büyük'**
  String get importIssueFileTooLarge;

  /// No description provided for @importIssueFormatVersion.
  ///
  /// In tr, this message translates to:
  /// **'Desteklenmeyen biçim sürümü'**
  String get importIssueFormatVersion;

  /// No description provided for @importIssueRequired.
  ///
  /// In tr, this message translates to:
  /// **'Zorunlu alan boş'**
  String get importIssueRequired;

  /// No description provided for @importIssueTooLong.
  ///
  /// In tr, this message translates to:
  /// **'Alan çok uzun'**
  String get importIssueTooLong;

  /// No description provided for @importIssueInvalidKey.
  ///
  /// In tr, this message translates to:
  /// **'Geçersiz anahtar (küçük harf, rakam ve tire; en çok 111 karakter)'**
  String get importIssueInvalidKey;

  /// No description provided for @importIssueDuplicateKey.
  ///
  /// In tr, this message translates to:
  /// **'Anahtar birden çok kez kullanılmış'**
  String get importIssueDuplicateKey;

  /// No description provided for @importIssueSlug.
  ///
  /// In tr, this message translates to:
  /// **'Geçersiz veya tekrarlanan kısa ad (slug)'**
  String get importIssueSlug;

  /// No description provided for @importIssueUnknownCity.
  ///
  /// In tr, this message translates to:
  /// **'Bilinmeyen il kodu'**
  String get importIssueUnknownCity;

  /// No description provided for @importIssueInvalidSrc.
  ///
  /// In tr, this message translates to:
  /// **'Geçersiz görsel yolu'**
  String get importIssueInvalidSrc;

  /// No description provided for @importIssueTooManyImages.
  ///
  /// In tr, this message translates to:
  /// **'Çok fazla görsel'**
  String get importIssueTooManyImages;

  /// No description provided for @importIssueUnknownMember.
  ///
  /// In tr, this message translates to:
  /// **'Külliyedeki eser dosyada yok'**
  String get importIssueUnknownMember;

  /// No description provided for @importIssueMemberTwice.
  ///
  /// In tr, this message translates to:
  /// **'Eser iki külliyede birden'**
  String get importIssueMemberTwice;

  /// No description provided for @importIssueMemberCity.
  ///
  /// In tr, this message translates to:
  /// **'Eserin ili külliyeninkinden farklı'**
  String get importIssueMemberCity;

  /// No description provided for @importIssueDuplicateMember.
  ///
  /// In tr, this message translates to:
  /// **'Külliyede aynı eser iki kez'**
  String get importIssueDuplicateMember;

  /// No description provided for @importWarningRenamed.
  ///
  /// In tr, this message translates to:
  /// **'Külliye anahtarı bir eserle aynı; kimliği değiştirildi'**
  String get importWarningRenamed;

  /// No description provided for @importWarningCategory.
  ///
  /// In tr, this message translates to:
  /// **'Tür addan çıkarılamadı (Diğer)'**
  String get importWarningCategory;

  /// No description provided for @importWarningDuplicateTitle.
  ///
  /// In tr, this message translates to:
  /// **'Aynı adda başka eser var'**
  String get importWarningDuplicateTitle;

  /// No description provided for @importWarningNoDistrict.
  ///
  /// In tr, this message translates to:
  /// **'İlçe adresten çıkarılamadı'**
  String get importWarningNoDistrict;

  /// No description provided for @importWarningNoImages.
  ///
  /// In tr, this message translates to:
  /// **'Görseli yok'**
  String get importWarningNoImages;

  /// No description provided for @reportsFilterEvidence.
  ///
  /// In tr, this message translates to:
  /// **'YZ kanıtı'**
  String get reportsFilterEvidence;

  /// No description provided for @reportsSortEvidence.
  ///
  /// In tr, this message translates to:
  /// **'Aciliyet, sonra YZ kanıtı'**
  String get reportsSortEvidence;

  /// No description provided for @reportSectionEvidence.
  ///
  /// In tr, this message translates to:
  /// **'Yapay zekâ kanıt değerlendirmesi'**
  String get reportSectionEvidence;

  /// No description provided for @evidenceLevelStrong.
  ///
  /// In tr, this message translates to:
  /// **'Kanıt güçlü'**
  String get evidenceLevelStrong;

  /// No description provided for @evidenceLevelUnverified.
  ///
  /// In tr, this message translates to:
  /// **'Doğrulanamadı'**
  String get evidenceLevelUnverified;

  /// No description provided for @evidenceLevelSuspicious.
  ///
  /// In tr, this message translates to:
  /// **'Şüpheli'**
  String get evidenceLevelSuspicious;

  /// No description provided for @evidenceLevelPending.
  ///
  /// In tr, this message translates to:
  /// **'Değerlendirilmedi'**
  String get evidenceLevelPending;

  /// No description provided for @evidenceChip.
  ///
  /// In tr, this message translates to:
  /// **'YZ: {level}'**
  String evidenceChip(String level);

  /// No description provided for @evidenceChipSemantics.
  ///
  /// In tr, this message translates to:
  /// **'Yapay zekâ kanıt etiketi: {level}'**
  String evidenceChipSemantics(String level);

  /// No description provided for @evidenceLevelLabel.
  ///
  /// In tr, this message translates to:
  /// **'Etiket'**
  String get evidenceLevelLabel;

  /// No description provided for @evidenceHelpStrong.
  ///
  /// In tr, this message translates to:
  /// **'Olumsuz işaret yok; en az iki bağımsız kanıt ya da bir bağımsız kanıt ve hasar tarif eden açıklama var. Önce bakılabilir.'**
  String get evidenceHelpStrong;

  /// No description provided for @evidenceHelpUnverified.
  ///
  /// In tr, this message translates to:
  /// **'Olumsuz işaret yok ama kanıt zayıf. Normal inceleme.'**
  String get evidenceHelpUnverified;

  /// No description provided for @evidenceHelpSuspicious.
  ///
  /// In tr, this message translates to:
  /// **'Somut olumsuz işaret var ya da açıklama hasar tarif etmiyor ve hiçbir destek yok. Dikkatli bakın; aciliyet sırası değişmez.'**
  String get evidenceHelpSuspicious;

  /// No description provided for @evidenceHelpPending.
  ///
  /// In tr, this message translates to:
  /// **'Bildirim henüz skorlanmadı; arka planda değerlendirilir (moderasyon servisi kapalıysa 24 saat boyunca yeniden denenir).'**
  String get evidenceHelpPending;

  /// No description provided for @evidenceDisclaimer.
  ///
  /// In tr, this message translates to:
  /// **'Etiket yalnızca yardımcıdır: durumu değiştirmez ve vatandaşa gösterilmez. YZ bildirimin doğru olup olmadığını bilemez, yalnızca kanıtın gücünü ölçer.'**
  String get evidenceDisclaimer;

  /// No description provided for @evidenceSupports.
  ///
  /// In tr, this message translates to:
  /// **'Destekleyen'**
  String get evidenceSupports;

  /// No description provided for @evidenceUndermines.
  ///
  /// In tr, this message translates to:
  /// **'Zayıflatan'**
  String get evidenceUndermines;

  /// No description provided for @evidenceNeutral.
  ///
  /// In tr, this message translates to:
  /// **'Bilgi'**
  String get evidenceNeutral;

  /// No description provided for @evidenceReasonSemantics.
  ///
  /// In tr, this message translates to:
  /// **'{effect}: {reason}'**
  String evidenceReasonSemantics(String effect, String reason);

  /// No description provided for @evidenceLocationOnSite.
  ///
  /// In tr, this message translates to:
  /// **'Konum yerinde: esere {distance} m'**
  String evidenceLocationOnSite(int distance);

  /// No description provided for @evidenceLocationDistant.
  ///
  /// In tr, this message translates to:
  /// **'Konum eserden uzak: {distance} m'**
  String evidenceLocationDistant(int distance);

  /// No description provided for @evidenceLocationNotProvided.
  ///
  /// In tr, this message translates to:
  /// **'Konum eklenmemiş'**
  String get evidenceLocationNotProvided;

  /// No description provided for @evidenceCorroborated.
  ///
  /// In tr, this message translates to:
  /// **'Son 14 günde {count} başka hesaptan aynı esere bildirim'**
  String evidenceCorroborated(int count);

  /// No description provided for @evidencePhotoMatches.
  ///
  /// In tr, this message translates to:
  /// **'Fotoğraf eserin katalog görsellerine benziyor (benzerlik {score})'**
  String evidencePhotoMatches(String score);

  /// No description provided for @evidencePhotoLowSimilarity.
  ///
  /// In tr, this message translates to:
  /// **'Fotoğraf katalog görsellerine benzemiyor (benzerlik {score}); hasar yakın çekimi olabilir, olumsuz sayılmaz'**
  String evidencePhotoLowSimilarity(String score);

  /// No description provided for @evidencePhotoNone.
  ///
  /// In tr, this message translates to:
  /// **'Fotoğraf eklenmemiş'**
  String get evidencePhotoNone;

  /// No description provided for @evidencePhotoUnreadable.
  ///
  /// In tr, this message translates to:
  /// **'{count} fotoğraf okunamadı'**
  String evidencePhotoUnreadable(int count);

  /// No description provided for @evidencePhotoCatalogCopy.
  ///
  /// In tr, this message translates to:
  /// **'Fotoğraf bir katalog görselinin kopyası olabilir (benzerlik {score})'**
  String evidencePhotoCatalogCopy(String score);

  /// No description provided for @evidencePhotoNsfw.
  ///
  /// In tr, this message translates to:
  /// **'Müstehcen fotoğraf (olasılık {score})'**
  String evidencePhotoNsfw(String score);

  /// No description provided for @evidenceTextDescribesDamage.
  ///
  /// In tr, this message translates to:
  /// **'Açıklama hasar tarif ediyor (skor {score})'**
  String evidenceTextDescribesDamage(String score);

  /// No description provided for @evidenceTextWeakDamage.
  ///
  /// In tr, this message translates to:
  /// **'Açıklamanın hasar tarifi belirsiz (skor {score})'**
  String evidenceTextWeakDamage(String score);

  /// No description provided for @evidenceTextNotDamage.
  ///
  /// In tr, this message translates to:
  /// **'Açıklama hasar tarif etmiyor (skor {score})'**
  String evidenceTextNotDamage(String score);

  /// No description provided for @evidenceTextAbusive.
  ///
  /// In tr, this message translates to:
  /// **'Açıklamada hakaret / zararlı dil (skor {score})'**
  String evidenceTextAbusive(String score);

  /// No description provided for @evidenceTextSpam.
  ///
  /// In tr, this message translates to:
  /// **'Açıklama spam kuralına uyuyor: {signals}'**
  String evidenceTextSpam(String signals);

  /// No description provided for @evidenceTextContact.
  ///
  /// In tr, this message translates to:
  /// **'Açıklamada iletişim bilgisi var ({signals}); kişisel veri olabilir'**
  String evidenceTextContact(String signals);

  /// No description provided for @evidenceCategorySuggested.
  ///
  /// In tr, this message translates to:
  /// **'Açıklama başka bir türe daha yakın: {category} (yalnızca öneri)'**
  String evidenceCategorySuggested(String category);

  /// No description provided for @evidenceUrgencyUnsupported.
  ///
  /// In tr, this message translates to:
  /// **'Aciliyet \"{urgency}\" ama bağımsız kanıt yok (sıra değişmez)'**
  String evidenceUrgencyUnsupported(String urgency);

  /// No description provided for @evidenceUnknown.
  ///
  /// In tr, this message translates to:
  /// **'Diğer sinyal: {code}'**
  String evidenceUnknown(String code);

  /// No description provided for @dashboardOpenByEvidence.
  ///
  /// In tr, this message translates to:
  /// **'Açık bildirimler, YZ kanıtına göre'**
  String get dashboardOpenByEvidence;

  /// No description provided for @aiSpamSignalContact.
  ///
  /// In tr, this message translates to:
  /// **'iletişim bilgisi'**
  String get aiSpamSignalContact;

  /// No description provided for @aiSpamSignalPromotion.
  ///
  /// In tr, this message translates to:
  /// **'ticari teklif'**
  String get aiSpamSignalPromotion;

  /// No description provided for @aiSpamSignalScam.
  ///
  /// In tr, this message translates to:
  /// **'dolandırıcılık kalıbı'**
  String get aiSpamSignalScam;

  /// No description provided for @aiCategoryNsfw.
  ///
  /// In tr, this message translates to:
  /// **'Müstehcen fotoğraf'**
  String get aiCategoryNsfw;

  /// No description provided for @aiCategoryUnrelated.
  ///
  /// In tr, this message translates to:
  /// **'Eserle ilgisiz'**
  String get aiCategoryUnrelated;

  /// No description provided for @aiCategorySpam.
  ///
  /// In tr, this message translates to:
  /// **'Spam / reklam'**
  String get aiCategorySpam;

  /// No description provided for @aiReviewCauseNsfw.
  ///
  /// In tr, this message translates to:
  /// **'Fotoğraf müstehcen olabilir'**
  String get aiReviewCauseNsfw;

  /// No description provided for @aiReviewCauseSpam.
  ///
  /// In tr, this message translates to:
  /// **'İletişim bilgisi var (olası spam)'**
  String get aiReviewCauseSpam;

  /// No description provided for @aiReviewCauseUnrelated.
  ///
  /// In tr, this message translates to:
  /// **'Fotoğraf esere benzemiyor'**
  String get aiReviewCauseUnrelated;

  /// No description provided for @aiReviewCauseContext.
  ///
  /// In tr, this message translates to:
  /// **'Metnin eserle bağlamı zayıf'**
  String get aiReviewCauseContext;

  /// No description provided for @aiSpamLabel.
  ///
  /// In tr, this message translates to:
  /// **'Spam skoru'**
  String get aiSpamLabel;

  /// No description provided for @aiSpamSignalsLabel.
  ///
  /// In tr, this message translates to:
  /// **'Eşleşen spam kuralları'**
  String get aiSpamSignalsLabel;

  /// No description provided for @aiRelevanceLabel.
  ///
  /// In tr, this message translates to:
  /// **'Metnin eserle bağlamı'**
  String get aiRelevanceLabel;

  /// No description provided for @aiNsfwLabel.
  ///
  /// In tr, this message translates to:
  /// **'Müstehcenlik (en yüksek fotoğraf)'**
  String get aiNsfwLabel;

  /// No description provided for @aiSimilarityLabel.
  ///
  /// In tr, this message translates to:
  /// **'Esere benzerlik (en düşük fotoğraf)'**
  String get aiSimilarityLabel;

  /// No description provided for @aiVisionModelLabel.
  ///
  /// In tr, this message translates to:
  /// **'Görsel model'**
  String get aiVisionModelLabel;

  /// No description provided for @aiContextModelLabel.
  ///
  /// In tr, this message translates to:
  /// **'Bağlam indeksi'**
  String get aiContextModelLabel;

  /// No description provided for @aiPhotoScores.
  ///
  /// In tr, this message translates to:
  /// **'Fotoğraf skorları'**
  String get aiPhotoScores;

  /// No description provided for @aiPhotoLabel.
  ///
  /// In tr, this message translates to:
  /// **'Fotoğraf {index}'**
  String aiPhotoLabel(int index);

  /// No description provided for @aiPhotoScoresValue.
  ///
  /// In tr, this message translates to:
  /// **'müstehcenlik {nsfw} · esere benzerlik {similarity}'**
  String aiPhotoScoresValue(String nsfw, String similarity);

  /// No description provided for @aiPhotoNoReference.
  ///
  /// In tr, this message translates to:
  /// **'referans görseli yok'**
  String get aiPhotoNoReference;

  /// No description provided for @aiPhotoUnreadable.
  ///
  /// In tr, this message translates to:
  /// **'okunamadı'**
  String get aiPhotoUnreadable;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
