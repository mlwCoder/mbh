import 'package:get/get.dart';
import 'package:mbh/app/core/auth/auth_service.dart';
import 'package:mbh/app/modules/auth/controllers/login_controller.dart';
import 'package:mbh/app/modules/auth/repositories/auth_repository.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRepository>(AuthRepository.new);
    Get.lazyPut<LoginController>(
      () => LoginController(
        Get.find<AuthRepository>(),
        Get.find<AuthService>(),
      ),
    );
  }
}
