// ignore_for_file: avoid_print, depend_on_referenced_packages

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../dao/branch_type_dao.dart';
import '../entity/branch_type_entity.dart';

class BranchTypeRepository {
  final BranchTypeDao _branchTypeDao;

  BranchTypeRepository(this._branchTypeDao);

  Future<List<BranchTypeEntity>> getAllBranchTypes() async {
    try {
      print('📋 Fetching all branch types from database...');
      final branchTypes = await _branchTypeDao.getAllBranchTypes();
      print('✅ Found ${branchTypes.length} branch types');
      return branchTypes;
    } catch (e) {
      print('❌ Error fetching branch types: $e');
      rethrow;
    }
  }

  Future<int> insertBranchType(BranchTypeEntity branchType) async {
    try {
      print('💾 Inserting branch type: ${branchType.companyName}');
      final result = await _branchTypeDao.insertBranchTypeList([branchType]);
      print('✅ Branch type inserted with IDs: $result');
      return result.first;
    } catch (e) {
      print('❌ Error inserting branch type: $e');
      rethrow;
    }
  }

  Future<void> updateBranchType(BranchTypeEntity branchType) async {
    try {
      print('🔄 Updating branch type: ${branchType.companyName} (ID: ${branchType.id})');
      await _branchTypeDao.updateBranchType(branchType);
      print('✅ Branch type updated successfully');
    } catch (e) {
      print('❌ Error updating branch type: $e');
      rethrow;
    }
  }

  Future<void> deleteBranchType(int id) async {
    try {
      print('🗑️ Deleting branch type with ID: $id');
      await _branchTypeDao.deleteBranchType(id);
      print('✅ Branch type deleted successfully');
    } catch (e) {
      print('❌ Error deleting branch type: $e');
      rethrow;
    }
  }

  Future<void> softDeleteBranchType(int id, String deletedBy) async {
    try {
      print('🗑️ Soft deleting branch type with ID: $id');
      await _branchTypeDao.softDeleteBranchType(
        id,
        deletedBy,
        DateTime.now().toIso8601String(),
      );
      print('✅ Branch type soft deleted successfully');
    } catch (e) {
      print('❌ Error soft deleting branch type: $e');
      rethrow;
    }
  }

  Future<int> getTotalCount() async {
    try {
      final count = await _branchTypeDao.getTotalCount();
      return count ?? 0;
    } catch (e) {
      print('❌ Error getting total count: $e');
      return 0;
    }
  }

  Future<int> getSyncedCount() async {
    try {
      final count = await _branchTypeDao.getSyncedCount();
      return count ?? 0;
    } catch (e) {
      print('❌ Error getting synced count: $e');
      return 0;
    }
  }

  Future<int> getPendingCount() async {
    try {
      final count = await _branchTypeDao.getPendingCount();
      return count ?? 0;
    } catch (e) {
      print('❌ Error getting pending count: $e');
      return 0;
    }
  }

  Future<List<BranchTypeEntity>> getPendingSync() async {
    try {
      return await _branchTypeDao.getPendingSync();
    } catch (e) {
      print('❌ Error getting pending sync: $e');
      return [];
    }
  }

  Future<void> markAsSynced(int id) async {
    try {
      await _branchTypeDao.markAsSynced(id);
    } catch (e) {
      print('❌ Error marking as synced: $e');
    }
  }

  Future<void> updateServerId(int id, int serverId) async {
    try {
      await _branchTypeDao.updateServerId(id, serverId);
    } catch (e) {
      print('❌ Error updating server ID: $e');
    }
  }

  Future<void> updateSyncError(int id, String error) async {
    try {
      await _branchTypeDao.updateSyncError(id, error);
    } catch (e) {
      print('❌ Error updating sync error: $e');
    }
  }

  Future<void> syncFromServer(List<Map<String, dynamic>> branchTypesList) async {
    try {
      print('🔄 Syncing ${branchTypesList.length} branch types from server...');
      
      final entities = branchTypesList.map((typeData) {
        return BranchTypeEntity(
          serverId: typeData['id'] ?? typeData['Id'],
          companyName: typeData['companyName'] ?? typeData['CompanyName'] ?? '',
          contactPerson: typeData['contactPerson'] ?? typeData['ContactPerson'] ?? '',
          contactNo: typeData['contactNo'] ?? typeData['ContactNo'] ?? '',
          email: typeData['email'] ?? typeData['Email'] ?? '',
          address1: typeData['address1'] ?? typeData['Address1'] ?? '',
          location: typeData['location'] ?? typeData['Location'] ?? '',
          type: typeData['type'] ?? typeData['Type'] ?? '',
          designation: typeData['designation'] ?? typeData['Designation'] ?? '',
          mobileNo: typeData['mobileNo'] ?? typeData['MobileNo'] ?? '',
          address2: typeData['address2'] ?? typeData['Address2'] ?? '',
          country: typeData['country'] ?? typeData['Country'] ?? '',
          state: typeData['state'] ?? typeData['State'] ?? '',
          city: typeData['city'] ?? typeData['City'] ?? '',
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

      print('💾 Saving ${entities.length} branch type entities to local database...');
      await _branchTypeDao.insertBranchTypeList(entities);
      print('✅ Branch type sync completed successfully');
    } catch (e) {
      print('❌ Error syncing branch types from server: $e');
      rethrow;
    }
  }

  Future<int?> addToServer(BranchTypeEntity branchType) async {
    try {
      print('☁️ Adding branch type to server: ${branchType.companyName}');
      
      final response = await http.post(
        Uri.parse('http://202.140.138.215:85/api/BranchTypeApi'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'id': 0,
          'companyName': branchType.companyName,
          'contactPerson': branchType.contactPerson,
          'contactNo': branchType.contactNo,
          'email': branchType.email,
          'address1': branchType.address1,
          'location': branchType.location,
          'type': branchType.type,
          'designation': branchType.designation,
          'mobileNo': branchType.mobileNo,
          'address2': branchType.address2,
          'country': branchType.country,
          'state': branchType.state,
          'city': branchType.city,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        print('✅ Branch type added to server with response: $data');
        return data['id'] as int?;
      } else {
        print('❌ Server error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('❌ Error adding branch type to server: $e');
      return null;
    }
  }

  Future<bool> updateOnServer(BranchTypeEntity branchType) async {
    try {
      if (branchType.serverId == null) {
        print('⚠️ Cannot update on server: serverId is null');
        return false;
      }

      print('☁️ Updating branch type on server: ${branchType.companyName} (ID: ${branchType.serverId})');
      
      final response = await http.put(
        Uri.parse('http://202.140.138.215:85/api/BranchTypeApi/${branchType.serverId}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'id': branchType.serverId,
          'companyName': branchType.companyName,
          'contactPerson': branchType.contactPerson,
          'contactNo': branchType.contactNo,
          'email': branchType.email,
          'address1': branchType.address1,
          'location': branchType.location,
          'type': branchType.type,
          'designation': branchType.designation,
          'mobileNo': branchType.mobileNo,
          'address2': branchType.address2,
          'country': branchType.country,
          'state': branchType.state,
          'city': branchType.city,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        print('✅ Branch type updated on server successfully');
        return true;
      } else {
        print('❌ Server error: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('❌ Error updating branch type on server: $e');
      return false;
    }
  }

  Future<bool> deleteFromServer(int serverId) async {
    try {
      print('☁️ Deleting branch type from server: ID $serverId');
      
      final response = await http.delete(
        Uri.parse('http://202.140.138.215:85/api/BranchTypeApi/$serverId'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200 || response.statusCode == 204) {
        print('✅ Branch type deleted from server successfully');
        return true;
      } else {
        print('❌ Server error: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('❌ Error deleting branch type from server: $e');
      return false;
    }
  }

  Future<List<BranchTypeEntity>> searchBranchTypes(String query) async {
    try {
      print('🔍 Searching branch types for: $query');
      final results = await _branchTypeDao.searchBranchTypes('%$query%');
      print('✅ Found ${results.length} results');
      return results;
    } catch (e) {
      print('❌ Error searching branch types: $e');
      return [];
    }
  }

  Future<BranchTypeEntity?> getBranchTypeByServerId(int serverId) async {
    try {
      return await _branchTypeDao.getBranchTypeByServerId(serverId);
    } catch (e) {
      print('❌ Error getting branch type by server ID: $e');
      return null;
    }
  }
}