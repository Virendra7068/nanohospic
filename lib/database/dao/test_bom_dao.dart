// test_bom_dao.dart - CORRECTED VERSION
import 'package:floor/floor.dart';
import 'package:nanohospic/database/entity/test_bom_entity.dart';

@dao
abstract class TestBOMDao {
  @Query('SELECT * FROM test_boms WHERE is_deleted = 0 ORDER BY name ASC')
  Future<List<TestBOM>> getAllTestBOMs();

  @Query('SELECT * FROM test_boms WHERE code = :code AND is_deleted = 0')
  Future<TestBOM?> getTestBOMByCode(String code);

  @Query('SELECT DISTINCT test_group FROM test_boms WHERE is_deleted = 0 ORDER BY test_group ASC')
  Future<List<String>> getAllTestGroups();

  @Query('SELECT * FROM test_boms WHERE test_group = :group AND is_deleted = 0 ORDER BY name ASC')
  Future<List<TestBOM>> getTestBOMsByGroup(String group);

  // CORRECTED: Made nullable
  @Query('SELECT COUNT(*) FROM test_boms WHERE is_deleted = 0')
  Future<int?> getTestBOMCount();

  // CORRECTED: Made nullable
  @Query('SELECT COUNT(*) FROM test_boms WHERE is_deleted = 0 AND is_active = 1')
  Future<int?> getActiveTestBOMCount();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> insertTestBOM(TestBOM testBOM);

  @Update()
  Future<int> updateTestBOM(TestBOM testBOM);

  // CORRECTED: Made nullable
  @Query('UPDATE test_boms SET is_deleted = 1, deleted_by = :deletedBy, last_modified = :lastModified WHERE code = :code')
  Future<int?> deleteTestBOM(String code, String deletedBy, String lastModified);

  // CORRECTED: Made nullable
  @Query('UPDATE test_boms SET is_synced = 1, sync_status = :status, last_modified = :lastModified WHERE code = :code')
  Future<int?> updateSyncStatus(String code, String status, String lastModified);

  // CORRECTED: Made nullable
  @Query('UPDATE test_boms SET sync_attempts = sync_attempts + 1, last_sync_error = :error WHERE code = :code')
  Future<int?> incrementSyncAttempts(String code, String error);
}