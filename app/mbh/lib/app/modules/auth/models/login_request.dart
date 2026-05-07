class LoginRequest {
  const LoginRequest({
    required this.account,
    required this.password,
  });

  final String account;
  final String password;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'account': account,
      'password': password,
    };
  }
}
