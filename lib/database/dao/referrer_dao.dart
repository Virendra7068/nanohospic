// lib/database/dao/referrer_dao.dart

import 'package:floor/floor.dart';
import '../entity/referrer_entity.dart';

@dao
abstract class ReferrerDao {
  @Query('SELECT * FROM referrers WHERE is_deleted = 0 ORDER BY name')
  Future<List<ReferrerEntity>> getAllReferrers();

  @Query('SELECT * FROM referrers WHERE id = :id')
  Future<ReferrerEntity?> getReferrerById(int id);

  @Query('SELECT * FROM referrers WHERE server_id = :serverId')
  Future<ReferrerEntity?> getReferrerByServerId(int serverId);

  @Query('SELECT * FROM referrers WHERE is_synced = 0 AND is_deleted = 0')
  Future<List<ReferrerEntity>> getPendingSync();

  @Query('SELECT COUNT(*) FROM referrers WHERE is_deleted = 0')
  Future<int?> getTotalCount();

  @Query('SELECT COUNT(*) FROM referrers WHERE is_synced = 1 AND is_deleted = 0')
  Future<int?> getSyncedCount();

  @Query('SELECT COUNT(*) FROM referrers WHERE is_synced = 0 AND is_deleted = 0')
  Future<int?> getPendingCount();

  @Query('''
    SELECT * FROM referrers 
    WHERE is_deleted = 0 
    AND (
      name LIKE :query OR
      contact_no LIKE :query OR
      email LIKE :query OR
      specialization LIKE :query OR
      registration_no LIKE :query
    )
    ORDER BY name
  ''')
  Future<List<ReferrerEntity>> searchReferrers(String query);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<List<int>> insertReferrerList(List<ReferrerEntity> referrers);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> insertReferrer(ReferrerEntity referrer);

  @Update()
  Future<void> updateReferrer(ReferrerEntity referrer);

  @Query('DELETE FROM referrers WHERE id = :id')
  Future<void> deleteReferrer(int id);

  @Query('''
    UPDATE referrers 
    SET is_deleted = 1, 
        deleted_by = :deletedBy,
        last_modified = :lastModified,
        is_synced = 0,
        sync_status = 'pending'
    WHERE id = :id
  ''')
  Future<void> softDeleteReferrer(int id, String deletedBy, String lastModified);

  @Query('UPDATE referrers SET is_synced = 1, sync_status = "synced" WHERE id = :id')
  Future<void> markAsSynced(int id);

  @Query('UPDATE referrers SET server_id = :serverId WHERE id = :id')
  Future<void> updateServerId(int id, int serverId);

  @Query('UPDATE referrers SET last_sync_error = :error WHERE id = :id')
  Future<void> updateSyncError(int id, String error);

  @Query('UPDATE referrers SET sync_attempts = sync_attempts + 1 WHERE id = :id')
  Future<void> incrementSyncAttempts(int id);

  @Query('SELECT DISTINCT specialization FROM referrers WHERE is_deleted = 0 AND specialization IS NOT NULL AND specialization != ""')
  Future<List<String>> getDistinctSpecializations();

  @Query('SELECT DISTINCT degree FROM referrers WHERE is_deleted = 0 AND degree IS NOT NULL AND degree != ""')
  Future<List<String>> getDistinctDegrees();

  @Query('SELECT DISTINCT tag_status FROM referrers WHERE is_deleted = 0 AND tag_status IS NOT NULL AND tag_status != ""')
  Future<List<String>> getDistinctTagStatus();

  @Query('SELECT DISTINCT center_name FROM referrers WHERE is_deleted = 0 AND center_name IS NOT NULL AND center_name != ""')
  Future<List<String>> getDistinctCenters();

  @Query('SELECT * FROM referrers WHERE is_deleted = 0 AND tag_status = "Tagged" ORDER BY name')
  Future<List<ReferrerEntity>> getTaggedReferrers();

  @Query('SELECT * FROM referrers WHERE is_deleted = 0 AND tag_status = "Untagged" ORDER BY name')
  Future<List<ReferrerEntity>> getUntaggedReferrers();

  @Query('SELECT * FROM referrers WHERE is_deleted = 0 AND center_name = :centerName ORDER BY name')
  Future<List<ReferrerEntity>> getReferrersByCenter(String centerName);
}