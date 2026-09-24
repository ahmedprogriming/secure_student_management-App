import 'package:flutter/material.dart';
import 'package:secure_student_management/core/theme/app_colors.dart';
import 'package:secure_student_management/core/widegt/cutom_card.dart';
import 'package:secure_student_management/features/auditing/screens/audit_logs_page.dart';
import 'package:secure_student_management/features/users/screens/users_list_page.dart';

class AdminDashbordPage extends StatelessWidget {
  const AdminDashbordPage({super.key});
  static const String id = 'AdminDashbordPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // بطاقة رأسية لتعريف القسم
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.25),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.security_outlined,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'System Administration',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Manage accounts and review security audit trail',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
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
              'Administration Tools',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),

            // إدارة المستخدمين
            CustomCard(
              title: 'Manage Users',
              subtitle: 'Add, edit, activate or deactivate system users',
              icon: Icons.manage_accounts_outlined,
              onTap: () {
                Navigator.pushNamed(context, AllUserPage.id);
              },
            ),

            const SizedBox(height: 14),

            // سجلات التدقيق والمراقبة
            CustomCard(
              title: 'Audit Logs & Security',
              subtitle: 'Inspect login events, actions, and system activity',
              icon: Icons.history_edu_outlined,
              onTap: () {
                Navigator.pushNamed(context, AuditLogsPage.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}