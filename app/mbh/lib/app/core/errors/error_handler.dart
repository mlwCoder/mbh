import 'package:mbh/app/core/errors/error_mapper.dart';
import 'package:mbh/app/core/errors/failure.dart';

class ErrorHandler {
  const ErrorHandler._();

  static Failure handle(Object error, [StackTrace? stackTrace]) {
    final exception = ErrorMapper.map(error, stackTrace);
    return Failure(
      code: exception.code,
      message: exception.message,
      originalError: exception.originalError ?? error,
      stackTrace: exception.stackTrace ?? stackTrace,
    );
  }
}
