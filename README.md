# Vakıf Atlas Yönetim

VGM personeli için masaüstü yönetim istemcisi (Flutter; macOS, Windows, Linux): katalog,
Sivil Koruma incelemesi, Anı Köşesi moderasyonu, geri bildirim, personel ve denetim kaydı.
Proje kuralları: [`CLAUDE.md`](CLAUDE.md). API: [`../docs/api-contracts.md`](../docs/api-contracts.md)
→ "Personel (Yönetim Paneli) API".

## Çalıştırma

| Config | Backend | Komut |
|:---|:---|:---|
| `config/dev.json` | Yerel compose, `http://localhost:8080/v1/` | `make run-dev` |
| `config/remote.json` | Yayındaki, `https://vakif-atlas.odx.studio/v1/` | `make run-remote` |
| `config/staging.json`, `config/prod.json` | Gerçek ortamlar (`API_BASE_URL`, `SSL_PINS` doldurulmalı) | `make run-staging` / `make run-prod` |

Platform `DEVICE` ile seçilir (varsayılan `macos`): `make run-remote DEVICE=windows`.

### Yerel backend ile

```bash
# 1. Yerel backend
cd ../vakif-atlas-microservices && docker compose -f deploy/compose/compose.yaml up -d --build --wait

# 2. İstemci
cd ../vakif_atlas_admin
make setup
make run-dev              # DEVICE=windows | linux
```

### Yayındaki backend ile

```bash
cd vakif_atlas_admin
make setup                # ilk seferde
make run-remote           # DEVICE=windows | linux
# eşdeğeri:
flutter run -d macos -t lib/main_dev.dart --dart-define-from-file=config/remote.json
```

Dev girişi kullanılır (SSL pinning kapalı, ayrıntılı log). Personel hesapları yayındaki sunucunun
verisidir; aşağıdaki demo hesapları yalnızca sunucu demo verisiyle açıldıysa vardır. Sunucu ayakta mı:
`https://vakif-atlas.odx.studio/v1/health` → `{"status":"ok"}`.

Nesne deposu (`https://vakif-atlas-s3.odx.studio`) uygulamada yapılandırılmaz: yükleme ve görsel
adresleri sunucudan gelir (sunucuda `PUBLIC_S3_URL`); uygulamadaki tek ayar o alan adının pin'leri,
`STORAGE_SSL_PINS` (staging/prod).

### Giriş

Demo hesabı: `vgm@vakifatlas.dev` / `VgmPersonel2026!`, ardından doğrulama kodu. Kodu
`JBSWY3DPEHPK3PXPJBSWY3DPEHPK3PXP` sırrını bir Authenticator uygulamasına ekleyerek veya şu komutla
alın:

```bash
python3 -I -c 'import base64,hmac,struct,time;k=base64.b32decode("JBSWY3DPEHPK3PXPJBSWY3DPEHPK3PXP");h=hmac.digest(k,struct.pack(">Q",int(time.time())//30),"sha1");o=h[-1]&15;print("%06d"%((struct.unpack(">I",h[o:o+4])[0]&0x7fffffff)%10**6))'
```

Rol başına hesaplar: `katalog@` (Editör), `moderator@vakifatlas.dev` (Moderatör) — aynı şifre/sır.
Davet edilen personel şifresini e-postadaki kodla belirler (yerelde Mailpit: http://localhost:8025).

## Test

```bash
make ci                                                   # format + analiz + test
flutter test tool/backend_app_e2e_test.dart -d macos     # yerel backend'e karşı uçtan uca
flutter test tool/backend_app_e2e_test.dart -d macos \
  --dart-define=API=https://vakif-atlas.odx.studio/v1/    # yayındaki backend'e karşı (demo verisi gerekir)
# Araç config dosyasını değil `API` tanımını okur (varsayılan http://localhost:8080/v1/).
```

## Derleme

```bash
make build-macos ENV=prod CONFIG=<prod.json>      # build-windows / build-linux
```

Linux için önce: `sudo apt install libgtk-3-dev libsecret-1-dev`.
