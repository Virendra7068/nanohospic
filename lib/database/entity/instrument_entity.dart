import 'package:floor/floor.dart';

@Entity(tableName: 'instruments')
class InstrumentEntity {
  @PrimaryKey(autoGenerate: true)
  int? id;

  @ColumnInfo(name: 'server_id')
  int? serverId;
  
  @ColumnInfo(name: 'machine_name')
  String machineName;
  
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

  InstrumentEntity({
    this.id,
    this.serverId,
    required this.machineName,
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
      'machine_name': machineName,
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

  factory InstrumentEntity.fromMap(Map<String, dynamic> map) {
    return InstrumentEntity(
      id: map['id'] as int?,
      serverId: map['server_id'] as int?,
      machineName: map['machine_name'] as String,
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

  factory InstrumentEntity.fromServerMap(Map<String, dynamic> map) {
    return InstrumentEntity(
      serverId: map['id'] as int?,
      machineName: map['machineName'] as String? ?? '',
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