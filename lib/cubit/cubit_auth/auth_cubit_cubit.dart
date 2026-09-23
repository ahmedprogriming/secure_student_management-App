import 'package:bloc/bloc.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:meta/meta.dart';
import 'package:secure_student_management/core/network/api_client.dart';
import 'package:secure_student_management/core/storage/secure_storage_service.dart';
import 'package:secure_student_management/features/auth/services/auth_service.dart';

part 'auth_cubit_state.dart';

class AuthCubit extends Cubit<AuthCubitState> {

  final SecureStorageService _tokenStorage ;

  AuthCubit(this._tokenStorage) : super(AuthCubitInitial());

  // التحقق عند فتح التطبيق
  Future<void> checkAuthStatus() async {
    // محاكاة تأخير بسيط لشاشة البداية (اختياري)
    await Future.delayed(const Duration(seconds: 2)); 
    
    final accessToken = await _tokenStorage.getAccessToken();
    
    if (accessToken != null && accessToken.isNotEmpty) {
      try {
        // فك تشفير التوكن لقراءة البيانات (Claims)
        Map<String, dynamic> decodedToken = JwtDecoder.decode(accessToken);
        
        // ASP.NET Core غالباً يحفظ الـ Role في هذا المسار الطويل، أو في مفتاح 'role' مباشرة
        // سنبحث عن الاثنين لضمان عمل الكود
        // طباعة المحتوى في الـ Console لمعرفة المفتاح الدقيق
print('TOKEN PAYLOAD: $decodedToken');
        String role = decodedToken['role'] ?? 
                     decodedToken['http://schemas.microsoft.com/ws/2008/06/identity/claims/role'] ?? 
                     'Student'; // قيمة افتراضية

        emit(AuthAuthenticated(role));
      } catch (e) {
        // إذا فشل فك التشفير لأي سبب (توكن تالف مثلاً)
        emit(AuthUnauthenticated());
      }
    } else {
      emit(AuthUnauthenticated());
    }
  }

  // تسجيل الخروج
  Future<void> logout() async {
      final apiClient = ApiClient();
    final secureToken =  SecureStorageService();
    final authService = AuthService(apiClient, secureToken);

    await authService.logoutOfApi();
    emit(AuthUnauthenticated());
  }
}
