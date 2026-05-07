class ApiResponse<T> {
  const ApiResponse({
    required this.code,
    required this.message,
    this.data,
    this.success = false,
  });

  final int code;
  final String message;
  final T? data;
  final bool success;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    return ApiResponse<T>(
      code: json['code'] as int? ?? -1,
      message: json['message'] as String? ?? '',
      data: json['data'] == null ? null : fromJsonT(json['data']),
      success: json['success'] as bool? ?? (json['code'] as int? ?? -1) == 0,
    );
  }
}
