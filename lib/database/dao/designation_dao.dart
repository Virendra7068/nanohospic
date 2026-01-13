// database/dao/Designation_dao.dart
import 'package:floor/floor.dart';
import 'package:nanohospic/database/entity/designation_entity.dart';

@dao
abstract class DesignationDao {
  @Query('SELECT * FROM designation WHERE is_deleted = 0 ORDER BY name ASC')
  Future<List<DesignationEntity>> getAllDesignations();

  @Query('SELECT * FROM designation WHERE id = :id')
  Future<DesignationEntity?> getDesignationById(int id);

  @Query('SELECT * FROM designation WHERE server_id = :serverId')
  Future<DesignationEntity?> getDesignationByServerId(int serverId);

  @Query('SELECT * FROM designation WHERE name = :name AND is_deleted = 0')
  Future<DesignationEntity?> getDesignationByName(String name);

  @Query('SELECT * FROM designation WHERE is_deleted = 0 AND is_synced = 0')
  Future<List<DesignationEntity>> getPendingSync();

  @Query('SELECT * FROM designation WHERE is_deleted = 1 AND is_synced = 0')
  Future<List<DesignationEntity>> getPendingDeletions();

  @Query('SELECT COUNT(*) FROM designation WHERE is_deleted = 0')
  Future<int?> getTotalCount();

  @Query('SELECT COUNT(*) FROM designation WHERE is_synced = 1 AND is_deleted = 0')
  Future<int?> getSyncedCount();

  @Query('SELECT COUNT(*) FROM designation WHERE is_synced = 0 AND is_deleted = 0')
  Future<int?> getPendingCount();

  @Query(
    'SELECT * FROM designation WHERE (name LIKE :query OR description LIKE :query) AND is_deleted = 0 ORDER BY name ASC',
  )
  Future<List<DesignationEntity>> searchDesignations(String query);

  @insert
  Future<int> insertDesignation(DesignationEntity designation);

  @update
  Future<void> updateDesignation(DesignationEntity designation);

  @Query(
    'UPDATE designation SET is_synced = 1, sync_status = "synced" WHERE id = :id',
  )
  Future<void> markAsSynced(int id);

  @Query(
    'UPDATE designation SET is_synced = 0, sync_status = "failed", sync_attempts = sync_attempts + 1, last_sync_error = :error WHERE id = :id',
  )
  Future<void> markSyncFailed(int id, String error);

  @Query('DELETE FROM designation WHERE id = :id')
  Future<void> deleteDesignation(int id);

  @Query(
    'UPDATE designation SET is_deleted = 1, deleted_by = :deletedBy WHERE id = :id',
  )
  Future<void> softDeleteDesignation(int id, String deletedBy);

  @Query('DELETE FROM designation WHERE is_deleted = 1 AND is_synced = 1')
  Future<void> cleanupDeleted();
}