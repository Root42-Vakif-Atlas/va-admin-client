import 'dart:ui';

import 'package:flutter/semantics.dart';
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';

/// Ekran okuyuculara (TalkBack / VoiceOver) gönderilecek duyurunun iletimi.
typedef AnnouncementSender = Future<void> Function(
  FlutterView view,
  String message,
  TextDirection textDirection,
  Assertiveness assertiveness,
);

/// Asenkron işlemler tamamlandığında ekran okuyucuya sesli bildirim
/// gönderir (TRD §7 — WCAG 4.1.3 Durum Mesajları).
///
/// Mesajlar çağıran tarafından yerelleştirilmiş olarak verilir.
@lazySingleton
class A11yAnnouncer {
  A11yAnnouncer() : this.withSender(_platformSender);

  A11yAnnouncer.withSender(this._send);

  final AnnouncementSender _send;

  /// [message] metnini ekran okuyucuya iletir.
  ///
  /// [assertive] yalnızca kullanıcının işini kesmesi gereken hatalarda
  /// kullanılır; diğer durumlar mevcut okumayı bölmeden (polite) duyurulur.
  Future<void> announce(
    String message, {
    TextDirection textDirection = TextDirection.ltr,
    bool assertive = false,
  }) async {
    if (message.trim().isEmpty) {
      return;
    }
    final dispatcher = WidgetsBinding.instance.platformDispatcher;
    final view = dispatcher.implicitView ?? dispatcher.views.firstOrNull;
    if (view == null) {
      return;
    }
    await _send(
      view,
      message,
      textDirection,
      assertive ? Assertiveness.assertive : Assertiveness.polite,
    );
  }

  static Future<void> _platformSender(
    FlutterView view,
    String message,
    TextDirection textDirection,
    Assertiveness assertiveness,
  ) {
    return SemanticsService.sendAnnouncement(
      view,
      message,
      textDirection,
      assertiveness: assertiveness,
    );
  }
}
