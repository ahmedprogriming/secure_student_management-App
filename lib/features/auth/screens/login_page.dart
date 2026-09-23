import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_student_management/core/network/api_client.dart';
import 'package:secure_student_management/core/theme/app_colors.dart';
import 'package:secure_student_management/core/widegt/custom_button.dart';
import 'package:secure_student_management/core/widegt/custom_showscanr.dart';
import 'package:secure_student_management/core/widegt/custom_text_field.dart';
import 'package:secure_student_management/cubit/cubit/login_page_cubit.dart';
import 'package:secure_student_management/features/auth/screens/start_page.dart';

class LoginPage extends StatefulWidget {
  static const String id = 'LoginPage';

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? email;
  String? password;
 

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ApiClient apiClient = ApiClient();

  @override
  void initState() {
    super.initState();
   
  }


  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginPageCubit, LoginPageState>(
      listener: (context, state) async {
        if (state is LoginPageSuccess) {
  
            showSnackbar(context, 'Login successful', type: SnackBarType.success);
                  Navigator.of(context).pushNamed(SplashScreen.id);
        } else if (state is LoginPageFailure) {
          showSnackbar(context, state.errorMessage, type: SnackBarType.error);
        }
      },
      builder: (context, state) {
       
        final bool isLoading = state is LodingPageLoading;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // شعار العيادة داخل دائرة بتأثير ناعم
                          Center(
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
                          const SizedBox(height: 24),

                          // العناوين
                          const Text(
                            "Hello, Welcome Back",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff211A16),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Login to your account",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 32),

                          // حاوية الحقول
                          Container(
                            padding: const EdgeInsets.all(22),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                CustomTextFiled(
                                  hint: ' Email',
                                  controller: emailController,
                                  
                                   prefixIcon: Icons.email_outlined,
                                  onChange: (data) => email = data,
                                ),
                                const SizedBox(height: 16),
                                CustomTextFiled(
                                  showPasswordIcon: true,
                                  controller: passwordController,
                                
                                  obsecureText: true,
                                  hint: ' Password',
                                  prefixIcon: Icons.lock_outline_rounded,
                                  onChange: (data) => password = data,
                                ),
                                const SizedBox(height: 14),

                     
                                // زر الدخول
                                CustomButton(
                                  namebutton: isLoading
                                      ? '...جاري التحقق'
                                      : 'تسجيل الدخول',
                                  buttonColor: AppColors.primary,
                                  onTap: isLoading
                                      ? null
                                      : () {
                                          if (formKey.currentState!
                                              .validate()) {
                                            BlocProvider.of<LoginPageCubit>(
                                              context,
                                            ).login(
                                              emailController.text.trim(),
                                              passwordController.text.trim(),
                                            );

                                          }

                                
                                        },
                                ),
                              ],
                            ),
                          ),
                         
                       
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}