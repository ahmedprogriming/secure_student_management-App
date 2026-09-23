class AddStudentRequest {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String studentNumber;
  final DateTime dateOfBirth;
  final String phone;
  final String address;

  AddStudentRequest({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.studentNumber,
    required this.dateOfBirth,
    required this.phone,
    required this.address,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'studentNumber': studentNumber,
      'dateOfBirth': dateOfBirth.toUtc().toIso8601String(),
      'phone': phone,
      'address': address,
    };
  }
}