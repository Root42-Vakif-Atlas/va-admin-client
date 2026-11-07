import 'package:flutter/material.dart';
import 'package:vakif_atlas_admin/core/l10n/l10n.dart';
import 'package:vakif_atlas_admin/core/theme/responsive.dart';
import 'package:vakif_atlas_admin/core/theme/theme_context.dart';
import 'package:vakif_atlas_admin/core/theme/tokens/app_spacing.dart';

/// Liste + ayrıntı düzeni (ADR A5). Geniş pencerede
/// ([ResponsiveContext.isSplitView]) ikisi yan yana; dar pencerede seçim
/// varsa yalnızca ayrıntı (üstte geri çubuğu; sistem geri hareketi de listeye
/// döner), yoksa liste gösterilir. Liste ve ayrıntı ayrı adlandırılmış
/// bölgelerdir.
class MasterDetailLayout extends StatelessWidget {
  const MasterDetailLayout({
    required this.master,
    required this.detail,
    required this.placeholder,
    required this.masterLabel,
    required this.detailLabel,
    this.onCloseDetail,
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

  /// Dar düzende geri çubuğu / sistem geri hareketi (seçimi kaldırır).
  final VoidCallback? onCloseDetail;
  final double masterWidth;

  @override
  Widget build(BuildContext context) {
    final split = context.isSplitView;
    final masterRegion = Semantics(
      container: true,
      explicitChildNodes: true,
      label: masterLabel,
      child: master,
    );
    final detailRegion = MasterDetailScope(
      split: split,
      child: Semantics(
        container: true,
        explicitChildNodes: true,
        label: detailLabel,
        child: detail ?? placeholder,
      ),
    );
    if (!split) {
      if (detail == null) {
        return masterRegion;
      }
      final onClose = onCloseDetail;
      if (onClose == null) {
        return detailRegion;
      }
      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) {
            onClose();
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _BackBar(label: masterLabel, onBack: onClose),
            Expanded(child: detailRegion),
          ],
        ),
      );
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
  }
}

/// Ayrıntı panelinin hangi düzende çizildiğini alt ağaca bildirir.
class MasterDetailScope extends InheritedWidget {
  const MasterDetailScope({
    required this.split,
    required super.child,
    super.key,
  });

  /// `true` → liste yanında (kapat düğmesi gerekir); `false` → tam sayfa
  /// (geri çubuğu düzenin kendisinde).
  final bool split;

  /// Kapsam yoksa (ör. bağımsız test) yan yana sayılır.
  static bool isSplit(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<MasterDetailScope>()?.split ??
      true;

  @override
  bool updateShouldNotify(MasterDetailScope oldWidget) =>
      split != oldWidget.split;
}

/// Ayrıntı başlığındaki kapat düğmesi; dar düzende geri çubuğu aynı işi
/// yaptığından gizlenir.
class DetailCloseButton extends StatelessWidget {
  const DetailCloseButton({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    if (!MasterDetailScope.isSplit(context)) {
      return const SizedBox.shrink();
    }
    return IconButton(
      tooltip: context.l10n.commonClose,
      onPressed: onPressed,
      icon: const Icon(Icons.close),
    );
  }
}

class _BackBar extends StatelessWidget {
  const _BackBar({required this.label, required this.onBack});

  final String label;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(bottom: BorderSide(color: colors.outlineVariant)),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.only(
          start: context.pageGutter - AppSpacing.xs,
          end: context.pageGutter,
        ),
        child: SizedBox(
          height: AppSizes.minTouchTarget,
          child: Row(
            children: [
              IconButton(
                tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                onPressed: onBack,
                icon: const BackButtonIcon(),
              ),
              const SizedBox(width: AppSpacing.xxs),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textStyles.titleMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
