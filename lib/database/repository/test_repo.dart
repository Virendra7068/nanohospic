// lib/database/repository/test_repo.dart
import 'package:nanohospic/database/database_provider.dart';
import 'package:nanohospic/database/entity/test_entity.dart';
import 'package:nanohospic/model/test_model.dart';

class TestRepository {
  Future<void> saveTest(TestModel model) async {
    try {
      print('💾 Saving test: ${model.code}');
      final db = await DatabaseProvider.database;
      final entity = TestEntity(
        code: model.code,
        name: model.name,
        group: model.group,
        mrp: model.mrp,
        salesRateA: model.salesRateA,
        salesRateB: model.salesRateB,
        hsnSac: model.hsnSac,
        gst: model.gst,
        barcode: model.barcode,
        minValue: model.minValue,
        maxValue: model.maxValue,
        unit: model.unit,
        createdAt: DateTime.now().toIso8601String(),
      );
      await db.testDao.insertTest(entity);
      print('✅ Test saved successfully');
    } catch (e, stackTrace) {
      print('❌ Error saving test: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  Future<List<TestModel>> getAllTests() async {
    try {
      print('📋 Getting all tests...');
      final db = await DatabaseProvider.database;
      final entities = await db.testDao.getAllTests();
      print('✅ Found ${entities.length} tests');
      return entities.map((entity) => TestModel(
        code: entity.code,
        name: entity.name,
        group: entity.group,
        mrp: entity.mrp,
        salesRateA: entity.salesRateA,
        salesRateB: entity.salesRateB,
        hsnSac: entity.hsnSac,
        gst: entity.gst,
        barcode: entity.barcode,
        minValue: entity.minValue,
        maxValue: entity.maxValue,
        unit: entity.unit,
      )).toList();
    } catch (e, stackTrace) {
      print('❌ Error getting tests: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  Future<TestModel?> getTestByCode(String code) async {
    try {
      final db = await DatabaseProvider.database;
      final entity = await db.testDao.getTestByCode(code);
      if (entity == null) return null;
      return TestModel(
        code: entity.code,
        name: entity.name,
        group: entity.group,
        mrp: entity.mrp,
        salesRateA: entity.salesRateA,
        salesRateB: entity.salesRateB,
        hsnSac: entity.hsnSac,
        gst: entity.gst,
        barcode: entity.barcode,
        minValue: entity.minValue,
        maxValue: entity.maxValue,
        unit: entity.unit,
      );
    } catch (e) {
      print('❌ Error getting test by code: $e');
      rethrow;
    }
  }

  Future<void> updateTest(TestModel model) async {
    try {
      final db = await DatabaseProvider.database;
      final existing = await db.testDao.getTestByCode(model.code);
      if (existing != null) {
        final updatedEntity = TestEntity(
          id: existing.id,
          serverId: existing.serverId,
          code: model.code,
          name: model.name,
          group: model.group,
          mrp: model.mrp,
          salesRateA: model.salesRateA,
          salesRateB: model.salesRateB,
          hsnSac: model.hsnSac,
          gst: model.gst,
          barcode: model.barcode,
          minValue: model.minValue,
          maxValue: model.maxValue,
          unit: model.unit,
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
        await db.testDao.updateTest(updatedEntity);
      }
    } catch (e) {
      print('❌ Error updating test: $e');
      rethrow;
    }
  }

  Future<void> deleteTest(String code, String deletedBy) async {
    try {
      final db = await DatabaseProvider.database;
      await db.testDao.softDeleteTest(code, deletedBy);
    } catch (e) {
      print('❌ Error deleting test: $e');
      rethrow;
    }
  }

  Future<int> getTestCount() async {
    try {
      final db = await DatabaseProvider.database;
      final count = await db.testDao.getTestCount();
      return count ?? 0;
    } catch (e) {
      print('❌ Error getting test count: $e');
      return 0;
    }
  }

  Future<List<TestModel>> searchTests(String query) async {
    try {
      final db = await DatabaseProvider.database;
      final searchQuery = '%$query%';
      final entities = await db.testDao.searchTests(searchQuery);
      return entities.map((entity) => TestModel(
        code: entity.code,
        name: entity.name,
        group: entity.group,
        mrp: entity.mrp,
        salesRateA: entity.salesRateA,
        salesRateB: entity.salesRateB,
        hsnSac: entity.hsnSac,
        gst: entity.gst,
        barcode: entity.barcode,
        minValue: entity.minValue,
        maxValue: entity.maxValue,
        unit: entity.unit,
      )).toList();
    } catch (e) {
      print('❌ Error searching tests: $e');
      rethrow;
    }
  }
}