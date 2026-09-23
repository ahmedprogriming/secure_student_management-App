import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_student_management/core/widegt/student_list.dart';
import 'package:secure_student_management/cubit/cubit_auth/auth_cubit_cubit.dart';
import 'package:secure_student_management/cubit/student_list_cubit/cubit/student_list_cubit.dart';
import 'package:secure_student_management/features/students/screens/add_student_page.dart';


class TeacherPage extends StatefulWidget {
  const TeacherPage({super.key});
  static const String id = 'TeacherPage';

  @override
  State<TeacherPage> createState() => _TeacherPageState();

  
}

class _TeacherPageState extends State<TeacherPage> {
  @override
  void initState() {
    super.initState();
    // جلب القائمة فور فتح الشاشة
    context.read<StudentListCubit>().fetchAllStudent();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Teacher'),
        centerTitle: true,
       
      ),
      body:StudentList(),
      floatingActionButton: FloatingActionButton(
  onPressed: () async {
    final result = await Navigator.pushNamed(context, AddStudentPage.id);
    if (result == true) {
      // إعادة تحميل القائمة تلقائياً بعد الإضافة الناجحة
      context.read<StudentListCubit>().fetchAllStudent();
    }
  },
  child: const Icon(Icons.add),
),
    );
  }
}