// database/dao/department_dao.dart
import 'package:floor/floor.dart';
import '../entity/department_entity.dart';

@dao
abstract class DepartmentDao {
  @Query('SELECT * FROM department WHERE is_deleted = 0 ORDER BY name ASC')
  Future<List<DepartmentEntity>> getAllDepartments();

  @Query('SELECT * FROM department WHERE id = :id')
  Future<DepartmentEntity?> getDepartmentById(int id);

  @Query('SELECT * FROM department WHERE server_id = :serverId')
  Future<DepartmentEntity?> getDepartmentByServerId(int serverId);

  @Query('SELECT * FROM department WHERE name = :name AND is_deleted = 0')
  Future<DepartmentEntity?> getDepartmentByName(String name);

  @Query('SELECT * FROM department WHERE is_deleted = 0 AND is_synced = 0')
  Future<List<DepartmentEntity>> getPendingSync();

  @Query('SELECT * FROM department WHERE is_deleted = 1 AND is_synced = 0')
  Future<List<DepartmentEntity>> getPendingDeletions();

  @Query('SELECT COUNT(*) FROM department WHERE is_deleted = 0')
  Future<int?> getTotalCount();

  @Query('SELECT COUNT(*) FROM department WHERE is_synced = 1 AND is_deleted = 0')
  Future<int?> getSyncedCount();

  @Query('SELECT COUNT(*) FROM department WHERE is_synced = 0 AND is_deleted = 0')
  Future<int?> getPendingCount();

  @Query(
    'SELECT * FROM department WHERE (name LIKE :query OR description LIKE :query) AND is_deleted = 0 ORDER BY name ASC',
  )
  Future<List<DepartmentEntity>> searchDepartments(String query);

  @insert
  Future<int> insertDepartment(DepartmentEntity department);

  @update
  Future<void> updateDepartment(DepartmentEntity department);

  @Query(
    'UPDATE department SET is_synced = 1, sync_status = "synced" WHERE id = :id',
  )
  Future<void> markAsSynced(int id);

  @Query(
    'UPDATE department SET is_synced = 0, sync_status = "failed", sync_attempts = sync_attempts + 1, last_sync_error = :error WHERE id = :id',
  )
  Future<void> markSyncFailed(int id, String error);

  @Query('DELETE FROM department WHERE id = :id')
  Future<void> deleteDepartment(int id);

  @Query(
    'UPDATE department SET is_deleted = 1, deleted_by = :deletedBy WHERE id = :id',
  )
  Future<void> softDeleteDepartment(int id, String deletedBy);

  @Query('DELETE FROM department WHERE is_deleted = 1 AND is_synced = 1')
  Future<void> cleanupDeleted();
}