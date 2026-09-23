import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_student_management/core/network/api_client.dart';
import 'package:secure_student_management/core/storage/secure_storage_service.dart';
import 'package:secure_student_management/core/theme/app_colors.dart';
import 'package:secure_student_management/cubit/audit_cubit/cubit/audit_log_cubit.dart';
import 'package:secure_student_management/features/auditing/screens/audit_logs_page.dart';
import 'package:secure_student_management/features/users/screens/add_user_page.dart';
import 'package:secure_student_management/features/users/screens/users_list_page.dart';
import 'package:secure_student_management/cubit/cubit/login_page_cubit.dart';
import 'package:secure_student_management/cubit/cubit_add_Student/cubit/add_student_cubit.dart';
import 'package:secure_student_management/cubit/cubit_auth/auth_cubit_cubit.dart';
import 'package:secure_student_management/cubit/cubit_student/cubit/profile_cupit_cubit.dart';
import 'package:secure_student_management/cubit/cubit_updateStudent/cubit/update_student_cubit.dart';
import 'package:secure_student_management/cubit/cubit_usrs/cubit/all_users_cubit.dart';
import 'package:secure_student_management/cubit/student_list_cubit/cubit/student_list_cubit.dart';
import 'package:secure_student_management/features/auth/screens/home_page.dart';
import 'package:secure_student_management/features/auth/screens/login_page.dart';
import 'package:secure_student_management/features/auth/screens/start_page.dart';
import 'package:secure_student_management/features/students/screens/add_student_page.dart';
import 'package:secure_student_management/features/students/screens/student_profile_page.dart';
import 'package:secure_student_management/features/users/screens/admin_page.dart';
import 'package:secure_student_management/features/users/screens/student_page.dart';
import 'package:secure_student_management/features/users/screens/teacher_page.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      
      providers: [
        BlocProvider<LoginPageCubit>(
          create: (context) => LoginPageCubit(),
        ),
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(SecureStorageService()),
        ),
        BlocProvider(
  create: (context) => ProfileCubit(
    apiClient:  ApiClient(), 
    secureStorage: SecureStorageService(), 
    // أو TokenStorage حسب اسم الكلاس لديك
  ),
),
 BlocProvider(
  create: (context) => StudentListCubit(
      ApiClient(), 
    
  ),
),
 BlocProvider(
  create: (context) => AddStudentCubit(
      ApiClient(), 
    
  ),
),
 BlocProvider(
  create: (context) => UpdateStudentCubit(
      ApiClient(), 
    
  ),
),
 BlocProvider(
  create: (context) => AllUsersCubit(
      ApiClient(), 
    
  ),
),
 BlocProvider(
  create: (context) => AuditLogsCubit(
      ApiClient(), 
    
  ),
),
      ],
      child: MaterialApp(
        title: 'Secure Student Management',
        debugShowCheckedModeBanner: false,
        routes: {
          LoginPage.id: (context) =>const LoginPage(),
          StudentProfilePage.id: (context) => const StudentProfilePage(),
          SplashScreen.id: (context) => const SplashScreen(),
          AdminDashbordPage.id: (context) => const AdminDashbordPage(),
          StudentPage.id: (context) => const StudentPage(),
          TeacherPage.id: (context) => const TeacherPage(),
          HomePage.id: (context) => const HomePage(),
          AddStudentPage.id:(context) => const AddStudentPage(),
          AllUserPage.id:(context) => const AllUserPage(),
          AddUserPage.id:(context) => const AddUserPage(),
          AuditLogsPage.id:(context) => const AuditLogsPage(),
        //  EditStudentPage.id:(context) => const EditStudentPage()
        },
        initialRoute: LoginPage.id,
        theme: ThemeData(primaryColor:AppColors.primary, scaffoldBackgroundColor: AppColors.background),
      ),
    );
  }
}