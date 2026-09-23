import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_student_management/core/widegt/custom_button.dart';
import 'package:secure_student_management/core/widegt/custom_showscanr.dart';
import 'package:secure_student_management/core/widegt/custom_text_field.dart';
import 'package:secure_student_management/cubit/cubit_updateStudent/cubit/update_student_cubit.dart';
import 'package:secure_student_management/features/students/models/student_profile.dart';

class EditStudentPage extends StatefulWidget {
  static const String id='EditStudentPage';
  final StudentProfile student;
  const EditStudentPage({super.key,required this.student});

  @override
  State<EditStudentPage> createState() => _EditStudentPageState();
}

class _EditStudentPageState extends State<EditStudentPage>{
  
late final TextEditingController _studentNumberCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _addressCtrl;
  late DateTime _selectedDob;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
   _studentNumberCtrl = TextEditingController(text: widget.student.studentNumber);
    _phoneCtrl = TextEditingController(text: widget.student.phone);
    _addressCtrl = TextEditingController(text: widget.student.address);
    _selectedDob = widget.student.dateOfBirh;
  }

  @override
  void dispose() {
    _studentNumberCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }
void _submitUpdate()  {
  
    final updated = StudentProfile(
      id: widget.student.id,
      userId: widget.student.userId,
      studentNumber: _studentNumberCtrl.text.trim(),
      dateOfBirh: _selectedDob,
      phone: _phoneCtrl.text.trim(),
      address: _addressCtrl.text.trim(),
    
    );

     context.read<UpdateStudentCubit>().updateStudent(
          widget.student.id,
          updated,
        );

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Student')),
      body: BlocConsumer<UpdateStudentCubit,UpdateStudentState>(
       listener: (context,state)
       {
        if(state is UpdateStudentSuccess)
        {
          showSnackbar(context, state.message,type: SnackBarType.success);
          Navigator.pop(context,true);
        }
        else if(state is UpdateStudentFailure)
        {
      showSnackbar(context, state.message,type: SnackBarType.success);
        }
       },
       builder: (context,state)
       {
        _isLoading=state is UpdateStudentLoading;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              CustomTextFiled(
              controller: _studentNumberCtrl,
              hint: 'Student Number',
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

            InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDob,
                  firstDate: DateTime(1970),
                  lastDate: DateTime.now(),
                );
                if (picked != null) {
                  setState(() => _selectedDob = picked);
                }
              },
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
                    Text(_selectedDob.toString().split(' ')[0]),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
            CustomButton(
              namebutton: _isLoading ? 'Updating...' : 'Save Changes',
              onTap: _isLoading ? null : _submitUpdate,
            ),
            ],
          ),
        );
       }
       ),
    );
  }
}