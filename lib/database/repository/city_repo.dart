// import 'dart:async';
// import 'package:nanohospic/database/dao/city_dao.dart';
// import 'package:nanohospic/database/entity/city_entity.dart';

// class CityRepository {
//   final CityDao _cityDao;

//   CityRepository(this._cityDao);

//   // Local database operations
//   Future<List<CityEntity>> getCitiesByState(int stateId) async {
//     return await _cityDao.getCitiesByState(stateId);
//   }

//   Future<CityEntity?> getCityById(int id) async {
//     return await _cityDao.getCityById(id);
//   }

//   Future<CityEntity?> getCityByServerId(int serverId) async {
//     return await _cityDao.getCityByServerId(serverId);
//   }

//   Future<List<CityEntity>> searchCities(String query, int stateId) async {
//     return await _cityDao.searchCities('%$query%', stateId);
//   }

//   Future<int> insertCity(CityEntity city) async {
//     // Set sync status to pending for new entries
//     city.isSynced = false;
//     city.syncStatus = 'pending';
//     city.createdAt = DateTime.now().toIso8601String();
    
//     return await _cityDao.insertCity(city);
//   }

//   Future<int> updateCity(CityEntity city) async {
//     // Update sync status when modifying
//     city.lastModified = DateTime.now().toIso8601String();
//     city.isSynced = false;
//     city.syncStatus = 'pending';
    
//     return await _cityDao.updateCity(city);
//   }

//   Future<int> deleteCity(int id) async {
//     // Mark as deleted instead of actual deletion
//     final result = await _cityDao.markAsDeleted(id);
//     return result ?? 0; // Handle nullable return
//   }

//   Future<int> hardDeleteCity(int id) async {
//     // First get the entity, then delete it
//     final city = await getCityById(id);
//     if (city != null) {
//       return await _cityDao.deleteCity(city);
//     }
//     return 0;
//   }

//   // Sync related methods - FIXED to handle nullable returns
//   Future<List<CityEntity>> getPendingSync() async {
//     return await _cityDao.getPendingSyncCities();
//   }

//   Future<int> markAsSynced(int id) async {
//     final result = await _cityDao.markAsSynced(id);
//     return result ?? 0; // Handle nullable return
//   }

//   Future<int> markAsFailed(int id) async {
//     final result = await _cityDao.markAsFailed(id);
//     return result ?? 0; // Handle nullable return
//   }

//   // Statistics - Handle nullable returns
//   Future<int> getCitiesCountByState(int stateId) async {
//     final count = await _cityDao.getCitiesCountByState(stateId);
//     return count ?? 0;
//   }

//   Future<int> getSyncedCount() async {
//     final count = await _cityDao.getSyncedCitiesCount();
//     return count ?? 0;
//   }

//   Future<int> getPendingCount() async {
//     final count = await _cityDao.getPendingCitiesCount();
//     return count ?? 0;
//   }

//   // Bulk operations
//   Future<void> insertAllCities(List<CityEntity> cities) async {
//     for (final city in cities) {
//       await insertCity(city);
//     }
//   }

//   // FIXED: Sync from server with proper entity creation
//   Future<void> syncFromServer(List<dynamic> serverData, int stateId, int id) async {
//     for (final dynamic item in serverData) {
//       try {
//         // Convert dynamic to Map<String, dynamic>
//         Map<String, dynamic> cityData;
        
//         if (item is Map<String, dynamic>) {
//           cityData = item;
//         } else if (item is Map) {
//           cityData = Map<String, dynamic>.from(item);
//         } else {
//           continue; // Skip invalid data
//         }
        
//         final serverId = _parseInt(cityData['id']);
//         final stateIdFromData = _parseInt(cityData['stateId']);
        
//         // Only sync cities for current state
//         if (stateIdFromData != stateId) continue;
        
//         final existing = await getCityByServerId(serverId);
        
//         if (existing == null) {
//           // Insert new city from server
//           final city = CityEntity(
//             serverId: serverId,
//             name: cityData['name']?.toString() ?? '',
//             countryId: _parseInt(cityData['countryId']),
//             stateId: stateIdFromData,
//             countryName: cityData['country']?['name']?.toString(),
//             stateName: cityData['state']?['name']?.toString(),
//             createdAt: cityData['created']?.toString(),
//             createdBy: cityData['createdBy']?.toString(),
//             lastModified: cityData['lastModified']?.toString(),
//             lastModifiedBy: cityData['lastModifiedBy']?.toString(),
//             isSynced: true,
//             syncStatus: 'synced',
//           );
//           await insertCity(city);
//         } else {
//           // Update existing city with server data
//           final updatedCity = CityEntity(
//             id: existing.id,
//             serverId: existing.serverId,
//             name: cityData['name']?.toString() ?? existing.name,
//             countryId: existing.countryId,
//             stateId: existing.stateId,
//             countryName: cityData['country']?['name']?.toString() ?? existing.countryName,
//             stateName: cityData['state']?['name']?.toString() ?? existing.stateName,
//             createdAt: existing.createdAt,
//             createdBy: existing.createdBy,
//             lastModified: cityData['lastModified']?.toString() ?? existing.lastModified,
//             lastModifiedBy: cityData['lastModifiedBy']?.toString() ?? existing.lastModifiedBy,
//             isDeleted: existing.isDeleted,
//             deletedBy: existing.deletedBy,
//             isSynced: true,
//             syncStatus: 'synced',
//           );
//           await updateCity(updatedCity);
//         }
//       } catch (e) {
//         print('Error syncing city: $e');
//         continue;
//       }
//     }
//   }

//   // Helper method to parse integers safely
//   int _parseInt(dynamic value) {
//     if (value == null) return 0;
//     if (value is int) return value;
//     if (value is String) return int.tryParse(value) ?? 0;
//     return 0;
//   }

//   // Additional helper methods
//   Future<List<CityEntity>> getActiveCitiesByState(int stateId) async {
//     final cities = await getCitiesByState(stateId);
//     return cities.where((city) => !city.isDeleted).toList();
//   }

//   Future<CityEntity?> findCityByName(String name, int stateId) async {
//     final cities = await getCitiesByState(stateId);
//     for (final city in cities) {
//       if (city.name.toLowerCase() == name.toLowerCase()) {
//         return city;
//       }
//     }
//     return null;
//   }

//   Future<bool> cityExists(String name, int stateId) async {
//     final city = await findCityByName(name, stateId);
//     return city != null;
//   }

//   Future<void> restoreCity(int id) async {
//     final city = await getCityById(id);
//     if (city != null && city.isDeleted) {
//       final restoredCity = CityEntity(
//         id: city.id,
//         serverId: city.serverId,
//         name: city.name,
//         countryId: city.countryId,
//         stateId: city.stateId,
//         countryName: city.countryName,
//         stateName: city.stateName,
//         createdAt: city.createdAt,
//         createdBy: city.createdBy,
//         lastModified: DateTime.now().toIso8601String(),
//         lastModifiedBy: 'system',
//         isDeleted: false,
//         deletedBy: null,
//         isSynced: false,
//         syncStatus: 'pending',
//       );
//       await updateCity(restoredCity);
//     }
//   }

//   Future<void> clearAllCitiesByState(int stateId) async {
//     final cities = await getCitiesByState(stateId);
//     for (final city in cities) {
//       await hardDeleteCity(city.id!);
//     }
//   }
// }


// ignore_for_file: avoid_print

import 'dart:async';
import 'package:nanohospic/database/dao/city_dao.dart';
import 'package:nanohospic/database/entity/city_entity.dart';

class CityRepository {
  final CityDao _cityDao;

  CityRepository(this._cityDao);

  // Local database operations
  Future<List<CityEntity>> getCitiesByState(int stateId) async {
    return await _cityDao.getCitiesByState(stateId);
  }

  // ✅ NEW: Get cities by stateId and countryId
  Future<List<CityEntity>> getCitiesByStateAndCountry(int stateId, int countryId) async {
    return await _cityDao.getCitiesByStateAndCountry(stateId, countryId);
  }

  Future<CityEntity?> getCityById(int id) async {
    return await _cityDao.getCityById(id);
  }

  Future<CityEntity?> getCityByServerId(int serverId) async {
    return await _cityDao.getCityByServerId(serverId);
  }

  Future<List<CityEntity>> searchCities(String query, int stateId) async {
    return await _cityDao.searchCities('%$query%', stateId);
  }

  Future<int> insertCity(CityEntity city) async {
    // Set sync status to pending for new entries
    city.isSynced = false;
    city.syncStatus = 'pending';
    city.createdAt = DateTime.now().toIso8601String();
    
    return await _cityDao.insertCity(city);
  }

  Future<int> updateCity(CityEntity city) async {
    // Update sync status when modifying
    city.lastModified = DateTime.now().toIso8601String();
    city.isSynced = false;
    city.syncStatus = 'pending';
    
    return await _cityDao.updateCity(city);
  }

  Future<int> deleteCity(int id) async {
    // Mark as deleted instead of actual deletion
    final city = await getCityById(id);
    if (city != null) {
      final updatedCity = CityEntity(
        id: city.id,
        serverId: city.serverId,
        name: city.name,
        countryId: city.countryId,
        stateId: city.stateId,
        countryName: city.countryName,
        stateName: city.stateName,
        createdAt: city.createdAt,
        createdBy: city.createdBy,
        lastModified: DateTime.now().toIso8601String(),
        lastModifiedBy: 'system',
        isDeleted: true,
        deletedBy: 'system',
        isSynced: false,
        syncStatus: 'pending',
      );
      return await _cityDao.updateCity(updatedCity);
    }
    return 0;
  }

  Future<int> hardDeleteCity(int id) async {
    // First get the entity, then delete it
    final city = await getCityById(id);
    if (city != null) {
      return await _cityDao.deleteCity(city);
    }
    return 0;
  }

  // Sync related methods
  Future<List<CityEntity>> getPendingSync() async {
    return await _cityDao.getPendingSyncCities();
  }

  Future<int> markAsSynced(int id) async {
    final city = await getCityById(id);
    if (city != null) {
      final updatedCity = CityEntity(
        id: city.id,
        serverId: city.serverId,
        name: city.name,
        countryId: city.countryId,
        stateId: city.stateId,
        countryName: city.countryName,
        stateName: city.stateName,
        createdAt: city.createdAt,
        createdBy: city.createdBy,
        lastModified: DateTime.now().toIso8601String(),
        lastModifiedBy: 'system',
        isDeleted: city.isDeleted,
        deletedBy: city.deletedBy,
        isSynced: true,
        syncStatus: 'synced',
      );
      return await _cityDao.updateCity(updatedCity);
    }
    return 0;
  }

  Future<int> markAsFailed(int id) async {
    final city = await getCityById(id);
    if (city != null) {
      final updatedCity = CityEntity(
        id: city.id,
        serverId: city.serverId,
        name: city.name,
        countryId: city.countryId,
        stateId: city.stateId,
        countryName: city.countryName,
        stateName: city.stateName,
        createdAt: city.createdAt,
        createdBy: city.createdBy,
        lastModified: DateTime.now().toIso8601String(),
        lastModifiedBy: 'system',
        isDeleted: city.isDeleted,
        deletedBy: city.deletedBy,
        isSynced: false,
        syncStatus: 'failed',
      );
      return await _cityDao.updateCity(updatedCity);
    }
    return 0;
  }

  // Statistics
  Future<int> getCitiesCountByState(int stateId) async {
    return await _cityDao.getCitiesCountByState(stateId) ?? 0;
  }

  // ✅ NEW: Get count by stateId and countryId
  Future<int> getCitiesCountByStateAndCountry(int stateId, int countryId) async {
    return await _cityDao.getCitiesCountByStateAndCountry(stateId, countryId) ?? 0;
  }

  Future<int> getSyncedCount() async {
    return await _cityDao.getSyncedCitiesCount() ?? 0;
  }

  // ✅ NEW: Get synced count by stateId and countryId
  Future<int> getSyncedCountByStateAndCountry(int stateId, int countryId) async {
    return await _cityDao.getSyncedCountByStateAndCountry(stateId, countryId) ?? 0;
  }

  Future<int> getPendingCount() async {
    return await _cityDao.getPendingCitiesCount() ?? 0;
  }

  // ✅ NEW: Get pending count by stateId and countryId
  Future<int> getPendingCountByStateAndCountry(int stateId, int countryId) async {
    return await _cityDao.getPendingCountByStateAndCountry(stateId, countryId) ?? 0;
  }

  // Bulk operations
  Future<void> insertAllCities(List<CityEntity> cities) async {
    for (final city in cities) {
      await insertCity(city);
    }
  }

  // ✅ FIXED: Sync from server with proper entity creation and country handling
  Future<void> syncFromServer(List<Map<String, dynamic>> serverData, int stateId, int countryId) async {
    for (final cityData in serverData) {
      try {
        final serverId = _parseInt(cityData['id']);
        final stateIdFromData = _parseInt(cityData['stateId']);
        final countryIdFromData = _parseInt(cityData['countryId']);
        
        // Only sync cities for current state and country
        if (stateIdFromData != stateId || countryIdFromData != countryId) {
          continue;
        }
        
        final existing = await getCityByServerId(serverId);
        
        if (existing == null) {
          // Insert new city from server
          final city = CityEntity(
            serverId: serverId,
            name: cityData['name']?.toString() ?? '',
            countryId: countryIdFromData,
            stateId: stateIdFromData,
            countryName: cityData['countryName']?.toString() ?? cityData['country']?['name']?.toString(),
            stateName: cityData['stateName']?.toString() ?? cityData['state']?['name']?.toString(),
            createdAt: cityData['createdAt']?.toString() ?? cityData['created']?.toString() ?? DateTime.now().toIso8601String(),
            createdBy: cityData['createdBy']?.toString(),
            lastModified: cityData['lastModified']?.toString() ?? cityData['updatedAt']?.toString(),
            lastModifiedBy: cityData['lastModifiedBy']?.toString(),
            isSynced: true,
            syncStatus: 'synced',
          );
          await insertCity(city);
        } else {
          final updatedCity = CityEntity(
            id: existing.id,
            serverId: existing.serverId,
            name: cityData['name']?.toString() ?? existing.name,
            countryId: existing.countryId,
            stateId: existing.stateId,
            countryName: cityData['countryName']?.toString() ?? cityData['country']?['name']?.toString() ?? existing.countryName,
            stateName: cityData['stateName']?.toString() ?? cityData['state']?['name']?.toString() ?? existing.stateName,
            createdAt: existing.createdAt,
            createdBy: existing.createdBy,
            lastModified: cityData['lastModified']?.toString() ?? cityData['updatedAt']?.toString() ?? existing.lastModified,
            lastModifiedBy: cityData['lastModifiedBy']?.toString() ?? existing.lastModifiedBy,
            isDeleted: existing.isDeleted,
            deletedBy: existing.deletedBy,
            isSynced: true,
            syncStatus: 'synced',
          );
          await updateCity(updatedCity);
        }
      } catch (e) {
        print('Error syncing city: $e');
        continue;
      }
    }
  }

  int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  Future<List<CityEntity>> getActiveCitiesByState(int stateId) async {
    final cities = await getCitiesByState(stateId);
    return cities.where((city) => !city.isDeleted).toList();
  }

  Future<List<CityEntity>> getActiveCitiesByStateAndCountry(int stateId, int countryId) async {
    final cities = await getCitiesByStateAndCountry(stateId, countryId);
    return cities.where((city) => !city.isDeleted).toList();
  }

  Future<CityEntity?> findCityByName(String name, int stateId) async {
    final cities = await getCitiesByState(stateId);
    for (final city in cities) {
      if (city.name.toLowerCase() == name.toLowerCase()) {
        return city;
      }
    }
    return null;
  }

  Future<CityEntity?> findCityByNameAndCountry(String name, int stateId, int countryId) async {
    final cities = await getCitiesByStateAndCountry(stateId, countryId);
    for (final city in cities) {
      if (city.name.toLowerCase() == name.toLowerCase()) {
        return city;
      }
    }
    return null;
  }

  Future<bool> cityExists(String name, int stateId) async {
    final city = await findCityByName(name, stateId);
    return city != null;
  }

  Future<bool> cityExistsWithCountry(String name, int stateId, int countryId) async {
    final city = await findCityByNameAndCountry(name, stateId, countryId);
    return city != null;
  }

  Future<void> restoreCity(int id) async {
    final city = await getCityById(id);
    if (city != null && city.isDeleted) {
      final restoredCity = CityEntity(
        id: city.id,
        serverId: city.serverId,
        name: city.name,
        countryId: city.countryId,
        stateId: city.stateId,
        countryName: city.countryName,
        stateName: city.stateName,
        createdAt: city.createdAt,
        createdBy: city.createdBy,
        lastModified: DateTime.now().toIso8601String(),
        lastModifiedBy: 'system',
        isDeleted: false,
        deletedBy: null,
        isSynced: false,
        syncStatus: 'pending',
      );
      await updateCity(restoredCity);
    }
  }

  Future<void> clearAllCitiesByState(int stateId) async {
    final cities = await getCitiesByState(stateId);
    for (final city in cities) {
      await hardDeleteCity(city.id!);
    }
  }

  Future<void> clearAllCitiesByStateAndCountry(int stateId, int countryId) async {
    final cities = await getCitiesByStateAndCountry(stateId, countryId);
    for (final city in cities) {
      await hardDeleteCity(city.id!);
    }
  }

  Future<List<CityEntity>> getPendingSyncByStateAndCountry(int stateId, int countryId) async {
    final pendingCities = await getPendingSync();
    return pendingCities.where((city) => 
      city.stateId == stateId && city.countryId == countryId
    ).toList();
  }

  Future<List<CityEntity>> getDeletedCitiesByStateAndCountry(int stateId, int countryId) async {
    final cities = await getCitiesByStateAndCountry(stateId, countryId);
    return cities.where((city) => city.isDeleted).toList();
  }
}