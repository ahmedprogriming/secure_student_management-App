import 'package:flutter/material.dart';
import 'package:secure_student_management/core/storage/secure_storage_service.dart';
import 'package:secure_student_management/features/students/screens/students_screen.dart';

import 'core/network/api_client.dart';
import 'features/auth/models/login_request.dart';
import 'features/auth/services/auth_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoginTestScreen(),
    );
  }
}

class LoginTestScreen extends StatefulWidget {
  const LoginTestScreen({super.key});

  @override
  State<LoginTestScreen> createState() => _LoginTestScreenState();
}

class _LoginTestScreenState extends State<LoginTestScreen> {
  String result = 'اضغط Login';

  Future<void> login() async {
    final apiClient = ApiClient();
    final SecureToken =  SecureStorageService();
    final authService = AuthService(apiClient, SecureToken);

    final request = LoginRequest(
      email: 'ahmed@gmail.com',
      password: 'password1',
    );

    try {
      final response = await authService.login(request);

      setState(() {
        if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const StudentsScreen()),
        );
        }
      });
    } catch (e) {
      setState(() {
        result = 'Login Error ❌\n$e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Test'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: login,
              child: const Text('Login'),
            ),
            const SizedBox(height: 20),
            Text(result),
          ],
        ),
      ),
    );
  }
}