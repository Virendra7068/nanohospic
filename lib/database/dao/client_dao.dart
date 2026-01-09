// // database/dao/client_dao.dart
// import 'package:floor/floor.dart';
// import 'package:nanohospic/database/entity/client_entity.dart';

// @dao
// abstract class ClientDao {
//   @Query('SELECT * FROM client ORDER BY created_at DESC')
//   Future<List<ClientEntity>> getAllClients();

//   @Query('SELECT * FROM client WHERE id = :id')
//   Future<ClientEntity?> getClientById(int id);

//   @Query('SELECT * FROM client WHERE server_id = :serverId')
//   Future<ClientEntity?> getClientByServerId(int serverId);

//   @Query('SELECT * FROM client WHERE is_synced = 0')
//   Future<List<ClientEntity>> getUnsyncedClients();

//   // Fix: Use INTEGER return type instead of int
//   @Query('SELECT COUNT(*) FROM client')
//   Future<int?> getTotalCount();

//   @Query('SELECT COUNT(*) FROM client WHERE is_synced = 1')
//   Future<int?> getSyncedCount();

//   @Query('SELECT COUNT(*) FROM client WHERE is_synced = 0')
//   Future<int?> getPendingCount();

//   @Query('SELECT DISTINCT business_name FROM client ORDER BY business_name')
//   Future<List<String>> getAllBusinessNames();

//   @Query('SELECT DISTINCT city FROM client WHERE city IS NOT NULL AND city != "" ORDER BY city')
//   Future<List<String>> getAllCities();

//   @Query('SELECT DISTINCT state FROM client WHERE state IS NOT NULL AND state != "" ORDER BY state')
//   Future<List<String>> getAllStates();

//   @Query('SELECT DISTINCT country FROM client WHERE country IS NOT NULL AND country != "" ORDER BY country')
//   Future<List<String>> getAllCountries();

//   @Query('''
//     SELECT * FROM client 
//     WHERE business_name LIKE :query 
//        OR contact_person_name LIKE :query 
//        OR phone LIKE :query 
//        OR city LIKE :query 
//     ORDER BY created_at DESC
//   ''')
//   Future<List<ClientEntity>> searchClients(String query);

//   @Query('''
//     SELECT * FROM client 
//     WHERE business_name LIKE :query 
//        OR contact_person_name LIKE :query 
//        OR phone LIKE :query 
//        OR city LIKE :query 
//     ORDER BY created_at DESC
//     LIMIT :limit OFFSET :offset
//   ''')
//   Future<List<ClientEntity>> searchClientsPaged(String query, int limit, int offset);

//   @Query('SELECT * FROM client ORDER BY created_at DESC LIMIT :limit OFFSET :offset')
//   Future<List<ClientEntity>> getClientsPaged(int limit, int offset);

//   @Insert(onConflict: OnConflictStrategy.replace)
//   Future<int> insertClient(ClientEntity client);

//   @Insert(onConflict: OnConflictStrategy.replace)
//   Future<List<int>> insertClients(List<ClientEntity> clients);

//   @Update(onConflict: OnConflictStrategy.replace)
//   Future<int> updateClient(ClientEntity client);

//   @Update(onConflict: OnConflictStrategy.replace)
//   Future<int> updateClients(List<ClientEntity> clients);

//   @Query('UPDATE client SET is_synced = 1, sync_status = :status, last_sync_error = NULL WHERE id = :id')
//   Future<int> markAsSynced(int id, String status);

//   @Query('UPDATE client SET is_synced = 0, sync_status = :status, sync_attempts = sync_attempts + 1, last_sync_error = :error WHERE id = :id')
//   Future<int> markAsUnsynced(int id, String status, String error);

//   @Query('UPDATE client SET server_id = :serverId WHERE id = :localId')
//   Future<int> updateServerId(int localId, int serverId);

//   @Query('DELETE FROM client WHERE id = :id')
//   Future<int> deleteClient(int id);

//   @Query('DELETE FROM client')
//   Future<int> deleteAllClients();

//   @Query('UPDATE client SET is_deleted = 1, deleted_by = :deletedBy WHERE id = :id')
//   Future<int> softDeleteClient(int id, String deletedBy);

//   @Query('SELECT * FROM client WHERE is_deleted = 0 ORDER BY created_at DESC')
//   Future<List<ClientEntity>> getActiveClients();

//   @Query('SELECT * FROM client WHERE is_deleted = 1 ORDER BY created_at DESC')
//   Future<List<ClientEntity>> getDeletedClients();

//   // Stats and analytics
//   @Query('SELECT COUNT(*) FROM client WHERE city = :city')
//   Future<int?> getCountByCity(String city);

//   @Query('SELECT COUNT(*) FROM client WHERE state = :state')
//   Future<int?> getCountByState(String state);

//   @Query('SELECT COUNT(*) FROM client WHERE country = :country')
//   Future<int?> getCountByCountry(String country);

//   @Query('SELECT city, COUNT(*) as count FROM client WHERE city IS NOT NULL GROUP BY city ORDER BY count DESC')
//   Future<List<Map<String, dynamic>>> getClientDistributionByCity();

//   @Query('SELECT state, COUNT(*) as count FROM client WHERE state IS NOT NULL GROUP BY state ORDER BY count DESC')
//   Future<List<Map<String, dynamic>>> getClientDistributionByState();

//   @Query('SELECT country, COUNT(*) as count FROM client WHERE country IS NOT NULL GROUP BY country ORDER BY count DESC')
//   Future<List<Map<String, dynamic>>> getClientDistributionByCountry();

//   // Emergency fix for table structure
//   @Query('''
//     CREATE TABLE IF NOT EXISTS client_temp AS SELECT * FROM client
//   ''')
//   Future<void> createTempTable();

//   @Query('DROP TABLE IF EXISTS client')
//   Future<void> dropTable();

//   @Query('''
//     CREATE TABLE IF NOT EXISTS client (
//       id INTEGER PRIMARY KEY AUTOINCREMENT,
//       server_id INTEGER,
//       business_name TEXT NOT NULL,
//       postal_code TEXT NOT NULL,
//       address1 TEXT NOT NULL,
//       contact_person_name TEXT NOT NULL,
//       location TEXT NOT NULL,
//       country TEXT NOT NULL,
//       phone TEXT NOT NULL,
//       state TEXT NOT NULL,
//       city TEXT NOT NULL,
//       required_credentials TEXT NOT NULL,
//       created_at TEXT NOT NULL,
//       created_by TEXT,
//       last_modified TEXT,
//       last_modified_by TEXT,
//       is_deleted INTEGER DEFAULT 0,
//       deleted_by TEXT,
//       is_synced INTEGER DEFAULT 0,
//       sync_status TEXT DEFAULT 'pending',
//       sync_attempts INTEGER DEFAULT 0,
//       last_sync_error TEXT
//     )
//   ''')
//   Future<void> createTable();

//   @Query('''
//     INSERT INTO client SELECT * FROM client_temp
//   ''')
//   Future<void> restoreFromTempTable();

//   @Query('DROP TABLE IF EXISTS client_temp')
//   Future<void> dropTempTable();

// }