import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbh/app/core/auth/auth_service.dart';
import 'package:mbh/app/core/base/base_controller.dart';
import 'package:mbh/app/core/localization/locale_service.dart';
import 'package:mbh/app/core/routing/app_navigator.dart';
import 'package:mbh/app/core/theme/theme_service.dart';
import 'package:mbh/app/shared/shared.dart';

class SettingsController extends BaseController {
  SettingsController(this._themeService, this._localeService, this._authService);

  final ThemeService _themeService;
  final LocaleService _localeService;
  final AuthService _authService;

  ThemeMode get currentThemeMode => _themeService.themeMode;
  Locale get currentLocale => _localeService.locale;

  void toggleTheme() {
    final ThemeMode next =
        currentThemeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    _themeService.updateThemeMode(next);
  }

  void switchLocale() {
    final Locale next = switch ('${currentLocale.languageCode}_${currentLocale.countryCode}') {
      'zh_CN' => const Locale('en', 'US'),
      'en_US' => const Locale('ru', 'RU'),
      _ => const Locale('zh', 'CN'),
    };
    _localeService.updateLocale(next);
  }

  Future<void> logout() async {
    final bool? confirmed = await AppDialog.confirm(
      title: 'Logout',
      message: 'Are you sure you want to logout?',
    );

    if (confirmed == true) {
      await _authService.clearSession();
      await AppNavigator.toLogin();
    }
  }
}
