import 'package:dio/dio.dart';
import 'package:mbh/app/core/errors/app_exception.dart';
import 'package:mbh/app/core/errors/error_codes.dart';

class ErrorMapper {
  const ErrorMapper._();

  static AppException map(Object error, [StackTrace? stackTrace]) {
    if (error is AppException) {
      return error;
    }

    if (error is DioException) {
      return _mapDio(error, stackTrace);
    }

    return AppException(
      code: ErrorCode.unknown,
      message: 'Unexpected error occurred.',
      originalError: error,
      stackTrace: stackTrace,
    );
  }

  static AppException _mapDio(DioException error, StackTrace? stackTrace) {
    final int? statusCode = error.response?.statusCode;

    return switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.sendTimeout => AppException(
        code: ErrorCode.timeout,
        message: 'Request timeout.',
        statusCode: statusCode,
        originalError: error,
        stackTrace: stackTrace,
      ),
      DioExceptionType.cancel => AppException(
        code: ErrorCode.cancelled,
        message: 'Request was cancelled.',
        statusCode: statusCode,
        originalError: error,
        stackTrace: stackTrace,
      ),
      DioExceptionType.badResponse => AppException(
        code: _statusToCode(statusCode),
        message: _statusToMessage(statusCode),
        statusCode: statusCode,
        originalError: error,
        stackTrace: stackTrace,
      ),
      DioExceptionType.connectionError => AppException(
        code: ErrorCode.network,
        message: 'Network connection error.',
        statusCode: statusCode,
        originalError: error,
        stackTrace: stackTrace,
      ),
      _ => AppException(
        code: ErrorCode.unknown,
        message: 'Unhandled network exception.',
        statusCode: statusCode,
        originalError: error,
        stackTrace: stackTrace,
      ),
    };
  }

  static ErrorCode _statusToCode(int? statusCode) {
    return switch (statusCode) {
      400 => ErrorCode.validation,
      401 => ErrorCode.unauthorized,
      403 => ErrorCode.forbidden,
      404 => ErrorCode.notFound,
      500 || 502 || 503 || 504 => ErrorCode.server,
      _ => ErrorCode.unknown,
    };
  }

  static String _statusToMessage(int? statusCode) {
    return switch (statusCode) {
      400 => 'Validation error.',
      401 => 'Unauthorized request.',
      403 => 'Forbidden request.',
      404 => 'Resource not found.',
      500 || 502 || 503 || 504 => 'Server error.',
      _ => 'Request failed.',
    };
  }
}
