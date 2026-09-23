import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_student_management/core/widegt/custom_showscanr.dart';
import 'package:secure_student_management/cubit/cubit_usrs/cubit/all_users_cubit.dart';
import '../../../core/widegt/custom_button.dart';
import '../../../core/widegt/custom_text_field.dart';
import '../models/add_user_request.dart';

class AddUserPage extends StatefulWidget {
  static const String id = 'AddUserPage';
  const AddUserPage({super.key});

  @override
  State<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  String _selectedRole = 'Student';
  bool _isActive = true;
  bool _isLoading = false;

  final List<String> _roles = ['Admin', 'Teacher', 'Student'];

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final request = AddUserRequest(
      firstName: _firstNameCtrl.text.trim(),
      lastName: _lastNameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      password: _passwordCtrl.text.trim(),
      role: _selectedRole,
      isActive: _isActive,
    );

    final success = await context.read<AllUsersCubit>().addNewUser(request);

    setState(() => _isLoading = false);

    if (mounted) {
     
      if (success) {
      showSnackbar(context, 'User added Succssfully!',type: SnackBarType.success);
        Navigator.pop(context, true);
      } else {
          showSnackbar(context, 'Feild to add new user.',type: SnackBarType.error);
       
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New User')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextFiled(
                controller: _firstNameCtrl,
                hint: 'First name',
                prefixIcon: Icons.person_outline,
               
              ),
              const SizedBox(height: 12),
              CustomTextFiled(
                controller: _lastNameCtrl,
                hint: 'Last name',
                prefixIcon: Icons.person_outline,
              ),
              const SizedBox(height: 12),
              CustomTextFiled(
                controller: _emailCtrl,
                hint: 'Email',
                prefixIcon: Icons.email_outlined,
              ),
              const SizedBox(height: 12),
              CustomTextFiled(
                controller: _passwordCtrl,
                hint: 'Password',
                prefixIcon: Icons.lock_outline,
                obsecureText: true,
              ),
              const SizedBox(height: 16),

              // اختيار الدور (Role)
              DropdownButtonFormField<String>(
                value: _selectedRole,
                decoration: InputDecoration(
                  labelText: 'Role',
                  prefixIcon: const Icon(Icons.shield_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: _roles.map((role) {
                  return DropdownMenuItem(value: role, child: Text(role));
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedRole = value);
                  }
                },
              ),
              const SizedBox(height: 12),

              // تفعيل الحساب
              SwitchListTile(
                title: const Text('The Accountant is Active'),
                value: _isActive,
                onChanged: (val) => setState(() => _isActive = val),
              ),
              const SizedBox(height: 24),

              CustomButton(
                namebutton: _isLoading ? 'Adding...' : 'Add User',
                onTap: _isLoading ? null : _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}