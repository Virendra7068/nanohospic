// // lib/database/entity/city_entity.dart
// import 'package:floor/floor.dart';

// @Entity(tableName: 'cities')
// class CityEntity {
//   @PrimaryKey(autoGenerate: true)
//   int? id;
  
//   @ColumnInfo(name: 'server_id')
//   int? serverId;
  
//   String name;
  
//   @ColumnInfo(name: 'country_id')
//   int countryId;
  
//   @ColumnInfo(name: 'state_id')
//   int stateId;
  
//   @ColumnInfo(name: 'country_name')
//   String? countryName;
  
//   @ColumnInfo(name: 'state_name')
//   String? stateName;
  
//   @ColumnInfo(name: 'created_at')
//   String? createdAt;
  
//   @ColumnInfo(name: 'created_by')
//   String? createdBy;
  
//   @ColumnInfo(name: 'last_modified')
//   String? lastModified;
  
//   @ColumnInfo(name: 'last_modified_by')
//   String? lastModifiedBy;
  
//   @ColumnInfo(name: 'is_deleted')
//   bool isDeleted;
  
//   @ColumnInfo(name: 'deleted_by')
//   String? deletedBy;
  
//   @ColumnInfo(name: 'is_synced')
//   bool isSynced;
  
//   @ColumnInfo(name: 'sync_status')
//   String syncStatus; // 'pending', 'synced', 'failed'
  
//   CityEntity({
//     this.id,
//     this.serverId,
//     required this.name,
//     required this.countryId,
//     required this.stateId,
//     this.countryName,
//     this.stateName,
//     this.createdAt,
//     this.createdBy,
//     this.lastModified,
//     this.lastModifiedBy,
//     this.isDeleted = false,
//     this.deletedBy,
//     this.isSynced = false,
//     this.syncStatus = 'pending',
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'server_id': serverId,
//       'name': name,
//       'country_id': countryId,
//       'state_id': stateId,
//       'country_name': countryName,
//       'state_name': stateName,
//       'created_at': createdAt,
//       'created_by': createdBy,
//       'last_modified': lastModified,
//       'last_modified_by': lastModifiedBy,
//       'is_deleted': isDeleted,
//       'deleted_by': deletedBy,
//       'is_synced': isSynced,
//       'sync_status': syncStatus,
//     };
//   }

//   factory CityEntity.fromMap(Map<String, dynamic> map) {
//     return CityEntity(
//       id: map['id'],
//       serverId: map['server_id'],
//       name: map['name'],
//       countryId: map['country_id'],
//       stateId: map['state_id'],
//       countryName: map['country_name'],
//       stateName: map['state_name'],
//       createdAt: map['created_at'],
//       createdBy: map['created_by'],
//       lastModified: map['last_modified'],
//       lastModifiedBy: map['last_modified_by'],
//       isDeleted: map['is_deleted'] == 1,
//       deletedBy: map['deleted_by'],
//       isSynced: map['is_synced'] == 1,
//       syncStatus: map['sync_status'],
//     );
//   }
// }

// lib/database/entity/city_entity.dart
import 'package:floor/floor.dart';

@Entity(tableName: 'cities')
class CityEntity {
  @PrimaryKey(autoGenerate: true)
  int? id;
  
  @ColumnInfo(name: 'server_id')
  int? serverId;
  
  String name;
  
  @ColumnInfo(name: 'country_id')
  int countryId;
  
  @ColumnInfo(name: 'state_id')
  int stateId;
  
  @ColumnInfo(name: 'country_name')
  String? countryName;
  
  @ColumnInfo(name: 'state_name')
  String? stateName;
  
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
  
  CityEntity({
    this.id,
    this.serverId,
    required this.name,
    required this.countryId,
    required this.stateId,
    this.countryName,
    this.stateName,
    this.createdAt,
    this.createdBy,
    this.lastModified,
    this.lastModifiedBy,
    this.isDeleted = false,
    this.deletedBy,
    this.isSynced = false,
    this.syncStatus = 'pending',
  });

  // ✅ ADDED: CopyWith method for easier entity updates
  CityEntity copyWith({
    int? id,
    int? serverId,
    String? name,
    int? countryId,
    int? stateId,
    String? countryName,
    String? stateName,
    String? createdAt,
    String? createdBy,
    String? lastModified,
    String? lastModifiedBy,
    bool? isDeleted,
    String? deletedBy,
    bool? isSynced,
    String? syncStatus,
  }) {
    return CityEntity(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      name: name ?? this.name,
      countryId: countryId ?? this.countryId,
      stateId: stateId ?? this.stateId,
      countryName: countryName ?? this.countryName,
      stateName: stateName ?? this.stateName,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      lastModified: lastModified ?? this.lastModified,
      lastModifiedBy: lastModifiedBy ?? this.lastModifiedBy,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedBy: deletedBy ?? this.deletedBy,
      isSynced: isSynced ?? this.isSynced,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }

  // ✅ FIXED: toMap method to handle boolean properly for database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'server_id': serverId,
      'name': name,
      'country_id': countryId,
      'state_id': stateId,
      'country_name': countryName,
      'state_name': stateName,
      'created_at': createdAt,
      'created_by': createdBy,
      'last_modified': lastModified,
      'last_modified_by': lastModifiedBy,
      'is_deleted': isDeleted ? 1 : 0, // Convert bool to int for database
      'deleted_by': deletedBy,
      'is_synced': isSynced ? 1 : 0, // Convert bool to int for database
      'sync_status': syncStatus,
    };
  }

  // ✅ FIXED: fromMap method to handle boolean properly from database
  factory CityEntity.fromMap(Map<String, dynamic> map) {
    return CityEntity(
      id: map['id'],
      serverId: map['server_id'],
      name: map['name'],
      countryId: map['country_id'] ?? 0, // Provide default value
      stateId: map['state_id'] ?? 0, // Provide default value
      countryName: map['country_name'],
      stateName: map['state_name'],
      createdAt: map['created_at'],
      createdBy: map['created_by'],
      lastModified: map['last_modified'],
      lastModifiedBy: map['last_modified_by'],
      isDeleted: map['is_deleted'] == 1, // Convert int to bool
      deletedBy: map['deleted_by'],
      isSynced: map['is_synced'] == 1, // Convert int to bool
      syncStatus: map['sync_status'] ?? 'pending', // Provide default value
    );
  }

  // ✅ ADDED: Helper method to create entity for API request
  Map<String, dynamic> toApiMap() {
    return {
      if (serverId != null && serverId! > 0) 'id': serverId,
      'name': name,
      'stateId': stateId,
      'countryId': countryId,
      if (stateName != null) 'stateName': stateName,
      if (countryName != null) 'countryName': countryName,
    };
  }

  // ✅ ADDED: Factory method to create entity from API response
  factory CityEntity.fromApiMap(Map<String, dynamic> map) {
    return CityEntity(
      serverId: map['id'],
      name: map['name'] ?? '',
      countryId: map['countryId'] ?? map['country_id'] ?? 0,
      stateId: map['stateId'] ?? map['state_id'] ?? 0,
      countryName: map['countryName'] ?? map['country_name'],
      stateName: map['stateName'] ?? map['state_name'],
      createdAt: map['createdAt'] ?? map['created_at'],
      createdBy: map['createdBy'] ?? map['created_by'],
      lastModified: map['lastModified'] ?? map['last_modified'],
      lastModifiedBy: map['lastModifiedBy'] ?? map['last_modified_by'],
      isSynced: true,
      syncStatus: 'synced',
    );
  }

  // ✅ ADDED: Helper method to check if entity is valid
  bool isValid() {
    return name.isNotEmpty && stateId > 0 && countryId > 0;
  }

  // ✅ ADDED: Helper method to check if entity needs sync
  bool needsSync() {
    return !isSynced || syncStatus == 'pending' || syncStatus == 'failed';
  }

  // ✅ ADDED: Helper method to mark as synced
  CityEntity markAsSynced() {
    return copyWith(
      isSynced: true,
      syncStatus: 'synced',
      lastModified: DateTime.now().toIso8601String(),
      lastModifiedBy: 'system',
    );
  }

  // ✅ ADDED: Helper method to mark as pending
  CityEntity markAsPending() {
    return copyWith(
      isSynced: false,
      syncStatus: 'pending',
      lastModified: DateTime.now().toIso8601String(),
      lastModifiedBy: 'system',
    );
  }

  // ✅ ADDED: Helper method to mark as failed
  CityEntity markAsFailed() {
    return copyWith(
      isSynced: false,
      syncStatus: 'failed',
      lastModified: DateTime.now().toIso8601String(),
      lastModifiedBy: 'system',
    );
  }

  // ✅ ADDED: Helper method to mark as deleted
  CityEntity markAsDeleted({String? deletedBy}) {
    return copyWith(
      isDeleted: true,
      deletedBy: deletedBy ?? 'system',
      lastModified: DateTime.now().toIso8601String(),
      lastModifiedBy: 'system',
      isSynced: false,
      syncStatus: 'pending',
    );
  }

  // ✅ ADDED: Helper method to restore from deleted
  CityEntity restoreFromDeleted() {
    return copyWith(
      isDeleted: false,
      deletedBy: null,
      lastModified: DateTime.now().toIso8601String(),
      lastModifiedBy: 'system',
      isSynced: false,
      syncStatus: 'pending',
    );
  }

  // ✅ ADDED: Override toString for better debugging
  @override
  String toString() {
    return 'CityEntity{id: $id, serverId: $serverId, name: $name, stateId: $stateId, countryId: $countryId, isSynced: $isSynced, syncStatus: $syncStatus}';
  }

  // ✅ ADDED: Override equality check
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CityEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          serverId == other.serverId &&
          name == other.name &&
          stateId == other.stateId &&
          countryId == other.countryId;

  // ✅ ADDED: Override hashCode
  @override
  int get hashCode =>
      id.hashCode ^
      serverId.hashCode ^
      name.hashCode ^
      stateId.hashCode ^
      countryId.hashCode;
}