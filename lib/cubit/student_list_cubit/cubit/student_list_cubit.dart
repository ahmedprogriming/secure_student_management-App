import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:secure_student_management/core/network/api_client.dart';
import 'package:secure_student_management/features/students/models/student_profile.dart';

part 'student_list_state.dart';

class StudentListCubit extends Cubit<StudentListState> {
  final ApiClient apiClient;
  StudentListCubit(this.apiClient) : super(StudentListInitial());

  Future<void> fetchAllStudent() async {
    emit(StudentListLoading());
    try {
      final response = await apiClient.get('/api/Students/All');
      final List<StudentProfile> students = (response.data as List)
          .map((json) => StudentProfile.fromJson(json))
          .toList();
      emit(StudentListSuccess(students));
    } catch (e) {
      emit(StudentListFailure('Failed to fetch student list: $e'));
    }
  }
}
