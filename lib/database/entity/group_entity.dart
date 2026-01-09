// lib/database/entity/group_entity.dart
import 'package:floor/floor.dart';

@Entity(tableName: 'groups')
class GroupEntity {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  
  @ColumnInfo(name: 'server_id')
  final int? serverId;
  
  @ColumnInfo(name: 'name')
  final String name;
  
  @ColumnInfo(name: 'description')
  final String? description;
  
  @ColumnInfo(name: 'code')
  final String? code;
  
  @ColumnInfo(name: 'type')
  final String? type;
  
  @ColumnInfo(name: 'status')
  final String? status;
  
  @ColumnInfo(name: 'tenant_id')
  final String? tenantId;
  
  @ColumnInfo(name: 'created_at')
  final String? createdAt;
  
  @ColumnInfo(name: 'created_by')
  final String? createdBy;
  
  @ColumnInfo(name: 'last_modified')
  final String? lastModified;
  
  @ColumnInfo(name: 'last_modified_by')
  final String? lastModifiedBy;
  
  @ColumnInfo(name: 'is_deleted')
  final int isDeleted;
  
  @ColumnInfo(name: 'deleted_by')
  final String? deletedBy;
  
  @ColumnInfo(name: 'is_synced')
  final int isSynced;
  
  @ColumnInfo(name: 'sync_status')
  final String? syncStatus;
  
  @ColumnInfo(name: 'sync_attempts')
  final int syncAttempts;
  
  @ColumnInfo(name: 'last_sync_error')
  final String? lastSyncError;

  GroupEntity({
    this.id,
    this.serverId,
    required this.name,
    this.description,
    this.code,
    this.type,
    this.status,
    this.tenantId,
    this.createdAt,
    this.createdBy,
    this.lastModified,
    this.lastModifiedBy,
    this.isDeleted = 0,
    this.deletedBy,
    this.isSynced = 0,
    this.syncStatus = 'pending',
    this.syncAttempts = 0,
    this.lastSyncError,
  });

  // Factory method to create from JSON/map
  factory GroupEntity.fromJson(Map<String, dynamic> json) {
    return GroupEntity(
      id: json['id'] as int?,
      serverId: json['server_id'] ?? json['serverId'] as int?,
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      code: json['code'] as String?,
      type: json['type'] as String? ?? 'general',
      status: json['status'] as String? ?? 'active',
      tenantId: json['tenant_id'] ?? json['tenantId'] as String?,
      createdAt: json['created_at'] ?? json['createdAt'] as String?,
      createdBy: json['created_by'] ?? json['createdBy'] as String?,
      lastModified: json['last_modified'] ?? json['lastModified'] as String?,
      lastModifiedBy: json['last_modified_by'] ?? json['lastModifiedBy'] as String?,
      isDeleted: (json['is_deleted'] ?? json['isDeleted'] ?? 0) as int,
      deletedBy: json['deleted_by'] ?? json['deletedBy'] as String?,
      isSynced: (json['is_synced'] ?? json['isSynced'] ?? 0) as int,
      syncStatus: json['sync_status'] ?? json['syncStatus'] as String? ?? 'pending',
      syncAttempts: (json['sync_attempts'] ?? json['syncAttempts'] ?? 0) as int,
      lastSyncError: json['last_sync_error'] ?? json['lastSyncError'] as String?,
    );
  }

  // Convert to JSON/map
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (serverId != null) 'server_id': serverId,
      'name': name,
      if (description != null) 'description': description,
      if (code != null) 'code': code,
      if (type != null) 'type': type,
      if (status != null) 'status': status,
      if (tenantId != null) 'tenant_id': tenantId,
      if (createdAt != null) 'created_at': createdAt,
      if (createdBy != null) 'created_by': createdBy,
      if (lastModified != null) 'last_modified': lastModified,
      if (lastModifiedBy != null) 'last_modified_by': lastModifiedBy,
      'is_deleted': isDeleted,
      if (deletedBy != null) 'deleted_by': deletedBy,
      'is_synced': isSynced,
      if (syncStatus != null) 'sync_status': syncStatus,
      'sync_attempts': syncAttempts,
      if (lastSyncError != null) 'last_sync_error': lastSyncError,
    };
  }

  // Copy with method for immutability
  GroupEntity copyWith({
    int? id,
    int? serverId,
    String? name,
    String? description,
    String? code,
    String? type,
    String? status,
    String? tenantId,
    String? createdAt,
    String? createdBy,
    String? lastModified,
    String? lastModifiedBy,
    int? isDeleted,
    String? deletedBy,
    int? isSynced,
    String? syncStatus,
    int? syncAttempts,
    String? lastSyncError,
  }) {
    return GroupEntity(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      name: name ?? this.name,
      description: description ?? this.description,
      code: code ?? this.code,
      type: type ?? this.type,
      status: status ?? this.status,
      tenantId: tenantId ?? this.tenantId,
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

  // Convenience getters
  bool get isActive => isDeleted == 0 && (status == 'active' || status == null);
  
  bool get isPendingSync => isSynced == 0;
  
  bool get hasSyncError => lastSyncError != null && lastSyncError!.isNotEmpty;
  
  bool get isSoftDeleted => isDeleted == 1;
  
  String get displayName => name;
  
  String get displayCode => code ?? 'N/A';
  
  String get displayType => type ?? 'General';
  
  String get displayStatus {
    if (isDeleted == 1) return 'Deleted';
    return status ?? 'Active';
  }

  // Equality check
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is GroupEntity &&
        other.id == id &&
        other.serverId == serverId &&
        other.name == name &&
        other.description == description &&
        other.code == code &&
        other.type == type &&
        other.status == status &&
        other.tenantId == tenantId &&
        other.isDeleted == isDeleted &&
        other.isSynced == isSynced;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        serverId.hashCode ^
        name.hashCode ^
        description.hashCode ^
        code.hashCode ^
        type.hashCode ^
        status.hashCode ^
        tenantId.hashCode ^
        isDeleted.hashCode ^
        isSynced.hashCode;
  }

  @override
  String toString() {
    return '''
GroupEntity(
  id: $id,
  serverId: $serverId,
  name: $name,
  code: $code,
  type: $type,
  status: $status,
  isDeleted: $isDeleted,
  isSynced: $isSynced,
  syncStatus: $syncStatus,
  createdAt: $createdAt,
)
''';
  }

  // Helper methods for sync operations
  GroupEntity markAsSynced() {
    return copyWith(
      isSynced: 1,
      syncStatus: 'synced',
      syncAttempts: 0,
      lastSyncError: null,
      lastModified: DateTime.now().toIso8601String(),
    );
  }

  GroupEntity markAsSyncFailed(String error) {
    return copyWith(
      syncAttempts: syncAttempts + 1,
      lastSyncError: error,
      syncStatus: 'failed',
      lastModified: DateTime.now().toIso8601String(),
    );
  }

  GroupEntity markAsDeleted(String deletedByUser) {
    return copyWith(
      isDeleted: 1,
      deletedBy: deletedByUser,
      lastModified: DateTime.now().toIso8601String(),
      isSynced: 0, // Mark for sync
    );
  }

  GroupEntity restore() {
    return copyWith(
      isDeleted: 0,
      deletedBy: null,
      lastModified: DateTime.now().toIso8601String(),
      isSynced: 0, // Mark for sync
    );
  }

  // Validation methods
  List<String> validate() {
    final errors = <String>[];
    
    if (name.isEmpty) {
      errors.add('Group name is required');
    } else if (name.length < 2) {
      errors.add('Group name must be at least 2 characters');
    } else if (name.length > 100) {
      errors.add('Group name cannot exceed 100 characters');
    }
    
    if (code != null && code!.length > 20) {
      errors.add('Group code cannot exceed 20 characters');
    }
    
    if (description != null && description!.length > 500) {
      errors.add('Description cannot exceed 500 characters');
    }
    
    return errors;
  }

  bool get isValid => validate().isEmpty;

  // For UI display
  Map<String, String> toDisplayMap() {
    return {
      'Name': name,
      'Code': code ?? 'Not set',
      'Type': type ?? 'General',
      'Status': displayStatus,
      'Description': description ?? 'No description',
      'Created At': createdAt != null 
          ? _formatDate(createdAt!) 
          : 'Unknown',
      'Created By': createdBy ?? 'Unknown',
      'Sync Status': isSynced == 1 ? 'Synced' : 'Pending',
      if (lastSyncError != null) 'Last Sync Error': lastSyncError!,
    };
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateString;
    }
  }

  // Create new group with current timestamp
  factory GroupEntity.create({
    required String name,
    String? description,
    String? code,
    String? type,
    String? status,
    String? createdBy,
    String? tenantId,
  }) {
    final now = DateTime.now().toIso8601String();
    return GroupEntity(
      name: name,
      description: description,
      code: code,
      type: type ?? 'general',
      status: status ?? 'active',
      tenantId: tenantId ?? 'default_tenant',
      createdAt: now,
      createdBy: createdBy ?? 'system',
      lastModified: now,
      lastModifiedBy: createdBy ?? 'system',
      isSynced: 0,
      syncStatus: 'pending',
    );
  }

  // Update group
  GroupEntity update({
    String? name,
    String? description,
    String? code,
    String? type,
    String? status,
    String? updatedBy,
  }) {
    return copyWith(
      name: name ?? this.name,
      description: description ?? this.description,
      code: code ?? this.code,
      type: type ?? this.type,
      status: status ?? this.status,
      lastModified: DateTime.now().toIso8601String(),
      lastModifiedBy: updatedBy ?? this.lastModifiedBy,
      isSynced: 0, // Mark for sync after update
    );
  }
}