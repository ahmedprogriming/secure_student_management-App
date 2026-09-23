import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_student_management/cubit/audit_cubit/cubit/audit_log_cubit.dart';


class AuditLogsPage extends StatefulWidget {
  static const String id = 'AuditLogsPage';
  const AuditLogsPage({super.key});

  @override
  State<AuditLogsPage> createState() => _AuditLogsPageState();
}

class _AuditLogsPageState extends State<AuditLogsPage> {
  @override
  void initState() {
    super.initState();
    context.read<AuditLogsCubit>().fetchAuditLogs();
  }

  Color _getActionColor(String action) {
    if (action.contains('FAILED') || action.contains('BLOCKED') || action.contains('DELETE')) {
      return Colors.red.shade700;
    }
    if (action.contains('SUCCESS') || action.contains('LOGIN')) {
      return Colors.green.shade700;
    }
    if (action.contains('UPDATE')) {
      return Colors.amber.shade800;
    }
    return Colors.blue.shade700;
  }

  IconData _getActionIcon(String action) {
    if (action.contains('FAILED') || action.contains('BLOCKED')) {
      return Icons.gpp_bad_outlined;
    }
    if (action.contains('LOGIN')) {
      return Icons.login;
    }
    if (action.contains('DELETE')) {
      return Icons.delete_outline;
    }
    return Icons.security_outlined;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Security Audit Logs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<AuditLogsCubit>().fetchAuditLogs(),
          ),
        ],
      ),
      body: BlocBuilder<AuditLogsCubit, AuditLogsState>(
        builder: (context, state) {
          if (state is AuditLogsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AuditLogsFailure) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lock_clock, size: 48, color: Colors.red.shade400),
                    const SizedBox(height: 12),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.read<AuditLogsCubit>().fetchAuditLogs(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is AuditLogsSuccess) {
            final logs = state.logs;

            if (logs.isEmpty) {
              return const Center(child: Text('No audit logs recorded.'));
            }

            return ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: logs.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final log = logs[index];
                final color = _getActionColor(log.action);
                final formattedDate = log.createdAt != null
                    ? '${log.createdAt!.year}-${log.createdAt!.month.toString().padLeft(2, '0')}-${log.createdAt!.day.toString().padLeft(2, '0')} ${log.createdAt!.hour.toString().padLeft(2, '0')}:${log.createdAt!.minute.toString().padLeft(2, '0')}'
                    : 'Unknown Time';

                return Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: color.withOpacity(0.3)),
                  ),
                  child: ExpansionTile(
                    leading: CircleAvatar(
                      backgroundColor: color.withOpacity(0.12),
                      child: Icon(_getActionIcon(log.action), color: color),
                    ),
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            log.action,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                          ),
                        ),
                        Text(
                          log.ipAddress,
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        children: [
                          Text('Entity: ${log.entityName}'),
                          const Spacer(),
                          Text(formattedDate, style: const TextStyle(fontSize: 11)),
                        ],
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Log ID: #${log.id}'),
                              Text('User ID: ${log.userId ?? 'None'}'),
                              if (log.entityId != null) Text('Entity ID: ${log.entityId}'),
                              const Divider(),
                              const Text('Details / Payload:', style: TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  log.details.isNotEmpty ? log.details : 'No details available',
                                  style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}