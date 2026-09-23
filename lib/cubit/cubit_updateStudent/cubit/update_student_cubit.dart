import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:secure_student_management/core/network/api_client.dart';
import 'package:secure_student_management/features/students/models/student_profile.dart';

part 'update_student_state.dart';

class UpdateStudentCubit extends Cubit<UpdateStudentState> {
  final ApiClient apiClient;
  UpdateStudentCubit(this.apiClient) : super(UpdateStudentInitial());

  Future<void> updateStudent(int id,StudentProfile updatedProfile)async
  {
    emit(UpdateStudentLoading());
try {
    final response = await apiClient.put(
      '/api/Students/$id',
      data: {
        'id': updatedProfile.id,
        'userId': updatedProfile.userId,
        'studentNumber': updatedProfile.studentNumber,
        'dateOfBirth': updatedProfile.dateOfBirh.toUtc().toIso8601String(),
        'phone': updatedProfile.phone,
        'address': updatedProfile.address,
    
      },
    );

    if( response.statusCode == 200 || response.statusCode == 204)
    {
      emit(UpdateStudentSuccess('Student updated successfully'));
    }
  } on DioException catch (e) {
  emit(UpdateStudentFailure('Failed to update student'));
  }
  }

  Future<bool> deletedStudent(int id)async
  {
    try {
    final response = await apiClient.delete('/api/Students/$id');

    return response.statusCode == 200 || response.statusCode == 204;
 
  } on DioException catch (e) {
    
     return false;
  }
  }
}
