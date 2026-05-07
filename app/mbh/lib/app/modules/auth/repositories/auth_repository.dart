import 'package:get/get.dart';
import 'package:mbh/app/core/base/base_repository.dart';
import 'package:mbh/app/core/base/result.dart';
import 'package:mbh/app/core/errors/error_handler.dart';
import 'package:mbh/app/core/network/network_service.dart';
import 'package:mbh/app/modules/auth/models/login_request.dart';
import 'package:mbh/app/modules/auth/models/login_response.dart';
import 'package:mbh/app/modules/auth/models/user_profile.dart';

class AuthRepository extends BaseRepository {
  AuthRepository() : _networkService = Get.find<NetworkService>();

  final NetworkService _networkService;

  Future<Result<LoginResponse>> login(LoginRequest request) async {
    try {
      final response = await _networkService.apiClient.post<LoginResponse>(
        '/auth/login',
        data: request.toJson(),
        fromJsonT: LoginResponse.fromJson,
      );

      if (response.success && response.data != null) {
        return Success<LoginResponse>(response.data!);
      }

      return FailureResult<LoginResponse>(
        ErrorHandler.handle(Exception(response.message)),
      );
    } catch (e, s) {
      return FailureResult<LoginResponse>(ErrorHandler.handle(e, s));
    }
  }

  Future<Result<UserProfile>> fetchProfile() async {
    try {
      final response = await _networkService.apiClient.get<UserProfile>(
        '/user/profile',
        fromJsonT: UserProfile.fromJson,
      );

      if (response.success && response.data != null) {
        return Success<UserProfile>(response.data!);
      }

      return FailureResult<UserProfile>(
        ErrorHandler.handle(Exception(response.message)),
      );
    } catch (e, s) {
      return FailureResult<UserProfile>(ErrorHandler.handle(e, s));
    }
  }
}
