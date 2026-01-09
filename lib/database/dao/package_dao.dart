import 'package:floor/floor.dart';
import '../entity/package_entity.dart';

@dao
abstract class PackageDao {
  @Query('SELECT * FROM packages WHERE is_deleted = 0 ORDER BY name')
  Future<List<PackageEntity>> getAllPackages();

  @Query('SELECT * FROM packages WHERE code = :code AND is_deleted = 0')
  Future<PackageEntity?> getPackageByCode(String code);

  @Query('SELECT * FROM packages WHERE is_synced = 0')
  Future<List<PackageEntity>> getUnsyncedPackages();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertPackage(PackageEntity package);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertPackages(List<PackageEntity> packages);

  @Update()
  Future<void> updatePackage(PackageEntity package);

  @Query('UPDATE packages SET is_deleted = 1, deleted_by = :deletedBy WHERE code = :code')
  Future<void> softDeletePackage(String code, String deletedBy);

  @delete
  Future<void> deletePackage(PackageEntity package);

  @Query('DELETE FROM packages WHERE code = :code')
  Future<void> deletePackageByCode(String code);

  @Query('SELECT COUNT(*) FROM packages WHERE is_deleted = 0')
  Future<int?> getPackageCount();

  @Query('SELECT * FROM packages WHERE name LIKE :query OR code LIKE :query AND is_deleted = 0')
  Future<List<PackageEntity>> searchPackages(String query);
}