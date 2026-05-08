import 'package:get/get.dart';
import 'package:mbh/app/core/routing/app_routes.dart';

class AppNavigator {
  const AppNavigator._();

  static String get loginRoute => AppRoutes.login;

  static Future<dynamic>? toHome() {
    return Get.offAllNamed(AppRoutes.home);
  }

  static Future<dynamic>? toLogin() {
    return Get.toNamed(AppRoutes.login);
  }

  static Future<dynamic>? offToLogin() {
    return Get.offAllNamed(AppRoutes.login);
  }

  static Future<dynamic>? toOnboarding() {
    return Get.offAllNamed(AppRoutes.onboarding);
  }
}
