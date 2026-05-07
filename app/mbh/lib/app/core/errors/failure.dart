import 'package:mbh/app/core/errors/error_codes.dart';

class Failure {
  const Failure({
    required this.code,
    required this.message,
    this.originalError,
    this.stackTrace,
  });

  final ErrorCode code;
  final String message;
  final Object? originalError;
  final StackTrace? stackTrace;
}
