import 'package:get/get.dart';
import 'package:mbh/app/core/auth/auth_service.dart';
import 'package:mbh/app/core/base/base_controller.dart';
import 'package:mbh/app/core/base/result.dart';
import 'package:mbh/app/core/logging/log.dart';
import 'package:mbh/app/core/routing/app_navigator.dart';
import 'package:mbh/app/modules/auth/models/login_request.dart';
import 'package:mbh/app/modules/auth/models/login_response.dart';
import 'package:mbh/app/modules/auth/repositories/auth_repository.dart';
import 'package:mbh/app/shared/shared.dart';

class LoginController extends BaseController {
  LoginController(this._authRepository, this._authService);

  final AuthRepository _authRepository;
  final AuthService _authService;

  final RxString account = ''.obs;
  final RxString password = ''.obs;

  bool get canSubmit => account.value.isNotEmpty && password.value.isNotEmpty;

  Future<void> login() async {
    Log.login('点击登录按钮');
    if (!canSubmit) {
      return;
    }

    showLoading();

    final Result<LoginResponse> result = await _authRepository.login(
      LoginRequest(
        account: account.value,
        password: password.value,
      ),
    );

    hideLoading();

    result.when(
      success: (LoginResponse data) {
        _authService.saveSession(
          accessToken: data.accessToken,
          refreshToken: data.refreshToken,
        );
        AppNavigator.toHome();
      },
      failure: (failure) {
        AppToast.show(failure.message);
      },
    );
  }
}
