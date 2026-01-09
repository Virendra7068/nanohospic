// lib/database/dao/test_method_dao.dart
import 'package:floor/floor.dart';
import 'package:nanohospic/database/entity/test_method_master_entity.dart';

@dao
abstract class TestMethodDao {
  @Query('SELECT * FROM test_methods WHERE id = :id')
  Future<TestMethodEntity?> getTestMethodById(int id);

  @Query('SELECT * FROM test_methods WHERE server_id = :serverId')
  Future<TestMethodEntity?> getTestMethodByServerId(int serverId);

  @Query('SELECT * FROM test_methods WHERE is_deleted = 0 ORDER BY method_name ASC')
  Future<List<TestMethodEntity>> getAllTestMethods();

  @Query('SELECT * FROM test_methods WHERE (method_name LIKE :query OR description LIKE :query) AND is_deleted = 0 ORDER BY method_name ASC')
  Future<List<TestMethodEntity>> searchTestMethods(String query);

  @Query('SELECT * FROM test_methods WHERE is_deleted = 0 AND (is_synced = 0 OR sync_status = "pending" OR sync_status = "failed") ORDER BY id ASC')
  Future<List<TestMethodEntity>> getPendingSyncTestMethods();

  @Query('SELECT COUNT(*) FROM test_methods WHERE is_deleted = 0')
  Future<int?> getTestMethodsCount();

  @Query('SELECT COUNT(*) FROM test_methods WHERE is_deleted = 0 AND is_synced = 1')
  Future<int?> getSyncedTestMethodsCount();

  @Query('SELECT COUNT(*) FROM test_methods WHERE is_deleted = 0 AND (is_synced = 0 OR sync_status = "pending" OR sync_status = "failed")')
  Future<int?> getPendingTestMethodsCount();

  @Query('UPDATE test_methods SET is_deleted = 1, deleted_by = "system", sync_status = "pending" WHERE id = :id')
  Future<int?> markAsDeleted(int id);

  @Query('UPDATE test_methods SET is_synced = 1, sync_status = "synced" WHERE id = :id')
  Future<int?> markAsSynced(int id);

  @Query('UPDATE test_methods SET sync_status = "failed" WHERE id = :id')
  Future<int?> markAsFailed(int id);

  @insert
  Future<int> insertTestMethod(TestMethodEntity testMethod);

  @update
  Future<int> updateTestMethod(TestMethodEntity testMethod);

  @delete
  Future<int> deleteTestMethod(TestMethodEntity testMethod);
}