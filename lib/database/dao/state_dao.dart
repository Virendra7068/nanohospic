// lib/database/dao/state_dao.dart
import 'package:floor/floor.dart';
import 'package:nanohospic/database/entity/state_entity.dart';

@dao
abstract class StateDao {
  @Query('SELECT * FROM states WHERE id = :id')
  Future<StateEntity?> getStateById(int id);

  @Query('SELECT * FROM states WHERE server_id = :serverId')
  Future<StateEntity?> getStateByServerId(int serverId);

  @Query('SELECT * FROM states WHERE country_id = :countryId AND is_deleted = 0 ORDER BY name ASC')
  Future<List<StateEntity>> getStatesByCountry(int countryId);

  @Query('SELECT * FROM states WHERE name LIKE :query AND country_id = :countryId AND is_deleted = 0 ORDER BY name ASC')
  Future<List<StateEntity>> searchStates(String query, int countryId);

  @Query('SELECT * FROM states WHERE is_deleted = 0 AND (is_synced = 0 OR sync_status = "pending" OR sync_status = "failed") ORDER BY id ASC')
  Future<List<StateEntity>> getPendingSyncStates();

  @Query('SELECT COUNT(*) FROM states WHERE country_id = :countryId AND is_deleted = 0')
  Future<int?> getStatesCountByCountry(int countryId);

  @Query('SELECT COUNT(*) FROM states WHERE is_deleted = 0 AND is_synced = 1')
  Future<int?> getSyncedStatesCount();

  @Query('SELECT COUNT(*) FROM states WHERE is_deleted = 0 AND (is_synced = 0 OR sync_status = "pending" OR sync_status = "failed")')
  Future<int?> getPendingStatesCount();

  // FIXED: Make these return nullable Future<int?>
  @Query('UPDATE states SET is_deleted = 1, sync_status = "pending" WHERE id = :id')
  Future<int?> markAsDeleted(int id);

  @Query('UPDATE states SET is_synced = 1, sync_status = "synced" WHERE id = :id')
  Future<int?> markAsSynced(int id);

  @Query('UPDATE states SET sync_status = "failed" WHERE id = :id')
  Future<int?> markAsFailed(int id);

  @insert
  Future<int> insertState(StateEntity state);

  @update
  Future<int> updateState(StateEntity state);

  @delete
  Future<int> deleteState(StateEntity state);
}