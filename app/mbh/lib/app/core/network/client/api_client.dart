import 'package:dio/dio.dart';
import 'package:mbh/app/core/network/models/api_response.dart';
import 'package:mbh/app/core/network/parser/response_parser.dart';

class ApiClient {
  ApiClient(this._dio);

  final Dio _dio;

  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    required T Function(Object? json) fromJsonT,
  }) async {
    final Response<dynamic> response = await _dio.get<dynamic>(
      path,
      queryParameters: queryParameters,
    );
    return ResponseParser.parse(response, fromJsonT);
  }

  Future<ApiResponse<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    required T Function(Object? json) fromJsonT,
  }) async {
    final Response<dynamic> response = await _dio.post<dynamic>(
      path,
      data: data,
      queryParameters: queryParameters,
    );
    return ResponseParser.parse(response, fromJsonT);
  }

  Future<ApiResponse<T>> put<T>(
    String path, {
    dynamic data,
    required T Function(Object? json) fromJsonT,
  }) async {
    final Response<dynamic> response = await _dio.put<dynamic>(
      path,
      data: data,
    );
    return ResponseParser.parse(response, fromJsonT);
  }

  Future<ApiResponse<T>> delete<T>(
    String path, {
    dynamic data,
    required T Function(Object? json) fromJsonT,
  }) async {
    final Response<dynamic> response = await _dio.delete<dynamic>(
      path,
      data: data,
    );
    return ResponseParser.parse(response, fromJsonT);
  }

  Dio get raw => _dio;
}
