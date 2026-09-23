part of 'auth_cubit_cubit.dart';

@immutable
sealed class AuthCubitState {
 final String role;
 const AuthCubitState({this.role= 'Unknown'});
}

final class AuthCubitInitial extends AuthCubitState {
const AuthCubitInitial() :super();
}
final class AuthAuthenticated extends AuthCubitState {
 
const  AuthAuthenticated(String role ) :super(role: role);
}
final class AuthUnauthenticated extends AuthCubitState {
  const AuthUnauthenticated() : super();
}