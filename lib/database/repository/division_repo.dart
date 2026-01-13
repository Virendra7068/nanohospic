// // lib/database/repository/division_repo.dart
// import 'dart:convert';
// import 'package:nanohospic/database/dao/division_dao.dart';
// import 'package:nanohospic/database/entity/division_entity.dart';

// class DivisionRepository {
//   final DivisionDao _divisionDao;

//   DivisionRepository(this._divisionDao);

//   // CRUD Operations
//   Future<List<DivisionEntity>> getAllDivisions() async {
//     return await _divisionDao.getAllDivisions();
//   }

//   Future<DivisionEntity?> getDivisionById(int id) async {
//     return await _divisionDao.getDivisionById(id);
//   }

//   Future<DivisionEntity?> getDivisionByServerId(int serverId) async {
//     return await _divisionDao.getDivisionByServerId(serverId);
//   }

//   Future<List<DivisionEntity>> getPendingSync() async {
//     return await _divisionDao.getPendingSync();
//   }

//   Future<int> getTotalCount() async {
//     final count = await _divisionDao.getTotalCount();
//     return count ?? 0;
//   }

//   Future<int> getSyncedCount() async {
//     final count = await _divisionDao.getSyncedCount();
//     return count ?? 0;
//   }

//   Future<int> getPendingCount() async {
//     final count = await _divisionDao.getPendingCount();
//     return count ?? 0;
//   }

//   Future<List<DivisionEntity>> searchDivisions(String query) async {
//     return await _divisionDao.searchDivisions('%$query%');
//   }

//   Future<List<DivisionEntity>> getDivisionsByCompany(int companyId) async {
//     return await _divisionDao.getDivisionsByCompany(companyId);
//   }

//   Future<int> insertDivision(DivisionEntity division) async {
//     await _divisionDao.insertDivision(division);
    
//     // Get the inserted ID by finding the division by name and company
//     final divisions = await _divisionDao.getAllDivisions();
//     final inserted = divisions.firstWhere(
//       (d) => d.name == division.name && d.companyId == division.companyId,
//       orElse: () => division,
//     );
    
//     return inserted.id ?? 0;
//   }

//   Future<void> updateDivision(DivisionEntity division) async {
//     await _divisionDao.updateDivision(division);
//   }

//   // Fix: Handle null by passing empty string or 'system'
//   Future<void> softDeleteDivision(int id, {String? deletedBy}) async {
//     await _divisionDao.softDeleteDivision(id, deletedBy ?? 'system');
//   }

//   Future<void> markAsSynced(int id) async {
//     await _divisionDao.markAsSynced(id);
//   }

//   Future<void> markAsFailed(int id) async {
//     await _divisionDao.markAsFailed(id);
//   }

//   // Sync Operations
//   Future<void> syncFromServer(List<Map<String, dynamic>> divisionsData) async {
//     for (final divisionData in divisionsData) {
//       try {
//         final serverId = divisionData['id'] as int?;
//         if (serverId == null) continue;

//         final existingDivision = await _divisionDao.getDivisionByServerId(serverId);
        
//         final division = DivisionEntity(
//           serverId: serverId,
//           name: divisionData['name']?.toString() ?? '',
//           companyId: divisionData['companyId'] as int?,
//           companyName: divisionData['companyName']?.toString(),
//           createdAt: divisionData['createdAt']?.toString(),
//           createdBy: divisionData['createdBy']?.toString(),
//           lastModified: divisionData['lastModified']?.toString(),
//           lastModifiedBy: divisionData['lastModifiedBy']?.toString(),
//           isDeleted: divisionData['isDeleted'] as bool? ?? false,
//           isSynced: true,
//           syncStatus: 'synced',
//           syncAttempts: 0,
//         );

//         if (existingDivision != null) {
//           division.id = existingDivision.id;
//           await _divisionDao.updateDivision(division);
//         } else {
//           await _divisionDao.insertDivision(division);
//         }
//       } catch (e) {
//         print('Error syncing division: $e');
//       }
//     }
//   }

//   // Convert division to JSON for API
//   Map<String, dynamic> divisionToJson(DivisionEntity division) {
//     return {
//       'id': division.serverId ?? 0,
//       'name': division.name,
//       'companyId': division.companyId,
//       'companyName': division.companyName,
//     };
//   }

//   // Batch operations
//   Future<void> insertMultipleDivisions(List<DivisionEntity> divisions) async {
//     for (final division in divisions) {
//       await _divisionDao.insertDivision(division);
//     }
//   }

//   Future<void> updateMultipleDivisions(List<DivisionEntity> divisions) async {
//     for (final division in divisions) {
//       await _divisionDao.updateDivision(division);
//     }
//   }

//   // Increment sync attempts
//   Future<void> incrementSyncAttempts(int id) async {
//     final division = await _divisionDao.getDivisionById(id);
//     if (division != null) {
//       division.syncAttempts = (division.syncAttempts ?? 0) + 1;
//       await _divisionDao.updateDivision(division);
//     }
//   }

//   // Record sync error
//   Future<void> recordSyncError(int id, String error) async {
//     final division = await _divisionDao.getDivisionById(id);
//     if (division != null) {
//       division.syncAttempts = (division.syncAttempts ?? 0) + 1;
//       division.lastSyncError = error;
//       division.syncStatus = 'failed';
//       await _divisionDao.updateDivision(division);
//     }
//   }
// }


// lib/database/repository/division_repo.dart
import 'dart:convert';
import 'package:nanohospic/database/dao/division_dao.dart';
import 'package:nanohospic/database/entity/division_entity.dart';

class DivisionRepository {
  final DivisionDao _divisionDao;

  DivisionRepository(this._divisionDao);

  // CRUD Operations
  Future<List<DivisionEntity>> getAllDivisions() async {
    return await _divisionDao.getAllDivisions();
  }

  Future<DivisionEntity?> getDivisionById(int id) async {
    return await _divisionDao.getDivisionById(id);
  }

  Future<DivisionEntity?> getDivisionByServerId(int serverId) async {
    return await _divisionDao.getDivisionByServerId(serverId);
  }

  Future<List<DivisionEntity>> getPendingSync() async {
    return await _divisionDao.getPendingSync();
  }

  Future<int> getTotalCount() async {
    final count = await _divisionDao.getTotalCount();
    return count ?? 0;
  }

  Future<int> getSyncedCount() async {
    final count = await _divisionDao.getSyncedCount();
    return count ?? 0;
  }

  Future<int> getPendingCount() async {
    final count = await _divisionDao.getPendingCount();
    return count ?? 0;
  }

  Future<List<DivisionEntity>> searchDivisions(String query) async {
    return await _divisionDao.searchDivisions('%$query%');
  }

  Future<List<DivisionEntity>> getDivisionsByCompany(int companyId) async {
    return await _divisionDao.getDivisionsByCompany(companyId);
  }

  Future<int> insertDivision(DivisionEntity division) async {
    await _divisionDao.insertDivision(division);
    
    // Get the inserted ID
    final divisions = await _divisionDao.getAllDivisions();
    final inserted = divisions.firstWhere(
      (d) => d.name == division.name && d.companyId == division.companyId,
      orElse: () => division,
    );
    
    return inserted.id ?? 0;
  }

  Future<void> updateDivision(DivisionEntity division) async {
    await _divisionDao.updateDivision(division);
  }

  Future<void> softDeleteDivision(int id, {String? deletedBy}) async {
    await _divisionDao.softDeleteDivision(id, deletedBy ?? 'system');
  }

  Future<void> markAsSynced(int id) async {
    await _divisionDao.markAsSynced(id);
  }

  Future<void> markAsFailed(int id) async {
    await _divisionDao.markAsFailed(id);
  }

  // Check for duplicate before inserting
  Future<bool> isDuplicateDivision(String name, int? companyId) async {
    final divisions = await _divisionDao.getAllDivisions();
    return divisions.any((division) => 
      division.name.toLowerCase() == name.toLowerCase() && 
      division.companyId == companyId &&
      !division.isDeleted
    );
  }

  // Sync Operations - Prevent duplicates
  Future<void> syncFromServer(List<Map<String, dynamic>> divisionsData) async {
    for (final divisionData in divisionsData) {
      try {
        final serverId = divisionData['id'] as int?;
        if (serverId == null) continue;

        // Check if already exists by serverId
        final existingDivision = await _divisionDao.getDivisionByServerId(serverId);
        
        final division = DivisionEntity(
          serverId: serverId,
          name: divisionData['name']?.toString() ?? '',
          companyId: divisionData['companyId'] as int?,
          companyName: divisionData['companyName']?.toString(),
          createdAt: divisionData['createdAt']?.toString(),
          createdBy: divisionData['createdBy']?.toString(),
          lastModified: divisionData['lastModified']?.toString(),
          lastModifiedBy: divisionData['lastModifiedBy']?.toString(),
          isDeleted: divisionData['isDeleted'] as bool? ?? false,
          isSynced: true,
          syncStatus: 'synced',
          syncAttempts: 0,
        );

        if (existingDivision != null) {
          // Update existing record
          division.id = existingDivision.id;
          await _divisionDao.updateDivision(division);
        } else {
          // Check for local duplicate before inserting
          final localDuplicates = await _divisionDao.getAllDivisions();
          final localDuplicate = localDuplicates.firstWhere(
            (d) => d.name.toLowerCase() == division.name.toLowerCase() && 
                   d.companyId == division.companyId &&
                   d.serverId == null, 
            orElse: () => DivisionEntity(name: '', companyId: null),
          );
          
          if (localDuplicate.id != null) {
            division.id = localDuplicate.id;
            await _divisionDao.updateDivision(division);
          } else {
            await _divisionDao.insertDivision(division);
          }
        }
      } catch (e) {
        print('Error syncing division: $e');
      }
    }
  }

  // Add a new division with duplicate check
  Future<DivisionEntity> addDivisionWithSync({
    required String name,
    required int? companyId,
    String? companyName,
  }) async {
    final isDuplicate = await isDuplicateDivision(name, companyId);
    if (isDuplicate) {
      throw Exception('Division "$name" already exists for this company');
    }

    final division = DivisionEntity(
      name: name,
      companyId: companyId,
      companyName: companyName,
      createdAt: DateTime.now().toIso8601String(),
      isSynced: false,
      syncStatus: 'pending',
    );
    await _divisionDao.insertDivision(division);
    final divisions = await _divisionDao.getAllDivisions();
    return divisions.firstWhere(
      (d) => d.name == name && d.companyId == companyId && !d.isDeleted,
    );
  }

  // Sync pending changes with proper state management
  Future<Map<String, dynamic>> syncPendingChanges() async {
    try {
      final pendingDivisions = await _divisionDao.getPendingSync();
      int successCount = 0;
      int failCount = 0;
      List<String> errors = [];
      
      for (final division in pendingDivisions) {
        try {
          if (division.isDeleted) {
            // Handle delete
            if (division.serverId != null) {
              // We'll handle this in the screen
              await markAsSynced(division.id!);
              successCount++;
            } else {
              // Local-only delete
              await markAsSynced(division.id!);
              successCount++;
            }
          } else if (division.serverId == null) {
            // Handle insert
            await markAsSynced(division.id!);
            successCount++;
          } else {
            // Handle update
            await markAsSynced(division.id!);
            successCount++;
          }
        } catch (e) {
          print('Failed to sync division ${division.id}: $e');
          await markAsFailed(division.id!);
          failCount++;
          errors.add('Division ${division.name}: $e');
        }
      }
      
      return {
        'success': successCount,
        'failed': failCount,
        'errors': errors,
        'total': pendingDivisions.length,
      };
    } catch (e) {
      print('Error syncing pending changes: $e');
      return {
        'success': 0,
        'failed': 0,
        'errors': [e.toString()],
        'total': 0,
      };
    }
  }

  // Get sync statistics
  Future<Map<String, int>> getSyncStats() async {
    final total = await getTotalCount();
    final synced = await getSyncedCount();
    final pending = await getPendingCount();
    
    return {
      'total': total,
      'synced': synced,
      'pending': pending,
    };
  }

  // Clean up duplicate pending records
  Future<void> cleanupDuplicates() async {
    try {
      final divisions = await _divisionDao.getAllDivisions();
      final Map<String, List<DivisionEntity>> duplicates = {};
      
      // Group by name and companyId
      for (final division in divisions) {
        if (division.isDeleted) continue;
        
        final key = '${division.name.toLowerCase()}_${division.companyId}';
        if (!duplicates.containsKey(key)) {
          duplicates[key] = [];
        }
        duplicates[key]!.add(division);
      }
      
      // Process duplicates
      for (final entry in duplicates.entries) {
        final duplicateList = entry.value;
        if (duplicateList.length > 1) {
          print('Found ${duplicateList.length} duplicates for ${entry.key}');
          
          // Keep the first record, mark others as deleted
          final firstRecord = duplicateList.first;
          for (int i = 1; i < duplicateList.length; i++) {
            final duplicate = duplicateList[i];
            await _divisionDao.softDeleteDivision(
              duplicate.id!, 
             'system_cleanup'
            );
            print('Marked duplicate ${duplicate.id} as deleted $firstRecord');
          }
        }
      }
    } catch (e) {
      print('Error cleaning up duplicates: $e');
    }
  }
}