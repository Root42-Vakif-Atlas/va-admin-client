import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas_admin/core/error/failures.dart';
import 'package:vakif_atlas_admin/core/utils/either.dart';
import 'package:vakif_atlas_admin/core/utils/paged.dart';
import 'package:vakif_atlas_admin/core/utils/typedefs.dart';
import 'package:vakif_atlas_admin/shared/paging/paged_list_cubit.dart';

class _Cubit extends PagedListCubit<String, String> {
  _Cubit() : super('');

  final Map<(String, String?), Completer<Either<Failure, Paged<String>>>>
  pending = {};

  @override
  ResultFuture<Paged<String>> fetch(String filter, String? cursor) =>
      (pending[(filter, cursor)] = Completer()).future;

  @override
  String idOf(String item) => item;
}

void main() {
  test('süzgeç değişince eski isteğin yanıtı yok sayılır', () async {
    final cubit = _Cubit();
    final first = cubit.load('a');
    final second = cubit.load('b');
    cubit.pending[('b', null)]!.complete(
      const Right(Paged(items: ['b1'], total: 1)),
    );
    cubit.pending[('a', null)]!.complete(
      const Right(Paged(items: ['a1'], total: 1)),
    );
    await Future.wait([first, second]);
    expect(cubit.state.filter, 'b');
    expect(cubit.state.items, ['b1']);
    await cubit.close();
  });

  test(
    'sonraki sayfa eklenir, yinelenen kayıt atlanır, yerinde güncelleme',
    () async {
      final cubit = _Cubit();
      final load = cubit.load('x');
      cubit.pending[('x', null)]!.complete(
        const Right(Paged(items: ['1', '2'], total: 3, nextCursor: 'c')),
      );
      await load;
      final more = cubit.loadMore();
      unawaited(cubit.loadMore()); // tekil: ikinci çağrı yok sayılır
      cubit.pending[('x', 'c')]!.complete(
        const Right(Paged(items: ['2', '3'], total: 3)),
      );
      await more;
      expect(cubit.state.items, ['1', '2', '3']);
      expect(cubit.state.hasMore, isFalse);

      cubit.remove('2');
      expect(cubit.state.items, ['1', '3']);
      expect(cubit.state.total, 2);
      await cubit.close();
    },
  );
}
