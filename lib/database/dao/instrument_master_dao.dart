// lib/database/dao/instrument_dao.dart
import 'package:floor/floor.dart';
import 'package:nanohospic/database/entity/instrument_entity.dart';

@dao
abstract class InstrumentDao {
  @Query('SELECT * FROM instruments WHERE id = :id')
  Future<InstrumentEntity?> getInstrumentById(int id);

  @Query('SELECT * FROM instruments WHERE server_id = :serverId')
  Future<InstrumentEntity?> getInstrumentByServerId(int serverId);

  @Query('SELECT * FROM instruments WHERE is_deleted = 0 ORDER BY machine_name ASC')
  Future<List<InstrumentEntity>> getAllInstruments();

  @Query('SELECT * FROM instruments WHERE (machine_name LIKE :query OR description LIKE :query) AND is_deleted = 0 ORDER BY machine_name ASC')
  Future<List<InstrumentEntity>> searchInstruments(String query);

  @Query('SELECT * FROM instruments WHERE is_deleted = 0 AND (is_synced = 0 OR sync_status = "pending" OR sync_status = "failed") ORDER BY id ASC')
  Future<List<InstrumentEntity>> getPendingSyncInstruments();

  @Query('SELECT COUNT(*) FROM instruments WHERE is_deleted = 0')
  Future<int?> getInstrumentsCount();

  @Query('SELECT COUNT(*) FROM instruments WHERE is_deleted = 0 AND is_synced = 1')
  Future<int?> getSyncedInstrumentsCount();

  @Query('SELECT COUNT(*) FROM instruments WHERE is_deleted = 0 AND (is_synced = 0 OR sync_status = "pending" OR sync_status = "failed")')
  Future<int?> getPendingInstrumentsCount();

  @Query('UPDATE instruments SET is_deleted = 1, deleted_by = "system", sync_status = "pending" WHERE id = :id')
  Future<int?> markAsDeleted(int id);

  @Query('UPDATE instruments SET is_synced = 1, sync_status = "synced" WHERE id = :id')
  Future<int?> markAsSynced(int id);

  @Query('UPDATE instruments SET sync_status = "failed" WHERE id = :id')
  Future<int?> markAsFailed(int id);

  @insert
  Future<int> insertInstrument(InstrumentEntity instrument);

  @update
  Future<int> updateInstrument(InstrumentEntity instrument);

  @delete
  Future<int> deleteInstrument(InstrumentEntity instrument);
}