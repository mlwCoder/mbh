import 'package:get/get.dart';
import 'package:mbh/app/core/base/base_controller.dart';
import 'package:mbh/app/core/base/result.dart';
import 'package:mbh/app/modules/auth/models/user_profile.dart';
import 'package:mbh/app/modules/auth/repositories/auth_repository.dart';
import 'package:mbh/app/shared/shared.dart';

class ProfileController extends BaseController {
  ProfileController(this._authRepository);

  final AuthRepository _authRepository;

  final Rx<UserProfile?> profile = Rx<UserProfile?>(null);
  final RxBool hasError = false.obs;

  @override
  void onReady() {
    super.onReady();
    loadProfile();
  }

  Future<void> loadProfile() async {
    showLoading();
    hasError.value = false;

    final Result<UserProfile> result = await _authRepository.fetchProfile();

    hideLoading();

    result.when(
      success: (UserProfile data) {
        profile.value = data;
      },
      failure: (failure) {
        hasError.value = true;
        AppToast.show(failure.message);
      },
    );
  }
}
