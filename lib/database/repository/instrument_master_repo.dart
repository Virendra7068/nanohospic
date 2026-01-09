// lib/database/repository/instrument_repo.dart
import 'dart:async';
import 'package:nanohospic/database/dao/instrument_master_dao.dart';
import 'package:nanohospic/database/entity/instrument_entity.dart';

class InstrumentRepository {
  final InstrumentDao _instrumentDao;

  InstrumentRepository(this._instrumentDao);

  Future<List<InstrumentEntity>> getAllInstruments() async {
    return await _instrumentDao.getAllInstruments();
  }

  Future<InstrumentEntity?> getInstrumentById(int id) async {
    return await _instrumentDao.getInstrumentById(id);
  }

  Future<InstrumentEntity?> getInstrumentByServerId(int serverId) async {
    return await _instrumentDao.getInstrumentByServerId(serverId);
  }

  Future<List<InstrumentEntity>> searchInstruments(String query) async {
    return await _instrumentDao.searchInstruments('%$query%');
  }

  Future<int> insertInstrument(InstrumentEntity instrument) async {
    instrument.isSynced = false;
    instrument.syncStatus = 'pending';
    instrument.createdAt = DateTime.now().toIso8601String();
    
    return await _instrumentDao.insertInstrument(instrument);
  }

  Future<int> updateInstrument(InstrumentEntity instrument) async {
    instrument.lastModified = DateTime.now().toIso8601String();
    instrument.isSynced = false;
    instrument.syncStatus = 'pending';
    
    return await _instrumentDao.updateInstrument(instrument);
  }

  Future<int> deleteInstrument(int id) async {
    final result = await _instrumentDao.markAsDeleted(id);
    return result ?? 0;
  }

  Future<int> hardDeleteInstrument(int id) async {
    final instrument = await getInstrumentById(id);
    if (instrument != null) {
      return await _instrumentDao.deleteInstrument(instrument);
    }
    return 0;
  }

  // Sync related methods
  Future<List<InstrumentEntity>> getPendingSync() async {
    return await _instrumentDao.getPendingSyncInstruments();
  }

  Future<int> markAsSynced(int id) async {
    final result = await _instrumentDao.markAsSynced(id);
    return result ?? 0;
  }

  Future<int> markAsFailed(int id) async {
    final result = await _instrumentDao.markAsFailed(id);
    return result ?? 0;
  }

  // Statistics
  Future<int> getTotalCount() async {
    final allInstruments = await getAllInstruments();
    return allInstruments.length;
  }

  Future<int> getSyncedCount() async {
    final count = await _instrumentDao.getSyncedInstrumentsCount();
    return count ?? 0;
  }

  Future<int> getPendingCount() async {
    final count = await _instrumentDao.getPendingInstrumentsCount();
    return count ?? 0;
  }

  // Sync from server
  Future<void> syncFromServer(List<dynamic> serverData) async {
    for (final dynamic item in serverData) {
      try {
        Map<String, dynamic> instrumentData;
        
        if (item is Map<String, dynamic>) {
          instrumentData = item;
        } else if (item is Map) {
          instrumentData = Map<String, dynamic>.from(item);
        } else {
          continue;
        }
        
        final serverId = _parseInt(instrumentData['id']);
        if (serverId == 0) continue;
        
        final existing = await getInstrumentByServerId(serverId);
        
        if (existing == null) {
          final instrument = InstrumentEntity(
            serverId: serverId,
            machineName: instrumentData['machineName']?.toString() ?? '',
            description: instrumentData['description']?.toString() ?? '',
            createdAt: instrumentData['created']?.toString(),
            createdBy: instrumentData['createdBy']?.toString(),
            lastModified: instrumentData['lastModified']?.toString(),
            lastModifiedBy: instrumentData['lastModifiedBy']?.toString(),
            isSynced: true,
            syncStatus: 'synced',
          );
          await insertInstrument(instrument);
        } else {
          final updatedInstrument = InstrumentEntity(
            id: existing.id,
            serverId: existing.serverId,
            machineName: instrumentData['machineName']?.toString() ?? existing.machineName,
            description: instrumentData['description']?.toString() ?? existing.description,
            createdAt: existing.createdAt,
            createdBy: existing.createdBy,
            lastModified: instrumentData['lastModified']?.toString() ?? existing.lastModified,
            lastModifiedBy: instrumentData['lastModifiedBy']?.toString() ?? existing.lastModifiedBy,
            isDeleted: existing.isDeleted,
            deletedBy: existing.deletedBy,
            isSynced: true,
            syncStatus: 'synced',
          );
          await updateInstrument(updatedInstrument);
        }
      } catch (e) {
        print('Error syncing instrument: $e');
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

  Future<List<InstrumentEntity>> getActiveInstruments() async {
    final instruments = await getAllInstruments();
    return instruments.where((i) => !i.isDeleted).toList();
  }

  Future<void> clearAllInstruments() async {
    final instruments = await getAllInstruments();
    for (final instrument in instruments) {
      await hardDeleteInstrument(instrument.id!);
    }
  }

  Future<void> restoreInstrument(int id) async {
    final instrument = await getInstrumentById(id);
    if (instrument != null && instrument.isDeleted) {
      final restoredInstrument = InstrumentEntity(
        id: instrument.id,
        serverId: instrument.serverId,
        machineName: instrument.machineName,
        description: instrument.description,
        createdAt: instrument.createdAt,
        createdBy: instrument.createdBy,
        lastModified: DateTime.now().toIso8601String(),
        lastModifiedBy: 'system',
        isDeleted: false,
        deletedBy: null,
        isSynced: false,
        syncStatus: 'pending',
      );
      await updateInstrument(restoredInstrument);
    }
  }
}