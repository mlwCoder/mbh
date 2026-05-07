import 'package:get/get.dart';
import 'package:mbh/app/core/auth/auth_service.dart';
import 'package:mbh/app/core/storage/kv/app_storage.dart';
import 'package:mbh/app/modules/splash/controllers/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(
      () => SplashController(
        Get.find<AppStorage>(),
        Get.find<AuthService>(),
      ),
    );
  }
}
