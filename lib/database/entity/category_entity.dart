import 'package:floor/floor.dart';
import 'package:nanohospic/model/item_cat_model.dart';

@Entity(tableName: 'categories')
class CategoryEntity {
  @PrimaryKey(autoGenerate: true)
  int? id;

  @ColumnInfo(name: 'server_id')
  int? serverId;

  @ColumnInfo(name: 'category_name')
  String categoryName;

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
  String syncStatus; 

  CategoryEntity({
    this.id,
    this.serverId,
    required this.categoryName,
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

  factory CategoryEntity.fromMap(Map<String, dynamic> map) {
    return CategoryEntity(
      id: map['id'],
      serverId: map['server_id'],
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

  factory CategoryEntity.fromApi(Map<String, dynamic> apiData) {
    return CategoryEntity(
      serverId: apiData['id'],
      categoryName: apiData['categoryName'] ?? '',
      createdAt: apiData['created']?.toString() ?? DateTime.now().toIso8601String(),
      createdBy: apiData['createdBy'],
      lastModified: apiData['lastModified']?.toString(),
      lastModifiedBy: apiData['lastModifiedBy'],
      isSynced: true,
      syncStatus: 'synced',
    );
  }

  Category toCategory() {
    return Category(
      id: serverId ?? 0,
      categoryName: categoryName,
      created: createdAt != null ? DateTime.parse(createdAt!) : null,
      createdBy: createdBy,
      lastModified: lastModified != null ? DateTime.parse(lastModified!) : null,
      lastModifiedBy: lastModifiedBy,
    );
  }
}