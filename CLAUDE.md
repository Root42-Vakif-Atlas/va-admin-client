# Vakıf Atlas Yönetim (VGM Yönetim Paneli) — Claude Code Proje Bağlamı

> Vatandaş uygulamasının (`../vakif_atlas`) kardeş istemcisidir. Kök `../CLAUDE.md`'deki kod
> kuralları ve ADR'ler (saf Dart domain, `Either`, ADR 9/11/14/42/45/50/51/54) burada da geçerlidir;
> bu dosya yalnızca farkları anlatır. Backend sözleşmesi: `../docs/api-contracts.md` →
> "Personel (Yönetim Paneli) API".

## Proje Özeti

VGM personeli için **masaüstü** yönetim istemcisi (macOS + Windows öncelikli, Linux en iyi çaba;
mobil/web hedef değil): katalog CRUD, Sivil Koruma inceleme süreci, Anı Köşesi moderasyonu ve
şikâyetleri, geri bildirim triajı, personel yönetimi ve denetim kaydı. **Yok:** harita, TTS/STT,
gelişmiş erişilebilirlik paneli, renk körlüğü filtresi, oyunlaştırma, kayıt/e-posta doğrulama,
flavor (ortam yalnızca `--dart-define-from-file=config/<env>.json`).

## Klasör Yapısı

```
lib/
├── core/        # vatandaştan kopya + admin: network/preconditions.dart (If-Match, Idempotency-Key),
│                # utils/{paged,versioned,idempotency}.dart, keyboard/app_shortcuts.dart,
│                # session/idle_timer.dart, router/{routes,app_router,unsaved_changes}.dart, guards/auth_guard.dart
├── shared/      # paging/{paged_list_cubit,record_cubit}.dart, master_detail_layout, paged_list,
│                # status_chip, filter_menu (FilterToolbar/FilterMenu/SortMenu), admin_table, admin_dialogs,
│                # detail_section, photo_strip
└── features/
    ├── auth/              # personel girişi, TOTP doğrulama/kurulum (QR), kurtarma kodları, şifre sıfırlama
    ├── shell/             # AdminShell: koyu kenar çubuğu, role göre menü + rozetler, hesap menüsü
    ├── dashboard/         # özetler (2 dk'da bir yenilenir), kartlar süzgeçli listelere gider
    ├── catalog/           # eser tablosu + düzenleyici (Genel · TR · EN · Bölümler · Görseller · Külliye yapıları) + VGM içe aktarımı
    ├── civil_protection/  # rapor kuyruğu + ayrıntı (konum, fotoğraflar, durum geçişi, iç not)
    ├── moderation/        # anı kuyruğu (bekleyen / bildirilen / YZ'nin kaldırdıkları / …) + karar + YZ metrikleri
    ├── feedback/          # geri bildirim listesi + triaj
    ├── staff/             # personel (davet, roller, devre dışı, MFA sıfırla, oturum kapat) — vgm_admin
    ├── audit/             # denetim kaydı — vgm_admin
    ├── profile/           # roller, MFA durumu, kurtarma kodu yenileme, şifre değiştir (oyunlaştırma yok)
    └── settings/          # tema (sistem/açık/koyu + yüksek kontrast), dil, metin ölçeği, hareket azalt, kısayollar, Hakkında
```

## Admin Kararları (A-ADR)

| # | Karar | Gerekçe |
|:---|:---|:---|
| A1 | **Sade kurumsal palet:** Gece Moru `#21172B` yalnızca kenar çubuğu / giriş marka paneli (`AppColorScheme.sidebar`, `AppTheme.sidebar()`) ve birincil eylemdir (açık temada dolgu; koyu temada açık gri). Yüzeyler nötr gri (sayfa `gray50`, içerik kartı/tablo beyaz), Eski Bronz `#AC8058` **yalnızca amblemde** — kenarlık, şerit, rozet vurgusu yok. Renk yalnızca durum bilgisinde (`StatusChip` tonları). `test/core/theme/contrast_test.dart` sidebar dahil tüm şemaları AA/AAA'ya karşı denetler. | Mor zeminler + bronz şeritler + renkli ikonlu etiketler "kurumsal" görünmüyordu (2026-10-22 kullanıcı geri bildirimi). |
| A2 | **Personel oturumu ayrıdır ve MFA zorunludur:** `auth/staff/login` → `mfaToken` → TOTP / kurtarma kodu; ilk girişte kurulum (QR + kopyalanabilir sır) ve 10 kurtarma kodu — `completeEnrollment` kodlar kaydedildiği onaylanana kadar `SignedIn`'i erteler. Oturum (erişim/yenileme anahtarı + profil) **tek keychain öğesinde** `admin.auth.session.v2` (JSON), açılışta bir kez okunup bellekte tutulur (`SecureStorageService`). macOS'ta eski (login) keychain (`usesDataProtectionKeychain: false`, imzasız debug derlemesinde de çalışır): bu keychain imzası değişen uygulamaya (her ad-hoc derleme) öğe erişimi başına şifre sorar — ayrı öğeler ve istek başına okuma açılışta/yenilemede 3'er soru demekti; tek öğe ile derleme başına en çok bir kez ("Her Zaman İzin Ver"). Hiç sorulmaması için sabit imza gerekir (Apple Development / Developer ID; o durumda data protection keychain + `keychain-access-groups`). | Vatandaş anahtarı rol taşımaz; personel anahtarı `aud=vakif-atlas-admin`. |
| A3 | **30 dk hareketsizlik → oturum kapanır** (`IdleTimer`, `GuestReason.idle`; sunucuda yenileme de 30 dk / 12 saat). Giriş ekranı nedenini gösterir. | Ortak bilgisayarda açık bırakılan oturum. |
| A4 | **Rol bazlı gezinme ve koruma:** üç rol — Yönetici (`vgm_admin`, her şey + personel + denetim), Editör (`editor`, katalog), Moderatör (`moderator`, Anı Köşesi + Sivil Koruma + geri bildirim); rol seçiminde açıklamasıyla gösterilir. `StaffRole` → `StaffPermission`; `AppRoutes.permissionFor` + `AuthGuard` yetkisiz bölümü panoya yönlendirir, menü yalnızca izinli bölümleri gösterir. Sunucu yine de 404 döner (tek doğruluk kaynağı sunucu). | En az ayrıcalık. |
| A5 | **Ana-detay düzeni:** seçili kayıt yolda (`/civil-protection/:id`); listeler ortak sayfa anahtarıyla (`reports`, `moderation`, `feedback`, `staff`) korunur, ≥1024 px yan yana, dar pencerede detay tam sayfa. | Derin bağlantı, geri hareketi, liste durumu kaybolmaz. |
| A6 | **İyimser eşzamanlılık:** her ayrıntı `Versioned<T>` (değer + ETag) olarak yüklenir, yazma `If-Match` taşır; 412 → `StaleDataFailure` → "kayıt başkası tarafından değiştirildi" diyaloğu (yeniden yükle). Oluşturma `Idempotency-Key` (`core/utils/idempotency.dart`, saf Dart; aynı form tekrarında aynı anahtar). | Kayıp güncelleme olmaz; ağ tekrarı çift kayıt açmaz. |
| A7 | **Kaydedilmemiş değişiklik koruması** `GoRoute.onExit` + `UnsavedChangesScope` (katalog düzenleyici). | Veri kaybı. |
| A8 | **Klavye:** Cmd/Ctrl+F arama, +N yeni, +S kaydet, +R / F5 yenile, Esc paneli kapat (`AppShortcuts`); Ayarlar'da listelenir. | Masaüstü verimliliği (WCAG 2.1.1). |
| A9 | **İlişkiler listeden seçilir:** külliyenin yapıları (`showMembersPicker`, çoklu seçim; zaten bağlı olanlar seçilemez, başka külliyedeki yapı "taşınır" uyarısıyla) arama + sayfalı listeden seçilir; kimlik elle yazılmaz. Külliye ayrı kayıttır (kök ADR 60): oluştururken "Kayıt türü" Eser / Külliye; eserin külliyesi salt okunurdur ("Külliyeyi aç"), üyelik ve sıra yalnızca külliyenin "Külliye yapıları" sekmesinden (`PUT complexes/{key}/works`). İl, 81 ilin plaka koduyla seçilir (`TurkishProvinces`); tür varsayılan olarak addan türetilir ("Türü addan belirle" → `category: null`); "Etkin" (`isActive`). **Katalog görselleri** sistem dosya seçicisi (`file_selector`) → isolate'te ≤2400 px JPEG q88, EXIF silinir (`ImagePreparer`) → içerik adresli `PUT catalog/admin/imports/images/{sha256}` → kayıtta `sha256` (bilet yüklemesi sonraki kayıtta yeniden başvurulamadığı için kullanılmaz). Türkçe betim zorunlu; yeni görselde yazar ve lisans zorunlu. Konum enlem/boylam alanlarıdır (harita yok), Türkiye sınırı doğrulanır; "OpenStreetMap'te aç" `url_launcher`. | Lisans atfı (ADR 20), gizlilik, harita bağımlılığı yok. |
| A10 | **Pencere:** 1440×900 açılır, en küçük 1100×720 (macOS `MainFlutterWindow`, Windows `WM_GETMINMAXINFO`, Linux size request). macOS `PRODUCT_NAME` ASCII ("Vakıf Atlas Admin" — "ö" codesign'ı kırıyordu), görünen ad `CFBundleDisplayName` "Vakıf Atlas Yönetim". Entitlements: `network.client`, `files.user-selected.read-only`. | Tablo + detay sığar. |
| A11 | **Mock yoktur** (ADR 3): testlerde `test/support/fake_backend.dart` (`FakeBackend`, sonradan eklenen stub önce eşleşir) + `TestDependencies.setUp(transport:)`. Canlı doğrulama `tool/backend_app_e2e_test.dart` (compose açıkken; TOTP seed sırrından hesaplanır, aynı 30 sn adımı iki kez kullanılamaz; ekran görüntüleri `build/e2e_shots`). | Gerçek sözleşme uçtan uca. |
| A12 | **Tasarım dili: bilgi önce, ikon ve renkli kenarlık yok.** Tek font Inter (Cinzel kaldırıldı; sayılar `AppTypography.tabularFigures`). `StatusChip` ikonsuz: düşük doygunluklu zemin + durum renginde metin (yüksek kontrastta kontur); yayın durumu ("Yayında" / "Yayından kaldırıldı") korunur. Butonlar, boş durum (`StatusMessageView`), zaman çizelgesi ve liste satırlarında dekoratif ikon yok; seçili satır yalnızca nötr zemin (sol renk şeridi yok). Listeler: `FilterToolbar` = 40 px arama + açılır `FilterMenu` (çoklu/tek seçim) + `SortMenu`; çip satırları kullanılmaz. Katalog `AdminTable` (sabit başlık, sütundan sıralama, dar pencerede dönem/görsel gizlenir). Pano: tek kartta 4 gösterge şeridi + bölüm başına döküm panelleri (durum / aciliyet / konu / tür, oranlı çubuk + sayı, kritik değer kırmızı; satırlar süzgeçli kuyruğa gider). Kenar çubuğunda tek renk ikon (daraltılmış mod için) kalır. | Kurumsal yönetim yazılımı; bilginin hızlı taranması ve tutarlılık. |
| A13 | **YZ moderasyonu görünümü (kök ADR 58):** kuyrukta ikonsuz YZ çipi (`aiChip`: karar · skor · kategori; ton bandına göre), "YZ'nin kaldırdıkları" kuyruğu (`status=rejected&decidedBy=ai`), bekleyenlerde `SortMenu` (en eski / en yüksek YZ skoru). Ayrıntıda "Yapay zekâ değerlendirmesi" (`KeyValueList`: neden — `score`/`nsfw`/`spam`/`unrelated`/`context`/`language`/`photos`/`unscored` —, metnin eserle bağlamı, spam skoru + eşleşen kurallar, NSFW, esere benzerlik, model sürümleri; `ScoreBreakdown` 0–1 çubukları yalnızca metin kategorileri (`AiCategory.textValues`), ≥ 0,5 kırmızı; fotoğraf başına skorlar); YZ'nin kaldırdığı anının onay düğmesi "Geri yükle (YZ kararını geri al)". `/moderation/metrics`: gösterge şeridi + döküm panelleri (`shared/widgets/organisms/metric_widgets.dart`, pano ile ortak). Eşikler salt bilgidir (sunucu yapılandırması). Çubuk satırları `Semantics(container: true)` (yoksa bölüm başlığına birleşiyordu). | Moderatör YZ'nin neden öyle karar verdiğini görür, yanlış kaldırmayı hızla bulup geri alır; eşiklerin gözden geçirilmesi için veri. |
| A14 | **VGM verisi içe aktarımı (kök ADR 59):** Katalog → "İçe aktar" (`/catalog/import`, `CatalogImportCubit` uygulama ömrü boyunca yönlendiricide tutulur). `getDirectoryPath` ile **klasör** seçilir (macOS sandbox'ında yalnızca seçilen klasöre erişim var; `files.user-selected.read-only` yeterli), klasördeki tek `.json` (şema dosyası hariç) kendiliğinden okunur, birden çoksa seçilir. `SeedFolderReaderImpl` isolate'te her `src`'nin SHA-256'sını hesaplar (eksik/5 MB üstü dosya yerel hata, sunucuya gidilmez); doğrulamanın tek kaynağı sunucu planıdır (hatalar/uyarılar yol + kodla listelenir, `issueLabel`). Sunucu durumsuzdur: plan `POST imports/validate`, onay `POST imports/commit` (aynı gövde: dosya + özetler, `Idempotency-Key`; 409 → eksik görsellerle güncel plan). "N görseli yükle ve içe aktar": 4 eşzamanlı `PUT imports/images/{sha}` (429'da `retryAfter`, ağ/5xx'te 3 deneme), sonra onay; durdurulan/başarısız yükleme planı yeniler (yalnızca eksikler kalır). Çalışırken çıkış onay ister (`_confirmLeaveImport`). Bitince "Konumu eksik eserleri aç" → `/catalog?location=missing`. Liste "Konum" süzgeci + satırda "Konum yok"; düzenleyicide konum isteğe bağlı, "Bölümler" sekmesi (bölüm silinince bağlı görseller eser görseline döner), görselde bölüm çipi, halk arasındaki ad. | VGM verisi dosya + görsel klasörü olarak gelir; tek seçim, tekrar çalıştırılabilir ve kesintiden devam eder. |
| A15 | **Sivil Koruma YZ kanıt etiketi (kök ADR 35):** `DamageReport.evidence` (`ReportEvidence`: `EvidenceLevel` strong/unverified/suspicious, `null` → `pending`; gerekçeler `EvidenceReasonCode` + etki + değer/ayrıntı, bilinmeyen kod ham gösterilir). Kuyrukta ikonsuz `YZ: <etiket>` çipi (değerlendirildiyse), "YZ kanıtı" `FilterMenu` (`evidence=`, `pending` dahil), "Aciliyet, sonra YZ kanıtı" sırası (`sort=evidence`). Ayrıntıda "Yapay zekâ kanıt değerlendirmesi": etiket + anlamı, Destekleyen / Zayıflatan / Bilgi gerekçe listeleri (değerler yerel biçimde; zayıflatan kırmızı metin), sürüm, zaman ve "etiket durumu değiştirmez, vatandaş görmez" notu. Pano: "Açık bildirimler, YZ kanıtına göre" dökümü (`summary.openByEvidence`; satır → `?status=open&evidence=<etiket>&sort=evidence`). Skor biçimi ve spam kural adları ortak `core/l10n/ai_formatters.dart`. | Moderatör güçlü kanıtlı bildirime önce bakar, şüpheliyi gerekçesiyle görür; etiket karar değil yardımcıdır. |

## Rotalar

| Route | İzin |
|:---|:---|
| `/splash`, `/sign-in`, `/password-reset` | — (misafir) |
| `/` (Pano), `/profile`, `/settings` | tüm personel |
| `/catalog` (`?location=missing`), `/catalog/new`, `/catalog/import` (`:id`'den önce eşlenir), `/catalog/:id` | `editor` |
| `/civil-protection[/:id]` | `moderator` |
| `/moderation[/:id]`, `/moderation/metrics` (YZ metrikleri; `:id`'den önce eşlenir) | `moderator` |
| `/feedback[/:id]` | `moderator` |
| `/staff[/:id]`, `/audit` | `vgm_admin` (her izni kapsar) |

## Komutlar

```bash
make setup                 # pub get + build_runner + gen-l10n
make ci                    # format-check + analyze + test
make run-dev               # DEVICE=macos|windows|linux; yerel compose backend'i (http://localhost:8080/v1/)
make build-macos ENV=prod CONFIG=<prod.json>   # build-windows / build-linux
flutter test tool/backend_app_e2e_test.dart -d macos --dart-define-from-file=config/dev.json   # canlı e2e
python3 ../backend/tools/staff_totp.py         # dev TOTP kodu
```

Dev hesapları: `vgm@vakifatlas.dev` (Yönetici), `katalog@` (Editör), `moderator@vakifatlas.dev`
(Moderatör) — şifre `VgmPersonel2026!`, TOTP sırrı `JBSWY3DPEHPK3PXPJBSWY3DPEHPK3PXP`.
CI: `.github/workflows/admin.yml` (denetim + macOS/Windows/Linux derlemesi).

## Bilinen tuzaklar

- `DetailSection` `Material` yüzeyidir: `DecoratedBox` içindeki `ListTile` mürekkebi testte hata veriyordu.
- Canlı e2e iki kez arka arkaya çalışırsa ikincisi aynı TOTP adımına düşüp reddedilir (tekrar koruması) — 30 sn bekle.
- Linux'ta `flutter_secure_storage` için `libsecret-1-dev` gerekir.
- ARB'ler TR şablonludur; yeni anahtar iki dosyaya birlikte eklenir, ardından `flutter gen-l10n`.
