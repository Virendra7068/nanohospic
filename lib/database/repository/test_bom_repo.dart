// test_bom_repo.dart - CORRECTED VERSION
import 'dart:convert';

import 'package:nanohospic/database/app_database.dart';
import 'package:nanohospic/database/dao/test_bom_dao.dart';
import 'package:nanohospic/database/entity/test_bom_entity.dart';

class TestBOMRepository {
  final TestBOMDao _testBOMDao;

  TestBOMRepository(AppDatabase database) : _testBOMDao = database.testBOMDao;

  // Check if database is ready
  Future<void> ensureDatabaseReady() async {
    try {
      await _testBOMDao.getAllTestBOMs();
    } catch (e) {
      print('⚠️ Database not ready: $e');
      rethrow;
    }
  }

  Future<List<TestBOM>> getAllTestBOMs() async {
    try {
      return await _testBOMDao.getAllTestBOMs();
    } catch (e) {
      print('❌ Error getting all Test BOMs: $e');
      rethrow;
    }
  }

  Future<TestBOM?> getTestBOMByCode(String code) async {
    try {
      return await _testBOMDao.getTestBOMByCode(code);
    } catch (e) {
      print('❌ Error getting Test BOM by code: $e');
      return null;
    }
  }

  Future<List<String>> getAllTestGroups() async {
    try {
      return await _testBOMDao.getAllTestGroups();
    } catch (e) {
      print('❌ Error getting test groups: $e');
      return [];
    }
  }

  Future<List<TestBOM>> getTestBOMsByGroup(String group) async {
    try {
      return await _testBOMDao.getTestBOMsByGroup(group);
    } catch (e) {
      print('❌ Error getting Test BOMs by group: $e');
      return [];
    }
  }

  Future<int> saveTestBOM(TestBOM testBOM) async {
    try {
      final result = await _testBOMDao.insertTestBOM(testBOM);
      print('✅ Test BOM saved with ID: $result');
      return result;
    } catch (e) {
      print('❌ Error saving Test BOM: $e');
      rethrow;
    }
  }

  Future<int> updateTestBOM(TestBOM testBOM) async {
    try {
      final result = await _testBOMDao.updateTestBOM(testBOM);
      print('✅ Test BOM updated, affected rows: $result');
      return result;
    } catch (e) {
      print('❌ Error updating Test BOM: $e');
      rethrow;
    }
  }

  // In test_bom_repo.dart - Update the methods that call nullable DAO methods
Future<int> deleteTestBOM(String code, String deletedBy, DateTime lastModified) async {
  try {
    final result = await _testBOMDao.deleteTestBOM(code, deletedBy, lastModified.toIso8601String());
    return result ?? 0;  // Handle nullable
  } catch (e) {
    print('❌ Error deleting Test BOM: $e');
    rethrow;
  }
}

Future<int> getTestBOMCount() async {
  try {
    final count = await _testBOMDao.getTestBOMCount();
    return count ?? 0;  // Handle nullable
  } catch (e) {
    print('❌ Error getting Test BOM count: $e');
    return 0;
  }
}

Future<int> getActiveTestBOMCount() async {
  try {
    final count = await _testBOMDao.getActiveTestBOMCount();
    return count ?? 0;  // Handle nullable
  } catch (e) {
    print('❌ Error getting active Test BOM count: $e');
    return 0;
  }
}

  // New method to check if test code already exists
  Future<bool> doesTestCodeExist(String code) async {
    try {
      final test = await getTestBOMByCode(code);
      return test != null;
    } catch (e) {
      print('❌ Error checking if test code exists: $e');
      return false;
    }
  }

  // New method to search tests
  Future<List<TestBOM>> searchTestBOMs(String query) async {
    try {
      final allTests = await getAllTestBOMs();
      if (query.isEmpty) return allTests;
      
      final lowerQuery = query.toLowerCase();
      return allTests.where((test) {
        return test.name.toLowerCase().contains(lowerQuery) ||
               test.code.toLowerCase().contains(lowerQuery) ||
               test.testGroup.toLowerCase().contains(lowerQuery) ||
               (test.description?.toLowerCase().contains(lowerQuery) ?? false);
      }).toList();
    } catch (e) {
      print('❌ Error searching Test BOMs: $e');
      return [];
    }
  }

  // UPDATED: Create test using the factory constructor
  Future<TestBOM> createTestFromData({
    String? code,
    required String name,
    required String testGroup,
    required String genderType,
    String? description,
    required double rate,
    required double gst,
    required String turnAroundTime,
    required String timeUnit,
    bool isActive = true,
    String? method,
    String? referenceRange,
    String? clinicalSignificance,
    String? specimenRequirement,
    String? createdBy,
    List<TestParameter> parameters = const [],
  }) async {
    return TestBOM.create(
      code: code,
      name: name,
      testGroup: testGroup,
      genderType: genderType,
      description: description,
      rate: rate,
      gst: gst,
      turnAroundTime: turnAroundTime,
      timeUnit: timeUnit,
      isActive: isActive,
      method: method,
      referenceRange: referenceRange,
      clinicalSignificance: clinicalSignificance,
      specimenRequirement: specimenRequirement,
      createdAt: DateTime.now(),
      createdBy: createdBy ?? 'system',
      parameters: parameters,
    );
  }

  // UPDATED: Create test from map using fromMap factory
  Future<TestBOM> createTestBOMFromMap(Map<String, dynamic> map) async {
    try {
      // Convert database map to entity format
      final parameters = map['parameters'] ?? '[]';
      List<TestParameter> parameterList = [];
      
      if (parameters is String && parameters.isNotEmpty) {
        try {
          final jsonList = json.decode(parameters);
          parameterList = List<Map<String, dynamic>>.from(jsonList)
              .map((p) => TestParameter.fromJson(p))
              .toList();
        } catch (e) {
          print('⚠️ Error parsing parameters JSON: $e');
        }
      }
      
      return TestBOM.fromMap({
        'id': map['id'],
        'serverId': map['server_id'],
        'code': map['code'] ?? '',
        'name': map['name'] ?? '',
        'testGroup': map['test_group'] ?? '',
        'genderType': map['gender_type'] ?? 'Both',
        'description': map['description'],
        'rate': map['rate'],
        'gst': map['gst'],
        'turnAroundTime': map['turn_around_time'] ?? '',
        'timeUnit': map['time_unit'] ?? 'hours',
        'isActive': map['is_active'] == 1,
        'method': map['method'],
        'referenceRange': map['reference_range'],
        'clinicalSignificance': map['clinical_significance'],
        'specimenRequirement': map['specimen_requirement'],
        'createdAt': map['created_at'] ?? DateTime.now().toIso8601String(),
        'createdBy': map['created_by'] ?? 'system',
        'lastModified': map['last_modified'],
        'lastModifiedBy': map['last_modified_by'],
        'isDeleted': map['is_deleted'] == 1,
        'deletedBy': map['deleted_by'],
        'isSynced': map['is_synced'] == 1,
        'syncStatus': map['sync_status'] ?? 'pending',
        'syncAttempts': map['sync_attempts'] ?? 0,
        'lastSyncError': map['last_sync_error'],
        'parameters': parameterList,
      });
    } catch (e) {
      print('❌ Error creating TestBOM from map: $e');
      rethrow;
    }
  }

  // Bulk operations
  Future<List<int>> saveTestBOMs(List<TestBOM> testBOMs) async {
    try {
      final results = <int>[];
      for (final testBOM in testBOMs) {
        final result = await saveTestBOM(testBOM);
        results.add(result);
      }
      print('✅ ${testBOMs.length} Test BOMs saved');
      return results;
    } catch (e) {
      print('❌ Error saving multiple Test BOMs: $e');
      rethrow;
    }
  }

  Future<List<int>> updateTestBOMs(List<TestBOM> testBOMs) async {
    try {
      final results = <int>[];
      for (final testBOM in testBOMs) {
        final result = await updateTestBOM(testBOM);
        results.add(result);
      }
      print('✅ ${testBOMs.length} Test BOMs updated');
      return results;
    } catch (e) {
      print('❌ Error updating multiple Test BOMs: $e');
      rethrow;
    }
  }


  // Get unsynced tests
  Future<List<TestBOM>> getUnsyncedTests() async {
    try {
      final allTests = await getAllTestBOMs();
      return allTests.where((test) => !test.isSyncedBool).toList();
    } catch (e) {
      print('❌ Error getting unsynced tests: $e');
      return [];
    }
  }

  // Get tests with sync errors
  Future<List<TestBOM>> getTestsWithSyncErrors() async {
    try {
      final allTests = await getAllTestBOMs();
      return allTests.where((test) => 
          test.syncStatus == 'error' && test.syncAttempts < 3).toList();
    } catch (e) {
      print('❌ Error getting tests with sync errors: $e');
      return [];
    }
  }

  // Helper method to validate test data
  Future<List<String>> validateTestBOM(TestBOM testBOM) async {
    final errors = <String>[];
    
    if (testBOM.code.isEmpty) {
      errors.add('Test code is required');
    }
    
    if (testBOM.name.isEmpty) {
      errors.add('Test name is required');
    }
    
    if (testBOM.testGroup.isEmpty) {
      errors.add('Test group is required');
    }
    
    if (testBOM.rate <= 0) {
      errors.add('Rate must be greater than 0');
    }
    
    if (testBOM.turnAroundTime.isEmpty) {
      errors.add('Turn around time is required');
    }
    
    // Check for duplicate code (only for new tests)
    if (testBOM.id == null) {
      final exists = await doesTestCodeExist(testBOM.code);
      if (exists) {
        errors.add('Test code already exists');
      }
    }
    
    return errors;
  }

  // Get statistics
  Future<Map<String, dynamic>> getStatistics() async {
    try {
      final total = await getTestBOMCount();
      final active = await getActiveTestBOMCount();
      final allTests = await getAllTestBOMs();
      
      // Count by group
      final groups = <String, int>{};
      for (final test in allTests) {
        groups[test.testGroup] = (groups[test.testGroup] ?? 0) + 1;
      }
      
      // Count by gender type
      final genderTypes = <String, int>{};
      for (final test in allTests) {
        genderTypes[test.genderType] = (genderTypes[test.genderType] ?? 0) + 1;
      }
      
      return {
        'total': total,
        'active': active,
        'inactive': total - active,
        'groups': groups,
        'genderTypes': genderTypes,
        'lastUpdated': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      print('❌ Error getting statistics: $e');
      return {
        'total': 0,
        'active': 0,
        'inactive': 0,
        'groups': {},
        'genderTypes': {},
        'lastUpdated': DateTime.now().toIso8601String(),
        'error': e.toString(),
      };
    }
  }
}