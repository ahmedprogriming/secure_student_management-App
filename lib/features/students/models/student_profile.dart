class StudentProfile {
  final int id;
  final int userId;
  final DateTime dateOfBirh;
  final String address;
  final String studentNumber;
  final String phone;

  StudentProfile({
    required this.id,
    required this.userId,
    required this.dateOfBirh,
    required this.address,
    required this.studentNumber,
    required this.phone,
  });

  factory StudentProfile.fromJson(Map<String, dynamic> json) {
    return StudentProfile(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? '',
     dateOfBirh: json['dateOfBirh'] != null 
          ? DateTime.parse(json['dateOfBirh']) 
          : DateTime.now(),
      address: json['address'] ?? '',
      studentNumber: json['studentNumber'] ?? '',
      phone: json['phone'] ?? '',
    );
  }
}