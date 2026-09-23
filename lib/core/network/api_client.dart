import 'package:dio/dio.dart';
import 'package:secure_student_management/core/constant/api_constant.dart';
import 'package:secure_student_management/core/network/auth_interceptor.dart';
import 'package:secure_student_management/core/storage/secure_storage_service.dart';
import 'package:secure_student_management/features/auth/services/auth_service.dart';
class ApiClient {

  late final Dio dio;

  ApiClient(){
    dio=
    Dio(
      BaseOptions(
        baseUrl:  ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
final secureStorage = SecureStorageService();
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // 1. إضافة الـ Token قبل كل طلب
          final accessToken = await secureStorage.getAccessToken(); // تأكد من اسم الدالة عندك
          if (accessToken != null && accessToken.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) async {
          // 2. معالجة خطأ 401
          if (error.response?.statusCode == 401) {
            try {
              // مهم جداً: نستخدم Dio جديد "خام" لطلب التجديد لمنع حلقة لانهائية (Infinite Loop)
              final refreshDio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));
              
              final refreshToken = await secureStorage.getRefreshToken();
              final email = await secureStorage.getEmail();

              if (refreshToken != null && email != null) {
                // إرسال طلب التجديد
                final response = await refreshDio.post(
                  '/api/Auth/refresh',
                  data: {
                    'refreshToken': refreshToken,
                    'email': email,
                  },
                );

                final newAccessToken = response.data['accessToken'];
                final newRefreshToken = response.data['refreshToken'];

                // حفظ الـ Tokens الجديدة
                await secureStorage.saveToken(
                  accessToken: newAccessToken,
                  refreshToken: newRefreshToken,
                  email: email,
                );

                // إعادة إرسال الطلب الأصلي مع الـ Access Token الجديد
                final options = error.requestOptions;
                options.headers['Authorization'] = 'Bearer $newAccessToken';
                
                final cloneRequest = await dio.fetch(options);
                return handler.resolve(cloneRequest);
              } else {
                await secureStorage.deleteToken(); // أو clearTokens حسب دالتك
              }
            } catch (e) {
              // إذا فشل التجديد (مثلاً الـ Refresh Token منتهي أيضاً)
              await secureStorage.deleteToken();
              // ملاحظة: يمكنك هنا إرسال حدث (Event) أو استخدام Stream لتوجيه المستخدم لشاشة Login
            }
          }
          // استمر في معالجة الأخطاء الأخرى
          return handler.next(error); 
        },
      ),
    );
    
  }

  Future<Response> get(
  String path, {
  Map<String, dynamic>? queryParameters,
}) {
  return dio.get(
    path,
    queryParameters: queryParameters,
  );
}

Future<Response> post(
  String path, {
  dynamic data,
}) {
  return dio.post(
    path,
    data: data,
  );
}

Future<Response> put(
  String path, {
  dynamic data,
}) {
  return dio.put(
    path,
    data: data,
  );
}

Future<Response> delete(
  String path, {
  dynamic data,
}) {
  return dio.delete(
    path,
    data: data,
  );
}
}