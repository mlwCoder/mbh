import 'package:get/get.dart';
import 'package:mbh/app/core/storage/kv/app_storage.dart';
import 'package:mbh/app/modules/onboarding/controllers/onboarding_controller.dart';

class OnboardingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnboardingController>(
      () => OnboardingController(Get.find<AppStorage>()),
    );
  }
}
