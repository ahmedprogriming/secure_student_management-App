import 'package:secure_student_management/core/network/api_client.dart';
import 'package:secure_student_management/core/storage/secure_storage_service.dart';
import 'package:secure_student_management/features/auth/models/login_request.dart';
import 'package:secure_student_management/features/auth/models/login_response.dart';

class AuthService {

  final ApiClient apiClient;
  final SecureStorageService secureStorageService ;

  AuthService(this.apiClient, this.secureStorageService);

  Future<LoginResponse> login(LoginRequest request) async {
    final response = await apiClient.post(
      '/api/Auth/Login',
      data: request.toJson(),
    );

   
      final loginResponse = LoginResponse.fromJson(response.data);
      await secureStorageService.saveToken(
        accessToken: loginResponse.accessToken,
        refreshToken: loginResponse.refreshToken,
        email: request.email,
      );
      return loginResponse;
   
  }

  Future<void> logoutOfApi() async {
    final tokenStorage = SecureStorageService();
  final refreshToken = await tokenStorage.getRefreshToken();
  final email=await tokenStorage.getEmail();
  

  try {
    await apiClient.post(
      '/api/Auth/logout',
      data: {
        'refreshToken': refreshToken,
        'email': email,
      },
    );
  } finally {
    await tokenStorage.deleteToken(); // حذف البيانات السرية بعد تسجيل الخروج
  }
}

}