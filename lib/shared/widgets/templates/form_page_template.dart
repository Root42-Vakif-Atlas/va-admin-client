import 'package:flutter/material.dart';
import 'package:vakif_atlas_admin/core/theme/tokens/app_spacing.dart';

/// Kaydırılabilir, klavye güvenli ve okunabilir genişlikte form şablonu
/// (Design System §4.2.4).
///
/// İçerik `CustomScrollView` içindedir; %200 metin ölçeğinde veya klavye
/// açıkken taşma oluşmaz. `Scaffold`'un `resizeToAvoidBottomInset`
/// varsayılanı (`true`) korunmalıdır.
class FormPageTemplate extends StatelessWidget {
  const FormPageTemplate({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(AppSpacing.md),
            sliver: SliverToBoxAdapter(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: AppSizes.maxContentWidth,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: children,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
