// ignore_for_file: avoid_print

import 'package:floor/floor.dart';

@Entity(tableName: 'sample_types')
class SampleTypeEntity {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  
  @ColumnInfo(name: 'server_id')
  final int? serverId;
  
  final String name;
  final String? description;
  
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

  SampleTypeEntity({
    this.id,
    this.serverId,
    required this.name,
    this.description,
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

  @override
  String toString() {
    return 'SampleTypeEntity(id: $id, serverId: $serverId, name: $name, isSynced: $isSynced)';
  }

  SampleTypeEntity copyWith({
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
    return SampleTypeEntity(
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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'server_id': serverId,
      'name': name,
      'description': description,
      'created_at': createdAt,
      'created_by': createdBy,
      'last_modified': lastModified,
      'last_modified_by': lastModifiedBy,
      'is_deleted': isDeleted,
      'deleted_by': deletedBy,
      'is_synced': isSynced,
      'sync_status': syncStatus,
      'sync_attempts': syncAttempts,
      'last_sync_error': lastSyncError,
    };
  }

  static SampleTypeEntity fromMap(Map<String, dynamic> map) {
    return SampleTypeEntity(
      id: map['id'],
      serverId: map['server_id'] ?? map['serverId'],
      name: map['name'] ?? '',
      description: map['description'],
      createdAt: map['created_at'] ?? map['createdAt'],
      createdBy: map['created_by'] ?? map['createdBy'],
      lastModified: map['last_modified'] ?? map['lastModified'],
      lastModifiedBy: map['last_modified_by'] ?? map['lastModifiedBy'],
      isDeleted: map['is_deleted'] ?? map['isDeleted'] ?? 0,
      deletedBy: map['deleted_by'] ?? map['deletedBy'],
      isSynced: map['is_synced'] ?? map['isSynced'] ?? 0,
      syncStatus: map['sync_status'] ?? map['syncStatus'] ?? 'pending',
      syncAttempts: map['sync_attempts'] ?? map['syncAttempts'] ?? 0,
      lastSyncError: map['last_sync_error'] ?? map['lastSyncError'],
    );
  }
}