// ignore_for_file: avoid_print

import 'package:floor/floor.dart';
import 'package:nanohospic/database/entity/patient_identity_entity.dart';

@dao
abstract class BasDao {
  @Query('SELECT * FROM bas_names ORDER BY name ASC')
  Future<List<BasEntity>> getAllBasNames();

  @Query('SELECT * FROM bas_names WHERE id = :id')
  Future<BasEntity?> getBasById(int id);

  @Query('SELECT * FROM bas_names WHERE server_id = :serverId')
  Future<BasEntity?> getBasByServerId(int serverId);

  @Query('SELECT * FROM bas_names WHERE name LIKE :search ORDER BY name ASC')
  Future<List<BasEntity>> searchBasNames(String search);

  @Query('SELECT COUNT(*) FROM bas_names')
  Future<int?> getTotalCount();  // Changed to int?

  @Query('SELECT COUNT(*) FROM bas_names WHERE is_synced = 1')
  Future<int?> getSyncedCount();  // Changed to int?

  @Query('SELECT COUNT(*) FROM bas_names WHERE is_synced = 0')
  Future<int?> getPendingCount();  // Changed to int?

  @Query('SELECT * FROM bas_names WHERE is_synced = 0 ORDER BY id ASC')
  Future<List<BasEntity>> getPendingSync();

  @Query('SELECT * FROM bas_names WHERE is_deleted = 0 ORDER BY name ASC')
  Future<List<BasEntity>> getActiveBasNames();

  @Query('UPDATE bas_names SET is_synced = 1, sync_status = "synced" WHERE id = :id')
  Future<void> markAsSynced(int id);

  @Query('UPDATE bas_names SET server_id = :serverId WHERE id = :id')
  Future<void> updateServerId(int id, int serverId);

  @Query('UPDATE bas_names SET sync_attempts = sync_attempts + 1, last_sync_error = :error WHERE id = :id')
  Future<void> updateSyncError(int id, String error);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertBas(BasEntity bas);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<List<int>> insertBasList(List<BasEntity> basList);

  @Update()
  Future<void> updateBas(BasEntity bas);

  @Query('UPDATE bas_names SET is_deleted = 1, deleted_by = :deletedBy, last_modified = :timestamp WHERE id = :id')
  Future<void> softDeleteBas(int id, String deletedBy, String timestamp);

  @Query('DELETE FROM bas_names WHERE id = :id')
  Future<void> deleteBas(int id);

  @Query('DELETE FROM bas_names')
  Future<void> deleteAllBas();
}