import 'package:dio/dio.dart';
import 'package:mbh/app/config/flavor/flavor_config.dart';
import 'package:mbh/app/core/constants/api_constants.dart';
import 'package:mbh/app/core/logging/app_logger.dart';
import 'package:mbh/app/core/network/interceptors/auth_interceptor.dart';
import 'package:mbh/app/core/network/interceptors/error_interceptor.dart';
import 'package:mbh/app/core/network/interceptors/header_interceptor.dart';
import 'package:mbh/app/core/network/interceptors/logging_interceptor.dart';
import 'package:mbh/app/core/network/interceptors/retry_interceptor.dart';
import 'package:mbh/app/core/network/interceptors/token_refresh_interceptor.dart';
import 'package:mbh/app/core/storage/secure/secure_storage_service.dart';

class DioFactory {
  DioFactory({
    required AppLogger logger,
    required SecureStorageService secureStorageService,
  })  : _logger = logger,
        _secureStorageService = secureStorageService;

  final AppLogger _logger;
  final SecureStorageService _secureStorageService;

  Dio create() {
    final BaseOptions options = BaseOptions(
      baseUrl: FlavorConfig.instance.baseUrl,
      connectTimeout: ApiConstants.connectTimeout,
      receiveTimeout: ApiConstants.receiveTimeout,
      sendTimeout: ApiConstants.sendTimeout,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    final Dio dio = Dio(options);
    final Dio refreshClient = Dio(options);

    dio.interceptors.addAll(<Interceptor>[
      HeaderInterceptor(defaultHeaders: <String, String>{}),
      AuthInterceptor(_secureStorageService),
      TokenRefreshInterceptor(
        refreshClient: refreshClient,
        secureStorageService: _secureStorageService,
      ),
      RetryInterceptor(dio: refreshClient),
      LoggingInterceptor(
        _logger,
        enabled: FlavorConfig.instance.enableLogging,
      ),
      ErrorInterceptor(_logger),
    ]);

    return dio;
  }
}
