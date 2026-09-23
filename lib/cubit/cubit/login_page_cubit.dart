import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:secure_student_management/core/network/api_client.dart';
import 'package:secure_student_management/core/storage/secure_storage_service.dart';
import 'package:secure_student_management/features/auth/models/login_request.dart';
import 'package:secure_student_management/features/auth/services/auth_service.dart';

part 'login_page_state.dart';

class LoginPageCubit extends Cubit<LoginPageState> {
  LoginPageCubit() : super(LoginPageInitial());

  Future<void> login(String email, String password) async {
    final apiClient = ApiClient();
    final secureToken =  SecureStorageService();
    final authService = AuthService(apiClient, secureToken);

    try {
      emit(LodingPageLoading());
      
    final request = LoginRequest(
      email: email,
      password: password,
    );

      await authService.login(request);

      emit(LoginPageSuccess());
    } catch (e) {
      emit(LoginPageFailure('Login Error ❌\n'));
    }
  }
}