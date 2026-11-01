import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Arama alanına odaklan (Cmd/Ctrl + F).
class FocusSearchIntent extends Intent {
  const FocusSearchIntent();
}

/// Yeni kayıt (Cmd/Ctrl + N).
class CreateItemIntent extends Intent {
  const CreateItemIntent();
}

/// Formu kaydet (Cmd/Ctrl + S).
class SaveIntent extends Intent {
  const SaveIntent();
}

/// Listeyi yenile (Cmd/Ctrl + R, F5).
class RefreshIntent extends Intent {
  const RefreshIntent();
}

/// Ayrıntı panelini kapat (Esc).
class CloseDetailIntent extends Intent {
  const CloseDetailIntent();
}

/// Masaüstü klavye kısayolları. macOS'ta Command, diğer platformlarda Control
/// kullanılır. Kısayollar sayfanın `Actions` eşlemesiyle etkinleşir; eylemi
/// olmayan sayfada tuş yok sayılır. Her kısayolun aynı işi yapan görünür bir
/// düğmesi vardır (WCAG 2.1.1, 2.1.4: tek tuşlu kısayol yok).
abstract final class AppShortcuts {
  static bool get _apple =>
      defaultTargetPlatform == TargetPlatform.macOS ||
      defaultTargetPlatform == TargetPlatform.iOS;

  static SingleActivator primary(LogicalKeyboardKey key) =>
      SingleActivator(key, meta: _apple, control: !_apple);

  static Map<ShortcutActivator, Intent> get bindings => {
    primary(LogicalKeyboardKey.keyF): const FocusSearchIntent(),
    primary(LogicalKeyboardKey.keyN): const CreateItemIntent(),
    primary(LogicalKeyboardKey.keyS): const SaveIntent(),
    primary(LogicalKeyboardKey.keyR): const RefreshIntent(),
    const SingleActivator(LogicalKeyboardKey.f5): const RefreshIntent(),
    const SingleActivator(LogicalKeyboardKey.escape): const CloseDetailIntent(),
  };

  /// Düğme ipuçlarında gösterilen biçim (⌘F / Ctrl+F).
  static String label(String key) => _apple ? '⌘$key' : 'Ctrl+$key';
}
