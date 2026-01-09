// lib/database/entity/test_entity.dart
import 'package:floor/floor.dart';

@Entity(tableName: 'test')
class TestEntity {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  
  @ColumnInfo(name: 'server_id')
  final int? serverId;
  
  @ColumnInfo(name: 'code')
  final String code;
  
  @ColumnInfo(name: 'name')
  final String name;
  
  @ColumnInfo(name: 'product_group')
  final String group;
  
  @ColumnInfo(name: 'mrp')
  final double mrp;
  
  @ColumnInfo(name: 'sales_rate_a')
  final double salesRateA;
  
  @ColumnInfo(name: 'sales_rate_b')
  final double salesRateB;
  
  @ColumnInfo(name: 'hsn_sac')
  final String? hsnSac;
  
  @ColumnInfo(name: 'gst')
  final int gst;
  
  @ColumnInfo(name: 'barcode')
  final String? barcode;
  
  @ColumnInfo(name: 'min_value')
  final double minValue;
  
  @ColumnInfo(name: 'max_value')
  final double maxValue;
  
  @ColumnInfo(name: 'unit')
  final String unit;
  
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

  TestEntity({
    this.id,
    this.serverId,
    required this.code,
    required this.name,
    required this.group,
    required this.mrp,
    required this.salesRateA,
    required this.salesRateB,
    this.hsnSac,
    required this.gst,
    this.barcode,
    required this.minValue,
    required this.maxValue,
    required this.unit,
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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'server_id': serverId,
      'code': code,
      'name': name,
      'product_group': group,
      'mrp': mrp,
      'sales_rate_a': salesRateA,
      'sales_rate_b': salesRateB,
      'hsn_sac': hsnSac,
      'gst': gst,
      'barcode': barcode,
      'min_value': minValue,
      'max_value': maxValue,
      'unit': unit,
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

  factory TestEntity.fromMap(Map<String, dynamic> map) {
    return TestEntity(
      id: map['id'] as int?,
      serverId: map['server_id'] as int?,
      code: map['code'] as String,
      name: map['name'] as String,
      group: map['product_group'] as String,
      mrp: (map['mrp'] as num).toDouble(),
      salesRateA: (map['sales_rate_a'] as num).toDouble(),
      salesRateB: (map['sales_rate_b'] as num).toDouble(),
      hsnSac: map['hsn_sac'] as String?,
      gst: map['gst'] as int,
      barcode: map['barcode'] as String?,
      minValue: (map['min_value'] as num).toDouble(),
      maxValue: (map['max_value'] as num).toDouble(),
      unit: map['unit'] as String,
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