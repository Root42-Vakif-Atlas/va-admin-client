/// İmleçli liste sayfası: `{items, total, nextCursor}` (`nextCursor` `null`
/// → son sayfa). Sunucu keyset sayfalaması yapar; imleç istemci için opaktır.
final class Paged<T> {
  const Paged({required this.items, required this.total, this.nextCursor});

  const Paged.empty() : items = const [], total = 0, nextCursor = null;

  final List<T> items;
  final int total;
  final String? nextCursor;

  bool get hasMore => nextCursor != null;

  Paged<R> map<R>(R Function(T item) convert) => Paged(
    items: items.map(convert).toList(growable: false),
    total: total,
    nextCursor: nextCursor,
  );
}
