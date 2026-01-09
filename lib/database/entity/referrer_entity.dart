// lib/database/entity/referrer_entity.dart

import 'package:floor/floor.dart';

@Entity(tableName: 'referrers')
class ReferrerEntity {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  
  @ColumnInfo(name: 'server_id')
  final int? serverId;
  
  @ColumnInfo(name: 'name')
  final String name;
  
  @ColumnInfo(name: 'dob')
  final String dob;
  
  @ColumnInfo(name: 'marriage_anniversary')
  final String marriageAnniversary;
  
  @ColumnInfo(name: 'work_station')
  final String workStation;
  
  @ColumnInfo(name: 'clinic_address')
  final String clinicAddress;
  
  @ColumnInfo(name: 'clinic_phone')
  final String clinicPhone;
  
  @ColumnInfo(name: 'hospital_name')
  final String hospitalName;
  
  @ColumnInfo(name: 'hospital_address')
  final String hospitalAddress;
  
  @ColumnInfo(name: 'hospital_phone')
  final String hospitalPhone;
  
  @ColumnInfo(name: 'email')
  final String email;
  
  @ColumnInfo(name: 'contact_no')
  final String contactNo;
  
  @ColumnInfo(name: 'specialization')
  final String specialization;
  
  @ColumnInfo(name: 'remarks')
  final String remarks;
  
  @ColumnInfo(name: 'registration_no')
  final String registrationNo;
  
  @ColumnInfo(name: 'degree')
  final String degree;
  
  @ColumnInfo(name: 'tag_status')
  final String tagStatus;
  
  @ColumnInfo(name: 'center_id')
  final int? centerId;
  
  @ColumnInfo(name: 'center_name')
  final String centerName;
  
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
  final String syncStatus;
  
  @ColumnInfo(name: 'sync_attempts')
  final int syncAttempts;
  
  @ColumnInfo(name: 'last_sync_error')
  final String? lastSyncError;

  ReferrerEntity({
    this.id,
    this.serverId,
    required this.name,
    required this.dob,
    required this.marriageAnniversary,
    required this.workStation,
    required this.clinicAddress,
    required this.clinicPhone,
    required this.hospitalName,
    required this.hospitalAddress,
    required this.hospitalPhone,
    required this.email,
    required this.contactNo,
    required this.specialization,
    required this.remarks,
    required this.registrationNo,
    required this.degree,
    required this.tagStatus,
    this.centerId,
    required this.centerName,
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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'server_id': serverId,
      'name': name,
      'dob': dob,
      'marriage_anniversary': marriageAnniversary,
      'work_station': workStation,
      'clinic_address': clinicAddress,
      'clinic_phone': clinicPhone,
      'hospital_name': hospitalName,
      'hospital_address': hospitalAddress,
      'hospital_phone': hospitalPhone,
      'email': email,
      'contact_no': contactNo,
      'specialization': specialization,
      'remarks': remarks,
      'registration_no': registrationNo,
      'degree': degree,
      'tag_status': tagStatus,
      'center_id': centerId,
      'center_name': centerName,
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

  factory ReferrerEntity.fromMap(Map<String, dynamic> map) {
    return ReferrerEntity(
      id: map['id'],
      serverId: map['server_id'],
      name: map['name'] ?? '',
      dob: map['dob'] ?? '',
      marriageAnniversary: map['marriage_anniversary'] ?? '',
      workStation: map['work_station'] ?? '',
      clinicAddress: map['clinic_address'] ?? '',
      clinicPhone: map['clinic_phone'] ?? '',
      hospitalName: map['hospital_name'] ?? '',
      hospitalAddress: map['hospital_address'] ?? '',
      hospitalPhone: map['hospital_phone'] ?? '',
      email: map['email'] ?? '',
      contactNo: map['contact_no'] ?? '',
      specialization: map['specialization'] ?? '',
      remarks: map['remarks'] ?? '',
      registrationNo: map['registration_no'] ?? '',
      degree: map['degree'] ?? '',
      tagStatus: map['tag_status'] ?? '',
      centerId: map['center_id'],
      centerName: map['center_name'] ?? '',
      createdAt: map['created_at'],
      createdBy: map['created_by'],
      lastModified: map['last_modified'],
      lastModifiedBy: map['last_modified_by'],
      isDeleted: map['is_deleted'] ?? 0,
      deletedBy: map['deleted_by'],
      isSynced: map['is_synced'] ?? 0,
      syncStatus: map['sync_status'] ?? 'pending',
      syncAttempts: map['sync_attempts'] ?? 0,
      lastSyncError: map['last_sync_error'],
    );
  }

  ReferrerEntity copyWith({
    int? id,
    int? serverId,
    String? name,
    String? dob,
    String? marriageAnniversary,
    String? workStation,
    String? clinicAddress,
    String? clinicPhone,
    String? hospitalName,
    String? hospitalAddress,
    String? hospitalPhone,
    String? email,
    String? contactNo,
    String? specialization,
    String? remarks,
    String? registrationNo,
    String? degree,
    String? tagStatus,
    int? centerId,
    String? centerName,
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
    return ReferrerEntity(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      name: name ?? this.name,
      dob: dob ?? this.dob,
      marriageAnniversary: marriageAnniversary ?? this.marriageAnniversary,
      workStation: workStation ?? this.workStation,
      clinicAddress: clinicAddress ?? this.clinicAddress,
      clinicPhone: clinicPhone ?? this.clinicPhone,
      hospitalName: hospitalName ?? this.hospitalName,
      hospitalAddress: hospitalAddress ?? this.hospitalAddress,
      hospitalPhone: hospitalPhone ?? this.hospitalPhone,
      email: email ?? this.email,
      contactNo: contactNo ?? this.contactNo,
      specialization: specialization ?? this.specialization,
      remarks: remarks ?? this.remarks,
      registrationNo: registrationNo ?? this.registrationNo,
      degree: degree ?? this.degree,
      tagStatus: tagStatus ?? this.tagStatus,
      centerId: centerId ?? this.centerId,
      centerName: centerName ?? this.centerName,
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
}