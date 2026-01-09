// lib/database/entity/country_entity.dart
import 'package:floor/floor.dart';
import 'package:nanohospic/model/country_model.dart';

@Entity(tableName: 'countries')
class CountryEntity {
  @PrimaryKey(autoGenerate: true)
  int? id;

  @ColumnInfo(name: 'server_id')
  int? serverId;
  String name;

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

  CountryEntity({
    this.id,
    this.serverId,
    required this.name,
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

  factory CountryEntity.fromMap(Map<String, dynamic> map) {
    return CountryEntity(
      id: map['id'],
      serverId: map['server_id'],
      name: map['name'],
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

  Country toCountry() {
    return Country(
      id: serverId ?? 0,
      name: name,
      created: createdAt != null ? DateTime.parse(createdAt!) : null,
      createdBy: createdBy,
      lastModified: lastModified != null ? DateTime.parse(lastModified!) : null,
      lastModifiedBy: lastModifiedBy,
      deleted: null,
      deletedBy: null,
    );
  }
}
