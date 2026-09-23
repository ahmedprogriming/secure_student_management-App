import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_student_management/core/widegt/custom_text_field.dart';
import 'package:secure_student_management/cubit/cubit_auth/auth_cubit_cubit.dart';
import 'package:secure_student_management/cubit/cubit_student/cubit/profile_cupit_cubit.dart';


class StudentProfilePage extends StatefulWidget {
  const StudentProfilePage({super.key});
  static const String id = 'StudentProfilePage';                                  
  @override
  State<StudentProfilePage> createState() => _StudentProfilePageState();
}

class _StudentProfilePageState extends State<StudentProfilePage> {
 

  final studentId = TextEditingController();
 
  @override
  void initState() {
    super.initState();
 // جلب البيانات فور فتح الشاشة
 //   context.read<ProfileCubit>().fetchMyProfile();
  }
  @override
  void dispose() {
    studentId.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Profile'),
       
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          String userRole = context.read<AuthCubit>().state.role;

          bool isAdmin=userRole == 'Admin';
          bool isTeacher=userRole=='Teacher';
          if (state is ProfileLoading) {
            if(isAdmin || isTeacher)
            {
              return  Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Text('Enter ID with Student',style: TextStyle(fontSize: 13),),
                  CustomTextFiled(
                    controller: studentId,
                  ),
                   
                ],

              );
              
            }
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message, style: const TextStyle(color: Colors.red)),
                  ElevatedButton(
                    onPressed: () => context.read<ProfileCubit>().fetchMyProfile(),
                    child: const Text('Retry'),
                  )
                ],
              ),
            );
          } else if (state is ProfileSuccess) {
            final profile = state.profile;
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ListTile(
                  leading: const Icon(Icons.person),
                  title: Text('${profile.id}'),
                  subtitle: const Text(' ID'),
                ),
                ListTile(
                  leading: const Icon(Icons.numbers),
                  title: Text(profile.userId.toString()),
                  subtitle: const Text('User Number'),
                ),
                ListTile(
                  leading: const Icon(Icons.badge),
                  title: Text(profile.studentNumber),
                  subtitle: const Text('Student Number'),
                ),
                 ListTile(
                  leading: const Icon(Icons.school),
                  title: Text('${profile.dateOfBirh}'),
                  subtitle: const Text('Date of Birth'),
                ),
                 ListTile(
                  leading: const Icon(Icons.location_city),
                  title: Text(profile.address),
                  subtitle: const Text('Address'),
                ),
               
                 ListTile(
                  leading: const Icon(Icons.phone),
                  title: Text(profile.phone),
                  subtitle: const Text('Phone Number'),
                ),
               
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
  }
