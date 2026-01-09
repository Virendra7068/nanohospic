import 'package:floor/floor.dart';

@Entity(tableName: 'branch_types')
class BranchTypeEntity {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  
  @ColumnInfo(name: 'server_id')
  final int? serverId;
  
  @ColumnInfo(name: 'company_name')
  final String companyName;
  
  @ColumnInfo(name: 'contact_person')
  final String contactPerson;
  
  @ColumnInfo(name: 'contact_no')
  final String contactNo;
  
  @ColumnInfo(name: 'email')
  final String email;
  
  @ColumnInfo(name: 'address1')
  final String address1;
  
  @ColumnInfo(name: 'location')
  final String location;
  
  @ColumnInfo(name: 'type')
  final String type;
  
  @ColumnInfo(name: 'designation')
  final String designation;
  
  @ColumnInfo(name: 'mobile_no')
  final String mobileNo;
  
  @ColumnInfo(name: 'address2')
  final String address2;
  
  @ColumnInfo(name: 'country')
  final String country;
  
  @ColumnInfo(name: 'state')
  final String state;
  
  @ColumnInfo(name: 'city')
  final String city;
  
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

  BranchTypeEntity({
    this.id,
    this.serverId,
    required this.companyName,
    required this.contactPerson,
    required this.contactNo,
    required this.email,
    required this.address1,
    required this.location,
    required this.type,
    required this.designation,
    required this.mobileNo,
    required this.address2,
    required this.country,
    required this.state,
    required this.city,
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
      'company_name': companyName,
      'contact_person': contactPerson,
      'contact_no': contactNo,
      'email': email,
      'address1': address1,
      'location': location,
      'type': type,
      'designation': designation,
      'mobile_no': mobileNo,
      'address2': address2,
      'country': country,
      'state': state,
      'city': city,
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

  factory BranchTypeEntity.fromMap(Map<String, dynamic> map) {
    return BranchTypeEntity(
      id: map['id'],
      serverId: map['server_id'],
      companyName: map['company_name'] ?? '',
      contactPerson: map['contact_person'] ?? '',
      contactNo: map['contact_no'] ?? '',
      email: map['email'] ?? '',
      address1: map['address1'] ?? '',
      location: map['location'] ?? '',
      type: map['type'] ?? '',
      designation: map['designation'] ?? '',
      mobileNo: map['mobile_no'] ?? '',
      address2: map['address2'] ?? '',
      country: map['country'] ?? '',
      state: map['state'] ?? '',
      city: map['city'] ?? '',
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

  BranchTypeEntity copyWith({
    int? id,
    int? serverId,
    String? companyName,
    String? contactPerson,
    String? contactNo,
    String? email,
    String? address1,
    String? location,
    String? type,
    String? designation,
    String? mobileNo,
    String? address2,
    String? country,
    String? state,
    String? city,
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
    return BranchTypeEntity(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      companyName: companyName ?? this.companyName,
      contactPerson: contactPerson ?? this.contactPerson,
      contactNo: contactNo ?? this.contactNo,
      email: email ?? this.email,
      address1: address1 ?? this.address1,
      location: location ?? this.location,
      type: type ?? this.type,
      designation: designation ?? this.designation,
      mobileNo: mobileNo ?? this.mobileNo,
      address2: address2 ?? this.address2,
      country: country ?? this.country,
      state: state ?? this.state,
      city: city ?? this.city,
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