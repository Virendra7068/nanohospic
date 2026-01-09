// lib/database/dao/collection_center_dao.dart

import 'package:floor/floor.dart';
import '../entity/collection_center_entity.dart';

@dao
abstract class CollectionCenterDao {
  @Query('SELECT * FROM collection_centers WHERE is_deleted = 0 ORDER BY center_name')
  Future<List<CollectionCenterEntity>> getAllCollectionCenters();

  @Query('SELECT * FROM collection_centers WHERE id = :id')
  Future<CollectionCenterEntity?> getCollectionCenterById(int id);

  @Query('SELECT * FROM collection_centers WHERE server_id = :serverId')
  Future<CollectionCenterEntity?> getCollectionCenterByServerId(int serverId);

  @Query('SELECT * FROM collection_centers WHERE is_synced = 0 AND is_deleted = 0')
  Future<List<CollectionCenterEntity>> getPendingSync();

  @Query('SELECT COUNT(*) FROM collection_centers WHERE is_deleted = 0')
  Future<int?> getTotalCount();

  @Query('SELECT COUNT(*) FROM collection_centers WHERE is_synced = 1 AND is_deleted = 0')
  Future<int?> getSyncedCount();

  @Query('SELECT COUNT(*) FROM collection_centers WHERE is_synced = 0 AND is_deleted = 0')
  Future<int?> getPendingCount();

  @Query('''
    SELECT * FROM collection_centers 
    WHERE is_deleted = 0 
    AND (
      center_code LIKE :query OR
      center_name LIKE :query OR
      contact_person_name LIKE :query OR
      phone_no LIKE :query OR
      email LIKE :query OR
      location LIKE :query
    )
    ORDER BY center_name
  ''')
  Future<List<CollectionCenterEntity>> searchCollectionCenters(String query);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<List<int>> insertCollectionCenterList(List<CollectionCenterEntity> collectionCenters);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> insertCollectionCenter(CollectionCenterEntity collectionCenter);

  @Update()
  Future<void> updateCollectionCenter(CollectionCenterEntity collectionCenter);

  @Query('DELETE FROM collection_centers WHERE id = :id')
  Future<void> deleteCollectionCenter(int id);

  @Query('''
    UPDATE collection_centers 
    SET is_deleted = 1, 
        deleted_by = :deletedBy,
        last_modified = :lastModified,
        is_synced = 0,
        sync_status = 'pending'
    WHERE id = :id
  ''')
  Future<void> softDeleteCollectionCenter(int id, String deletedBy, String lastModified);

  @Query('UPDATE collection_centers SET is_synced = 1, sync_status = "synced" WHERE id = :id')
  Future<void> markAsSynced(int id);

  @Query('UPDATE collection_centers SET server_id = :serverId WHERE id = :id')
  Future<void> updateServerId(int id, int serverId);

  @Query('UPDATE collection_centers SET last_sync_error = :error WHERE id = :id')
  Future<void> updateSyncError(int id, String error);

  @Query('UPDATE collection_centers SET sync_attempts = sync_attempts + 1 WHERE id = :id')
  Future<void> incrementSyncAttempts(int id);

  @Query('SELECT DISTINCT country FROM collection_centers WHERE is_deleted = 0 AND country IS NOT NULL AND country != ""')
  Future<List<String>> getDistinctCountries();

  @Query('SELECT DISTINCT state FROM collection_centers WHERE is_deleted = 0 AND state IS NOT NULL AND state != ""')
  Future<List<String>> getDistinctStates();

  @Query('SELECT DISTINCT city FROM collection_centers WHERE is_deleted = 0 AND city IS NOT NULL AND city != ""')
  Future<List<String>> getDistinctCities();

  @Query('SELECT DISTINCT centre_status FROM collection_centers WHERE is_deleted = 0 AND centre_status IS NOT NULL AND centre_status != ""')
  Future<List<String>> getDistinctCentreStatus();

  @Query('SELECT DISTINCT transport_mode FROM collection_centers WHERE is_deleted = 0 AND transport_mode IS NOT NULL AND transport_mode != ""')
  Future<List<String>> getDistinctTransportModes();

  @Query('SELECT DISTINCT commission_type FROM collection_centers WHERE is_deleted = 0 AND commission_type IS NOT NULL AND commission_type != ""')
  Future<List<String>> getDistinctCommissionTypes();

  @Query('SELECT * FROM collection_centers WHERE is_deleted = 0 AND centre_status = "Active" ORDER BY center_name')
  Future<List<CollectionCenterEntity>> getActiveCollectionCenters();

  @Query('SELECT * FROM collection_centers WHERE is_deleted = 0 AND centre_status = "Inactive" ORDER BY center_name')
  Future<List<CollectionCenterEntity>> getInactiveCollectionCenters();
}