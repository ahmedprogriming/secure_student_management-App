class AddUserRequest {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String role;
  final bool isActive;

  AddUserRequest({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.role,
    this.isActive = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': 0,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'role': role,
      'isActive': isActive,
      'passwordHash': password, // تمرير كلمة المرور المشفرة أو العادية حسب تعامل الـ API مع الحقل
     'refreshTokenHash': 'NONE', 
    'refreshTokenExpiresAt': null,
    'refreshTokenRevokedAt': null,
    };
  }
}