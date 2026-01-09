import 'package:floor/floor.dart';
import 'package:nanohospic/database/entity/subcat_entity.dart';

@dao
abstract class SubCategoryDao {
  @Query('SELECT * FROM subcategories ORDER BY name')
  Future<List<SubCategoryEntity>> getAllSubCategories();

  @Query('SELECT * FROM subcategories WHERE category_id = :categoryId ORDER BY name')
  Future<List<SubCategoryEntity>> getSubCategoriesByCategoryId(int categoryId);

  @Query('SELECT * FROM subcategories WHERE server_id = :serverId')
  Future<SubCategoryEntity?> getSubCategoryByServerId(int serverId);

  @Query('SELECT * FROM subcategories WHERE id = :id')
  Future<SubCategoryEntity?> getSubCategoryById(int id);

  @Query('SELECT COUNT(*) FROM subcategories')
  Future<int?> getTotalCount();

  @Query('SELECT COUNT(*) FROM subcategories WHERE is_synced = 1')
  Future<int?> getSyncedCount();

  @Query('SELECT COUNT(*) FROM subcategories WHERE is_synced = 0')
  Future<int?> getPendingCount();

  @Query('SELECT * FROM subcategories WHERE is_synced = 0')
  Future<List<SubCategoryEntity>> getPendingSync();

  @Query('SELECT * FROM subcategories WHERE name LIKE :query ORDER BY name')
  Future<List<SubCategoryEntity>> searchSubCategories(String query);

  // ✅ FIXED: Changed to nullable Future<int?>
  @insert
  Future<int?> insertSubCategory(SubCategoryEntity subCategory);

  // ✅ FIXED: Changed to nullable Future<int?>
  @update
  Future<int?> updateSubCategory(SubCategoryEntity subCategory);

  // ✅ FIXED: Changed to nullable Future<int?>
  @Query('UPDATE subcategories SET is_synced = 1, sync_status = :status WHERE id = :id')
  Future<int?> markAsSynced(int id, String status);

  // ✅ FIXED: Changed to nullable Future<int?>
  @Query('UPDATE subcategories SET is_deleted = 1 WHERE id = :id')
  Future<int?> softDelete(int id);

  // ✅ FIXED: Changed to nullable Future<int?>
  @delete
  Future<int?> deleteSubCategory(SubCategoryEntity subCategory);

  // ✅ FIXED: Changed to nullable Future<int?>
  @Query('DELETE FROM subcategories WHERE id = :id')
  Future<int?> deleteSubCategoryById(int id);

  // ✅ FIXED: Changed to nullable Future<int?>
  @Query('DELETE FROM subcategories WHERE category_id = :categoryId')
  Future<int?> deleteSubCategoriesByCategoryId(int categoryId);

  // ✅ FIXED: Changed to nullable Future<int?>
  @Query('DELETE FROM subcategories')
  Future<int?> deleteAllSubCategories();
}