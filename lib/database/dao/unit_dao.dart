// lib/database/dao/unit_dao.dart
import 'package:floor/floor.dart';
import 'package:nanohospic/database/entity/unit_entity.dart';

@dao
abstract class UnitDao {
  @Query('SELECT * FROM units WHERE id = :id')
  Future<UnitEntity?> getUnitById(int id);

  @Query('SELECT * FROM units WHERE server_id = :serverId')
  Future<UnitEntity?> getUnitByServerId(int serverId);

  @Query('SELECT * FROM units WHERE is_deleted = 0 ORDER BY name ASC')
  Future<List<UnitEntity>> getAllUnits();

  @Query('SELECT * FROM units WHERE name LIKE :query AND is_deleted = 0 ORDER BY name ASC')
  Future<List<UnitEntity>> searchUnits(String query);

  @Query('SELECT * FROM units WHERE is_deleted = 0 AND (is_synced = 0 OR sync_status = "pending" OR sync_status = "failed") ORDER BY id ASC')
  Future<List<UnitEntity>> getPendingSyncUnits();

  @Query('SELECT COUNT(*) FROM units WHERE is_deleted = 0')
  Future<int?> getUnitsCount();

  @Query('SELECT COUNT(*) FROM units WHERE is_deleted = 0 AND is_synced = 1')
  Future<int?> getSyncedUnitsCount();

  @Query('SELECT COUNT(*) FROM units WHERE is_deleted = 0 AND (is_synced = 0 OR sync_status = "pending" OR sync_status = "failed")')
  Future<int?> getPendingUnitsCount();

  // Fixed to return nullable
  @Query('UPDATE units SET is_deleted = 1, deleted_by = "system", sync_status = "pending" WHERE id = :id')
  Future<int?> markAsDeleted(int id);

  @Query('UPDATE units SET is_synced = 1, sync_status = "synced" WHERE id = :id')
  Future<int?> markAsSynced(int id);

  @Query('UPDATE units SET sync_status = "failed" WHERE id = :id')
  Future<int?> markAsFailed(int id);

  @insert
  Future<int> insertUnit(UnitEntity unit);

  @update
  Future<int> updateUnit(UnitEntity unit);

  @delete
  Future<int> deleteUnit(UnitEntity unit);
}