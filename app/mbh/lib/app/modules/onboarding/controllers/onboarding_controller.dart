import 'package:get/get.dart';
import 'package:mbh/app/core/base/base_controller.dart';
import 'package:mbh/app/core/routing/app_navigator.dart';
import 'package:mbh/app/core/storage/kv/app_storage.dart';

class OnboardingController extends BaseController {
  OnboardingController(this._storage);

  final AppStorage _storage;

  Future<void> completeOnboarding() async {
    await _storage.setFirstLaunchCompleted();
    await AppNavigator.toLogin();
  }
}
