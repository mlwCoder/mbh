import 'dart:async';

import 'package:dio/dio.dart';
import 'package:mbh/app/core/constants/api_constants.dart';
import 'package:mbh/app/core/storage/secure/secure_storage_service.dart';

class TokenRefreshInterceptor extends Interceptor {
  TokenRefreshInterceptor({
    required Dio refreshClient,
    required SecureStorageService secureStorageService,
  })  : _refreshClient = refreshClient,
        _secureStorageService = secureStorageService;

  final Dio _refreshClient;
  final SecureStorageService _secureStorageService;

  Future<void>? _refreshing;

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (!_shouldRefresh(err.requestOptions, err.response?.statusCode)) {
      handler.next(err);
      return;
    }

    _refreshing ??= _refreshToken();

    try {
      await _refreshing;
      final String? newAccessToken = await _secureStorageService.readAccessToken();
      final RequestOptions requestOptions = err.requestOptions;
      requestOptions.headers[ApiConstants.authorization] =
          '${ApiConstants.bearerPrefix} $newAccessToken';
      final Response<dynamic> response = await _refreshClient.fetch<dynamic>(requestOptions);
      handler.resolve(response);
    } catch (_) {
      handler.next(err);
    } finally {
      _refreshing = null;
    }
  }

  bool _shouldRefresh(RequestOptions options, int? statusCode) {
    return statusCode == 401 && !options.path.contains(ApiConstants.refreshTokenPath);
  }

  Future<void> _refreshToken() async {
    final String? refreshToken = await _secureStorageService.readRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      throw StateError('Refresh token is missing.');
    }

    final Response<dynamic> response = await _refreshClient.post<dynamic>(
      ApiConstants.refreshTokenPath,
      data: <String, dynamic>{
        'refreshToken': refreshToken,
      },
      options: Options(
        headers: <String, String>{
          ApiConstants.authorization: '${ApiConstants.bearerPrefix} $refreshToken',
        },
      ),
    );

    final Map<String, dynamic> payload =
        Map<String, dynamic>.from(response.data as Map<dynamic, dynamic>);
    final String? newAccessToken = payload['accessToken'] as String?;
    final String? newRefreshToken = payload['refreshToken'] as String?;

    if (newAccessToken == null || newAccessToken.isEmpty) {
      throw StateError('Access token refresh failed.');
    }

    await _secureStorageService.writeAccessToken(newAccessToken);
    if (newRefreshToken != null && newRefreshToken.isNotEmpty) {
      await _secureStorageService.writeRefreshToken(newRefreshToken);
    }
  }
}
