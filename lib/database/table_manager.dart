// ignore_for_file: avoid_print

import 'package:nanohospic/database/table_schemas.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

class TableManager {
  final sqflite.DatabaseExecutor database;
  
  TableManager(this.database);
  
  // Create a specific table
  Future<void> createTable(String tableName) async {
    try {
      final schema = TableSchemas.getSchema(tableName);
      if (schema != null) {
        await database.execute(schema);
        await _createIndexes(tableName);
        print('✅ $tableName table created successfully');
      } else {
        print('❌ No schema found for table: $tableName');
      }
    } catch (e) {
      print('❌ Error creating $tableName table: $e');
      rethrow;
    }
  }
  
  // Create indexes for a table
  Future<void> _createIndexes(String tableName) async {
    final indexes = TableSchemas.getIndexes(tableName);
    if (indexes != null) {
      for (final index in indexes) {
        await database.execute(index);
      }
    }
  }
  
  // Check if table exists
  Future<bool> tableExists(String tableName) async {
    try {
      final result = await database.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='$tableName'",
      );
      return result.isNotEmpty;
    } catch (e) {
      print('❌ Error checking $tableName table: $e');
      return false;
    }
  }
  
  // Ensure table exists (create if missing)
  Future<void> ensureTableExists(String tableName) async {
    if (!await tableExists(tableName)) {
      print('⚠️ $tableName table missing, creating...');
      await createTable(tableName);
    }
  }
  
  // Get all table names
  Future<List<String>> getAllTableNames() async {
    try {
      final result = await database.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' ORDER BY name",
      );
      return result.map((row) => row['name'] as String).toList();
    } catch (e) {
      print('❌ Error getting tables: $e');
      return [];
    }
  }
  
  // Create all tables
  Future<void> createAllTables() async {
    try {
      print('🏗️ Creating all tables from scratch...');
      
      for (final tableName in TableSchemas.getAllTableNames()) {
        await createTable(tableName);
      }
      
      print('✅ All tables created successfully');
    } catch (e) {
      print('❌ Error creating tables: $e');
      rethrow;
    }
  }
  
  // Verify all tables exist
  Future<void> verifyAllTables() async {
    try {
      final tableNames = await getAllTableNames();
      print('📋 Found tables: $tableNames');
      
      for (final tableName in TableSchemas.getAllTableNames()) {
        await ensureTableExists(tableName);
      }
      
      print('✅ All tables verified successfully');
    } catch (e) {
      print('❌ Table verification error: $e');
    }
  }
  
  // Get row count for a table
  Future<int> getRowCount(String tableName) async {
    try {
      final result = await database.rawQuery('SELECT COUNT(*) as count FROM $tableName');
      return result.first['count'] as int;
    } catch (e) {
      print('❌ Error getting row count for $tableName: $e');
      return 0;
    }
  }
}