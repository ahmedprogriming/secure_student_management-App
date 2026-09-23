import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_student_management/core/theme/app_colors.dart';
import 'package:secure_student_management/cubit/cubit_auth/auth_cubit_cubit.dart';
import 'package:secure_student_management/features/auth/screens/home_page.dart';
import 'package:secure_student_management/features/auth/screens/login_page.dart';
import 'package:secure_student_management/features/students/screens/student_profile_page.dart';
import 'package:secure_student_management/features/users/screens/admin_page.dart';
import 'package:secure_student_management/features/users/screens/student_page.dart';
import 'package:secure_student_management/features/users/screens/teacher_page.dart';
// استدعِ AuthCubit و شاشتي Login و Students هنا

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
 static const String id = 'SplashScreen';
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // نطلب من الـ Cubit فحص حالة الدخول فور فتح الشاشة
    context.read<AuthCubit>().checkAuthStatus();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthCubitState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
         Navigator.of(context).pushNamed(
            HomePage.id,
          );
        } else if (state is AuthUnauthenticated) {
          // إذا لم يكن مسجل الدخول، اذهب لشاشة تسجيل الدخول
          Navigator.of(context).pushNamed(
            LoginPage.id,
          );
        }
      },
      child:  Scaffold(
        body: Center(
          // يمكنك استبدال هذا بلوجو التطبيق الخاص بك
          child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(
                                  0xffFDF9F1,
                                ), // نفس لون خلفية الشعار بالضبط
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withValues(alpha: 0.15),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: Transform.scale(
                                  scale:
                                      1.6, // تكبير الشعار الداخلي لملء الفراغ المربع وقص الأطراف الزائدة
                                  child: Image.asset(
                                    'lib/assets/icons/log.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
        ),
      ),
    );
  }
}