import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Kullanıcı etkileşimi (işaretçi, kaydırma, klavye) olmadan [timeout]
/// geçerse [onTimeout] çağrılır. Personel oturumunun hareketsizlik sınırıdır
/// (OWASP ASVS V3.3: yönetici oturumu kısa süreli); sunucuda da yenileme
/// anahtarı aynı sürede geçersizleşir. Ağaç yapısını değiştirmez.
class IdleTimer extends StatefulWidget {
  const IdleTimer({
    required this.enabled,
    required this.onTimeout,
    required this.child,
    this.timeout = defaultTimeout,
    super.key,
  });

  static const Duration defaultTimeout = Duration(minutes: 30);

  final bool enabled;
  final Duration timeout;
  final VoidCallback onTimeout;
  final Widget child;

  @override
  State<IdleTimer> createState() => _IdleTimerState();
}

class _IdleTimerState extends State<IdleTimer> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(_onKey);
    _restart();
  }

  @override
  void didUpdateWidget(IdleTimer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.enabled != widget.enabled ||
        oldWidget.timeout != widget.timeout) {
      _restart();
    }
  }

  bool _onKey(KeyEvent event) {
    _restart();
    return false;
  }

  void _restart() {
    _timer?.cancel();
    if (widget.enabled) {
      _timer = Timer(widget.timeout, widget.onTimeout);
    }
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_onKey);
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) => _restart(),
      onPointerHover: (_) => _restart(),
      onPointerSignal: (_) => _restart(),
      child: widget.child,
    );
  }
}
