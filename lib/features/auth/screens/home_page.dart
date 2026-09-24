import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_student_management/core/theme/app_colors.dart';
import 'package:secure_student_management/core/widegt/cutom_card.dart';
import 'package:secure_student_management/cubit/cubit_auth/auth_cubit_cubit.dart';
import 'package:secure_student_management/features/auth/screens/login_page.dart';
import 'package:secure_student_management/features/users/screens/admin_page.dart';
import 'package:secure_student_management/features/users/screens/student_page.dart';
import 'package:secure_student_management/features/users/screens/teacher_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  static const String id = 'HomePag';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Logout',
            onPressed: () {
              context.read<AuthCubit>().logout();
            },
          ),
        ],
      ),
      body: BlocConsumer<AuthCubit, AuthCubitState>(
        listener: (context, state) {
          if (state is AuthUnauthenticated) {
            // حذف سجل التصفح بالكامل والرجوع لصفحة الدخول لمنع العودة بزر الرجوع
            Navigator.pushNamedAndRemoveUntil(
              context,
              LoginPage.id,
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          String userRole = state.role;

          bool isAdmin = userRole == 'Admin';
          bool isTeacher = userRole == 'Teacher';
          bool isStudent = userRole == 'Student';

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // بطاقة الترحيب العلوية
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryDark],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.25),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        child: const Icon(
                          Icons.school_rounded,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Welcome back,',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              userRole.isNotEmpty ? userRole : 'User',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                const Text(
                  'Quick Access',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),

                // بطاقات التنقل بحسب الصلاحيات
                if (isAdmin || isTeacher || isStudent) ...[
                  CustomCard(
                    title: 'Student Profile',
                    subtitle: 'View and manage student profile details',
                    icon: Icons.person_outline_rounded,
                    onTap: () {
                      Navigator.pushNamed(context, StudentPage.id);
                    },
                  ),
                  const SizedBox(height: 12),
                ],

                if (isAdmin || isTeacher) ...[
                  CustomCard(
                    title: 'Teacher Portal',
                    subtitle: 'Manage classes, student grades, and records',
                    icon: Icons.menu_book_rounded,
                    onTap: () {
                      Navigator.pushNamed(context, TeacherPage.id);
                    },
                  ),
                  const SizedBox(height: 12),
                ],

                if (isAdmin) ...[
                  CustomCard(
                    title: 'Admin Control Center',
                    subtitle: 'System management, users, and audit logs',
                    icon: Icons.admin_panel_settings_outlined,
                    onTap: () {
                      Navigator.pushNamed(context,  AdminDashbordPage.id);
                    },
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}