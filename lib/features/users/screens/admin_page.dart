import 'package:flutter/material.dart';
import 'package:secure_student_management/core/widegt/cutom_card.dart';
import 'package:secure_student_management/core/widegt/users_list.dart';

class AdminDashbordPage extends StatelessWidget {
  const AdminDashbordPage({super.key});
 static const String id = 'AdminDashbordPage';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
      
      ),
      body:  Center(
        child:Column(
          children: [
            SizedBox(height: 75,),
            Wrap(
                alignment: WrapAlignment.center,
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      CustomCard(text: 'Management Users',
                      onTap: ()
                      {
                        Navigator.pushNamed(context, AllUserPage.id);
                      },)
                    ],
            )
          ],
        )
      ),
    );
  }
}