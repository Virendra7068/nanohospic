// // lib/database/dao/city_dao.dart
// import 'package:floor/floor.dart';
// import 'package:nanohospic/database/entity/city_entity.dart';

// @dao
// abstract class CityDao {
//   @Query('SELECT * FROM cities WHERE id = :id')
//   Future<CityEntity?> getCityById(int id);

//   @Query('SELECT * FROM cities WHERE server_id = :serverId')
//   Future<CityEntity?> getCityByServerId(int serverId);

//   @Query('SELECT * FROM cities WHERE state_id = :stateId AND is_deleted = 0 ORDER BY name ASC')
//   Future<List<CityEntity>> getCitiesByState(int stateId);

//   @Query('SELECT * FROM cities WHERE name LIKE :query AND state_id = :stateId AND is_deleted = 0 ORDER BY name ASC')
//   Future<List<CityEntity>> searchCities(String query, int stateId);

//   @Query('SELECT * FROM cities WHERE is_deleted = 0 AND (is_synced = 0 OR sync_status = "pending" OR sync_status = "failed") ORDER BY id ASC')
//   Future<List<CityEntity>> getPendingSyncCities();

//   @Query('SELECT COUNT(*) FROM cities WHERE state_id = :stateId AND is_deleted = 0')
//   Future<int?> getCitiesCountByState(int stateId);

//   @Query('SELECT COUNT(*) FROM cities WHERE is_deleted = 0 AND is_synced = 1')
//   Future<int?> getSyncedCitiesCount();

//   @Query('SELECT COUNT(*) FROM cities WHERE is_deleted = 0 AND (is_synced = 0 OR sync_status = "pending" OR sync_status = "failed")')
//   Future<int?> getPendingCitiesCount();

//   // FIXED: Make these return nullable Future<int?>
//   @Query('UPDATE cities SET is_deleted = 1, sync_status = "pending" WHERE id = :id')
//   Future<int?> markAsDeleted(int id);

//   @Query('UPDATE cities SET is_synced = 1, sync_status = "synced" WHERE id = :id')
//   Future<int?> markAsSynced(int id);

//   @Query('UPDATE cities SET sync_status = "failed" WHERE id = :id')
//   Future<int?> markAsFailed(int id);

//   @insert
//   Future<int> insertCity(CityEntity city);

//   @update
//   Future<int> updateCity(CityEntity city);

//   @delete
//   Future<int> deleteCity(CityEntity city);
// }


// lib/database/dao/city_dao.dart
import 'package:floor/floor.dart';
import 'package:nanohospic/database/entity/city_entity.dart';

@dao
abstract class CityDao {
  @Query('SELECT * FROM cities WHERE id = :id')
  Future<CityEntity?> getCityById(int id);

  @Query('SELECT * FROM cities WHERE server_id = :serverId')
  Future<CityEntity?> getCityByServerId(int serverId);

  @Query('SELECT * FROM cities WHERE state_id = :stateId AND is_deleted = 0 ORDER BY name ASC')
  Future<List<CityEntity>> getCitiesByState(int stateId);

  // ✅ NEW: Get cities by both stateId and countryId
  @Query('SELECT * FROM cities WHERE state_id = :stateId AND country_id = :countryId AND is_deleted = 0 ORDER BY name ASC')
  Future<List<CityEntity>> getCitiesByStateAndCountry(int stateId, int countryId);

  @Query('SELECT * FROM cities WHERE name LIKE :query AND state_id = :stateId AND is_deleted = 0 ORDER BY name ASC')
  Future<List<CityEntity>> searchCities(String query, int stateId);

  // ✅ NEW: Search cities with countryId
  @Query('SELECT * FROM cities WHERE name LIKE :query AND state_id = :stateId AND country_id = :countryId AND is_deleted = 0 ORDER BY name ASC')
  Future<List<CityEntity>> searchCitiesWithCountry(String query, int stateId, int countryId);

  @Query('SELECT * FROM cities WHERE is_deleted = 0 AND (is_synced = 0 OR sync_status = "pending" OR sync_status = "failed") ORDER BY id ASC')
  Future<List<CityEntity>> getPendingSyncCities();

  // ✅ NEW: Get pending sync cities by stateId and countryId
  @Query('SELECT * FROM cities WHERE state_id = :stateId AND country_id = :countryId AND is_deleted = 0 AND (is_synced = 0 OR sync_status = "pending" OR sync_status = "failed") ORDER BY id ASC')
  Future<List<CityEntity>> getPendingSyncByStateAndCountry(int stateId, int countryId);

  @Query('SELECT COUNT(*) FROM cities WHERE state_id = :stateId AND is_deleted = 0')
  Future<int?> getCitiesCountByState(int stateId);

  // ✅ NEW: Get count by stateId and countryId
  @Query('SELECT COUNT(*) FROM cities WHERE state_id = :stateId AND country_id = :countryId AND is_deleted = 0')
  Future<int?> getCitiesCountByStateAndCountry(int stateId, int countryId);

  @Query('SELECT COUNT(*) FROM cities WHERE is_deleted = 0 AND is_synced = 1')
  Future<int?> getSyncedCitiesCount();

  // ✅ NEW: Get synced count by stateId and countryId
  @Query('SELECT COUNT(*) FROM cities WHERE state_id = :stateId AND country_id = :countryId AND is_deleted = 0 AND is_synced = 1')
  Future<int?> getSyncedCountByStateAndCountry(int stateId, int countryId);

  @Query('SELECT COUNT(*) FROM cities WHERE is_deleted = 0 AND (is_synced = 0 OR sync_status = "pending" OR sync_status = "failed")')
  Future<int?> getPendingCitiesCount();

  // ✅ NEW: Get pending count by stateId and countryId
  @Query('SELECT COUNT(*) FROM cities WHERE state_id = :stateId AND country_id = :countryId AND is_deleted = 0 AND (is_synced = 0 OR sync_status = "pending" OR sync_status = "failed")')
  Future<int?> getPendingCountByStateAndCountry(int stateId, int countryId);

  // ✅ NEW: Get deleted cities count by stateId and countryId
  @Query('SELECT COUNT(*) FROM cities WHERE state_id = :stateId AND country_id = :countryId AND is_deleted = 1')
  Future<int?> getDeletedCountByStateAndCountry(int stateId, int countryId);

  // ✅ NEW: Get all cities (including deleted) by stateId and countryId
  @Query('SELECT * FROM cities WHERE state_id = :stateId AND country_id = :countryId ORDER BY name ASC')
  Future<List<CityEntity>> getAllCitiesByStateAndCountry(int stateId, int countryId);

  // FIXED: Make these return nullable Future<int?>
  @Query('UPDATE cities SET is_deleted = 1, sync_status = "pending" WHERE id = :id')
  Future<int?> markAsDeleted(int id);

  @Query('UPDATE cities SET is_synced = 1, sync_status = "synced" WHERE id = :id')
  Future<int?> markAsSynced(int id);

  @Query('UPDATE cities SET sync_status = "failed" WHERE id = :id')
  Future<int?> markAsFailed(int id);

  // ✅ NEW: Bulk update - mark multiple cities as synced
  @Query('UPDATE cities SET is_synced = 1, sync_status = "synced" WHERE id IN (:ids)')
  Future<int?> markMultipleAsSynced(List<int> ids);

  // ✅ NEW: Bulk update - mark multiple cities as pending
  @Query('UPDATE cities SET is_synced = 0, sync_status = "pending" WHERE id IN (:ids)')
  Future<int?> markMultipleAsPending(List<int> ids);

  // ✅ NEW: Delete all cities by stateId and countryId
  @Query('DELETE FROM cities WHERE state_id = :stateId AND country_id = :countryId')
  Future<int?> deleteAllByStateAndCountry(int stateId, int countryId);

  // ✅ NEW: Soft delete all cities by stateId and countryId
  @Query('UPDATE cities SET is_deleted = 1, sync_status = "pending" WHERE state_id = :stateId AND country_id = :countryId AND is_deleted = 0')
  Future<int?> softDeleteAllByStateAndCountry(int stateId, int countryId);

  // ✅ NEW: Restore deleted cities by stateId and countryId
  @Query('UPDATE cities SET is_deleted = 0, sync_status = "pending" WHERE state_id = :stateId AND country_id = :countryId AND is_deleted = 1')
  Future<int?> restoreDeletedByStateAndCountry(int stateId, int countryId);

  @insert
  Future<int> insertCity(CityEntity city);

  @update
  Future<int> updateCity(CityEntity city);

  @delete
  Future<int> deleteCity(CityEntity city);

  // ✅ NEW: Bulk insert
  @insert
  Future<List<int>> insertCities(List<CityEntity> cities);

  // ✅ NEW: Bulk update
  @update
  Future<int> updateCities(List<CityEntity> cities);

  // ✅ NEW: Bulk delete
  @delete
  Future<int> deleteCities(List<CityEntity> cities);

  // ✅ NEW: Get city by name, stateId and countryId
  @Query('SELECT * FROM cities WHERE name = :name AND state_id = :stateId AND country_id = :countryId AND is_deleted = 0 LIMIT 1')
  Future<CityEntity?> getCityByNameAndStateAndCountry(String name, int stateId, int countryId);

  // ✅ NEW: Check if city exists
  @Query('SELECT COUNT(*) FROM cities WHERE name = :name AND state_id = :stateId AND country_id = :countryId AND is_deleted = 0')
  Future<int?> checkCityExists(String name, int stateId, int countryId);
}