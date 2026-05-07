import 'package:get/get.dart';
import 'package:mbh/app/core/auth/auth_service.dart';
import 'package:mbh/app/core/localization/locale_service.dart';
import 'package:mbh/app/core/theme/theme_service.dart';
import 'package:mbh/app/modules/settings/controllers/settings_controller.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingsController>(
      () => SettingsController(
        Get.find<ThemeService>(),
        Get.find<LocaleService>(),
        Get.find<AuthService>(),
      ),
    );
  }
}
