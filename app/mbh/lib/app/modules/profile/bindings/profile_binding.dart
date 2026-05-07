import 'package:get/get.dart';
import 'package:mbh/app/modules/auth/repositories/auth_repository.dart';
import 'package:mbh/app/modules/profile/controllers/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRepository>(AuthRepository.new);
    Get.lazyPut<ProfileController>(
      () => ProfileController(Get.find<AuthRepository>()),
    );
  }
}
