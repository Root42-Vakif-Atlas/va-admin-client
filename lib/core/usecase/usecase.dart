import 'package:vakif_atlas_admin/core/utils/typedefs.dart';

/// Tek bir iş kuralını temsil eden asenkron kullanım senaryosu.
abstract interface class UseCase<T, Params> {
  ResultFuture<T> call(Params params);
}

/// Akış (stream) döndüren kullanım senaryosu.
abstract interface class StreamUseCase<T, Params> {
  Stream<T> call(Params params);
}

/// Parametre almayan kullanım senaryoları için boş parametre tipi.
final class NoParams {
  const NoParams();

  @override
  bool operator ==(Object other) => other is NoParams;

  @override
  int get hashCode => (NoParams).hashCode;
}
