// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nanohospic/database/dao/patient_identity_dao.dart';
import 'package:nanohospic/database/entity/patient_identity_entity.dart';

class BasRepository {
  final BasDao _basDao;

  BasRepository(this._basDao);

  Future<List<BasEntity>> getAllBasNames() async {
    try {
      print('📋 Fetching all bas names from database...');
      final basNames = await _basDao.getAllBasNames();
      print('✅ Found ${basNames.length} bas names');
      return basNames;
    } catch (e) {
      print('❌ Error fetching bas names: $e');
      rethrow;
    }
  }

  Future<int> insertBas(BasEntity bas) async {
    try {
      print('💾 Inserting bas: ${bas.name}');
      final result = await _basDao.insertBasList([bas]);
      print('✅ Bas inserted with IDs: $result');
      return result.first;
    } catch (e) {
      print('❌ Error inserting bas: $e');
      rethrow;
    }
  }

  Future<void> updateBas(BasEntity bas) async {
    try {
      print('🔄 Updating bas: ${bas.name} (ID: ${bas.id})');
      await _basDao.updateBas(bas);
      print('✅ Bas updated successfully');
    } catch (e) {
      print('❌ Error updating bas: $e');
      rethrow;
    }
  }

  Future<void> deleteBas(int id) async {
    try {
      print('🗑️ Deleting bas with ID: $id');
      await _basDao.deleteBas(id);
      print('✅ Bas deleted successfully');
    } catch (e) {
      print('❌ Error deleting bas: $e');
      rethrow;
    }
  }

  Future<void> softDeleteBas(int id, String deletedBy) async {
    try {
      print('🗑️ Soft deleting bas with ID: $id');
      await _basDao.softDeleteBas(
        id,
        deletedBy,
        DateTime.now().toIso8601String(),
      );
      print('✅ Bas soft deleted successfully');
    } catch (e) {
      print('❌ Error soft deleting bas: $e');
      rethrow;
    }
  }

  Future<int> getTotalCount() async {
    try {
      final count = await _basDao.getTotalCount();
      return count ?? 0;
    } catch (e) {
      print('❌ Error getting total count: $e');
      return 0;
    }
  }

  Future<int> getSyncedCount() async {
    try {
      final count = await _basDao.getSyncedCount();
      return count ?? 0;
    } catch (e) {
      print('❌ Error getting synced count: $e');
      return 0;
    }
  }

  Future<int> getPendingCount() async {
    try {
      final count = await _basDao.getPendingCount();
      return count ?? 0;
    } catch (e) {
      print('❌ Error getting pending count: $e');
      return 0;
    }
  }

  Future<List<BasEntity>> getPendingSync() async {
    try {
      return await _basDao.getPendingSync();
    } catch (e) {
      print('❌ Error getting pending sync: $e');
      return [];
    }
  }

  Future<void> markAsSynced(int id) async {
    try {
      await _basDao.markAsSynced(id);
    } catch (e) {
      print('❌ Error marking as synced: $e');
    }
  }

  Future<void> updateServerId(int id, int serverId) async {
    try {
      await _basDao.updateServerId(id, serverId);
    } catch (e) {
      print('❌ Error updating server ID: $e');
    }
  }

  Future<void> updateSyncError(int id, String error) async {
    try {
      await _basDao.updateSyncError(id, error);
    } catch (e) {
      print('❌ Error updating sync error: $e');
    }
  }

  Future<void> syncFromServer(List<Map<String, dynamic>> basList) async {
    try {
      print('🔄 Syncing ${basList.length} bas names from server...');

      final entities = basList.map((basData) {
        return BasEntity(
          serverId: basData['id'] ?? basData['Id'],
          name: basData['name'] ?? basData['Name'] ?? '',
          createdAt:
              basData['createdAt']?.toString() ??
              DateTime.now().toIso8601String(),
          createdBy: basData['createdBy']?.toString(),
          lastModified: basData['lastModified']?.toString(),
          lastModifiedBy: basData['lastModifiedBy']?.toString(),
          isDeleted: (basData['isDeleted'] ?? 0) as int,
          deletedBy: basData['deletedBy']?.toString(),
          isSynced: 1,
          syncStatus: 'synced',
        );
      }).toList();

      print('💾 Saving ${entities.length} bas entities to local database...');
      await _basDao.insertBasList(entities);
      print('✅ Bas sync completed successfully');
    } catch (e) {
      print('❌ Error syncing bas from server: $e');
      rethrow;
    }
  }

  Future<int?> addToServer(BasEntity bas) async {
    try {
      print('☁️ Adding bas to server: ${bas.name}');

      final response = await http
          .post(
            Uri.parse(
              'http://202.140.138.215:85/api/BasApi',
            ), // Update this URL
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'id': 0,
              'name': bas.name,
              'createdBy': bas.createdBy ?? 'mobile_app',
            }),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        print('✅ Bas added to server with response: $data');
        return data['id'] as int?;
      } else {
        print('❌ Server error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('❌ Error adding bas to server: $e');
      return null;
    }
  }

  Future<bool> updateOnServer(BasEntity bas) async {
    try {
      if (bas.serverId == null) {
        print('⚠️ Cannot update on server: serverId is null');
        return false;
      }

      print('☁️ Updating bas on server: ${bas.name} (ID: ${bas.serverId})');

      final response = await http
          .put(
            Uri.parse('http://202.140.138.215:85/api/BasApi/${bas.serverId}'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'id': bas.serverId,
              'name': bas.name,
              'lastModifiedBy': bas.lastModifiedBy ?? 'mobile_app',
            }),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        print('✅ Bas updated on server successfully');
        return true;
      } else {
        print('❌ Server error: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('❌ Error updating bas on server: $e');
      return false;
    }
  }

  Future<bool> deleteFromServer(int serverId) async {
    try {
      print('☁️ Deleting bas from server: ID $serverId');

      final response = await http
          .delete(
            Uri.parse('http://202.140.138.215:85/api/BasApi/$serverId'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200 || response.statusCode == 204) {
        print('✅ Bas deleted from server successfully');
        return true;
      } else {
        print('❌ Server error: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('❌ Error deleting bas from server: $e');
      return false;
    }
  }

  Future<List<BasEntity>> searchBasNames(String query) async {
    try {
      print('🔍 Searching bas names for: $query');
      final results = await _basDao.searchBasNames('%$query%');
      print('✅ Found ${results.length} results');
      return results;
    } catch (e) {
      print('❌ Error searching bas names: $e');
      return [];
    }
  }

  Future<BasEntity?> getBasByServerId(int serverId) async {
    try {
      return await _basDao.getBasByServerId(serverId);
    } catch (e) {
      print('❌ Error getting bas by server ID: $e');
      return null;
    }
  }
}
