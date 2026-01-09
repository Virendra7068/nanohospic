// lib/database/dao/test_dao.dart
import 'package:floor/floor.dart';
import '../entity/test_entity.dart';

@dao
abstract class TestDao {
  @Query('SELECT * FROM test WHERE is_deleted = 0 ORDER BY name')
  Future<List<TestEntity>> getAllTests();

  @Query('SELECT * FROM test WHERE code = :code AND is_deleted = 0')
  Future<TestEntity?> getTestByCode(String code);

  @Query('SELECT * FROM test WHERE is_synced = 0')
  Future<List<TestEntity>> getUnsyncedTests();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertTest(TestEntity test);

  @Update()
  Future<void> updateTest(TestEntity test);

  @Query('UPDATE test SET is_deleted = 1, deleted_by = :deletedBy WHERE code = :code')
  Future<void> softDeleteTest(String code, String deletedBy);

  @delete
  Future<void> deleteTest(TestEntity test);

  @Query('DELETE FROM test WHERE code = :code')
  Future<void> deleteTestByCode(String code);

  @Query('SELECT COUNT(*) FROM test WHERE is_deleted = 0')
  Future<int?> getTestCount();

  @Query('SELECT * FROM test WHERE (name LIKE :query OR code LIKE :query) AND is_deleted = 0')
  Future<List<TestEntity>> searchTests(String query);
}