// ignore_for_file: avoid_print

import 'package:floor/floor.dart';
import 'package:nanohospic/database/entity/sample_type_entity.dart';

@dao
abstract class SampleTypeDao {
  @Query('SELECT * FROM sample_types ORDER BY name ASC')
  Future<List<SampleTypeEntity>> getAllSampleTypes();

  @Query('SELECT * FROM sample_types WHERE id = :id')
  Future<SampleTypeEntity?> getSampleTypeById(int id);

  @Query('SELECT * FROM sample_types WHERE server_id = :serverId')
  Future<SampleTypeEntity?> getSampleTypeByServerId(int serverId);

  @Query('SELECT * FROM sample_types WHERE name LIKE :search ORDER BY name ASC')
  Future<List<SampleTypeEntity>> searchSampleTypes(String search);

  @Query('SELECT COUNT(*) FROM sample_types')
  Future<int?> getTotalCount();

  @Query('SELECT COUNT(*) FROM sample_types WHERE is_synced = 1')
  Future<int?> getSyncedCount();

  @Query('SELECT COUNT(*) FROM sample_types WHERE is_synced = 0')
  Future<int?> getPendingCount();

  @Query('SELECT * FROM sample_types WHERE is_synced = 0 ORDER BY id ASC')
  Future<List<SampleTypeEntity>> getPendingSync();

  @Query('SELECT * FROM sample_types WHERE is_deleted = 0 ORDER BY name ASC')
  Future<List<SampleTypeEntity>> getActiveSampleTypes();

  @Query('UPDATE sample_types SET is_synced = 1, sync_status = "synced" WHERE id = :id')
  Future<void> markAsSynced(int id);

  @Query('UPDATE sample_types SET server_id = :serverId WHERE id = :id')
  Future<void> updateServerId(int id, int serverId);

  @Query('UPDATE sample_types SET sync_attempts = sync_attempts + 1, last_sync_error = :error WHERE id = :id')
  Future<void> updateSyncError(int id, String error);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertSampleType(SampleTypeEntity sampleType);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<List<int>> insertSampleTypeList(List<SampleTypeEntity> sampleTypes);

  @Update()
  Future<void> updateSampleType(SampleTypeEntity sampleType);

  @Query('UPDATE sample_types SET is_deleted = 1, deleted_by = :deletedBy, last_modified = :timestamp WHERE id = :id')
  Future<void> softDeleteSampleType(int id, String deletedBy, String timestamp);

  @Query('DELETE FROM sample_types WHERE id = :id')
  Future<void> deleteSampleType(int id);

  @Query('DELETE FROM sample_types')
  Future<void> deleteAllSampleTypes();
}