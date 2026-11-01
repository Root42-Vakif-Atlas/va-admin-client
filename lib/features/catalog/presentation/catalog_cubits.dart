import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas_admin/core/error/failures.dart';
import 'package:vakif_atlas_admin/core/utils/idempotency.dart';
import 'package:vakif_atlas_admin/core/utils/paged.dart';
import 'package:vakif_atlas_admin/core/utils/typedefs.dart';
import 'package:vakif_atlas_admin/core/utils/versioned.dart';
import 'package:vakif_atlas_admin/features/catalog/domain/catalog_entities.dart';
import 'package:vakif_atlas_admin/features/catalog/domain/catalog_repository.dart';
import 'package:vakif_atlas_admin/features/catalog/domain/monument_validation.dart';
import 'package:vakif_atlas_admin/shared/paging/paged_list_cubit.dart';

@injectable
class CatalogListCubit
    extends PagedListCubit<CatalogMonumentSummary, CatalogFilter> {
  CatalogListCubit(this._repository) : super(const CatalogFilter());

  final CatalogRepository _repository;

  @override
  ResultFuture<Paged<CatalogMonumentSummary>> fetch(
    CatalogFilter filter,
    String? cursor,
  ) => _repository.list(filter, cursor: cursor);

  @override
  String idOf(CatalogMonumentSummary item) => item.id;
}

@immutable
class CatalogEditorState {
  const CatalogEditorState({
    required this.creating,
    this.loading = false,
    this.loadFailure,
    this.saved,
    this.draft = const MonumentDraft(),
    this.showErrors = false,
    this.saving = false,
    this.actionFailure,
    this.savedCount = 0,
    this.uploading = 0,
    this.uploadFailure,
  });

  /// Yeni eser (henüz kaydedilmedi).
  final bool creating;
  final bool loading;
  final Failure? loadFailure;

  /// Son kaydedilen hâli ve sürümü.
  final Versioned<CatalogMonument>? saved;
  final MonumentDraft draft;

  /// İlk kaydetme denemesinden sonra alan hataları gösterilir.
  final bool showErrors;
  final bool saving;
  final Failure? actionFailure;
  final int savedCount;

  /// Hazırlanıp yüklenen görsel sayısı.
  final int uploading;
  final Failure? uploadFailure;

  Set<MonumentField> get errors =>
      MonumentValidation.validate(draft, creating: creating);

  bool get dirty =>
      creating ? draft != const MonumentDraft() : draft != saved?.value.draft;

  bool get busy => saving || uploading > 0;

  CatalogEditorState copyWith({
    bool? creating,
    bool? loading,
    Failure? Function()? loadFailure,
    Versioned<CatalogMonument>? saved,
    MonumentDraft? draft,
    bool? showErrors,
    bool? saving,
    Failure? Function()? actionFailure,
    int? savedCount,
    int? uploading,
    Failure? Function()? uploadFailure,
  }) => CatalogEditorState(
    creating: creating ?? this.creating,
    loading: loading ?? this.loading,
    loadFailure: loadFailure == null ? this.loadFailure : loadFailure(),
    saved: saved ?? this.saved,
    draft: draft ?? this.draft,
    showErrors: showErrors ?? this.showErrors,
    saving: saving ?? this.saving,
    actionFailure: actionFailure == null ? this.actionFailure : actionFailure(),
    savedCount: savedCount ?? this.savedCount,
    uploading: uploading ?? this.uploading,
    uploadFailure: uploadFailure == null ? this.uploadFailure : uploadFailure(),
  );
}

/// Eser düzenleyicisi: taslak, doğrulama, görsel yükleme, kaydetme
/// (oluşturma: `Idempotency-Key`; güncelleme: `If-Match`), yayın durumu ve
/// külliye yapıları.
@injectable
class CatalogEditorCubit extends Cubit<CatalogEditorState> {
  CatalogEditorCubit(this._repository, this._preparer, @factoryParam this._id)
    : super(CatalogEditorState(creating: _id == null));

  final CatalogRepository _repository;
  final ImagePreparer _preparer;
  final String? _id;

  /// Oluşturma isteği başına tek anahtar (tekrar → aynı yanıt).
  final String _idempotencyKey = newIdempotencyKey();

  Future<void> load() async {
    final id = state.saved?.value.id ?? _id;
    if (id == null) {
      return;
    }
    emit(state.copyWith(loading: true, loadFailure: () => null));
    final result = await _repository.get(id);
    if (isClosed) {
      return;
    }
    emit(
      result.fold(
        (failure) => state.copyWith(loading: false, loadFailure: () => failure),
        (record) => CatalogEditorState(
          creating: false,
          saved: record,
          draft: record.value.draft,
          savedCount: state.savedCount,
        ),
      ),
    );
  }

  void edit(MonumentDraft Function(MonumentDraft draft) change) => emit(
    state.copyWith(draft: change(state.draft), actionFailure: () => null),
  );

  /// Taslağı kayıtlı hâline döndürür.
  void discard() {
    final saved = state.saved;
    emit(
      state.copyWith(
        draft: saved?.value.draft ?? const MonumentDraft(),
        showErrors: false,
      ),
    );
  }

  Future<void> addImages(List<List<int>> files) async {
    emit(
      state.copyWith(
        uploading: state.uploading + files.length,
        uploadFailure: () => null,
      ),
    );
    for (final bytes in files) {
      final prepared = await _preparer.prepare(bytes);
      if (isClosed) {
        return;
      }
      if (prepared == null) {
        emit(
          state.copyWith(
            uploading: state.uploading - 1,
            uploadFailure: () => const ServerFailure(
              kind: ServerFailureKind.invalidRequest,
              code: 'invalid_image',
            ),
          ),
        );
        continue;
      }
      final result = await _repository.uploadImage(prepared);
      if (isClosed) {
        return;
      }
      emit(
        result.fold(
          (failure) => state.copyWith(
            uploading: state.uploading - 1,
            uploadFailure: () => failure,
          ),
          (sha256) => state.copyWith(
            uploading: state.uploading - 1,
            draft: state.draft.copyWith(
              images: [
                ...state.draft.images,
                MonumentImage(sha256: sha256, previewBytes: prepared.bytes),
              ],
            ),
          ),
        ),
      );
    }
  }

  void updateImage(
    int index,
    MonumentImage Function(MonumentImage image) change,
  ) {
    final images = [...state.draft.images];
    images[index] = change(images[index]);
    edit((draft) => draft.copyWith(images: images));
  }

  void moveImage(int from, int to) {
    if (to < 0 || to >= state.draft.images.length) {
      return;
    }
    final images = [...state.draft.images];
    final image = images.removeAt(from);
    images.insert(to, image);
    edit((draft) => draft.copyWith(images: images));
  }

  /// Bölümü siler; ona bağlı görseller eser görseline döner, sonraki
  /// bölümlerin görsel indeksleri kayar.
  void removePart(int index) => edit(
    (d) => d.copyWith(
      parts: [...d.parts]..removeAt(index),
      images: [
        for (final image in d.images)
          switch (image.part) {
            final part? when part == index => image.copyWith(part: () => null),
            final part? when part > index => image.copyWith(
              part: () => part - 1,
            ),
            _ => image,
          },
      ],
    ),
  );

  void removeImage(int index) {
    final images = [...state.draft.images]..removeAt(index);
    edit((draft) => draft.copyWith(images: images));
  }

  /// `true` → kaydedildi. Alan hataları varsa gönderilmez.
  Future<bool> save() async {
    if (state.busy) {
      return false;
    }
    if (state.errors.isNotEmpty) {
      emit(state.copyWith(showErrors: true));
      return false;
    }
    emit(state.copyWith(saving: true, actionFailure: () => null));
    final saved = state.saved;
    final result = state.creating || saved == null
        ? await _repository.create(state.draft, idempotencyKey: _idempotencyKey)
        : await _repository.update(state.draft, etag: saved.etag);
    return _apply(result);
  }

  Future<bool> setPublication(Publication publication) async {
    final saved = state.saved;
    if (saved == null || state.busy) {
      return false;
    }
    emit(state.copyWith(saving: true, actionFailure: () => null));
    return _apply(
      await _repository.setPublication(
        saved.value.id,
        complex: saved.value.draft.isComplex,
        etag: saved.etag,
        publication: publication,
      ),
      keepDraft: true,
    );
  }

  Future<bool> setMembers(List<String> memberIds) async {
    final saved = state.saved;
    if (saved == null || state.busy) {
      return false;
    }
    emit(state.copyWith(saving: true, actionFailure: () => null));
    return _apply(
      await _repository.setComplexMembers(
        saved.value.id,
        etag: saved.etag,
        memberIds: memberIds,
      ),
      keepDraft: true,
    );
  }

  /// Külliyeye eklenecek yapı adayları (yayındaki, külliye olmayan eserler).
  /// Külliye seçici: tüm külliyeler (yayında + kaldırılmış), sunucuda arama.
  ResultFuture<Paged<CatalogMonumentSummary>> searchComplexes(
    String query,
    String? cursor,
  ) => _repository.list(
    CatalogFilter(query: query, categories: const {MonumentCategory.complex}),
    cursor: cursor,
  );

  /// Yapı seçici: külliye olmayan tüm eserler (külliye iç içe olamaz).
  ResultFuture<Paged<CatalogMonumentSummary>> searchMemberCandidates(
    String query,
    String? cursor,
  ) => _repository.list(
    CatalogFilter(
      query: query,
      categories: {
        for (final category in MonumentCategory.values)
          if (category != MonumentCategory.complex) category,
      },
    ),
    cursor: cursor,
  );

  void clearActionFailure() => emit(state.copyWith(actionFailure: () => null));

  /// [keepDraft]: yayın/yapı işlemi taslaktaki kaydedilmemiş metni ezmez.
  bool _apply(
    Result<Versioned<CatalogMonument>> result, {
    bool keepDraft = false,
  }) {
    if (isClosed) {
      return false;
    }
    return result.fold(
      (failure) {
        emit(state.copyWith(saving: false, actionFailure: () => failure));
        return false;
      },
      (record) {
        final wasDirty = state.dirty;
        emit(
          CatalogEditorState(
            creating: false,
            saved: record,
            draft: keepDraft && wasDirty ? state.draft : record.value.draft,
            savedCount: state.savedCount + 1,
          ),
        );
        return true;
      },
    );
  }
}
