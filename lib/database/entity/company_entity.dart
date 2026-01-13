import 'package:floor/floor.dart';

@Entity(tableName: 'companies')
class CompanyEntity {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  
  @ColumnInfo(name: 'server_id')
  final int? serverId;
  
  final String name;
  
  @ColumnInfo(name: 'tenant')
  final String? tenant;
  
  @ColumnInfo(name: 'tenant_id')
  final int? tenantId;
  
  @ColumnInfo(name: 'created_at')
  final String createdAt;
  
  @ColumnInfo(name: 'created_by')
  final String? createdBy;
  
  @ColumnInfo(name: 'last_modified')
  final String? lastModified;
  
  @ColumnInfo(name: 'last_modified_by')
  final String? lastModifiedBy;
  
  final bool? deleted;
  
  @ColumnInfo(name: 'deleted_by')
  final String? deletedBy;
  
  @ColumnInfo(name: 'is_synced')
  final bool isSynced;
  
  @ColumnInfo(name: 'is_deleted')
  final bool isDeleted;
  
  @ColumnInfo(name: 'sync_pending')
  final bool syncPending;
  
  @ColumnInfo(name: 'sync_error')
  final bool syncError;
  
  @ColumnInfo(name: 'error_message')
  final String? errorMessage;
  
  @ColumnInfo(name: 'last_sync_attempt')
  final String? lastSyncAttempt;

  CompanyEntity({
    this.id,
    this.serverId,
    required this.name,
    this.tenant,
    this.tenantId,
    required this.createdAt,
    this.createdBy,
    this.lastModified,
    this.lastModifiedBy,
    this.deleted,
    this.deletedBy,
    this.isSynced = false,
    this.isDeleted = false,
    this.syncPending = false,
    this.syncError = false,
    this.errorMessage,
    this.lastSyncAttempt,
  });

  CompanyEntity copyWith({
    int? id,
    int? serverId,
    String? name,
    String? tenant,
    int? tenantId,
    String? createdAt,
    String? createdBy,
    String? lastModified,
    String? lastModifiedBy,
    bool? deleted,
    String? deletedBy,
    bool? isSynced,
    bool? isDeleted,
    bool? syncPending,
    bool? syncError,
    String? errorMessage,
    String? lastSyncAttempt,
  }) {
    return CompanyEntity(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      name: name ?? this.name,
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
      syncPending: syncPending ?? this.syncPending,
      syncError: syncError ?? this.syncError,
      errorMessage: errorMessage ?? this.errorMessage,
      lastSyncAttempt: lastSyncAttempt ?? this.lastSyncAttempt,
    );
  }
}