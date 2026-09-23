import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_student_management/core/theme/app_colors.dart';
import 'package:secure_student_management/core/widegt/custom_showscanr.dart';
import 'package:secure_student_management/cubit/cubit_auth/auth_cubit_cubit.dart';
import 'package:secure_student_management/cubit/cubit_updateStudent/cubit/update_student_cubit.dart';
import 'package:secure_student_management/cubit/student_list_cubit/cubit/student_list_cubit.dart';
import 'package:secure_student_management/features/students/screens/edit_student_page.dart';

class StudentList extends StatelessWidget {
  const StudentList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StudentListCubit, StudentListState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        if (state is StudentListLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is StudentListFailure) {
          return Center(
            child: Text(
              state.errorMessage,
              style: const TextStyle(color: Colors.red, fontSize: 16),
            ),
          );
        } else if (state is StudentListSuccess) {
          final students = state.students;
          return ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index];
              final studentOrder = index + 1; // حساب ترتيب الطالب
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 35,
                    backgroundColor: AppColors.textSecondary.withValues(
                      alpha: 0.18,
                    ),
                    child: Icon(
                      Icons.person,
                      color: AppColors.primary,
                      size: 35,
                    ),
                  ),
                  title: Text('$studentOrder'),
                  subtitle: Text(
                    'Student Number: ${student.studentNumber} - Address: ${student.address}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // زر التعديل: متاح للمعلم والمسؤول
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () async {
                          final refresh = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  EditStudentPage(student: student),
                            ),
                          );
                          if (refresh == true && context.mounted) {
                            context
                                .read<StudentListCubit>()
                                .fetchAllStudent();
                          }
                        },
                      ),

                      // زر الحذف: يظهر فقط إذا كان الدور Admin
                      if (context.read<AuthCubit>().state.role == 'Admin')
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _confirmDelete(context, student.id),
                        ),
                    ],
                  ),
                  onTap: () async {
                    final refresh = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditStudentPage(student: student),
                      ),
                    );
                    if (refresh == true && context.mounted) {
                      context.read<StudentListCubit>().fetchAllStudent();
                    }
                  },
                ),
              );
            },
          );
        }

        return const Center(child: Text('No data available'));
      },
    );
  }

  void _confirmDelete(BuildContext context, int studentId) {
  showDialog(
    context: context,
    builder: (dialogCtx) => AlertDialog(
      title: const Text('Delete Student'),
      content: const Text('Are you sure you want to delete this student?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogCtx),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            Navigator.pop(dialogCtx);
            final success = await context.read<UpdateStudentCubit>().deletedStudent(studentId);
            if (context.mounted) {
              if (success) {
              
                showSnackbar(context, 'Student deleted successfully',type: SnackBarType.success);
                context.read<StudentListCubit>().fetchAllStudent();
              } else {
                 showSnackbar(context, 'Failed to delete (403 Forbidden or Server Error)',type: SnackBarType.success);
              
                
              }
            }
          },
          child: const Text('Delete', style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}
}
