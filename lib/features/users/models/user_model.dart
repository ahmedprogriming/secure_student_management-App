class UserModel {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String role;
  final bool isActive;

  UserModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.isActive,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      role: json['role'] ?? '',
      isActive: json['isActive'] ?? false,
    );
  }

  String get fullName => '$firstName $lastName'.trim();
}