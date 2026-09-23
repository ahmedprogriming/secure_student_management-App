import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:secure_student_management/core/network/api_client.dart';
import 'package:secure_student_management/features/users/models/add_user_request.dart';
import 'package:secure_student_management/features/users/models/user_model.dart';

part 'all_users_state.dart';

class AllUsersCubit extends Cubit<AllUsersState> {
  final ApiClient apiClient;
  AllUsersCubit(this.apiClient) : super(AllUsersInitial());

  Future<void> fetchAllUsers() async {
    emit(AllUsersLoading());
    try {
      final response = await apiClient.get('/api/Usres/All');
      final List<UserModel> users = (response.data as List)
          .map((json) => UserModel.fromJson(json))
          .toList();
      emit(AllUsersSuccess(users));
    } catch (e) {
      emit(AllUsersFailure('Failed to fetch user list'));
    }
  }

   Future<bool> addNewUser(AddUserRequest request) async
  {
try {
    final response = await apiClient.post(
      '/api/Usres/AddNewUser',
      data: request.toJson(),
    );
    

    if (response.statusCode == 200 || response.statusCode == 201) {
      await fetchAllUsers(); // تحديث القائمة تلقائياً
      return true;
    }
    return false;
  } on DioException {
    return false;
  } catch (e) {
    return false;
  }
  }

}
