// // database/repository/client_repo.dart
// import 'dart:async';
// import 'package:nanohospic/database/dao/client_dao.dart';
// import 'package:nanohospic/database/entity/client_entity.dart';

// class ClientRepository {
//   final ClientDao _clientDao;

//   ClientRepository(this._clientDao);

//   // Get all clients
//   Future<List<ClientEntity>> getAllClients() async {
//     return await _clientDao.getAllClients();
//   }

//   // Get client by ID
//   Future<ClientEntity?> getClientById(int id) async {
//     return await _clientDao.getClientById(id);
//   }

//   // Get client by server ID
//   Future<ClientEntity?> getClientByServerId(int serverId) async {
//     return await _clientDao.getClientByServerId(serverId);
//   }

//   // Get unsynced clients
//   Future<List<ClientEntity>> getUnsyncedClients() async {
//     return await _clientDao.getUnsyncedClients();
//   }

//   // Get total count
//   Future<int?> getTotalCount() async {
//     return await _clientDao.getTotalCount();
//   }

//   // Get synced count
//   Future<int?> getSyncedCount() async {
//     return await _clientDao.getSyncedCount();
//   }

//   // Get pending sync count
//   Future<int?> getPendingCount() async {
//     return await _clientDao.getPendingCount();
//   }

//   // Get all business names
//   Future<List<String>> getAllBusinessNames() async {
//     return await _clientDao.getAllBusinessNames();
//   }

//   // Get all cities
//   Future<List<String>> getAllCities() async {
//     return await _clientDao.getAllCities();
//   }

//   // Get all states
//   Future<List<String>> getAllStates() async {
//     return await _clientDao.getAllStates();
//   }

//   // Get all countries
//   Future<List<String>> getAllCountries() async {
//     return await _clientDao.getAllCountries();
//   }

//   // Search clients
//   Future<List<ClientEntity>> searchClients(String query) async {
//     return await _clientDao.searchClients('%$query%');
//   }

//   // Search clients with pagination
//   Future<List<ClientEntity>> searchClientsPaged(String query, int limit, int offset) async {
//     return await _clientDao.searchClientsPaged('%$query%', limit, offset);
//   }

//   // Get clients with pagination
//   Future<List<ClientEntity>> getClientsPaged(int limit, int offset) async {
//     return await _clientDao.getClientsPaged(limit, offset);
//   }

//   // Insert client
//   Future<int> insertClient(ClientEntity client) async {
//     final clientToInsert = ClientEntity(
//       id: client.id,
//       serverId: client.serverId,
//       businessName: client.businessName,
//       postalCode: client.postalCode,
//       address1: client.address1,
//       contactPersonName: client.contactPersonName,
//       location: client.location,
//       country: client.country,
//       phone: client.phone,
//       state: client.state,
//       city: client.city,
//       requiredCredentials: client.requiredCredentials,
//       createdAt: DateTime.now().toIso8601String(),
//       createdBy: client.createdBy ?? 'system',
//       lastModified: DateTime.now().toIso8601String(),
//       lastModifiedBy: client.lastModifiedBy ?? 'system',
//       isDeleted: client.isDeleted,
//       deletedBy: client.deletedBy,
//       isSynced: 0,
//       syncStatus: 'pending',
//       syncAttempts: 0,
//       lastSyncError: null,
//     );
//     return await _clientDao.insertClient(clientToInsert);
//   }

//   // Insert multiple clients
//   Future<List<int>> insertClients(List<ClientEntity> clients) async {
//     final clientsToInsert = clients.map((client) => ClientEntity(
//       id: client.id,
//       serverId: client.serverId,
//       businessName: client.businessName,
//       postalCode: client.postalCode,
//       address1: client.address1,
//       contactPersonName: client.contactPersonName,
//       location: client.location,
//       country: client.country,
//       phone: client.phone,
//       state: client.state,
//       city: client.city,
//       requiredCredentials: client.requiredCredentials,
//       createdAt: client.createdAt ?? DateTime.now().toIso8601String(),
//       createdBy: client.createdBy ?? 'system',
//       lastModified: client.lastModified ?? DateTime.now().toIso8601String(),
//       lastModifiedBy: client.lastModifiedBy ?? 'system',
//       isDeleted: client.isDeleted ?? 0,
//       deletedBy: client.deletedBy,
//       isSynced: 0,
//       syncStatus: 'pending',
//       syncAttempts: 0,
//       lastSyncError: null,
//     )).toList();
    
//     return await _clientDao.insertClients(clientsToInsert);
//   }

//   // Update client
//   Future<int> updateClient(ClientEntity client) async {
//     final clientToUpdate = client.copyWith(
//       lastModified: DateTime.now().toIso8601String(),
//       lastModifiedBy: 'system',
//       isSynced: 0, // Mark as pending sync after update
//       syncStatus: 'pending',
//     );
//     return await _clientDao.updateClient(clientToUpdate);
//   }

//   // Update multiple clients
//   Future<int> updateClients(List<ClientEntity> clients) async {
//     final clientsToUpdate = clients.map((client) => client.copyWith(
//       lastModified: DateTime.now().toIso8601String(),
//       lastModifiedBy: 'system',
//       isSynced: 0,
//       syncStatus: 'pending',
//     )).toList();
    
//     return await _clientDao.updateClients(clientsToUpdate);
//   }

//   // Mark client as synced
//   Future<int> markAsSynced(int id, String status) async {
//     return await _clientDao.markAsSynced(id, status);
//   }

//   // Mark client as unsynced
//   Future<int> markAsUnsynced(int id, String status, String error) async {
//     return await _clientDao.markAsUnsynced(id, status, error);
//   }

//   // Update server ID
//   Future<int> updateServerId(int localId, int serverId) async {
//     return await _clientDao.updateServerId(localId, serverId);
//   }

//   // Delete client
//   Future<int> deleteClient(int id) async {
//     return await _clientDao.deleteClient(id);
//   }

//   // Delete all clients
//   Future<int> deleteAllClients() async {
//     return await _clientDao.deleteAllClients();
//   }

//   // Soft delete client
//   Future<int> softDeleteClient(int id, String deletedBy) async {
//     return await _clientDao.softDeleteClient(id, deletedBy);
//   }

//   // Get active clients
//   Future<List<ClientEntity>> getActiveClients() async {
//     return await _clientDao.getActiveClients();
//   }

//   // Get deleted clients
//   Future<List<ClientEntity>> getDeletedClients() async {
//     return await _clientDao.getDeletedClients();
//   }

//   // Statistics
//   Future<int?> getCountByCity(String city) async {
//     return await _clientDao.getCountByCity(city);
//   }

//   Future<int?> getCountByState(String state) async {
//     return await _clientDao.getCountByState(state);
//   }

//   Future<int?> getCountByCountry(String country) async {
//     return await _clientDao.getCountByCountry(country);
//   }

//   Future<List<Map<String, dynamic>>> getClientDistributionByCity() async {
//     return await _clientDao.getClientDistributionByCity();
//   }

//   Future<List<Map<String, dynamic>>> getClientDistributionByState() async {
//     return await _clientDao.getClientDistributionByState();
//   }

//   Future<List<Map<String, dynamic>>> getClientDistributionByCountry() async {
//     return await _clientDao.getClientDistributionByCountry();
//   }

//   // Sync from server
//   Future<void> syncFromServer(List<Map<String, dynamic>> serverData) async {
//     for (final clientData in serverData) {
//       try {
//         final serverId = _parseInt(clientData['id']);
//         final existing = await getClientByServerId(serverId);
        
//         final clientEntity = ClientEntity(
//           serverId: serverId,
//           businessName: clientData['businessName']?.toString() ?? '',
//           postalCode: clientData['postalCode']?.toString() ?? '',
//           address1: clientData['address1']?.toString() ?? '',
//           contactPersonName: clientData['contactPersonName']?.toString() ?? '',
//           location: clientData['location']?.toString() ?? '',
//           country: clientData['country']?.toString() ?? '',
//           phone: clientData['phone']?.toString() ?? '',
//           state: clientData['state']?.toString() ?? '',
//           city: clientData['city']?.toString() ?? '',
//           requiredCredentials: clientData['requiredCredentials']?.toString() ?? '',
//           createdAt: clientData['createdAt']?.toString() ?? DateTime.now().toIso8601String(),
//           createdBy: clientData['createdBy']?.toString(),
//           lastModified: clientData['lastModified']?.toString(),
//           lastModifiedBy: clientData['lastModifiedBy']?.toString(),
//           isDeleted: (clientData['isDeleted'] as bool? ?? false) ? 1 : 0,
//           deletedBy: clientData['deletedBy']?.toString(),
//           isSynced: 1, // From server means synced
//           syncStatus: 'synced',
//           syncAttempts: 0,
//           lastSyncError: null,
//         );

//         if (existing == null) {
//           // Insert new client
//           await insertClient(clientEntity);
//         } else {
//           // Update existing client
//           await updateClient(clientEntity.copyWith(id: existing.id));
//         }
//       } catch (e) {
//         print('Error syncing client: $e');
//         continue;
//       }
//     }
//   }

//   // Helper method to parse integers safely
//   int _parseInt(dynamic value) {
//     if (value == null) return 0;
//     if (value is int) return value;
//     if (value is String) return int.tryParse(value) ?? 0;
//     return 0;
//   }

//   // // Bulk operations
//   // Future<void> bulkInsertClients(List<ClientEntity> clients) async {
//   //   return await _clientDao.bulkInsertClients(clients);
//   // }

//   // // Emergency fix table
//   // Future<void> emergencyFixTable() async {
//   //   return await _clientDao.emergencyFixTable();
//   // }

//   // Additional helper methods
//   Future<List<ClientEntity>> getClientsByCity(String city) async {
//     final allClients = await getAllClients();
//     return allClients.where((client) => client.city.toLowerCase() == city.toLowerCase()).toList();
//   }

//   Future<List<ClientEntity>> getClientsByState(String state) async {
//     final allClients = await getAllClients();
//     return allClients.where((client) => client.state.toLowerCase() == state.toLowerCase()).toList();
//   }

//   Future<List<ClientEntity>> getClientsByCountry(String country) async {
//     final allClients = await getAllClients();
//     return allClients.where((client) => client.country.toLowerCase() == country.toLowerCase()).toList();
//   }

//   Future<ClientEntity?> findClientByPhone(String phone) async {
//     final allClients = await getAllClients();
//     for (final client in allClients) {
//       if (client.phone == phone) {
//         return client;
//       }
//     }
//     return null;
//   }

//   Future<ClientEntity?> findClientByBusinessName(String businessName) async {
//     final allClients = await getAllClients();
//     for (final client in allClients) {
//       if (client.businessName.toLowerCase() == businessName.toLowerCase()) {
//         return client;
//       }
//     }
//     return null;
//   }

//   Future<bool> clientExists(String businessName, String phone) async {
//     final client = await findClientByBusinessName(businessName);
//     if (client != null) return true;
    
//     final clientByPhone = await findClientByPhone(phone);
//     return clientByPhone != null;
//   }

//   Future<void> restoreClient(int id) async {
//     final client = await getClientById(id);
//     if (client != null && client.isDeleted == 1) {
//       final restoredClient = client.copyWith(
//         isDeleted: 0,
//         deletedBy: null,
//         lastModified: DateTime.now().toIso8601String(),
//         lastModifiedBy: 'system',
//         isSynced: 0,
//         syncStatus: 'pending',
//       );
//       await updateClient(restoredClient);
//     }
//   }

//   // Get clients by contact person name
//   Future<List<ClientEntity>> getClientsByContactPerson(String contactPersonName) async {
//     final allClients = await getAllClients();
//     return allClients.where((client) => 
//       client.contactPersonName.toLowerCase().contains(contactPersonName.toLowerCase())
//     ).toList();
//   }

//   // Get clients by location
//   Future<List<ClientEntity>> getClientsByLocation(String location) async {
//     final allClients = await getAllClients();
//     return allClients.where((client) => 
//       client.location.toLowerCase().contains(location.toLowerCase())
//     ).toList();
//   }

//   // Get recent clients
//   Future<List<ClientEntity>> getRecentClients(int count) async {
//     final allClients = await getAllClients();
//     allClients.sort((a, b) => b.createdAt.compareTo(a.createdAt));
//     return allClients.take(count).toList();
//   }

//   Future<List<ClientEntity>> getClientsRequiringCredentials() async {
//     final allClients = await getAllClients();
//     return allClients.where((client) => 
//       client.requiredCredentials.isNotEmpty
//     ).toList();
//   }

//   Future<List<ClientEntity>> getPendingSyncByLocation(String location) async {
//     final pendingClients = await getUnsyncedClients();
//     return pendingClients.where((client) => 
//       client.location.toLowerCase() == location.toLowerCase()
//     ).toList();
//   }
// }