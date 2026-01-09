// test_bom_entity.dart
import 'package:floor/floor.dart';
import 'dart:convert';

@Entity(tableName: 'test_boms')
class TestBOM {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  
  @ColumnInfo(name: 'server_id')
  final int? serverId;
  
  @ColumnInfo(name: 'code')
  final String code;
  
  @ColumnInfo(name: 'name')
  final String name;
  
  @ColumnInfo(name: 'test_group')
  final String testGroup;
  
  @ColumnInfo(name: 'gender_type')
  final String genderType;
  
  @ColumnInfo(name: 'description')
  final String? description;
  
  @ColumnInfo(name: 'rate')
  final double rate;
  
  @ColumnInfo(name: 'gst')
  final double gst;
  
  @ColumnInfo(name: 'turn_around_time')
  final String turnAroundTime;
  
  @ColumnInfo(name: 'time_unit')
  final String timeUnit;
  
  @ColumnInfo(name: 'is_active')
  final int isActive; 
  
  @ColumnInfo(name: 'method')
  final String? method;
  
  @ColumnInfo(name: 'reference_range')
  final String? referenceRange;
  
  @ColumnInfo(name: 'clinical_significance')
  final String? clinicalSignificance;
  
  @ColumnInfo(name: 'specimen_requirement')
  final String? specimenRequirement;
  
  @ColumnInfo(name: 'created_at')
  final String createdAt;
  
  @ColumnInfo(name: 'created_by')
  final String createdBy;
  
  @ColumnInfo(name: 'last_modified')
  final String? lastModified;
  
  @ColumnInfo(name: 'last_modified_by')
  final String? lastModifiedBy;
  
  @ColumnInfo(name: 'is_deleted')
  final int isDeleted;  // Changed to int for database storage (0 or 1)
  
  @ColumnInfo(name: 'deleted_by')
  final String? deletedBy;
  
  @ColumnInfo(name: 'is_synced')
  final int isSynced;  // Changed to int for database storage (0 or 1)
  
  @ColumnInfo(name: 'sync_status')
  final String syncStatus;
  
  @ColumnInfo(name: 'sync_attempts')
  final int syncAttempts;
  
  @ColumnInfo(name: 'last_sync_error')
  final String? lastSyncError;
  
  @ColumnInfo(name: 'parameters')
  final String parameters; // JSON string of TestParameter list

  TestBOM({
    this.id,
    this.serverId,
    required this.code,
    required this.name,
    required this.testGroup,
    required this.genderType,
    this.description,
    required this.rate,
    required this.gst,
    required this.turnAroundTime,
    required this.timeUnit,
    required this.isActive,
    this.method,
    this.referenceRange,
    this.clinicalSignificance,
    this.specimenRequirement,
    required this.createdAt,
    required this.createdBy,
    this.lastModified,
    this.lastModifiedBy,
    this.isDeleted = 0,
    this.deletedBy,
    this.isSynced = 0,
    this.syncStatus = 'pending',
    this.syncAttempts = 0,
    this.lastSyncError,
    required this.parameters,
  });

  // Add a factory constructor for easier creation
  factory TestBOM.create({
    String? code,
    required String name,
    required String testGroup,
    required String genderType,
    String? description,
    required double rate,
    required double gst,
    required String turnAroundTime,
    required String timeUnit,
    bool isActive = true,
    String? method,
    String? referenceRange,
    String? clinicalSignificance,
    String? specimenRequirement,
    DateTime? createdAt,
    String? createdBy,
    List<TestParameter> parameters = const [],
  }) {
    return TestBOM(
      code: code ?? 'TEST-${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      testGroup: testGroup,
      genderType: genderType,
      description: description,
      rate: rate,
      gst: gst,
      turnAroundTime: turnAroundTime,
      timeUnit: timeUnit,
      isActive: isActive ? 1 : 0,
      method: method,
      referenceRange: referenceRange,
      clinicalSignificance: clinicalSignificance,
      specimenRequirement: specimenRequirement,
      createdAt: (createdAt ?? DateTime.now()).toIso8601String(),
      createdBy: createdBy ?? 'system',
      parameters: TestBOM.parametersToJson(parameters),
    );
  }

  // Helper getter for boolean fields (ignored by database)
  @ignore
  bool get isActiveBool => isActive == 1;
  
  @ignore
  bool get isDeletedBool => isDeleted == 1;
  
  @ignore
  bool get isSyncedBool => isSynced == 1;

  // Helper method to convert parameters JSON to List<TestParameter>
  @ignore
  List<TestParameter> get parametersList {
    try {
      if (parameters.isEmpty) return [];
      final List<dynamic> jsonList = json.decode(parameters);
      return jsonList.map((json) => TestParameter.fromJson(json)).toList();
    } catch (e) {
      print('Error parsing parameters: $e');
      return [];
    }
  }

  // Helper method to set parameters from List<TestParameter>
  @ignore
  static String parametersToJson(List<TestParameter> parameters) {
    if (parameters.isEmpty) return '[]';
    return json.encode(parameters.map((p) => p.toJson()).toList());
  }

  // Convenience getter for gender type as enum
  @ignore
  GenderType get genderTypeEnum {
    return GenderType.fromString(genderType);
  }

  // Copy with method for updates
  TestBOM copyWith({
    int? id,
    int? serverId,
    String? code,
    String? name,
    String? testGroup,
    String? genderType,
    String? description,
    double? rate,
    double? gst,
    String? turnAroundTime,
    String? timeUnit,
    bool? isActive,
    String? method,
    String? referenceRange,
    String? clinicalSignificance,
    String? specimenRequirement,
    String? createdAt,
    String? createdBy,
    String? lastModified,
    String? lastModifiedBy,
    bool? isDeleted,
    String? deletedBy,
    bool? isSynced,
    String? syncStatus,
    int? syncAttempts,
    String? lastSyncError,
    List<TestParameter>? parameters,
  }) {
    return TestBOM(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      code: code ?? this.code,
      name: name ?? this.name,
      testGroup: testGroup ?? this.testGroup,
      genderType: genderType ?? this.genderType,
      description: description ?? this.description,
      rate: rate ?? this.rate,
      gst: gst ?? this.gst,
      turnAroundTime: turnAroundTime ?? this.turnAroundTime,
      timeUnit: timeUnit ?? this.timeUnit,
      isActive: isActive != null ? (isActive ? 1 : 0) : this.isActive,
      method: method ?? this.method,
      referenceRange: referenceRange ?? this.referenceRange,
      clinicalSignificance: clinicalSignificance ?? this.clinicalSignificance,
      specimenRequirement: specimenRequirement ?? this.specimenRequirement,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      lastModified: lastModified ?? this.lastModified,
      lastModifiedBy: lastModifiedBy ?? this.lastModifiedBy,
      isDeleted: isDeleted != null ? (isDeleted ? 1 : 0) : this.isDeleted,
      deletedBy: deletedBy ?? this.deletedBy,
      isSynced: isSynced != null ? (isSynced ? 1 : 0) : this.isSynced,
      syncStatus: syncStatus ?? this.syncStatus,
      syncAttempts: syncAttempts ?? this.syncAttempts,
      lastSyncError: lastSyncError ?? this.lastSyncError,
      parameters: parameters != null ? TestBOM.parametersToJson(parameters) : this.parameters,
    );
  }

  // Convert to map for JSON serialization
  @ignore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'serverId': serverId,
      'code': code,
      'name': name,
      'testGroup': testGroup,
      'genderType': genderType,
      'description': description,
      'rate': rate,
      'gst': gst,
      'turnAroundTime': turnAroundTime,
      'timeUnit': timeUnit,
      'isActive': isActiveBool,
      'method': method,
      'referenceRange': referenceRange,
      'clinicalSignificance': clinicalSignificance,
      'specimenRequirement': specimenRequirement,
      'createdAt': createdAt,
      'createdBy': createdBy,
      'lastModified': lastModified,
      'lastModifiedBy': lastModifiedBy,
      'isDeleted': isDeletedBool,
      'deletedBy': deletedBy,
      'isSynced': isSyncedBool,
      'syncStatus': syncStatus,
      'syncAttempts': syncAttempts,
      'lastSyncError': lastSyncError,
      'parameters': parametersList,
    };
  }

  // Factory from map for JSON deserialization
  @ignore
  factory TestBOM.fromMap(Map<String, dynamic> map) {
    return TestBOM(
      id: map['id'],
      serverId: map['serverId'],
      code: map['code'] ?? '',
      name: map['name'] ?? '',
      testGroup: map['testGroup'] ?? '',
      genderType: map['genderType'] ?? 'Both',
      description: map['description'],
      rate: (map['rate'] as num?)?.toDouble() ?? 0.0,
      gst: (map['gst'] as num?)?.toDouble() ?? 0.0,
      turnAroundTime: map['turnAroundTime'] ?? '',
      timeUnit: map['timeUnit'] ?? 'hours',
      isActive: (map['isActive'] as bool? ?? true) ? 1 : 0,
      method: map['method'],
      referenceRange: map['referenceRange'],
      clinicalSignificance: map['clinicalSignificance'],
      specimenRequirement: map['specimenRequirement'],
      createdAt: map['createdAt'] ?? DateTime.now().toIso8601String(),
      createdBy: map['createdBy'] ?? 'system',
      lastModified: map['lastModified'],
      lastModifiedBy: map['lastModifiedBy'],
      isDeleted: (map['isDeleted'] as bool? ?? false) ? 1 : 0,
      deletedBy: map['deletedBy'],
      isSynced: (map['isSynced'] as bool? ?? false) ? 1 : 0,
      syncStatus: map['syncStatus'] ?? 'pending',
      syncAttempts: map['syncAttempts'] ?? 0,
      lastSyncError: map['lastSyncError'],
      parameters: map['parameters'] is List<TestParameter> 
          ? TestBOM.parametersToJson(map['parameters'])
          : (map['parameters'] as String? ?? '[]'),
    );
  }

  @override
  String toString() {
    return 'TestBOM{id: $id, code: $code, name: $name, testGroup: $testGroup, isActive: $isActiveBool}';
  }
}

// Test Parameter model
class TestParameter {
  final String testName;
  final String? minValue;
  final String? maxValue;
  final String? testMethod;
  final String? unit;
  final String? description;

  TestParameter({
    required this.testName,
    this.minValue,
    this.maxValue,
    this.testMethod,
    this.unit,
    this.description,
  });

  factory TestParameter.fromJson(Map<String, dynamic> json) {
    return TestParameter(
      testName: json['testName'] ?? '',
      minValue: json['minValue'],
      maxValue: json['maxValue'],
      testMethod: json['testMethod'],
      unit: json['unit'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'testName': testName,
      'minValue': minValue,
      'maxValue': maxValue,
      'testMethod': testMethod,
      'unit': unit,
      'description': description,
    };
  }

  // For easier debugging
  @override
  String toString() {
    return 'TestParameter{testName: $testName, min: $minValue, max: $maxValue}';
  }

  // Copy with method for TestParameter
  TestParameter copyWith({
    String? testName,
    String? minValue,
    String? maxValue,
    String? testMethod,
    String? unit,
    String? description,
  }) {
    return TestParameter(
      testName: testName ?? this.testName,
      minValue: minValue ?? this.minValue,
      maxValue: maxValue ?? this.maxValue,
      testMethod: testMethod ?? this.testMethod,
      unit: unit ?? this.unit,
      description: description ?? this.description,
    );
  }
}

// Gender Type enum for easier handling
enum GenderType {
  male('Male'),
  female('Female'),
  both('Both'),
  na('N/A');

  final String value;
  const GenderType(this.value);

  static GenderType fromString(String value) {
    if (value.isEmpty) return GenderType.both;
    switch (value.toLowerCase()) {
      case 'male':
        return GenderType.male;
      case 'female':
        return GenderType.female;
      case 'both':
        return GenderType.both;
      case 'na':
      case 'n/a':
        return GenderType.na;
      default:
        return GenderType.both;
    }
  }

  String toDbString() {
    return switch (this) {
      GenderType.male => 'Male',
      GenderType.female => 'Female',
      GenderType.both => 'Both',
      GenderType.na => 'N/A',
    };
  }

  @override
  String toString() => value;
}