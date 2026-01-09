// lib/data/local/entity/company_entity.dart
import 'package:floor/floor.dart';
import 'package:intl/intl.dart';

@Entity(tableName: 'companies')
class CompanyEntity {
  @primaryKey
  final int? id;
  final String name;
  final String? tenantId;
  final String? email;
  final String? address1;
  final String? address2;
  final String? location;
  final String? pinCode;
  final String? contactPerson;
  final String? phone;
  final String? mobileNo;
  final String? gstNo;
  final int? companyType;
  final String? branch;
  final String? logoPath;
  final String? description;
  final String? ifssaiNo;
  final String? drugLicNo;
  final String? licenceExpiryDate;
  final String? jurisdiction;
  final int? workingStyle;
  final String? branchCode;
  final int? businessType;
  final int? calanderType;
  final String? yearFrom;
  final String? yearTo;
  final int? taxType;
  final int? countryId;
  final String? countryName;
  final int? stateId;
  final String? stateName;
  final int? cityId;
  final String? cityName;
  
  // Sync fields
  final bool isSynced;
  final bool isDeleted;
  final DateTime lastModified;
  final DateTime createdAt;
  final DateTime? syncedAt;
  final String? syncError;

  CompanyEntity({
    this.id,
    required this.name,
    this.tenantId,
    this.email,
    this.address1,
    this.address2,
    this.location,
    this.pinCode,
    this.contactPerson,
    this.phone,
    this.mobileNo,
    this.gstNo,
    this.companyType,
    this.branch,
    this.logoPath,
    this.description,
    this.ifssaiNo,
    this.drugLicNo,
    this.licenceExpiryDate,
    this.jurisdiction,
    this.workingStyle,
    this.branchCode,
    this.businessType,
    this.calanderType,
    this.yearFrom,
    this.yearTo,
    this.taxType,
    this.countryId,
    this.countryName,
    this.stateId,
    this.stateName,
    this.cityId,
    this.cityName,
    this.isSynced = false,
    this.isDeleted = false,
    required this.lastModified,
    required this.createdAt,
    this.syncedAt,
    this.syncError,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'tenant': {
        'name': name,
        'email': email,
        'address1': address1,
        'address2': address2,
        'location': location,
        'countryId': countryId,
        'country': countryName != null ? {
          'name': countryName,
        } : null,
        'stateId': stateId,
        'state': stateName != null ? {
          'name': stateName,
        } : null,
        'cityId': cityId,
        'city': cityName != null ? {
          'name': cityName,
        } : null,
        'pinCode': pinCode,
        'contactPerson': contactPerson,
        'phone': phone,
        'mobileNo': mobileNo,
        'gstNo': gstNo,
        'companyType': companyType,
        'branch': branch,
        'logo': logoPath != null ? "has_logo" : "",
        'description': description,
        'ifssaiNo': ifssaiNo,
        'drugLicNo': drugLicNo,
        'licenceExpiryDate': licenceExpiryDate,
        'jurisdiction': jurisdiction,
        'workingStyle': workingStyle,
        'branchCode': branchCode,
        'businessType': businessType,
        'calanderType': calanderType,
        'yearFrom': yearFrom,
        'yearTo': yearTo,
        'taxType': taxType,
      },
      'tenantId': tenantId,
      'created': DateFormat('yyyy-MM-ddTHH:mm:ss').format(createdAt),
      'createdBy': 'mobile_app',
      'lastModified': DateFormat('yyyy-MM-ddTHH:mm:ss').format(lastModified),
      'lastModifiedBy': 'mobile_app',
      'deleted': isDeleted ? DateFormat('yyyy-MM-ddTHH:mm:ss').format(lastModified) : null,
      'deletedBy': isDeleted ? 'mobile_app' : null,
    };
  }

  factory CompanyEntity.fromCreateCompanyScreen({
    required String name,
    required String email,
    required String contactPerson,
    String? address1,
    String? address2,
    String? location,
    String? pinCode,
    String? phone,
    String? mobileNo,
    String? gstNo,
    String? branch,
    String? description,
    String? ifssaiNo,
    String? drugLicNo,
    String? jurisdiction,
    String? branchCode,
    String? logoPath,
    int companyType = 1,
    int workingStyle = 1,
    int businessType = 1,
    int calanderType = 1,
    int taxType = 1,
    int countryId = 0,
    int stateId = 0,
    int cityId = 0,
    String countryName = "",
    String stateName = "",
    String cityName = "",
  }) {
    final now = DateTime.now();
    final nextYear = now.add(const Duration(days: 365));
    
    return CompanyEntity(
      name: name,
      email: email,
      address1: address1,
      address2: address2,
      location: location,
      pinCode: pinCode,
      contactPerson: contactPerson,
      phone: phone,
      mobileNo: mobileNo,
      gstNo: gstNo,
      companyType: companyType,
      branch: branch,
      logoPath: logoPath,
      description: description,
      ifssaiNo: ifssaiNo,
      drugLicNo: drugLicNo,
      licenceExpiryDate: DateFormat('yyyy-MM-ddTHH:mm:ss').format(nextYear),
      jurisdiction: jurisdiction,
      workingStyle: workingStyle,
      branchCode: branchCode,
      businessType: businessType,
      calanderType: calanderType,
      yearFrom: DateFormat('yyyy-MM-ddTHH:mm:ss').format(now),
      yearTo: DateFormat('yyyy-MM-ddTHH:mm:ss').format(nextYear),
      taxType: taxType,
      countryId: countryId,
      countryName: countryName,
      stateId: stateId,
      stateName: stateName,
      cityId: cityId,
      cityName: cityName,
      lastModified: now,
      createdAt: now,
      isSynced: false,
    );
  }

  factory CompanyEntity.fromApiResponse(Map<String, dynamic> json) {
    final tenant = json['tenant'] as Map<String, dynamic>?;
    
    return CompanyEntity(
      id: json['id'] as int?,
      name: json['name'] as String,
      tenantId: json['tenantId'] as String?,
      email: tenant?['email'] as String?,
      address1: tenant?['address1'] as String?,
      address2: tenant?['address2'] as String?,
      location: tenant?['location'] as String?,
      pinCode: tenant?['pinCode'] as String?,
      contactPerson: tenant?['contactPerson'] as String?,
      phone: tenant?['phone'] as String?,
      mobileNo: tenant?['mobileNo'] as String?,
      gstNo: tenant?['gstNo'] as String?,
      companyType: tenant?['companyType'] as int?,
      branch: tenant?['branch'] as String?,
      description: tenant?['description'] as String?,
      ifssaiNo: tenant?['ifssaiNo'] as String?,
      drugLicNo: tenant?['drugLicNo'] as String?,
      licenceExpiryDate: tenant?['licenceExpiryDate'] as String?,
      jurisdiction: tenant?['jurisdiction'] as String?,
      workingStyle: tenant?['workingStyle'] as int?,
      branchCode: tenant?['branchCode'] as String?,
      businessType: tenant?['businessType'] as int?,
      calanderType: tenant?['calanderType'] as int?,
      yearFrom: tenant?['yearFrom'] as String?,
      yearTo: tenant?['yearTo'] as String?,
      taxType: tenant?['taxType'] as int?,
      countryId: tenant?['countryId'] as int?,
      stateId: tenant?['stateId'] as int?,
      cityId: tenant?['cityId'] as int?,
      countryName: (tenant?['country'] as Map<String, dynamic>?)?['name'] as String?,
      stateName: (tenant?['state'] as Map<String, dynamic>?)?['name'] as String?,
      cityName: (tenant?['city'] as Map<String, dynamic>?)?['name'] as String?,
      lastModified: DateTime.parse(json['lastModified'] as String? ?? DateTime.now().toIso8601String()),
      createdAt: DateTime.parse(json['created'] as String? ?? DateTime.now().toIso8601String()),
      isSynced: true,
      syncedAt: DateTime.now(),
    );
  }

  CompanyEntity copyWith({
    int? id,
    String? name,
    String? tenantId,
    String? email,
    String? address1,
    String? address2,
    String? location,
    String? pinCode,
    String? contactPerson,
    String? phone,
    String? mobileNo,
    String? gstNo,
    int? companyType,
    String? branch,
    String? logoPath,
    String? description,
    String? ifssaiNo,
    String? drugLicNo,
    String? licenceExpiryDate,
    String? jurisdiction,
    int? workingStyle,
    String? branchCode,
    int? businessType,
    int? calanderType,
    String? yearFrom,
    String? yearTo,
    int? taxType,
    int? countryId,
    String? countryName,
    int? stateId,
    String? stateName,
    int? cityId,
    String? cityName,
    bool? isSynced,
    bool? isDeleted,
    DateTime? lastModified,
    DateTime? createdAt,
    DateTime? syncedAt,
    String? syncError,
  }) {
    return CompanyEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      tenantId: tenantId ?? this.tenantId,
      email: email ?? this.email,
      address1: address1 ?? this.address1,
      address2: address2 ?? this.address2,
      location: location ?? this.location,
      pinCode: pinCode ?? this.pinCode,
      contactPerson: contactPerson ?? this.contactPerson,
      phone: phone ?? this.phone,
      mobileNo: mobileNo ?? this.mobileNo,
      gstNo: gstNo ?? this.gstNo,
      companyType: companyType ?? this.companyType,
      branch: branch ?? this.branch,
      logoPath: logoPath ?? this.logoPath,
      description: description ?? this.description,
      ifssaiNo: ifssaiNo ?? this.ifssaiNo,
      drugLicNo: drugLicNo ?? this.drugLicNo,
      licenceExpiryDate: licenceExpiryDate ?? this.licenceExpiryDate,
      jurisdiction: jurisdiction ?? this.jurisdiction,
      workingStyle: workingStyle ?? this.workingStyle,
      branchCode: branchCode ?? this.branchCode,
      businessType: businessType ?? this.businessType,
      calanderType: calanderType ?? this.calanderType,
      yearFrom: yearFrom ?? this.yearFrom,
      yearTo: yearTo ?? this.yearTo,
      taxType: taxType ?? this.taxType,
      countryId: countryId ?? this.countryId,
      countryName: countryName ?? this.countryName,
      stateId: stateId ?? this.stateId,
      stateName: stateName ?? this.stateName,
      cityId: cityId ?? this.cityId,
      cityName: cityName ?? this.cityName,
      isSynced: isSynced ?? this.isSynced,
      isDeleted: isDeleted ?? this.isDeleted,
      lastModified: lastModified ?? this.lastModified,
      createdAt: createdAt ?? this.createdAt,
      syncedAt: syncedAt ?? this.syncedAt,
      syncError: syncError ?? this.syncError,
    );
  }
}