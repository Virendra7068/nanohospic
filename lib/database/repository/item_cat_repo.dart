import 'package:nanohospic/database/dao/item_cat_dao.dart';
import 'package:nanohospic/database/entity/category_entity.dart';

class CategoryRepository {
  final CategoryDao _categoryDao;

  CategoryRepository(this._categoryDao);

  Future<List<CategoryEntity>> getAllCategories() async {
    return await _categoryDao.getAllCategories();
  }

  Future<CategoryEntity?> getCategoryByServerId(int serverId) async {
    return await _categoryDao.getCategoryByServerId(serverId);
  }

  Future<CategoryEntity?> getCategoryById(int id) async {
    return await _categoryDao.getCategoryById(id);
  }

  Future<int> insertCategory(CategoryEntity category) async {
    final result = await _categoryDao.insertCategory(category);
    return result ?? 0; // ✅ Handle nullable
  }

  Future<int> updateCategory(CategoryEntity category) async {
    final result = await _categoryDao.updateCategory(category);
    return result ?? 0; // ✅ Handle nullable
  }

  Future<int> deleteCategory(int categoryId) async {
    final result = await _categoryDao.deleteCategoryById(categoryId);
    return result ?? 0; // ✅ Handle nullable
  }

  Future<List<CategoryEntity>> getPendingSync() async {
    return await _categoryDao.getPendingSync();
  }

  Future<int> getTotalCount() async {
    final count = await _categoryDao.getTotalCount();
    return count ?? 0;
  }

  Future<int> getSyncedCount() async {
    final count = await _categoryDao.getSyncedCount();
    return count ?? 0;
  }

  Future<int> getPendingCount() async {
    final count = await _categoryDao.getPendingCount();
    return count ?? 0;
  }

  Future<int> markAsSynced(int categoryId, String status) async {
    final result = await _categoryDao.markAsSynced(categoryId, status);
    return result ?? 0; // ✅ Handle nullable
  }

  Future<void> syncFromServer(List<Map<String, dynamic>> serverCategories) async {
    for (var categoryData in serverCategories) {
      try {
        final category = CategoryEntity.fromApi(categoryData);
        final existingCategory = await _categoryDao.getCategoryByServerId(category.serverId!);

        if (existingCategory != null) {
          category.id = existingCategory.id;
          await _categoryDao.updateCategory(category);
        } else {
          await _categoryDao.insertCategory(category);
        }
      } catch (e) {
        print('Error syncing category: $e');
      }
    }
  }
}