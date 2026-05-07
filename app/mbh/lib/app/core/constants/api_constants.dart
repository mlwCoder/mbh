class ApiConstants {
  const ApiConstants._();

  static const Duration connectTimeout = Duration(seconds: 20);
  static const Duration receiveTimeout = Duration(seconds: 20);
  static const Duration sendTimeout = Duration(seconds: 20);

  static const String authorization = 'Authorization';
  static const String bearerPrefix = 'Bearer';
  static const String refreshTokenPath = '/auth/refresh';
  static const String traceId = 'X-Trace-Id';
}
