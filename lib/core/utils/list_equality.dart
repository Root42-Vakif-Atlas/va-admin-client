/// İki listenin aynı sırada eşit öğeler içerip içermediği.
///
/// Domain varlıklarının değer eşitliği için saf Dart yardımcısıdır.
bool elementsEqual<T>(List<T> a, List<T> b) {
  if (identical(a, b)) {
    return true;
  }
  if (a.length != b.length) {
    return false;
  }
  for (var index = 0; index < a.length; index++) {
    if (a[index] != b[index]) {
      return false;
    }
  }
  return true;
}

/// İki kümenin aynı öğeleri içerip içermediği (sıradan bağımsız).
bool setEquals<T>(Set<T> a, Set<T> b) =>
    identical(a, b) || (a.length == b.length && a.containsAll(b));

/// İki eşlemin aynı anahtar/değer çiftlerini içerip içermediği.
bool mapEquals<K, V>(Map<K, V> a, Map<K, V> b) {
  if (identical(a, b)) {
    return true;
  }
  if (a.length != b.length) {
    return false;
  }
  for (final MapEntry(:key, :value) in a.entries) {
    if (!b.containsKey(key) || b[key] != value) {
      return false;
    }
  }
  return true;
}
