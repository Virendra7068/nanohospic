import 'package:nanohospic/database/entity/city_entity.dart';
import 'package:nanohospic/model/country_model.dart';
import 'package:nanohospic/model/state_model.dart';

class City {
  final int? id; // Local ID for offline
  final int? serverId; // Server ID after sync
  final String name;
  final int countryId;
  final int stateId;
  final String? countryName;
  final String? stateName;
  final DateTime? created;
  final String? createdBy;
  final DateTime? lastModified;
  final String? lastModifiedBy;
  final DateTime? deleted;
  final String? deletedBy;
  final bool isSynced;
  final bool isDeleted;
  final String syncStatus; // 'pending', 'synced', 'failed'

  City({
    this.id,
    this.serverId,
    required this.name,
    required this.countryId,
    required this.stateId,
    this.countryName,
    this.stateName,
    this.created,
    this.createdBy,
    this.lastModified,
    this.lastModifiedBy,
    this.deleted,
    this.deletedBy,
    this.isSynced = false,
    this.isDeleted = false,
    this.syncStatus = 'pending',
  });

  // Factory method to create from JSON (for API responses)
  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      serverId: json['id'] ?? 0,
      name: json['name'] ?? '',
      countryId: json['countryId'] ?? 0,
      stateId: json['stateId'] ?? 0,
      countryName: json['country']?['name'],
      stateName: json['state']?['name'],
      created: json['created'] != null ? DateTime.parse(json['created']) : null,
      createdBy: json['createdBy'],
      lastModified: json['lastModified'] != null 
          ? DateTime.parse(json['lastModified']) 
          : null,
      lastModifiedBy: json['lastModifiedBy'],
      deleted: json['deleted'] != null ? DateTime.parse(json['deleted']) : null,
      deletedBy: json['deletedBy'],
      isSynced: true,
      syncStatus: 'synced',
    );
  }

  // Convert to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      'id': serverId ?? 0,
      'name': name,
      'countryId': countryId,
      'stateId': stateId,
      'country': countryName != null ? {'name': countryName} : null,
      'state': stateName != null ? {'name': stateName} : null,
      'created': created?.toIso8601String(),
      'createdBy': createdBy,
      'lastModified': lastModified?.toIso8601String(),
      'lastModifiedBy': lastModifiedBy,
      'deleted': deleted?.toIso8601String(),
      'deletedBy': deletedBy,
    };
  }

  // Convert from entity
  factory City.fromEntity(CityEntity entity) {
    return City(
      id: entity.id,
      serverId: entity.serverId,
      name: entity.name,
      countryId: entity.countryId,
      stateId: entity.stateId,
      countryName: entity.countryName,
      stateName: entity.stateName,
      created: entity.createdAt != null ? DateTime.parse(entity.createdAt!) : null,
      createdBy: entity.createdBy,
      lastModified: entity.lastModified != null ? DateTime.parse(entity.lastModified!) : null,
      lastModifiedBy: entity.lastModifiedBy,
      deleted: entity.deletedBy != null ? DateTime.now() : null,
      deletedBy: entity.deletedBy,
      isSynced: entity.isSynced,
      isDeleted: entity.isDeleted,
      syncStatus: entity.syncStatus,
    );
  }

  // Convert to entity
  CityEntity toEntity() {
    return CityEntity(
      id: id,
      serverId: serverId,
      name: name,
      countryId: countryId,
      stateId: stateId,
      countryName: countryName,
      stateName: stateName,
      createdAt: created?.toIso8601String(),
      createdBy: createdBy,
      lastModified: lastModified?.toIso8601String(),
      lastModifiedBy: lastModifiedBy,
      isDeleted: isDeleted,
      deletedBy: deletedBy,
      isSynced: isSynced,
      syncStatus: syncStatus,
    );
  }

  // Copy with method for immutability
  City copyWith({
    int? id,
    int? serverId,
    String? name,
    int? countryId,
    int? stateId,
    String? countryName,
    String? stateName,
    DateTime? created,
    String? createdBy,
    DateTime? lastModified,
    String? lastModifiedBy,
    DateTime? deleted,
    String? deletedBy,
    bool? isSynced,
    bool? isDeleted,
    String? syncStatus,
  }) {
    return City(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      name: name ?? this.name,
      countryId: countryId ?? this.countryId,
      stateId: stateId ?? this.stateId,
      countryName: countryName ?? this.countryName,
      stateName: stateName ?? this.stateName,
      created: created ?? this.created,
      createdBy: createdBy ?? this.createdBy,
      lastModified: lastModified ?? this.lastModified,
      lastModifiedBy: lastModifiedBy ?? this.lastModifiedBy,
      deleted: deleted ?? this.deleted,
      deletedBy: deletedBy ?? this.deletedBy,
      isSynced: isSynced ?? this.isSynced,
      isDeleted: isDeleted ?? this.isDeleted,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }

  // Getter for the original ID (for backward compatibility)
  int get originalId => serverId ?? id ?? 0;

  // Helper methods
  bool get isPending => syncStatus == 'pending';
  bool get isFailed => syncStatus == 'failed';
  bool get isSyncedSuccessfully => syncStatus == 'synced';
  bool get needsSync => !isSynced || isPending || isFailed;

  // For backward compatibility with existing code
  Country? get country {
    if (countryName != null) {
      return Country(
        id: countryId,
        name: countryName!,
        created: created,
        createdBy: createdBy,
        lastModified: lastModified,
        lastModifiedBy: lastModifiedBy,
        deleted: deleted,
        deletedBy: deletedBy,
      );
    }
    return null;
  }

  StateModel? get state {
    if (stateName != null) {
      return StateModel(
        id: stateId,
        serverId: stateId,
        name: stateName!,
        countryId: countryId,
        isSynced: isSynced,
        isDeleted: isDeleted,
        syncStatus: syncStatus,
      );
    }
    return null;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is City &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          serverId == other.serverId &&
          name == other.name &&
          countryId == other.countryId &&
          stateId == other.stateId;

  @override
  int get hashCode =>
      id.hashCode ^
      serverId.hashCode ^
      name.hashCode ^
      countryId.hashCode ^
      stateId.hashCode;

  @override
  String toString() {
    return 'City{id: $id, serverId: $serverId, name: $name, countryId: $countryId, stateId: $stateId, syncStatus: $syncStatus}';
  }
}