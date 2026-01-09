// lib/database/entity/state_entity.dart
import 'package:floor/floor.dart';

@Entity(tableName: 'states')
class StateEntity {
  @PrimaryKey(autoGenerate: true)
  int? id;
  
  @ColumnInfo(name: 'server_id')
  int? serverId;
  
  String name;
  
  @ColumnInfo(name: 'country_id')
  int countryId;
  
  @ColumnInfo(name: 'country_name')
  String? countryName;
  
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
  
  StateEntity({
    this.id,
    this.serverId,
    required this.name,
    required this.countryId,
    this.countryName,
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
      'name': name,
      'country_id': countryId,
      'country_name': countryName,
      'created_at': createdAt,
      'created_by': createdBy,
      'last_modified': lastModified,
      'last_modified_by': lastModifiedBy,
      'is_deleted': isDeleted,
      'deleted_by': deletedBy,
      'is_synced': isSynced,
      'sync_status': syncStatus,
    };
  }

  factory StateEntity.fromMap(Map<String, dynamic> map) {
    return StateEntity(
      id: map['id'],
      serverId: map['server_id'],
      name: map['name'],
      countryId: map['country_id'],
      countryName: map['country_name'],
      createdAt: map['created_at'],
      createdBy: map['created_by'],
      lastModified: map['last_modified'],
      lastModifiedBy: map['last_modified_by'],
      isDeleted: map['is_deleted'] == 1,
      deletedBy: map['deleted_by'],
      isSynced: map['is_synced'] == 1,
      syncStatus: map['sync_status'],
    );
  }
}