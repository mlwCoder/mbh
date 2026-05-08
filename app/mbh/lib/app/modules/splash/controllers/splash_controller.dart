import 'dart:async';

import 'package:get/get.dart';
import 'package:mbh/app/core/auth/auth_service.dart';
import 'package:mbh/app/core/base/base_controller.dart';
import 'package:mbh/app/core/logging/log.dart';
import 'package:mbh/app/core/routing/app_navigator.dart';
import 'package:mbh/app/core/storage/kv/app_storage.dart';

class SplashController extends BaseController {
  SplashController(this._storage, this._authService);

  final AppStorage _storage;
  final AuthService _authService;

  final RxInt countdown = 3.obs;

  Timer? _timer;
  bool _hasNavigated = false;

  @override
  void onReady() {
    super.onReady();
    _startRouteFlow();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  Future<void> _startRouteFlow() async {
    await _storage.setFirstLaunchCompleted();
    _startCountdown();
  }

  void _startCountdown() {
    _timer?.cancel();
    countdown.value = 3;

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (countdown.value <= 1) {
        timer.cancel();
        goToHome();
        return;
      }

      countdown.value -= 1;
    });
  }

  Future<void> goToHome() async {
    if (_hasNavigated) {
      return;
    }

    _hasNavigated = true;
    _timer?.cancel();
    Log.i('SPLASH', '倒计时结束，进入首页');
    await AppNavigator.toHome();
  }
}
