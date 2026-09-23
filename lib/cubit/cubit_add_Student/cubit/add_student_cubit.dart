import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:secure_student_management/core/network/api_client.dart';
import 'package:secure_student_management/features/students/models/add_student_request.dart';

part 'add_student_state.dart';

class AddStudentCubit extends Cubit<AddStudentState> {
  final ApiClient apiClient;
  AddStudentCubit(this.apiClient) : super(AddStudentInitial());

  Future<void> addStudent(AddStudentRequest request)async
  {
    emit(AddStudentLoading());

    try{
      final response = await apiClient.post(
        '/api/Students',
        data: request.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(AddStudentSuccess('Student added successfully'));
      } else {
        emit(AddStudentFailure('Unexpected status code: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      String msg = 'Failed to add student';
      final data = e.response?.data;
      if (data is Map<String, dynamic> && data.containsKey('message')) {
        msg = data['message'];
      } else if (data is String && data.isNotEmpty) {
        msg = data;
      }
      emit(AddStudentFailure(msg));
    }
    catch(e)
    {
    emit(AddStudentFailure('An unexpected error occurred: $e'));
    }
  }
}
