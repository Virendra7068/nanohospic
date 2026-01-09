// // database/entity/client_entity.dart
// import 'package:floor/floor.dart';

// @Entity(tableName: 'client')
// class ClientEntity {
//   @PrimaryKey(autoGenerate: true)
//   final int? id;
  
//   @ColumnInfo(name: 'server_id')
//   final int? serverId;
  
//   @ColumnInfo(name: 'business_name')
//   final String businessName;
  
//   @ColumnInfo(name: 'postal_code')
//   final String postalCode;
  
//   @ColumnInfo(name: 'address1')
//   final String address1;
  
//   @ColumnInfo(name: 'contact_person_name')
//   final String contactPersonName;
  
//   @ColumnInfo(name: 'location')
//   final String location;

//   @ColumnInfo(name: 'country')
//   final String country;

//   @ColumnInfo(name: 'phone')
//   final String phone;

//   @ColumnInfo(name: 'state')
//   final String state;
  
//   @ColumnInfo(name: 'city')
//   final String city;
  
//   @ColumnInfo(name: 'required_credentials')
//   final String requiredCredentials;
  
//   @ColumnInfo(name: 'created_at')
//   final String createdAt;
  
//   @ColumnInfo(name: 'created_by')
//   final String? createdBy;
  
//   @ColumnInfo(name: 'last_modified')
//   final String? lastModified;
  
//   @ColumnInfo(name: 'last_modified_by')
//   final String? lastModifiedBy;
  
//   @ColumnInfo(name: 'is_deleted')
//   final int isDeleted;
  
//   @ColumnInfo(name: 'deleted_by')
//   final String? deletedBy;
  
//   @ColumnInfo(name: 'is_synced')
//   final int isSynced;
  
//   @ColumnInfo(name: 'sync_status')
//   final String? syncStatus;
  
//   @ColumnInfo(name: 'sync_attempts')
//   final int syncAttempts;
  
//   @ColumnInfo(name: 'last_sync_error')
//   final String? lastSyncError;

//   ClientEntity({
//     this.id,
//     this.serverId,
//     required this.businessName,
//     required this.postalCode,
//     required this.address1,
//     required this.contactPersonName,
//     required this.location,
//     required this.country,
//     required this.phone,
//     required this.state,
//     required this.city,
//     required this.requiredCredentials,
//     required this.createdAt,
//     this.createdBy,
//     this.lastModified,
//     this.lastModifiedBy,
//     this.isDeleted = 0,
//     this.deletedBy,
//     this.isSynced = 0,
//     this.syncStatus = 'pending',
//     this.syncAttempts = 0,
//     this.lastSyncError,
//   });

//   ClientEntity copyWith({
//     int? id,
//     int? serverId,
//     String? businessName,
//     String? postalCode,
//     String? address1,
//     String? contactPersonName,
//     String? location,
//     String? country,
//     String? phone,
//     String? state,
//     String? city,
//     String? requiredCredentials,
//     String? createdAt,
//     String? createdBy,
//     String? lastModified,
//     String? lastModifiedBy,
//     int? isDeleted,
//     String? deletedBy,
//     int? isSynced,
//     String? syncStatus,
//     int? syncAttempts,
//     String? lastSyncError,
//   }) {
//     return ClientEntity(
//       id: id ?? this.id,
//       serverId: serverId ?? this.serverId,
//       businessName: businessName ?? this.businessName,
//       postalCode: postalCode ?? this.postalCode,
//       address1: address1 ?? this.address1,
//       contactPersonName: contactPersonName ?? this.contactPersonName,
//       location: location ?? this.location,
//       country: country ?? this.country,
//       phone: phone ?? this.phone,
//       state: state ?? this.state,
//       city: city ?? this.city,
//       requiredCredentials: requiredCredentials ?? this.requiredCredentials,
//       createdAt: createdAt ?? this.createdAt,
//       createdBy: createdBy ?? this.createdBy,
//       lastModified: lastModified ?? this.lastModified,
//       lastModifiedBy: lastModifiedBy ?? this.lastModifiedBy,
//       isDeleted: isDeleted ?? this.isDeleted,
//       deletedBy: deletedBy ?? this.deletedBy,
//       isSynced: isSynced ?? this.isSynced,
//       syncStatus: syncStatus ?? this.syncStatus,
//       syncAttempts: syncAttempts ?? this.syncAttempts,
//       lastSyncError: lastSyncError ?? this.lastSyncError,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': serverId ?? 0,
//       'businessName': businessName,
//       'postalCode': postalCode,
//       'address1': address1,
//       'contactPersonName': contactPersonName,
//       'location': location,
//       'country': country,
//       'phone': phone,
//       'state': state,
//       'city': city,
//       'requiredCredentials': requiredCredentials,
//       'createdAt': createdAt,
//       'createdBy': createdBy,
//       'lastModified': lastModified,
//       'lastModifiedBy': lastModifiedBy,
//       'isDeleted': isDeleted == 1,
//       'deletedBy': deletedBy,
//       'isSynced': isSynced == 1,
//       'syncStatus': syncStatus,
//       'syncAttempts': syncAttempts,
//       'lastSyncError': lastSyncError,
//     };
//   }

//   factory ClientEntity.fromJson(Map<String, dynamic> json) {
//     return ClientEntity(
//       serverId: json['id'] as int?,
//       businessName: json['businessName'] as String,
//       postalCode: json['postalCode'] as String,
//       address1: json['address1'] as String,
//       contactPersonName: json['contactPersonName'] as String,
//       location: json['location'] as String,
//       country: json['country'] as String,
//       phone: json['phone'] as String,
//       state: json['state'] as String,
//       city: json['city'] as String,
//       requiredCredentials: json['requiredCredentials'] as String,
//       createdAt: json['createdAt'] as String,
//       createdBy: json['createdBy'] as String?,
//       lastModified: json['lastModified'] as String?,
//       lastModifiedBy: json['lastModifiedBy'] as String?,
//       isDeleted: (json['isDeleted'] as bool? ?? false) ? 1 : 0,
//       deletedBy: json['deletedBy'] as String?,
//       isSynced: (json['isSynced'] as bool? ?? false) ? 1 : 0,
//       syncStatus: json['syncStatus'] as String?,
//       syncAttempts: json['syncAttempts'] as int? ?? 0,
//       lastSyncError: json['lastSyncError'] as String?,
//     );
//   }

//   factory ClientEntity.fromServerJson(Map<String, dynamic> json) {
//     return ClientEntity(
//       serverId: json['id'] as int?,
//       businessName: json['businessName'] as String? ?? '',
//       postalCode: json['postalCode'] as String? ?? '',
//       address1: json['address1'] as String? ?? '',
//       contactPersonName: json['contactPersonName'] as String? ?? '',
//       location: json['location'] as String? ?? '',
//       country: json['country'] as String? ?? '',
//       phone: json['phone'] as String? ?? '',
//       state: json['state'] as String? ?? '',
//       city: json['city'] as String? ?? '',
//       requiredCredentials: json['requiredCredentials'] as String? ?? '',
//       createdAt: json['createdAt'] as String? ?? DateTime.now().toIso8601String(),
//       createdBy: json['createdBy'] as String?,
//       lastModified: json['lastModified'] as String?,
//       lastModifiedBy: json['lastModifiedBy'] as String?,
//       isDeleted: (json['isDeleted'] as bool? ?? false) ? 1 : 0,
//       deletedBy: json['deletedBy'] as String?,
//       isSynced: 1, // From server means it's synced
//       syncStatus: 'synced',
//       syncAttempts: 0,
//       lastSyncError: null,
//     );
//   }
// }