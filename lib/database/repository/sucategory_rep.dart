import 'package:nanohospic/database/dao/subcat_dao.dart';
import 'package:nanohospic/database/entity/subcat_entity.dart';

class SubCategoryRepository {
  final SubCategoryDao _subCategoryDao;

  SubCategoryRepository(this._subCategoryDao);

  Future<List<SubCategoryEntity>> getAllSubCategories() async {
    return await _subCategoryDao.getAllSubCategories();
  }

  Future<List<SubCategoryEntity>> getSubCategoriesByCategoryId(int categoryId) async {
    return await _subCategoryDao.getSubCategoriesByCategoryId(categoryId);
  }

  Future<SubCategoryEntity?> getSubCategoryByServerId(int serverId) async {
    return await _subCategoryDao.getSubCategoryByServerId(serverId);
  }

  Future<SubCategoryEntity?> getSubCategoryById(int id) async {
    return await _subCategoryDao.getSubCategoryById(id);
  }

  Future<int> insertSubCategory(SubCategoryEntity subCategory) async {
    final result = await _subCategoryDao.insertSubCategory(subCategory);
    return result ?? 0; // ✅ Handle nullable
  }

  Future<int> updateSubCategory(SubCategoryEntity subCategory) async {
    final result = await _subCategoryDao.updateSubCategory(subCategory);
    return result ?? 0; // ✅ Handle nullable
  }

  Future<int> deleteSubCategory(int subCategoryId) async {
    final result = await _subCategoryDao.deleteSubCategoryById(subCategoryId);
    return result ?? 0; // ✅ Handle nullable
  }

  Future<List<SubCategoryEntity>> getPendingSync() async {
    return await _subCategoryDao.getPendingSync();
  }

  Future<int> getTotalCount() async {
    final count = await _subCategoryDao.getTotalCount();
    return count ?? 0;
  }

  Future<int> getSyncedCount() async {
    final count = await _subCategoryDao.getSyncedCount();
    return count ?? 0;
  }

  Future<int> getPendingCount() async {
    final count = await _subCategoryDao.getPendingCount();
    return count ?? 0;
  }

  Future<int> markAsSynced(int subCategoryId, String status) async {
    final result = await _subCategoryDao.markAsSynced(subCategoryId, status);
    return result ?? 0; // ✅ Handle nullable
  }

  Future<void> syncFromServer(List<Map<String, dynamic>> serverSubCategories) async {
    for (var subCategoryData in serverSubCategories) {
      try {
        final subCategory = SubCategoryEntity.fromApi(subCategoryData);
        final existingSubCategory = await _subCategoryDao.getSubCategoryByServerId(subCategory.serverId!);

        if (existingSubCategory != null) {
          subCategory.id = existingSubCategory.id;
          await _subCategoryDao.updateSubCategory(subCategory);
        } else {
          await _subCategoryDao.insertSubCategory(subCategory);
        }
      } catch (e) {
        print('Error syncing subcategory: $e');
      }
    }
  }
}