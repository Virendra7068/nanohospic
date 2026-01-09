// lib/database/repository/collection_center_repo.dart

// ignore_for_file: avoid_print, depend_on_referenced_packages

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../dao/collection_center_dao.dart';
import '../entity/collection_center_entity.dart';

class CollectionCenterRepository {
  final CollectionCenterDao _collectionCenterDao;

  CollectionCenterRepository(this._collectionCenterDao);

  Future<List<CollectionCenterEntity>> getAllCollectionCenters() async {
    try {
      print('📋 Fetching all collection centers from database...');
      final centers = await _collectionCenterDao.getAllCollectionCenters();
      print('✅ Found ${centers.length} collection centers');
      return centers;
    } catch (e) {
      print('❌ Error fetching collection centers: $e');
      rethrow;
    }
  }

  Future<int> insertCollectionCenter(CollectionCenterEntity center) async {
    try {
      print('💾 Inserting collection center: ${center.centerName}');
      final result = await _collectionCenterDao.insertCollectionCenter(center);
      print('✅ Collection center inserted with ID: $result');
      return result;
    } catch (e) {
      print('❌ Error inserting collection center: $e');
      rethrow;
    }
  }

  Future<void> updateCollectionCenter(CollectionCenterEntity center) async {
    try {
      print('🔄 Updating collection center: ${center.centerName} (ID: ${center.id})');
      await _collectionCenterDao.updateCollectionCenter(center);
      print('✅ Collection center updated successfully');
    } catch (e) {
      print('❌ Error updating collection center: $e');
      rethrow;
    }
  }

  Future<void> deleteCollectionCenter(int id) async {
    try {
      print('🗑️ Deleting collection center with ID: $id');
      await _collectionCenterDao.deleteCollectionCenter(id);
      print('✅ Collection center deleted successfully');
    } catch (e) {
      print('❌ Error deleting collection center: $e');
      rethrow;
    }
  }

  Future<void> softDeleteCollectionCenter(int id, String deletedBy) async {
    try {
      print('🗑️ Soft deleting collection center with ID: $id');
      await _collectionCenterDao.softDeleteCollectionCenter(
        id,
        deletedBy,
        DateTime.now().toIso8601String(),
      );
      print('✅ Collection center soft deleted successfully');
    } catch (e) {
      print('❌ Error soft deleting collection center: $e');
      rethrow;
    }
  }

  Future<int> getTotalCount() async {
    try {
      final count = await _collectionCenterDao.getTotalCount();
      return count ?? 0;
    } catch (e) {
      print('❌ Error getting total count: $e');
      return 0;
    }
  }

  Future<int> getSyncedCount() async {
    try {
      final count = await _collectionCenterDao.getSyncedCount();
      return count ?? 0;
    } catch (e) {
      print('❌ Error getting synced count: $e');
      return 0;
    }
  }

  Future<int> getPendingCount() async {
    try {
      final count = await _collectionCenterDao.getPendingCount();
      return count ?? 0;
    } catch (e) {
      print('❌ Error getting pending count: $e');
      return 0;
    }
  }

  Future<List<CollectionCenterEntity>> getPendingSync() async {
    try {
      return await _collectionCenterDao.getPendingSync();
    } catch (e) {
      print('❌ Error getting pending sync: $e');
      return [];
    }
  }

  Future<void> markAsSynced(int id) async {
    try {
      await _collectionCenterDao.markAsSynced(id);
    } catch (e) {
      print('❌ Error marking as synced: $e');
    }
  }

  Future<void> updateServerId(int id, int serverId) async {
    try {
      await _collectionCenterDao.updateServerId(id, serverId);
    } catch (e) {
      print('❌ Error updating server ID: $e');
    }
  }

  Future<void> updateSyncError(int id, String error) async {
    try {
      await _collectionCenterDao.updateSyncError(id, error);
    } catch (e) {
      print('❌ Error updating sync error: $e');
    }
  }

  Future<List<CollectionCenterEntity>> searchCollectionCenters(String query) async {
    try {
      print('🔍 Searching collection centers for: $query');
      final results = await _collectionCenterDao.searchCollectionCenters('%$query%');
      print('✅ Found ${results.length} results');
      return results;
    } catch (e) {
      print('❌ Error searching collection centers: $e');
      return [];
    }
  }

  Future<CollectionCenterEntity?> getCollectionCenterByServerId(int serverId) async {
    try {
      return await _collectionCenterDao.getCollectionCenterByServerId(serverId);
    } catch (e) {
      print('❌ Error getting collection center by server ID: $e');
      return null;
    }
  }

  Future<List<String>> getDistinctCountries() async {
    try {
      return await _collectionCenterDao.getDistinctCountries();
    } catch (e) {
      print('❌ Error getting distinct countries: $e');
      return [];
    }
  }

  Future<List<String>> getDistinctStates() async {
    try {
      return await _collectionCenterDao.getDistinctStates();
    } catch (e) {
      print('❌ Error getting distinct states: $e');
      return [];
    }
  }

  Future<List<String>> getDistinctCities() async {
    try {
      return await _collectionCenterDao.getDistinctCities();
    } catch (e) {
      print('❌ Error getting distinct cities: $e');
      return [];
    }
  }

  Future<List<String>> getDistinctCentreStatus() async {
    try {
      return await _collectionCenterDao.getDistinctCentreStatus();
    } catch (e) {
      print('❌ Error getting distinct centre status: $e');
      return [];
    }
  }

  Future<List<String>> getDistinctTransportModes() async {
    try {
      return await _collectionCenterDao.getDistinctTransportModes();
    } catch (e) {
      print('❌ Error getting distinct transport modes: $e');
      return [];
    }
  }

  Future<List<String>> getDistinctCommissionTypes() async {
    try {
      return await _collectionCenterDao.getDistinctCommissionTypes();
    } catch (e) {
      print('❌ Error getting distinct commission types: $e');
      return [];
    }
  }

  Future<List<CollectionCenterEntity>> getActiveCollectionCenters() async {
    try {
      return await _collectionCenterDao.getActiveCollectionCenters();
    } catch (e) {
      print('❌ Error getting active collection centers: $e');
      return [];
    }
  }

  Future<List<CollectionCenterEntity>> getInactiveCollectionCenters() async {
    try {
      return await _collectionCenterDao.getInactiveCollectionCenters();
    } catch (e) {
      print('❌ Error getting inactive collection centers: $e');
      return [];
    }
  }

  Future<void> syncFromServer(List<Map<String, dynamic>> centersList) async {
    try {
      print('🔄 Syncing ${centersList.length} collection centers from server...');
      
      final entities = centersList.map((centerData) {
        return CollectionCenterEntity(
          serverId: centerData['id'] ?? centerData['Id'],
          centerCode: centerData['centerCode'] ?? centerData['CenterCode'] ?? '',
          centerName: centerData['centerName'] ?? centerData['CenterName'] ?? '',
          country: centerData['country'] ?? centerData['Country'] ?? '',
          state: centerData['state'] ?? centerData['State'] ?? '',
          city: centerData['city'] ?? centerData['City'] ?? '',
          address1: centerData['address1'] ?? centerData['Address1'] ?? '',
          address2: centerData['address2'] ?? centerData['Address2'] ?? '',
          location: centerData['location'] ?? centerData['Location'] ?? '',
          postalCode: centerData['postalCode']?.toString() ?? centerData['PostalCode']?.toString() ?? '',
          latitude: (centerData['latitude'] as num?)?.toDouble() ?? 0.0,
          longitude: (centerData['longitude'] as num?)?.toDouble() ?? 0.0,
          gstNumber: centerData['gstNumber'] ?? centerData['GstNumber'] ?? '',
          panNumber: centerData['panNumber'] ?? centerData['PanNumber'] ?? '',
          contactPersonName: centerData['contactPersonName'] ?? centerData['ContactPersonName'] ?? '',
          phoneNo: centerData['phoneNo'] ?? centerData['PhoneNo'] ?? '',
          email: centerData['email'] ?? centerData['Email'] ?? '',
          centreStatus: centerData['centreStatus'] ?? centerData['CentreStatus'] ?? '',
          branchTypeId: centerData['branchTypeId'] ?? centerData['BranchTypeId'],
          labAffiliationCompany: centerData['labAffiliationCompany'] ?? centerData['LabAffiliationCompany'] ?? '',
          operationalHoursFrom: centerData['operationalHoursFrom'] ?? centerData['OperationalHoursFrom'] ?? '',
          operationalHoursTo: centerData['operationalHoursTo'] ?? centerData['OperationalHoursTo'] ?? '',
          collectionDays: centerData['collectionDays'] ?? centerData['CollectionDays'] ?? '',
          samplePickupTimingFrom: centerData['samplePickupTimingFrom'] ?? centerData['SamplePickupTimingFrom'] ?? '',
          samplePickupTimingTo: centerData['samplePickupTimingTo'] ?? centerData['SamplePickupTimingTo'] ?? '',
          transportMode: centerData['transportMode'] ?? centerData['TransportMode'] ?? '',
          courierAgencyName: centerData['courierAgencyName'] ?? centerData['CourierAgencyName'] ?? '',
          commissionType: centerData['commissionType'] ?? centerData['CommissionType'] ?? '',
          commissionValue: (centerData['commissionValue'] as num?)?.toDouble() ?? 0.0,
          accountHolderName: centerData['accountHolderName'] ?? centerData['AccountHolderName'] ?? '',
          accountNo: centerData['accountNo'] ?? centerData['AccountNo'] ?? '',
          ifscCode: centerData['ifscCode'] ?? centerData['IfscCode'] ?? '',
          agreementFile1Path: centerData['agreementFile1Path'] ?? centerData['AgreementFile1Path'],
          agreementFile2Path: centerData['agreementFile2Path'] ?? centerData['AgreementFile2Path'],
          createdAt: centerData['createdAt']?.toString() ?? 
                   centerData['created_at']?.toString() ??
                   DateTime.now().toIso8601String(),
          createdBy: centerData['createdBy']?.toString() ?? centerData['created_by']?.toString(),
          lastModified: centerData['lastModified']?.toString() ?? centerData['last_modified']?.toString(),
          lastModifiedBy: centerData['lastModifiedBy']?.toString() ?? centerData['last_modified_by']?.toString(),
          isDeleted: (centerData['isDeleted'] ?? centerData['is_deleted'] ?? 0) as int,
          deletedBy: centerData['deletedBy']?.toString() ?? centerData['deleted_by']?.toString(),
          isSynced: 1,
          syncStatus: 'synced',
        );
      }).toList();

      print('💾 Saving ${entities.length} collection center entities to local database...');
      await _collectionCenterDao.insertCollectionCenterList(entities);
      print('✅ Collection center sync completed successfully');
    } catch (e) {
      print('❌ Error syncing collection centers from server: $e');
      rethrow;
    }
  }

  Future<int?> addToServer(CollectionCenterEntity center) async {
    try {
      print('☁️ Adding collection center to server: ${center.centerName}');
      
      final response = await http.post(
        Uri.parse('http://202.140.138.215:85/api/CollectionCenterApi'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'id': 0,
          'centerCode': center.centerCode,
          'centerName': center.centerName,
          'country': center.country,
          'state': center.state,
          'city': center.city,
          'address1': center.address1,
          'address2': center.address2,
          'location': center.location,
          'postalCode': center.postalCode,
          'latitude': center.latitude,
          'longitude': center.longitude,
          'gstNumber': center.gstNumber,
          'panNumber': center.panNumber,
          'contactPersonName': center.contactPersonName,
          'phoneNo': center.phoneNo,
          'email': center.email,
          'centreStatus': center.centreStatus,
          'branchTypeId': center.branchTypeId,
          'labAffiliationCompany': center.labAffiliationCompany,
          'operationalHoursFrom': center.operationalHoursFrom,
          'operationalHoursTo': center.operationalHoursTo,
          'collectionDays': center.collectionDays,
          'samplePickupTimingFrom': center.samplePickupTimingFrom,
          'samplePickupTimingTo': center.samplePickupTimingTo,
          'transportMode': center.transportMode,
          'courierAgencyName': center.courierAgencyName,
          'commissionType': center.commissionType,
          'commissionValue': center.commissionValue,
          'accountHolderName': center.accountHolderName,
          'accountNo': center.accountNo,
          'ifscCode': center.ifscCode,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        print('✅ Collection center added to server with response: $data');
        return data['id'] as int?;
      } else {
        print('❌ Server error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('❌ Error adding collection center to server: $e');
      return null;
    }
  }

  Future<bool> updateOnServer(CollectionCenterEntity center) async {
    try {
      if (center.serverId == null) {
        print('⚠️ Cannot update on server: serverId is null');
        return false;
      }

      print('☁️ Updating collection center on server: ${center.centerName} (ID: ${center.serverId})');
      
      final response = await http.put(
        Uri.parse('http://202.140.138.215:85/api/CollectionCenterApi/${center.serverId}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'id': center.serverId,
          'centerCode': center.centerCode,
          'centerName': center.centerName,
          'country': center.country,
          'state': center.state,
          'city': center.city,
          'address1': center.address1,
          'address2': center.address2,
          'location': center.location,
          'postalCode': center.postalCode,
          'latitude': center.latitude,
          'longitude': center.longitude,
          'gstNumber': center.gstNumber,
          'panNumber': center.panNumber,
          'contactPersonName': center.contactPersonName,
          'phoneNo': center.phoneNo,
          'email': center.email,
          'centreStatus': center.centreStatus,
          'branchTypeId': center.branchTypeId,
          'labAffiliationCompany': center.labAffiliationCompany,
          'operationalHoursFrom': center.operationalHoursFrom,
          'operationalHoursTo': center.operationalHoursTo,
          'collectionDays': center.collectionDays,
          'samplePickupTimingFrom': center.samplePickupTimingFrom,
          'samplePickupTimingTo': center.samplePickupTimingTo,
          'transportMode': center.transportMode,
          'courierAgencyName': center.courierAgencyName,
          'commissionType': center.commissionType,
          'commissionValue': center.commissionValue,
          'accountHolderName': center.accountHolderName,
          'accountNo': center.accountNo,
          'ifscCode': center.ifscCode,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        print('✅ Collection center updated on server successfully');
        return true;
      } else {
        print('❌ Server error: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('❌ Error updating collection center on server: $e');
      return false;
    }
  }

  Future<bool> deleteFromServer(int serverId) async {
    try {
      print('☁️ Deleting collection center from server: ID $serverId');
      
      final response = await http.delete(
        Uri.parse('http://202.140.138.215:85/api/CollectionCenterApi/$serverId'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200 || response.statusCode == 204) {
        print('✅ Collection center deleted from server successfully');
        return true;
      } else {
        print('❌ Server error: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('❌ Error deleting collection center from server: $e');
      return false;
    }
  }

  Future<CollectionCenterEntity?> getCollectionCenterById(int id) async {
    try {
      return await _collectionCenterDao.getCollectionCenterById(id);
    } catch (e) {
      print('❌ Error getting collection center by ID: $e');
      return null;
    }
  }
}