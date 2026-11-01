import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vakif_atlas_admin/core/l10n/l10n.dart';
import 'package:vakif_atlas_admin/core/network/network_status.dart';
import 'package:vakif_atlas_admin/core/theme/theme_context.dart';
import 'package:vakif_atlas_admin/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas_admin/shared/widgets/atoms/app_text.dart';

/// Cihaz çevrimdışıyken uygulamanın üstünde kalıcı bir şerit gösterir.
///
/// Durum ikon + metinle verilir (renge bağlı değil); değişiklik
/// [onAnnounce] ile ekran okuyucuya duyurulur. Şerit görünürken alttaki
/// içeriğin üst güvenli alanı şerit tarafından kullanılır.
class OfflineBanner extends StatefulWidget {
  const OfflineBanner({
    required this.network,
    required this.onAnnounce,
    required this.child,
    super.key,
  });

  final NetworkStatus network;
  final void Function(String message, {required bool offline}) onAnnounce;
  final Widget child;

  @override
  State<OfflineBanner> createState() => _OfflineBannerState();
}

class _OfflineBannerState extends State<OfflineBanner> {
  late bool _online;
  late StreamSubscription<bool> _subscription;

  @override
  void initState() {
    super.initState();
    _online = widget.network.isOnline;
    _subscription = _listen();
  }

  StreamSubscription<bool> _listen() => widget.network.changes.listen((online) {
    if (!mounted || online == _online) {
      return;
    }
    setState(() => _online = online);
    final l10n = context.l10n;
    widget.onAnnounce(
      online ? l10n.onlineAnnouncement : l10n.offlineAnnouncement,
      offline: !online,
    );
  });

  @override
  void didUpdateWidget(OfflineBanner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.network != widget.network) {
      unawaited(_subscription.cancel());
      _online = widget.network.isOnline;
      _subscription = _listen();
    }
  }

  @override
  void dispose() {
    unawaited(_subscription.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Ağaç yapısı çevrimdışı durumda da aynı kalır: alt ağaç (yönlendirici)
    // yeniden kurulmaz.
    return Column(
      children: [
        if (_online) const SizedBox.shrink() else const _Strip(),
        Expanded(
          child: MediaQuery.removePadding(
            context: context,
            removeTop: !_online,
            child: widget.child,
          ),
        ),
      ],
    );
  }
}

class _Strip extends StatelessWidget {
  const _Strip();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Material(
      key: const Key('offline_banner'),
      color: colors.secondaryContainer,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          child: Semantics(
            container: true,
            child: Row(
              children: [
                Icon(
                  Icons.cloud_off_outlined,
                  color: colors.onSecondaryContainer,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: AppText(
                    context.l10n.offlineBannerMessage,
                    role: AppTextRole.bodyMedium,
                    color: colors.onSecondaryContainer,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
