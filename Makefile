# Vakıf Atlas Yönetim — masaüstü yönetim istemcisi

.PHONY: help setup codegen l10n analyze format format-check test ci run-dev run-remote run-staging run-prod backend-e2e build-macos build-windows build-linux clean

help: ## Mevcut komutları listele
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-16s\033[0m %s\n", $$1, $$2}'

setup: ## Bağımlılıklar + kod üretimi + yerelleştirme
	flutter pub get
	dart run build_runner build --delete-conflicting-outputs
	flutter gen-l10n

codegen: ## freezed, injectable, json_serializable
	dart run build_runner build --delete-conflicting-outputs

l10n: ## ARB -> Dart
	flutter gen-l10n

analyze: ## Statik analiz
	flutter analyze lib/ test/ tool/

format: ## Biçimlendir
	dart format lib/ test/ tool/

format-check: ## Biçim denetimi
	dart format --output=none --set-exit-if-changed lib/ test/ tool/

test: ## Birim, widget, mimari ve kontrast testleri
	flutter test test/

ci: format-check analyze test ## CI denetimi

DEVICE ?= macos
run-dev: ## Yerel backend'e (backend/deploy/compose) karşı çalıştır; DEVICE=macos|windows|linux
	flutter run -d $(DEVICE) -t lib/main_dev.dart --dart-define-from-file=config/dev.json

run-remote: ## Yayındaki backend'e (https://vakif-atlas.odx.studio/v1/; depo adresleri sunucudan: https://vakif-atlas-s3.odx.studio) karşı çalıştır (SSL pinning kapalı)
	flutter run -d $(DEVICE) -t lib/main_dev.dart --dart-define-from-file=config/remote.json

run-staging: ## Staging
	flutter run -d $(DEVICE) -t lib/main_staging.dart --dart-define-from-file=config/staging.json

run-prod: ## Production
	flutter run -d $(DEVICE) -t lib/main_prod.dart --dart-define-from-file=config/prod.json

backend-e2e: ## Uygulamanın kendisini çalışan backend'e karşı uçtan uca dene (ekran görüntüleri build/e2e_shots)
	flutter test tool/backend_app_e2e_test.dart

macos-release:
	flutter build macos --release -t lib/main_dev.dart --dart-define-from-file=config/remote.json
	cp -R build/macos/Build/Products/Release/*.app /Applications/

# Release derlemeleri: ENV=dev|staging|prod; CONFIG CI'da secret'lardan üretilir.
ENV ?= staging
CONFIG ?= config/$(ENV).json
RELEASE_FLAGS = --release -t lib/main_$(ENV).dart --dart-define-from-file=$(CONFIG) --obfuscate --split-debug-info=build/symbols/$(ENV)

build-macos: ## macOS .app
	flutter build macos $(RELEASE_FLAGS)

build-windows: ## Windows (x64)
	flutter build windows $(RELEASE_FLAGS)

build-linux: ## Linux (GTK; libsecret gerekir)
	flutter build linux $(RELEASE_FLAGS)

clean:
	flutter clean
