// ignore_for_file: avoid_print

import 'package:nanohospic/database/entity/payment_mode_entity.dart';

class PaymentMode {
  final int id;
  final String name;
  final String? description;
  final String? tenantId;
  final String? createdAt;
  final String? createdBy;

  PaymentMode({
    required this.id,
    required this.name,
    this.description,
    this.tenantId,
    this.createdAt,
    this.createdBy,
  });

  factory PaymentMode.fromJson(Map<String, dynamic> json) {
    return PaymentMode(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'],
      tenantId: json['tenantId'] ?? json['tenant_id'],
      createdAt: json['created']?.toString() ?? json['created_at']?.toString(),
      createdBy: json['createdBy'] ?? json['created_by'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'tenantId': tenantId,
      'created': createdAt,
      'createdBy': createdBy,
    };
  }

  @override
  String toString() {
    return 'PaymentMode(id: $id, name: $name)';
  }

  factory PaymentMode.fromEntity(PaymentModeEntity entity) {
    return PaymentMode(
      id: entity.serverId ?? entity.id ?? 0,
      name: entity.name,
      description: entity.description,
      tenantId: entity.tenantId,
      createdAt: entity.createdAt,
      createdBy: entity.createdBy,
    );
  }

  PaymentModeEntity toEntity() {
    return PaymentModeEntity(
      serverId: id > 0 ? id : null,
      name: name,
      description: description,
      tenantId: tenantId ?? 'default_tenant',
      createdAt: createdAt ?? DateTime.now().toIso8601String(),
      createdBy: createdBy ?? 'system',
    );
  }
}