// lib/database/dao/doctor_commission_dao.dart
import 'package:floor/floor.dart';
import 'package:nanohospic/database/entity/doctor_commision_entity.dart';

@dao
abstract class DoctorCommissionDao {
  @Query('SELECT * FROM doctor_commissions WHERE is_deleted = 0 ORDER BY doctor_name ASC')
  Future<List<DoctorCommissionEntity>> getAllCommissions();

  @Query('SELECT * FROM doctor_commissions WHERE id = :id')
  Future<DoctorCommissionEntity?> getCommissionById(int id);

  @Query('SELECT * FROM doctor_commissions WHERE server_id = :serverId')
  Future<DoctorCommissionEntity?> getCommissionByServerId(int serverId);

  @Query('SELECT * FROM doctor_commissions WHERE is_synced = 0 OR sync_status = \'failed\'')
  Future<List<DoctorCommissionEntity>> getPendingSync();

  @Query('SELECT * FROM doctor_commissions WHERE referrer_id = :referrerId AND is_deleted = 0')
  Future<List<DoctorCommissionEntity>> getCommissionsByReferrer(int referrerId);

  @Query('SELECT * FROM doctor_commissions WHERE status = :status AND is_deleted = 0')
  Future<List<DoctorCommissionEntity>> getCommissionsByStatus(String status);

  @Query('SELECT * FROM doctor_commissions WHERE commission_for = :commissionFor AND is_deleted = 0')
  Future<List<DoctorCommissionEntity>> getCommissionsByType(String commissionFor);

  @insert
  Future<int> insertCommission(DoctorCommissionEntity commission);

  @update
  Future<int> updateCommission(DoctorCommissionEntity commission);

  // For queries that return single values (counts), they should be nullable
  @Query('UPDATE doctor_commissions SET is_deleted = 1, deleted_by = :deletedBy, last_modified = :timestamp, is_synced = 0, sync_status = \'pending\' WHERE id = :id')
  Future<void> softDeleteCommission(int id, String deletedBy, String timestamp); // Changed to Future<void>

  @Query('UPDATE doctor_commissions SET is_synced = 1, sync_status = \'synced\' WHERE id = :id')
  Future<void> markAsSynced(int id); // Changed to Future<void>

  @Query('UPDATE doctor_commissions SET sync_status = \'failed\' WHERE id = :id')
  Future<void> markAsFailed(int id); // Changed to Future<void>

  @Query('UPDATE doctor_commissions SET server_id = :serverId WHERE id = :id')
  Future<void> updateServerId(int id, int serverId); // Changed to Future<void>

  @Query('SELECT COUNT(*) FROM doctor_commissions WHERE is_deleted = 0')
  Future<int?> getActiveCommissionCount(); // Changed to nullable

  @Query('SELECT COUNT(*) FROM doctor_commissions WHERE is_synced = 0 AND is_deleted = 0')
  Future<int?> getPendingSyncCount(); // Changed to nullable
}