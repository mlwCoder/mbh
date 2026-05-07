import 'package:get/get.dart';
import 'package:mbh/app/core/storage/secure/secure_storage_service.dart';

class AuthService extends GetxService {
  AuthService(this._secureStorageService);

  final SecureStorageService _secureStorageService;

  final RxBool isLoggedIn = false.obs;
  String? _cachedAccessToken;

  Future<AuthService> init() async {
    _cachedAccessToken = await _secureStorageService.readAccessToken();
    isLoggedIn.value = _cachedAccessToken != null && _cachedAccessToken!.isNotEmpty;
    return this;
  }

  bool get hasToken => _cachedAccessToken != null && _cachedAccessToken!.isNotEmpty;

  Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _secureStorageService.writeAccessToken(accessToken);
    await _secureStorageService.writeRefreshToken(refreshToken);
    _cachedAccessToken = accessToken;
    isLoggedIn.value = true;
  }

  Future<void> clearSession() async {
    await _secureStorageService.clearTokens();
    _cachedAccessToken = null;
    isLoggedIn.value = false;
  }
}
