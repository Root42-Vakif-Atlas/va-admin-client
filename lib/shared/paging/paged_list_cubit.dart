import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakif_atlas_admin/core/error/failures.dart';
import 'package:vakif_atlas_admin/core/utils/paged.dart';
import 'package:vakif_atlas_admin/core/utils/typedefs.dart';

/// İmleçli liste ekranlarının ortak durumu: süzgeç [F], öğeler [T].
@immutable
class PagedListState<T, F> {
  const PagedListState({
    required this.filter,
    this.items = const [],
    this.total = 0,
    this.nextCursor,
    this.loading = false,
    this.loadingMore = false,
    this.failure,
  });

  final F filter;
  final List<T> items;
  final int total;
  final String? nextCursor;

  /// İlk sayfa (süzgeç değişimi / yenileme) yükleniyor.
  final bool loading;
  final bool loadingMore;

  /// Son yüklemenin hatası (liste doluysa üstünde bildirim olarak gösterilir).
  final Failure? failure;

  bool get hasMore => nextCursor != null;

  PagedListState<T, F> copyWith({
    F? filter,
    List<T>? items,
    int? total,
    String? Function()? nextCursor,
    bool? loading,
    bool? loadingMore,
    Failure? Function()? failure,
  }) => PagedListState(
    filter: filter ?? this.filter,
    items: items ?? this.items,
    total: total ?? this.total,
    nextCursor: nextCursor == null ? this.nextCursor : nextCursor(),
    loading: loading ?? this.loading,
    loadingMore: loadingMore ?? this.loadingMore,
    failure: failure == null ? this.failure : failure(),
  );
}

/// Süzgeçli, imleçli liste. Süzgeç değişince eski isteğin yanıtı nesil
/// sayacıyla yok sayılır (yarış yok); sonraki sayfa tekil yüklenir.
/// Ayrıntı panelinde değişen kayıt [replace] ile listede güncellenir.
abstract class PagedListCubit<T, F> extends Cubit<PagedListState<T, F>> {
  PagedListCubit(F initialFilter)
    : super(PagedListState(filter: initialFilter));

  int _generation = 0;

  @protected
  ResultFuture<Paged<T>> fetch(F filter, String? cursor);

  /// Öğenin kimliği (yerinde güncelleme ve seçim için).
  @protected
  String idOf(T item);

  Future<void> load([F? filter]) async {
    final generation = ++_generation;
    final next = filter ?? state.filter;
    emit(
      PagedListState(
        filter: next,
        items: filter == null ? state.items : const [],
        total: filter == null ? state.total : 0,
        loading: true,
      ),
    );
    final result = await fetch(next, null);
    if (generation != _generation || isClosed) {
      return;
    }
    emit(
      result.fold(
        (failure) => state.copyWith(loading: false, failure: () => failure),
        (page) => PagedListState(
          filter: next,
          items: page.items,
          total: page.total,
          nextCursor: page.nextCursor,
        ),
      ),
    );
  }

  Future<void> refresh() => load();

  Future<void> loadMore() async {
    final cursor = state.nextCursor;
    if (cursor == null || state.loadingMore || state.loading) {
      return;
    }
    final generation = _generation;
    emit(state.copyWith(loadingMore: true, failure: () => null));
    final result = await fetch(state.filter, cursor);
    if (generation != _generation || isClosed) {
      return;
    }
    emit(
      result.fold(
        (failure) => state.copyWith(loadingMore: false, failure: () => failure),
        (page) => state.copyWith(
          loadingMore: false,
          items: [
            ...state.items,
            // Sayfalar arası yinelenen kayıt (araya eklenen) gösterilmez.
            ...page.items.where(
              (item) => !state.items.any((e) => idOf(e) == idOf(item)),
            ),
          ],
          total: page.total,
          nextCursor: () => page.nextCursor,
        ),
      ),
    );
  }

  /// Ayrıntıda güncellenen kaydı listede yerinde değiştirir.
  void replace(T item) {
    final id = idOf(item);
    if (!state.items.any((e) => idOf(e) == id)) {
      return;
    }
    emit(
      state.copyWith(
        items: [for (final e in state.items) idOf(e) == id ? item : e],
      ),
    );
  }

  void remove(String id) {
    final before = state.items.length;
    final items = state.items.where((e) => idOf(e) != id).toList();
    if (items.length != before) {
      emit(state.copyWith(items: items, total: state.total - 1));
    }
  }
}
