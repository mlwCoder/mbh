import 'package:get/get.dart';
import 'package:mbh/app/core/routing/app_routes.dart';
import 'package:mbh/app/core/routing/middlewares/auth_middleware.dart';
import 'package:mbh/app/core/routing/middlewares/guest_middleware.dart';
import 'package:mbh/app/modules/auth/bindings/auth_binding.dart';
import 'package:mbh/app/modules/auth/views/login_page.dart';
import 'package:mbh/app/modules/home/bindings/home_binding.dart';
import 'package:mbh/app/modules/home/views/home_page.dart';
import 'package:mbh/app/modules/onboarding/bindings/onboarding_binding.dart';
import 'package:mbh/app/modules/onboarding/views/onboarding_page.dart';
import 'package:mbh/app/modules/profile/bindings/profile_binding.dart';
import 'package:mbh/app/modules/profile/views/profile_page.dart';
import 'package:mbh/app/modules/settings/bindings/settings_binding.dart';
import 'package:mbh/app/modules/settings/views/settings_page.dart';
import 'package:mbh/app/modules/splash/bindings/splash_binding.dart';
import 'package:mbh/app/modules/splash/views/splash_page.dart';

class AppPages {
  const AppPages._();

  static final List<GetPage<dynamic>> pages = <GetPage<dynamic>>[
    GetPage<dynamic>(
      name: AppRoutes.splash,
      page: SplashPage.new,
      binding: SplashBinding(),
    ),
    GetPage<dynamic>(
      name: AppRoutes.onboarding,
      page: OnboardingPage.new,
      binding: OnboardingBinding(),
    ),
    GetPage<dynamic>(
      name: AppRoutes.login,
      page: LoginPage.new,
      binding: AuthBinding(),
      middlewares: <GetMiddleware>[GuestMiddleware()],
    ),
    GetPage<dynamic>(
      name: AppRoutes.home,
      page: HomePage.new,
      binding: HomeBinding(),
      middlewares: <GetMiddleware>[AuthMiddleware()],
    ),
    GetPage<dynamic>(
      name: AppRoutes.settings,
      page: SettingsPage.new,
      binding: SettingsBinding(),
      middlewares: <GetMiddleware>[AuthMiddleware()],
    ),
    GetPage<dynamic>(
      name: AppRoutes.profile,
      page: ProfilePage.new,
      binding: ProfileBinding(),
      middlewares: <GetMiddleware>[AuthMiddleware()],
    ),
  ];
}
