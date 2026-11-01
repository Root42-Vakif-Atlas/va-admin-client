import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakif_atlas_admin/core/error/failures.dart';
import 'package:vakif_atlas_admin/core/utils/typedefs.dart';
import 'package:vakif_atlas_admin/core/utils/versioned.dart';

/// Ayrıntı panelinin durumu: sürümüyle okunan kayıt ve son işlemin sonucu.
@immutable
class RecordState<T> {
  const RecordState({
    this.loading = true,
    this.record,
    this.loadFailure,
    this.saving = false,
    this.actionFailure,
    this.savedCount = 0,
  });

  final bool loading;
  final Versioned<T>? record;
  final Failure? loadFailure;
  final bool saving;

  /// Son değişikliğin hatası (412 → `StaleDataFailure`).
  final Failure? actionFailure;

  /// Başarılı değişiklik sayısı (dinleyiciler "kaydedildi"yi bundan anlar).
  final int savedCount;

  T? get value => record?.value;

  RecordState<T> copyWith({
    bool? loading,
    Versioned<T>? record,
    Failure? Function()? loadFailure,
    bool? saving,
    Failure? Function()? actionFailure,
    int? savedCount,
  }) => RecordState(
    loading: loading ?? this.loading,
    record: record ?? this.record,
    loadFailure: loadFailure == null ? this.loadFailure : loadFailure(),
    saving: saving ?? this.saving,
    actionFailure: actionFailure == null ? this.actionFailure : actionFailure(),
    savedCount: savedCount ?? this.savedCount,
  );
}

/// Kaydı yükler ve değişiklikleri okunan sürümle (`If-Match`) gönderir.
abstract class RecordCubit<T> extends Cubit<RecordState<T>> {
  RecordCubit() : super(RecordState<T>());

  @protected
  ResultFuture<Versioned<T>> fetch();

  Future<void> load() async {
    emit(state.copyWith(loading: true, loadFailure: () => null));
    final result = await fetch();
    if (isClosed) {
      return;
    }
    emit(
      result.fold(
        (failure) => state.copyWith(loading: false, loadFailure: () => failure),
        (record) => RecordState(
          loading: false,
          record: record,
          savedCount: state.savedCount,
        ),
      ),
    );
  }

  /// [action] güncel sürümle çağrılır; başarıda kayıt değişir. `true` →
  /// kaydedildi.
  @protected
  Future<bool> mutate(
    ResultFuture<Versioned<T>> Function(String etag) action,
  ) async {
    final current = state.record;
    if (current == null || state.saving) {
      return false;
    }
    emit(state.copyWith(saving: true, actionFailure: () => null));
    final result = await action(current.etag);
    if (isClosed) {
      return false;
    }
    return result.fold(
      (failure) {
        emit(state.copyWith(saving: false, actionFailure: () => failure));
        return false;
      },
      (record) {
        emit(
          state.copyWith(
            saving: false,
            record: record,
            savedCount: state.savedCount + 1,
          ),
        );
        return true;
      },
    );
  }

  void clearActionFailure() => emit(state.copyWith(actionFailure: () => null));
}
