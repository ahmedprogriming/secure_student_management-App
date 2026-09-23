import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:secure_student_management/core/network/api_client.dart';
import 'package:secure_student_management/features/auditing/models/audit_log_model.dart';

part 'audit_log_state.dart';

class AuditLogsCubit extends Cubit<AuditLogsState> {
  final ApiClient apiClient;
  AuditLogsCubit(this.apiClient) : super(AuditLogsInitial());

  Future<void> fetchAuditLogs() async {
    emit(AuditLogsLoading());
    try {
      final response = await apiClient.get('/api/AudtingLogs/All');

      final List<dynamic> data = response.data;
      final logs = data.map((json) => AuditLogModel.fromJson(json)).toList();

      // ترتيب السجلات من الأحدث إلى الأقدم
      logs.sort((a, b) {
        if (a.createdAt == null) return 1;
        if (b.createdAt == null) return -1;
        return b.createdAt!.compareTo(a.createdAt!);
      });

      emit(AuditLogsSuccess(logs));
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        emit(AuditLogsFailure('Access Denied: Admins only.'));
      } else {
        emit(AuditLogsFailure(e.response?.data?['message'] ?? 'Failed to load audit logs'));
      }
    } catch (e) {
      emit(AuditLogsFailure('Unexpected error: $e'));
    }
  }
}
