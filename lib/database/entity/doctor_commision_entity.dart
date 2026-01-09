// lib/database/entity/doctor_commission_entity.dart
import 'package:floor/floor.dart';

@Entity(tableName: 'doctor_commissions')
class DoctorCommissionEntity {
  @PrimaryKey(autoGenerate: true)
  int? id;

  @ColumnInfo(name: 'server_id')
  int? serverId;

  @ColumnInfo(name: 'doctor_name')
  String doctorName;

  String initials;
  
  @ColumnInfo(name: 'contact_no')
  String contactNo;
  
  String email;
  
  @ColumnInfo(name: 'work_station')
  String workStation;
  
  @ColumnInfo(name: 'referrer_id')
  int? referrerId;
  
  @ColumnInfo(name: 'referrer_name')
  String referrerName;
  
  @ColumnInfo(name: 'commission_for')
  String commissionFor; // OPD, IPD, etc.
  
  @ColumnInfo(name: 'commission_type')
  String commissionType; // Percentage, Fixed Amount
  
  double percentage;
  
  double value;
  
  String remarks;
  
  String status; // Active, Inactive
  
  @ColumnInfo(name: 'center_id')
  int centerId;
  
  @ColumnInfo(name: 'center_name')
  String centerName;

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

  DoctorCommissionEntity({
    this.id,
    this.serverId,
    required this.doctorName,
    required this.initials,
    required this.contactNo,
    required this.email,
    required this.workStation,
    this.referrerId,
    required this.referrerName,
    required this.commissionFor,
    required this.commissionType,
    required this.percentage,
    required this.value,
    required this.remarks,
    required this.status,
    required this.centerId,
    required this.centerName,
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
      'doctor_name': doctorName,
      'initials': initials,
      'contact_no': contactNo,
      'email': email,
      'work_station': workStation,
      'referrer_id': referrerId,
      'referrer_name': referrerName,
      'commission_for': commissionFor,
      'commission_type': commissionType,
      'percentage': percentage,
      'value': value,
      'remarks': remarks,
      'status': status,
      'center_id': centerId,
      'center_name': centerName,
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

  factory DoctorCommissionEntity.fromMap(Map<String, dynamic> map) {
    return DoctorCommissionEntity(
      id: map['id'],
      serverId: map['server_id'],
      doctorName: map['doctor_name'] ?? '',
      initials: map['initials'] ?? '',
      contactNo: map['contact_no'] ?? '',
      email: map['email'] ?? '',
      workStation: map['work_station'] ?? '',
      referrerId: map['referrer_id'],
      referrerName: map['referrer_name'] ?? '',
      commissionFor: map['commission_for'] ?? '',
      commissionType: map['commission_type'] ?? 'Percentage',
      percentage: (map['percentage'] as num?)?.toDouble() ?? 0.0,
      value: (map['value'] as num?)?.toDouble() ?? 0.0,
      remarks: map['remarks'] ?? '',
      status: map['status'] ?? 'Active',
      centerId: map['center_id'] ?? 0,
      centerName: map['center_name'] ?? '',
      createdAt: map['created_at'],
      createdBy: map['created_by'],
      lastModified: map['last_modified'],
      lastModifiedBy: map['last_modified_by'],
      isDeleted: map['is_deleted'] == 1,
      deletedBy: map['deleted_by'],
      isSynced: map['is_synced'] == 1,
      syncStatus: map['sync_status'] ?? 'pending',
    );
  }

  // Convert to DoctorCommission model if needed
  // DoctorCommission toDoctorCommission() {
  //   return DoctorCommission(
  //     id: serverId ?? 0,
  //     doctorName: doctorName,
  //     initials: initials,
  //     contactNo: contactNo,
  //     email: email,
  //     workStation: workStation,
  //     referrerId: referrerId,
  //     referrerName: referrerName,
  //     commissionFor: commissionFor,
  //     commissionType: commissionType,
  //     percentage: percentage,
  //     value: value,
  //     remarks: remarks,
  //     status: status,
  //     centerId: centerId,
  //     centerName: centerName,
  //     created: createdAt != null ? DateTime.parse(createdAt!) : null,
  //     createdBy: createdBy,
  //     lastModified: lastModified != null ? DateTime.parse(lastModified!) : null,
  //     lastModifiedBy: lastModifiedBy,
  //   );
  // }
}