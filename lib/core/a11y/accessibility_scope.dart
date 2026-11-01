import 'package:flutter/widgets.dart';

/// Kökte kurulan, bileşenlerin okuduğu erişilebilirlik tercihleri
/// (tema veya `MediaQuery` ile ifade edilemeyenler).
///
/// - [hideImages]: `AppNetworkImage` içerik fotoğrafı yerine betimini
///   (alternatif metin) gösterir.
/// - [alignLeft]: `AppText` ortalanmış / sağa yaslı / iki yana yaslı metni
///   başa hizalar.
class AccessibilityScope extends InheritedWidget {
  const AccessibilityScope({
    required super.child,
    this.hideImages = false,
    this.alignLeft = false,
    super.key,
  });

  final bool hideImages;
  final bool alignLeft;

  static const AccessibilityScope _fallback = AccessibilityScope(
    child: SizedBox.shrink(),
  );

  /// Kök yoksa (ör. bileşen testleri) varsayılan değerler.
  static AccessibilityScope of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AccessibilityScope>() ??
      _fallback;

  @override
  bool updateShouldNotify(AccessibilityScope oldWidget) =>
      oldWidget.hideImages != hideImages || oldWidget.alignLeft != alignLeft;
}
