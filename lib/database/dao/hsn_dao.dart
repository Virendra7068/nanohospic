// lib/database/dao/hsn_dao.dart
import 'package:floor/floor.dart';
import '../entity/hsn_entity.dart';

@dao
abstract class HsnDao {
  @Query('SELECT * FROM hsn_codes WHERE is_deleted = 0 ORDER BY created_at DESC')
  Future<List<HsnEntity>> getAllHsnCodes();

  @Query('SELECT * FROM hsn_codes WHERE server_id = :serverId')
  Future<HsnEntity?> getHsnByServerId(int serverId);

  @Query('SELECT * FROM hsn_codes WHERE hsn_code LIKE :query AND is_deleted = 0')
  Future<List<HsnEntity>> searchHsnCodes(String query);

  @Query('SELECT * FROM hsn_codes WHERE is_synced = 0 AND is_deleted = 0')
  Future<List<HsnEntity>> getPendingSync();

  // ✅ सभी single value return करने वाले methods को nullable बनाएं
  @Query('SELECT COUNT(*) FROM hsn_codes WHERE is_deleted = 0')
  Future<int?> getTotalCount();

  @Query('SELECT COUNT(*) FROM hsn_codes WHERE is_synced = 1 AND is_deleted = 0')
  Future<int?> getSyncedCount();

  @Query('SELECT COUNT(*) FROM hsn_codes WHERE is_synced = 0 AND is_deleted = 0')
  Future<int?> getPendingCount();

  @Query('SELECT * FROM hsn_codes WHERE hsn_code = :hsnCode AND is_deleted = 0')
  Future<HsnEntity?> getHsnByCode(String hsnCode);

  @insert
  Future<int> insertHsn(HsnEntity hsn);

  @insert
  Future<List<int>> insertMultipleHsn(List<HsnEntity> hsnList);

  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> updateHsn(HsnEntity hsn);

  @Query('UPDATE hsn_codes SET is_synced = 1, sync_attempts = 0, last_sync_error = NULL WHERE id = :id')
  Future<void> markAsSynced(int id);

  @Query('UPDATE hsn_codes SET is_synced = 0, sync_attempts = sync_attempts + 1, last_sync_error = :error WHERE id = :id')
  Future<void> markAsFailed(int id, String error);

  @Query('UPDATE hsn_codes SET is_deleted = 1, deleted = :timestamp, deleted_by = :deletedBy WHERE id = :id')
  Future<void> softDelete(int id, String timestamp, String deletedBy);

  @Query('UPDATE hsn_codes SET server_id = :serverId WHERE id = :localId')
  Future<void> updateServerId(int localId, int serverId);

  @Query('DELETE FROM hsn_codes WHERE id = :id')
  Future<void> deleteHsn(int id);

  @Query('DELETE FROM hsn_codes')
  Future<void> deleteAll();

  // ✅ Additional useful queries
  @Query('SELECT DISTINCT hsn_type FROM hsn_codes WHERE is_deleted = 0')
  Future<List<int?>> getHsnTypes();

  @Query('SELECT * FROM hsn_codes WHERE created_at >= :date AND is_deleted = 0')
  Future<List<HsnEntity>> getHsnSinceDate(String date);
}