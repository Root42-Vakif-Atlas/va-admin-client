import 'package:flutter/material.dart';
import 'package:vakif_atlas_admin/core/l10n/l10n.dart';
import 'package:vakif_atlas_admin/shared/widgets/templates/status_message_view.dart';

/// Tanımsız bir adrese (ör. hatalı derin bağlantı) gidildiğinde gösterilir.
class NotFoundPage extends StatelessWidget {
  const NotFoundPage({required this.onGoHome, super.key});

  final VoidCallback onGoHome;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.notFoundTitle)),
      body: StatusMessageView(
        title: l10n.notFoundTitle,
        message: l10n.notFoundBody,
        actionLabel: l10n.notFoundAction,
        onAction: onGoHome,
      ),
    );
  }
}
