import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widegt/custom_button.dart';
import '../../../core/widegt/custom_text_field.dart';
import '../../../cubit/cubit/login_page_cubit.dart';
import '../../../cubit/cubit_auth/auth_cubit_cubit.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  static const String id = 'LoginPage';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _onLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<LoginPageCubit>().login(
            _emailCtrl.text.trim(),
            _passwordCtrl.text.trim(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocConsumer<LoginPageCubit, LoginPageState>(
        listener: (context, state) {
          if (state is LoginPageSuccess) {
            context.read<AuthCubit>().checkAuthStatus();
            Navigator.pushReplacementNamed(context, HomePage.id);
          } else if (state is LoginPageFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is LodingPageLoading;

          return SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // عرض الشعار المتناسق مع الحاوية
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.35),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Image.asset(
                          'lib/assets/icons/log.png',
                          width: 72,
                          height: 72,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Secure Student Portal',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Sign in to access your academic dashboard',
                        style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 36),

                      CustomTextFiled(
                        controller: _emailCtrl,
                        hint: 'Email Address',
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: (val) => val == null || val.isEmpty ? 'Email is required' : null,
                      ),
                      const SizedBox(height: 16),

                      CustomTextFiled(
                        controller: _passwordCtrl,
                        hint: 'Password',
                        prefixIcon: Icons.lock_outline,
                        obsecureText: true,
                        validator: (val) => val == null || val.isEmpty ? 'Password is required' : null,
                      ),
                      const SizedBox(height: 28),

                      CustomButton(
                        namebutton: 'Sign In',
                        isLoading: isLoading,
                        onTap: _onLogin,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}