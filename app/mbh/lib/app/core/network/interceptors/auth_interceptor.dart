import 'package:dio/dio.dart';
import 'package:mbh/app/core/constants/api_constants.dart';
import 'package:mbh/app/core/storage/secure/secure_storage_service.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._secureStorageService);

  final SecureStorageService _secureStorageService;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final String? token = await _secureStorageService.readAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers[ApiConstants.authorization] = '${ApiConstants.bearerPrefix} $token';
    }
    handler.next(options);
  }
}
