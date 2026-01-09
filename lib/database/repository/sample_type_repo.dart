// ignore_for_file: avoid_print, depend_on_referenced_packages

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nanohospic/database/dao/sample_type_dao.dart';
import 'package:nanohospic/database/entity/sample_type_entity.dart';

class SampleTypeRepository {
  final SampleTypeDao _sampleTypeDao;

  SampleTypeRepository(this._sampleTypeDao);

  Future<List<SampleTypeEntity>> getAllSampleTypes() async {
    try {
      print('📋 Fetching all sample types from database...');
      final sampleTypes = await _sampleTypeDao.getAllSampleTypes();
      print('✅ Found ${sampleTypes.length} sample types');
      return sampleTypes;
    } catch (e) {
      print('❌ Error fetching sample types: $e');
      rethrow;
    }
  }

  Future<int> insertSampleType(SampleTypeEntity sampleType) async {
    try {
      print('💾 Inserting sample type: ${sampleType.name}');
      final result = await _sampleTypeDao.insertSampleTypeList([sampleType]);
      print('✅ Sample type inserted with IDs: $result');
      return result.first;
    } catch (e) {
      print('❌ Error inserting sample type: $e');
      rethrow;
    }
  }

  Future<void> updateSampleType(SampleTypeEntity sampleType) async {
    try {
      print('🔄 Updating sample type: ${sampleType.name} (ID: ${sampleType.id})');
      await _sampleTypeDao.updateSampleType(sampleType);
      print('✅ Sample type updated successfully');
    } catch (e) {
      print('❌ Error updating sample type: $e');
      rethrow;
    }
  }

  Future<void> deleteSampleType(int id) async {
    try {
      print('🗑️ Deleting sample type with ID: $id');
      await _sampleTypeDao.deleteSampleType(id);
      print('✅ Sample type deleted successfully');
    } catch (e) {
      print('❌ Error deleting sample type: $e');
      rethrow;
    }
  }

  Future<void> softDeleteSampleType(int id, String deletedBy) async {
    try {
      print('🗑️ Soft deleting sample type with ID: $id');
      await _sampleTypeDao.softDeleteSampleType(
        id,
        deletedBy,
        DateTime.now().toIso8601String(),
      );
      print('✅ Sample type soft deleted successfully');
    } catch (e) {
      print('❌ Error soft deleting sample type: $e');
      rethrow;
    }
  }

  Future<int> getTotalCount() async {
    try {
      final count = await _sampleTypeDao.getTotalCount();
      return count ?? 0;
    } catch (e) {
      print('❌ Error getting total count: $e');
      return 0;
    }
  }

  Future<int> getSyncedCount() async {
    try {
      final count = await _sampleTypeDao.getSyncedCount();
      return count ?? 0;
    } catch (e) {
      print('❌ Error getting synced count: $e');
      return 0;
    }
  }

  Future<int> getPendingCount() async {
    try {
      final count = await _sampleTypeDao.getPendingCount();
      return count ?? 0;
    } catch (e) {
      print('❌ Error getting pending count: $e');
      return 0;
    }
  }

  Future<List<SampleTypeEntity>> getPendingSync() async {
    try {
      return await _sampleTypeDao.getPendingSync();
    } catch (e) {
      print('❌ Error getting pending sync: $e');
      return [];
    }
  }

  Future<void> markAsSynced(int id) async {
    try {
      await _sampleTypeDao.markAsSynced(id);
    } catch (e) {
      print('❌ Error marking as synced: $e');
    }
  }

  Future<void> updateServerId(int id, int serverId) async {
    try {
      await _sampleTypeDao.updateServerId(id, serverId);
    } catch (e) {
      print('❌ Error updating server ID: $e');
    }
  }

  Future<void> updateSyncError(int id, String error) async {
    try {
      await _sampleTypeDao.updateSyncError(id, error);
    } catch (e) {
      print('❌ Error updating sync error: $e');
    }
  }

  Future<void> syncFromServer(List<Map<String, dynamic>> sampleTypesList) async {
    try {
      print('🔄 Syncing ${sampleTypesList.length} sample types from server...');
      
      final entities = sampleTypesList.map((typeData) {
        return SampleTypeEntity(
          serverId: typeData['id'] ?? typeData['Id'],
          name: typeData['name'] ?? typeData['Name'] ?? '',
          description: typeData['description'] ?? typeData['Description'],
          createdAt: typeData['createdAt']?.toString() ?? 
                   typeData['created_at']?.toString() ??
                   DateTime.now().toIso8601String(),
          createdBy: typeData['createdBy']?.toString() ?? typeData['created_by']?.toString(),
          lastModified: typeData['lastModified']?.toString() ?? typeData['last_modified']?.toString(),
          lastModifiedBy: typeData['lastModifiedBy']?.toString() ?? typeData['last_modified_by']?.toString(),
          isDeleted: (typeData['isDeleted'] ?? typeData['is_deleted'] ?? 0) as int,
          deletedBy: typeData['deletedBy']?.toString() ?? typeData['deleted_by']?.toString(),
          isSynced: 1,
          syncStatus: 'synced',
        );
      }).toList();

      print('💾 Saving ${entities.length} sample type entities to local database...');
      await _sampleTypeDao.insertSampleTypeList(entities);
      print('✅ Sample type sync completed successfully');
    } catch (e) {
      print('❌ Error syncing sample types from server: $e');
      rethrow;
    }
  }

  Future<int?> addToServer(SampleTypeEntity sampleType) async {
    try {
      print('☁️ Adding sample type to server: ${sampleType.name}');
      
      final response = await http.post(
        Uri.parse('http://202.140.138.215:85/api/SampleTypeApi'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'id': 0,
          'name': sampleType.name,
          'description': sampleType.description ?? '',
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        print('✅ Sample type added to server with response: $data');
        return data['id'] as int?;
      } else {
        print('❌ Server error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('❌ Error adding sample type to server: $e');
      return null;
    }
  }

  Future<bool> updateOnServer(SampleTypeEntity sampleType) async {
    try {
      if (sampleType.serverId == null) {
        print('⚠️ Cannot update on server: serverId is null');
        return false;
      }

      print('☁️ Updating sample type on server: ${sampleType.name} (ID: ${sampleType.serverId})');
      
      final response = await http.put(
        Uri.parse('http://202.140.138.215:85/api/SampleTypeApi/${sampleType.serverId}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'id': sampleType.serverId,
          'name': sampleType.name,
          'description': sampleType.description ?? '',
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        print('✅ Sample type updated on server successfully');
        return true;
      } else {
        print('❌ Server error: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('❌ Error updating sample type on server: $e');
      return false;
    }
  }

  Future<bool> deleteFromServer(int serverId) async {
    try {
      print('☁️ Deleting sample type from server: ID $serverId');
      
      final response = await http.delete(
        Uri.parse('http://202.140.138.215:85/api/SampleTypeApi/$serverId'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200 || response.statusCode == 204) {
        print('✅ Sample type deleted from server successfully');
        return true;
      } else {
        print('❌ Server error: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('❌ Error deleting sample type from server: $e');
      return false;
    }
  }

  Future<List<SampleTypeEntity>> searchSampleTypes(String query) async {
    try {
      print('🔍 Searching sample types for: $query');
      final results = await _sampleTypeDao.searchSampleTypes('%$query%');
      print('✅ Found ${results.length} results');
      return results;
    } catch (e) {
      print('❌ Error searching sample types: $e');
      return [];
    }
  }

  Future<SampleTypeEntity?> getSampleTypeByServerId(int serverId) async {
    try {
      return await _sampleTypeDao.getSampleTypeByServerId(serverId);
    } catch (e) {
      print('❌ Error getting sample type by server ID: $e');
      return null;
    }
  }
}