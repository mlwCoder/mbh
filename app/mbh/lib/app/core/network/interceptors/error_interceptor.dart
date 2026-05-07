import 'package:dio/dio.dart';
import 'package:mbh/app/core/errors/error_handler.dart';
import 'package:mbh/app/core/errors/failure.dart';
import 'package:mbh/app/core/logging/app_logger.dart';

class ErrorInterceptor extends Interceptor {
  ErrorInterceptor(this._logger);

  final AppLogger _logger;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final Failure failure = ErrorHandler.handle(err, err.stackTrace);
    _logger.error(
      'HTTP error [${failure.code.name}] ${err.requestOptions.method} ${err.requestOptions.uri}: ${failure.message}',
    );
    handler.next(err);
  }
}
