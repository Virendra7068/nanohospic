import 'dart:async';
import 'package:nanohospic/database/dao/state_dao.dart';
import 'package:nanohospic/database/entity/state_entity.dart';

class StateRepository {
  final StateDao _stateDao;

  StateRepository(this._stateDao);

  Future<List<StateEntity>> getStatesByCountry(int countryId) async {
    return await _stateDao.getStatesByCountry(countryId);
  }

  Future<StateEntity?> getStateById(int id) async {
    return await _stateDao.getStateById(id);
  }

  Future<StateEntity?> getStateByServerId(int serverId) async {
    return await _stateDao.getStateByServerId(serverId);
  }

  Future<List<StateEntity>> searchStates(String query, int countryId) async {
    return await _stateDao.searchStates('%$query%', countryId);
  }

  Future<int> insertState(StateEntity state) async {
    state.isSynced = false;
    state.syncStatus = 'pending';
    state.createdAt = DateTime.now().toIso8601String();
    
    return await _stateDao.insertState(state);
  }

  Future<int> updateState(StateEntity state) async {
    state.lastModified = DateTime.now().toIso8601String();
    state.isSynced = false;
    state.syncStatus = 'pending';
    
    return await _stateDao.updateState(state);
  }

  Future<int> deleteState(int id) async {
    final result = await _stateDao.markAsDeleted(id);
    return result ?? 0; // Handle nullable return
  }

  Future<int> hardDeleteState(int id) async {
    // First get the entity, then delete it
    final state = await getStateById(id);
    if (state != null) {
      return await _stateDao.deleteState(state);
    }
    return 0;
  }

  Future<List<StateEntity>> getPendingSync() async {
    return await _stateDao.getPendingSyncStates();
  }

  Future<int> markAsSynced(int id) async {
    final result = await _stateDao.markAsSynced(id);
    return result ?? 0; // Handle nullable return
  }

  Future<int> markAsFailed(int id) async {
    final result = await _stateDao.markAsFailed(id);
    return result ?? 0; // Handle nullable return
  }

  Future<int> getStatesCountByCountry(int countryId) async {
    final count = await _stateDao.getStatesCountByCountry(countryId);
    return count ?? 0; // Handle nullable return
  }

  Future<int> getSyncedCount() async {
    final count = await _stateDao.getSyncedStatesCount();
    return count ?? 0; // Handle nullable return
  }

  Future<int> getPendingCount() async {
    final count = await _stateDao.getPendingStatesCount();
    return count ?? 0; // Handle nullable return
  }

  // Bulk operations
  Future<void> insertAllStates(List<StateEntity> states) async {
    for (final state in states) {
      await insertState(state);
    }
  }

  // Sync from server with improved error handling
  Future<void> syncFromServer(List<dynamic> serverData, int countryId) async {
    for (final dynamic item in serverData) {
      try {
        // Convert dynamic to Map<String, dynamic>
        Map<String, dynamic> stateData;
        
        if (item is Map<String, dynamic>) {
          stateData = item;
        } else if (item is Map) {
          stateData = Map<String, dynamic>.from(item);
        } else {
          continue; // Skip invalid data
        }
        
        final serverId = _parseInt(stateData['id']);
        final countryIdFromData = _parseInt(stateData['countryId']);
        
        if (countryIdFromData != countryId) continue;
        
        final existing = await getStateByServerId(serverId);
        
        if (existing == null) {
          // Insert new state from server
          final state = StateEntity(
            serverId: serverId,
            name: stateData['name']?.toString() ?? '',
            countryId: countryIdFromData,
            countryName: stateData['country']?['name']?.toString(),
            createdAt: stateData['created']?.toString(),
            createdBy: stateData['createdBy']?.toString(),
            lastModified: stateData['lastModified']?.toString(),
            lastModifiedBy: stateData['lastModifiedBy']?.toString(),
            isSynced: true,
            syncStatus: 'synced',
          );
          await insertState(state);
        } else {
          // Update existing state with server data
          final updatedState = StateEntity(
            id: existing.id,
            serverId: existing.serverId,
            name: stateData['name']?.toString() ?? existing.name,
            countryId: existing.countryId,
            countryName: stateData['country']?['name']?.toString() ?? existing.countryName,
            createdAt: existing.createdAt,
            createdBy: existing.createdBy,
            lastModified: stateData['lastModified']?.toString() ?? existing.lastModified,
            lastModifiedBy: stateData['lastModifiedBy']?.toString() ?? existing.lastModifiedBy,
            isDeleted: existing.isDeleted,
            deletedBy: existing.deletedBy,
            isSynced: true,
            syncStatus: 'synced',
          );
          await updateState(updatedState);
        }
      } catch (e) {
        print('Error syncing state: $e');
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

  // Additional helper methods
  Future<List<StateEntity>> getActiveStatesByCountry(int countryId) async {
    final states = await getStatesByCountry(countryId);
    return states.where((state) => !state.isDeleted).toList();
  }

  Future<StateEntity?> findStateByName(String name, int countryId) async {
    final states = await getStatesByCountry(countryId);
    for (final state in states) {
      if (state.name.toLowerCase() == name.toLowerCase()) {
        return state;
      }
    }
    return null;
  }

  Future<bool> stateExists(String name, int countryId) async {
    final state = await findStateByName(name, countryId);
    return state != null;
  }

  Future<void> restoreState(int id) async {
    final state = await getStateById(id);
    if (state != null && state.isDeleted) {
      final restoredState = StateEntity(
        id: state.id,
        serverId: state.serverId,
        name: state.name,
        countryId: state.countryId,
        countryName: state.countryName,
        createdAt: state.createdAt,
        createdBy: state.createdBy,
        lastModified: DateTime.now().toIso8601String(),
        lastModifiedBy: 'system',
        isDeleted: false,
        deletedBy: null,
        isSynced: false,
        syncStatus: 'pending',
      );
      await updateState(restoredState);
    }
  }

  Future<void> clearAllStatesByCountry(int countryId) async {
    final states = await getStatesByCountry(countryId);
    for (final state in states) {
      await hardDeleteState(state.id!);
    }
  }

  Future<int> getTotalStateCount() async {
    final states = await _stateDao.getStatesByCountry(0); // Adjust based on your DAO method
    return states.length;
  }
}