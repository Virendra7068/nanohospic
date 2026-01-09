// lib/database/repository/country_repo.dart
import 'dart:async';
import 'package:nanohospic/database/dao/country_dao_screen.dart';
import 'package:nanohospic/database/entity/country_entity.dart';

class CountryRepository {
  final CountryDao _countryDao;

  CountryRepository(this._countryDao);

  // Local database operations
  Future<List<CountryEntity>> getAllCountries() async {
    return await _countryDao.getAllCountries();
  }

  Future<CountryEntity?> getCountryById(int id) async {
    return await _countryDao.getCountryById(id);
  }

  Future<CountryEntity?> getCountryByServerId(int serverId) async {
    return await _countryDao.getCountryByServerId(serverId);
  }

  Future<List<CountryEntity>> searchCountries(String query) async {
    return await _countryDao.searchCountries('%$query%');
  }

  Future<int> insertCountry(CountryEntity country) async {
    // Set sync status to pending for new entries
    country.isSynced = false;
    country.syncStatus = 'pending';
    country.createdAt = DateTime.now().toIso8601String();
    
    return await _countryDao.insertCountry(country);
  }

  Future<int> updateCountry(CountryEntity country) async {
    // Update sync status when modifying
    country.lastModified = DateTime.now().toIso8601String();
    country.isSynced = false;
    country.syncStatus = 'pending';
    
    return await _countryDao.updateCountry(country);
  }

  Future<int> deleteCountry(int id) async {
    // Mark as deleted instead of actual deletion
    final result = await _countryDao.markAsDeleted(id);
    return result ?? 0; // Handle null return
  }

  Future<int> hardDeleteCountry(int id) async {
    // First get the entity, then delete it
    final country = await getCountryById(id);
    if (country != null) {
      return await _countryDao.deleteCountry(country);
    }
    return 0;
  }

  // Sync related methods
  Future<List<CountryEntity>> getPendingSync() async {
    return await _countryDao.getPendingSyncCountries();
  }

  Future<int> markAsSynced(int id) async {
    final result = await _countryDao.markAsSynced(id);
    return result ?? 0; // Handle null return
  }

  Future<int> markAsFailed(int id) async {
    final result = await _countryDao.markAsFailed(id);
    return result ?? 0; // Handle null return
  }

  // Statistics
  Future<int> getTotalCount() async {
    final allCountries = await getAllCountries();
    return allCountries.length;
  }

  Future<int> getSyncedCount() async {
    final count = await _countryDao.getSyncedCountriesCount();
    return count ?? 0; // Handle null return
  }

  Future<int> getPendingCount() async {
    final count = await _countryDao.getPendingCountriesCount();
    return count ?? 0; // Handle null return
  }

  // Bulk operations
  Future<void> insertAllCountries(List<CountryEntity> countries) async {
    for (final country in countries) {
      await insertCountry(country);
    }
  }

  // FIXED METHOD: Sync from server with proper entity handling
  Future<void> syncFromServer(List<dynamic> serverData) async {
    for (final dynamic item in serverData) {
      try {
        // Convert dynamic to Map<String, dynamic>
        Map<String, dynamic> countryData;
        
        if (item is Map<String, dynamic>) {
          countryData = item;
        } else if (item is Map) {
          countryData = Map<String, dynamic>.from(item);
        } else {
          continue; // Skip invalid data
        }
        
        final serverId = _parseInt(countryData['id']);
        if (serverId == 0) continue; // Skip invalid IDs
        
        final existing = await getCountryByServerId(serverId);
        
        if (existing == null) {
          // Insert new country from server
          final country = CountryEntity(
            serverId: serverId,
            name: countryData['name']?.toString() ?? '',
            createdAt: countryData['created']?.toString(),
            createdBy: countryData['createdBy']?.toString(),
            lastModified: countryData['lastModified']?.toString(),
            lastModifiedBy: countryData['lastModifiedBy']?.toString(),
            isSynced: true,
            syncStatus: 'synced',
          );
          await insertCountry(country);
        } else {
          // Update existing country with server data
          final updatedCountry = CountryEntity(
            id: existing.id,
            serverId: existing.serverId,
            name: countryData['name']?.toString() ?? existing.name,
            createdAt: existing.createdAt,
            createdBy: existing.createdBy,
            lastModified: countryData['lastModified']?.toString() ?? existing.lastModified,
            lastModifiedBy: countryData['lastModifiedBy']?.toString() ?? existing.lastModifiedBy,
            isDeleted: existing.isDeleted,
            deletedBy: existing.deletedBy,
            isSynced: true,
            syncStatus: 'synced',
          );
          await updateCountry(updatedCountry);
        }
      } catch (e) {
        print('Error syncing country: $e');
        continue;
      }
    }
  }

  // Helper method to parse integers safely
  int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  // FIXED METHOD: findCountryByName with proper type handling
  Future<CountryEntity?> findCountryByName(String name) async {
    final countries = await getAllCountries();
    for (final country in countries) {
      if (country.name.toLowerCase() == name.toLowerCase()) {
        return country;
      }
    }
    return null;
  }

  Future<List<CountryEntity>> getActiveCountries() async {
    final countries = await getAllCountries();
    return countries.where((c) => !c.isDeleted).toList();
  }

  Future<void> clearAllCountries() async {
    final countries = await getAllCountries();
    for (final country in countries) {
      await hardDeleteCountry(country.id!);
    }
  }

  // Additional helper methods
  Future<bool> countryExists(String name) async {
    final country = await findCountryByName(name);
    return country != null;
  }

  Future<void> restoreCountry(int id) async {
    final country = await getCountryById(id);
    if (country != null && country.isDeleted) {
      final restoredCountry = CountryEntity(
        id: country.id,
        serverId: country.serverId,
        name: country.name,
        createdAt: country.createdAt,
        createdBy: country.createdBy,
        lastModified: DateTime.now().toIso8601String(),
        lastModifiedBy: 'system',
        isDeleted: false,
        deletedBy: null,
        isSynced: false,
        syncStatus: 'pending',
      );
      await updateCountry(restoredCountry);
    }
  }
}