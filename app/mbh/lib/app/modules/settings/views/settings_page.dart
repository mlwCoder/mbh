import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbh/app/core/localization/locale_keys.dart';
import 'package:mbh/app/core/theme/tokens/spacing.dart';
import 'package:mbh/app/modules/settings/controllers/settings_controller.dart';
import 'package:mbh/app/modules/settings/widgets/settings_tile.dart';
import 'package:mbh/app/shared/shared.dart';

class SettingsPage extends GetView<SettingsController> {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(title: 'Settings'),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: Spacing.lg),
        children: [
          SettingsTile(
            title: LocaleKeys.switchTheme.tr,
            onTap: controller.toggleTheme,
          ),
          SettingsTile(
            title: LocaleKeys.switchLanguage.tr,
            onTap: controller.switchLocale,
          ),
          const Divider(height: Spacing.xxl),
          SettingsTile(
            title: 'Logout',
            trailing: const Icon(Icons.logout, color: Colors.red),
            onTap: controller.logout,
          ),
        ],
      ),
    );
  }
}
