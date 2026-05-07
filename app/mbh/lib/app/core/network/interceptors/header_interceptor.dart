import 'package:dio/dio.dart';

class HeaderInterceptor extends Interceptor {
  HeaderInterceptor({required this.defaultHeaders});

  final Map<String, String> defaultHeaders;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers.addAll(defaultHeaders);
    handler.next(options);
  }
}
