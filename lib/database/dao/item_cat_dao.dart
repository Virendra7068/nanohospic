import 'package:floor/floor.dart';
import '../entity/category_entity.dart';

@dao
abstract class CategoryDao {
  @Query('SELECT * FROM categories ORDER BY category_name')
  Future<List<CategoryEntity>> getAllCategories();

  @Query('SELECT * FROM categories WHERE server_id = :serverId')
  Future<CategoryEntity?> getCategoryByServerId(int serverId);

  @Query('SELECT * FROM categories WHERE id = :id')
  Future<CategoryEntity?> getCategoryById(int id);

  // ✅ FIXED: Changed to nullable Future<int?>
  @Query('SELECT COUNT(*) FROM categories')
  Future<int?> getTotalCount();

  // ✅ FIXED: Changed to nullable Future<int?>
  @Query('SELECT COUNT(*) FROM categories WHERE is_synced = 1')
  Future<int?> getSyncedCount();

  // ✅ FIXED: Changed to nullable Future<int?>
  @Query('SELECT COUNT(*) FROM categories WHERE is_synced = 0')
  Future<int?> getPendingCount();

  @Query('SELECT * FROM categories WHERE is_synced = 0')
  Future<List<CategoryEntity>> getPendingSync();

  @Query('SELECT * FROM categories WHERE category_name LIKE :query ORDER BY category_name')
  Future<List<CategoryEntity>> searchCategories(String query);

  @insert
  Future<int?> insertCategory(CategoryEntity category); // ✅ Changed to nullable

  @update
  Future<int?> updateCategory(CategoryEntity category); // ✅ Changed to nullable

  // ✅ FIXED: Changed to nullable Future<int?>
  @Query('UPDATE categories SET is_synced = 1, sync_status = :status WHERE id = :id')
  Future<int?> markAsSynced(int id, String status);

  // ✅ FIXED: Changed to nullable Future<int?>
  @Query('UPDATE categories SET is_deleted = 1 WHERE id = :id')
  Future<int?> softDelete(int id);

  @delete
  Future<int?> deleteCategory(CategoryEntity category); // ✅ Changed to nullable

  // ✅ FIXED: Changed to nullable Future<int?>
  @Query('DELETE FROM categories WHERE id = :id')
  Future<int?> deleteCategoryById(int id);

  // ✅ FIXED: Changed to nullable Future<int?>
  @Query('DELETE FROM categories')
  Future<int?> deleteAllCategories();
}