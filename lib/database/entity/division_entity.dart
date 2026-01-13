// lib/database/entity/division_entity.dart
import 'package:floor/floor.dart';

@Entity(tableName: 'divisions')
class DivisionEntity {
  @PrimaryKey(autoGenerate: true)
  int? id;

  @ColumnInfo(name: 'server_id')
  int? serverId;
  
  String name;

  @ColumnInfo(name: 'company_id')
  int? companyId;

  @ColumnInfo(name: 'company_name')
  String? companyName;

  @ColumnInfo(name: 'created_at')
  String? createdAt;

  @ColumnInfo(name: 'created_by')
  String? createdBy;

  @ColumnInfo(name: 'last_modified')
  String? lastModified;

  @ColumnInfo(name: 'last_modified_by')
  String? lastModifiedBy;

  @ColumnInfo(name: 'is_deleted')
  bool isDeleted;

  @ColumnInfo(name: 'deleted_by')
  String? deletedBy;

  @ColumnInfo(name: 'is_synced')
  bool isSynced;

  @ColumnInfo(name: 'sync_status')
  String syncStatus; // 'pending', 'synced', 'failed'

  @ColumnInfo(name: 'sync_attempts')
  int syncAttempts;

  @ColumnInfo(name: 'last_sync_error')
  String? lastSyncError;

  DivisionEntity({
    this.id,
    this.serverId,
    required this.name,
    this.companyId,
    this.companyName,
    this.createdAt,
    this.createdBy,
    this.lastModified,
    this.lastModifiedBy,
    this.isDeleted = false,
    this.deletedBy,
    this.isSynced = false,
    this.syncStatus = 'pending',
    this.syncAttempts = 0,
    this.lastSyncError,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'server_id': serverId,
      'name': name,
      'company_id': companyId,
      'company_name': companyName,
      'created_at': createdAt,
      'created_by': createdBy,
      'last_modified': lastModified,
      'last_modified_by': lastModifiedBy,
      'is_deleted': isDeleted ? 1 : 0,
      'deleted_by': deletedBy,
      'is_synced': isSynced ? 1 : 0,
      'sync_status': syncStatus,
      'sync_attempts': syncAttempts,
      'last_sync_error': lastSyncError,
    };
  }

  factory DivisionEntity.fromMap(Map<String, dynamic> map) {
    return DivisionEntity(
      id: map['id'],
      serverId: map['server_id'],
      name: map['name'],
      companyId: map['company_id'],
      companyName: map['company_name'],
      createdAt: map['created_at'],
      createdBy: map['created_by'],
      lastModified: map['last_modified'],
      lastModifiedBy: map['last_modified_by'],
      isDeleted: map['is_deleted'] == 1,
      deletedBy: map['deleted_by'],
      isSynced: map['is_synced'] == 1,
      syncStatus: map['sync_status'],
      syncAttempts: map['sync_attempts'] ?? 0,
      lastSyncError: map['last_sync_error'],
    );
  }

  Map<String, dynamic> toServerMap() {
    return {
      'id': serverId ?? 0,
      'name': name,
      'companyId': companyId,
    };
  }

  DivisionEntity copyWith({
    int? id,
    int? serverId,
    String? name,
    int? companyId,
    String? companyName,
    String? createdAt,
    String? createdBy,
    String? lastModified,
    String? lastModifiedBy,
    bool? isDeleted,
    String? deletedBy,
    bool? isSynced,
    String? syncStatus,
    int? syncAttempts,
    String? lastSyncError,
  }) {
    return DivisionEntity(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      name: name ?? this.name,
      companyId: companyId ?? this.companyId,
      companyName: companyName ?? this.companyName,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      lastModified: lastModified ?? this.lastModified,
      lastModifiedBy: lastModifiedBy ?? this.lastModifiedBy,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedBy: deletedBy ?? this.deletedBy,
      isSynced: isSynced ?? this.isSynced,
      syncStatus: syncStatus ?? this.syncStatus,
      syncAttempts: syncAttempts ?? this.syncAttempts,
      lastSyncError: lastSyncError ?? this.lastSyncError,
    );
  }
}