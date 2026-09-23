import 'package:flutter/material.dart';
import 'package:secure_student_management/core/theme/app_colors.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({super.key, required this.text, this.onTap});
final String text;

final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
            
              height: 140,
              width: 165,
              
              decoration: BoxDecoration(
                
                boxShadow: [
                  BoxShadow(
                    blurRadius: 40,
                    color:AppColors.textSecondary.withValues(alpha: 0.2),
                    spreadRadius: 0,
                    offset: Offset(10,10),
                  ),
                ],
              ),
        
              child: Card(
                 color:AppColors.primary,
                elevation: 10,
        
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(text,
                                      
                        style: TextStyle(color: Colors.black87, fontSize: 20,fontWeight: FontWeight.bold),
                      ),
                 
                   
                    ],
                  ),
                ),
              ),
            ),
           
          ],
        ),
    );
  }
}