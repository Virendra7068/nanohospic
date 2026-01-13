// // lib/database/dao/division_dao.dart
// import 'package:floor/floor.dart';
// import '../entity/division_entity.dart';

// @dao
// abstract class DivisionDao {
//   @Query('SELECT * FROM divisions WHERE is_deleted = 0 ORDER BY name')
//   Future<List<DivisionEntity>> getAllDivisions();

//   @Query('SELECT * FROM divisions WHERE id = :id')
//   Future<DivisionEntity?> getDivisionById(int id);

//   @Query('SELECT * FROM divisions WHERE server_id = :serverId')
//   Future<DivisionEntity?> getDivisionByServerId(int serverId);

//   @Query('SELECT * FROM divisions WHERE is_synced = 0 AND is_deleted = 0')
//   Future<List<DivisionEntity>> getPendingSync();

//   // Fix 1: Make COUNT queries return nullable
//   @Query('SELECT COUNT(*) FROM divisions WHERE is_deleted = 0')
//   Future<int?> getTotalCount();

//   @Query('SELECT COUNT(*) FROM divisions WHERE is_synced = 1 AND is_deleted = 0')
//   Future<int?> getSyncedCount();

//   @Query('SELECT COUNT(*) FROM divisions WHERE is_synced = 0 AND is_deleted = 0')
//   Future<int?> getPendingCount();

//   @Query('SELECT * FROM divisions WHERE name LIKE :query AND is_deleted = 0 ORDER BY name')
//   Future<List<DivisionEntity>> searchDivisions(String query);

//   @Query('SELECT * FROM divisions WHERE company_id = :companyId AND is_deleted = 0 ORDER BY name')
//   Future<List<DivisionEntity>> getDivisionsByCompany(int companyId);

//   @Insert(onConflict: OnConflictStrategy.replace)
//   Future<void> insertDivision(DivisionEntity division);

//   @Update(onConflict: OnConflictStrategy.replace)
//   Future<void> updateDivision(DivisionEntity division);

//   // Fix 2: Remove nullable parameter from @Query method
//   @Query('UPDATE divisions SET is_deleted = 1, deleted_by = :deletedBy, is_synced = 0, sync_status = \'pending\' WHERE id = :id')
//   Future<void> softDeleteDivision(int id, String deletedBy); // Changed String? to String

//   @Query('UPDATE divisions SET is_synced = 1, sync_status = \'synced\' WHERE id = :id')
//   Future<void> markAsSynced(int id);

//   @Query('UPDATE divisions SET sync_status = \'failed\' WHERE id = :id')
//   Future<void> markAsFailed(int id);

//   @Query('DELETE FROM divisions WHERE id = :id')
//   Future<void> deleteDivision(int id);

//   @Query('DELETE FROM divisions')
//   Future<void> deleteAllDivisions();
// }


// lib/database/dao/division_dao.dart
import 'package:floor/floor.dart';
import '../entity/division_entity.dart';

@dao
abstract class DivisionDao {
  @Query('SELECT * FROM divisions WHERE is_deleted = 0 ORDER BY name')
  Future<List<DivisionEntity>> getAllDivisions();

  @Query('SELECT * FROM divisions WHERE id = :id')
  Future<DivisionEntity?> getDivisionById(int id);

  @Query('SELECT * FROM divisions WHERE server_id = :serverId')
  Future<DivisionEntity?> getDivisionByServerId(int serverId);

  @Query('SELECT * FROM divisions WHERE is_synced = 0 AND is_deleted = 0')
  Future<List<DivisionEntity>> getPendingSync();

  // Make COUNT queries nullable
  @Query('SELECT COUNT(*) FROM divisions WHERE is_deleted = 0')
  Future<int?> getTotalCount();

  @Query('SELECT COUNT(*) FROM divisions WHERE is_synced = 1 AND is_deleted = 0')
  Future<int?> getSyncedCount();

  @Query('SELECT COUNT(*) FROM divisions WHERE is_synced = 0 AND is_deleted = 0')
  Future<int?> getPendingCount();

  @Query('SELECT * FROM divisions WHERE name LIKE :query AND is_deleted = 0 ORDER BY name')
  Future<List<DivisionEntity>> searchDivisions(String query);

  @Query('SELECT * FROM divisions WHERE company_id = :companyId AND is_deleted = 0 ORDER BY name')
  Future<List<DivisionEntity>> getDivisionsByCompany(int companyId);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertDivision(DivisionEntity division);

  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> updateDivision(DivisionEntity division);

  // Use non-nullable parameter in @Query
  @Query('UPDATE divisions SET is_deleted = 1, deleted_by = :deletedBy, is_synced = 0, sync_status = \'pending\' WHERE id = :id')
  Future<void> softDeleteDivision(int id, String deletedBy);

  @Query('UPDATE divisions SET is_synced = 1, sync_status = \'synced\' WHERE id = :id')
  Future<void> markAsSynced(int id);

  @Query('UPDATE divisions SET sync_status = \'failed\' WHERE id = :id')
  Future<void> markAsFailed(int id);

  @Query('DELETE FROM divisions WHERE id = :id')
  Future<void> deleteDivision(int id);

  @Query('DELETE FROM divisions')
  Future<void> deleteAllDivisions();
}