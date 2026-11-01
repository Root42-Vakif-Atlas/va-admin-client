import 'package:flutter/material.dart';

/// Uygulamanın kısa bildirimleri (SnackBar) için tek kural.
///
/// Flutter, eylem butonu olan SnackBar'ı varsayılan olarak kalıcı yapar
/// (`persist`); bu yüzden "Geri al", "Ayarlar" gibi eylemli bildirimler hiç
/// kapanmıyordu. Burada:
/// - Eylemsiz bildirim [shortDuration], eylemli bildirim [actionDuration]
///   sonra kendiliğinden kapanır (Material: 4–10 sn).
/// - Ekran okuyucu açıkken (`accessibleNavigation`) eylemli bildirim, kullanıcı
///   eyleme ulaşabilsin diye kapat butonuyla kalıcıdır (WCAG 2.2.1).
abstract final class AppSnackBar {
  static const Duration shortDuration = Duration(seconds: 4);
  static const Duration actionDuration = Duration(seconds: 8);

  static SnackBar build(
    BuildContext context, {
    required String message,
    SnackBarAction? action,
    Duration? duration,
    Key? key,
  }) => create(
    accessibleNavigation: MediaQuery.accessibleNavigationOf(context),
    message: message,
    action: action,
    duration: duration,
    key: key,
  );

  /// Bağlamın beklemeden sonra kullanılamadığı yerler için: ekran okuyucu
  /// durumu önceden okunur.
  static SnackBar create({
    required bool accessibleNavigation,
    required String message,
    SnackBarAction? action,
    Duration? duration,
    Key? key,
  }) {
    final persist = action != null && accessibleNavigation;
    return SnackBar(
      key: key,
      content: Text(message),
      action: action,
      duration: duration ?? (action == null ? shortDuration : actionDuration),
      persist: persist,
      showCloseIcon: persist,
    );
  }

  /// Önceki bildirimi kapatıp yenisini gösterir.
  static void show(
    BuildContext context, {
    required String message,
    SnackBarAction? action,
    Duration? duration,
    Key? key,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        build(
          context,
          message: message,
          action: action,
          duration: duration,
          key: key,
        ),
      );
  }
}
