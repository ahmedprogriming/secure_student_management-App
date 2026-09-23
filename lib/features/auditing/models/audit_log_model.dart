class AuditLogModel {
  final int id;
  final int? userId;
  final String action;
  final String entityName;
  final String? entityId;
  final String ipAddress;
  final String details;
  final DateTime? createdAt;

  AuditLogModel({
    required this.id,
    this.userId,
    required this.action,
    required this.entityName,
    this.entityId,
    required this.ipAddress,
    required this.details,
    this.createdAt,
  });

  factory AuditLogModel.fromJson(Map<String, dynamic> json) {
    return AuditLogModel(
      id: json['id'] ?? 0,
      userId: json['userId'],
      action: json['action'] ?? '',
      entityName: json['entityName'] ?? '',
      entityId: json['entityId']?.toString(),
      ipAddress: json['ipAddress'] ?? 'Unknown',
      details: json['details'] ?? '',
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
    );
  }
}