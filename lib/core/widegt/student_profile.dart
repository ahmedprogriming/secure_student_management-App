import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_student_management/core/widegt/custom_showscanr.dart';
import 'package:secure_student_management/core/widegt/custom_text_field.dart';
import 'package:secure_student_management/cubit/cubit_student/cubit/profile_cupit_cubit.dart';

class StudentProfile extends StatefulWidget {
  final String userRole; // تم التعديل إلى String

  const StudentProfile({super.key, required this.userRole});

  @override
  State<StudentProfile> createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
  final TextEditingController _studentIdController = TextEditingController();

  bool get isStudent => widget.userRole == 'Student';

  @override
  void initState() {
    super.initState();
    // جلب الملف الشخصي تلقائيًا فقط إذا كان المستخدم طالبًا
    if (isStudent) {
      context.read<ProfileCubit>().fetchMyProfile();
    }
  }

  @override
  void dispose() {
    _studentIdController.dispose();
    super.dispose();
  }

  void _searchStudent() {
    final query = _studentIdController.text.trim();
    if (query.isEmpty) return;

    final id = int.tryParse(query);
    if (id != null) {
      context.read<ProfileCubit>().fetchStudentById(id);
    } else {
      showSnackbar(context, 'Please enter a valid numeric ID', type: SnackBarType.error);
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isStudent ? 'My Profile' : 'Search Student Profile'),
      ),
      body: Column(
        children: [
          // شريط البحث يظهر فقط للمسؤول أو المعلم
          if (!isStudent)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: CustomTextFiled(
                      controller: _studentIdController,
                      hint: 'Enter Student ID',
                      prefixIcon: Icons.search,
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _searchStudent,
                    child: const Text('Search'),
                  ),
                ],
              ),
            ),

          // منطقة عرض النتائج والحالات
          Expanded(
            child: BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) {
                if (state is ProfileLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is ProfileFailure) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline, size: 50, color: Colors.red.shade400),
                          const SizedBox(height: 12),
                          Text(
                            state.message,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.red, fontSize: 16),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () {
                              if (isStudent) {
                                context.read<ProfileCubit>().fetchMyProfile();
                              } else {
                                _searchStudent();
                              }
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (state is ProfileSuccess) {
                  final profile = state.profile;
                  final formattedDate = profile.dateOfBirh.toString().split(' ')[0];

                  return ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      // بطاقة الهوية العلوية
                      Card(
                        elevation: 1.5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 32,
                                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                                child: Icon(
                                  Icons.person,
                                  size: 36,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Student #${profile.studentNumber}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'System ID: ${profile.id}  •  User ID: ${profile.userId}',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // قائمة تفاصيل الحساب
                      _buildInfoTile(
                        icon: Icons.calendar_today_outlined,
                        title: 'Date of Birth',
                        value: formattedDate,
                      ),
                      _buildInfoTile(
                        icon: Icons.phone_outlined,
                        title: 'Phone Number',
                        value: profile.phone.isNotEmpty ? profile.phone : 'Not provided',
                      ),
                      _buildInfoTile(
                        icon: Icons.location_on_outlined,
                        title: 'Address',
                        value: profile.address.isNotEmpty ? profile.address : 'Not provided',
                      ),
                    ],
                  );
                }

                // الحالة المبدئية عند عدم البحث بعد (للمعلم والمسؤول)
                return Center(
                  child: Text(
                    isStudent
                        ? 'Loading profile...'
                        : 'Enter a student ID to view details',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        leading: Icon(icon),
        title: Text(
          title,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}