// lib/database/repository/group_repo.dart
import 'dart:async';
import 'package:nanohospic/database/dao/group_dao.dart';
import 'package:nanohospic/database/entity/group_entity.dart';

class GroupRepository {
  final GroupDao _groupDao;

  GroupRepository(this._groupDao);

  Future<List<GroupEntity>> getAllGroups() async {
    return await _groupDao.getAllGroups();
  }

  Future<GroupEntity?> getGroupById(int id) async {
    return await _groupDao.getGroupById(id);
  }

  Future<GroupEntity?> getGroupByServerId(int serverId) async {
    return await _groupDao.getGroupByServerId(serverId);
  }

  Future<List<GroupEntity>> searchGroups(String query) async {
    return await _groupDao.searchGroups('%$query%');
  }

  Future<int> insertGroup(GroupEntity group) async {
    group.isSynced = false;
    group.syncStatus = 'pending';
    group.createdAt = DateTime.now().toIso8601String();
    
    return await _groupDao.insertGroup(group);
  }

  Future<int> updateGroup(GroupEntity group) async {
    group.lastModified = DateTime.now().toIso8601String();
    group.isSynced = false;
    group.syncStatus = 'pending';
    
    return await _groupDao.updateGroup(group);
  }

  Future<int> deleteGroup(int id) async {
    final result = await _groupDao.markAsDeleted(id);
    return result ?? 0;
  }

  Future<int> hardDeleteGroup(int id) async {
    final group = await getGroupById(id);
    if (group != null) {
      return await _groupDao.deleteGroup(group);
    }
    return 0;
  }

  // Sync related methods
  Future<List<GroupEntity>> getPendingSync() async {
    return await _groupDao.getPendingSyncGroups();
  }

  Future<int> markAsSynced(int id) async {
    final result = await _groupDao.markAsSynced(id);
    return result ?? 0;
  }

  Future<int> markAsFailed(int id) async {
    final result = await _groupDao.markAsFailed(id);
    return result ?? 0;
  }

  // Statistics
  Future<int> getTotalCount() async {
    final allGroups = await getAllGroups();
    return allGroups.length;
  }

  Future<int> getSyncedCount() async {
    final count = await _groupDao.getSyncedGroupsCount();
    return count ?? 0;
  }

  Future<int> getPendingCount() async {
    final count = await _groupDao.getPendingGroupsCount();
    return count ?? 0;
  }

  // Sync from server
  Future<void> syncFromServer(List<dynamic> serverData) async {
    for (final dynamic item in serverData) {
      try {
        Map<String, dynamic> groupData;
        
        if (item is Map<String, dynamic>) {
          groupData = item;
        } else if (item is Map) {
          groupData = Map<String, dynamic>.from(item);
        } else {
          continue;
        }
        
        final serverId = _parseInt(groupData['id']);
        if (serverId == 0) continue;
        
        final existing = await getGroupByServerId(serverId);
        
        if (existing == null) {
          final group = GroupEntity(
            serverId: serverId,
            name: groupData['name']?.toString() ?? '',
            description: groupData['description']?.toString(),
            groupCode: groupData['code']?.toString(),
            type: groupData['type']?.toString() ?? 'general',
            status: groupData['status']?.toString() ?? 'active',
            tenantId: groupData['tenantId']?.toString(),
            createdAt: groupData['created']?.toString(),
            createdBy: groupData['createdBy']?.toString(),
            lastModified: groupData['lastModified']?.toString(),
            lastModifiedBy: groupData['lastModifiedBy']?.toString(),
            isSynced: true,
            syncStatus: 'synced',
          );
          await insertGroup(group);
        } else {
          final updatedGroup = GroupEntity(
            id: existing.id,
            serverId: existing.serverId,
            name: groupData['name']?.toString() ?? existing.name,
            description: groupData['description']?.toString() ?? existing.description,
            groupCode: groupData['code']?.toString() ?? existing.groupCode,
            type: groupData['type']?.toString() ?? existing.type,
            status: groupData['status']?.toString() ?? existing.status,
            tenantId: groupData['tenantId']?.toString() ?? existing.tenantId,
            createdAt: existing.createdAt,
            createdBy: existing.createdBy,
            lastModified: groupData['lastModified']?.toString() ?? existing.lastModified,
            lastModifiedBy: groupData['lastModifiedBy']?.toString() ?? existing.lastModifiedBy,
            isDeleted: existing.isDeleted,
            deletedBy: existing.deletedBy,
            isSynced: true,
            syncStatus: 'synced',
          );
          await updateGroup(updatedGroup);
        }
      } catch (e) {
        print('Error syncing group: $e');
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

  Future<List<GroupEntity>> getActiveGroups() async {
    final groups = await getAllGroups();
    return groups.where((g) => !g.isDeleted).toList();
  }

  Future<void> clearAllGroups() async {
    final groups = await getAllGroups();
    for (final group in groups) {
      await hardDeleteGroup(group.id!);
    }
  }

  Future<void> restoreGroup(int id) async {
    final group = await getGroupById(id);
    if (group != null && group.isDeleted) {
      final restoredGroup = GroupEntity(
        id: group.id,
        serverId: group.serverId,
        name: group.name,
        description: group.description,
        groupCode: group.groupCode,
        type: group.type,
        status: group.status,
        tenantId: group.tenantId,
        createdAt: group.createdAt,
        createdBy: group.createdBy,
        lastModified: DateTime.now().toIso8601String(),
        lastModifiedBy: 'system',
        isDeleted: false,
        deletedBy: null,
        isSynced: false,
        syncStatus: 'pending',
      );
      await updateGroup(restoredGroup);
    }
  }
}