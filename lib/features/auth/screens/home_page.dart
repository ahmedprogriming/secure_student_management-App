import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      appBar: AppBar(title: const Text('Home Page',
      ),
      centerTitle: true,
     automaticallyImplyLeading: false,
      actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthCubit>().logout();
            },
          ),
        ],),
      
      body: BlocConsumer<AuthCubit, AuthCubitState>(
    
        listener: (context, state) {
         
          if (state is AuthUnauthenticated) {
            // Navigate to the login page when the user logs out
            Navigator.pushNamed(context, LoginPage.id);
          }
        },
        builder: (context, state) {
          String userRole = '';
          if(state is AuthAuthenticated)
          {
            userRole = state.role;
          }

          bool isAdmin = userRole == 'Admin';
          bool isTeacher = userRole == 'Teacher';
          bool isStudent = userRole == 'Student';
          return Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      'Welcome $userRole !',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  SizedBox(height: 75),
                  Wrap(
                   alignment: WrapAlignment.center,
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      if(isAdmin||isTeacher||isStudent)
                      CustomCard(
                        text: 'Student Profile',
                        onTap: () {
                          Navigator.pushNamed(context, StudentPage.id);
                        },
                      ),
                      if(isAdmin||isTeacher)
                      CustomCard(
                        text: 'Teacher Page',
                        onTap: () {
                          Navigator.pushNamed(context, TeacherPage.id);
                        },
                      ),
                      if(isAdmin)
                      CustomCard(
                        text: 'Admin Page',
                        onTap: () {
                          // Navigate to Admin Page
                          Navigator.pushNamed(
                            context,
                            AdminDashbordPage.id,
                          ); // Replace with your Admin Page route
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
