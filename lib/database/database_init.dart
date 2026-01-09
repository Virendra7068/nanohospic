import 'dart:io';
import 'package:nanohospic/database/table_manager.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:nanohospic/database/app_database.dart';

class DatabaseInitializer {
  // Initialize database with retry
  static Future<void> initializeDatabaseWithRetry(Future<AppDatabase> dbGetter) async {
    try {
      print('🔄 Initializing database...');
      final db = await dbGetter;
      await _forceCreateTablesIfMissing(db);
      print('✅ Database initialized successfully');
    } catch (e) {
      print('❌ Database initialization failed: $e');
      print('🔄 Retrying with clean database...');
      await _recreateDatabase(dbGetter);
    }
  }
  
  // Force create tables if missing
  static Future<void> _forceCreateTablesIfMissing(AppDatabase db) async {
    try {
      final tableManager = TableManager(db.database);
      await tableManager.createAllTables();
      print('✅ All tables created/verified successfully');
    } catch (e) {
      print('❌ Error creating tables: $e');
      rethrow;
    }
  }
  
  // Recreate database
  static Future<void> _recreateDatabase(Future<AppDatabase> dbGetter) async {
    try {
      final databasesPath = await sqflite.getDatabasesPath();
      final dbPath = '$databasesPath/database.db';
      final dbFile = File(dbPath);
      
      if (await dbFile.exists()) {
        await dbFile.delete();
        print('🗑️ Deleted old database file');
      }
      
      try {
        final shmFile = File('$dbPath-shm');
        final walFile = File('$dbPath-wal');
        if (await shmFile.exists()) await shmFile.delete();
        if (await walFile.exists()) await walFile.delete();
      } catch (e) {
        print('Note: Could not delete shm/wal files: $e');
      }
      
      await dbGetter;
      print('✅ Database recreated successfully');
    } catch (e) {
      print('❌ Error recreating database: $e');
      rethrow;
    }
  }
  
  // Debug database
  static Future<void> debugDatabase(sqflite.DatabaseExecutor database) async {
    try {
      print('🔍 DEBUGGING DATABASE...');
      final versionResult = await database.rawQuery('PRAGMA user_version');
      final version = versionResult.first['user_version'];
      print('📊 Database version: $version');
      
      final tableManager = TableManager(database);
      final tables = await tableManager.getAllTableNames();
      print('📋 All tables: $tables');
      
      for (var table in tables) {
        final count = await tableManager.getRowCount(table);
        print('   - $table: $count rows');
      }
    } catch (e) {
      print('❌ Debug failed: $e');
    }
  }
  
  // Execute raw SQL
  static Future<void> executeRawSQL(sqflite.DatabaseExecutor database, String sql) async {
    try {
      await database.execute(sql);
      print('✅ SQL executed: $sql');
    } catch (e) {
      print('❌ SQL execution failed: $e');
      rethrow;
    }
  }
  
  // Emergency create table directly
  static Future<void> createTableDirectly(sqflite.DatabaseExecutor database, String tableName) async {
    try {
      print('🆘 EMERGENCY: Creating $tableName table directly...');
      final tableManager = TableManager(database);
      
      if (!await tableManager.tableExists(tableName)) {
        await tableManager.createTable(tableName);
        print('✅ $tableName table created via direct SQL');
        
        // Verify
        final test = await database.query(tableName, limit: 1);
        print('✅ $tableName table verified, row count: ${test.length}');
      } else {
        print('✅ $tableName table already exists');
      }
    } catch (e) {
      print('❌ Direct creation failed: $e');
      rethrow;
    }
  }
}