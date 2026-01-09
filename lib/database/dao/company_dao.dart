// lib/data/local/dao/company_dao.dart
import 'package:floor/floor.dart';
import '../entity/company_entity.dart';

@dao
abstract class CompanyDao {
  @Query('SELECT * FROM companies WHERE isDeleted = 0 ORDER BY lastModified DESC')
  Future<List<CompanyEntity>> getAllCompanies();
  
  @Query('SELECT * FROM companies WHERE isSynced = 0 AND isDeleted = 0')
  Future<List<CompanyEntity>> getUnsyncedCompanies();
  
  @Query('SELECT * FROM companies WHERE id = :id')
  Future<CompanyEntity?> getCompanyById(int id);
  
  @Query('SELECT * FROM companies WHERE name LIKE :query AND isDeleted = 0 ORDER BY lastModified DESC')
  Future<List<CompanyEntity>> searchCompanies(String query);
  
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> insertCompany(CompanyEntity company);
  
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<List<int>> insertCompanies(List<CompanyEntity> companies);
  
  @Update()
  Future<void> updateCompany(CompanyEntity company);
  
  @Query('UPDATE companies SET isDeleted = 1, lastModified = :timestamp WHERE id = :id')
  Future<void> markAsDeleted(int id, DateTime timestamp);
  
  @Query('DELETE FROM companies WHERE id = :id')
  Future<void> deleteCompany(int id);
  
  @Query('DELETE FROM companies')
  Future<void> deleteAllCompanies();
}