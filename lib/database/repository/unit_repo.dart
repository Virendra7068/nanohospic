// lib/database/repository/unit_repo.dart
import 'dart:async';
import 'package:nanohospic/database/dao/unit_dao.dart';
import 'package:nanohospic/database/entity/unit_entity.dart';

class UnitRepository {
  final UnitDao _unitDao;

  UnitRepository(this._unitDao);

  // Local database operations
  Future<List<UnitEntity>> getAllUnits() async {
    return await _unitDao.getAllUnits();
  }

  Future<UnitEntity?> getUnitById(int id) async {
    return await _unitDao.getUnitById(id);
  }

  Future<UnitEntity?> getUnitByServerId(int serverId) async {
    return await _unitDao.getUnitByServerId(serverId);
  }

  Future<List<UnitEntity>> searchUnits(String query) async {
    return await _unitDao.searchUnits('%$query%');
  }

  Future<int> insertUnit(UnitEntity unit) async {
    // Set sync status to pending for new entries
    unit.isSynced = false;
    unit.syncStatus = 'pending';
    unit.createdAt = DateTime.now().toIso8601String();
    
    return await _unitDao.insertUnit(unit);
  }

  Future<int> updateUnit(UnitEntity unit) async {
    // Update sync status when modifying
    unit.lastModified = DateTime.now().toIso8601String();
    unit.isSynced = false;
    unit.syncStatus = 'pending';
    
    return await _unitDao.updateUnit(unit);
  }

  Future<int> deleteUnit(int id) async {
    // Mark as deleted instead of actual deletion
    final result = await _unitDao.markAsDeleted(id);
    return result ?? 0; // Handle null return
  }

  Future<int> hardDeleteUnit(int id) async {
    // First get the entity, then delete it
    final unit = await getUnitById(id);
    if (unit != null) {
      return await _unitDao.deleteUnit(unit);
    }
    return 0;
  }

  // Sync related methods
  Future<List<UnitEntity>> getPendingSync() async {
    return await _unitDao.getPendingSyncUnits();
  }

  Future<int> markAsSynced(int id) async {
    final result = await _unitDao.markAsSynced(id);
    return result ?? 0; // Handle null return
  }

  Future<int> markAsFailed(int id) async {
    final result = await _unitDao.markAsFailed(id);
    return result ?? 0; // Handle null return
  }

  // Statistics
  Future<int> getTotalCount() async {
    final allUnits = await getAllUnits();
    return allUnits.length;
  }

  Future<int> getSyncedCount() async {
    final count = await _unitDao.getSyncedUnitsCount();
    return count ?? 0; // Handle null return
  }

  Future<int> getPendingCount() async {
    final count = await _unitDao.getPendingUnitsCount();
    return count ?? 0; // Handle null return
  }

  // Bulk operations
  Future<void> insertAllUnits(List<UnitEntity> units) async {
    for (final unit in units) {
      await insertUnit(unit);
    }
  }

  // FIXED METHOD: Sync from server with proper entity handling
  Future<void> syncFromServer(List<dynamic> serverData) async {
    for (final dynamic item in serverData) {
      try {
        // Convert dynamic to Map<String, dynamic>
        Map<String, dynamic> unitData;
        
        if (item is Map<String, dynamic>) {
          unitData = item;
        } else if (item is Map) {
          unitData = Map<String, dynamic>.from(item);
        } else {
          continue; // Skip invalid data
        }
        
        final serverId = _parseInt(unitData['id']);
        if (serverId == 0) continue; // Skip invalid IDs
        
        final existing = await getUnitByServerId(serverId);
        
        if (existing == null) {
          // Insert new unit from server
          final unit = UnitEntity(
            serverId: serverId,
            name: unitData['name']?.toString() ?? '',
            createdAt: unitData['created']?.toString(),
            createdBy: unitData['createdBy']?.toString(),
            lastModified: unitData['lastModified']?.toString(),
            lastModifiedBy: unitData['lastModifiedBy']?.toString(),
            isSynced: true,
            syncStatus: 'synced',
          );
          await insertUnit(unit);
        } else {
          // Update existing unit with server data
          final updatedUnit = UnitEntity(
            id: existing.id,
            serverId: existing.serverId,
            name: unitData['name']?.toString() ?? existing.name,
            createdAt: existing.createdAt,
            createdBy: existing.createdBy,
            lastModified: unitData['lastModified']?.toString() ?? existing.lastModified,
            lastModifiedBy: unitData['lastModifiedBy']?.toString() ?? existing.lastModifiedBy,
            isDeleted: existing.isDeleted,
            deletedBy: existing.deletedBy,
            isSynced: true,
            syncStatus: 'synced',
          );
          await updateUnit(updatedUnit);
        }
      } catch (e) {
        print('Error syncing unit: $e');
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

  // FIXED METHOD: findUnitByName with proper type handling
  Future<UnitEntity?> findUnitByName(String name) async {
    final units = await getAllUnits();
    for (final unit in units) {
      if (unit.name.toLowerCase() == name.toLowerCase()) {
        return unit;
      }
    }
    return null;
  }

  Future<List<UnitEntity>> getActiveUnits() async {
    final units = await getAllUnits();
    return units.where((u) => !u.isDeleted).toList();
  }

  Future<void> clearAllUnits() async {
    final units = await getAllUnits();
    for (final unit in units) {
      await hardDeleteUnit(unit.id!);
    }
  }

  // Additional helper methods
  Future<bool> unitExists(String name) async {
    final unit = await findUnitByName(name);
    return unit != null;
  }

  Future<void> restoreUnit(int id) async {
    final unit = await getUnitById(id);
    if (unit != null && unit.isDeleted) {
      final restoredUnit = UnitEntity(
        id: unit.id,
        serverId: unit.serverId,
        name: unit.name,
        createdAt: unit.createdAt,
        createdBy: unit.createdBy,
        lastModified: DateTime.now().toIso8601String(),
        lastModifiedBy: 'system',
        isDeleted: false,
        deletedBy: null,
        isSynced: false,
        syncStatus: 'pending',
      );
      await updateUnit(restoredUnit);
    }
  }
}