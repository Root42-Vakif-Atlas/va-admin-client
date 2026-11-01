/// Sunucudaki sürümüyle birlikte okunan kayıt.
///
/// [etag] değiştiren isteğe `If-Match` olarak geri gönderilir; kayıt bu
/// arada başkası tarafından değiştirildiyse sunucu 412 döner ve personelin
/// kararı sessizce eskimiş veriye uygulanmaz.
final class Versioned<T> {
  const Versioned(this.value, this.etag);

  final T value;
  final String etag;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Versioned<T> && other.value == value && other.etag == etag;

  @override
  int get hashCode => Object.hash(value, etag);

  @override
  String toString() => 'Versioned($value)';
}
