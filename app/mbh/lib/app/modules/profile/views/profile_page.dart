import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbh/app/core/theme/theme_context_ext.dart';
import 'package:mbh/app/core/theme/tokens/spacing.dart';
import 'package:mbh/app/modules/profile/controllers/profile_controller.dart';
import 'package:mbh/app/shared/shared.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(title: 'Profile'),
      body: Obx(() => _buildBody(context)),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (controller.isLoading.value) {
      return const AppLoading();
    }

    if (controller.hasError.value) {
      return AppErrorView(onRetry: controller.loadProfile);
    }

    final profile = controller.profile.value;
    if (profile == null) {
      return const AppEmpty();
    }

    return ListView(
      padding: const EdgeInsets.all(Spacing.xxl),
      children: [
        CircleAvatar(
          radius: 48,
          child: Text(
            profile.name.isNotEmpty ? profile.name[0].toUpperCase() : '?',
            style: context.appTextTheme.headlineLarge,
          ),
        ),
        const SizedBox(height: Spacing.lg),
        Text(
          profile.name,
          style: context.appTextTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        if (profile.email != null) ...[
          const SizedBox(height: Spacing.sm),
          Text(
            profile.email!,
            style: context.appTextTheme.bodyMedium?.copyWith(
              color: context.appTheme.mutedText,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}
