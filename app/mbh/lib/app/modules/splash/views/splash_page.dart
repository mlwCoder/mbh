import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbh/app/core/localization/locale_keys.dart';
import 'package:mbh/app/core/theme/theme_context_ext.dart';
import 'package:mbh/app/modules/splash/controllers/splash_controller.dart';

class SplashPage extends GetView<SplashController> {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 16,
              right: 16,
              child: Obx(
                () => TextButton(
                  onPressed: controller.goToHome,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    backgroundColor: Colors.black.withValues(alpha: 0.45),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    '${controller.countdown.value}s ${LocaleKeys.splashSkip.tr}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: Text(
                LocaleKeys.splashTitle.tr,
                style: context.appTextTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
