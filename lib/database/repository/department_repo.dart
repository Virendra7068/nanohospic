// database/repository/department_repo.dart
// ignore_for_file: avoid_print

import 'dart:async';

import 'package:nanohospic/database/dao/department_dao.dart';

import '../database_provider.dart';
import '../entity/department_entity.dart';

class DepartmentRepository {
  late DepartmentDao _departmentDao;

  DepartmentRepository(DepartmentDao departmentDao) {
    _departmentDao = departmentDao;
  }

  // Initialize repository
  static Future<DepartmentRepository> getInstance() async {
    final db = await DatabaseProvider.database;
    return DepartmentRepository(db.departmentDao);
  }

  // CRUD Operations
  Future<List<DepartmentEntity>> getAllDepartments() async {
    try {
      return await _departmentDao.getAllDepartments();
    } catch (e) {
      print('Error getting all departments: $e');
      rethrow;
    }
  }

  Future<DepartmentEntity?> getDepartmentById(int id) async {
    try {
      return await _departmentDao.getDepartmentById(id);
    } catch (e) {
      print('Error getting department by id: $e');
      rethrow;
    }
  }

  Future<DepartmentEntity?> getDepartmentByServerId(int serverId) async {
    try {
      return await _departmentDao.getDepartmentByServerId(serverId);
    } catch (e) {
      print('Error getting department by server id: $e');
      rethrow;
    }
  }

  Future<DepartmentEntity?> getDepartmentByName(String name) async {
    try {
      return await _departmentDao.getDepartmentByName(name);
    } catch (e) {
      print('Error getting department by name: $e');
      rethrow;
    }
  }

  Future<int> insertDepartment(DepartmentEntity department) async {
    try {
      // Check for duplicate name
      final existing = await _departmentDao.getDepartmentByName(department.name);
      if (existing != null) {
        throw Exception('Department with name "${department.name}" already exists');
      }
      return await _departmentDao.insertDepartment(department);
    } catch (e) {
      print('Error inserting department: $e');
      rethrow;
    }
  }

  Future<void> updateDepartment(DepartmentEntity department) async {
    try {
      // Check for duplicate name (excluding current record)
      final existing = await _departmentDao.getDepartmentByName(department.name);
      if (existing != null && existing.id != department.id) {
        throw Exception('Department with name "${department.name}" already exists');
      }
      await _departmentDao.updateDepartment(department);
    } catch (e) {
      print('Error updating department: $e');
      rethrow;
    }
  }

  Future<void> deleteDepartment(int id) async {
    try {
      await _departmentDao.deleteDepartment(id);
    } catch (e) {
      print('Error deleting department: $e');
      rethrow;
    }
  }

  Future<void> softDeleteDepartment(int id, String deletedBy) async {
    try {
      await _departmentDao.softDeleteDepartment(id, deletedBy);
    } catch (e) {
      print('Error soft deleting department: $e');
      rethrow;
    }
  }

  // Sync Operations
  Future<List<DepartmentEntity>> getPendingSync() async {
    try {
      return await _departmentDao.getPendingSync();
    } catch (e) {
      print('Error getting pending sync: $e');
      rethrow;
    }
  }

  Future<List<DepartmentEntity>> getPendingDeletions() async {
    try {
      return await _departmentDao.getPendingDeletions();
    } catch (e) {
      print('Error getting pending deletions: $e');
      rethrow;
    }
  }

  Future<void> markAsSynced(int id) async {
    try {
      await _departmentDao.markAsSynced(id);
    } catch (e) {
      print('Error marking as synced: $e');
      rethrow;
    }
  }

  Future<void> markSyncFailed(int id, String error) async {
    try {
      await _departmentDao.markSyncFailed(id, error);
    } catch (e) {
      print('Error marking sync failed: $e');
      rethrow;
    }
  }

  // Statistics methods
  Future<int> getTotalCount() async {
    try {
      final count = await _departmentDao.getTotalCount();
      return count ?? 0;
    } catch (e) {
      print('Error getting total count: $e');
      return 0;
    }
  }

  Future<int> getSyncedCount() async {
    try {
      final count = await _departmentDao.getSyncedCount();
      return count ?? 0;
    } catch (e) {
      print('Error getting synced count: $e');
      return 0;
    }
  }

  Future<int> getPendingCount() async {
    try {
      final count = await _departmentDao.getPendingCount();
      return count ?? 0;
    } catch (e) {
      print('Error getting pending count: $e');
      return 0;
    }
  }

  Future<List<DepartmentEntity>> searchDepartments(String query) async {
    try {
      if (query.isEmpty) {
        return await getAllDepartments();
      }
      return await _departmentDao.searchDepartments('%$query%');
    } catch (e) {
      print('Error searching departments: $e');
      return [];
    }
  }

  // Server Sync
  Future<void> syncFromServer(List<Map<String, dynamic>> departmentList) async {
    try {
      for (var departmentData in departmentList) {
        final departmentEntity = DepartmentEntity.fromServerJson(departmentData);
        
        // Check if exists by server id
        if (departmentEntity.serverId != null) {
          final existing = await _departmentDao.getDepartmentByServerId(departmentEntity.serverId!);
          
          if (existing != null) {
            // Update existing
            final updated = existing.copyWith(
              serverId: departmentEntity.serverId,
              name: departmentEntity.name,
              description: departmentEntity.description,
              createdAt: departmentEntity.createdAt,
              createdBy: departmentEntity.createdBy,
              lastModified: departmentEntity.lastModified,
              lastModifiedBy: departmentEntity.lastModifiedBy,
              isDeleted: departmentEntity.isDeleted,
              deletedBy: departmentEntity.deletedBy,
              isSynced: 1,
              syncStatus: 'synced',
            );
            await _departmentDao.updateDepartment(updated);
          } else {
            // Insert new
            await _departmentDao.insertDepartment(departmentEntity.copyWith(isSynced: 1, syncStatus: 'synced'));
          }
        }
      }
      
      // Cleanup old deleted records
      await _departmentDao.cleanupDeleted();
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