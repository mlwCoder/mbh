import 'package:dio/dio.dart';
import 'package:mbh/app/core/network/models/api_response.dart';

class ResponseParser {
  const ResponseParser._();

  static ApiResponse<T> parse<T>(
    Response<dynamic> response,
    T Function(Object? json) fromJsonT,
  ) {
    final dynamic payload = response.data;
    if (payload is! Map<String, dynamic>) {
      return ApiResponse<T>(
        code: response.statusCode ?? -1,
        message: 'Invalid response payload.',
        success: false,
      );
    }

    return ApiResponse<T>.fromJson(payload, fromJsonT);
  }
}
