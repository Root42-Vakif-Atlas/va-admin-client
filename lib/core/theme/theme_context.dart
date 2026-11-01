import 'package:flutter/material.dart';
import 'package:vakif_atlas_admin/core/theme/extensions/app_color_scheme.dart';
import 'package:vakif_atlas_admin/core/theme/extensions/app_text_theme.dart';

/// Tema extension'larına kısa erişim.
extension AppThemeContext on BuildContext {
  AppColorScheme get colors => Theme.of(this).extension<AppColorScheme>()!;

  AppTextTheme get textStyles => Theme.of(this).extension<AppTextTheme>()!;
}
