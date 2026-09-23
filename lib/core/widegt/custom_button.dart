
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.onTap,
    this.isLoading = false,
    required this.namebutton,
    this.buttonColor,
    this.borderColor,
    this.icon,

  });

  final void Function()? onTap;
  final bool isLoading;
  final String namebutton;
  final Color? buttonColor;
  final Color? borderColor;
  final Icon? icon;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 55,
        decoration: BoxDecoration(
          color: buttonColor ?? Color(0xffD6A857),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor ?? Color(0xffC49243), width: 1),
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(color: Colors.black),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                   spacing: 12,
                  children: [
                     (icon != null)? icon! : SizedBox.shrink(),
                    
                    Text(
                      namebutton,
                      style: TextStyle(
                        color: Color.fromARGB(255, 78, 56, 24),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}