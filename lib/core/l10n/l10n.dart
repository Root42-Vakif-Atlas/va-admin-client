import 'package:flutter/widgets.dart';
import 'package:vakif_atlas_admin/core/l10n/generated/app_localizations.dart';

export 'package:vakif_atlas_admin/core/l10n/generated/app_localizations.dart';

/// Yerelleştirilmiş metinlere kısa erişim: `context.l10n.appTitle`.
extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
