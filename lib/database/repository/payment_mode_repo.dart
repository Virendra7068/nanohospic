// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nanohospic/database/dao/payment_mode_dao.dart';
import 'package:nanohospic/database/entity/payment_mode_entity.dart';

class PaymentModeRepository {
  final PaymentModeDao _paymentModeDao;

  PaymentModeRepository(this._paymentModeDao);

  Future<List<PaymentModeEntity>> getAllPaymentModes() async {
    try {
      print('📋 Fetching all payment modes from database...');
      final paymentModes = await _paymentModeDao.getAllPaymentModes();
      print('✅ Found ${paymentModes.length} payment modes');
      return paymentModes;
    } catch (e) {
      print('❌ Error fetching payment modes: $e');
      rethrow;
    }
  }

  Future<int> insertPaymentMode(PaymentModeEntity paymentMode) async {
    try {
      print('💾 Inserting payment mode: ${paymentMode.name}');
      final result = await _paymentModeDao.insertPaymentModeList([paymentMode]);
      print('✅ Payment mode inserted with IDs: $result');
      return result.first;
    } catch (e) {
      print('❌ Error inserting payment mode: $e');
      rethrow;
    }
  }

  Future<void> updatePaymentMode(PaymentModeEntity paymentMode) async {
    try {
      print('🔄 Updating payment mode: ${paymentMode.name} (ID: ${paymentMode.id})');
      await _paymentModeDao.updatePaymentMode(paymentMode);
      print('✅ Payment mode updated successfully');
    } catch (e) {
      print('❌ Error updating payment mode: $e');
      rethrow;
    }
  }

  Future<void> deletePaymentMode(int id) async {
    try {
      print('🗑️ Deleting payment mode with ID: $id');
      await _paymentModeDao.deletePaymentMode(id);
      print('✅ Payment mode deleted successfully');
    } catch (e) {
      print('❌ Error deleting payment mode: $e');
      rethrow;
    }
  }

  Future<void> softDeletePaymentMode(int id, String deletedBy) async {
    try {
      print('🗑️ Soft deleting payment mode with ID: $id');
      await _paymentModeDao.softDeletePaymentMode(
        id,
        deletedBy,
        DateTime.now().toIso8601String(),
      );
      print('✅ Payment mode soft deleted successfully');
    } catch (e) {
      print('❌ Error soft deleting payment mode: $e');
      rethrow;
    }
  }

  Future<int> getTotalCount() async {
    try {
      final count = await _paymentModeDao.getTotalCount();
      return count ?? 0;
    } catch (e) {
      print('❌ Error getting total count: $e');
      return 0;
    }
  }

  Future<int> getSyncedCount() async {
    try {
      final count = await _paymentModeDao.getSyncedCount();
      return count ?? 0;
    } catch (e) {
      print('❌ Error getting synced count: $e');
      return 0;
    }
  }

  Future<int> getPendingCount() async {
    try {
      final count = await _paymentModeDao.getPendingCount();
      return count ?? 0;
    } catch (e) {
      print('❌ Error getting pending count: $e');
      return 0;
    }
  }

  Future<List<PaymentModeEntity>> getPendingSync() async {
    try {
      return await _paymentModeDao.getPendingSync();
    } catch (e) {
      print('❌ Error getting pending sync: $e');
      return [];
    }
  }

  Future<void> markAsSynced(int id) async {
    try {
      await _paymentModeDao.markAsSynced(id);
    } catch (e) {
      print('❌ Error marking as synced: $e');
    }
  }

  Future<void> updateServerId(int id, int serverId) async {
    try {
      await _paymentModeDao.updateServerId(id, serverId);
    } catch (e) {
      print('❌ Error updating server ID: $e');
    }
  }

  Future<void> updateSyncError(int id, String error) async {
    try {
      await _paymentModeDao.updateSyncError(id, error);
    } catch (e) {
      print('❌ Error updating sync error: $e');
    }
  }

  Future<void> syncFromServer(List<Map<String, dynamic>> paymentModesList) async {
    try {
      print('🔄 Syncing ${paymentModesList.length} payment modes from server...');
      
      final entities = paymentModesList.map((modeData) {
        return PaymentModeEntity(
          serverId: modeData['id'] ?? modeData['Id'],
          name: modeData['name'] ?? modeData['Name'] ?? '',
          description: modeData['description'] ?? modeData['Description'],
          tenantId: modeData['tenantId'] ?? modeData['tenant_id'] ?? 'default_tenant',
          createdAt: modeData['created']?.toString() ?? 
                   modeData['createdAt']?.toString() ??
                   DateTime.now().toIso8601String(),
          createdBy: modeData['createdBy']?.toString() ?? modeData['created_by']?.toString(),
          lastModified: modeData['lastModified']?.toString() ?? modeData['last_modified']?.toString(),
          lastModifiedBy: modeData['lastModifiedBy']?.toString() ?? modeData['last_modified_by']?.toString(),
          isDeleted: (modeData['isDeleted'] ?? modeData['is_deleted'] ?? 0) as int,
          deletedBy: modeData['deletedBy']?.toString() ?? modeData['deleted_by']?.toString(),
          isSynced: 1,
          syncStatus: 'synced',
        );
      }).toList();

      print('💾 Saving ${entities.length} payment mode entities to local database...');
      await _paymentModeDao.insertPaymentModeList(entities);
      print('✅ Payment mode sync completed successfully');
    } catch (e) {
      print('❌ Error syncing payment modes from server: $e');
      rethrow;
    }
  }

  Future<int?> addToServer(PaymentModeEntity paymentMode) async {
    try {
      print('☁️ Adding payment mode to server: ${paymentMode.name}');
      
      final response = await http.post(
        Uri.parse('http://202.140.138.215:85/api/PaymentModeApi/Create'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'id': 0,
          'name': paymentMode.name,
          'description': paymentMode.description ?? '',
          'modeOfPayments': [
            {
              'id': 0,
              'name': paymentMode.name,
              'description': paymentMode.description ?? '',
              'tenantId': paymentMode.tenantId ?? 'default_tenant',
              'created': DateTime.now().toIso8601String(),
              'createdBy': paymentMode.createdBy ?? 'mobile_app',
              'lastModified': DateTime.now().toIso8601String(),
              'lastModifiedBy': paymentMode.createdBy ?? 'mobile_app',
              'deleted': null,
              'deletedBy': null,
            }
          ],
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        print('✅ Payment mode added to server with response: $data');
        return data['id'] as int?;
      } else {
        print('❌ Server error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('❌ Error adding payment mode to server: $e');
      return null;
    }
  }

  Future<bool> updateOnServer(PaymentModeEntity paymentMode) async {
    try {
      if (paymentMode.serverId == null) {
        print('⚠️ Cannot update on server: serverId is null');
        return false;
      }

      print('☁️ Updating payment mode on server: ${paymentMode.name} (ID: ${paymentMode.serverId})');
      
      final response = await http.put(
        Uri.parse('http://202.140.138.215:85/api/PaymentModeApi/${paymentMode.serverId}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'id': paymentMode.serverId,
          'name': paymentMode.name,
          'description': paymentMode.description ?? '',
          'modeOfPayments': [
            {
              'id': paymentMode.serverId,
              'name': paymentMode.name,
              'description': paymentMode.description ?? '',
              'tenantId': paymentMode.tenantId ?? 'default_tenant',
              'created': paymentMode.createdAt ?? DateTime.now().toIso8601String(),
              'createdBy': paymentMode.createdBy ?? 'mobile_app',
              'lastModified': DateTime.now().toIso8601String(),
              'lastModifiedBy': paymentMode.createdBy ?? 'mobile_app',
              'deleted': null,
              'deletedBy': null,
            }
          ],
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        print('✅ Payment mode updated on server successfully');
        return true;
      } else {
        print('❌ Server error: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('❌ Error updating payment mode on server: $e');
      return false;
    }
  }

  Future<bool> deleteFromServer(int serverId) async {
    try {
      print('☁️ Deleting payment mode from server: ID $serverId');
      
      final response = await http.post(
        Uri.parse('http://202.140.138.215:85/api/PaymentModeApi/Delete/$serverId'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        print('✅ Payment mode deleted from server successfully');
        return true;
      } else {
        print('❌ Server error: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('❌ Error deleting payment mode from server: $e');
      return false;
    }
  }

  Future<List<PaymentModeEntity>> searchPaymentModes(String query) async {
    try {
      print('🔍 Searching payment modes for: $query');
      final results = await _paymentModeDao.searchPaymentModes('%$query%');
      print('✅ Found ${results.length} results');
      return results;
    } catch (e) {
      print('❌ Error searching payment modes: $e');
      return [];
    }
  }

  Future<PaymentModeEntity?> getPaymentModeByServerId(int serverId) async {
    try {
      return await _paymentModeDao.getPaymentModeByServerId(serverId);
    } catch (e) {
      print('❌ Error getting payment mode by server ID: $e');
      return null;
    }
  }
}