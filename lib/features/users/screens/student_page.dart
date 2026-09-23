import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_student_management/core/widegt/student_profile.dart';
import 'package:secure_student_management/cubit/cubit_auth/auth_cubit_cubit.dart';

class StudentPage extends StatelessWidget {
 const StudentPage({super.key});
  static const String id = 'StudentPage';

  @override
  Widget build(BuildContext context) {
   String role= context.read<AuthCubit>().state.role;
    return StudentProfile(userRole: role);
  }
}