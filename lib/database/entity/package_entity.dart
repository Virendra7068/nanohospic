// ignore_for_file: avoid_print

import 'package:floor/floor.dart';
import 'dart:convert';
import 'package:nanohospic/model/package_model.dart';

@Entity(tableName: 'packages')
class PackageEntity {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  @ColumnInfo(name: 'server_id')
  final int? serverId;

  @ColumnInfo(name: 'code')
  final String code;

  @ColumnInfo(name: 'name')
  final String name;

  @ColumnInfo(name: 'gst')
  final double gst;

  @ColumnInfo(name: 'rate')
  final double rate;

  @ColumnInfo(name: 'tests_json')
  final String testsJson; 

  @ColumnInfo(name: 'created_at')
  final String createdAt;

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

  PackageEntity({
    this.id,
    this.serverId,
    required this.code,
    required this.name,
    required this.gst,
    required this.rate,
    required this.testsJson,
    required this.createdAt,
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

  // Helper method to convert tests list to JSON string
  static String encodeTests(List<PackageTest> tests) {
    return json.encode(tests.map((test) => test.toMap()).toList());
  }

  // Helper method to convert JSON string to tests list
  static List<PackageTest> decodeTests(String testsJson) {
    try {
      final List<dynamic> decoded = json.decode(testsJson);
      return decoded.map((test) => PackageTest.fromMap(test as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Error decoding tests JSON: $e');
      return [];
    }
  }

  factory PackageEntity.fromModel(PackageModel model) {
    return PackageEntity(
      code: model.code,
      name: model.name,
      gst: model.gst,
      rate: model.rate,
      testsJson: encodeTests(model.tests),
      createdAt: DateTime.now().toIso8601String(),
    );
  }

  PackageModel toModel() {
    return PackageModel(
      code: code,
      name: name,
      gst: gst,
      rate: rate,
      tests: decodeTests(testsJson),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'server_id': serverId,
      'code': code,
      'name': name,
      'gst': gst,
      'rate': rate,
      'tests_json': testsJson,
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

  factory PackageEntity.fromMap(Map<String, dynamic> map) {
    return PackageEntity(
      id: map['id'] as int?,
      serverId: map['server_id'] as int?,
      code: map['code'] as String,
      name: map['name'] as String,
      gst: (map['gst'] as num).toDouble(),
      rate: (map['rate'] as num).toDouble(),
      testsJson: map['tests_json'] as String,
      createdAt: map['created_at'] as String,
      createdBy: map['created_by'] as String?,
      lastModified: map['last_modified'] as String?,
      lastModifiedBy: map['last_modified_by'] as String?,
      isDeleted: map['is_deleted'] as int,
      deletedBy: map['deleted_by'] as String?,
      isSynced: map['is_synced'] as int,
      syncStatus: map['sync_status'] as String,
      syncAttempts: map['sync_attempts'] as int,
      lastSyncError: map['last_sync_error'] as String?,
    );
  }
}