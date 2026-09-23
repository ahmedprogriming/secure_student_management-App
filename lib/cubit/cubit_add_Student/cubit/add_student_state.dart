part of 'add_student_cubit.dart';

@immutable
sealed class AddStudentState {}

final class AddStudentInitial extends AddStudentState {}
final class AddStudentLoading extends AddStudentState {}
final class AddStudentSuccess extends AddStudentState {
  final String message;
  AddStudentSuccess(this.message);

}
final class AddStudentFailure extends AddStudentState {
    final String message;
  AddStudentFailure(this.message);
}
