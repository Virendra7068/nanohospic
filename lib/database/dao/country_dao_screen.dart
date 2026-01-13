// lib/database/dao/country_dao.dart
import 'package:floor/floor.dart';
import 'package:nanohospic/database/entity/country_entity.dart';

@dao
abstract class CountryDao {
  @Query('SELECT * FROM countries WHERE id = :id')
  Future<CountryEntity?> getCountryById(int id);

  @Query('SELECT * FROM countries WHERE server_id = :serverId')
  Future<CountryEntity?> getCountryByServerId(int serverId);

  @Query('SELECT * FROM countries WHERE is_deleted = 0 ORDER BY name ASC')
  Future<List<CountryEntity>> getAllCountries();

  @Query('SELECT * FROM countries WHERE name LIKE :query AND is_deleted = 0 ORDER BY name ASC')
  Future<List<CountryEntity>> searchCountries(String query);

  @Query('SELECT * FROM countries WHERE is_deleted = 0 AND (is_synced = 0 OR sync_status = "pending" OR sync_status = "failed") ORDER BY id ASC')
  Future<List<CountryEntity>> getPendingSyncCountries();

  @Query('SELECT COUNT(*) FROM countries WHERE is_deleted = 0')
  Future<int?> getCountriesCount();

  @Query('SELECT COUNT(*) FROM countries WHERE is_deleted = 0 AND is_synced = 1')
  Future<int?> getSyncedCountriesCount();

  @Query('SELECT COUNT(*) FROM countries WHERE is_deleted = 0 AND (is_synced = 0 OR sync_status = "pending" OR sync_status = "failed")')
  Future<int?> getPendingCountriesCount();

  @Query('UPDATE countries SET is_deleted = 1, deleted_by = "system", sync_status = "pending" WHERE id = :id')
  Future<int?> markAsDeleted(int id);

  @Query('UPDATE countries SET is_synced = 1, sync_status = "synced" WHERE id = :id')
  Future<int?> markAsSynced(int id);

  @Query('UPDATE countries SET sync_status = "failed" WHERE id = :id')
  Future<int?> markAsFailed(int id);

  @insert
  Future<int> insertCountry(CountryEntity country);

  @update
  Future<int> updateCountry(CountryEntity country);

  @delete
  Future<int> deleteCountry(CountryEntity country);
}