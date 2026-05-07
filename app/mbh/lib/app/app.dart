import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mbh/app/core/constants/app_constants.dart';
import 'package:mbh/app/core/localization/app_translations.dart';
import 'package:mbh/app/core/localization/locale_service.dart';
import 'package:mbh/app/core/routing/app_pages.dart';
import 'package:mbh/app/core/routing/app_routes.dart';
import 'package:mbh/app/core/theme/app_theme.dart';
import 'package:mbh/app/core/theme/theme_service.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeService themeService = Get.find<ThemeService>();
    final LocaleService localeService = Get.find<LocaleService>();

    return ScreenUtilInit(
      designSize: const Size(
        AppConstants.designWidth,
        AppConstants.designHeight,
      ),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) {
        return Obx(
          () => GetMaterialApp(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            translations: AppTranslations(),
            locale: localeService.currentLocale.value,
            fallbackLocale: const Locale('en', 'US'),
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeService.currentThemeMode.value,
            initialRoute: AppRoutes.splash,
            getPages: AppPages.pages,
          ),
        );
      },
    );
  }
}
