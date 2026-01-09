// lib/database/dao/group_dao.dart
import 'package:floor/floor.dart';
import 'package:nanohospic/database/entity/group_entity.dart';

@dao
abstract class GroupDao {
  @Query('SELECT * FROM groups WHERE id = :id')
  Future<GroupEntity?> getGroupById(int id);

  @Query('SELECT * FROM groups WHERE server_id = :serverId')
  Future<GroupEntity?> getGroupByServerId(int serverId);

  @Query('SELECT * FROM groups WHERE is_deleted = 0 ORDER BY name ASC')
  Future<List<GroupEntity>> getAllGroups();

  @Query('SELECT * FROM groups WHERE (name LIKE :query OR description LIKE :query) AND is_deleted = 0 ORDER BY name ASC')
  Future<List<GroupEntity>> searchGroups(String query);

  @Query('SELECT * FROM groups WHERE is_deleted = 0 AND (is_synced = 0 OR sync_status = "pending" OR sync_status = "failed") ORDER BY id ASC')
  Future<List<GroupEntity>> getPendingSyncGroups();

  @Query('SELECT COUNT(*) FROM groups WHERE is_deleted = 0')
  Future<int?> getGroupsCount();

  @Query('SELECT COUNT(*) FROM groups WHERE is_deleted = 0 AND is_synced = 1')
  Future<int?> getSyncedGroupsCount();

  @Query('SELECT COUNT(*) FROM groups WHERE is_deleted = 0 AND (is_synced = 0 OR sync_status = "pending" OR sync_status = "failed")')
  Future<int?> getPendingGroupsCount();

  @Query('UPDATE groups SET is_deleted = 1, deleted_by = "system", sync_status = "pending" WHERE id = :id')
  Future<int?> markAsDeleted(int id);

  @Query('UPDATE groups SET is_synced = 1, sync_status = "synced" WHERE id = :id')
  Future<int?> markAsSynced(int id);

  @Query('UPDATE groups SET sync_status = "failed" WHERE id = :id')
  Future<int?> markAsFailed(int id);

  @insert
  Future<int> insertGroup(GroupEntity group);

  @update
  Future<int> updateGroup(GroupEntity group);

  @delete
  Future<int> deleteGroup(GroupEntity group);
}