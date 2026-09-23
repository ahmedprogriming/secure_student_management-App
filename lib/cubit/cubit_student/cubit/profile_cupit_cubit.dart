import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:meta/meta.dart';
import 'package:secure_student_management/core/network/api_client.dart';
import 'package:secure_student_management/core/storage/secure_storage_service.dart';
import 'package:secure_student_management/features/students/models/student_profile.dart';

part 'profile_cupit_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ApiClient apiClient;
  final SecureStorageService secureStorage; // أضفنا التخزين هنا

  ProfileCubit({
    required this.apiClient,
    required this.secureStorage,
  }) : super(ProfileLoading());

  Future<void> fetchMyProfile() async {
    emit(ProfileLoading());
    try {
      // 1. جلب التوكن من التخزين الآمن
      final token = await secureStorage.getAccessToken();
      if (token == null || token.isEmpty) {
        emit(ProfileFailure('لا يوجد توكن صالح'));
        return;
      }

      // 2. فك التوكن لاستخراج الـ ID
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      
      // في ASP.NET Core، يتم حفظ الـ ID عادة في أحد هذه المفاتيح
      String userId = decodedToken['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier'] 
                   ?? decodedToken['sub'] 
                   ?? decodedToken['id'] 
                   ?? '';

      if (userId.isEmpty) {
        emit(ProfileFailure('لم يتم العثور على معرف المستخدم في التوكن'));
        return;
      }

      // 3. تمرير الـ ID للـ Endpoint
      final response = await apiClient.get('/api/Students/$userId'); // تأكد من مسار الـ API الصحيح
      
      final profile = StudentProfile.fromJson(response.data);
      emit(ProfileSuccess(profile));
      
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        emit(ProfileFailure('غير مصرح لك بمشاهدة هذه البيانات (مبدأ Ownership يعمل)'));
      } else {
        emit(ProfileFailure('حدث خطأ أثناء جلب البيانات'));
      }
    } catch (e) {
      emit(ProfileFailure('خطأ غير متوقع: $e'));
    }
  }


    Future<void> fetchStudentById(int id) async {
    emit(ProfileLoading());
    try {
      // 1. جلب التوكن من التخزين الآمن
      final token = await secureStorage.getAccessToken();
      if (token == null || token.isEmpty) {
        emit(ProfileFailure('لا يوجد توكن صالح'));
        return;
      }

      // 3. تمرير الـ ID للـ Endpoint
      final response = await apiClient.get('/api/Students/$id'); // تأكد من مسار الـ API الصحيح
      
      final profile = StudentProfile.fromJson(response.data);
      emit(ProfileSuccess(profile));
      
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        emit(ProfileFailure('غير مصرح لك بمشاهدة هذه البيانات (مبدأ Ownership يعمل)'));
      } else {
        emit(ProfileFailure('حدث خطأ أثناء جلب البيانات'));
      }
    } catch (e) {
      emit(ProfileFailure('خطأ غير متوقع: $e'));
    }
  }
}
