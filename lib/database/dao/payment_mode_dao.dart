// ignore_for_file: avoid_print

import 'package:floor/floor.dart';
import 'package:nanohospic/database/entity/payment_mode_entity.dart';

@dao
abstract class PaymentModeDao {
  @Query('SELECT * FROM payment_modes ORDER BY name ASC')
  Future<List<PaymentModeEntity>> getAllPaymentModes();

  @Query('SELECT * FROM payment_modes WHERE id = :id')
  Future<PaymentModeEntity?> getPaymentModeById(int id);

  @Query('SELECT * FROM payment_modes WHERE server_id = :serverId')
  Future<PaymentModeEntity?> getPaymentModeByServerId(int serverId);

  @Query('SELECT * FROM payment_modes WHERE name LIKE :search ORDER BY name ASC')
  Future<List<PaymentModeEntity>> searchPaymentModes(String search);

  @Query('SELECT COUNT(*) FROM payment_modes')
  Future<int?> getTotalCount();

  @Query('SELECT COUNT(*) FROM payment_modes WHERE is_synced = 1')
  Future<int?> getSyncedCount();

  @Query('SELECT COUNT(*) FROM payment_modes WHERE is_synced = 0')
  Future<int?> getPendingCount();

  @Query('SELECT * FROM payment_modes WHERE is_synced = 0 ORDER BY id ASC')
  Future<List<PaymentModeEntity>> getPendingSync();

  @Query('SELECT * FROM payment_modes WHERE is_deleted = 0 ORDER BY name ASC')
  Future<List<PaymentModeEntity>> getActivePaymentModes();

  @Query('UPDATE payment_modes SET is_synced = 1, sync_status = "synced" WHERE id = :id')
  Future<void> markAsSynced(int id);

  @Query('UPDATE payment_modes SET server_id = :serverId WHERE id = :id')
  Future<void> updateServerId(int id, int serverId);

  @Query('UPDATE payment_modes SET sync_attempts = sync_attempts + 1, last_sync_error = :error WHERE id = :id')
  Future<void> updateSyncError(int id, String error);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertPaymentMode(PaymentModeEntity paymentMode);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<List<int>> insertPaymentModeList(List<PaymentModeEntity> paymentModes);

  @Update()
  Future<void> updatePaymentMode(PaymentModeEntity paymentMode);

  @Query('UPDATE payment_modes SET is_deleted = 1, deleted_by = :deletedBy, last_modified = :timestamp WHERE id = :id')
  Future<void> softDeletePaymentMode(int id, String deletedBy, String timestamp);

  @Query('DELETE FROM payment_modes WHERE id = :id')
  Future<void> deletePaymentMode(int id);

  @Query('DELETE FROM payment_modes')
  Future<void> deleteAllPaymentModes();
}