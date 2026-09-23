import 'package:flutter/material.dart';
import 'package:secure_student_management/core/theme/app_colors.dart';

class CustomTextFiled extends StatefulWidget {
  const CustomTextFiled({
    super.key,
    this.hint,
    this.maxLines = 1,
    this.onSave,
    this.initialValue,
    this.textdecoration,
    this.obsecureText = false,
    this.showPasswordIcon = false,
    this.width,
    this.height,
    this.hintColor,
    this.bordercolor,
    this.icon,
    this.prefixIcon, // دعم تمرير أيقونة البداية
    this.fillcolor,
    this.fontsizehint,
    this.readonly = false,
    this.onTap,
    this.controller,
    this.onChange,
  });

  final String? hint;
  final int? maxLines;
  final void Function(String?)? onSave;
  final String? initialValue;
  final TextDecoration? textdecoration;
  final bool obsecureText;
  final bool showPasswordIcon;
  final double? width;
  final double? height;
  final Color? hintColor;
  final Color? bordercolor;
  final IconData? icon;
  final IconData? prefixIcon;
  final Color? fillcolor;
  final double? fontsizehint;
  final bool readonly;
  final void Function()? onTap;
  final TextEditingController? controller;
  final Function(String)? onChange;

  @override
  State<CustomTextFiled> createState() => _CustomTextFiledState();
}

class _CustomTextFiledState extends State<CustomTextFiled> {
  late bool isObsecure;

  @override
  void initState() {
    super.initState();
    isObsecure = widget.obsecureText;
  }

  @override
  Widget build(BuildContext context) {
    // تحديد الأيقونة الأمامية (تقبل إما prefixIcon أو icon للتوافق مع الكود السابق)
    final IconData? leadingIcon = widget.prefixIcon ?? widget.icon;

    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: TextFormField(
        initialValue: widget.initialValue,
        onChanged: widget.onChange,
        onSaved: widget.onSave,
        obscureText: isObsecure,
        readOnly: widget.readonly,
        onTap: widget.onTap,
        controller: widget.controller,
        textDirection: widget.textdecoration == TextDecoration.none
            ? TextDirection.rtl
            : TextDirection.ltr,
        validator: (value) {
          if (value?.isEmpty ?? true) {
            return 'الحقل مطلوب';
          }
          return null;
        },
        cursorColor: Colors.black,
        textAlignVertical: TextAlignVertical.center,
        maxLines: widget.maxLines,
        decoration: InputDecoration(
          filled: true,
          fillColor: widget.fillcolor ?? Colors.white,
          hintText: widget.hint,
          hintTextDirection: TextDirection.ltr,
          hintStyle: TextStyle(
            color: widget.hintColor ?? Colors.black54,
            fontSize: widget.fontsizehint ?? 15,
          ),

          // 1. أيقونة الحقل الأساسية (تظهر في البداية)
          prefixIcon: leadingIcon != null
              ? Icon(
                  leadingIcon,
                  color: const Color(0xffC1AD94),
                  size: 22,
                )
              : null,

          // 2. زر إظهار/إخفاء كلمة المرور (يظهر في نهاية الحقل)
          suffixIcon: widget.showPasswordIcon
              ? IconButton(
                  splashRadius: 20,
                  onPressed: () {
                    setState(() {
                      isObsecure = !isObsecure;
                    });
                  },
                  icon: Icon(
                    isObsecure ? Icons.visibility_off : Icons.visibility,
                    color: const Color(0xffC1AD94),
                    size: 22,
                  ),
                )
              : null,

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: widget.bordercolor ?? AppColors.textSecondary),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: widget.bordercolor ?? const Color(0xffE6D8C0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: AppColors.textSecondary, width: 1.5),
          ),
        ),
      ),
    );
  }
}