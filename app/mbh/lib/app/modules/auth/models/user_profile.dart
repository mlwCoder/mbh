class UserProfile {
  const UserProfile({
    required this.id,
    required this.name,
    this.avatar,
    this.email,
    this.phone,
  });

  final String id;
  final String name;
  final String? avatar;
  final String? email;
  final String? phone;

  factory UserProfile.fromJson(Object? json) {
    final Map<String, dynamic> map = json as Map<String, dynamic>;
    return UserProfile(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      avatar: map['avatar'] as String?,
      email: map['email'] as String?,
      phone: map['phone'] as String?,
    );
  }
}
