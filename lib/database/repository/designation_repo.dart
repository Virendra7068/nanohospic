// database/repository/Designation_repo.dart
// ignore_for_file: avoid_print

import 'dart:async';

import 'package:nanohospic/database/dao/designation_dao.dart';
import 'package:nanohospic/database/entity/designation_entity.dart';

import '../database_provider.dart';

class DesignationRepository {
  late DesignationDao _designationDao;

  DesignationRepository(DesignationDao designationDao) {
    _designationDao = designationDao;
  }

  // Initialize repository
  static Future<DesignationRepository> getInstance() async {
    final db = await DatabaseProvider.database;
    return DesignationRepository(db.designationDao);
  }

  // CRUD Operations
  Future<List<DesignationEntity>> getAllDesignations() async {
    try {
      return await _designationDao.getAllDesignations();
    } catch (e) {
      print('Error getting all Designations: $e');
      rethrow;
    }
  }

  Future<DesignationEntity?> getDesignationById(int id) async {
    try {
      return await _designationDao.getDesignationById(id);
    } catch (e) {
      print('Error getting Designation by id: $e');
      rethrow;
    }
  }

  Future<DesignationEntity?> getDesignationByServerId(int serverId) async {
    try {
      return await _designationDao.getDesignationByServerId(serverId);
    } catch (e) {
      print('Error getting Designation by server id: $e');
      rethrow;
    }
  }

  Future<DesignationEntity?> getDesignationByName(String name) async {
    try {
      return await _designationDao.getDesignationByName(name);
    } catch (e) {
      print('Error getting Designation by name: $e');
      rethrow;
    }
  }

  Future<int> insertDesignation(DesignationEntity designation) async {
    try {
      // Check for duplicate name
      final existing = await _designationDao.getDesignationByName(designation.name);
      if (existing != null) {
        throw Exception('Designation with name "${designation.name}" already exists');
      }
      return await _designationDao.insertDesignation(designation);
    } catch (e) {
      print('Error inserting Designation: $e');
      rethrow;
    }
  }

  Future<void> updateDesignation(DesignationEntity designation) async {
    try {
      // Check for duplicate name (excluding current record)
      final existing = await _designationDao.getDesignationByName(designation.name);
      if (existing != null && existing.id != designation.id) {
        throw Exception('Designation with name "${designation.name}" already exists');
      }
      await _designationDao.updateDesignation(designation);
    } catch (e) {
      print('Error updating Designation: $e');
      rethrow;
    }
  }

  Future<void> deleteDesignation(int id) async {
    try {
      await _designationDao.deleteDesignation(id);
    } catch (e) {
      print('Error deleting Designation: $e');
      rethrow;
    }
  }

  Future<void> softDeleteDesignation(int id, String deletedBy) async {
    try {
      await _designationDao.softDeleteDesignation(id, deletedBy);
    } catch (e) {
      print('Error soft deleting Designation: $e');
      rethrow;
    }
  }

  // Sync Operations
  Future<List<DesignationEntity>> getPendingSync() async {
    try {
      return await _designationDao.getPendingSync();
    } catch (e) {
      print('Error getting pending sync: $e');
      rethrow;
    }
  }

  Future<List<DesignationEntity>> getPendingDeletions() async {
    try {
      return await _designationDao.getPendingDeletions();
    } catch (e) {
      print('Error getting pending deletions: $e');
      rethrow;
    }
  }

  Future<void> markAsSynced(int id) async {
    try {
      await _designationDao.markAsSynced(id);
    } catch (e) {
      print('Error marking as synced: $e');
      rethrow;
    }
  }

  Future<void> markSyncFailed(int id, String error) async {
    try {
      await _designationDao.markSyncFailed(id, error);
    } catch (e) {
      print('Error marking sync failed: $e');
      rethrow;
    }
  }

  // Statistics methods
  Future<int> getTotalCount() async {
    try {
      final count = await _designationDao.getTotalCount();
      return count ?? 0;
    } catch (e) {
      print('Error getting total count: $e');
      return 0;
    }
  }

  Future<int> getSyncedCount() async {
    try {
      final count = await _designationDao.getSyncedCount();
      return count ?? 0;
    } catch (e) {
      print('Error getting synced count: $e');
      return 0;
    }
  }

  Future<int> getPendingCount() async {
    try {
      final count = await _designationDao.getPendingCount();
      return count ?? 0;
    } catch (e) {
      print('Error getting pending count: $e');
      return 0;
    }
  }

  Future<List<DesignationEntity>> searchDesignations(String query) async {
    try {
      if (query.isEmpty) {
        return await getAllDesignations();
      }
      return await _designationDao.searchDesignations('%$query%');
    } catch (e) {
      print('Error searching Designations: $e');
      return [];
    }
  }

  // Server Sync
  Future<void> syncFromServer(List<Map<String, dynamic>> DesignationList) async {
    try {
      // ignore: non_constant_identifier_names
      for (var DesignationData in DesignationList) {
        // ignore: non_constant_identifier_names
        final designationEntity = DesignationEntity.fromServerJson(DesignationData);
        
        // Check if exists by server id
        if (designationEntity.serverId != null) {
          final existing = await _designationDao.getDesignationByServerId(designationEntity.serverId!);
          
          if (existing != null) {
            // Update existing
            final updated = existing.copyWith(
              serverId: designationEntity.serverId,
              name: designationEntity.name,
              description: designationEntity.description,
              createdAt: designationEntity.createdAt,
              createdBy: designationEntity.createdBy,
              lastModified: designationEntity.lastModified,
              lastModifiedBy: designationEntity.lastModifiedBy,
              isDeleted: designationEntity.isDeleted,
              deletedBy: designationEntity.deletedBy,
              isSynced: 1,
              syncStatus: 'synced',
            );
            await _designationDao.updateDesignation(updated);
          } else {
            // Insert new
            await _designationDao.insertDesignation(designationEntity.copyWith(isSynced: 1, syncStatus: 'synced'));
          }
        }
      }
      
      // Cleanup old deleted records
      await _designationDao.cleanupDeleted();
    } catch (e) {
      print('Error syncing from server: $e');
      rethrow;
    }
  }

  // Validation
  bool validateName(String name) {
    return name.trim().isNotEmpty && name.trim().length >= 2;
  }
}