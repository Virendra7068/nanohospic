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