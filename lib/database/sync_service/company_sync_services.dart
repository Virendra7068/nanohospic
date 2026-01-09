// // lib/data/sync/sync_service.dart
// import 'dart:async';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:http/http.dart' as http;
// import 'package:nanohospic/database/app_database.dart';
// import 'package:nanohospic/database/entity/company_entity.dart';
// import 'dart:convert';

// class SyncService {
//   final AppDatabase database;
//   final String apiUrl = 'http://202.140.138.215:85/api/CompanyApi';
  
//   // Timer for periodic sync
//   Timer? _syncTimer;
  
//   // Connectivity
//   final Connectivity _connectivity = Connectivity();
//   StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  
//   // Sync status stream
//   final StreamController<SyncStatus> _syncStatusController = StreamController<SyncStatus>.broadcast();
//   Stream<SyncStatus> get syncStatusStream => _syncStatusController.stream;
  
//   SyncService({required this.database});
  
//   Future<void> startAutoSync({int intervalSeconds = 30}) async {
//     // Stop any existing timer
//     stopAutoSync();
    
//     // Set up connectivity listener
//     _connectivitySubscription = _connectivity.onConnectivityChanged.listen((result) {
//       if (result != ConnectivityResult.none) {
//         _triggerSync();
//       }
//     }) as StreamSubscription<ConnectivityResult>?;
    
//     // Set up periodic sync timer
//     _syncTimer = Timer.periodic(Duration(seconds: intervalSeconds), (timer) async {
//       final connectivityResult = await Connectivity().checkConnectivity();
//       if (connectivityResult != ConnectivityResult.none) {
//         await _triggerSync();
//       }
//     });
    
//     // Initial sync check
//     final connectivityResult = await Connectivity().checkConnectivity();
//     if (connectivityResult != ConnectivityResult.none) {
//       await _triggerSync();
//     }
//   }
  
//   void stopAutoSync() {
//     _syncTimer?.cancel();
//     _syncTimer = null;
//     _connectivitySubscription?.cancel();
//     _connectivitySubscription = null;
//   }
  
//   Future<void> _triggerSync() async {
//     try {
//       _syncStatusController.add(SyncStatus.syncing);
      
//       // Sync unsynced companies
//       await _syncUnsyncedCompanies();
      
//       // Sync with server (pull updates)
//       await _pullCompaniesFromServer();
      
//       _syncStatusController.add(SyncStatus.completed);
      
//       // Wait a bit before sending next status
//       await Future.delayed(const Duration(seconds: 2));
//       _syncStatusController.add(SyncStatus.idle);
//     } catch (e) {
//       _syncStatusController.add(SyncStatus.error(e.toString()));
//       await Future.delayed(const Duration(seconds: 2));
//       _syncStatusController.add(SyncStatus.idle);
//     }
//   }
  
//   Future<void> _syncUnsyncedCompanies() async {
//     final unsyncedCompanies = await database.companyDao.getUnsyncedCompanies();
    
//     for (final company in unsyncedCompanies) {
//       try {
//         if (company.isDeleted) {
//           // If marked for deletion, delete from server
//           if (company.id != null && company.id! > 0) {
//             await _deleteFromServer(company.id!);
//           }
//           // Remove from local DB after successful server delete
//           await database.companyDao.deleteCompany(company.id!);
//         } else {
//           // Insert/Update to server
//           final response = await http.post(
//             Uri.parse(apiUrl),
//             headers: {'Content-Type': 'application/json; charset=UTF-8'},
//             body: jsonEncode(company.toJson()),
//           );
          
//           if (response.statusCode == 200 || response.statusCode == 201) {
//             final responseData = jsonDecode(response.body);
//             final updatedCompany = company.copyWith(
//               isSynced: true,
//               syncedAt: DateTime.now(),
//               id: responseData['id'] as int? ?? company.id,
//             );
//             await database.companyDao.updateCompany(updatedCompany);
//           } else {
//             // Update with error
//             await database.companyDao.updateCompany(
//               company.copyWith(
//                 syncError: 'Server error: ${response.statusCode}',
//               ),
//             );
//           }
//         }
//       } catch (e) {
//         // Update with error
//         await database.companyDao.updateCompany(
//           company.copyWith(
//             syncError: e.toString(),
//           ),
//         );
//       }
//     }
//   }
  
//   Future<void> _deleteFromServer(int id) async {
//     try {
//       final response = await http.delete(
//         Uri.parse('$apiUrl/$id'),
//         headers: {'Content-Type': 'application/json'},
//       );
      
//       if (response.statusCode != 200) {
//         throw Exception('Failed to delete from server: ${response.statusCode}');
//       }
//     } catch (e) {
//       rethrow;
//     }
//   }
  
//   Future<void> _pullCompaniesFromServer() async {
//     try {
//       final response = await http.get(Uri.parse(apiUrl));
      
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         final companiesData = data['data'] as List<dynamic>;
        
//         final serverCompanies = companiesData
//             .map((json) => CompanyEntity.fromApiResponse(json))
//             .toList();
        
//         // Insert or update in local database
//         await database.companyDao.insertCompanies(serverCompanies);
//       }
//     } catch (e) {
//       // Log error but don't throw - offline mode should still work
//       print('Error pulling from server: $e');
//     }
//   }
  
//   Future<void> manualSync() async {
//     final connectivityResult = await Connectivity().checkConnectivity();
//     if (connectivityResult == ConnectivityResult.none) {
//       throw Exception('No internet connection');
//     }
//     await _triggerSync();
//   }
  
//   void dispose() {
//     stopAutoSync();
//     _syncStatusController.close();
//   }
// }

// enum SyncStatusType {
//   idle,
//   syncing,
//   completed,
//   error,
// }

// class SyncStatus {
//   final SyncStatusType type;
//   final String? message;
  
//   SyncStatus(this.type, [this.message]);
  
//   factory SyncStatus.idle() => SyncStatus(SyncStatusType.idle);
//   factory SyncStatus.syncing() => SyncStatus(SyncStatusType.syncing);
//   factory SyncStatus.completed() => SyncStatus(SyncStatusType.completed);
//   factory SyncStatus.error(String message) => SyncStatus(SyncStatusType.error, message);
// }