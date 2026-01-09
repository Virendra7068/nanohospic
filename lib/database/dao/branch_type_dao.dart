import 'package:floor/floor.dart';
import '../entity/branch_type_entity.dart';

@dao
abstract class BranchTypeDao {
  @Query('SELECT * FROM branch_types WHERE is_deleted = 0 ORDER BY company_name')
  Future<List<BranchTypeEntity>> getAllBranchTypes();

  @Query('SELECT * FROM branch_types WHERE id = :id')
  Future<BranchTypeEntity?> getBranchTypeById(int id);

  @Query('SELECT * FROM branch_types WHERE server_id = :serverId')
  Future<BranchTypeEntity?> getBranchTypeByServerId(int serverId);

  @Query('SELECT * FROM branch_types WHERE is_synced = 0 AND is_deleted = 0')
  Future<List<BranchTypeEntity>> getPendingSync();

  @Query('SELECT COUNT(*) FROM branch_types WHERE is_deleted = 0')
  Future<int?> getTotalCount();

  @Query('SELECT COUNT(*) FROM branch_types WHERE is_synced = 1 AND is_deleted = 0')
  Future<int?> getSyncedCount();

  @Query('SELECT COUNT(*) FROM branch_types WHERE is_synced = 0 AND is_deleted = 0')
  Future<int?> getPendingCount();

  @Query('''
    SELECT * FROM branch_types 
    WHERE is_deleted = 0 
    AND (
      company_name LIKE :query OR
      contact_person LIKE :query OR
      contact_no LIKE :query OR
      email LIKE :query OR
      location LIKE :query
    )
    ORDER BY company_name
  ''')
  Future<List<BranchTypeEntity>> searchBranchTypes(String query);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<List<int>> insertBranchTypeList(List<BranchTypeEntity> branchTypes);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> insertBranchType(BranchTypeEntity branchType);

  @Update()
  Future<void> updateBranchType(BranchTypeEntity branchType);

  @Query('DELETE FROM branch_types WHERE id = :id')
  Future<void> deleteBranchType(int id);

  @Query('''
    UPDATE branch_types 
    SET is_deleted = 1, 
        deleted_by = :deletedBy,
        last_modified = :lastModified,
        is_synced = 0,
        sync_status = 'pending'
    WHERE id = :id
  ''')
  Future<void> softDeleteBranchType(int id, String deletedBy, String lastModified);

  @Query('UPDATE branch_types SET is_synced = 1, sync_status = "synced" WHERE id = :id')
  Future<void> markAsSynced(int id);

  @Query('UPDATE branch_types SET server_id = :serverId WHERE id = :id')
  Future<void> updateServerId(int id, int serverId);

  @Query('UPDATE branch_types SET last_sync_error = :error WHERE id = :id')
  Future<void> updateSyncError(int id, String error);

  @Query('UPDATE branch_types SET sync_attempts = sync_attempts + 1 WHERE id = :id')
  Future<void> incrementSyncAttempts(int id);
}