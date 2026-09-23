part of 'all_users_cubit.dart';

@immutable
sealed class AllUsersState {}

final class AllUsersInitial extends AllUsersState {}
final class AllUsersLoading extends AllUsersState {}
final class AllUsersSuccess extends AllUsersState {
  final List<UserModel> userList;
  AllUsersSuccess(this.userList);
}
final class AllUsersFailure extends AllUsersState {

  final String message;
  AllUsersFailure(this.message);
}
