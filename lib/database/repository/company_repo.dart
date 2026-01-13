// // lib/data/repository/company_repository.dart
// import 'dart:async';
// import 'package:nanohospic/database/app_database.dart';
// import 'package:nanohospic/database/entity/company_entity.dart';
// import 'package:nanohospic/database/sync_service/company_sync_services.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';

// class CompanyRepository {
//   final AppDatabase database;
//   final SyncService syncService;
//   final Connectivity _connectivity = Connectivity();

//   CompanyRepository({
//     required this.database,
//     required this.syncService,
//   });

//   // Start auto sync
//   Future<void> startAutoSync() async {
//     await syncService.startAutoSync();
//   }

//   // Stop auto sync
//   void stopAutoSync() {
//     syncService.stopAutoSync();
//   }

//   // Get all companies (local + sync status)
//   Future<List<CompanyEntity>> getAllCompanies() async {
//     return database.companyDao.getAllCompanies();
//   }

//   // Search companies
//   Future<List<CompanyEntity>> searchCompanies(String query) async {
//     if (query.isEmpty) {
//       return getAllCompanies();
//     }
//     return database.companyDao.searchCompanies('%$query%');
//   }

//   // Create new company
//   Future<CompanyEntity> createCompany(CompanyEntity company) async {
//     final now = DateTime.now();
//     final companyWithTimestamps = company.copyWith(
//       createdAt: now,
//       lastModified: now,
//       isSynced: false,
//     );

//     final id = await database.companyDao.insertCompany(companyWithTimestamps);

//     // Check connectivity and sync if available
//     final connectivityResult = await _connectivity.checkConnectivity();
//     if (connectivityResult != ConnectivityResult.none) {
//       await syncService.manualSync();
//     }

//     return companyWithTimestamps.copyWith(id: id);
//   }

//   // Update company
//   Future<void> updateCompany(CompanyEntity company) async {
//     final updatedCompany = company.copyWith(
//       lastModified: DateTime.now(),
//       isSynced: false,
//     );

//     await database.companyDao.updateCompany(updatedCompany);

//     // Check connectivity and sync if available
//     final connectivityResult = await _connectivity.checkConnectivity();
//     if (connectivityResult != ConnectivityResult.none) {
//       await syncService.manualSync();
//     }
//   }

//   // Delete company (soft delete)
//   Future<void> deleteCompany(int id) async {
//     final now = DateTime.now();
//     await database.companyDao.markAsDeleted(id, now);
//     // Check connectivity and sync if available
//     final connectivityResult = await _connectivity.checkConnectivity();
//     if (connectivityResult != ConnectivityResult.none) {
//       await syncService.manualSync();
//     }
//   }

//   // Get unsynced companies count
//   Future<int> getUnsyncedCount() async {
//     final unsynced = await database.companyDao.getUnsyncedCompanies();
//     return unsynced.length;
//   }

//   // Manual sync
//   Future<void> manualSync() async {
//     await syncService.manualSync();
//   }

//   // Sync status stream
//   Stream<SyncStatus> get syncStatusStream => syncService.syncStatusStream;

//   // Dispose resources
//   void dispose() {
//     syncService.dispose();
//   }
// }

import 'package:nanohospic/database/dao/company_dao.dart';
import 'package:nanohospic/database/entity/company_entity.dart';

class CompanyRepository {
  final CompanyDao _companyDao;

  CompanyRepository(this._companyDao);

  Future<List<CompanyEntity>> getAllCompanies() async {
    return await _companyDao.getAllCompanies();
  }

  Future<CompanyEntity?> getCompanyById(int id) async {
    return await _companyDao.getCompanyById(id);
  }

  Future<CompanyEntity?> getCompanyByServerId(int serverId) async {
    return await _companyDao.getCompanyByServerId(serverId);
  }

  Future<int> getTotalCount() async {
    return await _companyDao.getTotalCount();
  }

  Future<int> getSyncedCount() async {
    return await _companyDao.getSyncedCount();
  }

  Future<int> getPendingCount() async {
    return await _companyDao.getPendingCount();
  }

  Future<List<CompanyEntity>> getPendingSync() async {
    return await _companyDao.getPendingSync();
  }

  Future<List<CompanyEntity>> searchCompanies(String query) async {
    return await _companyDao.searchCompanies('%$query%');
  }

  Future<void> insertCompany(CompanyEntity company) async {
    await _companyDao.insertCompany(company);
  }

  Future<void> updateCompany(CompanyEntity company) async {
    await _companyDao.updateCompany(company);
  }

  Future<void> deleteCompany(int id) async {
    await _companyDao.softDeleteCompany(id);
  }

  Future<void> markAsSynced(int id) async {
    await _companyDao.markAsSynced(id);
  }

  Future<void> markAsSyncError(int id, String errorMessage) async {
    await _companyDao.markAsSyncError(id, errorMessage);
  }

  Future<void> syncFromServer(List<Map<String, dynamic>> companiesData) async {
    for (var companyData in companiesData) {
      final existingCompany = await _companyDao.getCompanyByServerId(
        companyData['id'] as int,
      );

      if (existingCompany != null) {
        // Update existing company
        final updatedCompany = existingCompany.copyWith(
          name: companyData['name'] as String? ?? existingCompany.name,
          tenant: companyData['tenant'] as String?,
          tenantId: companyData['tenantId'] as int?,
          createdBy: companyData['createdBy'] as String?,
          isSynced: true,
          syncPending: false,
          syncError: false,
        );
        await _companyDao.updateCompany(updatedCompany);
      } else {
        // Insert new company
        final company = CompanyEntity(
          serverId: companyData['id'] as int,
          name: companyData['name'] as String? ?? '',
          tenant: companyData['tenant'] as String?,
          tenantId: companyData['tenantId'] as int?,
          createdAt:
              companyData['created'] as String? ??
              DateTime.now().toIso8601String(),
          createdBy: companyData['createdBy'] as String?,
          lastModified: companyData['lastModified'] as String?,
          lastModifiedBy: companyData['lastModifiedBy'] as String?,
          deleted: companyData['deleted'] as bool?,
          deletedBy: companyData['deletedBy'] as String?,
          isSynced: true,
          syncPending: false,
          isDeleted: false,
        );
        await _companyDao.insertCompany(company);
      }
    }
  }
}
