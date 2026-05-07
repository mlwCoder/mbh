class LoginResponse {
  const LoginResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.userId,
  });

  final String accessToken;
  final String refreshToken;
  final String userId;

  factory LoginResponse.fromJson(Object? json) {
    final Map<String, dynamic> map = json as Map<String, dynamic>;
    return LoginResponse(
      accessToken: map['accessToken'] as String? ?? '',
      refreshToken: map['refreshToken'] as String? ?? '',
      userId: map['userId'] as String? ?? '',
    );
  }
}
