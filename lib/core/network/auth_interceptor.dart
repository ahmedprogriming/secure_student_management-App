import 'package:dio/dio.dart';
import 'package:secure_student_management/core/storage/secure_storage_service.dart';

class AuthInterceptor extends Interceptor{

  final SecureStorageService secureStorageService;

  AuthInterceptor(this.secureStorageService);

 @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final accessToken = await secureStorageService.getAccessToken();
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    return super.onRequest(options, handler);
  }
}