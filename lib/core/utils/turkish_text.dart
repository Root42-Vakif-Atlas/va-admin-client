/// Türkçe metin karşılaştırma ve arama yardımcıları (saf Dart).
abstract final class TurkishText {
  static const String _alphabet = 'abcçdefgğhıijklmnoöprsştuüvwxyz';

  /// Arama için katlanmış küçük harfli biçim.
  ///
  /// Türkçe büyük/küçük harf kuralları uygulanır (`I` → `ı`, `İ` → `i`),
  /// ardından aksanlar atılır: "SÜLEYMANİYE", "Süleymaniye" ve
  /// "suleymaniye" aynı sonucu verir. Türkçe klavyesi olmayan kullanıcılar
  /// da eser bulabilir.
  static String fold(String value) {
    final buffer = StringBuffer();
    for (final rune in toLowerCase(value).runes) {
      final char = String.fromCharCode(rune);
      buffer.write(_folded[char] ?? char);
    }
    return buffer.toString();
  }

  /// Türkçe kurallarıyla küçük harfe çevirir.
  static String toLowerCase(String value) =>
      value.replaceAll('I', 'ı').replaceAll('İ', 'i').toLowerCase();

  /// Türkçe kurallarıyla büyük harfe çevirir.
  static String toUpperCase(String value) =>
      value.replaceAll('i', 'İ').replaceAll('ı', 'I').toUpperCase();

  /// Türk alfabesi sırasına göre karşılaştırma (Ç, Ğ, I/İ, Ö, Ş, Ü).
  ///
  /// Dart'ın `String.compareTo` işlemi kod birimine göre sıraladığı için
  /// "Çifte Minareli" gibi adları listenin sonuna atar.
  static int compare(String a, String b) {
    final left = _collationKeys(a);
    final right = _collationKeys(b);
    final length = left.length < right.length ? left.length : right.length;
    for (var index = 0; index < length; index++) {
      final difference = left[index] - right[index];
      if (difference != 0) {
        return difference;
      }
    }
    return left.length - right.length;
  }

  static List<int> _collationKeys(String value) => [
    for (final rune in toLowerCase(value).runes)
      switch (_alphabet.indexOf(String.fromCharCode(rune))) {
        -1 => _alphabet.length + rune,
        final position => position,
      },
  ];

  static const Map<String, String> _folded = {
    'ç': 'c',
    'ğ': 'g',
    'ı': 'i',
    'ö': 'o',
    'ş': 's',
    'ü': 'u',
    'â': 'a',
    'î': 'i',
    'û': 'u',
    'é': 'e',
    'è': 'e',
    'ä': 'a',
  };
}
