// ignore_for_file: avoid_print

import 'package:nanohospic/database/database_provider.dart';
import 'package:nanohospic/database/entity/package_entity.dart';
import 'package:nanohospic/model/package_model.dart';

class PackageRepository {
  Future<void> savePackage(PackageModel model) async {
    try {
      print('💾 Saving package: ${model.code}');
      final db = await DatabaseProvider.database;
      final entity = PackageEntity.fromModel(model);
      await db.packageDao.insertPackage(entity);
      print('✅ Package saved successfully');
    } catch (e, stackTrace) {
      print('❌ Error saving package: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  Future<List<PackageModel>> getAllPackages() async {
    try {
      print('📋 Getting all packages...');
      final db = await DatabaseProvider.database;
      final entities = await db.packageDao.getAllPackages();
      print('✅ Found ${entities.length} packages');
      return entities.map((entity) => entity.toModel()).toList();
    } catch (e, stackTrace) {
      print('❌ Error getting packages: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  Future<PackageModel?> getPackageByCode(String code) async {
    try {
      final db = await DatabaseProvider.database;
      final entity = await db.packageDao.getPackageByCode(code);
      return entity?.toModel();
    } catch (e) {
      print('❌ Error getting package by code: $e');
      rethrow;
    }
  }

  Future<void> updatePackage(PackageModel model) async {
    try {
      final db = await DatabaseProvider.database;
      final existing = await db.packageDao.getPackageByCode(model.code);
      if (existing != null) {
        final updatedEntity = PackageEntity(
          id: existing.id,
          serverId: existing.serverId,
          code: model.code,
          name: model.name,
          gst: model.gst,
          rate: model.rate,
          testsJson: PackageEntity.encodeTests(model.tests),
          createdAt: existing.createdAt,
          createdBy: existing.createdBy,
          lastModified: DateTime.now().toIso8601String(),
          lastModifiedBy: existing.lastModifiedBy,
          isDeleted: existing.isDeleted,
          deletedBy: existing.deletedBy,
          isSynced: 0,
          syncStatus: 'pending',
          syncAttempts: existing.syncAttempts,
          lastSyncError: existing.lastSyncError,
        );
        await db.packageDao.updatePackage(updatedEntity);
      }
    } catch (e) {
      print('❌ Error updating package: $e');
      rethrow;
    }
  }

  Future<void> deletePackage(String code, String deletedBy) async {
    try {
      final db = await DatabaseProvider.database;
      await db.packageDao.softDeletePackage(code, deletedBy);
    } catch (e) {
      print('❌ Error deleting package: $e');
      rethrow;
    }
  }

  Future<int> getPackageCount() async {
    try {
      final db = await DatabaseProvider.database;
      final count = await db.packageDao.getPackageCount();
      return count ?? 0;
    } catch (e) {
      print('❌ Error getting package count: $e');
      return 0;
    }
  }

  Future<List<PackageModel>> searchPackages(String query) async {
    try {
      final db = await DatabaseProvider.database;
      final searchQuery = '%$query%';
      final entities = await db.packageDao.searchPackages(searchQuery);
      return entities.map((entity) => entity.toModel()).toList();
    } catch (e) {
      print('❌ Error searching packages: $e');
      rethrow;
    }
  }
}