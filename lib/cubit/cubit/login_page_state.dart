part of 'login_page_cubit.dart';

@immutable
sealed class LoginPageState {}

final class LoginPageInitial extends LoginPageState {}
final class LodingPageLoading extends LoginPageState {}
final class LoginPageSuccess extends LoginPageState {}
final class LoginPageFailure extends LoginPageState 
{
  final String errorMessage;

  LoginPageFailure(this.errorMessage);
}
