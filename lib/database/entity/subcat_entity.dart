import 'package:floor/floor.dart';
import 'package:nanohospic/model/subcat_model.dart';

@Entity(tableName: 'subcategories')
class SubCategoryEntity {
  @PrimaryKey(autoGenerate: true)
  int? id;

  @ColumnInfo(name: 'server_id')
  int? serverId;

  String name;

  @ColumnInfo(name: 'category_id')
  int categoryId;

  @ColumnInfo(name: 'category_server_id')
  int? categoryServerId;

  @ColumnInfo(name: 'category_name')
  String? categoryName;

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

  SubCategoryEntity({
    this.id,
    this.serverId,
    required this.name,
    required this.categoryId,
    this.categoryServerId,
    this.categoryName,
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
      'name': name,
      'category_id': categoryId,
      'category_server_id': categoryServerId,
      'category_name': categoryName,
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

  factory SubCategoryEntity.fromMap(Map<String, dynamic> map) {
    return SubCategoryEntity(
      id: map['id'],
      serverId: map['server_id'],
      name: map['name'],
      categoryId: map['category_id'],
      categoryServerId: map['category_server_id'],
      categoryName: map['category_name'],
      createdAt: map['created_at'],
      createdBy: map['created_by'],
      lastModified: map['last_modified'],
      lastModifiedBy: map['last_modified_by'],
      isDeleted: map['is_deleted'] == 1,
      deletedBy: map['deleted_by'],
      isSynced: map['is_synced'] == 1,
      syncStatus: map['sync_status'],
    );
  }

  factory SubCategoryEntity.fromApi(Map<String, dynamic> apiData) {
    return SubCategoryEntity(
      serverId: apiData['id'],
      name: apiData['name'] ?? '',
      categoryId: apiData['categoryId'] ?? 0,
      categoryServerId: apiData['categoryId'],
      categoryName: apiData['categoryName'] ?? '',
      createdAt: apiData['created']?.toString() ?? DateTime.now().toIso8601String(),
      createdBy: apiData['createdBy'],
      lastModified: apiData['lastModified']?.toString(),
      lastModifiedBy: apiData['lastModifiedBy'],
      isSynced: true,
      syncStatus: 'synced',
    );
  }

  SubCategory toSubCategory() {
    return SubCategory(
      id: serverId ?? 0,
      name: name,
      categoryId: categoryId,
      categoryName: categoryName,
      created: createdAt != null ? DateTime.parse(createdAt!) : null,
      createdBy: createdBy,
      lastModified: lastModified != null ? DateTime.parse(lastModified!) : null,
      lastModifiedBy: lastModifiedBy,
    );
  }
}