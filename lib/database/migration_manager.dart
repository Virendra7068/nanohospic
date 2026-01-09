// ignore_for_file: avoid_print

import 'package:floor/floor.dart';
import 'package:nanohospic/database/table_schemas.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

class MigrationManager {
  // Get all migrations
  static List<Migration> getMigrations() {
    return [
      Migration(1, 2, (database) => _migration1to2(database)),
      Migration(2, 3, (database) => _migration2to3(database)),
      Migration(3, 4, (database) => _migration3to4(database)),
      Migration(4, 5, (database) => _migration4to5(database)),
      Migration(5, 6, (database) => _migration5to6(database)),
      Migration(6, 7, (database) => _migration6to7(database)),
      Migration(7, 8, (database) => _migration7to8(database)),
      Migration(8, 9, (database) => _migration8to9(database)),
      Migration(9, 10, (database) => _migration9to10(database)),
      Migration(10, 11, (database) => _migration10to11(database)),
      Migration(11, 12, (database) => _migration11to12(database)),
      Migration(12, 13, (database) => _migration12to13(database)),
      Migration(13, 14, (database) => _migration13to14(database)),
      Migration(14, 15, (database) => _migration14to15(database)),
      Migration(15, 16, (database) => _migration15to16(database)),
      Migration(16, 17, (database) => _migration16to17(database)),
      Migration(17, 18, (database) => _migration17to18(database)),
    ];
  }

  // Migration 1 → 2: Create categories and subcategories
  static Future<void> _migration1to2(sqflite.DatabaseExecutor database) async {
    try {
      await database.execute(TableSchemas.categories);
      await database.execute(TableSchemas.subcategories);
      print('✅ Migration 1→2 completed: Created categories and subcategories tables');
    } catch (e) {
      print('❌ Migration 1→2 error: $e');
      rethrow;
    }
  }

  // Migration 2 → 3: Create HSN codes table
  static Future<void> _migration2to3(sqflite.DatabaseExecutor database) async {
    try {
      await _createTable(database, 'hsn_codes');
      print('✅ Migration 2→3 completed: Created hsn_codes table');
    } catch (e) {
      print('❌ Migration 2→3 error: $e');
      rethrow;
    }
  }

  // Migration 3 → 4: Verify HSN codes table
  static Future<void> _migration3to4(sqflite.DatabaseExecutor database) async {
    try {
      await _verifyTable(database, 'hsn_codes');
      print('✅ Migration 3→4 completed: Verified HSN table');
    } catch (e) {
      print('❌ Migration 3→4 error: $e');
      rethrow;
    }
  }

  // Migration 4 → 5: Placeholder migration
  static Future<void> _migration4to5(sqflite.DatabaseExecutor database) async {
    try {
      print('✅ Migration 4→5 completed: Placeholder migration');
    } catch (e) {
      print('❌ Migration 4→5 error: $e');
      rethrow;
    }
  }

  // Migration 5 → 6: Create staff table
  static Future<void> _migration5to6(sqflite.DatabaseExecutor database) async {
    try {
      await _createTable(database, 'staff');
      print('✅ Migration 5→6 completed: Created staff table');
    } catch (e) {
      print('❌ Migration 5→6 error: $e');
      rethrow;
    }
  }

  // Migration 6 → 7: Verify staff table
  static Future<void> _migration6to7(sqflite.DatabaseExecutor database) async {
    try {
      await _verifyTable(database, 'staff');
      print('✅ Migration 6→7 completed: Verified staff table');
    } catch (e) {
      print('❌ Migration 6→7 error: $e');
      rethrow;
    }
  }

  // Migration 7 → 8: Create bas_names table
  static Future<void> _migration7to8(sqflite.DatabaseExecutor database) async {
    try {
      await _createTable(database, 'bas_names');
      print('✅ Migration 7→8 completed: Created bas_names table');
    } catch (e) {
      print('❌ Migration 7→8 error: $e');
      rethrow;
    }
  }

  // Migration 8 → 9: Verify bas_names table
  static Future<void> _migration8to9(sqflite.DatabaseExecutor database) async {
    try {
      await _verifyTable(database, 'bas_names');
      print('✅ Migration 8→9 completed: Verified bas_names table');
    } catch (e) {
      print('❌ Migration 8→9 error: $e');
      rethrow;
    }
  }

  // Migration 9 → 10: Create payment_modes table
  static Future<void> _migration9to10(sqflite.DatabaseExecutor database) async {
    try {
      await _createTable(database, 'payment_modes');
      print('✅ Migration 9→10 completed: Created payment_modes table');
    } catch (e) {
      print('❌ Migration 9→10 error: $e');
      rethrow;
    }
  }

  // Migration 10 → 11: Verify payment_modes table
  static Future<void> _migration10to11(sqflite.DatabaseExecutor database) async {
    try {
      await _verifyTable(database, 'payment_modes');
      print('✅ Migration 10→11 completed: Verified payment_modes table');
    } catch (e) {
      print('❌ Migration 10→11 error: $e');
      rethrow;
    }
  }

  // Migration 11 → 12: Create sample_types table
  static Future<void> _migration11to12(sqflite.DatabaseExecutor database) async {
    try {
      await _createTable(database, 'sample_types');
      print('✅ Migration 11→12 completed: Created sample_types table');
    } catch (e) {
      print('❌ Migration 11→12 error: $e');
      rethrow;
    }
  }

  // Migration 12 → 13: Verify sample_types table
  static Future<void> _migration12to13(sqflite.DatabaseExecutor database) async {
    try {
      await _verifyTable(database, 'sample_types');
      print('✅ Migration 12→13 completed: Verified sample_types table');
    } catch (e) {
      print('❌ Migration 12→13 error: $e');
      rethrow;
    }
  }

  // Migration 13 → 14: Create branch_types table
  static Future<void> _migration13to14(sqflite.DatabaseExecutor database) async {
    try {
      await _createTable(database, 'branch_types');
      print('✅ Migration 13→14 completed: Created branch_types table');
    } catch (e) {
      print('❌ Migration 13→14 error: $e');
      rethrow;
    }
  }

  // Migration 14 → 15: Verify branch_types table
  static Future<void> _migration14to15(sqflite.DatabaseExecutor database) async {
    try {
      await _verifyTable(database, 'branch_types');
      print('✅ Migration 14→15 completed: Verified branch_types table');
    } catch (e) {
      print('❌ Migration 14→15 error: $e');
      rethrow;
    }
  }

  // Migration 15 → 16: Create collection_centers table
  static Future<void> _migration15to16(sqflite.DatabaseExecutor database) async {
    try {
      await _createTable(database, 'collection_centers');
      print('✅ Migration 15→16 completed: Created collection_centers table');
    } catch (e) {
      print('❌ Migration 15→16 error: $e');
      rethrow;
    }
  }

  // Migration 16 → 17: Verify collection_centers table
  static Future<void> _migration16to17(sqflite.DatabaseExecutor database) async {
    try {
      await _verifyTable(database, 'collection_centers');
      print('✅ Migration 16→17 completed: Verified collection_centers table');
    } catch (e) {
      print('❌ Migration 16→17 error: $e');
      rethrow;
    }
  }

  // Migration 17 → 18: Create groups table
  static Future<void> _migration17to18(sqflite.DatabaseExecutor database) async {
    try {
      await _createTable(database, 'groups');
      print('✅ Migration 17→18 completed: Created groups table');
    } catch (e) {
      print('❌ Migration 17→18 error: $e');
      rethrow;
    }
  }

  // Helper method to create table with indexes
  static Future<void> _createTable(sqflite.DatabaseExecutor database, String tableName) async {
    try {
      final schema = TableSchemas.getSchema(tableName);
      if (schema != null) {
        await database.execute(schema);
        
        // Create indexes
        final indexes = TableSchemas.getIndexes(tableName);
        if (indexes != null) {
          for (final index in indexes) {
            await database.execute(index);
          }
        }
      }
    } catch (e) {
      print('❌ Error creating $tableName table: $e');
      rethrow;
    }
  }

  // Helper method to verify table exists
  static Future<void> _verifyTable(sqflite.DatabaseExecutor database, String tableName) async {
    try {
      final result = await database.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='$tableName'",
      );
      
      if (result.isEmpty) {
        print('⚠️ $tableName table not found, creating...');
        await _createTable(database, tableName);
      }
    } catch (e) {
      print('❌ Error verifying $tableName table: $e');
      rethrow;
    }
  }
}