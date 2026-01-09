// lib/database/repository/hsn_repository.dart
import 'dart:async';
import 'package:nanohospic/database/dao/hsn_dao.dart';
import 'package:nanohospic/database/entity/hsn_entity.dart';
import 'package:nanohospic/model/hsn_model.dart';

class HsnRepository {
  final HsnDao hsnDao;

  HsnRepository(this.hsnDao);

  // Get all HSN codes
  Future<List<HsnEntity>> getAllHsnCodes() async {
    return await hsnDao.getAllHsnCodes();
  }

  // Search HSN codes
  Future<List<HsnEntity>> searchHsnCodes(String query) async {
    return await hsnDao.searchHsnCodes('%$query%');
  }

  // Get HSN by server ID
  Future<HsnEntity?> getHsnByServerId(int serverId) async {
    return await hsnDao.getHsnByServerId(serverId);
  }

  // Get HSN by code
  Future<HsnEntity?> getHsnByCode(String hsnCode) async {
    return await hsnDao.getHsnByCode(hsnCode);
  }

  // Insert new HSN
  Future<int> insertHsn(HsnEntity hsn) async {
    try {
      // Check if HSN code already exists
      final existing = await getHsnByCode(hsn.hsnCode);
      if (existing != null && !existing.isDeleted) {
        throw Exception('HSN code ${hsn.hsnCode} already exists');
      }
      
      return await hsnDao.insertHsn(hsn);
    } catch (e) {
      rethrow;
    }
  }

  // Insert from model
  Future<int> insertFromModel(HsnModel model) async {
    final entity = HsnEntity.fromModel(model);
    return await insertHsn(entity);
  }

  // Update HSN
  Future<void> updateHsn(HsnEntity hsn) async {
    await hsnDao.updateHsn(hsn);
  }

  // Soft delete HSN
  Future<void> deleteHsn(int id) async {
    final timestamp = DateTime.now().toIso8601String();
    await hsnDao.softDelete(id, timestamp, 'User');
  }

  // Hard delete HSN (permanent)
  Future<void> hardDeleteHsn(int id) async {
    await hsnDao.deleteHsn(id);
  }

  // Sync from server
  Future<void> syncFromServer(List<Map<String, dynamic>> serverData) async {
    final batch = <HsnEntity>[];

    for (final item in serverData) {
      try {
        final entity = HsnEntity.fromServerJson(item);
        batch.add(entity);
      } catch (e) {
        print('Error parsing HSN item: $e');
      }
    }

    if (batch.isNotEmpty) {
      // First, mark all existing records as deleted (soft delete)
      final existing = await getAllHsnCodes();
      for (final hsn in existing) {
        if (!batch.any((b) => b.hsnCode == hsn.hsnCode)) {
          await hsnDao.softDelete(
            hsn.id!,
            DateTime.now().toIso8601String(),
            'Sync',
          );
        }
      }

      // Then insert/update new records
      for (final hsn in batch) {
        final existing = await hsnDao.getHsnByCode(hsn.hsnCode);
        if (existing != null) {
          // Update existing
          final updatedHsn = existing.copyWith(
            serverId: hsn.serverId,
            sgst: hsn.sgst,
            cgst: hsn.cgst,
            igst: hsn.igst,
            cess: hsn.cess,
            hsnType: hsn.hsnType,
            tenant: hsn.tenant,
            tenantId: hsn.tenantId,
            lastModified: DateTime.now().toIso8601String(),
            lastModifiedBy: 'Sync',
            isSynced: true,
          );
          await hsnDao.updateHsn(updatedHsn);
        } else {
          await hsnDao.insertHsn(hsn);
        }
      }
    }
  }

  Future<List<HsnEntity>> getPendingSync() async {
    return await hsnDao.getPendingSync();
  }

  Future<void> markAsSynced(int id) async {
    await hsnDao.markAsSynced(id);
  }

  Future<void> markAsFailed(int id, String error) async {
    await hsnDao.markAsFailed(id, error);
  }

  Future<Map<String, int>> getSyncStats() async {
    final total = await hsnDao.getTotalCount() ?? 0;
    final synced = await hsnDao.getSyncedCount() ?? 0;
    final pending = await hsnDao.getPendingCount() ?? 0;

    return {
      'total': total,
      'synced': synced,
      'pending': pending,
    };
  }

  // Clear all data
  Future<void> clearAll() async {
    await hsnDao.deleteAll();
  }

  // Bulk insert from server
  Future<void> bulkInsertFromServer(List<HsnModel> models) async {
    final entities = models.map((model) => HsnEntity.fromModel(model)).toList();
    await hsnDao.insertMultipleHsn(entities);
  }

  // Get HSN types
  Future<List<int?>> getHsnTypes() async {
    return await hsnDao.getHsnTypes();
  }

  // Get HSN since date
  Future<List<HsnEntity>> getHsnSinceDate(DateTime date) async {
    return await hsnDao.getHsnSinceDate(date.toIso8601String());
  }
}