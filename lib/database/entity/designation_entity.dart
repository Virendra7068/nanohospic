// database/entity/Designation_entity.dart
import 'package:floor/floor.dart';

@Entity(tableName: 'designation')
class DesignationEntity {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  
  @ColumnInfo(name: 'server_id')
  final int? serverId;
  
  @ColumnInfo(name: 'name')
  final String name;
  
  @ColumnInfo(name: 'description')
  final String? description;
  
  @ColumnInfo(name: 'created_at')
  final String createdAt;
  
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

  DesignationEntity({
    this.id,
    this.serverId,
    required this.name,
    this.description,
    required this.createdAt,
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

  DesignationEntity copyWith({
    int? id,
    int? serverId,
    String? name,
    String? description,
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
    return DesignationEntity(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      name: name ?? this.name,
      description: description ?? this.description,
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

  Map<String, dynamic> toJson() {
    return {
      'id': serverId ?? 0,
      'name': name,
      'description': description ?? '',
      'createdAt': createdAt,
      'createdBy': createdBy,
      'lastModified': lastModified,
      'lastModifiedBy': lastModifiedBy,
      'isDeleted': isDeleted == 1,
      'deletedBy': deletedBy,
      'isSynced': isSynced == 1,
      'syncStatus': syncStatus,
      'syncAttempts': syncAttempts,
      'lastSyncError': lastSyncError,
    };
  }

  factory DesignationEntity.fromJson(Map<String, dynamic> json) {
    return DesignationEntity(
      serverId: json['id'] as int?,
      name: json['name'] as String,
      description: json['description'] as String?,
      createdAt: json['createdAt'] as String,
      createdBy: json['createdBy'] as String?,
      lastModified: json['lastModified'] as String?,
      lastModifiedBy: json['lastModifiedBy'] as String?,
      isDeleted: (json['isDeleted'] as bool? ?? false) ? 1 : 0,
      deletedBy: json['deletedBy'] as String?,
      isSynced: (json['isSynced'] as bool? ?? false) ? 1 : 0,
      syncStatus: json['syncStatus'] as String?,
      syncAttempts: json['syncAttempts'] as int? ?? 0,
      lastSyncError: json['lastSyncError'] as String?,
    );
  }

  factory DesignationEntity.fromServerJson(Map<String, dynamic> json) {
    return DesignationEntity(
      serverId: json['id'] as int?,
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      createdAt: json['createdAt'] as String? ?? DateTime.now().toIso8601String(),
      createdBy: json['createdBy'] as String?,
      lastModified: json['lastModified'] as String?,
      lastModifiedBy: json['lastModifiedBy'] as String?,
      isDeleted: (json['isDeleted'] as bool? ?? false) ? 1 : 0,
      deletedBy: json['deletedBy'] as String?,
      isSynced: 1,
      syncStatus: 'synced',
    );
  }
}