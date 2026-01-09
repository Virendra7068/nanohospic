// lib/database/repository/doctor_commission_repository.dart
import 'dart:async';
import 'package:nanohospic/database/dao/doctor_commision_dao.dart';
import 'package:nanohospic/database/database_provider.dart';
import 'package:nanohospic/database/entity/doctor_commision_entity.dart';

class DoctorCommissionRepository {
  DoctorCommissionRepository(DoctorCommissionDao doctorCommissionDao);

  Future<DoctorCommissionDao> get _dao async {
    final database = await DatabaseProvider.database;
    return database.doctorCommissionDao;
  }

  Future<List<DoctorCommissionEntity>> getAllCommissions() async {
    final dao = await _dao;
    return dao.getAllCommissions();
  }

  Future<DoctorCommissionEntity?> getCommissionById(int id) async {
    final dao = await _dao;
    return dao.getCommissionById(id);
  }

  Future<DoctorCommissionEntity?> getCommissionByServerId(int serverId) async {
    final dao = await _dao;
    return dao.getCommissionByServerId(serverId);
  }

  Future<List<DoctorCommissionEntity>> getPendingSync() async {
    final dao = await _dao;
    return dao.getPendingSync();
  }

  Future<List<DoctorCommissionEntity>> getCommissionsByReferrer(int referrerId) async {
    final dao = await _dao;
    return dao.getCommissionsByReferrer(referrerId);
  }

  Future<List<DoctorCommissionEntity>> getCommissionsByStatus(String status) async {
    final dao = await _dao;
    return dao.getCommissionsByStatus(status);
  }

  Future<List<DoctorCommissionEntity>> getCommissionsByType(String commissionFor) async {
    final dao = await _dao;
    return dao.getCommissionsByType(commissionFor);
  }

  Future<int> insertCommission(DoctorCommissionEntity commission) async {
    final dao = await _dao;
    final now = DateTime.now().toIso8601String();
    
    final entity = DoctorCommissionEntity(
      doctorName: commission.doctorName,
      initials: commission.initials,
      contactNo: commission.contactNo,
      email: commission.email,
      workStation: commission.workStation,
      referrerId: commission.referrerId,
      referrerName: commission.referrerName,
      commissionFor: commission.commissionFor,
      commissionType: commission.commissionType,
      percentage: commission.percentage,
      value: commission.value,
      remarks: commission.remarks,
      status: commission.status,
      centerId: commission.centerId,
      centerName: commission.centerName,
      createdAt: now,
      createdBy: commission.createdBy ?? 'User',
      lastModified: now,
      lastModifiedBy: commission.lastModifiedBy ?? 'User',
      isSynced: false,
      syncStatus: 'pending',
    );

    return dao.insertCommission(entity);
  }

  Future<int> updateCommission(DoctorCommissionEntity commission) async {
    final dao = await _dao;
    final now = DateTime.now().toIso8601String();
    
    final entity = DoctorCommissionEntity(
      id: commission.id,
      serverId: commission.serverId,
      doctorName: commission.doctorName,
      initials: commission.initials,
      contactNo: commission.contactNo,
      email: commission.email,
      workStation: commission.workStation,
      referrerId: commission.referrerId,
      referrerName: commission.referrerName,
      commissionFor: commission.commissionFor,
      commissionType: commission.commissionType,
      percentage: commission.percentage,
      value: commission.value,
      remarks: commission.remarks,
      status: commission.status,
      centerId: commission.centerId,
      centerName: commission.centerName,
      createdAt: commission.createdAt,
      createdBy: commission.createdBy,
      lastModified: now,
      lastModifiedBy: commission.lastModifiedBy ?? 'User',
      isDeleted: commission.isDeleted,
      deletedBy: commission.deletedBy,
      isSynced: commission.isSynced,
      syncStatus: commission.syncStatus,
    );

    return dao.updateCommission(entity);
  }

  Future<int> softDeleteCommission(int id, String deletedBy) async {
    final dao = await _dao;
    final now = DateTime.now().toIso8601String();
    await dao.softDeleteCommission(id, deletedBy, now);
    return 1; // Return success indicator
  }

  Future<void> markAsSynced(int id) async {
    final dao = await _dao;
    await dao.markAsSynced(id);
  }

  Future<void> updateServerId(int id, int serverId) async {
    final dao = await _dao;
    await dao.updateServerId(id, serverId);
  }

  Future<void> markAsFailed(int id) async {
    final dao = await _dao;
    await dao.markAsFailed(id);
  }

  Future<int> getActiveCommissionCount() async {
    final dao = await _dao;
    final count = await dao.getActiveCommissionCount();
    return count ?? 0;
  }

  Future<int> getPendingSyncCount() async {
    final dao = await _dao;
    final count = await dao.getPendingSyncCount();
    return count ?? 0;
  }

  // Server sync methods
  Future<int?> addToServer(DoctorCommissionEntity commission) async {
    try {
      // TODO: Implement server API call
      // final response = await apiClient.post('/doctor-commissions', commission.toMap());
      // return response.data['id'];
      await Future.delayed(Duration(milliseconds: 500));
      return 1000 + (commission.id ?? 0); // Mock server ID
    } catch (e) {
      print('Error adding to server: $e');
      await markAsFailed(commission.id!);
      return null;
    }
  }

  Future<bool> updateOnServer(DoctorCommissionEntity commission) async {
    try {
      if (commission.serverId == null) return false;
      
      // TODO: Implement server API call
      // await apiClient.put('/doctor-commissions/${commission.serverId}', commission.toMap());
      await Future.delayed(Duration(milliseconds: 500));
      return true;
    } catch (e) {
      print('Error updating on server: $e');
      await markAsFailed(commission.id!);
      return false;
    }
  }

  Future<bool> deleteFromServer(int serverId) async {
    try {
      // TODO: Implement server API call
      // await apiClient.delete('/doctor-commissions/$serverId');
      await Future.delayed(Duration(milliseconds: 500));
      return true;
    } catch (e) {
      print('Error deleting from server: $e');
      return false;
    }
  }
}