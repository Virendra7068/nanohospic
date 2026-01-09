// lib/database/entity/collection_center_entity.dart

import 'package:floor/floor.dart';

@Entity(tableName: 'collection_centers')
class CollectionCenterEntity {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  
  @ColumnInfo(name: 'server_id')
  final int? serverId;
  
  @ColumnInfo(name: 'center_code')
  final String centerCode;
  
  @ColumnInfo(name: 'center_name')
  final String centerName;
  
  @ColumnInfo(name: 'country')
  final String country;
  
  @ColumnInfo(name: 'state')
  final String state;
  
  @ColumnInfo(name: 'city')
  final String city;
  
  @ColumnInfo(name: 'address1')
  final String address1;
  
  @ColumnInfo(name: 'address2')
  final String address2;
  
  @ColumnInfo(name: 'location')
  final String location;
  
  @ColumnInfo(name: 'postal_code')
  final String postalCode;
  
  @ColumnInfo(name: 'latitude')
  final double latitude;
  
  @ColumnInfo(name: 'longitude')
  final double longitude;
  
  @ColumnInfo(name: 'gst_number')
  final String gstNumber;
  
  @ColumnInfo(name: 'pan_number')
  final String panNumber;
  
  @ColumnInfo(name: 'contact_person_name')
  final String contactPersonName;
  
  @ColumnInfo(name: 'phone_no')
  final String phoneNo;
  
  @ColumnInfo(name: 'email')
  final String email;
  
  @ColumnInfo(name: 'centre_status')
  final String centreStatus;
  
  @ColumnInfo(name: 'branch_type_id')
  final int? branchTypeId;
  
  @ColumnInfo(name: 'lab_affiliation_company')
  final String labAffiliationCompany;
  
  @ColumnInfo(name: 'operational_hours_from')
  final String operationalHoursFrom;
  
  @ColumnInfo(name: 'operational_hours_to')
  final String operationalHoursTo;
  
  @ColumnInfo(name: 'collection_days')
  final String collectionDays;
  
  @ColumnInfo(name: 'sample_pickup_timing_from')
  final String samplePickupTimingFrom;
  
  @ColumnInfo(name: 'sample_pickup_timing_to')
  final String samplePickupTimingTo;
  
  @ColumnInfo(name: 'transport_mode')
  final String transportMode;
  
  @ColumnInfo(name: 'courier_agency_name')
  final String courierAgencyName;
  
  @ColumnInfo(name: 'commission_type')
  final String commissionType;
  
  @ColumnInfo(name: 'commission_value')
  final double commissionValue;
  
  @ColumnInfo(name: 'account_holder_name')
  final String accountHolderName;
  
  @ColumnInfo(name: 'account_no')
  final String accountNo;
  
  @ColumnInfo(name: 'ifsc_code')
  final String ifscCode;
  
  @ColumnInfo(name: 'agreement_file1_path')
  final String? agreementFile1Path;
  
  @ColumnInfo(name: 'agreement_file2_path')
  final String? agreementFile2Path;
  
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

  CollectionCenterEntity({
    this.id,
    this.serverId,
    required this.centerCode,
    required this.centerName,
    required this.country,
    required this.state,
    required this.city,
    required this.address1,
    required this.address2,
    required this.location,
    required this.postalCode,
    required this.latitude,
    required this.longitude,
    required this.gstNumber,
    required this.panNumber,
    required this.contactPersonName,
    required this.phoneNo,
    required this.email,
    required this.centreStatus,
    this.branchTypeId,
    required this.labAffiliationCompany,
    required this.operationalHoursFrom,
    required this.operationalHoursTo,
    required this.collectionDays,
    required this.samplePickupTimingFrom,
    required this.samplePickupTimingTo,
    required this.transportMode,
    required this.courierAgencyName,
    required this.commissionType,
    required this.commissionValue,
    required this.accountHolderName,
    required this.accountNo,
    required this.ifscCode,
    this.agreementFile1Path,
    this.agreementFile2Path,
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
      'center_code': centerCode,
      'center_name': centerName,
      'country': country,
      'state': state,
      'city': city,
      'address1': address1,
      'address2': address2,
      'location': location,
      'postal_code': postalCode,
      'latitude': latitude,
      'longitude': longitude,
      'gst_number': gstNumber,
      'pan_number': panNumber,
      'contact_person_name': contactPersonName,
      'phone_no': phoneNo,
      'email': email,
      'centre_status': centreStatus,
      'branch_type_id': branchTypeId,
      'lab_affiliation_company': labAffiliationCompany,
      'operational_hours_from': operationalHoursFrom,
      'operational_hours_to': operationalHoursTo,
      'collection_days': collectionDays,
      'sample_pickup_timing_from': samplePickupTimingFrom,
      'sample_pickup_timing_to': samplePickupTimingTo,
      'transport_mode': transportMode,
      'courier_agency_name': courierAgencyName,
      'commission_type': commissionType,
      'commission_value': commissionValue,
      'account_holder_name': accountHolderName,
      'account_no': accountNo,
      'ifsc_code': ifscCode,
      'agreement_file1_path': agreementFile1Path,
      'agreement_file2_path': agreementFile2Path,
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

  factory CollectionCenterEntity.fromMap(Map<String, dynamic> map) {
    return CollectionCenterEntity(
      id: map['id'],
      serverId: map['server_id'],
      centerCode: map['center_code'] ?? '',
      centerName: map['center_name'] ?? '',
      country: map['country'] ?? '',
      state: map['state'] ?? '',
      city: map['city'] ?? '',
      address1: map['address1'] ?? '',
      address2: map['address2'] ?? '',
      location: map['location'] ?? '',
      postalCode: map['postal_code'] ?? '',
      latitude: (map['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 0.0,
      gstNumber: map['gst_number'] ?? '',
      panNumber: map['pan_number'] ?? '',
      contactPersonName: map['contact_person_name'] ?? '',
      phoneNo: map['phone_no'] ?? '',
      email: map['email'] ?? '',
      centreStatus: map['centre_status'] ?? '',
      branchTypeId: map['branch_type_id'],
      labAffiliationCompany: map['lab_affiliation_company'] ?? '',
      operationalHoursFrom: map['operational_hours_from'] ?? '',
      operationalHoursTo: map['operational_hours_to'] ?? '',
      collectionDays: map['collection_days'] ?? '',
      samplePickupTimingFrom: map['sample_pickup_timing_from'] ?? '',
      samplePickupTimingTo: map['sample_pickup_timing_to'] ?? '',
      transportMode: map['transport_mode'] ?? '',
      courierAgencyName: map['courier_agency_name'] ?? '',
      commissionType: map['commission_type'] ?? '',
      commissionValue: (map['commission_value'] as num?)?.toDouble() ?? 0.0,
      accountHolderName: map['account_holder_name'] ?? '',
      accountNo: map['account_no'] ?? '',
      ifscCode: map['ifsc_code'] ?? '',
      agreementFile1Path: map['agreement_file1_path'],
      agreementFile2Path: map['agreement_file2_path'],
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

  CollectionCenterEntity copyWith({
    int? id,
    int? serverId,
    String? centerCode,
    String? centerName,
    String? country,
    String? state,
    String? city,
    String? address1,
    String? address2,
    String? location,
    String? postalCode,
    double? latitude,
    double? longitude,
    String? gstNumber,
    String? panNumber,
    String? contactPersonName,
    String? phoneNo,
    String? email,
    String? centreStatus,
    int? branchTypeId,
    String? labAffiliationCompany,
    String? operationalHoursFrom,
    String? operationalHoursTo,
    String? collectionDays,
    String? samplePickupTimingFrom,
    String? samplePickupTimingTo,
    String? transportMode,
    String? courierAgencyName,
    String? commissionType,
    double? commissionValue,
    String? accountHolderName,
    String? accountNo,
    String? ifscCode,
    String? agreementFile1Path,
    String? agreementFile2Path,
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
    return CollectionCenterEntity(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      centerCode: centerCode ?? this.centerCode,
      centerName: centerName ?? this.centerName,
      country: country ?? this.country,
      state: state ?? this.state,
      city: city ?? this.city,
      address1: address1 ?? this.address1,
      address2: address2 ?? this.address2,
      location: location ?? this.location,
      postalCode: postalCode ?? this.postalCode,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      gstNumber: gstNumber ?? this.gstNumber,
      panNumber: panNumber ?? this.panNumber,
      contactPersonName: contactPersonName ?? this.contactPersonName,
      phoneNo: phoneNo ?? this.phoneNo,
      email: email ?? this.email,
      centreStatus: centreStatus ?? this.centreStatus,
      branchTypeId: branchTypeId ?? this.branchTypeId,
      labAffiliationCompany: labAffiliationCompany ?? this.labAffiliationCompany,
      operationalHoursFrom: operationalHoursFrom ?? this.operationalHoursFrom,
      operationalHoursTo: operationalHoursTo ?? this.operationalHoursTo,
      collectionDays: collectionDays ?? this.collectionDays,
      samplePickupTimingFrom: samplePickupTimingFrom ?? this.samplePickupTimingFrom,
      samplePickupTimingTo: samplePickupTimingTo ?? this.samplePickupTimingTo,
      transportMode: transportMode ?? this.transportMode,
      courierAgencyName: courierAgencyName ?? this.courierAgencyName,
      commissionType: commissionType ?? this.commissionType,
      commissionValue: commissionValue ?? this.commissionValue,
      accountHolderName: accountHolderName ?? this.accountHolderName,
      accountNo: accountNo ?? this.accountNo,
      ifscCode: ifscCode ?? this.ifscCode,
      agreementFile1Path: agreementFile1Path ?? this.agreementFile1Path,
      agreementFile2Path: agreementFile2Path ?? this.agreementFile2Path,
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