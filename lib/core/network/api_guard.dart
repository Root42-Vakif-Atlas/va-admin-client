import 'package:vakif_atlas_admin/core/error/error_mapper.dart';
import 'package:vakif_atlas_admin/core/error/failures.dart';
import 'package:vakif_atlas_admin/core/utils/either.dart';

/// Data katmanı çağrılarının ortak hata dönüşümü: ağ/sunucu istisnaları
/// tabloya göre [Failure]'a, bozuk yanıt gövdesi (`TypeError`, sözleşme dışı
/// alan) [UnexpectedFailure]'a çevrilir. Presentation'a istisna sızmaz.
Future<Either<Failure, T>> guardApi<T>(Future<T> Function() call) async {
  try {
    return Right(await call());
  } on Exception catch (error) {
    return Left(ErrorMapper.toFailure(error));
  } on TypeError {
    return const Left(UnexpectedFailure());
  }
}
