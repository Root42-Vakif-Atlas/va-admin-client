import 'package:flutter/material.dart';
import 'package:vakif_atlas_admin/core/l10n/l10n.dart';
import 'package:vakif_atlas_admin/core/theme/theme_context.dart';
import 'package:vakif_atlas_admin/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas_admin/shared/widgets/atoms/app_network_image.dart';

/// Şeritteki fotoğraf.
@immutable
class StripPhoto {
  const StripPhoto({
    required this.url,
    required this.thumbnailUrl,
    required this.semanticsLabel,
    this.caption,
  });

  final String url;
  final String thumbnailUrl;
  final String semanticsLabel;
  final String? caption;
}

/// Küçük resim şeridi; dokunma/Enter büyük görüntüyü diyalogda açar.
class PhotoStrip extends StatelessWidget {
  const PhotoStrip({required this.photos, super.key});

  final List<StripPhoto> photos;

  static const double _thumbnail = 112;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: [
        for (final photo in photos)
          Semantics(
            button: true,
            label: photo.semanticsLabel,
            excludeSemantics: true,
            child: InkWell(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              onTap: () => showPhotoViewer(context, photo),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.sm),
                child: SizedBox.square(
                  dimension: _thumbnail,
                  child: AppNetworkImage(url: photo.thumbnailUrl),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

Future<void> showPhotoViewer(BuildContext context, StripPhoto photo) {
  final l10n = context.l10n;
  return showDialog<void>(
    context: context,
    builder: (context) => Dialog(
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200, maxHeight: 900),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Flexible(
              child: InteractiveViewer(
                child: AppNetworkImage(
                  url: photo.url,
                  fit: BoxFit.contain,
                  semanticsLabel: photo.semanticsLabel,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      photo.caption ?? '',
                      style: context.textStyles.bodyMedium,
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(l10n.commonClose),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
