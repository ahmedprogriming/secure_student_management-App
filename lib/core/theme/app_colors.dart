import 'package:flutter/material.dart';

class AppColors {
  // الألوان الأساسية المشتقة من الشعار
  static const Color primary = Color(0xFF0047BA);       // الأزرق الملكي الأساسي للشعار
  static const Color primaryDark = Color(0xFF002F80);   // أزرق داكن للتدرجات والعناوين
  static const Color primaryLight = Color(0xFFEBF2FD);  // خلفية زرقاء فاتحة ناعمة للأيقونات والبطاقات
  static const Color accent = Color(0xFF1E88E5);        // أزرق تفاعلي ثانوي

  // الخلفيات والسطوح
  static const Color background = Color(0xFFF8FAFD);    // خلفية مريحة للعين وفاتحة
  static const Color surface = Colors.white;            // لون البطاقات والحقول
  
  // النصوص
  static const Color textPrimary = Color(0xFF1A1F36);   // لون داكن عالي التباين
  static const Color textSecondary = Color(0xFF697386); // لون فرعي رمادي ناعم
  static const Color border = Color(0xFFE2E8F0);        // لون الحدود

  // الحالات
  static const Color success = Color(0xFF0E9F6E);
  static const Color error = Color(0xFFE02424);
  static const Color warning = Color(0xFFF59E0B);
}