import 'package:floor/floor.dart';
import 'package:nanohospic/database/entity/company_entity.dart';

@dao
abstract class CompanyDao {
  @Query('SELECT * FROM companies WHERE is_deleted = 0 ORDER BY id DESC')
  Future<List<CompanyEntity>> getAllCompanies();
  
  @Query('SELECT * FROM companies WHERE server_id = :serverId')
  Future<CompanyEntity?> getCompanyByServerId(int serverId);
  
  @Query('SELECT * FROM companies WHERE id = :id')
  Future<CompanyEntity?> getCompanyById(int id);
  
  @Query('SELECT COUNT(*) FROM companies WHERE is_deleted = 0')
  Future<int> getTotalCount();
  
  @Query('SELECT COUNT(*) FROM companies WHERE is_synced = 1 AND is_deleted = 0')
  Future<int> getSyncedCount();
  
  @Query('SELECT COUNT(*) FROM companies WHERE sync_pending = 1 OR is_synced = 0')
  Future<int> getPendingCount();
  
  @Query('SELECT * FROM companies WHERE sync_pending = 1 OR is_synced = 0')
  Future<List<CompanyEntity>> getPendingSync();
  
  @Query('SELECT * FROM companies WHERE name LIKE :query AND is_deleted = 0')
  Future<List<CompanyEntity>> searchCompanies(String query);
  
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertCompany(CompanyEntity company);
  
  @Update()
  Future<void> updateCompany(CompanyEntity company);
  
  @Query('UPDATE companies SET is_deleted = 1, sync_pending = 1 WHERE id = :id')
  Future<void> softDeleteCompany(int id);
  
  @Query('UPDATE companies SET is_synced = 1, sync_pending = 0, sync_error = 0, error_message = NULL WHERE id = :id')
  Future<void> markAsSynced(int id);
  
  @Query('UPDATE companies SET sync_error = 1, error_message = :errorMessage WHERE id = :id')
  Future<void> markAsSyncError(int id, String errorMessage);
  
  @Query('DELETE FROM companies WHERE id = :id')
  Future<void> deleteCompany(int id);
}