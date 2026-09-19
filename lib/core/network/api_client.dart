import 'package:dio/dio.dart';
import 'package:secure_student_management/core/constant/api_constant.dart';
import 'package:secure_student_management/core/network/auth_interceptor.dart';
import 'package:secure_student_management/core/storage/secure_storage_service.dart';
class ApiClient {

  late final Dio dio;

  ApiClient(){
    dio=
    Dio(
      BaseOptions(
        baseUrl:  ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
final secureStorage = SecureStorageService();
    dio.interceptors.add(AuthInterceptor(secureStorage));
    
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