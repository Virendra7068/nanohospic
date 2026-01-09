// lib/database/entity/hsn_entity.dart
import 'package:floor/floor.dart';
import 'package:nanohospic/model/hsn_model.dart';

@Entity(tableName: 'hsn_codes')
class HsnEntity {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  
  @ColumnInfo(name: 'server_id')
  final int? serverId;
  
  @ColumnInfo(name: 'hsn_code')
  final String hsnCode;
  
  final double sgst;
  final double cgst;
  final double igst;
  final double cess;
  
  @ColumnInfo(name: 'hsn_type')
  final int? hsnType;
  
  final String? tenant;
  
  @ColumnInfo(name: 'tenant_id')
  final String? tenantId;
  
  @ColumnInfo(name: 'created_at')
  final String createdAt;
  
  @ColumnInfo(name: 'created_by')
  final String createdBy;
  
  @ColumnInfo(name: 'last_modified')
  final String? lastModified;
  
  @ColumnInfo(name: 'last_modified_by')
  final String? lastModifiedBy;
  
  final String? deleted;
  
  @ColumnInfo(name: 'deleted_by')
  final String? deletedBy;
  
  @ColumnInfo(name: 'is_synced')
  final bool isSynced;
  
  @ColumnInfo(name: 'is_deleted')
  final bool isDeleted;
  
  @ColumnInfo(name: 'sync_attempts')
  final int syncAttempts;
  
  @ColumnInfo(name: 'last_sync_error')
  final String? lastSyncError;
  
  HsnEntity({
    this.id,
    this.serverId,
    required this.hsnCode,
    this.sgst = 0,
    this.cgst = 0,
    this.igst = 0,
    this.cess = 0,
    this.hsnType,
    this.tenant,
    this.tenantId,
    required this.createdAt,
    required this.createdBy,
    this.lastModified,
    this.lastModifiedBy,
    this.deleted,
    this.deletedBy,
    this.isSynced = false,
    this.isDeleted = false,
    this.syncAttempts = 0,
    this.lastSyncError,
  });

  // Copy with method for updating fields
  HsnEntity copyWith({
    int? id,
    int? serverId,
    String? hsnCode,
    double? sgst,
    double? cgst,
    double? igst,
    double? cess,
    int? hsnType,
    String? tenant,
    String? tenantId,
    String? createdAt,
    String? createdBy,
    String? lastModified,
    String? lastModifiedBy,
    String? deleted,
    String? deletedBy,
    bool? isSynced,
    bool? isDeleted,
    int? syncAttempts,
    String? lastSyncError,
  }) {
    return HsnEntity(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      hsnCode: hsnCode ?? this.hsnCode,
      sgst: sgst ?? this.sgst,
      cgst: cgst ?? this.cgst,
      igst: igst ?? this.igst,
      cess: cess ?? this.cess,
      hsnType: hsnType ?? this.hsnType,
      tenant: tenant ?? this.tenant,
      tenantId: tenantId ?? this.tenantId,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      lastModified: lastModified ?? this.lastModified,
      lastModifiedBy: lastModifiedBy ?? this.lastModifiedBy,
      deleted: deleted ?? this.deleted,
      deletedBy: deletedBy ?? this.deletedBy,
      isSynced: isSynced ?? this.isSynced,
      isDeleted: isDeleted ?? this.isDeleted,
      syncAttempts: syncAttempts ?? this.syncAttempts,
      lastSyncError: lastSyncError ?? this.lastSyncError,
    );
  }

  // Convert from model to entity
  factory HsnEntity.fromModel(HsnModel model) {
    return HsnEntity(
      serverId: model.id,
      hsnCode: model.hsnCode,
      sgst: model.sgst,
      cgst: model.cgst,
      igst: model.igst,
      cess: model.cess,
      hsnType: model.hsnType,
      tenant: model.tenant,
      tenantId: model.tenantId,
      createdAt: model.created.toIso8601String(),
      createdBy: model.createdBy,
      lastModified: model.lastModified?.toIso8601String(),
      lastModifiedBy: model.lastModifiedBy,
      deleted: model.deleted?.toIso8601String(),
      deletedBy: model.deletedBy,
      isSynced: true,
    );
  }

  // Convert to model
  HsnModel toModel() {
    return HsnModel(
      id: serverId ?? 0,
      hsnCode: hsnCode,
      sgst: sgst,
      cgst: cgst,
      igst: igst,
      cess: cess,
      hsnType: hsnType,
      tenant: tenant,
      tenantId: tenantId,
      created: DateTime.parse(createdAt),
      createdBy: createdBy,
      lastModified: lastModified != null ? DateTime.parse(lastModified!) : null,
      lastModifiedBy: lastModifiedBy,
      deleted: deleted != null ? DateTime.parse(deleted!) : null,
      deletedBy: deletedBy,
    );
  }

  // Convert from server JSON to entity
  factory HsnEntity.fromServerJson(Map<String, dynamic> json) {
    return HsnEntity(
      serverId: json['id'] ?? 0,
      hsnCode: json['hsnCode'] ?? '',
      sgst: (json['sgst'] ?? 0).toDouble(),
      cgst: (json['cgst'] ?? 0).toDouble(),
      igst: (json['igst'] ?? 0).toDouble(),
      cess: (json['cess'] ?? 0).toDouble(),
      hsnType: json['hsnType'],
      tenant: json['tenant'],
      tenantId: json['tenantId'],
      createdAt: json['created'] != null 
          ? json['created'] is DateTime 
              ? (json['created'] as DateTime).toIso8601String()
              : json['created'].toString()
          : DateTime.now().toIso8601String(),
      createdBy: json['createdBy'] ?? 'System',
      lastModified: json['lastModified']?.toString(),
      lastModifiedBy: json['lastModifiedBy'],
      deleted: json['deleted']?.toString(),
      deletedBy: json['deletedBy'],
      isSynced: true,
    );
  }

  // Convert to server JSON
  Map<String, dynamic> toServerJson() {
    return {
      if (serverId != null && serverId! > 0) 'id': serverId,
      'hsnCode': hsnCode,
      'sgst': sgst,
      'cgst': cgst,
      'igst': igst,
      'cess': cess,
      'hsnType': hsnType,
      'tenant': tenant,
      'tenantId': tenantId,
      if (serverId == null || serverId! == 0) 
        'created': DateTime.now().toIso8601String(),
      if (serverId == null || serverId! == 0) 
        'createdBy': createdBy,
    };
  }

  // Check if HSN is valid
  bool isValid() {
    return hsnCode.isNotEmpty;
  }

  @override
  String toString() {
    return 'HsnEntity{id: $id, serverId: $serverId, hsnCode: $hsnCode, sgst: $sgst, cgst: $cgst, igst: $igst, cess: $cess, isSynced: $isSynced}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HsnEntity &&
          runtimeType == other.runtimeType &&
          hsnCode == other.hsnCode;

  @override
  int get hashCode => hsnCode.hashCode;
}