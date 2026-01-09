// database/repository/staff_repo.dart
import 'dart:async';
import 'package:nanohospic/database/dao/staff_dao.dart';

import '../database_provider.dart';
import '../entity/staff_entity.dart';

class StaffRepository {
  late StaffDao _staffDao;

  StaffRepository(StaffDao staffDao) {
    _staffDao = staffDao;
  }

  // Initialize repository
  static Future<StaffRepository> getInstance() async {
    final db = await DatabaseProvider.database;
    return StaffRepository(db.staffDao);
  }

  // CRUD Operations
  Future<List<StaffEntity>> getAllStaff() async {
    try {
      return await _staffDao.getAllStaff();
    } catch (e) {
      print('Error getting all staff: $e');
      rethrow;
    }
  }

  Future<StaffEntity?> getStaffById(int id) async {
    try {
      return await _staffDao.getStaffById(id);
    } catch (e) {
      print('Error getting staff by id: $e');
      rethrow;
    }
  }

  Future<StaffEntity?> getStaffByServerId(int serverId) async {
    try {
      return await _staffDao.getStaffByServerId(serverId);
    } catch (e) {
      print('Error getting staff by server id: $e');
      rethrow;
    }
  }

  Future<int> insertStaff(StaffEntity staff) async {
    try {
      return await _staffDao.insertStaff(staff);
    } catch (e) {
      print('Error inserting staff: $e');
      rethrow;
    }
  }

  Future<void> updateStaff(StaffEntity staff) async {
    try {
      await _staffDao.updateStaff(staff);
    } catch (e) {
      print('Error updating staff: $e');
      rethrow;
    }
  }

  Future<void> deleteStaff(int id) async {
    try {
      await _staffDao.deleteStaff(id);
    } catch (e) {
      print('Error deleting staff: $e');
      rethrow;
    }
  }

  Future<void> softDeleteStaff(int id, String deletedBy) async {
    try {
      await _staffDao.softDeleteStaff(id, deletedBy);
    } catch (e) {
      print('Error soft deleting staff: $e');
      rethrow;
    }
  }

  // Sync Operations
  Future<List<StaffEntity>> getPendingSync() async {
    try {
      return await _staffDao.getPendingSync();
    } catch (e) {
      print('Error getting pending sync: $e');
      rethrow;
    }
  }

  Future<List<StaffEntity>> getPendingDeletions() async {
    try {
      return await _staffDao.getPendingDeletions();
    } catch (e) {
      print('Error getting pending deletions: $e');
      rethrow;
    }
  }

  Future<void> markAsSynced(int id) async {
    try {
      await _staffDao.markAsSynced(id);
    } catch (e) {
      print('Error marking as synced: $e');
      rethrow;
    }
  }

  Future<void> markSyncFailed(int id, String error) async {
    try {
      await _staffDao.markSyncFailed(id, error);
    } catch (e) {
      print('Error marking sync failed: $e');
      rethrow;
    }
  }

  // database/repository/staff_repo.dart - Update statistics methods
Future<int> getTotalCount() async {
  try {
    final count = await _staffDao.getTotalCount();
    return count ?? 0;
  } catch (e) {
    print('Error getting total count: $e');
    return 0;
  }
}

Future<int> getSyncedCount() async {
  try {
    final count = await _staffDao.getSyncedCount();
    return count ?? 0;
  } catch (e) {
    print('Error getting synced count: $e');
    return 0;
  }
}

Future<int> getPendingCount() async {
  try {
    final count = await _staffDao.getPendingCount();
    return count ?? 0;
  } catch (e) {
    print('Error getting pending count: $e');
    return 0;
  }
}

  Future<List<StaffEntity>> searchStaff(String query) async {
    try {
      if (query.isEmpty) {
        return await getAllStaff();
      }
      return await _staffDao.searchStaff('%$query%');
    } catch (e) {
      print('Error searching staff: $e');
      return [];
    }
  }

  Future<List<StaffEntity>> getStaffByDepartment(String department) async {
    try {
      return await _staffDao.getStaffByDepartment(department);
    } catch (e) {
      print('Error getting staff by department: $e');
      return [];
    }
  }

  Future<List<String>> getAllDepartments() async {
    try {
      return await _staffDao.getAllDepartments();
    } catch (e) {
      print('Error getting all departments: $e');
      return [];
    }
  }

  Future<List<String>> getAllDesignations() async {
    try {
      return await _staffDao.getAllDesignations();
    } catch (e) {
      print('Error getting all designations: $e');
      return [];
    }
  }

  // Server Sync
  Future<void> syncFromServer(List<Map<String, dynamic>> staffList) async {
    try {
      for (var staffData in staffList) {
        final staffEntity = StaffEntity.fromServerJson(staffData);
        
        // Check if exists by server id
        if (staffEntity.serverId != null) {
          final existing = await _staffDao.getStaffByServerId(staffEntity.serverId!);
          
          if (existing != null) {
            // Update existing
            final updated = existing.copyWith(
              serverId: staffEntity.serverId,
              name: staffEntity.name,
              department: staffEntity.department,
              designation: staffEntity.designation,
              email: staffEntity.email,
              phone: staffEntity.phone,
              requiredCredentials: staffEntity.requiredCredentials,
              createdAt: staffEntity.createdAt,
              createdBy: staffEntity.createdBy,
              lastModified: staffEntity.lastModified,
              lastModifiedBy: staffEntity.lastModifiedBy,
              isDeleted: staffEntity.isDeleted,
              deletedBy: staffEntity.deletedBy,
              isSynced: 1,
              syncStatus: 'synced',
            );
            await _staffDao.updateStaff(updated);
          } else {
            // Insert new
            await _staffDao.insertStaff(staffEntity.copyWith(isSynced: 1, syncStatus: 'synced'));
          }
        }
      }
      
      // Cleanup old deleted records
      await _staffDao.cleanupDeleted();
    } catch (e) {
      print('Error syncing from server: $e');
      rethrow;
    }
  }

  // Validation
  bool validateEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  bool validatePhone(String phone) {
    final phoneRegex = RegExp(r'^[0-9]{10}$');
    return phoneRegex.hasMatch(phone);
  }
}