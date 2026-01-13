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
    return await _countryDao.insertCountry(country);
  }

  Future<int> updateCountry(CountryEntity country) async {
    // Update sync status when modifying
    country.lastModified = DateTime.now().toIso8601String();
    country.isSynced = false;
    country.syncStatus = 'pending';

    return await _countryDao.updateCountry(country);
  }

  // FIXED: Method to update country without resetting sync status (for sync operations)
  Future<int> updateSyncedCountry(CountryEntity country) async {
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
    // Deduplicate server data by name, keeping the first occurrence
    final uniqueServerData = <String, Map<String, dynamic>>{};

    for (final dynamic item in serverData) {
      if (item == null) continue;

      Map<String, dynamic>? countryData;
      if (item is Map<String, dynamic>) {
        countryData = item;
      } else if (item is Map) {
        countryData = Map<String, dynamic>.from(item);
      }

      if (countryData != null) {
        final name = countryData['name']?.toString().trim();
        if (name != null && name.isNotEmpty) {
          // Normalizing key to lowercase for deduplication
          final key = name.toLowerCase();
          if (!uniqueServerData.containsKey(key)) {
            uniqueServerData[key] = countryData;
          }
        }
      }
    }

    // Process unique records
    for (final countryData in uniqueServerData.values) {
      try {
        final serverId = _parseInt(countryData['id']);
        if (serverId == 0) continue; // Skip invalid IDs

        final existing = await getCountryByServerId(serverId);

        // If not found by server ID, check by name to avoid duplicates
        // This handles cases where user added locally (pending) and server also has it
        CountryEntity? existingByName;
        if (existing == null) {
          final name = countryData['name']?.toString() ?? '';
          if (name.isNotEmpty) {
            existingByName = await findCountryByName(name);
          }
        }

        if (existing == null && existingByName == null) {
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
          // Use either the one found by ID or by Name
          final target = existing ?? existingByName!;

          final updatedCountry = CountryEntity(
            id: target.id,
            serverId: serverId, // Ensure serverId is set
            name: countryData['name']?.toString() ?? target.name,
            createdAt: target.createdAt,
            createdBy: target.createdBy,
            // Use server's last modified, or fall back to current if missing
            lastModified:
                countryData['lastModified']?.toString() ?? target.lastModified,
            lastModifiedBy:
                countryData['lastModifiedBy']?.toString() ??
                target.lastModifiedBy,
            isDeleted: target.isDeleted,
            deletedBy: target.deletedBy,
            isSynced:
                true, // ERROR WAS HERE: Previously called updateCountry which set this to false
            syncStatus: 'synced',
          );

          // CRITICAL FIX: Direct DAO call to avoid 'updateCountry' wrapper which resets sync status
          await _countryDao.updateCountry(updatedCountry);
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
  // FIXED METHOD: findCountryByName with proper type handling and normalization
  Future<CountryEntity?> findCountryByName(String name) async {
    final searchName = name.trim().toLowerCase();
    final countries = await getAllCountries();
    for (final country in countries) {
      if (country.name.trim().toLowerCase() == searchName) {
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
