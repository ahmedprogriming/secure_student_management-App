import 'package:flutter/material.dart';
import 'package:secure_student_management/core/network/api_client.dart';
import 'package:secure_student_management/core/storage/secure_storage_service.dart';
import 'package:secure_student_management/main.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  @override
  
  final ApiClient apiClient = ApiClient();
  List<dynamic> students = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchStudents();
  }

  Future<void> _fetchStudents() async {
    try {
      // الـ Interceptor سيضيف الـ Token لهذا الطلب تلقائياً!
      final response = await apiClient.get('/api/Students/All');
      setState(() {
        students = response.data; // نفترض أن الـ API يرجع قائمة بالطلاب
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'حدث خطأ أثناء جلب البيانات: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    final secureStorage = SecureStorageService();
    await secureStorage.deleteToken(); // حذف البيانات السرية

    if (mounted) {
      // العودة إلى شاشة تسجيل الدخول
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginTestScreen()),
      );
    }
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('قائمة الطلاب'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout, // استدعاء دالة تسجيل الخروج
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage.isNotEmpty) {
      return Center(
        child: Text(
          errorMessage,
          style: const TextStyle(color: Colors.red, fontSize: 16),
        ),
      );
    }

    if (students.isEmpty) {
      return const Center(child: Text('لا يوجد طلاب حالياً'));
    }

    return ListView.builder(
      itemCount: students.length,
      itemBuilder: (context, index) {
        final student = students[index];
        // ⚠️ مهم: تأكد أن أسماء الحقول 'name' و 'email' تطابق ما يرجعه الـ API الخاص بك
        return ListTile(
          leading: const CircleAvatar(child: Icon(Icons.person)),
          // استخدام رقم الطالب كعنوان رئيسي
          title: Text(student['studentNumber'] ?? 'بدون رقم'), 
          // عرض العنوان ورقم الهاتف في العنوان الفرعي
          subtitle: Text('${student['address'] ?? 'بدون عنوان'} - ${student['phone'] ?? 'بدون هاتف'}'),
          
        );
      },
    );
  }
}