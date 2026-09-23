import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:secure_student_management/core/network/api_client.dart';
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

}
