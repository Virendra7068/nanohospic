// lib/model/state_model.dart
import 'package:nanohospic/database/entity/state_entity.dart';

class StateModel {
  final int? id; // Local ID
  final int? serverId; // Server ID
  final String name;
  final int countryId;
  final String? countryName;
  final DateTime? created;
  final String? createdBy;
  final DateTime? lastModified;
  final String? lastModifiedBy;
  final DateTime? deleted;
  final String? deletedBy;
  final bool isSynced;
  final bool isDeleted;
  final String syncStatus; // 'pending', 'synced', 'failed'

  StateModel({
    this.id,
    this.serverId,
    required this.name,
    required this.countryId,
    this.countryName,
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
  factory StateModel.fromJson(Map<String, dynamic> json) {
    return StateModel(
      serverId: json['id'] ?? 0,
      name: json['name'] ?? '',
      countryId: json['countryId'] ?? 0,
      countryName: json['country']?['name'],
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
      'country': countryName != null ? {'name': countryName} : null,
      'created': created?.toIso8601String(),
      'createdBy': createdBy,
      'lastModified': lastModified?.toIso8601String(),
      'lastModifiedBy': lastModifiedBy,
      'deleted': deleted?.toIso8601String(),
      'deletedBy': deletedBy,
    };
  }

  // Convert from entity
  factory StateModel.fromEntity(StateEntity entity) {
    return StateModel(
      id: entity.id,
      serverId: entity.serverId,
      name: entity.name,
      countryId: entity.countryId,
      countryName: entity.countryName,
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
  StateEntity toEntity() {
    return StateEntity(
      id: id,
      serverId: serverId,
      name: name,
      countryId: countryId,
      countryName: countryName,
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
  StateModel copyWith({
    int? id,
    int? serverId,
    String? name,
    int? countryId,
    String? countryName,
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
    return StateModel(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      name: name ?? this.name,
      countryId: countryId ?? this.countryId,
      countryName: countryName ?? this.countryName,
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

  // Helper methods
  bool get isPending => syncStatus == 'pending';
  bool get isFailed => syncStatus == 'failed';
  bool get isSyncedSuccessfully => syncStatus == 'synced';
  bool get needsSync => !isSynced || isPending || isFailed;

  // For UI display
  String get displayName => name;
  String get displayCountry => countryName ?? 'Unknown Country';
  
  // Get sync status icon
  String get syncIcon {
    if (isSyncedSuccessfully) return '✓';
    if (isFailed) return '✗';
    if (isPending) return '↻';
    return '?';
  }

  // Get sync status color
  String get syncColor {
    if (isSyncedSuccessfully) return 'green';
    if (isFailed) return 'red';
    if (isPending) return 'orange';
    return 'grey';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StateModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          serverId == other.serverId &&
          name == other.name &&
          countryId == other.countryId;

  @override
  int get hashCode =>
      id.hashCode ^
      serverId.hashCode ^
      name.hashCode ^
      countryId.hashCode;

  @override
  String toString() {
    return 'StateModel{id: $id, serverId: $serverId, name: $name, countryId: $countryId, syncStatus: $syncStatus}';
  }
}