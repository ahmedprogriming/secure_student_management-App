import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_student_management/core/widegt/custom_button.dart';
import 'package:secure_student_management/core/widegt/custom_showscanr.dart';
import 'package:secure_student_management/core/widegt/custom_text_field.dart';
import 'package:secure_student_management/cubit/cubit_add_Student/cubit/add_student_cubit.dart';
import 'package:secure_student_management/features/students/models/add_student_request.dart';

class AddStudentPage extends StatefulWidget {
  static const String id = 'AddStudentPage';
  const AddStudentPage({super.key});

  @override
  State<AddStudentPage> createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _studentNumberCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();

  DateTime? _selectedDob;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _studentNumberCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1970),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _selectedDob = picked);
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDob == null) {
      showSnackbar(
        context,
        'Please select Date of Birth',
        type: SnackBarType.info,
      );

      return;
    }

    final request = AddStudentRequest(
      email: _emailCtrl.text.trim(),
      password: _passwordCtrl.text.trim(),
      firstName: _firstNameCtrl.text.trim(),
      lastName: _lastNameCtrl.text.trim(),
      studentNumber: _studentNumberCtrl.text.trim(),
      dateOfBirth: _selectedDob!,
      phone: _phoneCtrl.text.trim(),
      address: _addressCtrl.text.trim(),
    );

    context.read<AddStudentCubit>().addStudent(request);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Student')),
      body: BlocConsumer<AddStudentCubit, AddStudentState>(
        listener: (context, state) {
          if (state is AddStudentSuccess) {
            showSnackbar(context, state.message, type: SnackBarType.success);

            Navigator.pop(context, true);
          } else if (state is AddStudentFailure) {
            showSnackbar(context, state.message, type: SnackBarType.error);
          }
        },
        builder: (context, state) {
          final isLoading = state is AddStudentLoading;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextFiled(
                    controller: _firstNameCtrl,
                    hint: 'First Name',
                    prefixIcon: Icons.person_outline,
                  ),
                  const SizedBox(height: 12),
                  CustomTextFiled(
                    controller: _lastNameCtrl,
                    hint: 'Last Name',
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
                    hint: 'Temporary Password',
                    prefixIcon: Icons.lock_outline,
                    obsecureText: true,
                  ),
                  const SizedBox(height: 12),
                  CustomTextFiled(
                    controller: _studentNumberCtrl,
                    hint: 'Student Number (e.g. STD-1001)',
                    prefixIcon: Icons.badge_outlined,
                  ),
                  const SizedBox(height: 12),
                  CustomTextFiled(
                    controller: _phoneCtrl,
                    hint: 'Phone Number',
                    prefixIcon: Icons.phone_outlined,
                  ),
                  const SizedBox(height: 12),
                  CustomTextFiled(
                    controller: _addressCtrl,
                    hint: 'Address',
                    prefixIcon: Icons.location_on_outlined,
                  ),
                  const SizedBox(height: 16),

               // حقل اختيار تاريخ الميلاد
                  InkWell(
                    onTap: _pickDate,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today_outlined, color: Colors.grey),
                          const SizedBox(width: 12),
                          Text(
                            _selectedDob == null
                                ? 'Select Date of Birth'
                                : _selectedDob!.toString().split(' ')[0],
                            style: TextStyle(
                              color: _selectedDob == null ? Colors.grey : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  CustomButton(
                    namebutton: isLoading ? 'Adding Student...' : 'Add Student',
                    onTap: isLoading ? null : _submit,
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
