import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas_admin/core/error/failures.dart';
import 'package:vakif_atlas_admin/core/utils/idempotency.dart';
import 'package:vakif_atlas_admin/features/catalog/domain/catalog_import.dart';

/// İçe aktarım aşamaları: klasör → okuma (özetler) → sunucu planı → görsel
/// yükleme → onay → sonuç.
enum ImportStage {
  idle,
  reading,
  planning,
  planned,
  uploading,
  committing,
  done,
}

@immutable
class CatalogImportState {
  const CatalogImportState({
    this.stage = ImportStage.idle,
    this.folder,
    this.jsonFiles = const [],
    this.jsonPath,
    this.seed,
    this.plan,
    this.uploaded = 0,
    this.uploadFailed = 0,
    this.failure,
    this.cancelling = false,
  });

  final ImportStage stage;
  final String? folder;

  /// Klasördeki aday veri dosyaları (birden çoksa kullanıcı seçer).
  final List<String> jsonFiles;
  final String? jsonPath;
  final SeedFolder? seed;
  final ImportPlan? plan;
  final int uploaded;
  final int uploadFailed;
  final Failure? failure;
  final bool cancelling;

  int get toUpload => plan?.missingImages.length ?? 0;

  /// Görsel yükleme veya onay sürüyor: sayfadan çıkış onay ister.
  bool get running =>
      stage == ImportStage.uploading || stage == ImportStage.committing;

  bool get busy =>
      running || stage == ImportStage.reading || stage == ImportStage.planning;

  bool get canStart =>
      stage == ImportStage.planned && (plan?.valid ?? false) && !busy;

  CatalogImportState copyWith({
    ImportStage? stage,
    String? Function()? folder,
    List<String>? jsonFiles,
    String? Function()? jsonPath,
    SeedFolder? Function()? seed,
    ImportPlan? Function()? plan,
    int? uploaded,
    int? uploadFailed,
    Failure? Function()? failure,
    bool? cancelling,
  }) => CatalogImportState(
    stage: stage ?? this.stage,
    folder: folder == null ? this.folder : folder(),
    jsonFiles: jsonFiles ?? this.jsonFiles,
    jsonPath: jsonPath == null ? this.jsonPath : jsonPath(),
    seed: seed == null ? this.seed : seed(),
    plan: plan == null ? this.plan : plan(),
    uploaded: uploaded ?? this.uploaded,
    uploadFailed: uploadFailed ?? this.uploadFailed,
    failure: failure == null ? this.failure : failure(),
    cancelling: cancelling ?? this.cancelling,
  );
}

/// VGM verisinin içe aktarımı (ADR 59). Doğrulamanın tek kaynağı sunucudur:
/// istemci dosyayı okur, görsel özetlerini hesaplar ve planı ister; plan
/// geçerliyse eksik görselleri yükleyip onaylar. Tekrar çalıştırmak güvenlidir
/// (görseller içerik adresli, kayıtlar upsert).
@injectable
class CatalogImportCubit extends Cubit<CatalogImportState> {
  CatalogImportCubit(this._repository, this._reader)
    : super(const CatalogImportState());

  final CatalogImportRepository _repository;
  final SeedFolderReader _reader;

  /// Eşzamanlı görsel yüklemesi (sunucu her görseli yeniden kodlar).
  static const int concurrency = 4;

  /// Görsel başına deneme (429'da sunucunun bekleme süresi uygulanır).
  static const int maxAttempts = 4;

  bool _cancelled = false;

  /// Onay isteğinin anahtarı; klasör değişince yenilenir.
  String? _commitKey;

  Future<void> selectFolder(String folder) async {
    _commitKey = null;
    final files = await _reader.jsonFiles(folder);
    emit(
      CatalogImportState(
        folder: folder,
        jsonFiles: files,
        jsonPath: files.length == 1 ? files.single : null,
      ),
    );
    if (files.length == 1) {
      await analyze();
    }
  }

  Future<void> selectJson(String path) async {
    emit(
      state.copyWith(
        jsonPath: () => path,
        seed: () => null,
        plan: () => null,
        failure: () => null,
        stage: ImportStage.idle,
      ),
    );
    await analyze();
  }

  /// Dosyayı okur, özetleri hesaplar ve sunucudan planı (ön denetim) alır.
  Future<void> analyze() async {
    final path = state.jsonPath;
    if (path == null || state.busy) {
      return;
    }
    emit(
      state.copyWith(
        stage: ImportStage.reading,
        failure: () => null,
        plan: () => null,
        uploaded: 0,
        uploadFailed: 0,
      ),
    );
    final read = await _reader.read(path);
    final seed = read.fold((_) => null, (s) => s);
    if (seed == null) {
      emit(
        state.copyWith(
          stage: ImportStage.idle,
          failure: () => read.fold((f) => f, (_) => null),
        ),
      );
      return;
    }
    if (seed.issues.isNotEmpty) {
      // Eksik/okunamayan dosya: sunucuya gidilmez, sorunlar plan gibi gösterilir.
      emit(
        state.copyWith(
          stage: ImportStage.planned,
          seed: () => seed,
          plan: () => ImportPlan(
            valid: false,
            missingImages: const [],
            errors: seed.issues,
            warnings: const [],
            warningCount: 0,
          ),
        ),
      );
      return;
    }
    emit(state.copyWith(stage: ImportStage.planning, seed: () => seed));
    final plan = await _repository.plan(seed);
    plan.fold(
      (failure) =>
          emit(state.copyWith(stage: ImportStage.idle, failure: () => failure)),
      (plan) =>
          emit(state.copyWith(stage: ImportStage.planned, plan: () => plan)),
    );
  }

  /// Eksik görselleri yükler ve içe aktarımı onaylar.
  Future<void> start() async {
    final plan = state.plan;
    final seed = state.seed;
    if (!state.canStart || plan == null || seed == null) {
      return;
    }
    _cancelled = false;
    emit(
      state.copyWith(
        stage: ImportStage.uploading,
        uploaded: 0,
        uploadFailed: 0,
        failure: () => null,
        cancelling: false,
      ),
    );

    final queue = [...plan.missingImages];
    Failure? lastFailure;
    Future<void> worker() async {
      while (queue.isNotEmpty && !_cancelled) {
        final sha = queue.removeLast();
        final file = seed.files[sha];
        final failure = file == null
            ? const UnexpectedFailure()
            : await _upload(sha, file);
        if (isClosed) {
          return;
        }
        if (failure == null) {
          emit(state.copyWith(uploaded: state.uploaded + 1));
        } else {
          lastFailure = failure;
          emit(state.copyWith(uploadFailed: state.uploadFailed + 1));
        }
      }
    }

    await Future.wait([for (var i = 0; i < concurrency; i++) worker()]);
    if (isClosed) {
      return;
    }
    if (_cancelled || state.uploadFailed > 0) {
      // Yüklenenler depoda kalır: yeniden "Başlat" yalnızca eksikleri gönderir.
      await _refreshPlan();
      emit(
        state.copyWith(
          stage: ImportStage.planned,
          cancelling: false,
          failure: () => _cancelled ? null : lastFailure,
        ),
      );
      return;
    }

    emit(state.copyWith(stage: ImportStage.committing));
    // Aynı onay tekrarında (ağ hatası) aynı anahtar: çift içe aktarım yok.
    _commitKey ??= newIdempotencyKey();
    final committed = await _repository.commit(
      seed,
      idempotencyKey: _commitKey!,
    );
    if (isClosed) {
      return;
    }
    committed.fold(
      (failure) => emit(
        state.copyWith(stage: ImportStage.planned, failure: () => failure),
      ),
      (result) {
        // Görsel eksik (409): güncel plan gösterilir, yeniden başlatılabilir.
        if (result.committed) {
          _commitKey = null;
        }
        emit(
          state.copyWith(
            stage: result.committed ? ImportStage.done : ImportStage.planned,
            plan: () => result,
          ),
        );
      },
    );
  }

  /// Sürmekte olan yüklemeler bitince durur; onaya geçilmez.
  void cancel() {
    if (state.stage == ImportStage.uploading) {
      _cancelled = true;
      emit(state.copyWith(cancelling: true));
    }
  }

  void reset() {
    _cancelled = true;
    _commitKey = null;
    emit(const CatalogImportState());
  }

  Future<Failure?> _upload(String sha, SeedImageFile file) async {
    Failure? failure;
    for (var attempt = 1; attempt <= maxAttempts && !_cancelled; attempt++) {
      final result = await _repository.uploadImage(sha, file);
      failure = result.fold((f) => f, (_) => null);
      if (failure == null) {
        return null;
      }
      final wait = switch (failure) {
        TooManyRequestsFailure(:final retryAfter) =>
          retryAfter ?? const Duration(seconds: 5),
        NetworkFailure() ||
        ServerFailure(
          kind: ServerFailureKind.unavailable,
        ) => Duration(seconds: attempt * 2),
        _ => null,
      };
      if (wait == null) {
        return failure;
      }
      await Future<void>.delayed(wait);
    }
    return failure;
  }

  /// Aynı planı yeniden ister: eksik görsel listesi güncellenir.
  Future<void> _refreshPlan() async {
    final seed = state.seed;
    if (seed == null) {
      return;
    }
    final plan = await _repository.plan(seed);
    if (!isClosed) {
      plan.fold((_) {}, (plan) => emit(state.copyWith(plan: () => plan)));
    }
  }
}
