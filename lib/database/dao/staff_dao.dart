// database/dao/staff_dao.dart
import 'package:floor/floor.dart';
import '../entity/staff_entity.dart';

@dao
abstract class StaffDao {
  @Query('SELECT * FROM staff ORDER BY name ASC')
  Future<List<StaffEntity>> getAllStaff();

  @Query('SELECT * FROM staff WHERE id = :id')
  Future<StaffEntity?> getStaffById(int id);

  @Query('SELECT * FROM staff WHERE server_id = :serverId')
  Future<StaffEntity?> getStaffByServerId(int serverId);

  @Query('SELECT * FROM staff WHERE is_deleted = 0 AND is_synced = 0')
  Future<List<StaffEntity>> getPendingSync();

  @Query('SELECT * FROM staff WHERE is_deleted = 1 AND is_synced = 0')
  Future<List<StaffEntity>> getPendingDeletions();

  @Query('SELECT COUNT(*) FROM staff')
  Future<int?> getTotalCount();

  @Query('SELECT COUNT(*) FROM staff WHERE is_synced = 1')
  Future<int?> getSyncedCount();

  @Query('SELECT COUNT(*) FROM staff WHERE is_synced = 0')
  Future<int?> getPendingCount();

  @Query(
    'SELECT * FROM staff WHERE name LIKE :query OR phone LIKE :query OR email LIKE :query ORDER BY name ASC',
  )
  Future<List<StaffEntity>> searchStaff(String query);

  @Query('SELECT * FROM staff WHERE department = :department ORDER BY name ASC')
  Future<List<StaffEntity>> getStaffByDepartment(String department);

  @Query(
    'SELECT DISTINCT department FROM staff WHERE department IS NOT NULL AND department != "" ORDER BY department ASC',
  )
  Future<List<String>> getAllDepartments();

  @Query(
    'SELECT DISTINCT designation FROM staff WHERE designation IS NOT NULL AND designation != "" ORDER BY designation ASC',
  )
  Future<List<String>> getAllDesignations();

  @insert
  Future<int> insertStaff(StaffEntity staff);

  @update
  Future<void> updateStaff(StaffEntity staff);

  @Query(
    'UPDATE staff SET is_synced = 1, sync_status = "synced" WHERE id = :id',
  )
  Future<void> markAsSynced(int id);

  @Query(
    'UPDATE staff SET is_synced = 0, sync_status = "failed", sync_attempts = sync_attempts + 1, last_sync_error = :error WHERE id = :id',
  )
  Future<void> markSyncFailed(int id, String error);

  @Query('DELETE FROM staff WHERE id = :id')
  Future<void> deleteStaff(int id);

  @Query(
    'UPDATE staff SET is_deleted = 1, deleted_by = :deletedBy WHERE id = :id',
  )
  Future<void> softDeleteStaff(int id, String deletedBy);

  @Query('DELETE FROM staff WHERE is_deleted = 1 AND is_synced = 1')
  Future<void> cleanupDeleted();
}
