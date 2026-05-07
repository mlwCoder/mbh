import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbh/app/core/localization/locale_keys.dart';
import 'package:mbh/app/core/theme/theme_context_ext.dart';
import 'package:mbh/app/core/theme/tokens/spacing.dart';
import 'package:mbh/app/modules/onboarding/controllers/onboarding_controller.dart';
import 'package:mbh/app/shared/shared.dart';

class OnboardingPage extends GetView<OnboardingController> {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Spacing.xxl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.onboardingTitle.tr,
                style: context.appTextTheme.headlineMedium,
              ),
              const SizedBox(height: Spacing.lg),
              AppButton(
                label: LocaleKeys.onboardingContinue.tr,
                onPressed: controller.completeOnboarding,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
