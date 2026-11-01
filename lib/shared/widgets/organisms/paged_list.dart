import 'package:flutter/material.dart';
import 'package:vakif_atlas_admin/core/l10n/l10n.dart';
import 'package:vakif_atlas_admin/core/theme/theme_context.dart';
import 'package:vakif_atlas_admin/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas_admin/shared/widgets/templates/loading_status_view.dart';
import 'package:vakif_atlas_admin/shared/widgets/templates/status_message_view.dart';

/// İmleçli liste: ilk yükleme, boş/hata durumları, sona yaklaşınca sonraki
/// sayfa ve görünür "Daha fazla yükle" düğmesi (kaydırmaya alternatif,
/// WCAG 2.5.1). Toplam sayı listenin başında okunur.
class PagedList<T> extends StatefulWidget {
  const PagedList({
    required this.items,
    required this.total,
    required this.itemBuilder,
    required this.isLoading,
    required this.isLoadingMore,
    required this.hasMore,
    required this.onLoadMore,
    required this.onRetry,
    this.errorMessage,
    this.emptyTitle,
    this.emptyMessage,
    this.showSummary = true,
    this.padding = const EdgeInsets.symmetric(vertical: AppSpacing.xs),
    super.key,
  });

  final List<T> items;
  final int total;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final VoidCallback onLoadMore;
  final VoidCallback onRetry;

  /// İlk sayfa yüklenemediyse kullanıcı mesajı.
  final String? errorMessage;
  final String? emptyTitle;
  final String? emptyMessage;

  /// `false` → "N / M gösteriliyor" satırı listede çizilmez (çağıran
  /// kendi yerinde gösterir, ör. tablo alt bilgisi).
  final bool showSummary;
  final EdgeInsetsGeometry padding;

  @override
  State<PagedList<T>> createState() => _PagedListState<T>();
}

class _PagedListState<T> extends State<PagedList<T>> {
  static const double _prefetchExtent = 600;

  bool _onScroll(ScrollNotification notification) {
    if (widget.hasMore &&
        !widget.isLoadingMore &&
        notification.metrics.extentAfter < _prefetchExtent) {
      widget.onLoadMore();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    if (widget.isLoading && widget.items.isEmpty) {
      return LoadingStatusView(label: l10n.commonLoading);
    }
    if (widget.errorMessage != null && widget.items.isEmpty) {
      return StatusMessageView(
        tone: StatusMessageTone.error,
        title: l10n.commonLoadError,
        message: widget.errorMessage!,
        actionLabel: l10n.commonRetry,
        onAction: widget.onRetry,
      );
    }
    if (widget.items.isEmpty) {
      return StatusMessageView(
        title: widget.emptyTitle ?? l10n.commonEmptyTitle,
        message: widget.emptyMessage ?? l10n.commonEmptyFiltered,
      );
    }
    return NotificationListener<ScrollNotification>(
      onNotification: _onScroll,
      child: ListView.builder(
        padding: widget.padding,
        itemCount: widget.items.length + 2,
        itemBuilder: (context, index) {
          if (index == 0) {
            if (!widget.showSummary) {
              return const SizedBox.shrink();
            }
            return Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.xxs,
                AppSpacing.md,
                AppSpacing.xs,
              ),
              child: Semantics(
                liveRegion: true,
                child: Text(
                  l10n.commonShownOfTotal(widget.items.length, widget.total),
                  style: context.textStyles.labelMedium.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
              ),
            );
          }
          if (index == widget.items.length + 1) {
            if (!widget.hasMore) {
              return const SizedBox(height: AppSpacing.md);
            }
            return Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Center(
                child: widget.isLoadingMore
                    ? const SizedBox.square(
                        dimension: AppSizes.spinner,
                        child: CircularProgressIndicator(
                          strokeWidth: AppSizes.spinnerStroke,
                        ),
                      )
                    : OutlinedButton(
                        onPressed: widget.onLoadMore,
                        child: Text(l10n.commonLoadMore),
                      ),
              ),
            );
          }
          return widget.itemBuilder(
            context,
            widget.items[index - 1],
            index - 1,
          );
        },
      ),
    );
  }
}
