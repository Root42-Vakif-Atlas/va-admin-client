import 'package:flutter/material.dart';
import 'package:vakif_atlas_admin/core/theme/theme_context.dart';
import 'package:vakif_atlas_admin/shared/widgets/molecules/status_chip.dart';

/// Personelin birincil rolü: nötr etiket (rol bilgidir, vurgu değil).
class RoleBadge extends StatelessWidget {
  const RoleBadge({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) => StatusChip(
    label: label,
    tone: context.colors.isHighContrast
        ? StatusTone.accent
        : StatusTone.neutral,
  );
}
