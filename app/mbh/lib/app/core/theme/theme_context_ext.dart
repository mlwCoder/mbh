import 'package:flutter/material.dart';
import 'package:mbh/app/core/theme/app_theme_extension.dart';

extension ThemeDataX on BuildContext {
  ThemeData get theme => Theme.of(this);

  AppThemeExtension get appTheme => theme.extension<AppThemeExtension>()!;

  TextTheme get appTextTheme => theme.textTheme;

  ColorScheme get appColorScheme => theme.colorScheme;
}
