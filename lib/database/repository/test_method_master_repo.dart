// lib/database/repository/test_method_repo.dart
import 'dart:async';
import 'package:nanohospic/database/dao/test_mesthod_master_dao.dart';
import 'package:nanohospic/database/entity/test_method_master_entity.dart';

class TestMethodRepository {
  final TestMethodDao _testMethodDao;

  TestMethodRepository(this._testMethodDao);

  // Local database operations
  Future<List<TestMethodEntity>> getAllTestMethods() async {
    return await _testMethodDao.getAllTestMethods();
  }

  Future<TestMethodEntity?> getTestMethodById(int id) async {
    return await _testMethodDao.getTestMethodById(id);
  }

  Future<TestMethodEntity?> getTestMethodByServerId(int serverId) async {
    return await _testMethodDao.getTestMethodByServerId(serverId);
  }

  Future<List<TestMethodEntity>> searchTestMethods(String query) async {
    return await _testMethodDao.searchTestMethods('%$query%');
  }

  Future<int> insertTestMethod(TestMethodEntity testMethod) async {
    testMethod.isSynced = false;
    testMethod.syncStatus = 'pending';
    testMethod.createdAt = DateTime.now().toIso8601String();
    
    return await _testMethodDao.insertTestMethod(testMethod);
  }

  Future<int> updateTestMethod(TestMethodEntity testMethod) async {
    testMethod.lastModified = DateTime.now().toIso8601String();
    testMethod.isSynced = false;
    testMethod.syncStatus = 'pending';
    
    return await _testMethodDao.updateTestMethod(testMethod);
  }

  Future<int> deleteTestMethod(int id) async {
    final result = await _testMethodDao.markAsDeleted(id);
    return result ?? 0;
  }

  Future<int> hardDeleteTestMethod(int id) async {
    final testMethod = await getTestMethodById(id);
    if (testMethod != null) {
      return await _testMethodDao.deleteTestMethod(testMethod);
    }
    return 0;
  }

  // Sync related methods
  Future<List<TestMethodEntity>> getPendingSync() async {
    return await _testMethodDao.getPendingSyncTestMethods();
  }

  Future<int> markAsSynced(int id) async {
    final result = await _testMethodDao.markAsSynced(id);
    return result ?? 0;
  }

  Future<int> markAsFailed(int id) async {
    final result = await _testMethodDao.markAsFailed(id);
    return result ?? 0;
  }

  // Statistics
  Future<int> getTotalCount() async {
    final allTestMethods = await getAllTestMethods();
    return allTestMethods.length;
  }

  Future<int> getSyncedCount() async {
    final count = await _testMethodDao.getSyncedTestMethodsCount();
    return count ?? 0;
  }

  Future<int> getPendingCount() async {
    final count = await _testMethodDao.getPendingTestMethodsCount();
    return count ?? 0;
  }

  // Sync from server
  Future<void> syncFromServer(List<dynamic> serverData) async {
    for (final dynamic item in serverData) {
      try {
        Map<String, dynamic> testMethodData;
        
        if (item is Map<String, dynamic>) {
          testMethodData = item;
        } else if (item is Map) {
          testMethodData = Map<String, dynamic>.from(item);
        } else {
          continue;
        }
        
        final serverId = _parseInt(testMethodData['id']);
        if (serverId == 0) continue;
        
        final existing = await getTestMethodByServerId(serverId);
        
        if (existing == null) {
          final testMethod = TestMethodEntity(
            serverId: serverId,
            methodName: testMethodData['methodName']?.toString() ?? '',
            description: testMethodData['description']?.toString() ?? '',
            createdAt: testMethodData['created']?.toString(),
            createdBy: testMethodData['createdBy']?.toString(),
            lastModified: testMethodData['lastModified']?.toString(),
            lastModifiedBy: testMethodData['lastModifiedBy']?.toString(),
            isSynced: true,
            syncStatus: 'synced',
          );
          await insertTestMethod(testMethod);
        } else {
          final updatedTestMethod = TestMethodEntity(
            id: existing.id,
            serverId: existing.serverId,
            methodName: testMethodData['methodName']?.toString() ?? existing.methodName,
            description: testMethodData['description']?.toString() ?? existing.description,
            createdAt: existing.createdAt,
            createdBy: existing.createdBy,
            lastModified: testMethodData['lastModified']?.toString() ?? existing.lastModified,
            lastModifiedBy: testMethodData['lastModifiedBy']?.toString() ?? existing.lastModifiedBy,
            isDeleted: existing.isDeleted,
            deletedBy: existing.deletedBy,
            isSynced: true,
            syncStatus: 'synced',
          );
          await updateTestMethod(updatedTestMethod);
        }
      } catch (e) {
        print('Error syncing test method: $e');
        continue;
      }
    }
  }

  int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  Future<List<TestMethodEntity>> getActiveTestMethods() async {
    final testMethods = await getAllTestMethods();
    return testMethods.where((tm) => !tm.isDeleted).toList();
  }

  Future<void> clearAllTestMethods() async {
    final testMethods = await getAllTestMethods();
    for (final testMethod in testMethods) {
      await hardDeleteTestMethod(testMethod.id!);
    }
  }

  Future<void> restoreTestMethod(int id) async {
    final testMethod = await getTestMethodById(id);
    if (testMethod != null && testMethod.isDeleted) {
      final restoredTestMethod = TestMethodEntity(
        id: testMethod.id,
        serverId: testMethod.serverId,
        methodName: testMethod.methodName,
        description: testMethod.description,
        createdAt: testMethod.createdAt,
        createdBy: testMethod.createdBy,
        lastModified: DateTime.now().toIso8601String(),
        lastModifiedBy: 'system',
        isDeleted: false,
        deletedBy: null,
        isSynced: false,
        syncStatus: 'pending',
      );
      await updateTestMethod(restoredTestMethod);
    }
  }
}