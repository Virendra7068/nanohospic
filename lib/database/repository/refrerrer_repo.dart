// lib/database/repository/referrer_repo.dart

// ignore_for_file: avoid_print, depend_on_referenced_packages

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../dao/referrer_dao.dart';
import '../entity/referrer_entity.dart';

class ReferrerRepository {
  final ReferrerDao _referrerDao;

  ReferrerRepository(this._referrerDao);

  Future<List<ReferrerEntity>> getAllReferrers() async {
    try {
      print('📋 Fetching all referrers from database...');
      final referrers = await _referrerDao.getAllReferrers();
      print('✅ Found ${referrers.length} referrers');
      return referrers;
    } catch (e) {
      print('❌ Error fetching referrers: $e');
      rethrow;
    }
  }

  Future<int> insertReferrer(ReferrerEntity referrer) async {
    try {
      print('💾 Inserting referrer: ${referrer.name}');
      final result = await _referrerDao.insertReferrer(referrer);
      print('✅ Referrer inserted with ID: $result');
      return result;
    } catch (e) {
      print('❌ Error inserting referrer: $e');
      rethrow;
    }
  }

  Future<void> updateReferrer(ReferrerEntity referrer) async {
    try {
      print('🔄 Updating referrer: ${referrer.name} (ID: ${referrer.id})');
      await _referrerDao.updateReferrer(referrer);
      print('✅ Referrer updated successfully');
    } catch (e) {
      print('❌ Error updating referrer: $e');
      rethrow;
    }
  }

  Future<void> deleteReferrer(int id) async {
    try {
      print('🗑️ Deleting referrer with ID: $id');
      await _referrerDao.deleteReferrer(id);
      print('✅ Referrer deleted successfully');
    } catch (e) {
      print('❌ Error deleting referrer: $e');
      rethrow;
    }
  }

  Future<void> softDeleteReferrer(int id, String deletedBy) async {
    try {
      print('🗑️ Soft deleting referrer with ID: $id');
      await _referrerDao.softDeleteReferrer(
        id,
        deletedBy,
        DateTime.now().toIso8601String(),
      );
      print('✅ Referrer soft deleted successfully');
    } catch (e) {
      print('❌ Error soft deleting referrer: $e');
      rethrow;
    }
  }

  Future<int> getTotalCount() async {
    try {
      final count = await _referrerDao.getTotalCount();
      return count ?? 0;
    } catch (e) {
      print('❌ Error getting total count: $e');
      return 0;
    }
  }

  Future<int> getSyncedCount() async {
    try {
      final count = await _referrerDao.getSyncedCount();
      return count ?? 0;
    } catch (e) {
      print('❌ Error getting synced count: $e');
      return 0;
    }
  }

  Future<int> getPendingCount() async {
    try {
      final count = await _referrerDao.getPendingCount();
      return count ?? 0;
    } catch (e) {
      print('❌ Error getting pending count: $e');
      return 0;
    }
  }

  Future<List<ReferrerEntity>> getPendingSync() async {
    try {
      return await _referrerDao.getPendingSync();
    } catch (e) {
      print('❌ Error getting pending sync: $e');
      return [];
    }
  }

  Future<void> markAsSynced(int id) async {
    try {
      await _referrerDao.markAsSynced(id);
    } catch (e) {
      print('❌ Error marking as synced: $e');
    }
  }

  Future<void> updateServerId(int id, int serverId) async {
    try {
      await _referrerDao.updateServerId(id, serverId);
    } catch (e) {
      print('❌ Error updating server ID: $e');
    }
  }

  Future<void> updateSyncError(int id, String error) async {
    try {
      await _referrerDao.updateSyncError(id, error);
    } catch (e) {
      print('❌ Error updating sync error: $e');
    }
  }

  Future<List<ReferrerEntity>> searchReferrers(String query) async {
    try {
      print('🔍 Searching referrers for: $query');
      final results = await _referrerDao.searchReferrers('%$query%');
      print('✅ Found ${results.length} results');
      return results;
    } catch (e) {
      print('❌ Error searching referrers: $e');
      return [];
    }
  }

  Future<ReferrerEntity?> getReferrerByServerId(int serverId) async {
    try {
      return await _referrerDao.getReferrerByServerId(serverId);
    } catch (e) {
      print('❌ Error getting referrer by server ID: $e');
      return null;
    }
  }

  Future<List<String>> getDistinctSpecializations() async {
    try {
      return await _referrerDao.getDistinctSpecializations();
    } catch (e) {
      print('❌ Error getting distinct specializations: $e');
      return [];
    }
  }

  Future<List<String>> getDistinctDegrees() async {
    try {
      return await _referrerDao.getDistinctDegrees();
    } catch (e) {
      print('❌ Error getting distinct degrees: $e');
      return [];
    }
  }

  Future<List<String>> getDistinctTagStatus() async {
    try {
      return await _referrerDao.getDistinctTagStatus();
    } catch (e) {
      print('❌ Error getting distinct tag status: $e');
      return [];
    }
  }

  Future<List<String>> getDistinctCenters() async {
    try {
      return await _referrerDao.getDistinctCenters();
    } catch (e) {
      print('❌ Error getting distinct centers: $e');
      return [];
    }
  }

  Future<List<ReferrerEntity>> getTaggedReferrers() async {
    try {
      return await _referrerDao.getTaggedReferrers();
    } catch (e) {
      print('❌ Error getting tagged referrers: $e');
      return [];
    }
  }

  Future<List<ReferrerEntity>> getUntaggedReferrers() async {
    try {
      return await _referrerDao.getUntaggedReferrers();
    } catch (e) {
      print('❌ Error getting untagged referrers: $e');
      return [];
    }
  }

  Future<List<ReferrerEntity>> getReferrersByCenter(String centerName) async {
    try {
      return await _referrerDao.getReferrersByCenter(centerName);
    } catch (e) {
      print('❌ Error getting referrers by center: $e');
      return [];
    }
  }

  Future<void> syncFromServer(List<Map<String, dynamic>> referrersList) async {
    try {
      print('🔄 Syncing ${referrersList.length} referrers from server...');
      
      final entities = referrersList.map((referrerData) {
        return ReferrerEntity(
          serverId: referrerData['id'] ?? referrerData['Id'],
          name: referrerData['name'] ?? referrerData['Name'] ?? '',
          dob: referrerData['dob']?.toString() ?? referrerData['Dob']?.toString() ?? '',
          marriageAnniversary: referrerData['marriageAnniversary']?.toString() ?? referrerData['MarriageAnniversary']?.toString() ?? '',
          workStation: referrerData['workStation'] ?? referrerData['WorkStation'] ?? '',
          clinicAddress: referrerData['clinicAddress'] ?? referrerData['ClinicAddress'] ?? '',
          clinicPhone: referrerData['clinicPhone'] ?? referrerData['ClinicPhone'] ?? '',
          hospitalName: referrerData['hospitalName'] ?? referrerData['HospitalName'] ?? '',
          hospitalAddress: referrerData['hospitalAddress'] ?? referrerData['HospitalAddress'] ?? '',
          hospitalPhone: referrerData['hospitalPhone'] ?? referrerData['HospitalPhone'] ?? '',
          email: referrerData['email'] ?? referrerData['Email'] ?? '',
          contactNo: referrerData['contactNo'] ?? referrerData['ContactNo'] ?? '',
          specialization: referrerData['specialization'] ?? referrerData['Specialization'] ?? '',
          remarks: referrerData['remarks'] ?? referrerData['Remarks'] ?? '',
          registrationNo: referrerData['registrationNo'] ?? referrerData['RegistrationNo'] ?? '',
          degree: referrerData['degree'] ?? referrerData['Degree'] ?? '',
          tagStatus: referrerData['tagStatus'] ?? referrerData['TagStatus'] ?? '',
          centerId: referrerData['centerId'] ?? referrerData['CenterId'],
          centerName: referrerData['centerName'] ?? referrerData['CenterName'] ?? '',
          createdAt: referrerData['createdAt']?.toString() ?? 
                   referrerData['created_at']?.toString() ??
                   DateTime.now().toIso8601String(),
          createdBy: referrerData['createdBy']?.toString() ?? referrerData['created_by']?.toString(),
          lastModified: referrerData['lastModified']?.toString() ?? referrerData['last_modified']?.toString(),
          lastModifiedBy: referrerData['lastModifiedBy']?.toString() ?? referrerData['last_modified_by']?.toString(),
          isDeleted: (referrerData['isDeleted'] ?? referrerData['is_deleted'] ?? 0) as int,
          deletedBy: referrerData['deletedBy']?.toString() ?? referrerData['deleted_by']?.toString(),
          isSynced: 1,
          syncStatus: 'synced',
        );
      }).toList();

      print('💾 Saving ${entities.length} referrer entities to local database...');
      await _referrerDao.insertReferrerList(entities);
      print('✅ Referrer sync completed successfully');
    } catch (e) {
      print('❌ Error syncing referrers from server: $e');
      rethrow;
    }
  }

  Future<int?> addToServer(ReferrerEntity referrer) async {
    try {
      print('☁️ Adding referrer to server: ${referrer.name}');
      
      final response = await http.post(
        Uri.parse('http://202.140.138.215:85/api/ReferrerApi'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'id': 0,
          'name': referrer.name,
          'dob': referrer.dob,
          'marriageAnniversary': referrer.marriageAnniversary,
          'workStation': referrer.workStation,
          'clinicAddress': referrer.clinicAddress,
          'clinicPhone': referrer.clinicPhone,
          'hospitalName': referrer.hospitalName,
          'hospitalAddress': referrer.hospitalAddress,
          'hospitalPhone': referrer.hospitalPhone,
          'email': referrer.email,
          'contactNo': referrer.contactNo,
          'specialization': referrer.specialization,
          'remarks': referrer.remarks,
          'registrationNo': referrer.registrationNo,
          'degree': referrer.degree,
          'tagStatus': referrer.tagStatus,
          'centerId': referrer.centerId,
          'centerName': referrer.centerName,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        print('✅ Referrer added to server with response: $data');
        return data['id'] as int?;
      } else {
        print('❌ Server error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('❌ Error adding referrer to server: $e');
      return null;
    }
  }

  Future<bool> updateOnServer(ReferrerEntity referrer) async {
    try {
      if (referrer.serverId == null) {
        print('⚠️ Cannot update on server: serverId is null');
        return false;
      }

      print('☁️ Updating referrer on server: ${referrer.name} (ID: ${referrer.serverId})');
      
      final response = await http.put(
        Uri.parse('http://202.140.138.215:85/api/ReferrerApi/${referrer.serverId}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'id': referrer.serverId,
          'name': referrer.name,
          'dob': referrer.dob,
          'marriageAnniversary': referrer.marriageAnniversary,
          'workStation': referrer.workStation,
          'clinicAddress': referrer.clinicAddress,
          'clinicPhone': referrer.clinicPhone,
          'hospitalName': referrer.hospitalName,
          'hospitalAddress': referrer.hospitalAddress,
          'hospitalPhone': referrer.hospitalPhone,
          'email': referrer.email,
          'contactNo': referrer.contactNo,
          'specialization': referrer.specialization,
          'remarks': referrer.remarks,
          'registrationNo': referrer.registrationNo,
          'degree': referrer.degree,
          'tagStatus': referrer.tagStatus,
          'centerId': referrer.centerId,
          'centerName': referrer.centerName,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        print('✅ Referrer updated on server successfully');
        return true;
      } else {
        print('❌ Server error: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('❌ Error updating referrer on server: $e');
      return false;
    }
  }

  Future<bool> deleteFromServer(int serverId) async {
    try {
      print('☁️ Deleting referrer from server: ID $serverId');
      
      final response = await http.delete(
        Uri.parse('http://202.140.138.215:85/api/ReferrerApi/$serverId'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200 || response.statusCode == 204) {
        print('✅ Referrer deleted from server successfully');
        return true;
      } else {
        print('❌ Server error: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('❌ Error deleting referrer from server: $e');
      return false;
    }
  }

  Future<ReferrerEntity?> getReferrerById(int id) async {
    try {
      return await _referrerDao.getReferrerById(id);
    } catch (e) {
      print('❌ Error getting referrer by ID: $e');
      return null;
    }
  }
}