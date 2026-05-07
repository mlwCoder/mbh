import 'package:mbh/app/core/errors/error_codes.dart';

class AppException implements Exception {
  const AppException({
    required this.code,
    required this.message,
    this.statusCode,
    this.originalError,
    this.stackTrace,
  });

  final ErrorCode code;
  final String message;
  final int? statusCode;
  final Object? originalError;
  final StackTrace? stackTrace;

  @override
  String toString() {
    return 'AppException(code: $code, message: $message, statusCode: $statusCode)';
  }
}
