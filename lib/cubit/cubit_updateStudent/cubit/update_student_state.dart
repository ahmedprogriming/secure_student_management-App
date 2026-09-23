part of 'update_student_cubit.dart';

@immutable
sealed class UpdateStudentState {}

final class UpdateStudentInitial extends UpdateStudentState {}
final class UpdateStudentLoading extends UpdateStudentState {}
final class UpdateStudentSuccess extends UpdateStudentState {
  final String message;
  UpdateStudentSuccess(this.message);
}
final class UpdateStudentFailure extends UpdateStudentState {
  final String message;
  UpdateStudentFailure(this.message);
}
