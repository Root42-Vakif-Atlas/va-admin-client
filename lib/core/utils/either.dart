/// İki olası sonuçtan birini taşıyan değişmez tip.
///
/// Geleneksel olarak [Left] başarısızlığı (`Failure`), [Right] başarıyı temsil
/// eder. Projeye ait saf Dart implementasyonudur; Domain katmanının dış
/// paketlere bağımlı olmaması için harici bir FP kütüphanesi kullanılmaz.
sealed class Either<L, R> {
  const Either();

  bool get isLeft => this is Left<L, R>;

  bool get isRight => this is Right<L, R>;

  /// Her iki durumu da ele alarak tek bir değere indirger.
  T fold<T>(T Function(L left) onLeft, T Function(R right) onRight) {
    return switch (this) {
      Left<L, R>(:final value) => onLeft(value),
      Right<L, R>(:final value) => onRight(value),
    };
  }

  /// Başarı değerini dönüştürür; başarısızlık olduğu gibi aktarılır.
  Either<L, T> map<T>(T Function(R right) transform) {
    return switch (this) {
      Left<L, R>(:final value) => Left<L, T>(value),
      Right<L, R>(:final value) => Right<L, T>(transform(value)),
    };
  }

  /// Başarı değerini yeni bir [Either] üreten işleme zincirler.
  Either<L, T> flatMap<T>(Either<L, T> Function(R right) transform) {
    return switch (this) {
      Left<L, R>(:final value) => Left<L, T>(value),
      Right<L, R>(:final value) => transform(value),
    };
  }

  /// Başarı değerini, başarısızlıkta `null` döndürür.
  R? getOrNull() {
    return switch (this) {
      Left<L, R>() => null,
      Right<L, R>(:final value) => value,
    };
  }
}

/// Başarısız sonuç.
final class Left<L, R> extends Either<L, R> {
  const Left(this.value);

  final L value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Left<L, R> && other.value == value;

  @override
  int get hashCode => Object.hash(Left, value);

  @override
  String toString() => 'Left($value)';
}

/// Başarılı sonuç.
final class Right<L, R> extends Either<L, R> {
  const Right(this.value);

  final R value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Right<L, R> && other.value == value;

  @override
  int get hashCode => Object.hash(Right, value);

  @override
  String toString() => 'Right($value)';
}

/// Değer taşımayan başarılı işlemlerin dönüş tipi (`void` karşılığı).
final class Unit {
  const Unit._();

  @override
  String toString() => '()';
}

/// [Unit] tipinin tek örneği.
const Unit unit = Unit._();
