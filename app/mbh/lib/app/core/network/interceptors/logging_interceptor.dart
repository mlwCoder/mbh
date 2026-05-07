import 'package:dio/dio.dart';
import 'package:mbh/app/core/logging/app_logger.dart';

class LoggingInterceptor extends Interceptor {
  LoggingInterceptor(this._logger, {required this.enabled});

  final AppLogger _logger;
  final bool enabled;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (enabled) {
      _logger.debug('HTTP ${options.method} ${options.uri}');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    if (enabled) {
      _logger.debug(
        'HTTP ${response.requestOptions.method} ${response.requestOptions.uri} -> ${response.statusCode}',
      );
    }
    handler.next(response);
  }
}
