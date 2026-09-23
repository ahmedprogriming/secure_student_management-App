part of 'student_list_cubit.dart';

@immutable
sealed class StudentListState {}

final class StudentListInitial extends StudentListState {}
final class StudentListLoading extends StudentListState {}
final class StudentListSuccess extends StudentListState {
  final List<StudentProfile> students;

  StudentListSuccess(this.students);
}
final class StudentListFailure extends StudentListState {
  final String errorMessage;

  StudentListFailure(this.errorMessage);
}    
