// lib/database/repository/group_repo.dart
// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nanohospic/database/dao/group_dao.dart';
import 'package:nanohospic/database/entity/group_entity.dart';

class GroupRepo {
  final GroupDao _groupDao;

  GroupRepo(this._groupDao);

  Future<List<GroupEntity>> getAllGroups() async {
    try {
      print('📋 Fetching all groups from database...');
      final allGroups = await _groupDao.getAllGroups();
      print('✅ Found ${allGroups.length} groups');
      return allGroups;
    } catch (e, stackTrace) {
      print('❌ Error fetching groups: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  Future<void> insertGroup(GroupEntity group) async {
    try {
      print('💾 Inserting group: ${group.name}');
      await _groupDao.insertGroup(group);
      print('✅ Group inserted successfully');
    } catch (e) {
      print('❌ Error inserting group: $e');
      rethrow;
    }
  }

  Future<void> updateGroup(GroupEntity group) async {
    try {
      print('🔄 Updating group: ${group.name} (ID: ${group.id})');
      await _groupDao.updateGroup(group);
      print('✅ Group updated successfully');
    } catch (e) {
      print('❌ Error updating group: $e');
      rethrow;
    }
  }

  // Hard delete - permanently remove from database
  Future<void> deleteGroup(int id) async {
    try {
      print('🗑️ Hard deleting group with ID: $id');
      await _groupDao.deleteGroup(id);
      print('✅ Group permanently deleted');
    } catch (e) {
      print('❌ Error deleting group: $e');
      rethrow;
    }
  }

  // Soft delete - mark as deleted without removing
  Future<void> softDeleteGroup(int id, String deletedBy) async {
    try {
      print('🗑️ Soft deleting group with ID: $id');
      await _groupDao.softDeleteGroup(id, deletedBy, DateTime.now().toIso8601String());
      print('✅ Group soft deleted successfully');
    } catch (e) {
      print('❌ Error soft deleting group: $e');
      rethrow;
    }
  }

  Future<List<GroupEntity>> getDeletedGroups() async {
    try {
      print('📋 Fetching deleted groups...');
      final deletedGroups = await _groupDao.getDeletedGroups();
      print('✅ Found ${deletedGroups.length} deleted groups');
      return deletedGroups;
    } catch (e) {
      print('❌ Error getting deleted groups: $e');
      return [];
    }
  }

  Future<void> restoreGroup(int id) async {
    try {
      print('🔄 Restoring group with ID: $id');
      await _groupDao.restoreGroup(id);
      print('✅ Group restored successfully');
    } catch (e) {
      print('❌ Error restoring group: $e');
      rethrow;
    }
  }

  Future<int> getTotalCount() async {
    try {
      final count = await _groupDao.getTotalCount();
      return count ?? 0;
    } catch (e) {
      print('❌ Error getting total count: $e');
      return 0;
    }
  }

  Future<int> getSyncedCount() async {
    try {
      final count = await _groupDao.getSyncedCount();
      return count ?? 0;
    } catch (e) {
      print('❌ Error getting synced count: $e');
      return 0;
    }
  }

  Future<int> getPendingCount() async {
    try {
      final count = await _groupDao.getPendingCount();
      return count ?? 0;
    } catch (e) {
      print('❌ Error getting pending count: $e');
      return 0;
    }
  }

  Future<List<GroupEntity>> getPendingSync() async {
    try {
      final pendingGroups = await _groupDao.getPendingSync();
      print('📊 Found ${pendingGroups.length} groups pending sync');
      return pendingGroups;
    } catch (e) {
      print('❌ Error getting pending sync: $e');
      return [];
    }
  }

  Future<void> markAsSynced(int id) async {
    try {
      print('✅ Marking group $id as synced');
      await _groupDao.markAsSynced(id);
    } catch (e) {
      print('❌ Error marking as synced: $e');
    }
  }

  Future<void> updateServerId(int id, int serverId) async {
    try {
      print('🔄 Updating server ID for group $id to $serverId');
      await _groupDao.updateServerId(id, serverId);
    } catch (e) {
      print('❌ Error updating server ID: $e');
    }
  }

  Future<void> updateSyncError(int id, String error) async {
    try {
      print('⚠️ Updating sync error for group $id: $error');
      await _groupDao.updateSyncError(id, error);
    } catch (e) {
      print('❌ Error updating sync error: $e');
    }
  }

  Future<void> syncFromServer(List<Map<String, dynamic>> groupsList) async {
    try {
      print('🔄 Syncing ${groupsList.length} groups from server...');
      
      final entities = groupsList.map((groupData) {
        return GroupEntity(
          serverId: groupData['id'] ?? groupData['Id'],
          name: groupData['name'] ?? groupData['Name'] ?? '',
          description: groupData['description'] ?? groupData['Description'] ?? '',
          code: groupData['code'] ?? groupData['Code'] ?? '',
          type: groupData['type'] ?? groupData['Type'] ?? 'general',
          status: groupData['status'] ?? groupData['Status'] ?? 'active',
          tenantId: groupData['tenantId'] ?? groupData['tenant_id'] ?? 'default_tenant',
          createdAt: groupData['created']?.toString() ?? 
                   groupData['createdAt']?.toString() ??
                   DateTime.now().toIso8601String(),
          createdBy: groupData['createdBy']?.toString() ?? 
                    groupData['created_by']?.toString() ?? 'system',
          lastModified: groupData['lastModified']?.toString() ?? 
                       groupData['last_modified']?.toString(),
          lastModifiedBy: groupData['lastModifiedBy']?.toString() ?? 
                         groupData['last_modified_by']?.toString(),
          isDeleted: (groupData['isDeleted'] ?? groupData['is_deleted'] ?? 0) as int,
          deletedBy: groupData['deletedBy']?.toString() ?? 
                    groupData['deleted_by']?.toString(),
          isSynced: 1,
          syncStatus: 'synced',
          syncAttempts: 0,
          lastSyncError: null,
        );
      }).toList();

      print('💾 Saving ${entities.length} group entities to local database...');
      await _groupDao.insertGroups(entities);
      print('✅ Group sync completed successfully');
    } catch (e, stackTrace) {
      print('❌ Error syncing groups from server: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  Future<int?> addToServer(GroupEntity group) async {
    try {
      print('☁️ Adding group to server: ${group.name}');
      
      final response = await http.post(
        Uri.parse('http://202.140.138.215:85/api/GroupApi/Create'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'id': 0,
          'name': group.name,
          'description': group.description ?? '',
          'code': group.code ?? '',
          'type': group.type ?? 'general',
          'status': group.status ?? 'active',
          'tenantId': group.tenantId ?? 'default_tenant',
          'created': DateTime.now().toIso8601String(),
          'createdBy': group.createdBy ?? 'mobile_app',
          'lastModified': DateTime.now().toIso8601String(),
          'lastModifiedBy': group.createdBy ?? 'mobile_app',
          'isDeleted': 0,
          'deletedBy': null,
        }),
      ).timeout(const Duration(seconds: 10));

      print('📥 Server response: ${response.statusCode} - ${response.body}');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final data = json.decode(response.body);
          print('✅ Group added to server with response: $data');
          
          // Try to extract ID from different possible formats
          final serverId = data['id'] ?? data['Id'] ?? data['ID'];
          if (serverId != null) {
            return int.tryParse(serverId.toString());
          }
          return null;
        } catch (parseError) {
          print('⚠️ Error parsing server response: $parseError');
          return null;
        }
      } else {
        print('❌ Server error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('❌ Error adding group to server: $e');
      return null;
    }
  }

  Future<bool> updateOnServer(GroupEntity group) async {
    try {
      if (group.serverId == null) {
        print('⚠️ Cannot update on server: serverId is null');
        return false;
      }

      print('☁️ Updating group on server: ${group.name} (ID: ${group.serverId})');
      
      final response = await http.put(
        Uri.parse('http://202.140.138.215:85/api/GroupApi/${group.serverId}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'id': group.serverId,
          'name': group.name,
          'description': group.description ?? '',
          'code': group.code ?? '',
          'type': group.type ?? 'general',
          'status': group.status ?? 'active',
          'tenantId': group.tenantId ?? 'default_tenant',
          'created': group.createdAt ?? DateTime.now().toIso8601String(),
          'createdBy': group.createdBy ?? 'mobile_app',
          'lastModified': DateTime.now().toIso8601String(),
          'lastModifiedBy': group.createdBy ?? 'mobile_app',
          'isDeleted': group.isDeleted,
          'deletedBy': group.deletedBy,
        }),
      ).timeout(const Duration(seconds: 10));

      print('📥 Server response: ${response.statusCode} - ${response.body}');
      
      if (response.statusCode == 200) {
        print('✅ Group updated on server successfully');
        return true;
      } else {
        print('❌ Server error: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('❌ Error updating group on server: $e');
      return false;
    }
  }

  Future<bool> deleteFromServer(int serverId) async {
    try {
      print('☁️ Deleting group from server: ID $serverId');
      
      final response = await http.delete(
        Uri.parse('http://202.140.138.215:85/api/GroupApi/$serverId'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      print('📥 Server response: ${response.statusCode} - ${response.body}');
      
      if (response.statusCode == 200) {
        print('✅ Group deleted from server successfully');
        return true;
      } else {
        print('❌ Server error: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('❌ Error deleting group from server: $e');
      return false;
    }
  }

  Future<List<GroupEntity>> searchGroups(String query) async {
    try {
      print('🔍 Searching groups for: $query');
      final searchQuery = '%$query%';
      final results = await _groupDao.searchGroups(searchQuery);
      print('✅ Found ${results.length} results');
      return results;
    } catch (e) {
      print('❌ Error searching groups: $e');
      return [];
    }
  }

  Future<GroupEntity?> getGroupByServerId(int serverId) async {
    try {
      final group = await _groupDao.getGroupByServerId(serverId);
      if (group == null) {
        print('⚠️ No group found with server ID: $serverId');
      }
      return group;
    } catch (e) {
      print('❌ Error getting group by server ID: $e');
      return null;
    }
  }

  Future<GroupEntity?> getGroupById(int id) async {
    try {
      final group = await _groupDao.getGroupById(id);
      if (group == null) {
        print('⚠️ No group found with ID: $id');
      }
      return group;
    } catch (e) {
      print('❌ Error getting group by ID: $e');
      return null;
    }
  }

  // Get groups by type
  Future<List<GroupEntity>> getGroupsByType(String type) async {
    try {
      final allGroups = await getAllGroups();
      return allGroups.where((group) => group.type == type).toList();
    } catch (e) {
      print('❌ Error getting groups by type: $e');
      return [];
    }
  }

  // Get groups by status
  Future<List<GroupEntity>> getGroupsByStatus(String status) async {
    try {
      final allGroups = await getAllGroups();
      return allGroups.where((group) => group.status == status).toList();
    } catch (e) {
      print('❌ Error getting groups by status: $e');
      return [];
    }
  }

  // Get active groups (not deleted and status active)
  Future<List<GroupEntity>> getActiveGroups() async {
    try {
      final allGroups = await getAllGroups();
      return allGroups
          .where((group) => group.isDeleted == 0 && group.status == 'active')
          .toList();
    } catch (e) {
      print('❌ Error getting active groups: $e');
      return [];
    }
  }

  // Sync individual group
  Future<bool> syncSingleGroup(GroupEntity group) async {
    try {
      print('🔄 Syncing single group: ${group.name}');
      
      if (group.serverId == null) {
        // Add new group to server
        final serverId = await addToServer(group);
        if (serverId != null) {
          await updateServerId(group.id!, serverId);
          await markAsSynced(group.id!);
          return true;
        }
        return false;
      } else {
        // Update existing group on server
        final success = await updateOnServer(group);
        if (success) {
          await markAsSynced(group.id!);
          return true;
        }
        return false;
      }
    } catch (e) {
      print('❌ Error syncing single group: $e');
      await updateSyncError(group.id!, e.toString());
      return false;
    }
  }

  // Bulk sync
  Future<void> bulkSync(List<GroupEntity> groups) async {
    try {
      print('🔄 Bulk syncing ${groups.length} groups...');
      
      int successCount = 0;
      int failCount = 0;
      
      for (final group in groups) {
        final success = await syncSingleGroup(group);
        if (success) {
          successCount++;
        } else {
          failCount++;
        }
      }
      
      print('📊 Bulk sync completed: $successCount succeeded, $failCount failed');
    } catch (e) {
      print('❌ Bulk sync error: $e');
    }
  }

  // Validate group data before saving
  String? validateGroup(GroupEntity group) {
    if (group.name.isEmpty) {
      return 'Group name is required';
    }
    
    if (group.name.length < 2) {
      return 'Group name must be at least 2 characters';
    }
    
    if (group.name.length > 100) {
      return 'Group name cannot exceed 100 characters';
    }
    
    if (group.code != null && group.code!.length > 20) {
      return 'Group code cannot exceed 20 characters';
    }
    
    return null; // Validation passed
  }

  // Create group with validation
  Future<GroupEntity?> createGroup({
    required String name,
    String? description,
    String? code,
    String? type,
    String? status,
    String? createdBy,
  }) async {
    try {
      final group = GroupEntity(
        name: name.trim(),
        description: description?.trim(),
        code: code?.trim(),
        type: type?.trim() ?? 'general',
        status: status?.trim() ?? 'active',
        tenantId: 'default_tenant',
        createdAt: DateTime.now().toIso8601String(),
        createdBy: createdBy ?? 'user',
        isSynced: 0,
      );
      
      // Validate
      final validationError = validateGroup(group);
      if (validationError != null) {
        print('❌ Validation failed: $validationError');
        return null;
      }
      
      // Check for duplicate name
      final existingGroups = await getAllGroups();
      final duplicate = existingGroups.any(
        (g) => g.name.toLowerCase() == name.toLowerCase() && g.isDeleted == 0
      );
      
      if (duplicate) {
        print('❌ Group with name "$name" already exists');
        return null;
      }
      
      await insertGroup(group);
      return group;
    } catch (e) {
      print('❌ Error creating group: $e');
      return null;
    }
  }

  // Test DAO connection
  Future<bool> testDaoConnection() async {
    try {
      print('🔧 Testing GroupDao connection...');
      final count = await getTotalCount();
      print('✅ GroupDao is working. Total groups: $count');
      return true;
    } catch (e, stackTrace) {
      print('❌ GroupDao test failed: $e');
      print('Stack trace: $stackTrace');
      return false;
    }
  }
}