import 'package:flutter/material.dart';
import 'package:vakif_atlas_admin/core/theme/theme_context.dart';
import 'package:vakif_atlas_admin/core/theme/tokens/app_spacing.dart';

/// Liste + ayrıntı düzeni. Geniş pencerede (≥ [AppBreakpoints.split]) ikisi
/// yan yana; dar pencerede seçim varsa yalnızca ayrıntı (geri düğmesiyle),
/// yoksa liste gösterilir. Liste ve ayrıntı ayrı adlandırılmış bölgelerdir.
class MasterDetailLayout extends StatelessWidget {
  const MasterDetailLayout({
    required this.master,
    required this.detail,
    required this.placeholder,
    required this.masterLabel,
    required this.detailLabel,
    this.masterWidth = AppSizes.masterPane,
    super.key,
  });

  final Widget master;

  /// Seçili kaydın ayrıntısı; seçim yoksa `null`.
  final Widget? detail;

  /// Geniş düzende seçim yokken ayrıntı bölgesinde gösterilir.
  final Widget placeholder;
  final String masterLabel;
  final String detailLabel;
  final double masterWidth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= AppBreakpoints.split;
        final masterRegion = Semantics(
          container: true,
          explicitChildNodes: true,
          label: masterLabel,
          child: master,
        );
        final detailRegion = Semantics(
          container: true,
          explicitChildNodes: true,
          label: detailLabel,
          child: detail ?? placeholder,
        );
        if (!wide) {
          return detail == null ? masterRegion : detailRegion;
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(width: masterWidth, child: masterRegion),
            VerticalDivider(
              width: AppSizes.borderThin,
              color: context.colors.outlineVariant,
            ),
            Expanded(child: detailRegion),
          ],
        );
      },
    );
  }
}
