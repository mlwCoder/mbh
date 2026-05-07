import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbh/app/core/auth/auth_service.dart';
import 'package:mbh/app/core/routing/app_routes.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    final AuthService authService = Get.find<AuthService>();

    if (!authService.hasToken) {
      return const RouteSettings(name: AppRoutes.login);
    }

    return null;
  }
}
