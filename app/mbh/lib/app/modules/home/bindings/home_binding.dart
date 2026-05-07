import 'package:get/get.dart';
import 'package:mbh/app/modules/home/controllers/home_controller.dart';
import 'package:mbh/app/modules/home/repositories/home_repository.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeRepository>(HomeRepository.new);
    Get.lazyPut<HomeController>(
      () => HomeController(Get.find<HomeRepository>()),
    );
  }
}
