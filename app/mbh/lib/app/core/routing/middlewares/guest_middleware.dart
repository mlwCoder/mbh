import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbh/app/core/auth/auth_service.dart';
import 'package:mbh/app/core/routing/app_routes.dart';

class GuestMiddleware extends GetMiddleware {
  @override
  int? get priority => 2;

  @override
  RouteSettings? redirect(String? route) {
    final AuthService authService = Get.find<AuthService>();

    if (authService.hasToken) {
      return const RouteSettings(name: AppRoutes.home);
    }

    return null;
  }
}
