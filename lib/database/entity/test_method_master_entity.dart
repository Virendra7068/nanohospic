// lib/database/entity/test_method_entity.dart
import 'package:floor/floor.dart';

@Entity(tableName: 'test_methods')
class TestMethodEntity {
  @PrimaryKey(autoGenerate: true)
  int? id;

  @ColumnInfo(name: 'server_id')
  int? serverId;
  
  @ColumnInfo(name: 'method_name')
  String methodName;
  
  String description;

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

  TestMethodEntity({
    this.id,
    this.serverId,
    required this.methodName,
    required this.description,
    this.createdAt,
    this.createdBy,
    this.lastModified,
    this.lastModifiedBy,
    this.isDeleted = false,
    this.deletedBy,
    this.isSynced = false,
    this.syncStatus = 'pending',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'server_id': serverId,
      'method_name': methodName,
      'description': description,
      'created_at': createdAt,
      'created_by': createdBy,
      'last_modified': lastModified,
      'last_modified_by': lastModifiedBy,
      'is_deleted': isDeleted ? 1 : 0,
      'deleted_by': deletedBy,
      'is_synced': isSynced ? 1 : 0,
      'sync_status': syncStatus,
    };
  }

  factory TestMethodEntity.fromMap(Map<String, dynamic> map) {
    return TestMethodEntity(
      id: map['id'] as int?,
      serverId: map['server_id'] as int?,
      methodName: map['method_name'] as String,
      description: map['description'] as String,
      createdAt: map['created_at'] as String?,
      createdBy: map['created_by'] as String?,
      lastModified: map['last_modified'] as String?,
      lastModifiedBy: map['last_modified_by'] as String?,
      isDeleted: (map['is_deleted'] as int?) == 1,
      deletedBy: map['deleted_by'] as String?,
      isSynced: (map['is_synced'] as int?) == 1,
      syncStatus: map['sync_status'] as String? ?? 'pending',
    );
  }

  factory TestMethodEntity.fromServerMap(Map<String, dynamic> map) {
    return TestMethodEntity(
      serverId: map['id'] as int?,
      methodName: map['methodName'] as String? ?? '',
      description: map['description'] as String? ?? '',
      createdAt: map['created'] as String?,
      createdBy: map['createdBy'] as String?,
      lastModified: map['lastModified'] as String?,
      lastModifiedBy: map['lastModifiedBy'] as String?,
      isSynced: true,
      syncStatus: 'synced',
    );
  }
}