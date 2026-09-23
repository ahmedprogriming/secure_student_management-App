part of 'audit_log_cubit.dart';

@immutable
sealed class AuditLogsState {}

final class AuditLogsInitial extends AuditLogsState {}
final class AuditLogsLoading extends AuditLogsState {}
final class AuditLogsSuccess extends AuditLogsState {
  final List<AuditLogModel> logs;

  AuditLogsSuccess(this.logs);
}

final class AuditLogsFailure extends AuditLogsState {
  final String message;
  AuditLogsFailure(this.message);
}
