// lib/database/dao/group_dao.dart
import 'package:floor/floor.dart';
import '../entity/group_entity.dart';

@dao
abstract class GroupDao {
  @Query('SELECT * FROM groups WHERE is_deleted = 0 ORDER BY name')
  Future<List<GroupEntity>> getAllGroups();

  @Query('SELECT * FROM groups WHERE id = :id')
  Future<GroupEntity?> getGroupById(int id);

  @Query('SELECT * FROM groups WHERE server_id = :serverId')
  Future<GroupEntity?> getGroupByServerId(int serverId);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertGroup(GroupEntity group);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertGroups(List<GroupEntity> groups);

  @Update()
  Future<void> updateGroup(GroupEntity group);

  @Query('DELETE FROM groups WHERE id = :id')
  Future<void> deleteGroup(int id);

  @Query('SELECT COUNT(*) FROM groups WHERE is_deleted = 0')
  Future<int?> getTotalCount();

  @Query('SELECT COUNT(*) FROM groups WHERE is_synced = 1 AND is_deleted = 0')
  Future<int?> getSyncedCount();

  @Query('SELECT COUNT(*) FROM groups WHERE is_synced = 0 AND is_deleted = 0')
  Future<int?> getPendingCount();

  @Query('SELECT * FROM groups WHERE is_synced = 0 AND is_deleted = 0')
  Future<List<GroupEntity>> getPendingSync();

  @Query('UPDATE groups SET is_synced = 1, sync_status = "synced" WHERE id = :id')
  Future<void> markAsSynced(int id);

  @Query('UPDATE groups SET server_id = :serverId WHERE id = :id')
  Future<void> updateServerId(int id, int serverId);

  @Query('UPDATE groups SET sync_attempts = sync_attempts + 1, last_sync_error = :error WHERE id = :id')
  Future<void> updateSyncError(int id, String error);

  // FIXED: Added parentheses to fix logical OR condition
  @Query('SELECT * FROM groups WHERE (name LIKE :query OR code LIKE :query) AND is_deleted = 0')
  Future<List<GroupEntity>> searchGroups(String query);

  // Optional: Add method to soft delete (mark as deleted)
  @Query('UPDATE groups SET is_deleted = 1, deleted_by = :deletedBy, last_modified = :timestamp WHERE id = :id')
  Future<void> softDeleteGroup(int id, String deletedBy, String timestamp);

  // Optional: Add method to get deleted groups
  @Query('SELECT * FROM groups WHERE is_deleted = 1 ORDER BY name')
  Future<List<GroupEntity>> getDeletedGroups();

  // Optional: Add method to restore deleted group
  @Query('UPDATE groups SET is_deleted = 0, deleted_by = NULL WHERE id = :id')
  Future<void> restoreGroup(int id);
}