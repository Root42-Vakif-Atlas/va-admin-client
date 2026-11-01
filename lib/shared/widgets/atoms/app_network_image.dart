import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vakif_atlas_admin/core/a11y/accessibility_scope.dart';
import 'package:vakif_atlas_admin/core/a11y/reduce_motion.dart';
import 'package:vakif_atlas_admin/core/l10n/l10n.dart';
import 'package:vakif_atlas_admin/core/theme/theme_context.dart';
import 'package:vakif_atlas_admin/core/theme/tokens/app_durations.dart';
import 'package:vakif_atlas_admin/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas_admin/shared/widgets/atoms/app_icon.dart';

/// Ağdan yüklenen görsel: yükleniyor ve hata durumları tema renkleriyle,
/// belirme animasyonu hareket azaltmaya duyarlı çizilir.
///
/// [semanticsLabel] verilirse görsel ekran okuyucuya bu betimle sunulur
/// (WCAG 1.1.1); verilmezse süs görseli kabul edilip gizlenir.
///
/// Erişilebilirlik → "Görseli gizle" açıkken görsel yüklenmez; yerine
/// betimi (yoksa "Görsel gizlendi") gösterilir.
class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({
    required this.url,
    this.semanticsLabel,
    this.fit = BoxFit.cover,
    super.key,
  });

  final String url;
  final String? semanticsLabel;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final label = semanticsLabel;
    if (AccessibilityScope.of(context).hideImages) {
      return _HiddenImage(description: label);
    }
    final reduceMotion = context.reduceMotion;
    Widget frameBuilder(
      BuildContext context,
      Widget child,
      int? frame,
      bool wasSynchronouslyLoaded,
    ) {
      if (wasSynchronouslyLoaded || reduceMotion) {
        return child;
      }
      return AnimatedOpacity(
        opacity: frame == null ? 0 : 1,
        duration: AppDurations.normal,
        curve: Curves.easeOut,
        child: child,
      );
    }

    Widget errorBuilder(BuildContext context, Object error, StackTrace? _) =>
        _ImagePlaceholder.error(announce: label != null);

    final dataBytes = _DataUriCache.bytesOf(url);
    if (dataBytes != null) {
      return Image.memory(
        dataBytes,
        fit: fit,
        width: double.infinity,
        height: double.infinity,
        semanticLabel: label,
        excludeFromSemantics: label == null,
        frameBuilder: frameBuilder,
        errorBuilder: errorBuilder,
      );
    }
    return Image.network(
      url,
      fit: fit,
      width: double.infinity,
      height: double.infinity,
      semanticLabel: label,
      excludeFromSemantics: label == null,
      frameBuilder: frameBuilder,
      loadingBuilder: (context, child, progress) =>
          progress == null ? child : const _ImagePlaceholder.loading(),
      errorBuilder: errorBuilder,
    );
  }
}

/// `data:` adresli görseller (ör. testlerdeki sahte backend'in fotoğrafları)
/// bellekten çizilir. Aynı bayt örneği yeniden kullanıldığında Flutter görsel
/// önbelleği çözümlenmiş kareyi tekrar kullanır.
abstract final class _DataUriCache {
  static const int _capacity = 24;
  static final Map<String, Uint8List> _entries = {};

  static Uint8List? bytesOf(String url) {
    if (!url.startsWith('data:')) {
      return null;
    }
    final cached = _entries.remove(url);
    if (cached != null) {
      return _entries[url] = cached;
    }
    final data = Uri.tryParse(url)?.data;
    if (data == null) {
      return null;
    }
    final bytes = data.contentAsBytes();
    if (_entries.length >= _capacity) {
      _entries.remove(_entries.keys.first);
    }
    return _entries[url] = bytes;
  }
}

class _HiddenImage extends StatelessWidget {
  const _HiddenImage({this.description});

  final String? description;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ColoredBox(
      key: const Key('hidden_image'),
      color: colors.surfaceVariant,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xs),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppIcon.decorative(
                Icons.hide_image_outlined,
                color: colors.onSurfaceVariant,
              ),
              const SizedBox(height: AppSpacing.xxs),
              Flexible(
                child: Text(
                  description ?? context.l10n.a11yImageHidden,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.fade,
                  style: context.textStyles.labelSmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder.loading() : isError = false, announce = false;

  const _ImagePlaceholder.error({required this.announce}) : isError = true;

  final bool isError;

  /// Hata, anlamlı (betimli) bir görsel için ekran okuyucuya bildirilir.
  final bool announce;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final Widget indicator;
    if (isError) {
      indicator = announce
          ? AppIcon(
              Icons.broken_image_outlined,
              semanticsLabel: context.l10n.galleryImageError,
              color: colors.onSurfaceVariant,
            )
          : AppIcon.decorative(
              Icons.broken_image_outlined,
              color: colors.onSurfaceVariant,
            );
    } else if (context.reduceMotion) {
      indicator = AppIcon.decorative(
        Icons.hourglass_top,
        color: colors.onSurfaceVariant,
      );
    } else {
      indicator = SizedBox.square(
        dimension: AppSizes.spinner,
        child: CircularProgressIndicator(
          strokeWidth: AppSizes.spinnerStroke,
          color: colors.accentText,
        ),
      );
    }
    return ColoredBox(
      color: colors.surfaceVariant,
      child: Center(child: indicator),
    );
  }
}
