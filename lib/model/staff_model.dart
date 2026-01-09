// model/staff_model.dart
import 'package:nanohospic/database/entity/staff_entity.dart';

class StaffModel {
  final int? id;
  final int? serverId;
  final String name;
  final String department;
  final String designation;
  final String? email;
  final String phone;
  final String requiredCredentials;
  final DateTime createdAt;
  final String? createdBy;
  final DateTime? lastModified;
  final String? lastModifiedBy;
  final bool isDeleted;
  final bool isSynced;
  final String syncStatus;

  StaffModel({
    this.id,
    this.serverId,
    required this.name,
    required this.department,
    required this.designation,
    this.email,
    required this.phone,
    required this.requiredCredentials,
    required this.createdAt,
    this.createdBy,
    this.lastModified,
    this.lastModifiedBy,
    this.isDeleted = false,
    this.isSynced = false,
    this.syncStatus = 'pending',
  });

  factory StaffModel.fromEntity(StaffEntity entity) {
    return StaffModel(
      id: entity.id,
      serverId: entity.serverId,
      name: entity.name,
      department: entity.department,
      designation: entity.designation,
      email: entity.email,
      phone: entity.phone,
      requiredCredentials: entity.requiredCredentials,
      createdAt: DateTime.parse(entity.createdAt),
      createdBy: entity.createdBy,
      lastModified: entity.lastModified != null ? DateTime.parse(entity.lastModified!) : null,
      lastModifiedBy: entity.lastModifiedBy,
      isDeleted: entity.isDeleted == 1,
      isSynced: entity.isSynced == 1,
      syncStatus: entity.syncStatus ?? 'pending',
    );
  }

  StaffEntity toEntity() {
    return StaffEntity(
      id: id,
      serverId: serverId,
      name: name,
      department: department,
      designation: designation,
      email: email,
      phone: phone,
      requiredCredentials: requiredCredentials,
      createdAt: createdAt.toIso8601String(),
      createdBy: createdBy,
      lastModified: lastModified?.toIso8601String(),
      lastModifiedBy: lastModifiedBy,
      isDeleted: isDeleted ? 1 : 0,
      isSynced: isSynced ? 1 : 0,
      syncStatus: syncStatus,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': serverId ?? 0,
      'name': name,
      'department': department,
      'designation': designation,
      'email': email ?? '',
      'phone': phone,
      'requiredCredentials': requiredCredentials,
      'createdAt': createdAt.toIso8601String(),
      'createdBy': createdBy,
      'lastModified': lastModified?.toIso8601String(),
      'lastModifiedBy': lastModifiedBy,
      'isDeleted': isDeleted,
      'isSynced': isSynced,
      'syncStatus': syncStatus,
    };
  }

  factory StaffModel.fromJson(Map<String, dynamic> json) {
    return StaffModel(
      serverId: json['id'] as int?,
      name: json['name'] as String,
      department: json['department'] as String,
      designation: json['designation'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String,
      requiredCredentials: json['requiredCredentials'] as String,
      createdAt: DateTime.parse(json['createdAt']),
      createdBy: json['createdBy'] as String?,
      lastModified: json['lastModified'] != null ? DateTime.parse(json['lastModified']) : null,
      lastModifiedBy: json['lastModifiedBy'] as String?,
      isDeleted: json['isDeleted'] as bool? ?? false,
      isSynced: json['isSynced'] as bool? ?? false,
      syncStatus: json['syncStatus'] as String? ?? 'pending',
    );
  }

  StaffModel copyWith({
    int? id,
    int? serverId,
    String? name,
    String? department,
    String? designation,
    String? email,
    String? phone,
    String? requiredCredentials,
    DateTime? createdAt,
    String? createdBy,
    DateTime? lastModified,
    String? lastModifiedBy,
    bool? isDeleted,
    bool? isSynced,
    String? syncStatus,
  }) {
    return StaffModel(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      name: name ?? this.name,
      department: department ?? this.department,
      designation: designation ?? this.designation,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      requiredCredentials: requiredCredentials ?? this.requiredCredentials,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      lastModified: lastModified ?? this.lastModified,
      lastModifiedBy: lastModifiedBy ?? this.lastModifiedBy,
      isDeleted: isDeleted ?? this.isDeleted,
      isSynced: isSynced ?? this.isSynced,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }
}