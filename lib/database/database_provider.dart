// // // // // // ignore_for_file: avoid_print

// // // // // import 'dart:io';
// // // // // import 'package:floor/floor.dart';
// // // // // import 'package:nanohospic/database/app_database.dart';
// // // // // import 'package:nanohospic/database/repository/branch_type_repo.dart';
// // // // // import 'package:nanohospic/database/repository/city_repo.dart';
// // // // // import 'package:nanohospic/database/repository/country_repo.dart';
// // // // // import 'package:nanohospic/database/repository/hsn_repo.dart';
// // // // // import 'package:nanohospic/database/repository/item_cat_repo.dart';
// // // // // import 'package:nanohospic/database/repository/patient_identity_repo.dart';
// // // // // import 'package:nanohospic/database/repository/payment_mode_repo.dart';
// // // // // import 'package:nanohospic/database/repository/refrerrer_repo.dart';
// // // // // import 'package:nanohospic/database/repository/sample_type_repo.dart';
// // // // // import 'package:nanohospic/database/repository/staff_repo.dart';
// // // // // import 'package:nanohospic/database/repository/state_repo.dart';
// // // // // import 'package:nanohospic/database/repository/sucategory_rep.dart';
// // // // // import 'package:nanohospic/database/repository/user_reposetory.dart';
// // // // // import 'package:nanohospic/database/repository/collection_center_repo.dart';
// // // // // import 'package:sqflite/sqflite.dart';

// // // // // class DatabaseProvider {
// // // // //   static final DatabaseProvider _instance = DatabaseProvider._internal();
// // // // //   factory DatabaseProvider() => _instance;
// // // // //   DatabaseProvider._internal();
// // // // //   static AppDatabase? _database;
// // // // //   static UserRepository? _userRepository;
// // // // //   static StaffRepository? _staffRepository;
// // // // //   static CountryRepository? _countryRepository;
// // // // //   static StateRepository? _stateRepository;
// // // // //   static CityRepository? _cityRepository;
// // // // //   static CategoryRepository? _categoryRepository;
// // // // //   static SubCategoryRepository? _subCategoryRepository;
// // // // //   static HsnRepository? _hsnRepository;
// // // // //   static BasRepository? _basRepository;
// // // // //   static PaymentModeRepository? _paymentModeRepository;
// // // // //   static SampleTypeRepository? _sampleTypeRepository;
// // // // //   static BranchTypeRepository? _branchTypeRepository;
// // // // //   static CollectionCenterRepository? _collectionCenterRepository;
// // // // //   static ReferrerRepository? _referrerRepository;

// // // // //   static Future<AppDatabase> get database async {
// // // // //     if (_database != null) return _database!;

// // // // //     _database = await $FloorAppDatabase
// // // // //         .databaseBuilder('database.db')
// // // // //         .addMigrations([
// // // // //           Migration(1, 2, (database) async {
// // // // //             try {
// // // // //               await database.execute('''
// // // // //                 CREATE TABLE IF NOT EXISTS categories (
// // // // //                   id INTEGER PRIMARY KEY AUTOINCREMENT,
// // // // //                   server_id INTEGER,
// // // // //                   category_name TEXT NOT NULL,
// // // // //                   created_at TEXT,
// // // // //                   created_by TEXT,
// // // // //                   last_modified TEXT,
// // // // //                   last_modified_by TEXT,
// // // // //                   is_deleted INTEGER DEFAULT 0,
// // // // //                   deleted_by TEXT,
// // // // //                   is_synced INTEGER DEFAULT 0,
// // // // //                   sync_status TEXT DEFAULT 'pending'
// // // // //                 )
// // // // //               ''');

// // // // //               await database.execute('''
// // // // //                 CREATE TABLE IF NOT EXISTS subcategories (
// // // // //                   id INTEGER PRIMARY KEY AUTOINCREMENT,
// // // // //                   server_id INTEGER,
// // // // //                   name TEXT NOT NULL,
// // // // //                   category_id INTEGER NOT NULL,
// // // // //                   category_server_id INTEGER,
// // // // //                   category_name TEXT,
// // // // //                   created_at TEXT,
// // // // //                   created_by TEXT,
// // // // //                   last_modified TEXT,
// // // // //                   last_modified_by TEXT,
// // // // //                   is_deleted INTEGER DEFAULT 0,
// // // // //                   deleted_by TEXT,
// // // // //                   is_synced INTEGER DEFAULT 0,
// // // // //                   sync_status TEXT DEFAULT 'pending'
// // // // //                 )
// // // // //               ''');

// // // // //               print(
// // // // //                 '✅ Migration 1→2 completed: Created categories and subcategories tables',
// // // // //               );
// // // // //             } catch (e) {
// // // // //               print('❌ Migration error: $e');
// // // // //               rethrow;
// // // // //             }
// // // // //           }),

// // // // //           Migration(2, 3, (database) async {
// // // // //             try {
// // // // //               await _createHsnTable(database);
// // // // //               print('✅ Migration 2→3 completed: Created hsn_codes table');
// // // // //             } catch (e) {
// // // // //               print('❌ Migration error: $e');
// // // // //               rethrow;
// // // // //             }
// // // // //           }),

// // // // //           Migration(3, 4, (database) async {
// // // // //             try {
// // // // //               final result = await database.rawQuery(
// // // // //                 "SELECT name FROM sqlite_master WHERE type='table' AND name='hsn_codes'",
// // // // //               );
// // // // //               if (result.isEmpty) {
// // // // //                 print('⚠️ HSN table not found in migration 3→4, creating...');
// // // // //                 await _createHsnTable(database);
// // // // //               }
// // // // //               print('✅ Migration 3→4 completed: Verified HSN table');
// // // // //             } catch (e) {
// // // // //               print('❌ Migration error: $e');
// // // // //               rethrow;
// // // // //             }
// // // // //           }),

// // // // //           Migration(4, 5, (database) async {
// // // // //             try {
// // // // //               print('✅ Migration 4→5 completed: Placeholder migration');
// // // // //             } catch (e) {
// // // // //               print('❌ Migration error: $e');
// // // // //               rethrow;
// // // // //             }
// // // // //           }),

// // // // //           // Migration from version 5 to 6 for staff table
// // // // //           Migration(5, 6, (database) async {
// // // // //             try {
// // // // //               await _createStaffTable(database);
// // // // //               print('✅ Migration 5→6 completed: Created staff table');
// // // // //             } catch (e) {
// // // // //               print('❌ Migration error: $e');
// // // // //               rethrow;
// // // // //             }
// // // // //           }),

// // // // //           // Migration from version 6 to 7 (Fallback for staff table)
// // // // //           Migration(6, 7, (database) async {
// // // // //             try {
// // // // //               // Ensure staff table exists
// // // // //               final result = await database.rawQuery(
// // // // //                 "SELECT name FROM sqlite_master WHERE type='table' AND name='staff'",
// // // // //               );

// // // // //               if (result.isEmpty) {
// // // // //                 print('⚠️ Staff table not found in migration 6→7, creating...');
// // // // //                 await _createStaffTable(database);
// // // // //               }

// // // // //               print('✅ Migration 6→7 completed: Verified staff table');
// // // // //             } catch (e) {
// // // // //               print('❌ Migration error: $e');
// // // // //               rethrow;
// // // // //             }
// // // // //           }),

// // // // //           // Migration from version 7 to 8 for bas_names table
// // // // //           Migration(7, 8, (database) async {
// // // // //             try {
// // // // //               await _createBasTable(database);
// // // // //               print('✅ Migration 7→8 completed: Created bas_names table');
// // // // //             } catch (e) {
// // // // //               print('❌ Migration error: $e');
// // // // //               rethrow;
// // // // //             }
// // // // //           }),

// // // // //           // Migration from version 8 to 9 (Fallback for bas table)
// // // // //           Migration(8, 9, (database) async {
// // // // //             try {
// // // // //               // Ensure bas table exists
// // // // //               final result = await database.rawQuery(
// // // // //                 "SELECT name FROM sqlite_master WHERE type='table' AND name='bas_names'",
// // // // //               );

// // // // //               if (result.isEmpty) {
// // // // //                 print('⚠️ Bas table not found in migration 8→9, creating...');
// // // // //                 await _createBasTable(database);
// // // // //               }

// // // // //               print('✅ Migration 8→9 completed: Verified bas_names table');
// // // // //             } catch (e) {
// // // // //               print('❌ Migration error: $e');
// // // // //               rethrow;
// // // // //             }
// // // // //           }),

// // // // //           // Migration from version 9 to 10 for payment_modes table
// // // // //           Migration(9, 10, (database) async {
// // // // //             try {
// // // // //               await _createPaymentModeTable(database);
// // // // //               print('✅ Migration 9→10 completed: Created payment_modes table');
// // // // //             } catch (e) {
// // // // //               print('❌ Migration error: $e');
// // // // //               rethrow;
// // // // //             }
// // // // //           }),

// // // // //           // Migration from version 10 to 11 (Fallback for payment mode table)
// // // // //           Migration(10, 11, (database) async {
// // // // //             try {
// // // // //               // Ensure payment mode table exists
// // // // //               final result = await database.rawQuery(
// // // // //                 "SELECT name FROM sqlite_master WHERE type='table' AND name='payment_modes'",
// // // // //               );

// // // // //               if (result.isEmpty) {
// // // // //                 print(
// // // // //                   '⚠️ Payment mode table not found in migration 10→11, creating...',
// // // // //                 );
// // // // //                 await _createPaymentModeTable(database);
// // // // //               }

// // // // //               print(
// // // // //                 '✅ Migration 10→11 completed: Verified payment_modes table',
// // // // //               );
// // // // //             } catch (e) {
// // // // //               print('❌ Migration error: $e');
// // // // //               rethrow;
// // // // //             }
// // // // //           }),

// // // // //           // Migration from version 11 to 12 for sample_types table
// // // // //           Migration(11, 12, (database) async {
// // // // //             try {
// // // // //               await _createSampleTypeTable(database);
// // // // //               print('✅ Migration 11→12 completed: Created sample_types table');
// // // // //             } catch (e) {
// // // // //               print('❌ Migration error: $e');
// // // // //               rethrow;
// // // // //             }
// // // // //           }),

// // // // //           // Migration from version 12 to 13 (Fallback for sample type table)
// // // // //           Migration(12, 13, (database) async {
// // // // //             try {
// // // // //               // Ensure sample type table exists
// // // // //               final result = await database.rawQuery(
// // // // //                 "SELECT name FROM sqlite_master WHERE type='table' AND name='sample_types'",
// // // // //               );

// // // // //               if (result.isEmpty) {
// // // // //                 print(
// // // // //                   '⚠️ Sample type table not found in migration 12→13, creating...',
// // // // //                 );
// // // // //                 await _createSampleTypeTable(database);
// // // // //               }

// // // // //               print('✅ Migration 12→13 completed: Verified sample_types table');
// // // // //             } catch (e) {
// // // // //               print('❌ Migration error: $e');
// // // // //               rethrow;
// // // // //             }
// // // // //           }),

// // // // //           // Migration from version 13 to 14 for branch_types table
// // // // //           Migration(13, 14, (database) async {
// // // // //             try {
// // // // //               await _createBranchTypeTable(database);
// // // // //               print('✅ Migration 13→14 completed: Created branch_types table');
// // // // //             } catch (e) {
// // // // //               print('❌ Migration error: $e');
// // // // //               rethrow;
// // // // //             }
// // // // //           }),

// // // // //           // Migration from version 14 to 15 (Fallback for branch type table)
// // // // //           Migration(14, 15, (database) async {
// // // // //             try {
// // // // //               // Ensure branch type table exists
// // // // //               final result = await database.rawQuery(
// // // // //                 "SELECT name FROM sqlite_master WHERE type='table' AND name='branch_types'",
// // // // //               );

// // // // //               if (result.isEmpty) {
// // // // //                 print(
// // // // //                   '⚠️ Branch type table not found in migration 14→15, creating...',
// // // // //                 );
// // // // //                 await _createBranchTypeTable(database);
// // // // //               }

// // // // //               print('✅ Migration 14→15 completed: Verified branch_types table');
// // // // //             } catch (e) {
// // // // //               print('❌ Migration error: $e');
// // // // //               rethrow;
// // // // //             }
// // // // //           }),

// // // // //           // Migration from version 15 to 16 for collection_centers table
// // // // //           Migration(15, 16, (database) async {
// // // // //             try {
// // // // //               await _createCollectionCenterTable(database);
// // // // //               print(
// // // // //                 '✅ Migration 15→16 completed: Created collection_centers table',
// // // // //               );
// // // // //             } catch (e) {
// // // // //               print('❌ Migration error: $e');
// // // // //               rethrow;
// // // // //             }
// // // // //           }),

// // // // //           // Migration from version 16 to 17 (Fallback for collection center table)
// // // // //           Migration(16, 17, (database) async {
// // // // //             try {
// // // // //               // Ensure collection center table exists
// // // // //               final result = await database.rawQuery(
// // // // //                 "SELECT name FROM sqlite_master WHERE type='table' AND name='collection_centers'",
// // // // //               );

// // // // //               if (result.isEmpty) {
// // // // //                 print(
// // // // //                   '⚠️ Collection center table not found in migration 16→17, creating...',
// // // // //                 );
// // // // //                 await _createCollectionCenterTable(database);
// // // // //               }

// // // // //               print(
// // // // //                 '✅ Migration 16→17 completed: Verified collection_centers table',
// // // // //               );
// // // // //             } catch (e) {
// // // // //               print('❌ Migration error: $e');
// // // // //               rethrow;
// // // // //             }
// // // // //           }),
// // // // //         ])
// // // // //         .addCallback(
// // // // //           Callback(
// // // // //             onCreate: (database, version) async {
// // // // //               print('🏗️ Creating all tables for version $version');
// // // // //               await _createAllTables(database);
// // // // //             },
// // // // //             onOpen: (database) async {
// // // // //               print('📂 Database opened');
// // // // //               await _verifyAllTables(database);
// // // // //             },
// // // // //           ),
// // // // //         )
// // // // //         .build();

// // // // //     // Verify all tables were created
// // // // //     await _verifyAllTables(_database!.database);

// // // // //     return _database!;
// // // // //   }

// // // // //   // Create HSN table method
// // // // //   static Future<void> _createHsnTable(DatabaseExecutor database) async {
// // // // //     try {
// // // // //       await database.execute('''
// // // // //         CREATE TABLE IF NOT EXISTS hsn_codes (
// // // // //           id INTEGER PRIMARY KEY AUTOINCREMENT,
// // // // //           server_id INTEGER,
// // // // //           hsn_code TEXT NOT NULL UNIQUE,
// // // // //           sgst REAL DEFAULT 0,
// // // // //           cgst REAL DEFAULT 0,
// // // // //           igst REAL DEFAULT 0,
// // // // //           cess REAL DEFAULT 0,
// // // // //           hsn_type INTEGER,
// // // // //           tenant TEXT,
// // // // //           tenant_id TEXT,
// // // // //           created_at TEXT NOT NULL,
// // // // //           created_by TEXT NOT NULL,
// // // // //           last_modified TEXT,
// // // // //           last_modified_by TEXT,
// // // // //           deleted TEXT,
// // // // //           deleted_by TEXT,
// // // // //           is_synced INTEGER DEFAULT 0,
// // // // //           is_deleted INTEGER DEFAULT 0,
// // // // //           sync_attempts INTEGER DEFAULT 0,
// // // // //           last_sync_error TEXT
// // // // //         )
// // // // //       ''');

// // // // //       // Create indexes
// // // // //       await database.execute('''
// // // // //         CREATE INDEX IF NOT EXISTS idx_hsn_code
// // // // //         ON hsn_codes(hsn_code)
// // // // //       ''');

// // // // //       await database.execute('''
// // // // //         CREATE INDEX IF NOT EXISTS idx_hsn_synced
// // // // //         ON hsn_codes(is_synced)
// // // // //       ''');

// // // // //       await database.execute('''
// // // // //         CREATE INDEX IF NOT EXISTS idx_hsn_deleted
// // // // //         ON hsn_codes(is_deleted)
// // // // //       ''');

// // // // //       print('✅ HSN table created successfully');
// // // // //     } catch (e) {
// // // // //       print('❌ Error creating HSN table: $e');
// // // // //       rethrow;
// // // // //     }
// // // // //   }

// // // // //   // Create staff table method
// // // // //   static Future<void> _createStaffTable(DatabaseExecutor database) async {
// // // // //     try {
// // // // //       await database.execute('''
// // // // //         CREATE TABLE IF NOT EXISTS staff (
// // // // //           id INTEGER PRIMARY KEY AUTOINCREMENT,
// // // // //           server_id INTEGER,
// // // // //           name TEXT NOT NULL,
// // // // //           department TEXT NOT NULL,
// // // // //           designation TEXT NOT NULL,
// // // // //           email TEXT,
// // // // //           phone TEXT NOT NULL,
// // // // //           required_credentials TEXT NOT NULL,
// // // // //           created_at TEXT NOT NULL,
// // // // //           created_by TEXT,
// // // // //           last_modified TEXT,
// // // // //           last_modified_by TEXT,
// // // // //           is_deleted INTEGER DEFAULT 0,
// // // // //           deleted_by TEXT,
// // // // //           is_synced INTEGER DEFAULT 0,
// // // // //           sync_status TEXT DEFAULT 'pending',
// // // // //           sync_attempts INTEGER DEFAULT 0,
// // // // //           last_sync_error TEXT
// // // // //         )
// // // // //       ''');

// // // // //       // Create indexes
// // // // //       await database.execute('''
// // // // //         CREATE INDEX IF NOT EXISTS idx_staff_name
// // // // //         ON staff(name)
// // // // //       ''');

// // // // //       await database.execute('''
// // // // //         CREATE INDEX IF NOT EXISTS idx_staff_department
// // // // //         ON staff(department)
// // // // //       ''');

// // // // //       await database.execute('''
// // // // //         CREATE INDEX IF NOT EXISTS idx_staff_designation
// // // // //         ON staff(designation)
// // // // //       ''');

// // // // //       await database.execute('''
// // // // //         CREATE INDEX IF NOT EXISTS idx_staff_synced
// // // // //         ON staff(is_synced)
// // // // //       ''');

// // // // //       await database.execute('''
// // // // //         CREATE INDEX IF NOT EXISTS idx_staff_deleted
// // // // //         ON staff(is_deleted)
// // // // //       ''');

// // // // //       print('✅ Staff table created successfully');
// // // // //     } catch (e) {
// // // // //       print('❌ Error creating staff table: $e');
// // // // //       rethrow;
// // // // //     }
// // // // //   }

// // // // //   // Create bas table method
// // // // //   static Future<void> _createBasTable(DatabaseExecutor database) async {
// // // // //     try {
// // // // //       await database.execute('''
// // // // //         CREATE TABLE IF NOT EXISTS bas_names (
// // // // //           id INTEGER PRIMARY KEY AUTOINCREMENT,
// // // // //           server_id INTEGER,
// // // // //           name TEXT NOT NULL,
// // // // //           created_at TEXT,
// // // // //           created_by TEXT,
// // // // //           last_modified TEXT,
// // // // //           last_modified_by TEXT,
// // // // //           is_deleted INTEGER DEFAULT 0,
// // // // //           deleted_by TEXT,
// // // // //           is_synced INTEGER DEFAULT 0,
// // // // //           sync_status TEXT DEFAULT 'pending',
// // // // //           sync_attempts INTEGER DEFAULT 0,
// // // // //           last_sync_error TEXT
// // // // //         )
// // // // //       ''');

// // // // //       await database.execute('''
// // // // //         CREATE INDEX IF NOT EXISTS idx_bas_name
// // // // //         ON bas_names(name)
// // // // //       ''');

// // // // //       await database.execute('''
// // // // //         CREATE INDEX IF NOT EXISTS idx_bas_synced
// // // // //         ON bas_names(is_synced)
// // // // //       ''');

// // // // //       await database.execute('''
// // // // //         CREATE INDEX IF NOT EXISTS idx_bas_deleted
// // // // //         ON bas_names(is_deleted)
// // // // //       ''');

// // // // //       print('✅ Bas table created successfully');
// // // // //     } catch (e) {
// // // // //       print('❌ Error creating Bas table: $e');
// // // // //       rethrow;
// // // // //     }
// // // // //   }

// // // // //   static Future<void> _createPaymentModeTable(DatabaseExecutor database) async {
// // // // //     try {
// // // // //       await database.execute('''
// // // // //         CREATE TABLE IF NOT EXISTS payment_modes (
// // // // //           id INTEGER PRIMARY KEY AUTOINCREMENT,
// // // // //           server_id INTEGER,
// // // // //           name TEXT NOT NULL,
// // // // //           description TEXT,
// // // // //           tenant_id TEXT,
// // // // //           created_at TEXT,
// // // // //           created_by TEXT,
// // // // //           last_modified TEXT,
// // // // //           last_modified_by TEXT,
// // // // //           is_deleted INTEGER DEFAULT 0,
// // // // //           deleted_by TEXT,
// // // // //           is_synced INTEGER DEFAULT 0,
// // // // //           sync_status TEXT DEFAULT 'pending',
// // // // //           sync_attempts INTEGER DEFAULT 0,
// // // // //           last_sync_error TEXT
// // // // //         )
// // // // //       ''');

// // // // //       // Create indexes
// // // // //       await database.execute('''
// // // // //         CREATE INDEX IF NOT EXISTS idx_payment_mode_name
// // // // //         ON payment_modes(name)
// // // // //       ''');

// // // // //       await database.execute('''
// // // // //         CREATE INDEX IF NOT EXISTS idx_payment_mode_synced
// // // // //         ON payment_modes(is_synced)
// // // // //       ''');

// // // // //       await database.execute('''
// // // // //         CREATE INDEX IF NOT EXISTS idx_payment_mode_deleted
// // // // //         ON payment_modes(is_deleted)
// // // // //       ''');

// // // // //       print('✅ Payment mode table created successfully');
// // // // //     } catch (e) {
// // // // //       print('❌ Error creating Payment mode table: $e');
// // // // //       rethrow;
// // // // //     }
// // // // //   }

// // // // //   // Create sample type table method
// // // // //   static Future<void> _createSampleTypeTable(DatabaseExecutor database) async {
// // // // //     try {
// // // // //       await database.execute('''
// // // // //         CREATE TABLE IF NOT EXISTS sample_types (
// // // // //           id INTEGER PRIMARY KEY AUTOINCREMENT,
// // // // //           server_id INTEGER,
// // // // //           name TEXT NOT NULL,
// // // // //           description TEXT,
// // // // //           created_at TEXT,
// // // // //           created_by TEXT,
// // // // //           last_modified TEXT,
// // // // //           last_modified_by TEXT,
// // // // //           is_deleted INTEGER DEFAULT 0,
// // // // //           deleted_by TEXT,
// // // // //           is_synced INTEGER DEFAULT 0,
// // // // //           sync_status TEXT DEFAULT 'pending',
// // // // //           sync_attempts INTEGER DEFAULT 0,
// // // // //           last_sync_error TEXT
// // // // //         )
// // // // //       ''');

// // // // //       // Create indexes
// // // // //       await database.execute('''
// // // // //         CREATE INDEX IF NOT EXISTS idx_sample_type_name
// // // // //         ON sample_types(name)
// // // // //       ''');

// // // // //       await database.execute('''
// // // // //         CREATE INDEX IF NOT EXISTS idx_sample_type_synced
// // // // //         ON sample_types(is_synced)
// // // // //       ''');

// // // // //       await database.execute('''
// // // // //         CREATE INDEX IF NOT EXISTS idx_sample_type_deleted
// // // // //         ON sample_types(is_deleted)
// // // // //       ''');

// // // // //       print('✅ Sample type table created successfully');
// // // // //     } catch (e) {
// // // // //       print('❌ Error creating Sample type table: $e');
// // // // //       rethrow;
// // // // //     }
// // // // //   }

// // // // //   // Create branch type table method
// // // // //   static Future<void> _createBranchTypeTable(DatabaseExecutor database) async {
// // // // //     try {
// // // // //       await database.execute('''
// // // // //         CREATE TABLE IF NOT EXISTS branch_types (
// // // // //           id INTEGER PRIMARY KEY AUTOINCREMENT,
// // // // //           server_id INTEGER,
// // // // //           company_name TEXT NOT NULL,
// // // // //           contact_person TEXT NOT NULL,
// // // // //           contact_no TEXT NOT NULL,
// // // // //           email TEXT NOT NULL,
// // // // //           address1 TEXT NOT NULL,
// // // // //           location TEXT NOT NULL,
// // // // //           type TEXT NOT NULL,
// // // // //           designation TEXT NOT NULL,
// // // // //           mobile_no TEXT NOT NULL,
// // // // //           address2 TEXT,
// // // // //           country TEXT NOT NULL,
// // // // //           state TEXT NOT NULL,
// // // // //           city TEXT NOT NULL,
// // // // //           created_at TEXT,
// // // // //           created_by TEXT,
// // // // //           last_modified TEXT,
// // // // //           last_modified_by TEXT,
// // // // //           is_deleted INTEGER DEFAULT 0,
// // // // //           deleted_by TEXT,
// // // // //           is_synced INTEGER DEFAULT 0,
// // // // //           sync_status TEXT DEFAULT 'pending',
// // // // //           sync_attempts INTEGER DEFAULT 0,
// // // // //           last_sync_error TEXT
// // // // //         )
// // // // //       ''');

// // // // //       // Create indexes
// // // // //       await database.execute('''
// // // // //         CREATE INDEX IF NOT EXISTS idx_branch_type_company
// // // // //         ON branch_types(company_name)
// // // // //       ''');

// // // // //       await database.execute('''
// // // // //         CREATE INDEX IF NOT EXISTS idx_branch_type_contact
// // // // //         ON branch_types(contact_person)
// // // // //       ''');

// // // // //       await database.execute('''
// // // // //         CREATE INDEX IF NOT EXISTS idx_branch_type_synced
// // // // //         ON branch_types(is_synced)
// // // // //       ''');

// // // // //       await database.execute('''
// // // // //         CREATE INDEX IF NOT EXISTS idx_branch_type_deleted
// // // // //         ON branch_types(is_deleted)
// // // // //       ''');

// // // // //       print('✅ Branch type table created successfully');
// // // // //     } catch (e) {
// // // // //       print('❌ Error creating branch type table: $e');
// // // // //       rethrow;
// // // // //     }
// // // // //   }

// // // // //   // Create collection center table method
// // // // //   static Future<void> _createCollectionCenterTable(
// // // // //     DatabaseExecutor database,
// // // // //   ) async {
// // // // //     try {
// // // // //       await database.execute('''
// // // // //         CREATE TABLE IF NOT EXISTS collection_centers (
// // // // //           id INTEGER PRIMARY KEY AUTOINCREMENT,
// // // // //           server_id INTEGER,
// // // // //           center_code TEXT NOT NULL,
// // // // //           center_name TEXT NOT NULL,
// // // // //           country TEXT NOT NULL,
// // // // //           state TEXT NOT NULL,
// // // // //           city TEXT NOT NULL,
// // // // //           address1 TEXT NOT NULL,
// // // // //           address2 TEXT,
// // // // //           location TEXT,
// // // // //           postal_code TEXT,
// // // // //           latitude REAL DEFAULT 0.0,
// // // // //           longitude REAL DEFAULT 0.0,
// // // // //           gst_number TEXT,
// // // // //           pan_number TEXT,
// // // // //           contact_person_name TEXT NOT NULL,
// // // // //           phone_no TEXT NOT NULL,
// // // // //           email TEXT,
// // // // //           centre_status TEXT NOT NULL,
// // // // //           branch_type_id INTEGER,
// // // // //           lab_affiliation_company TEXT,
// // // // //           operational_hours_from TEXT,
// // // // //           operational_hours_to TEXT,
// // // // //           collection_days TEXT,
// // // // //           sample_pickup_timing_from TEXT,
// // // // //           sample_pickup_timing_to TEXT,
// // // // //           transport_mode TEXT,
// // // // //           courier_agency_name TEXT,
// // // // //           commission_type TEXT,
// // // // //           commission_value REAL DEFAULT 0.0,
// // // // //           account_holder_name TEXT,
// // // // //           account_no TEXT,
// // // // //           ifsc_code TEXT,
// // // // //           agreement_file1_path TEXT,
// // // // //           agreement_file2_path TEXT,
// // // // //           created_at TEXT,
// // // // //           created_by TEXT,
// // // // //           last_modified TEXT,
// // // // //           last_modified_by TEXT,
// // // // //           is_deleted INTEGER DEFAULT 0,
// // // // //           deleted_by TEXT,
// // // // //           is_synced INTEGER DEFAULT 0,
// // // // //           sync_status TEXT DEFAULT 'pending',
// // // // //           sync_attempts INTEGER DEFAULT 0,
// // // // //           last_sync_error TEXT
// // // // //         )
// // // // //       ''');

// // // // //       // Create indexes
// // // // //       await database.execute('''
// // // // //         CREATE INDEX IF NOT EXISTS idx_collection_center_code
// // // // //         ON collection_centers(center_code)
// // // // //       ''');

// // // // //       await database.execute('''
// // // // //         CREATE INDEX IF NOT EXISTS idx_collection_center_name
// // // // //         ON collection_centers(center_name)
// // // // //       ''');

// // // // //       await database.execute('''
// // // // //         CREATE INDEX IF NOT EXISTS idx_collection_center_status
// // // // //         ON collection_centers(centre_status)
// // // // //       ''');

// // // // //       await database.execute('''
// // // // //         CREATE INDEX IF NOT EXISTS idx_collection_center_city
// // // // //         ON collection_centers(city)
// // // // //       ''');

// // // // //       await database.execute('''
// // // // //         CREATE INDEX IF NOT EXISTS idx_collection_center_synced
// // // // //         ON collection_centers(is_synced)
// // // // //       ''');

// // // // //       await database.execute('''
// // // // //         CREATE INDEX IF NOT EXISTS idx_collection_center_deleted
// // // // //         ON collection_centers(is_deleted)
// // // // //       ''');

// // // // //       print('✅ Collection center table created successfully');
// // // // //     } catch (e) {
// // // // //       print('❌ Error creating collection center table: $e');
// // // // //       rethrow;
// // // // //     }
// // // // //   }

// // // // //   static Future<void> emergencyFixForStaff() async {
// // // // //     try {
// // // // //       print('🆘 EMERGENCY FIX FOR STAFF TABLE...');

// // // // //       final db = await database;

// // // // //       // Check if staff table exists
// // // // //       final result = await db.database.rawQuery(
// // // // //         "SELECT name FROM sqlite_master WHERE type='table' AND name='staff'",
// // // // //       );

// // // // //       if (result.isEmpty) {
// // // // //         print('❌ Staff table NOT found! Creating with direct SQL...');

// // // // //         // Direct SQL से table create करें (bypassing migrations)
// // // // //         await db.database.execute('''
// // // // //           CREATE TABLE IF NOT EXISTS staff (
// // // // //             id INTEGER PRIMARY KEY AUTOINCREMENT,
// // // // //             server_id INTEGER,
// // // // //             name TEXT NOT NULL,
// // // // //             department TEXT NOT NULL,
// // // // //             designation TEXT NOT NULL,
// // // // //             email TEXT,
// // // // //             phone TEXT NOT NULL,
// // // // //             required_credentials TEXT NOT NULL,
// // // // //             created_at TEXT NOT NULL,
// // // // //             created_by TEXT,
// // // // //             last_modified TEXT,
// // // // //             last_modified_by TEXT,
// // // // //             is_deleted INTEGER DEFAULT 0,
// // // // //             deleted_by TEXT,
// // // // //             is_synced INTEGER DEFAULT 0,
// // // // //             sync_status TEXT DEFAULT 'pending',
// // // // //             sync_attempts INTEGER DEFAULT 0,
// // // // //             last_sync_error TEXT
// // // // //           )
// // // // //         ''');

// // // // //         // Create indexes
// // // // //         await db.database.execute('''
// // // // //           CREATE INDEX IF NOT EXISTS idx_staff_name ON staff(name)
// // // // //         ''');

// // // // //         await db.database.execute('''
// // // // //           CREATE INDEX IF NOT EXISTS idx_staff_department ON staff(department)
// // // // //         ''');

// // // // //         await db.database.execute('''
// // // // //           CREATE INDEX IF NOT EXISTS idx_staff_designation ON staff(designation)
// // // // //         ''');

// // // // //         await db.database.execute('''
// // // // //           CREATE INDEX IF NOT EXISTS idx_staff_synced ON staff(is_synced)
// // // // //         ''');

// // // // //         await db.database.execute('''
// // // // //           CREATE INDEX IF NOT EXISTS idx_staff_deleted ON staff(is_deleted)
// // // // //         ''');

// // // // //         print('✅ Staff table created via DIRECT SQL (bypassing migrations)');
// // // // //       } else {
// // // // //         print('✅ Staff table already exists');
// // // // //       }
// // // // //     } catch (e) {
// // // // //       print('❌ Emergency fix failed: $e');
// // // // //     }
// // // // //   }

// // // // //   // Create all tables
// // // // //   static Future<void> _createAllTables(DatabaseExecutor database) async {
// // // // //     try {
// // // // //       print('🏗️ Creating all tables from scratch...');

// // // // //       // Create categories table
// // // // //       await database.execute('''
// // // // //         CREATE TABLE IF NOT EXISTS categories (
// // // // //           id INTEGER PRIMARY KEY AUTOINCREMENT,
// // // // //           server_id INTEGER,
// // // // //           category_name TEXT NOT NULL,
// // // // //           created_at TEXT,
// // // // //           created_by TEXT,
// // // // //           last_modified TEXT,
// // // // //           last_modified_by TEXT,
// // // // //           is_deleted INTEGER DEFAULT 0,
// // // // //           deleted_by TEXT,
// // // // //           is_synced INTEGER DEFAULT 0,
// // // // //           sync_status TEXT DEFAULT 'pending'
// // // // //         )
// // // // //       ''');

// // // // //       // Create subcategories table
// // // // //       await database.execute('''
// // // // //         CREATE TABLE IF NOT EXISTS subcategories (
// // // // //           id INTEGER PRIMARY KEY AUTOINCREMENT,
// // // // //           server_id INTEGER,
// // // // //           name TEXT NOT NULL,
// // // // //           category_id INTEGER NOT NULL,
// // // // //           category_server_id INTEGER,
// // // // //           category_name TEXT,
// // // // //           created_at TEXT,
// // // // //           created_by TEXT,
// // // // //           last_modified TEXT,
// // // // //           last_modified_by TEXT,
// // // // //           is_deleted INTEGER DEFAULT 0,
// // // // //           deleted_by TEXT,
// // // // //           is_synced INTEGER DEFAULT 0,
// // // // //           sync_status TEXT DEFAULT 'pending'
// // // // //         )
// // // // //       ''');

// // // // //       // Create HSN table
// // // // //       await _createHsnTable(database);

// // // // //       // Create staff table
// // // // //       await _createStaffTable(database);

// // // // //       // Create bas table
// // // // //       await _createBasTable(database);

// // // // //       // Create payment mode table
// // // // //       await _createPaymentModeTable(database);

// // // // //       // Create sample type table
// // // // //       await _createSampleTypeTable(database);

// // // // //       // Create branch type table
// // // // //       await _createBranchTypeTable(database);

// // // // //       // Create collection center table
// // // // //       await _createCollectionCenterTable(database);

// // // // //       print('✅ All tables created successfully');
// // // // //     } catch (e) {
// // // // //       print('❌ Error creating tables: $e');
// // // // //       rethrow;
// // // // //     }
// // // // //   }

// // // // //   // Verify all tables exist
// // // // //   static Future<void> _verifyAllTables(DatabaseExecutor database) async {
// // // // //     try {
// // // // //       // Get all tables
// // // // //       final tables = await database.rawQuery(
// // // // //         "SELECT name FROM sqlite_master WHERE type='table'",
// // // // //       );

// // // // //       final tableNames = tables.map((t) => t['name'] as String).toList();
// // // // //       print('📋 Found tables: $tableNames');

// // // // //       // Check categories table
// // // // //       if (!tableNames.contains('categories')) {
// // // // //         print('⚠️ Categories table missing, creating...');
// // // // //         await database.execute('''
// // // // //           CREATE TABLE IF NOT EXISTS categories (
// // // // //             id INTEGER PRIMARY KEY AUTOINCREMENT,
// // // // //             server_id INTEGER,
// // // // //             category_name TEXT NOT NULL,
// // // // //             created_at TEXT,
// // // // //             created_by TEXT,
// // // // //             last_modified TEXT,
// // // // //             last_modified_by TEXT,
// // // // //             is_deleted INTEGER DEFAULT 0,
// // // // //             deleted_by TEXT,
// // // // //             is_synced INTEGER DEFAULT 0,
// // // // //             sync_status TEXT DEFAULT 'pending'
// // // // //           )
// // // // //         ''');
// // // // //       }

// // // // //       // Check subcategories table
// // // // //       if (!tableNames.contains('subcategories')) {
// // // // //         print('⚠️ Subcategories table missing, creating...');
// // // // //         await database.execute('''
// // // // //           CREATE TABLE IF NOT EXISTS subcategories (
// // // // //             id INTEGER PRIMARY KEY AUTOINCREMENT,
// // // // //             server_id INTEGER,
// // // // //             name TEXT NOT NULL,
// // // // //             category_id INTEGER NOT NULL,
// // // // //             category_server_id INTEGER,
// // // // //             category_name TEXT,
// // // // //             created_at TEXT,
// // // // //             created_by TEXT,
// // // // //             last_modified TEXT,
// // // // //             last_modified_by TEXT,
// // // // //             is_deleted INTEGER DEFAULT 0,
// // // // //             deleted_by TEXT,
// // // // //             is_synced INTEGER DEFAULT 0,
// // // // //             sync_status TEXT DEFAULT 'pending'
// // // // //           )
// // // // //         ''');
// // // // //       }

// // // // //       // Check hsn_codes table
// // // // //       if (!tableNames.contains('hsn_codes')) {
// // // // //         print('⚠️ HSN Codes table missing, creating...');
// // // // //         await _createHsnTable(database);
// // // // //       }

// // // // //       // Check staff table
// // // // //       if (!tableNames.contains('staff')) {
// // // // //         print('⚠️ Staff table missing, creating...');
// // // // //         await _createStaffTable(database);
// // // // //       }

// // // // //       // Check bas table
// // // // //       if (!tableNames.contains('bas_names')) {
// // // // //         print('⚠️ Bas table missing, creating...');
// // // // //         await _createBasTable(database);
// // // // //       }

// // // // //       // Check payment modes table
// // // // //       if (!tableNames.contains('payment_modes')) {
// // // // //         print('⚠️ Payment modes table missing, creating...');
// // // // //         await _createPaymentModeTable(database);
// // // // //       }

// // // // //       // Check sample types table
// // // // //       if (!tableNames.contains('sample_types')) {
// // // // //         print('⚠️ Sample types table missing, creating...');
// // // // //         await _createSampleTypeTable(database);
// // // // //       }

// // // // //       // Check branch types table
// // // // //       if (!tableNames.contains('branch_types')) {
// // // // //         print('⚠️ Branch types table missing, creating...');
// // // // //         await _createBranchTypeTable(database);
// // // // //       }

// // // // //       // Check collection centers table
// // // // //       if (!tableNames.contains('collection_centers')) {
// // // // //         print('⚠️ Collection centers table missing, creating...');
// // // // //         await _createCollectionCenterTable(database);
// // // // //       }

// // // // //       print('✅ All tables verified successfully');
// // // // //     } catch (e) {
// // // // //       print('❌ Table verification error: $e');
// // // // //     }
// // // // //   }

// // // // //   // Repository getters
// // // // //   static Future<UserRepository> get userRepository async {
// // // // //     final db = await database;
// // // // //     _userRepository ??= UserRepository(db);
// // // // //     return _userRepository!;
// // // // //   }

// // // // //   static Future<CountryRepository> get countryRepository async {
// // // // //     final db = await database;
// // // // //     _countryRepository ??= CountryRepository(db.countryDao);
// // // // //     return _countryRepository!;
// // // // //   }

// // // // //   static Future<StateRepository> get stateRepository async {
// // // // //     final db = await database;
// // // // //     _stateRepository ??= StateRepository(db.stateDao);
// // // // //     return _stateRepository!;
// // // // //   }

// // // // //   static Future<CityRepository> get cityRepository async {
// // // // //     final db = await database;
// // // // //     _cityRepository ??= CityRepository(db.cityDao);
// // // // //     return _cityRepository!;
// // // // //   }

// // // // //   static Future<CategoryRepository> get categoryRepository async {
// // // // //     final db = await database;
// // // // //     _categoryRepository ??= CategoryRepository(db.categoryDao);
// // // // //     return _categoryRepository!;
// // // // //   }

// // // // //   static Future<SubCategoryRepository> get subCategoryRepository async {
// // // // //     final db = await database;
// // // // //     _subCategoryRepository ??= SubCategoryRepository(db.subcategoryDao);
// // // // //     return _subCategoryRepository!;
// // // // //   }

// // // // //   static Future<HsnRepository> get hsnRepository async {
// // // // //     final db = await database;
// // // // //     _hsnRepository ??= HsnRepository(db.hsnDao);
// // // // //     return _hsnRepository!;
// // // // //   }

// // // // //   static Future<StaffRepository> get staffRepository async {
// // // // //     final db = await database;
// // // // //     _staffRepository ??= StaffRepository(db.staffDao);
// // // // //     return _staffRepository!;
// // // // //   }

// // // // //   static Future<BasRepository> get basRepository async {
// // // // //     final db = await database;
// // // // //     _basRepository ??= BasRepository(db.basDao);
// // // // //     return _basRepository!;
// // // // //   }

// // // // //   static Future<PaymentModeRepository> get paymentModeRepository async {
// // // // //     final db = await database;
// // // // //     _paymentModeRepository ??= PaymentModeRepository(db.paymentModeDao);
// // // // //     return _paymentModeRepository!;
// // // // //   }

// // // // //   static Future<SampleTypeRepository> get sampleTypeRepository async {
// // // // //     final db = await database;
// // // // //     _sampleTypeRepository ??= SampleTypeRepository(db.sampleTypeDao);
// // // // //     return _sampleTypeRepository!;
// // // // //   }

// // // // //   // Add BranchTypeRepository getter
// // // // //   static Future<BranchTypeRepository> get branchTypeRepository async {
// // // // //     final db = await database;
// // // // //     _branchTypeRepository ??= BranchTypeRepository(db.branchTypeDao);
// // // // //     return _branchTypeRepository!;
// // // // //   }

// // // // //   // Add CollectionCenterRepository getter
// // // // //   static Future<CollectionCenterRepository>
// // // // //   get collectionCenterRepository async {
// // // // //     final db = await database;
// // // // //     _collectionCenterRepository ??= CollectionCenterRepository(
// // // // //       db.collectionCenterDao,
// // // // //     );
// // // // //     return _collectionCenterRepository!;
// // // // //   }

// // // // //   // Emergency function to create staff table directly
// // // // // static Future<void> createStaffTableDirectly() async {
// // // // //   try {
// // // // //     print('🆘 EMERGENCY: Creating staff table directly...');

// // // // //     final db = await database;

// // // // //     // First check if table exists
// // // // //     final exists = await checkStaffTableExists();
// // // // //     if (exists) {
// // // // //       print('✅ Staff table already exists');
// // // // //       return;
// // // // //     }

// // // // //     print('🔄 Creating staff table...');
// // // // //     await _createStaffTable(db.database);

// // // // //     // Verify
// // // // //     final test = await db.database.query('staff', limit: 1);
// // // // //     print('✅ Staff table verified, row count: ${test.length}');
// // // // //   } catch (e) {
// // // // //     print('❌ Direct creation failed: $e');
// // // // //     rethrow;
// // // // //   }
// // // // // }

// // // // //   // Emergency function to create bas table directly
// // // // // static Future<void> createBasTableDirectly() async {
// // // // //   try {
// // // // //     print('🆘 EMERGENCY: Creating bas table directly...');

// // // // //     final db = await database;

// // // // //     // First check if table exists
// // // // //     final exists = await checkBasTableExists();
// // // // //     if (exists) {
// // // // //       print('✅ Bas table already exists');
// // // // //       return;
// // // // //     }

// // // // //     print('🔄 Creating bas table...');
// // // // //     await _createBasTable(db.database);

// // // // //     // Verify
// // // // //     final test = await db.database.query('bas_names', limit: 1);
// // // // //     print('✅ Bas table verified, row count: ${test.length}');
// // // // //   } catch (e) {
// // // // //     print('❌ Direct creation failed: $e');
// // // // //     rethrow;
// // // // //   }
// // // // // }

// // // // //   // Emergency function to create payment mode table directly
// // // // // static Future<void> createPaymentModeTableDirectly() async {
// // // // //   try {
// // // // //     print('🆘 EMERGENCY: Creating payment mode table directly...');

// // // // //     final db = await database;

// // // // //     // First check if table exists
// // // // //     final exists = await checkPaymentModeTableExists();
// // // // //     if (exists) {
// // // // //       print('✅ Payment mode table already exists');
// // // // //       return;
// // // // //     }

// // // // //     print('🔄 Creating payment mode table...');
// // // // //     await _createPaymentModeTable(db.database);

// // // // //     // Verify
// // // // //     final test = await db.database.query('payment_modes', limit: 1);
// // // // //     print('✅ Payment mode table verified, row count: ${test.length}');
// // // // //   } catch (e) {
// // // // //     print('❌ Direct creation failed: $e');
// // // // //     rethrow;
// // // // //   }
// // // // // }

// // // // //   // Emergency function to create sample type table directly
// // // // // static Future<void> createSampleTypeTableDirectly() async {
// // // // //   try {
// // // // //     print('🆘 EMERGENCY: Creating sample type table directly...');

// // // // //     final db = await database;

// // // // //     // First check if table exists
// // // // //     final exists = await checkSampleTypeTableExists();
// // // // //     if (exists) {
// // // // //       print('✅ Sample type table already exists');
// // // // //       return;
// // // // //     }

// // // // //     print('🔄 Creating sample type table...');
// // // // //     await _createSampleTypeTable(db.database);

// // // // //     // Verify
// // // // //     final test = await db.database.query('sample_types', limit: 1);
// // // // //     print('✅ Sample type table verified, row count: ${test.length}');
// // // // //   } catch (e) {
// // // // //     print('❌ Direct creation failed: $e');
// // // // //     rethrow;
// // // // //   }
// // // // // }

// // // // //   // Emergency function to create branch type table directly
// // // // // static Future<void> createBranchTypeTableDirectly() async {
// // // // //   try {
// // // // //     print('🆘 EMERGENCY: Creating branch type table directly...');

// // // // //     final db = await database;

// // // // //     // First check if table exists
// // // // //     final exists = await checkBranchTypeTableExists();
// // // // //     if (exists) {
// // // // //       print('✅ Branch type table already exists');
// // // // //       return;
// // // // //     }

// // // // //     print('🔄 Creating branch type table...');
// // // // //     await _createBranchTypeTable(db.database);

// // // // //     // Verify
// // // // //     final test = await db.database.query('branch_types', limit: 1);
// // // // //     print('✅ Branch type table verified, row count: ${test.length}');
// // // // //   } catch (e) {
// // // // //     print('❌ Direct creation failed: $e');
// // // // //     rethrow;
// // // // //   }
// // // // // }

// // // // //   // Emergency function to create collection center table directly
// // // // // static Future<void> createCollectionCenterTableDirectly() async {
// // // // //   try {
// // // // //     print('🆘 EMERGENCY: Creating collection center table directly...');

// // // // //     final db = await database;

// // // // //     // First check if table exists
// // // // //     final exists = await checkCollectionCenterTableExists();
// // // // //     if (exists) {
// // // // //       print('✅ Collection center table already exists');
// // // // //       return;
// // // // //     }

// // // // //     print('🔄 Creating collection center table...');
// // // // //     await _createCollectionCenterTable(db.database);

// // // // //     // Verify
// // // // //     final test = await db.database.query('collection_centers', limit: 1);
// // // // //     print('✅ Collection center table verified, row count: ${test.length}');
// // // // //   } catch (e) {
// // // // //     print('❌ Direct creation failed: $e');
// // // // //     rethrow;
// // // // //   }
// // // // // }

// // // // //   // Check if staff table exists
// // // // // static Future<bool> checkStaffTableExists() async {
// // // // //   try {
// // // // //     final db = await database;
// // // // //     final result = await db.database.rawQuery(
// // // // //       "SELECT name FROM sqlite_master WHERE type='table' AND name='staff'",
// // // // //     );
// // // // //     return result.isNotEmpty;
// // // // //   } catch (e) {
// // // // //     print('❌ Error checking staff table: $e');
// // // // //     return false;
// // // // //   }
// // // // // }

// // // // //   // Check if bas table exists
// // // // // static Future<bool> checkBasTableExists() async {
// // // // //   try {
// // // // //     final db = await database;
// // // // //     final result = await db.database.rawQuery(
// // // // //       "SELECT name FROM sqlite_master WHERE type='table' AND name='bas_names'",
// // // // //     );
// // // // //     return result.isNotEmpty;
// // // // //   } catch (e) {
// // // // //     print('❌ Error checking bas table: $e');
// // // // //     return false;
// // // // //   }
// // // // // }

// // // // //   // Check if payment mode table exists
// // // // // static Future<bool> checkPaymentModeTableExists() async {
// // // // //   try {
// // // // //     final db = await database;
// // // // //     final result = await db.database.rawQuery(
// // // // //       "SELECT name FROM sqlite_master WHERE type='table' AND name='payment_modes'",
// // // // //     );
// // // // //     return result.isNotEmpty;
// // // // //   } catch (e) {
// // // // //     print('❌ Error checking payment mode table: $e');
// // // // //     return false;
// // // // //   }
// // // // // }

// // // // //   // Check if sample type table exists
// // // // // static Future<bool> checkSampleTypeTableExists() async {
// // // // //   try {
// // // // //     final db = await database;
// // // // //     final result = await db.database.rawQuery(
// // // // //       "SELECT name FROM sqlite_master WHERE type='table' AND name='sample_types'",
// // // // //     );
// // // // //     return result.isNotEmpty;
// // // // //   } catch (e) {
// // // // //     print('❌ Error checking sample type table: $e');
// // // // //     return false;
// // // // //   }
// // // // // }

// // // // //   // Check if branch type table exists
// // // // // static Future<bool> checkBranchTypeTableExists() async {
// // // // //   try {
// // // // //     final db = await database;
// // // // //     final result = await db.database.rawQuery(
// // // // //       "SELECT name FROM sqlite_master WHERE type='table' AND name='branch_types'",
// // // // //     );
// // // // //     return result.isNotEmpty;
// // // // //   } catch (e) {
// // // // //     print('❌ Error checking branch type table: $e');
// // // // //     return false;
// // // // //   }
// // // // // }

// // // // //   // Check if collection center table exists
// // // // // static Future<bool> checkCollectionCenterTableExists() async {
// // // // //   try {
// // // // //     final db = await database;
// // // // //     final result = await db.database.rawQuery(
// // // // //       "SELECT name FROM sqlite_master WHERE type='table' AND name='collection_centers'",
// // // // //     );
// // // // //     return result.isNotEmpty;
// // // // //   } catch (e) {
// // // // //     print('❌ Error checking collection center table: $e');
// // // // //     return false;
// // // // //   }
// // // // // }

// // // // //   // Initialize database with retry mechanism
// // // // // static Future<void> initializeDatabaseWithRetry() async {
// // // // //   try {
// // // // //     print('🔄 Initializing database...');
// // // // //     final db = await database;

// // // // //     // Force table creation if needed
// // // // //     await _forceCreateTablesIfMissing(db);

// // // // //     print('✅ Database initialized successfully');
// // // // //   } catch (e) {
// // // // //     print('❌ Database initialization failed: $e');
// // // // //     print('🔄 Retrying with clean database...');
// // // // //     await _recreateDatabase();
// // // // //   }
// // // // // }

// // // // // static Future<void> _forceCreateTablesIfMissing(AppDatabase db) async {
// // // // //   try {
// // // // //     // Create categories table if missing
// // // // //     await db.database.execute('''
// // // // //       CREATE TABLE IF NOT EXISTS categories (
// // // // //         id INTEGER PRIMARY KEY AUTOINCREMENT,
// // // // //         server_id INTEGER,
// // // // //         category_name TEXT NOT NULL,
// // // // //         created_at TEXT,
// // // // //         created_by TEXT,
// // // // //         last_modified TEXT,
// // // // //         last_modified_by TEXT,
// // // // //         is_deleted INTEGER DEFAULT 0,
// // // // //         deleted_by TEXT,
// // // // //         is_synced INTEGER DEFAULT 0,
// // // // //         sync_status TEXT DEFAULT 'pending'
// // // // //       )
// // // // //     ''');

// // // // //     // Create subcategories table if missing
// // // // //     await db.database.execute('''
// // // // //       CREATE TABLE IF NOT EXISTS subcategories (
// // // // //         id INTEGER PRIMARY KEY AUTOINCREMENT,
// // // // //         server_id INTEGER,
// // // // //         name TEXT NOT NULL,
// // // // //         category_id INTEGER NOT NULL,
// // // // //         category_server_id INTEGER,
// // // // //         category_name TEXT,
// // // // //         created_at TEXT,
// // // // //         created_by TEXT,
// // // // //         last_modified TEXT,
// // // // //         last_modified_by TEXT,
// // // // //         is_deleted INTEGER DEFAULT 0,
// // // // //         deleted_by TEXT,
// // // // //         is_synced INTEGER DEFAULT 0,
// // // // //         sync_status TEXT DEFAULT 'pending'
// // // // //       )
// // // // //     ''');

// // // // //     await _createHsnTable(db.database);
// // // // //     await _createStaffTable(db.database);
// // // // //     await _createBasTable(db.database);
// // // // //     await _createPaymentModeTable(db.database);
// // // // //     await _createSampleTypeTable(db.database);
// // // // //     await _createBranchTypeTable(db.database);
// // // // //     await _createCollectionCenterTable(db.database); // Add this

// // // // //     print('✅ All tables created/verified successfully');
// // // // //   } catch (e) {
// // // // //     print('❌ Error creating tables: $e');
// // // // //     rethrow;
// // // // //   }
// // // // // }

// // // // //   static Future<void> ensureStaffTableExists() async {
// // // // //     try {
// // // // //       print('🔍 Checking staff table...');

// // // // //       final db = await database;

// // // // //       // Direct SQL से table check करें
// // // // //       final result = await db.database.rawQuery(
// // // // //         "SELECT name FROM sqlite_master WHERE type='table' AND name='staff'",
// // // // //       );

// // // // //       if (result.isEmpty) {
// // // // //         print('❌ Staff table NOT found! Creating immediately...');

// // // // //         // Direct SQL से table create करें
// // // // //         await db.database.execute('''
// // // // //         CREATE TABLE staff (
// // // // //           id INTEGER PRIMARY KEY AUTOINCREMENT,
// // // // //           server_id INTEGER,
// // // // //           name TEXT NOT NULL,
// // // // //           department TEXT NOT NULL,
// // // // //           designation TEXT NOT NULL,
// // // // //           email TEXT,
// // // // //           phone TEXT NOT NULL,
// // // // //           required_credentials TEXT NOT NULL,
// // // // //           created_at TEXT NOT NULL,
// // // // //           created_by TEXT,
// // // // //           last_modified TEXT,
// // // // //           last_modified_by TEXT,
// // // // //           is_deleted INTEGER DEFAULT 0,
// // // // //           deleted_by TEXT,
// // // // //           is_synced INTEGER DEFAULT 0,
// // // // //           sync_status TEXT DEFAULT 'pending',
// // // // //           sync_attempts INTEGER DEFAULT 0,
// // // // //           last_sync_error TEXT
// // // // //         )
// // // // //       ''');

// // // // //         print('✅ Staff table created successfully via direct SQL');
// // // // //       } else {
// // // // //         print('✅ Staff table already exists');
// // // // //       }
// // // // //     } catch (e) {
// // // // //       print('❌ Error in ensureStaffTableExists: $e');
// // // // //     }
// // // // //   }

// // // // //   static Future<void> ensureBasTableExists() async {
// // // // //     try {
// // // // //       print('🔍 Checking bas table...');

// // // // //       final db = await database;

// // // // //       // Direct SQL से table check करें
// // // // //       final result = await db.database.rawQuery(
// // // // //         "SELECT name FROM sqlite_master WHERE type='table' AND name='bas_names'",
// // // // //       );

// // // // //       if (result.isEmpty) {
// // // // //         print('❌ Bas table NOT found! Creating immediately...');

// // // // //         // Direct SQL से table create करें
// // // // //         await db.database.execute('''
// // // // //         CREATE TABLE bas_names (
// // // // //           id INTEGER PRIMARY KEY AUTOINCREMENT,
// // // // //           server_id INTEGER,
// // // // //           name TEXT NOT NULL,
// // // // //           created_at TEXT,
// // // // //           created_by TEXT,
// // // // //           last_modified TEXT,
// // // // //           last_modified_by TEXT,
// // // // //           is_deleted INTEGER DEFAULT 0,
// // // // //           deleted_by TEXT,
// // // // //           is_synced INTEGER DEFAULT 0,
// // // // //           sync_status TEXT DEFAULT 'pending',
// // // // //           sync_attempts INTEGER DEFAULT 0,
// // // // //           last_sync_error TEXT
// // // // //         )
// // // // //       ''');

// // // // //         // Create indexes
// // // // //         await db.database.execute('''
// // // // //           CREATE INDEX IF NOT EXISTS idx_bas_name ON bas_names(name)
// // // // //         ''');

// // // // //         await db.database.execute('''
// // // // //           CREATE INDEX IF NOT EXISTS idx_bas_synced ON bas_names(is_synced)
// // // // //         ''');

// // // // //         await db.database.execute('''
// // // // //           CREATE INDEX IF NOT EXISTS idx_bas_deleted ON bas_names(is_deleted)
// // // // //         ''');

// // // // //         print('✅ Bas table created successfully via direct SQL');
// // // // //       } else {
// // // // //         print('✅ Bas table already exists');
// // // // //       }
// // // // //     } catch (e) {
// // // // //       print('❌ Error in ensureBasTableExists: $e');
// // // // //     }
// // // // //   }

// // // // //   static Future<void> ensurePaymentModeTableExists() async {
// // // // //     try {
// // // // //       print('🔍 Checking payment mode table...');

// // // // //       final db = await database;

// // // // //       // Direct SQL से table check करें
// // // // //       final result = await db.database.rawQuery(
// // // // //         "SELECT name FROM sqlite_master WHERE type='table' AND name='payment_modes'",
// // // // //       );

// // // // //       if (result.isEmpty) {
// // // // //         print('❌ Payment mode table NOT found! Creating immediately...');

// // // // //         // Direct SQL से table create करें
// // // // //         await db.database.execute('''
// // // // //         CREATE TABLE payment_modes (
// // // // //           id INTEGER PRIMARY KEY AUTOINCREMENT,
// // // // //           server_id INTEGER,
// // // // //           name TEXT NOT NULL,
// // // // //           description TEXT,
// // // // //           tenant_id TEXT,
// // // // //           created_at TEXT,
// // // // //           created_by TEXT,
// // // // //           last_modified TEXT,
// // // // //           last_modified_by TEXT,
// // // // //           is_deleted INTEGER DEFAULT 0,
// // // // //           deleted_by TEXT,
// // // // //           is_synced INTEGER DEFAULT 0,
// // // // //           sync_status TEXT DEFAULT 'pending',
// // // // //           sync_attempts INTEGER DEFAULT 0,
// // // // //           last_sync_error TEXT
// // // // //         )
// // // // //       ''');

// // // // //         // Create indexes
// // // // //         await db.database.execute('''
// // // // //           CREATE INDEX IF NOT EXISTS idx_payment_mode_name ON payment_modes(name)
// // // // //         ''');

// // // // //         await db.database.execute('''
// // // // //           CREATE INDEX IF NOT EXISTS idx_payment_mode_synced ON payment_modes(is_synced)
// // // // //         ''');

// // // // //         await db.database.execute('''
// // // // //           CREATE INDEX IF NOT EXISTS idx_payment_mode_deleted ON payment_modes(is_deleted)
// // // // //         ''');

// // // // //         print('✅ Payment mode table created successfully via direct SQL');
// // // // //       } else {
// // // // //         print('✅ Payment mode table already exists');
// // // // //       }
// // // // //     } catch (e) {
// // // // //       print('❌ Error in ensurePaymentModeTableExists: $e');
// // // // //     }
// // // // //   }

// // // // //   static Future<void> ensureSampleTypeTableExists() async {
// // // // //     try {
// // // // //       print('🔍 Checking sample type table...');

// // // // //       final db = await database;

// // // // //       // Direct SQL से table check करें
// // // // //       final result = await db.database.rawQuery(
// // // // //         "SELECT name FROM sqlite_master WHERE type='table' AND name='sample_types'",
// // // // //       );

// // // // //       if (result.isEmpty) {
// // // // //         print('❌ Sample type table NOT found! Creating immediately...');

// // // // //         // Direct SQL से table create करें
// // // // //         await db.database.execute('''
// // // // //         CREATE TABLE sample_types (
// // // // //           id INTEGER PRIMARY KEY AUTOINCREMENT,
// // // // //           server_id INTEGER,
// // // // //           name TEXT NOT NULL,
// // // // //           description TEXT,
// // // // //           created_at TEXT,
// // // // //           created_by TEXT,
// // // // //           last_modified TEXT,
// // // // //           last_modified_by TEXT,
// // // // //           is_deleted INTEGER DEFAULT 0,
// // // // //           deleted_by TEXT,
// // // // //           is_synced INTEGER DEFAULT 0,
// // // // //           sync_status TEXT DEFAULT 'pending',
// // // // //           sync_attempts INTEGER DEFAULT 0,
// // // // //           last_sync_error TEXT
// // // // //         )
// // // // //       ''');

// // // // //         // Create indexes
// // // // //         await db.database.execute('''
// // // // //           CREATE INDEX IF NOT EXISTS idx_sample_type_name ON sample_types(name)
// // // // //         ''');

// // // // //         await db.database.execute('''
// // // // //           CREATE INDEX IF NOT EXISTS idx_sample_type_synced ON sample_types(is_synced)
// // // // //         ''');

// // // // //         await db.database.execute('''
// // // // //           CREATE INDEX IF NOT EXISTS idx_sample_type_deleted ON sample_types(is_deleted)
// // // // //         ''');

// // // // //         print('✅ Sample type table created successfully via direct SQL');
// // // // //       } else {
// // // // //         print('✅ Sample type table already exists');
// // // // //       }
// // // // //     } catch (e) {
// // // // //       print('❌ Error in ensureSampleTypeTableExists: $e');
// // // // //     }
// // // // //   }

// // // // //   static Future<void> ensureBranchTypeTableExists() async {
// // // // //     try {
// // // // //       print('🔍 Checking branch type table...');

// // // // //       final db = await database;

// // // // //       // Direct SQL से table check करें
// // // // //       final result = await db.database.rawQuery(
// // // // //         "SELECT name FROM sqlite_master WHERE type='table' AND name='branch_types'",
// // // // //       );

// // // // //       if (result.isEmpty) {
// // // // //         print('❌ Branch type table NOT found! Creating immediately...');

// // // // //         // Direct SQL से table create करें
// // // // //         await db.database.execute('''
// // // // //         CREATE TABLE branch_types (
// // // // //           id INTEGER PRIMARY KEY AUTOINCREMENT,
// // // // //           server_id INTEGER,
// // // // //           company_name TEXT NOT NULL,
// // // // //           contact_person TEXT NOT NULL,
// // // // //           contact_no TEXT NOT NULL,
// // // // //           email TEXT NOT NULL,
// // // // //           address1 TEXT NOT NULL,
// // // // //           location TEXT NOT NULL,
// // // // //           type TEXT NOT NULL,
// // // // //           designation TEXT NOT NULL,
// // // // //           mobile_no TEXT NOT NULL,
// // // // //           address2 TEXT,
// // // // //           country TEXT NOT NULL,
// // // // //           state TEXT NOT NULL,
// // // // //           city TEXT NOT NULL,
// // // // //           created_at TEXT,
// // // // //           created_by TEXT,
// // // // //           last_modified TEXT,
// // // // //           last_modified_by TEXT,
// // // // //           is_deleted INTEGER DEFAULT 0,
// // // // //           deleted_by TEXT,
// // // // //           is_synced INTEGER DEFAULT 0,
// // // // //           sync_status TEXT DEFAULT 'pending',
// // // // //           sync_attempts INTEGER DEFAULT 0,
// // // // //           last_sync_error TEXT
// // // // //         )
// // // // //       ''');

// // // // //         // Create indexes
// // // // //         await db.database.execute('''
// // // // //           CREATE INDEX IF NOT EXISTS idx_branch_type_company ON branch_types(company_name)
// // // // //         ''');

// // // // //         await db.database.execute('''
// // // // //           CREATE INDEX IF NOT EXISTS idx_branch_type_contact ON branch_types(contact_person)
// // // // //         ''');

// // // // //         await db.database.execute('''
// // // // //           CREATE INDEX IF NOT EXISTS idx_branch_type_synced ON branch_types(is_synced)
// // // // //         ''');

// // // // //         await db.database.execute('''
// // // // //           CREATE INDEX IF NOT EXISTS idx_branch_type_deleted ON branch_types(is_deleted)
// // // // //         ''');

// // // // //         print('✅ Branch type table created successfully via direct SQL');
// // // // //       } else {
// // // // //         print('✅ Branch type table already exists');
// // // // //       }
// // // // //     } catch (e) {
// // // // //       print('❌ Error in ensureBranchTypeTableExists: $e');
// // // // //     }
// // // // //   }

// // // // //   static Future<void> ensureCollectionCenterTableExists() async {
// // // // //     try {
// // // // //       print('🔍 Checking collection center table...');
// // // // //       final db = await database;
// // // // //       final result = await db.database.rawQuery(
// // // // //         "SELECT name FROM sqlite_master WHERE type='table' AND name='collection_centers'",
// // // // //       );

// // // // //       if (result.isEmpty) {
// // // // //         print('❌ Collection center table NOT found! Creating immediately...');

// // // // //         await db.database.execute('''
// // // // //         CREATE TABLE collection_centers (
// // // // //           id INTEGER PRIMARY KEY AUTOINCREMENT,
// // // // //           server_id INTEGER,
// // // // //           center_code TEXT NOT NULL,
// // // // //           center_name TEXT NOT NULL,
// // // // //           country TEXT NOT NULL,
// // // // //           state TEXT NOT NULL,
// // // // //           city TEXT NOT NULL,
// // // // //           address1 TEXT NOT NULL,
// // // // //           address2 TEXT,
// // // // //           location TEXT,
// // // // //           postal_code TEXT,
// // // // //           latitude REAL DEFAULT 0.0,
// // // // //           longitude REAL DEFAULT 0.0,
// // // // //           gst_number TEXT,
// // // // //           pan_number TEXT,
// // // // //           contact_person_name TEXT NOT NULL,
// // // // //           phone_no TEXT NOT NULL,
// // // // //           email TEXT,
// // // // //           centre_status TEXT NOT NULL,
// // // // //           branch_type_id INTEGER,
// // // // //           lab_affiliation_company TEXT,
// // // // //           operational_hours_from TEXT,
// // // // //           operational_hours_to TEXT,
// // // // //           collection_days TEXT,
// // // // //           sample_pickup_timing_from TEXT,
// // // // //           sample_pickup_timing_to TEXT,
// // // // //           transport_mode TEXT,
// // // // //           courier_agency_name TEXT,
// // // // //           commission_type TEXT,
// // // // //           commission_value REAL DEFAULT 0.0,
// // // // //           account_holder_name TEXT,
// // // // //           account_no TEXT,
// // // // //           ifsc_code TEXT,
// // // // //           agreement_file1_path TEXT,
// // // // //           agreement_file2_path TEXT,
// // // // //           created_at TEXT,
// // // // //           created_by TEXT,
// // // // //           last_modified TEXT,
// // // // //           last_modified_by TEXT,
// // // // //           is_deleted INTEGER DEFAULT 0,
// // // // //           deleted_by TEXT,
// // // // //           is_synced INTEGER DEFAULT 0,
// // // // //           sync_status TEXT DEFAULT 'pending',
// // // // //           sync_attempts INTEGER DEFAULT 0,
// // // // //           last_sync_error TEXT
// // // // //         )
// // // // //       ''');

// // // // //         await db.database.execute('''
// // // // //           CREATE INDEX IF NOT EXISTS idx_collection_center_code ON collection_centers(center_code)
// // // // //         ''');

// // // // //         await db.database.execute('''
// // // // //           CREATE INDEX IF NOT EXISTS idx_collection_center_name ON collection_centers(center_name)
// // // // //         ''');

// // // // //         await db.database.execute('''
// // // // //           CREATE INDEX IF NOT EXISTS idx_collection_center_status ON collection_centers(centre_status)
// // // // //         ''');

// // // // //         await db.database.execute('''
// // // // //           CREATE INDEX IF NOT EXISTS idx_collection_center_city ON collection_centers(city)
// // // // //         ''');

// // // // //         await db.database.execute('''
// // // // //           CREATE INDEX IF NOT EXISTS idx_collection_center_synced ON collection_centers(is_synced)
// // // // //         ''');

// // // // //         await db.database.execute('''
// // // // //           CREATE INDEX IF NOT EXISTS idx_collection_center_deleted ON collection_centers(is_deleted)
// // // // //         ''');

// // // // //         print('✅ Collection center table created successfully via direct SQL');
// // // // //       } else {
// // // // //         print('✅ Collection center table already exists');
// // // // //       }
// // // // //     } catch (e) {
// // // // //       print('❌ Error in ensureCollectionCenterTableExists: $e');
// // // // //     }
// // // // //   }

// // // // // static Future<void> initializeStaffScreen() async {
// // // // //   try {
// // // // //     print('🚀 Initializing staff screen...');
// // // // //     await ensureStaffTableExists();
// // // // //     await debugDatabase();

// // // // //     print('✅ Staff screen ready!');
// // // // //   } catch (e) {
// // // // //     print('❌ Staff initialization failed: $e');
// // // // //   }
// // // // // }

// // // // // static Future<void> initializeBasScreen() async {
// // // // //   try {
// // // // //     print('🚀 Initializing bas screen...');
// // // // //     await ensureBasTableExists();
// // // // //     await debugDatabase();

// // // // //     print('✅ Bas screen ready!');
// // // // //   } catch (e) {
// // // // //     print('❌ Bas initialization failed: $e');
// // // // //   }
// // // // // }

// // // // // static Future<void> initializePaymentModeScreen() async {
// // // // //   try {
// // // // //     print('🚀 Initializing payment mode screen...');
// // // // //     await ensurePaymentModeTableExists();
// // // // //     await debugDatabase();

// // // // //     print('✅ Payment mode screen ready!');
// // // // //   } catch (e) {
// // // // //     print('❌ Payment mode initialization failed: $e');
// // // // //   }
// // // // // }

// // // // // static Future<void> initializeSampleTypeScreen() async {
// // // // //   try {
// // // // //     print('🚀 Initializing sample type screen...');
// // // // //     await ensureSampleTypeTableExists();
// // // // //     await debugDatabase();

// // // // //     print('✅ Sample type screen ready!');
// // // // //   } catch (e) {
// // // // //     print('❌ Sample type initialization failed: $e');
// // // // //   }
// // // // // }

// // // // // static Future<void> initializeBranchTypeScreen() async {
// // // // //   try {
// // // // //     print('🚀 Initializing branch type screen...');
// // // // //     await ensureBranchTypeTableExists();
// // // // //     await debugDatabase();

// // // // //     print('✅ Branch type screen ready!');
// // // // //   } catch (e) {
// // // // //     print('❌ Branch type initialization failed: $e');
// // // // //   }
// // // // // }

// // // // // static Future<void> initializeCollectionCenterScreen() async {
// // // // //   try {
// // // // //     print('🚀 Initializing collection center screen...');
// // // // //     await ensureCollectionCenterTableExists();
// // // // //     await debugDatabase();
// // // // //     print('✅ Collection center screen ready!');
// // // // //   } catch (e) {
// // // // //     print('❌ Collection center initialization failed: $e');
// // // // //   }
// // // // // }

// // // // //   static Future<void> _recreateDatabase() async {
// // // // //     try {
// // // // //       if (_database != null) {
// // // // //         await _database!.close();
// // // // //         _database = null;
// // // // //       }
// // // // //       final databasesPath = await getDatabasesPath();
// // // // //       final dbPath = '$databasesPath/database.db';
// // // // //       final dbFile = File(dbPath);
// // // // //       if (await dbFile.exists()) {
// // // // //         await dbFile.delete();
// // // // //         print('🗑️ Deleted old database file');
// // // // //       }
// // // // //       try {
// // // // //         final shmFile = File('$dbPath-shm');
// // // // //         final walFile = File('$dbPath-wal');
// // // // //         if (await shmFile.exists()) await shmFile.delete();
// // // // //         if (await walFile.exists()) await walFile.delete();
// // // // //       } catch (e) {
// // // // //         print('Note: Could not delete shm/wal files: $e');
// // // // //       }
// // // // //       _userRepository = null;
// // // // //       _countryRepository = null;
// // // // //       _stateRepository = null;
// // // // //       _cityRepository = null;
// // // // //       _categoryRepository = null;
// // // // //       _subCategoryRepository = null;
// // // // //       _hsnRepository = null;
// // // // //       _staffRepository = null;
// // // // //       _basRepository = null;
// // // // //       _paymentModeRepository = null;
// // // // //       _sampleTypeRepository = null;
// // // // //       _branchTypeRepository = null;
// // // // //       _collectionCenterRepository = null; // Add this
// // // // //       _database = null;
// // // // //       await database;
// // // // //       print('✅ Database recreated successfully');
// // // // //     } catch (e) {
// // // // //       print('❌ Error recreating database: $e');
// // // // //       rethrow;
// // // // //     }
// // // // //   }

// // // // //   static Future<void> resetDatabase() async {
// // // // //     await _recreateDatabase();
// // // // //   }

// // // // //   static Future<void> closeDatabase() async {
// // // // //     if (_database != null) {
// // // // //       await _database!.close();
// // // // //       _database = null;
// // // // //       _userRepository = null;
// // // // //       _countryRepository = null;
// // // // //       _stateRepository = null;
// // // // //       _cityRepository = null;
// // // // //       _categoryRepository = null;
// // // // //       _subCategoryRepository = null;
// // // // //       _hsnRepository = null;
// // // // //       _staffRepository = null;
// // // // //       _basRepository = null;
// // // // //       _paymentModeRepository = null;
// // // // //       _sampleTypeRepository = null;
// // // // //       _branchTypeRepository = null;
// // // // //       _collectionCenterRepository = null; // Add this
// // // // //     }
// // // // //   }

// // // // // static Future<void> createHsnTableDirectly() async {
// // // // //   try {
// // // // //     print('🆘 EMERGENCY: Creating HSN table directly...');
// // // // //     final db = await database;
// // // // //     try {
// // // // //       await db.database.execute('DROP TABLE IF EXISTS hsn_codes');
// // // // //     } catch (_) {}
// // // // //     await _createHsnTable(db.database);
// // // // //     print('✅ HSN table created via direct SQL');
// // // // //     final test = await db.database.query('hsn_codes', limit: 1);
// // // // //     print('✅ Table verified, row count: ${test.length}');
// // // // //   } catch (e) {
// // // // //     print('❌ Direct creation failed: $e');
// // // // //     rethrow;
// // // // //   }
// // // // // }

// // // // // static Future<bool> checkHsnTableExists() async {
// // // // //   try {
// // // // //     final db = await database;
// // // // //     final result = await db.database.rawQuery(
// // // // //       "SELECT name FROM sqlite_master WHERE type='table' AND name='hsn_codes'",
// // // // //     );
// // // // //     return result.isNotEmpty;
// // // // //   } catch (e) {
// // // // //     print('❌ Error checking HSN table: $e');
// // // // //     return false;
// // // // //   }
// // // // // }

// // // // //   static Future<List<String>> getAllTableNames() async {
// // // // //     try {
// // // // //       final db = await database;
// // // // //       final result = await db.database.rawQuery(
// // // // //         "SELECT name FROM sqlite_master WHERE type='table' ORDER BY name",
// // // // //       );
// // // // //       return result.map((row) => row['name'] as String).toList();
// // // // //     } catch (e) {
// // // // //       print('❌ Error getting tables: $e');
// // // // //       return [];
// // // // //     }
// // // // //   }

// // // // // static Future<void> executeRawSQL(String sql) async {
// // // // //   try {
// // // // //     final db = await database;
// // // // //     await db.database.execute(sql);
// // // // //     print('✅ SQL executed: $sql');
// // // // //   } catch (e) {
// // // // //     print('❌ SQL execution failed: $e');
// // // // //     rethrow;
// // // // //   }
// // // // // }

// // // // //   static Future<void> debugDatabase() async {
// // // // //     try {
// // // // //       print('🔍 DEBUGGING DATABASE...');
// // // // //       final db = await database;
// // // // //       final versionResult = await db.database.rawQuery('PRAGMA user_version');
// // // // //       final version = versionResult.first['user_version'];
// // // // //       print('📊 Database version: $version');
// // // // //       final tables = await getAllTableNames();
// // // // //       print('📋 All tables: $tables');
// // // // //       for (var table in tables) {
// // // // //         final countResult = await db.database.rawQuery(
// // // // //           'SELECT COUNT(*) as count FROM $table',
// // // // //         );
// // // // //         final count = countResult.first['count'];
// // // // //         print('   - $table: $count rows');
// // // // //       }
// // // // //     } catch (e) {
// // // // //       print('❌ Debug failed: $e');
// // // // //     }
// // // // //   }
// // // // // }

// // // // // ignore_for_file: avoid_print

// // // // import 'dart:io';
// // // // import 'package:floor/floor.dart';
// // // // import 'package:nanohospic/database/app_database.dart';
// // // // import 'package:nanohospic/database/repository/branch_type_repo.dart';
// // // // import 'package:nanohospic/database/repository/city_repo.dart';
// // // // import 'package:nanohospic/database/repository/country_repo.dart';
// // // // import 'package:nanohospic/database/repository/group_repo.dart'; // Add this
// // // // import 'package:nanohospic/database/repository/hsn_repo.dart';
// // // // import 'package:nanohospic/database/repository/item_cat_repo.dart';
// // // // import 'package:nanohospic/database/repository/patient_identity_repo.dart';
// // // // import 'package:nanohospic/database/repository/payment_mode_repo.dart';
// // // // import 'package:nanohospic/database/repository/refrerrer_repo.dart';
// // // // import 'package:nanohospic/database/repository/sample_type_repo.dart';
// // // // import 'package:nanohospic/database/repository/staff_repo.dart';
// // // // import 'package:nanohospic/database/repository/state_repo.dart';
// // // // import 'package:nanohospic/database/repository/sucategory_rep.dart';
// // // // import 'package:nanohospic/database/repository/test_bom_repo.dart';
// // // // import 'package:nanohospic/database/repository/user_reposetory.dart';
// // // // import 'package:nanohospic/database/repository/collection_center_repo.dart';
// // // // import 'package:sqflite/sqflite.dart';

// // // // class DatabaseProvider {
// // // //   static final DatabaseProvider _instance = DatabaseProvider._internal();
// // // //   factory DatabaseProvider() => _instance;
// // // //   DatabaseProvider._internal();

// // // //   static AppDatabase? _database;
// // // //   static UserRepository? _userRepository;
// // // //   static StaffRepository? _staffRepository;
// // // //   static CountryRepository? _countryRepository;
// // // //   static StateRepository? _stateRepository;
// // // //   static CityRepository? _cityRepository;
// // // //   static CategoryRepository? _categoryRepository;
// // // //   static SubCategoryRepository? _subCategoryRepository;
// // // //   static HsnRepository? _hsnRepository;
// // // //   static BasRepository? _basRepository;
// // // //   static PaymentModeRepository? _paymentModeRepository;
// // // //   static SampleTypeRepository? _sampleTypeRepository;
// // // //   static BranchTypeRepository? _branchTypeRepository;
// // // //   static CollectionCenterRepository? _collectionCenterRepository;
// // // //   static ReferrerRepository? _referrerRepository;
// // // //   static GroupRepo? _groupRepository;
// // // //   static TestBOMRepository? _testBOMRepository;

// // // //   static Future<TestBOMRepository> get testBOMRepository async {
// // // //   final db = await database;
// // // //   _testBOMRepository ??= TestBOMRepository(db);
// // // //   return _testBOMRepository!;
// // // // }

// // // //   static Future<AppDatabase> get database async {
// // // //     if (_database != null) return _database!;

// // // //     _database = await $FloorAppDatabase
// // // //         .databaseBuilder('database.db')
// // // //         .addMigrations([
// // // //           Migration(1, 2, (database) async {
// // // //             try {
// // // //               await database.execute('''
// // // //                 CREATE TABLE IF NOT EXISTS categories (
// // // //                   id INTEGER PRIMARY KEY AUTOINCREMENT,
// // // //                   server_id INTEGER,
// // // //                   category_name TEXT NOT NULL,
// // // //                   created_at TEXT,
// // // //                   created_by TEXT,
// // // //                   last_modified TEXT,
// // // //                   last_modified_by TEXT,
// // // //                   is_deleted INTEGER DEFAULT 0,
// // // //                   deleted_by TEXT,
// // // //                   is_synced INTEGER DEFAULT 0,
// // // //                   sync_status TEXT DEFAULT 'pending'
// // // //                 )
// // // //               ''');

// // // //               await database.execute('''
// // // //                 CREATE TABLE IF NOT EXISTS subcategories (
// // // //                   id INTEGER PRIMARY KEY AUTOINCREMENT,
// // // //                   server_id INTEGER,
// // // //                   name TEXT NOT NULL,
// // // //                   category_id INTEGER NOT NULL,
// // // //                   category_server_id INTEGER,
// // // //                   category_name TEXT,
// // // //                   created_at TEXT,
// // // //                   created_by TEXT,
// // // //                   last_modified TEXT,
// // // //                   last_modified_by TEXT,
// // // //                   is_deleted INTEGER DEFAULT 0,
// // // //                   deleted_by TEXT,
// // // //                   is_synced INTEGER DEFAULT 0,
// // // //                   sync_status TEXT DEFAULT 'pending'
// // // //                 )
// // // //               ''');

// // // //               print(
// // // //                 '✅ Migration 1→2 completed: Created categories and subcategories tables',
// // // //               );
// // // //             } catch (e) {
// // // //               print('❌ Migration error: $e');
// // // //               rethrow;
// // // //             }
// // // //           }),

// // // //           Migration(2, 3, (database) async {
// // // //             try {
// // // //               await _createHsnTable(database);
// // // //               print('✅ Migration 2→3 completed: Created hsn_codes table');
// // // //             } catch (e) {
// // // //               print('❌ Migration error: $e');
// // // //               rethrow;
// // // //             }
// // // //           }),

// // // //           Migration(3, 4, (database) async {
// // // //             try {
// // // //               final result = await database.rawQuery(
// // // //                 "SELECT name FROM sqlite_master WHERE type='table' AND name='hsn_codes'",
// // // //               );
// // // //               if (result.isEmpty) {
// // // //                 print('⚠️ HSN table not found in migration 3→4, creating...');
// // // //                 await _createHsnTable(database);
// // // //               }
// // // //               print('✅ Migration 3→4 completed: Verified HSN table');
// // // //             } catch (e) {
// // // //               print('❌ Migration error: $e');
// // // //               rethrow;
// // // //             }
// // // //           }),

// // // //           Migration(4, 5, (database) async {
// // // //             try {
// // // //               print('✅ Migration 4→5 completed: Placeholder migration');
// // // //             } catch (e) {
// // // //               print('❌ Migration error: $e');
// // // //               rethrow;
// // // //             }
// // // //           }),

// // // //           Migration(5, 6, (database) async {
// // // //             try {
// // // //               await _createStaffTable(database);
// // // //               print('✅ Migration 5→6 completed: Created staff table');
// // // //             } catch (e) {
// // // //               print('❌ Migration error: $e');
// // // //               rethrow;
// // // //             }
// // // //           }),

// // // //           Migration(6, 7, (database) async {
// // // //             try {
// // // //               final result = await database.rawQuery(
// // // //                 "SELECT name FROM sqlite_master WHERE type='table' AND name='staff'",
// // // //               );

// // // //               if (result.isEmpty) {
// // // //                 print('⚠️ Staff table not found in migration 6→7, creating...');
// // // //                 await _createStaffTable(database);
// // // //               }

// // // //               print('✅ Migration 6→7 completed: Verified staff table');
// // // //             } catch (e) {
// // // //               print('❌ Migration error: $e');
// // // //               rethrow;
// // // //             }
// // // //           }),

// // // //           Migration(7, 8, (database) async {
// // // //             try {
// // // //               await _createBasTable(database);
// // // //               print('✅ Migration 7→8 completed: Created bas_names table');
// // // //             } catch (e) {
// // // //               print('❌ Migration error: $e');
// // // //               rethrow;
// // // //             }
// // // //           }),

// // // //           Migration(8, 9, (database) async {
// // // //             try {
// // // //               final result = await database.rawQuery(
// // // //                 "SELECT name FROM sqlite_master WHERE type='table' AND name='bas_names'",
// // // //               );

// // // //               if (result.isEmpty) {
// // // //                 print('⚠️ Bas table not found in migration 8→9, creating...');
// // // //                 await _createBasTable(database);
// // // //               }

// // // //               print('✅ Migration 8→9 completed: Verified bas_names table');
// // // //             } catch (e) {
// // // //               print('❌ Migration error: $e');
// // // //               rethrow;
// // // //             }
// // // //           }),

// // // //           Migration(9, 10, (database) async {
// // // //             try {
// // // //               await _createPaymentModeTable(database);
// // // //               print('✅ Migration 9→10 completed: Created payment_modes table');
// // // //             } catch (e) {
// // // //               print('❌ Migration error: $e');
// // // //               rethrow;
// // // //             }
// // // //           }),

// // // //           Migration(10, 11, (database) async {
// // // //             try {
// // // //               final result = await database.rawQuery(
// // // //                 "SELECT name FROM sqlite_master WHERE type='table' AND name='payment_modes'",
// // // //               );

// // // //               if (result.isEmpty) {
// // // //                 print(
// // // //                   '⚠️ Payment mode table not found in migration 10→11, creating...',
// // // //                 );
// // // //                 await _createPaymentModeTable(database);
// // // //               }

// // // //               print(
// // // //                 '✅ Migration 10→11 completed: Verified payment_modes table',
// // // //               );
// // // //             } catch (e) {
// // // //               print('❌ Migration error: $e');
// // // //               rethrow;
// // // //             }
// // // //           }),

// // // //           Migration(11, 12, (database) async {
// // // //             try {
// // // //               await _createSampleTypeTable(database);
// // // //               print('✅ Migration 11→12 completed: Created sample_types table');
// // // //             } catch (e) {
// // // //               print('❌ Migration error: $e');
// // // //               rethrow;
// // // //             }
// // // //           }),

// // // //           Migration(12, 13, (database) async {
// // // //             try {
// // // //               final result = await database.rawQuery(
// // // //                 "SELECT name FROM sqlite_master WHERE type='table' AND name='sample_types'",
// // // //               );

// // // //               if (result.isEmpty) {
// // // //                 print(
// // // //                   '⚠️ Sample type table not found in migration 12→13, creating...',
// // // //                 );
// // // //                 await _createSampleTypeTable(database);
// // // //               }

// // // //               print('✅ Migration 12→13 completed: Verified sample_types table');
// // // //             } catch (e) {
// // // //               print('❌ Migration error: $e');
// // // //               rethrow;
// // // //             }
// // // //           }),

// // // //           Migration(13, 14, (database) async {
// // // //             try {
// // // //               await _createBranchTypeTable(database);
// // // //               print('✅ Migration 13→14 completed: Created branch_types table');
// // // //             } catch (e) {
// // // //               print('❌ Migration error: $e');
// // // //               rethrow;
// // // //             }
// // // //           }),

// // // //           Migration(14, 15, (database) async {
// // // //             try {
// // // //               final result = await database.rawQuery(
// // // //                 "SELECT name FROM sqlite_master WHERE type='table' AND name='branch_types'",
// // // //               );

// // // //               if (result.isEmpty) {
// // // //                 print(
// // // //                   '⚠️ Branch type table not found in migration 14→15, creating...',
// // // //                 );
// // // //                 await _createBranchTypeTable(database);
// // // //               }

// // // //               print('✅ Migration 14→15 completed: Verified branch_types table');
// // // //             } catch (e) {
// // // //               print('❌ Migration error: $e');
// // // //               rethrow;
// // // //             }
// // // //           }),

// // // //           Migration(15, 16, (database) async {
// // // //             try {
// // // //               await _createCollectionCenterTable(database);
// // // //               print(
// // // //                 '✅ Migration 15→16 completed: Created collection_centers table',
// // // //               );
// // // //             } catch (e) {
// // // //               print('❌ Migration error: $e');
// // // //               rethrow;
// // // //             }
// // // //           }),

// // // //           Migration(16, 17, (database) async {
// // // //             try {
// // // //               final result = await database.rawQuery(
// // // //                 "SELECT name FROM sqlite_master WHERE type='table' AND name='collection_centers'",
// // // //               );

// // // //               if (result.isEmpty) {
// // // //                 print(
// // // //                   '⚠️ Collection center table not found in migration 16→17, creating...',
// // // //                 );
// // // //                 await _createCollectionCenterTable(database);
// // // //               }

// // // //               print(
// // // //                 '✅ Migration 16→17 completed: Verified collection_centers table',
// // // //               );
// // // //             } catch (e) {
// // // //               print('❌ Migration error: $e');
// // // //               rethrow;
// // // //             }
// // // //           }),

// // // //           // Add new migration for groups table
// // // //           Migration(17, 18, (database) async {
// // // //             try {
// // // //               await _createGroupTable(database);
// // // //               print('✅ Migration 17→18 completed: Created groups table');
// // // //             } catch (e) {
// // // //               print('❌ Migration error: $e');
// // // //               rethrow;
// // // //             }
// // // //           }),
// // // //           Migration(18, 19, (database) async {
// // // //             try {
// // // //               await _createTestTable(database);
// // // //               print('✅ Migration 18→19 completed: Created test table');
// // // //             } catch (e) {
// // // //               print('❌ Migration error: $e');
// // // //               rethrow;
// // // //             }
// // // //           }),
// // // //           Migration(19, 20, (database) async {
// // // //             try {
// // // //               await _createPackageTable(database);
// // // //               print('✅ Migration 19→20 completed: Created packages table');
// // // //             } catch (e) {
// // // //               print('❌ Migration error: $e');
// // // //               rethrow;
// // // //             }
// // // //           }),
// // // //           Migration(20, 21, (database) async {
// // // //             try {
// // // //               await _createTestBOMTable(database);
// // // //               print('✅ Migration 20→21 completed: Created test_boms table');
// // // //             } catch (e) {
// // // //               print('❌ Migration error: $e');
// // // //               rethrow;
// // // //             }
// // // //           }),
// // // //         ])
// // // //         .addCallback(
// // // //           Callback(
// // // //             onCreate: (database, version) async {
// // // //               print('🏗️ Creating all tables for version $version');
// // // //               await _createAllTables(database);
// // // //             },
// // // //             onOpen: (database) async {
// // // //               print('📂 Database opened');
// // // //               await _verifyAllTables(database);
// // // //             },
// // // //           ),
// // // //         )
// // // //         .build();

// // // //     // Verify all tables were created
// // // //     await _verifyAllTables(_database!.database);

// // // //     return _database!;
// // // //   }

// // // //   // Create Group table method
// // // //   static Future<void> _createGroupTable(DatabaseExecutor database) async {
// // // //     try {
// // // //       await database.execute('''
// // // //         CREATE TABLE IF NOT EXISTS groups (
// // // //           id INTEGER PRIMARY KEY AUTOINCREMENT,
// // // //           server_id INTEGER,
// // // //           name TEXT NOT NULL,
// // // //           description TEXT,
// // // //           code TEXT,
// // // //           type TEXT DEFAULT 'general',
// // // //           status TEXT DEFAULT 'active',
// // // //           tenant_id TEXT,
// // // //           created_at TEXT,
// // // //           created_by TEXT,
// // // //           last_modified TEXT,
// // // //           last_modified_by TEXT,
// // // //           is_deleted INTEGER DEFAULT 0,
// // // //           deleted_by TEXT,
// // // //           is_synced INTEGER DEFAULT 0,
// // // //           sync_status TEXT DEFAULT 'pending',
// // // //           sync_attempts INTEGER DEFAULT 0,
// // // //           last_sync_error TEXT
// // // //         )
// // // //       ''');

// // // //       // Create indexes
// // // //       await database.execute('''
// // // //         CREATE INDEX IF NOT EXISTS idx_group_name
// // // //         ON groups(name)
// // // //       ''');

// // // //       await database.execute('''
// // // //         CREATE INDEX IF NOT EXISTS idx_group_code
// // // //         ON groups(code)
// // // //       ''');

// // // //       await database.execute('''
// // // //         CREATE INDEX IF NOT EXISTS idx_group_type
// // // //         ON groups(type)
// // // //       ''');

// // // //       await database.execute('''
// // // //         CREATE INDEX IF NOT EXISTS idx_group_synced
// // // //         ON groups(is_synced)
// // // //       ''');

// // // //       await database.execute('''
// // // //         CREATE INDEX IF NOT EXISTS idx_group_deleted
// // // //         ON groups(is_deleted)
// // // //       ''');

// // // //       print('✅ Groups table created successfully');
// // // //     } catch (e) {
// // // //       print('❌ Error creating groups table: $e');
// // // //       rethrow;
// // // //     }
// // // //   }

// // // //   // Create HSN table method
// // // //   static Future<void> _createHsnTable(DatabaseExecutor database) async {
// // // //     try {
// // // //       await database.execute('''
// // // //         CREATE TABLE IF NOT EXISTS hsn_codes (
// // // //           id INTEGER PRIMARY KEY AUTOINCREMENT,
// // // //           server_id INTEGER,
// // // //           hsn_code TEXT NOT NULL UNIQUE,
// // // //           sgst REAL DEFAULT 0,
// // // //           cgst REAL DEFAULT 0,
// // // //           igst REAL DEFAULT 0,
// // // //           cess REAL DEFAULT 0,
// // // //           hsn_type INTEGER,
// // // //           tenant TEXT,
// // // //           tenant_id TEXT,
// // // //           created_at TEXT NOT NULL,
// // // //           created_by TEXT NOT NULL,
// // // //           last_modified TEXT,
// // // //           last_modified_by TEXT,
// // // //           deleted TEXT,
// // // //           deleted_by TEXT,
// // // //           is_synced INTEGER DEFAULT 0,
// // // //           is_deleted INTEGER DEFAULT 0,
// // // //           sync_attempts INTEGER DEFAULT 0,
// // // //           last_sync_error TEXT
// // // //         )
// // // //       ''');

// // // //       // Create indexes
// // // //       await database.execute('''
// // // //         CREATE INDEX IF NOT EXISTS idx_hsn_code
// // // //         ON hsn_codes(hsn_code)
// // // //       ''');

// // // //       await database.execute('''
// // // //         CREATE INDEX IF NOT EXISTS idx_hsn_synced
// // // //         ON hsn_codes(is_synced)
// // // //       ''');

// // // //       await database.execute('''
// // // //         CREATE INDEX IF NOT EXISTS idx_hsn_deleted
// // // //         ON hsn_codes(is_deleted)
// // // //       ''');

// // // //       print('✅ HSN table created successfully');
// // // //     } catch (e) {
// // // //       print('❌ Error creating HSN table: $e');
// // // //       rethrow;
// // // //     }
// // // //   }

// // // //   // Create staff table method
// // // //   static Future<void> _createStaffTable(DatabaseExecutor database) async {
// // // //     try {
// // // //       await database.execute('''
// // // //         CREATE TABLE IF NOT EXISTS staff (
// // // //           id INTEGER PRIMARY KEY AUTOINCREMENT,
// // // //           server_id INTEGER,
// // // //           name TEXT NOT NULL,
// // // //           department TEXT NOT NULL,
// // // //           designation TEXT NOT NULL,
// // // //           email TEXT,
// // // //           phone TEXT NOT NULL,
// // // //           required_credentials TEXT NOT NULL,
// // // //           created_at TEXT NOT NULL,
// // // //           created_by TEXT,
// // // //           last_modified TEXT,
// // // //           last_modified_by TEXT,
// // // //           is_deleted INTEGER DEFAULT 0,
// // // //           deleted_by TEXT,
// // // //           is_synced INTEGER DEFAULT 0,
// // // //           sync_status TEXT DEFAULT 'pending',
// // // //           sync_attempts INTEGER DEFAULT 0,
// // // //           last_sync_error TEXT
// // // //         )
// // // //       ''');

// // // //       // Create indexes
// // // //       await database.execute('''
// // // //         CREATE INDEX IF NOT EXISTS idx_staff_name
// // // //         ON staff(name)
// // // //       ''');

// // // //       await database.execute('''
// // // //         CREATE INDEX IF NOT EXISTS idx_staff_department
// // // //         ON staff(department)
// // // //       ''');

// // // //       await database.execute('''
// // // //         CREATE INDEX IF NOT EXISTS idx_staff_designation
// // // //         ON staff(designation)
// // // //       ''');

// // // //       await database.execute('''
// // // //         CREATE INDEX IF NOT EXISTS idx_staff_synced
// // // //         ON staff(is_synced)
// // // //       ''');

// // // //       await database.execute('''
// // // //         CREATE INDEX IF NOT EXISTS idx_staff_deleted
// // // //         ON staff(is_deleted)
// // // //       ''');

// // // //       print('✅ Staff table created successfully');
// // // //     } catch (e) {
// // // //       print('❌ Error creating staff table: $e');
// // // //       rethrow;
// // // //     }
// // // //   }

// // // //   // Create bas table method
// // // //   static Future<void> _createBasTable(DatabaseExecutor database) async {
// // // //     try {
// // // //       await database.execute('''
// // // //         CREATE TABLE IF NOT EXISTS bas_names (
// // // //           id INTEGER PRIMARY KEY AUTOINCREMENT,
// // // //           server_id INTEGER,
// // // //           name TEXT NOT NULL,
// // // //           created_at TEXT,
// // // //           created_by TEXT,
// // // //           last_modified TEXT,
// // // //           last_modified_by TEXT,
// // // //           is_deleted INTEGER DEFAULT 0,
// // // //           deleted_by TEXT,
// // // //           is_synced INTEGER DEFAULT 0,
// // // //           sync_status TEXT DEFAULT 'pending',
// // // //           sync_attempts INTEGER DEFAULT 0,
// // // //           last_sync_error TEXT
// // // //         )
// // // //       ''');

// // // //       // Create indexes
// // // //       await database.execute('''
// // // //         CREATE INDEX IF NOT EXISTS idx_bas_name
// // // //         ON bas_names(name)
// // // //       ''');

// // // //       await database.execute('''
// // // //         CREATE INDEX IF NOT EXISTS idx_bas_synced
// // // //         ON bas_names(is_synced)
// // // //       ''');

// // // //       await database.execute('''
// // // //         CREATE INDEX IF NOT EXISTS idx_bas_deleted
// // // //         ON bas_names(is_deleted)
// // // //       ''');

// // // //       print('✅ Bas table created successfully');
// // // //     } catch (e) {
// // // //       print('❌ Error creating Bas table: $e');
// // // //       rethrow;
// // // //     }
// // // //   }

// // // //   // Create payment mode table method
// // // //   static Future<void> _createPaymentModeTable(DatabaseExecutor database) async {
// // // //     try {
// // // //       await database.execute('''
// // // //         CREATE TABLE IF NOT EXISTS payment_modes (
// // // //           id INTEGER PRIMARY KEY AUTOINCREMENT,
// // // //           server_id INTEGER,
// // // //           name TEXT NOT NULL,
// // // //           description TEXT,
// // // //           tenant_id TEXT,
// // // //           created_at TEXT,
// // // //           created_by TEXT,
// // // //           last_modified TEXT,
// // // //           last_modified_by TEXT,
// // // //           is_deleted INTEGER DEFAULT 0,
// // // //           deleted_by TEXT,
// // // //           is_synced INTEGER DEFAULT 0,
// // // //           sync_status TEXT DEFAULT 'pending',
// // // //           sync_attempts INTEGER DEFAULT 0,
// // // //           last_sync_error TEXT
// // // //         )
// // // //       ''');

// // // //       // Create indexes
// // // //       await database.execute('''
// // // //         CREATE INDEX IF NOT EXISTS idx_payment_mode_name
// // // //         ON payment_modes(name)
// // // //       ''');

// // // //       await database.execute('''
// // // //         CREATE INDEX IF NOT EXISTS idx_payment_mode_synced
// // // //         ON payment_modes(is_synced)
// // // //       ''');

// // // //       await database.execute('''
// // // //         CREATE INDEX IF NOT EXISTS idx_payment_mode_deleted
// // // //         ON payment_modes(is_deleted)
// // // //       ''');

// // // //       print('✅ Payment mode table created successfully');
// // // //     } catch (e) {
// // // //       print('❌ Error creating Payment mode table: $e');
// // // //       rethrow;
// // // //     }
// // // //   }

// // // //   // Create sample type table method
// // // //   static Future<void> _createSampleTypeTable(DatabaseExecutor database) async {
// // // //     try {
// // // //       await database.execute('''
// // // //         CREATE TABLE IF NOT EXISTS sample_types (
// // // //           id INTEGER PRIMARY KEY AUTOINCREMENT,
// // // //           server_id INTEGER,
// // // //           name TEXT NOT NULL,
// // // //           description TEXT,
// // // //           created_at TEXT,
// // // //           created_by TEXT,
// // // //           last_modified TEXT,
// // // //           last_modified_by TEXT,
// // // //           is_deleted INTEGER DEFAULT 0,
// // // //           deleted_by TEXT,
// // // //           is_synced INTEGER DEFAULT 0,
// // // //           sync_status TEXT DEFAULT 'pending',
// // // //           sync_attempts INTEGER DEFAULT 0,
// // // //           last_sync_error TEXT
// // // //         )
// // // //       ''');

// // // //       // Create indexes
// // // //       await database.execute('''
// // // //         CREATE INDEX IF NOT EXISTS idx_sample_type_name
// // // //         ON sample_types(name)
// // // //       ''');

// // // //       await database.execute('''
// // // //         CREATE INDEX IF NOT EXISTS idx_sample_type_synced
// // // //         ON sample_types(is_synced)
// // // //       ''');

// // // //       await database.execute('''
// // // //         CREATE INDEX IF NOT EXISTS idx_sample_type_deleted
// // // //         ON sample_types(is_deleted)
// // // //       ''');

// // // //       print('✅ Sample type table created successfully');
// // // //     } catch (e) {
// // // //       print('❌ Error creating Sample type table: $e');
// // // //       rethrow;
// // // //     }
// // // //   }

// // // //   // Create branch type table method
// // // //   static Future<void> _createBranchTypeTable(DatabaseExecutor database) async {
// // // //     try {
// // // //       await database.execute('''
// // // //         CREATE TABLE IF NOT EXISTS branch_types (
// // // //           id INTEGER PRIMARY KEY AUTOINCREMENT,
// // // //           server_id INTEGER,
// // // //           company_name TEXT NOT NULL,
// // // //           contact_person TEXT NOT NULL,
// // // //           contact_no TEXT NOT NULL,
// // // //           email TEXT NOT NULL,
// // // //           address1 TEXT NOT NULL,
// // // //           location TEXT NOT NULL,
// // // //           type TEXT NOT NULL,
// // // //           designation TEXT NOT NULL,
// // // //           mobile_no TEXT NOT NULL,
// // // //           address2 TEXT,
// // // //           country TEXT NOT NULL,
// // // //           state TEXT NOT NULL,
// // // //           city TEXT NOT NULL,
// // // //           created_at TEXT,
// // // //           created_by TEXT,
// // // //           last_modified TEXT,
// // // //           last_modified_by TEXT,
// // // //           is_deleted INTEGER DEFAULT 0,
// // // //           deleted_by TEXT,
// // // //           is_synced INTEGER DEFAULT 0,
// // // //           sync_status TEXT DEFAULT 'pending',
// // // //           sync_attempts INTEGER DEFAULT 0,
// // // //           last_sync_error TEXT
// // // //         )
// // // //       ''');

// // // //       // Create indexes
// // // //       await database.execute('''
// // // //         CREATE INDEX IF NOT EXISTS idx_branch_type_company
// // // //         ON branch_types(company_name)
// // // //       ''');

// // // //       await database.execute('''
// // // //         CREATE INDEX IF NOT EXISTS idx_branch_type_contact
// // // //         ON branch_types(contact_person)
// // // //       ''');

// // // //       await database.execute('''
// // // //         CREATE INDEX IF NOT EXISTS idx_branch_type_synced
// // // //         ON branch_types(is_synced)
// // // //       ''');

// // // //       await database.execute('''
// // // //         CREATE INDEX IF NOT EXISTS idx_branch_type_deleted
// // // //         ON branch_types(is_deleted)
// // // //       ''');

// // // //       print('✅ Branch type table created successfully');
// // // //     } catch (e) {
// // // //       print('❌ Error creating branch type table: $e');
// // // //       rethrow;
// // // //     }
// // // //   }

// // // //   // Create collection center table method
// // // //   static Future<void> _createCollectionCenterTable(
// // // //     DatabaseExecutor database,
// // // //   ) async {
// // // //     try {
// // // //       await database.execute('''
// // // //         CREATE TABLE IF NOT EXISTS collection_centers (
// // // //           id INTEGER PRIMARY KEY AUTOINCREMENT,
// // // //           server_id INTEGER,
// // // //           center_code TEXT NOT NULL,
// // // //           center_name TEXT NOT NULL,
// // // //           country TEXT NOT NULL,
// // // //           state TEXT NOT NULL,
// // // //           city TEXT NOT NULL,
// // // //           address1 TEXT NOT NULL,
// // // //           address2 TEXT,
// // // //           location TEXT,
// // // //           postal_code TEXT,
// // // //           latitude REAL DEFAULT 0.0,
// // // //           longitude REAL DEFAULT 0.0,
// // // //           gst_number TEXT,
// // // //           pan_number TEXT,
// // // //           contact_person_name TEXT NOT NULL,
// // // //           phone_no TEXT NOT NULL,
// // // //           email TEXT,
// // // //           centre_status TEXT NOT NULL,
// // // //           branch_type_id INTEGER,
// // // //           lab_affiliation_company TEXT,
// // // //           operational_hours_from TEXT,
// // // //           operational_hours_to TEXT,
// // // //           collection_days TEXT,
// // // //           sample_pickup_timing_from TEXT,
// // // //           sample_pickup_timing_to TEXT,
// // // //           transport_mode TEXT,
// // // //           courier_agency_name TEXT,
// // // //           commission_type TEXT,
// // // //           commission_value REAL DEFAULT 0.0,
// // // //           account_holder_name TEXT,
// // // //           account_no TEXT,
// // // //           ifsc_code TEXT,
// // // //           agreement_file1_path TEXT,
// // // //           agreement_file2_path TEXT,
// // // //           created_at TEXT,
// // // //           created_by TEXT,
// // // //           last_modified TEXT,
// // // //           last_modified_by TEXT,
// // // //           is_deleted INTEGER DEFAULT 0,
// // // //           deleted_by TEXT,
// // // //           is_synced INTEGER DEFAULT 0,
// // // //           sync_status TEXT DEFAULT 'pending',
// // // //           sync_attempts INTEGER DEFAULT 0,
// // // //           last_sync_error TEXT
// // // //         )
// // // //       ''');

// // // //       // Create indexes
// // // //       await database.execute('''
// // // //         CREATE INDEX IF NOT EXISTS idx_collection_center_code
// // // //         ON collection_centers(center_code)
// // // //       ''');

// // // //       await database.execute('''
// // // //         CREATE INDEX IF NOT EXISTS idx_collection_center_name
// // // //         ON collection_centers(center_name)
// // // //       ''');

// // // //       await database.execute('''
// // // //         CREATE INDEX IF NOT EXISTS idx_collection_center_status
// // // //         ON collection_centers(centre_status)
// // // //       ''');

// // // //       await database.execute('''
// // // //         CREATE INDEX IF NOT EXISTS idx_collection_center_city
// // // //         ON collection_centers(city)
// // // //       ''');

// // // //       await database.execute('''
// // // //         CREATE INDEX IF NOT EXISTS idx_collection_center_synced
// // // //         ON collection_centers(is_synced)
// // // //       ''');

// // // //       await database.execute('''
// // // //         CREATE INDEX IF NOT EXISTS idx_collection_center_deleted
// // // //         ON collection_centers(is_deleted)
// // // //       ''');

// // // //       print('✅ Collection center table created successfully');
// // // //     } catch (e) {
// // // //       print('❌ Error creating collection center table: $e');
// // // //       rethrow;
// // // //     }
// // // //   }

// // // //   static Future<void> _createAllTables(DatabaseExecutor database) async {
// // // //     try {
// // // //       print('🏗️ Creating all tables from scratch...');

// // // //       // Create categories table
// // // //       await database.execute('''
// // // //         CREATE TABLE IF NOT EXISTS categories (
// // // //           id INTEGER PRIMARY KEY AUTOINCREMENT,
// // // //           server_id INTEGER,
// // // //           category_name TEXT NOT NULL,
// // // //           created_at TEXT,
// // // //           created_by TEXT,
// // // //           last_modified TEXT,
// // // //           last_modified_by TEXT,
// // // //           is_deleted INTEGER DEFAULT 0,
// // // //           deleted_by TEXT,
// // // //           is_synced INTEGER DEFAULT 0,
// // // //           sync_status TEXT DEFAULT 'pending'
// // // //         )
// // // //       ''');

// // // //       // Create subcategories table
// // // //       await database.execute('''
// // // //         CREATE TABLE IF NOT EXISTS subcategories (
// // // //           id INTEGER PRIMARY KEY AUTOINCREMENT,
// // // //           server_id INTEGER,
// // // //           name TEXT NOT NULL,
// // // //           category_id INTEGER NOT NULL,
// // // //           category_server_id INTEGER,
// // // //           category_name TEXT,
// // // //           created_at TEXT,
// // // //           created_by TEXT,
// // // //           last_modified TEXT,
// // // //           last_modified_by TEXT,
// // // //           is_deleted INTEGER DEFAULT 0,
// // // //           deleted_by TEXT,
// // // //           is_synced INTEGER DEFAULT 0,
// // // //           sync_status TEXT DEFAULT 'pending'
// // // //         )
// // // //       ''');

// // // //       // Create HSN table
// // // //       await _createHsnTable(database);

// // // //       // Create staff table
// // // //       await _createStaffTable(database);

// // // //       // Create bas table
// // // //       await _createBasTable(database);

// // // //       // Create payment mode table
// // // //       await _createPaymentModeTable(database);

// // // //       // Create sample type table
// // // //       await _createSampleTypeTable(database);

// // // //       // Create branch type table
// // // //       await _createBranchTypeTable(database);

// // // //       // Create collection center table
// // // //       await _createCollectionCenterTable(database);

// // // //       // Create groups table
// // // //       await _createGroupTable(database);

// // // //       await _createTestTable(database);

// // // //       await _createPackageTable(database);

// // // //       await _createTestBOMTable(database);

// // // //       print('✅ All tables created successfully');
// // // //     } catch (e) {
// // // //       print('❌ Error creating tables: $e');
// // // //       rethrow;
// // // //     }
// // // //   }

// // // //   static Future<void> _verifyAllTables(DatabaseExecutor database) async {
// // // //     try {
// // // //       // Get all tables
// // // //       final tables = await database.rawQuery(
// // // //         "SELECT name FROM sqlite_master WHERE type='table'",
// // // //       );

// // // //       final tableNames = tables.map((t) => t['name'] as String).toList();
// // // //       print('📋 Found tables: $tableNames');

// // // //       // Check categories table
// // // //       if (!tableNames.contains('categories')) {
// // // //         print('⚠️ Categories table missing, creating...');
// // // //         await database.execute('''
// // // //           CREATE TABLE IF NOT EXISTS categories (
// // // //             id INTEGER PRIMARY KEY AUTOINCREMENT,
// // // //             server_id INTEGER,
// // // //             category_name TEXT NOT NULL,
// // // //             created_at TEXT,
// // // //             created_by TEXT,
// // // //             last_modified TEXT,
// // // //             last_modified_by TEXT,
// // // //             is_deleted INTEGER DEFAULT 0,
// // // //             deleted_by TEXT,
// // // //             is_synced INTEGER DEFAULT 0,
// // // //             sync_status TEXT DEFAULT 'pending'
// // // //           )
// // // //         ''');
// // // //       }

// // // //       // Check subcategories table
// // // //       if (!tableNames.contains('subcategories')) {
// // // //         print('⚠️ Subcategories table missing, creating...');
// // // //         await database.execute('''
// // // //           CREATE TABLE IF NOT EXISTS subcategories (
// // // //             id INTEGER PRIMARY KEY AUTOINCREMENT,
// // // //             server_id INTEGER,
// // // //             name TEXT NOT NULL,
// // // //             category_id INTEGER NOT NULL,
// // // //             category_server_id INTEGER,
// // // //             category_name TEXT,
// // // //             created_at TEXT,
// // // //             created_by TEXT,
// // // //             last_modified TEXT,
// // // //             last_modified_by TEXT,
// // // //             is_deleted INTEGER DEFAULT 0,
// // // //             deleted_by TEXT,
// // // //             is_synced INTEGER DEFAULT 0,
// // // //             sync_status TEXT DEFAULT 'pending'
// // // //           )
// // // //         ''');
// // // //       }

// // // //       // Check hsn_codes table
// // // //       if (!tableNames.contains('hsn_codes')) {
// // // //         print('⚠️ HSN Codes table missing, creating...');
// // // //         await _createHsnTable(database);
// // // //       }

// // // //       // Check staff table
// // // //       if (!tableNames.contains('staff')) {
// // // //         print('⚠️ Staff table missing, creating...');
// // // //         await _createStaffTable(database);
// // // //       }

// // // //       // Check bas table
// // // //       if (!tableNames.contains('bas_names')) {
// // // //         print('⚠️ Bas table missing, creating...');
// // // //         await _createBasTable(database);
// // // //       }

// // // //       // Check payment modes table
// // // //       if (!tableNames.contains('payment_modes')) {
// // // //         print('⚠️ Payment modes table missing, creating...');
// // // //         await _createPaymentModeTable(database);
// // // //       }

// // // //       // Check sample types table
// // // //       if (!tableNames.contains('sample_types')) {
// // // //         print('⚠️ Sample types table missing, creating...');
// // // //         await _createSampleTypeTable(database);
// // // //       }

// // // //       // Check branch types table
// // // //       if (!tableNames.contains('branch_types')) {
// // // //         print('⚠️ Branch types table missing, creating...');
// // // //         await _createBranchTypeTable(database);
// // // //       }

// // // //       // Check collection centers table
// // // //       if (!tableNames.contains('collection_centers')) {
// // // //         print('⚠️ Collection centers table missing, creating...');
// // // //         await _createCollectionCenterTable(database);
// // // //       }

// // // //       // Check groups table
// // // //       if (!tableNames.contains('groups')) {
// // // //         print('⚠️ Groups table missing, creating...');
// // // //         await _createGroupTable(database);
// // // //       }

// // // //       if (!tableNames.contains('test')) {
// // // //         print('⚠️ Test table missing, creating...');
// // // //         await _createTestTable(database);
// // // //       }

// // // //       if (!tableNames.contains('packages')) {
// // // //         print('⚠️ Packages table missing, creating...');
// // // //         await _createPackageTable(database);
// // // //       }

// // // //       if (!tableNames.contains('test_boms')) {
// // // //         print('⚠️ Test BOM table missing, creating...');
// // // //         await _createTestBOMTable(database);
// // // //       }

// // // //       print('✅ All tables verified successfully');
// // // //     } catch (e) {
// // // //       print('❌ Table verification error: $e');
// // // //     }
// // // //   }

// // // //   // Repository getters
// // // //   static Future<UserRepository> get userRepository async {
// // // //     final db = await database;
// // // //     _userRepository ??= UserRepository(db);
// // // //     return _userRepository!;
// // // //   }

// // // //   static Future<CountryRepository> get countryRepository async {
// // // //     final db = await database;
// // // //     _countryRepository ??= CountryRepository(db.countryDao);
// // // //     return _countryRepository!;
// // // //   }

// // // //   static Future<StateRepository> get stateRepository async {
// // // //     final db = await database;
// // // //     _stateRepository ??= StateRepository(db.stateDao);
// // // //     return _stateRepository!;
// // // //   }

// // // //   static Future<CityRepository> get cityRepository async {
// // // //     final db = await database;
// // // //     _cityRepository ??= CityRepository(db.cityDao);
// // // //     return _cityRepository!;
// // // //   }

// // // //   static Future<CategoryRepository> get categoryRepository async {
// // // //     final db = await database;
// // // //     _categoryRepository ??= CategoryRepository(db.categoryDao);
// // // //     return _categoryRepository!;
// // // //   }

// // // //   static Future<SubCategoryRepository> get subCategoryRepository async {
// // // //     final db = await database;
// // // //     _subCategoryRepository ??= SubCategoryRepository(db.subcategoryDao);
// // // //     return _subCategoryRepository!;
// // // //   }

// // // //   static Future<HsnRepository> get hsnRepository async {
// // // //     final db = await database;
// // // //     _hsnRepository ??= HsnRepository(db.hsnDao);
// // // //     return _hsnRepository!;
// // // //   }

// // // //   static Future<StaffRepository> get staffRepository async {
// // // //     final db = await database;
// // // //     _staffRepository ??= StaffRepository(db.staffDao);
// // // //     return _staffRepository!;
// // // //   }

// // // //   static Future<BasRepository> get basRepository async {
// // // //     final db = await database;
// // // //     _basRepository ??= BasRepository(db.basDao);
// // // //     return _basRepository!;
// // // //   }

// // // //   static Future<PaymentModeRepository> get paymentModeRepository async {
// // // //     final db = await database;
// // // //     _paymentModeRepository ??= PaymentModeRepository(db.paymentModeDao);
// // // //     return _paymentModeRepository!;
// // // //   }

// // // //   static Future<SampleTypeRepository> get sampleTypeRepository async {
// // // //     final db = await database;
// // // //     _sampleTypeRepository ??= SampleTypeRepository(db.sampleTypeDao);
// // // //     return _sampleTypeRepository!;
// // // //   }

// // // //   static Future<BranchTypeRepository> get branchTypeRepository async {
// // // //     final db = await database;
// // // //     _branchTypeRepository ??= BranchTypeRepository(db.branchTypeDao);
// // // //     return _branchTypeRepository!;
// // // //   }

// // // //   static Future<CollectionCenterRepository>
// // // //   get collectionCenterRepository async {
// // // //     final db = await database;
// // // //     _collectionCenterRepository ??= CollectionCenterRepository(
// // // //       db.collectionCenterDao,
// // // //     );
// // // //     return _collectionCenterRepository!;
// // // //   }

// // // //   // Add GroupRepository getter
// // // //   static Future<GroupRepo> get groupRepository async {
// // // //     final db = await database;
// // // //     _groupRepository ??= GroupRepo(db.groupDao);
// // // //     return _groupRepository!;
// // // //   }

// // // //   // Emergency function to create group table directly
// // // //   static Future<void> createGroupTableDirectly() async {
// // // //     try {
// // // //       print('🆘 EMERGENCY: Creating group table directly...');

// // // //       final db = await database;

// // // //       // First check if table exists
// // // //       final exists = await checkGroupTableExists();
// // // //       if (exists) {
// // // //         print('✅ Group table already exists');
// // // //         return;
// // // //       }

// // // //       print('🔄 Creating group table...');
// // // //       await _createGroupTable(db.database);

// // // //       // Verify
// // // //       final test = await db.database.query('groups', limit: 1);
// // // //       print('✅ Group table verified, row count: ${test.length}');
// // // //     } catch (e) {
// // // //       print('❌ Direct creation failed: $e');
// // // //       rethrow;
// // // //     }
// // // //   }

// // // //   // Check if group table exists
// // // //   static Future<bool> checkGroupTableExists() async {
// // // //     try {
// // // //       final db = await database;
// // // //       final result = await db.database.rawQuery(
// // // //         "SELECT name FROM sqlite_master WHERE type='table' AND name='groups'",
// // // //       );
// // // //       return result.isNotEmpty;
// // // //     } catch (e) {
// // // //       print('❌ Error checking group table: $e');
// // // //       return false;
// // // //     }
// // // //   }

// // // //   static Future<void> ensureGroupTableExists() async {
// // // //     try {
// // // //       print('🔍 Checking group table...');

// // // //       final db = await database;

// // // //       final result = await db.database.rawQuery(
// // // //         "SELECT name FROM sqlite_master WHERE type='table' AND name='groups'",
// // // //       );

// // // //       if (result.isEmpty) {
// // // //         print('❌ Group table NOT found! Creating immediately...');

// // // //         await db.database.execute('''
// // // //         CREATE TABLE groups (
// // // //           id INTEGER PRIMARY KEY AUTOINCREMENT,
// // // //           server_id INTEGER,
// // // //           name TEXT NOT NULL,
// // // //           description TEXT,
// // // //           code TEXT,
// // // //           type TEXT DEFAULT 'general',
// // // //           status TEXT DEFAULT 'active',
// // // //           tenant_id TEXT,
// // // //           created_at TEXT,
// // // //           created_by TEXT,
// // // //           last_modified TEXT,
// // // //           last_modified_by TEXT,
// // // //           is_deleted INTEGER DEFAULT 0,
// // // //           deleted_by TEXT,
// // // //           is_synced INTEGER DEFAULT 0,
// // // //           sync_status TEXT DEFAULT 'pending',
// // // //           sync_attempts INTEGER DEFAULT 0,
// // // //           last_sync_error TEXT
// // // //         )
// // // //       ''');

// // // //         // Create indexes
// // // //         await db.database.execute('''
// // // //           CREATE INDEX IF NOT EXISTS idx_group_name ON groups(name)
// // // //         ''');

// // // //         await db.database.execute('''
// // // //           CREATE INDEX IF NOT EXISTS idx_group_code ON groups(code)
// // // //         ''');

// // // //         await db.database.execute('''
// // // //           CREATE INDEX IF NOT EXISTS idx_group_type ON groups(type)
// // // //         ''');

// // // //         await db.database.execute('''
// // // //           CREATE INDEX IF NOT EXISTS idx_group_synced ON groups(is_synced)
// // // //         ''');

// // // //         await db.database.execute('''
// // // //           CREATE INDEX IF NOT EXISTS idx_group_deleted ON groups(is_deleted)
// // // //         ''');

// // // //         print('✅ Group table created successfully via direct SQL');
// // // //       } else {
// // // //         print('✅ Group table already exists');
// // // //       }
// // // //     } catch (e) {
// // // //       print('❌ Error in ensureGroupTableExists: $e');
// // // //     }
// // // //   }

// // // //   static Future<void> initializeGroupScreen() async {
// // // //     try {
// // // //       print('🚀 Initializing group screen...');

// // // //       // 1. पहले group table check करें
// // // //       await ensureGroupTableExists();

// // // //       // 2. Database debug करें
// // // //       await debugDatabase();

// // // //       print('✅ Group screen ready!');
// // // //     } catch (e) {
// // // //       print('❌ Group initialization failed: $e');
// // // //     }
// // // //   }

// // // //   // Keep existing emergency functions (they remain the same)
// // // //   static Future<void> emergencyFixForStaff() async {
// // // //     try {
// // // //       print('🆘 EMERGENCY FIX FOR STAFF TABLE...');

// // // //       final db = await database;

// // // //       final result = await db.database.rawQuery(
// // // //         "SELECT name FROM sqlite_master WHERE type='table' AND name='staff'",
// // // //       );

// // // //       if (result.isEmpty) {
// // // //         print('❌ Staff table NOT found! Creating with direct SQL...');

// // // //         await db.database.execute('''
// // // //           CREATE TABLE IF NOT EXISTS staff (
// // // //             id INTEGER PRIMARY KEY AUTOINCREMENT,
// // // //             server_id INTEGER,
// // // //             name TEXT NOT NULL,
// // // //             department TEXT NOT NULL,
// // // //             designation TEXT NOT NULL,
// // // //             email TEXT,
// // // //             phone TEXT NOT NULL,
// // // //             required_credentials TEXT NOT NULL,
// // // //             created_at TEXT NOT NULL,
// // // //             created_by TEXT,
// // // //             last_modified TEXT,
// // // //             last_modified_by TEXT,
// // // //             is_deleted INTEGER DEFAULT 0,
// // // //             deleted_by TEXT,
// // // //             is_synced INTEGER DEFAULT 0,
// // // //             sync_status TEXT DEFAULT 'pending',
// // // //             sync_attempts INTEGER DEFAULT 0,
// // // //             last_sync_error TEXT
// // // //           )
// // // //         ''');

// // // //         await db.database.execute('''
// // // //           CREATE INDEX IF NOT EXISTS idx_staff_name ON staff(name)
// // // //         ''');

// // // //         await db.database.execute('''
// // // //           CREATE INDEX IF NOT EXISTS idx_staff_department ON staff(department)
// // // //         ''');

// // // //         await db.database.execute('''
// // // //           CREATE INDEX IF NOT EXISTS idx_staff_designation ON staff(designation)
// // // //         ''');

// // // //         await db.database.execute('''
// // // //           CREATE INDEX IF NOT EXISTS idx_staff_synced ON staff(is_synced)
// // // //         ''');

// // // //         await db.database.execute('''
// // // //           CREATE INDEX IF NOT EXISTS idx_staff_deleted ON staff(is_deleted)
// // // //         ''');

// // // //         print('✅ Staff table created via DIRECT SQL (bypassing migrations)');
// // // //       } else {
// // // //         print('✅ Staff table already exists');
// // // //       }
// // // //     } catch (e) {
// // // //       print('❌ Emergency fix failed: $e');
// // // //     }
// // // //   }

// // // //   // Keep all other existing methods (ensureStaffTableExists, ensureBasTableExists, etc.)
// // // //   // They remain exactly the same as in your original code

// // // //   static Future<void> ensureStaffTableExists() async {
// // // //     try {
// // // //       print('🔍 Checking staff table...');

// // // //       final db = await database;

// // // //       final result = await db.database.rawQuery(
// // // //         "SELECT name FROM sqlite_master WHERE type='table' AND name='staff'",
// // // //       );

// // // //       if (result.isEmpty) {
// // // //         print('❌ Staff table NOT found! Creating immediately...');

// // // //         await db.database.execute('''
// // // //         CREATE TABLE staff (
// // // //           id INTEGER PRIMARY KEY AUTOINCREMENT,
// // // //           server_id INTEGER,
// // // //           name TEXT NOT NULL,
// // // //           department TEXT NOT NULL,
// // // //           designation TEXT NOT NULL,
// // // //           email TEXT,
// // // //           phone TEXT NOT NULL,
// // // //           required_credentials TEXT NOT NULL,
// // // //           created_at TEXT NOT NULL,
// // // //           created_by TEXT,
// // // //           last_modified TEXT,
// // // //           last_modified_by TEXT,
// // // //           is_deleted INTEGER DEFAULT 0,
// // // //           deleted_by TEXT,
// // // //           is_synced INTEGER DEFAULT 0,
// // // //           sync_status TEXT DEFAULT 'pending',
// // // //           sync_attempts INTEGER DEFAULT 0,
// // // //           last_sync_error TEXT
// // // //         )
// // // //       ''');

// // // //         print('✅ Staff table created successfully via direct SQL');
// // // //       } else {
// // // //         print('✅ Staff table already exists');
// // // //       }
// // // //     } catch (e) {
// // // //       print('❌ Error in ensureStaffTableExists: $e');
// // // //     }
// // // //   }

// // // //   static Future<void> ensureBasTableExists() async {
// // // //     try {
// // // //       print('🔍 Checking bas table...');

// // // //       final db = await database;

// // // //       final result = await db.database.rawQuery(
// // // //         "SELECT name FROM sqlite_master WHERE type='table' AND name='bas_names'",
// // // //       );

// // // //       if (result.isEmpty) {
// // // //         print('❌ Bas table NOT found! Creating immediately...');

// // // //         await db.database.execute('''
// // // //         CREATE TABLE bas_names (
// // // //           id INTEGER PRIMARY KEY AUTOINCREMENT,
// // // //           server_id INTEGER,
// // // //           name TEXT NOT NULL,
// // // //           created_at TEXT,
// // // //           created_by TEXT,
// // // //           last_modified TEXT,
// // // //           last_modified_by TEXT,
// // // //           is_deleted INTEGER DEFAULT 0,
// // // //           deleted_by TEXT,
// // // //           is_synced INTEGER DEFAULT 0,
// // // //           sync_status TEXT DEFAULT 'pending',
// // // //           sync_attempts INTEGER DEFAULT 0,
// // // //           last_sync_error TEXT
// // // //         )
// // // //       ''');

// // // //         await db.database.execute('''
// // // //           CREATE INDEX IF NOT EXISTS idx_bas_name ON bas_names(name)
// // // //         ''');

// // // //         await db.database.execute('''
// // // //           CREATE INDEX IF NOT EXISTS idx_bas_synced ON bas_names(is_synced)
// // // //         ''');

// // // //         await db.database.execute('''
// // // //           CREATE INDEX IF NOT EXISTS idx_bas_deleted ON bas_names(is_deleted)
// // // //         ''');

// // // //         print('✅ Bas table created successfully via direct SQL');
// // // //       } else {
// // // //         print('✅ Bas table already exists');
// // // //       }
// // // //     } catch (e) {
// // // //       print('❌ Error in ensureBasTableExists: $e');
// // // //     }
// // // //   }

// // // //   static Future<void> ensurePaymentModeTableExists() async {
// // // //     try {
// // // //       print('🔍 Checking payment mode table...');

// // // //       final db = await database;

// // // //       final result = await db.database.rawQuery(
// // // //         "SELECT name FROM sqlite_master WHERE type='table' AND name='payment_modes'",
// // // //       );

// // // //       if (result.isEmpty) {
// // // //         print('❌ Payment mode table NOT found! Creating immediately...');

// // // //         await db.database.execute('''
// // // //         CREATE TABLE payment_modes (
// // // //           id INTEGER PRIMARY KEY AUTOINCREMENT,
// // // //           server_id INTEGER,
// // // //           name TEXT NOT NULL,
// // // //           description TEXT,
// // // //           tenant_id TEXT,
// // // //           created_at TEXT,
// // // //           created_by TEXT,
// // // //           last_modified TEXT,
// // // //           last_modified_by TEXT,
// // // //           is_deleted INTEGER DEFAULT 0,
// // // //           deleted_by TEXT,
// // // //           is_synced INTEGER DEFAULT 0,
// // // //           sync_status TEXT DEFAULT 'pending',
// // // //           sync_attempts INTEGER DEFAULT 0,
// // // //           last_sync_error TEXT
// // // //         )
// // // //       ''');

// // // //         await db.database.execute('''
// // // //           CREATE INDEX IF NOT EXISTS idx_payment_mode_name ON payment_modes(name)
// // // //         ''');

// // // //         await db.database.execute('''
// // // //           CREATE INDEX IF NOT EXISTS idx_payment_mode_synced ON payment_modes(is_synced)
// // // //         ''');

// // // //         await db.database.execute('''
// // // //           CREATE INDEX IF NOT EXISTS idx_payment_mode_deleted ON payment_modes(is_deleted)
// // // //         ''');

// // // //         print('✅ Payment mode table created successfully via direct SQL');
// // // //       } else {
// // // //         print('✅ Payment mode table already exists');
// // // //       }
// // // //     } catch (e) {
// // // //       print('❌ Error in ensurePaymentModeTableExists: $e');
// // // //     }
// // // //   }

// // // //   static Future<void> ensureSampleTypeTableExists() async {
// // // //     try {
// // // //       print('🔍 Checking sample type table...');

// // // //       final db = await database;

// // // //       final result = await db.database.rawQuery(
// // // //         "SELECT name FROM sqlite_master WHERE type='table' AND name='sample_types'",
// // // //       );

// // // //       if (result.isEmpty) {
// // // //         print('❌ Sample type table NOT found! Creating immediately...');

// // // //         await db.database.execute('''
// // // //         CREATE TABLE sample_types (
// // // //           id INTEGER PRIMARY KEY AUTOINCREMENT,
// // // //           server_id INTEGER,
// // // //           name TEXT NOT NULL,
// // // //           description TEXT,
// // // //           created_at TEXT,
// // // //           created_by TEXT,
// // // //           last_modified TEXT,
// // // //           last_modified_by TEXT,
// // // //           is_deleted INTEGER DEFAULT 0,
// // // //           deleted_by TEXT,
// // // //           is_synced INTEGER DEFAULT 0,
// // // //           sync_status TEXT DEFAULT 'pending',
// // // //           sync_attempts INTEGER DEFAULT 0,
// // // //           last_sync_error TEXT
// // // //         )
// // // //       ''');

// // // //         await db.database.execute('''
// // // //           CREATE INDEX IF NOT EXISTS idx_sample_type_name ON sample_types(name)
// // // //         ''');

// // // //         await db.database.execute('''
// // // //           CREATE INDEX IF NOT EXISTS idx_sample_type_synced ON sample_types(is_synced)
// // // //         ''');

// // // //         await db.database.execute('''
// // // //           CREATE INDEX IF NOT EXISTS idx_sample_type_deleted ON sample_types(is_deleted)
// // // //         ''');

// // // //         print('✅ Sample type table created successfully via direct SQL');
// // // //       } else {
// // // //         print('✅ Sample type table already exists');
// // // //       }
// // // //     } catch (e) {
// // // //       print('❌ Error in ensureSampleTypeTableExists: $e');
// // // //     }
// // // //   }

// // // //   static Future<void> ensureBranchTypeTableExists() async {
// // // //     try {
// // // //       print('🔍 Checking branch type table...');

// // // //       final db = await database;

// // // //       final result = await db.database.rawQuery(
// // // //         "SELECT name FROM sqlite_master WHERE type='table' AND name='branch_types'",
// // // //       );

// // // //       if (result.isEmpty) {
// // // //         print('❌ Branch type table NOT found! Creating immediately...');

// // // //         await db.database.execute('''
// // // //         CREATE TABLE branch_types (
// // // //           id INTEGER PRIMARY KEY AUTOINCREMENT,
// // // //           server_id INTEGER,
// // // //           company_name TEXT NOT NULL,
// // // //           contact_person TEXT NOT NULL,
// // // //           contact_no TEXT NOT NULL,
// // // //           email TEXT NOT NULL,
// // // //           address1 TEXT NOT NULL,
// // // //           location TEXT NOT NULL,
// // // //           type TEXT NOT NULL,
// // // //           designation TEXT NOT NULL,
// // // //           mobile_no TEXT NOT NULL,
// // // //           address2 TEXT,
// // // //           country TEXT NOT NULL,
// // // //           state TEXT NOT NULL,
// // // //           city TEXT NOT NULL,
// // // //           created_at TEXT,
// // // //           created_by TEXT,
// // // //           last_modified TEXT,
// // // //           last_modified_by TEXT,
// // // //           is_deleted INTEGER DEFAULT 0,
// // // //           deleted_by TEXT,
// // // //           is_synced INTEGER DEFAULT 0,
// // // //           sync_status TEXT DEFAULT 'pending',
// // // //           sync_attempts INTEGER DEFAULT 0,
// // // //           last_sync_error TEXT
// // // //         )
// // // //       ''');

// // // //         await db.database.execute('''
// // // //           CREATE INDEX IF NOT EXISTS idx_branch_type_company ON branch_types(company_name)
// // // //         ''');

// // // //         await db.database.execute('''
// // // //           CREATE INDEX IF NOT EXISTS idx_branch_type_contact ON branch_types(contact_person)
// // // //         ''');

// // // //         await db.database.execute('''
// // // //           CREATE INDEX IF NOT EXISTS idx_branch_type_synced ON branch_types(is_synced)
// // // //         ''');

// // // //         await db.database.execute('''
// // // //           CREATE INDEX IF NOT EXISTS idx_branch_type_deleted ON branch_types(is_deleted)
// // // //         ''');

// // // //         print('✅ Branch type table created successfully via direct SQL');
// // // //       } else {
// // // //         print('✅ Branch type table already exists');
// // // //       }
// // // //     } catch (e) {
// // // //       print('❌ Error in ensureBranchTypeTableExists: $e');
// // // //     }
// // // //   }

// // // //   static Future<void> ensureCollectionCenterTableExists() async {
// // // //     try {
// // // //       print('🔍 Checking collection center table...');

// // // //       final db = await database;

// // // //       final result = await db.database.rawQuery(
// // // //         "SELECT name FROM sqlite_master WHERE type='table' AND name='collection_centers'",
// // // //       );

// // // //       if (result.isEmpty) {
// // // //         print('❌ Collection center table NOT found! Creating immediately...');

// // // //         await db.database.execute('''
// // // //         CREATE TABLE collection_centers (
// // // //           id INTEGER PRIMARY KEY AUTOINCREMENT,
// // // //           server_id INTEGER,
// // // //           center_code TEXT NOT NULL,
// // // //           center_name TEXT NOT NULL,
// // // //           country TEXT NOT NULL,
// // // //           state TEXT NOT NULL,
// // // //           city TEXT NOT NULL,
// // // //           address1 TEXT NOT NULL,
// // // //           address2 TEXT,
// // // //           location TEXT,
// // // //           postal_code TEXT,
// // // //           latitude REAL DEFAULT 0.0,
// // // //           longitude REAL DEFAULT 0.0,
// // // //           gst_number TEXT,
// // // //           pan_number TEXT,
// // // //           contact_person_name TEXT NOT NULL,
// // // //           phone_no TEXT NOT NULL,
// // // //           email TEXT,
// // // //           centre_status TEXT NOT NULL,
// // // //           branch_type_id INTEGER,
// // // //           lab_affiliation_company TEXT,
// // // //           operational_hours_from TEXT,
// // // //           operational_hours_to TEXT,
// // // //           collection_days TEXT,
// // // //           sample_pickup_timing_from TEXT,
// // // //           sample_pickup_timing_to TEXT,
// // // //           transport_mode TEXT,
// // // //           courier_agency_name TEXT,
// // // //           commission_type TEXT,
// // // //           commission_value REAL DEFAULT 0.0,
// // // //           account_holder_name TEXT,
// // // //           account_no TEXT,
// // // //           ifsc_code TEXT,
// // // //           agreement_file1_path TEXT,
// // // //           agreement_file2_path TEXT,
// // // //           created_at TEXT,
// // // //           created_by TEXT,
// // // //           last_modified TEXT,
// // // //           last_modified_by TEXT,
// // // //           is_deleted INTEGER DEFAULT 0,
// // // //           deleted_by TEXT,
// // // //           is_synced INTEGER DEFAULT 0,
// // // //           sync_status TEXT DEFAULT 'pending',
// // // //           sync_attempts INTEGER DEFAULT 0,
// // // //           last_sync_error TEXT
// // // //         )
// // // //       ''');

// // // //         await db.database.execute('''
// // // //           CREATE INDEX IF NOT EXISTS idx_collection_center_code ON collection_centers(center_code)
// // // //         ''');

// // // //         await db.database.execute('''
// // // //           CREATE INDEX IF NOT EXISTS idx_collection_center_name ON collection_centers(center_name)
// // // //         ''');

// // // //         await db.database.execute('''
// // // //           CREATE INDEX IF NOT EXISTS idx_collection_center_status ON collection_centers(centre_status)
// // // //         ''');

// // // //         await db.database.execute('''
// // // //           CREATE INDEX IF NOT EXISTS idx_collection_center_city ON collection_centers(city)
// // // //         ''');

// // // //         await db.database.execute('''
// // // //           CREATE INDEX IF NOT EXISTS idx_collection_center_synced ON collection_centers(is_synced)
// // // //         ''');

// // // //         await db.database.execute('''
// // // //           CREATE INDEX IF NOT EXISTS idx_collection_center_deleted ON collection_centers(is_deleted)
// // // //         ''');

// // // //         print('✅ Collection center table created successfully via direct SQL');
// // // //       } else {
// // // //         print('✅ Collection center table already exists');
// // // //       }
// // // //     } catch (e) {
// // // //       print('❌ Error in ensureCollectionCenterTableExists: $e');
// // // //     }
// // // //   }

// // // //   static Future<void> _recreateDatabase() async {
// // // //     try {
// // // //       if (_database != null) {
// // // //         await _database!.close();
// // // //         _database = null;
// // // //       }
// // // //       final databasesPath = await getDatabasesPath();
// // // //       final dbPath = '$databasesPath/database.db';
// // // //       final dbFile = File(dbPath);
// // // //       if (await dbFile.exists()) {
// // // //         await dbFile.delete();
// // // //         print('🗑️ Deleted old database file');
// // // //       }
// // // //       try {
// // // //         final shmFile = File('$dbPath-shm');
// // // //         final walFile = File('$dbPath-wal');
// // // //         if (await shmFile.exists()) await shmFile.delete();
// // // //         if (await walFile.exists()) await walFile.delete();
// // // //       } catch (e) {
// // // //         print('Note: Could not delete shm/wal files: $e');
// // // //       }
// // // //       _userRepository = null;
// // // //       _countryRepository = null;
// // // //       _stateRepository = null;
// // // //       _cityRepository = null;
// // // //       _categoryRepository = null;
// // // //       _subCategoryRepository = null;
// // // //       _hsnRepository = null;
// // // //       _staffRepository = null;
// // // //       _basRepository = null;
// // // //       _paymentModeRepository = null;
// // // //       _sampleTypeRepository = null;
// // // //       _branchTypeRepository = null;
// // // //       _collectionCenterRepository = null;
// // // //       _groupRepository = null; // Add this
// // // //       _testBOMRepository = null;
// // // //       _database = null;
// // // //       await database;
// // // //       print('✅ Database recreated successfully');
// // // //     } catch (e) {
// // // //       print('❌ Error recreating database: $e');
// // // //       rethrow;
// // // //     }
// // // //   }

// // // //   static Future<void> resetDatabase() async {
// // // //     await _recreateDatabase();
// // // //   }

// // // //   static Future<void> closeDatabase() async {
// // // //     if (_database != null) {
// // // //       await _database!.close();
// // // //       _database = null;
// // // //       _userRepository = null;
// // // //       _countryRepository = null;
// // // //       _stateRepository = null;
// // // //       _cityRepository = null;
// // // //       _categoryRepository = null;
// // // //       _subCategoryRepository = null;
// // // //       _hsnRepository = null;
// // // //       _staffRepository = null;
// // // //       _basRepository = null;
// // // //       _paymentModeRepository = null;
// // // //       _sampleTypeRepository = null;
// // // //       _branchTypeRepository = null;
// // // //       _collectionCenterRepository = null;
// // // //       _groupRepository = null; // Add this
// // // //       _testBOMRepository = null;
// // // //     }
// // // //   }

// // // //   static Future<void> debugDatabase() async {
// // // //     try {
// // // //       print('🔍 DEBUGGING DATABASE...');
// // // //       final db = await database;
// // // //       final versionResult = await db.database.rawQuery('PRAGMA user_version');
// // // //       final version = versionResult.first['user_version'];
// // // //       print('📊 Database version: $version');
// // // //       final tables = await getAllTableNames();
// // // //       print('📋 All tables: $tables');
// // // //       for (var table in tables) {
// // // //         final countResult = await db.database.rawQuery(
// // // //           'SELECT COUNT(*) as count FROM $table',
// // // //         );
// // // //         final count = countResult.first['count'];
// // // //         print('   - $table: $count rows');
// // // //       }
// // // //     } catch (e) {
// // // //       print('❌ Debug failed: $e');
// // // //     }
// // // //   }

// // // //   static Future<List<String>> getAllTableNames() async {
// // // //     try {
// // // //       final db = await database;
// // // //       final result = await db.database.rawQuery(
// // // //         "SELECT name FROM sqlite_master WHERE type='table' ORDER BY name",
// // // //       );
// // // //       return result.map((row) => row['name'] as String).toList();
// // // //     } catch (e) {
// // // //       print('❌ Error getting tables: $e');
// // // //       return [];
// // // //     }
// // // //   }

// // // //   static Future<void> initializeStaffScreen() async {
// // // //     try {
// // // //       print('🚀 Initializing staff screen...');
// // // //       await ensureStaffTableExists();
// // // //       await debugDatabase();

// // // //       print('✅ Staff screen ready!');
// // // //     } catch (e) {
// // // //       print('❌ Staff initialization failed: $e');
// // // //     }
// // // //   }

// // // //   static Future<void> initializeBasScreen() async {
// // // //     try {
// // // //       print('🚀 Initializing bas screen...');
// // // //       await ensureBasTableExists();
// // // //       await debugDatabase();

// // // //       print('✅ Bas screen ready!');
// // // //     } catch (e) {
// // // //       print('❌ Bas initialization failed: $e');
// // // //     }
// // // //   }

// // // //   static Future<void> initializePaymentModeScreen() async {
// // // //     try {
// // // //       print('🚀 Initializing payment mode screen...');
// // // //       await ensurePaymentModeTableExists();
// // // //       await debugDatabase();

// // // //       print('✅ Payment mode screen ready!');
// // // //     } catch (e) {
// // // //       print('❌ Payment mode initialization failed: $e');
// // // //     }
// // // //   }

// // // //   static Future<void> initializeSampleTypeScreen() async {
// // // //     try {
// // // //       print('🚀 Initializing sample type screen...');
// // // //       await ensureSampleTypeTableExists();
// // // //       await debugDatabase();

// // // //       print('✅ Sample type screen ready!');
// // // //     } catch (e) {
// // // //       print('❌ Sample type initialization failed: $e');
// // // //     }
// // // //   }

// // // //   static Future<void> initializeBranchTypeScreen() async {
// // // //     try {
// // // //       print('🚀 Initializing branch type screen...');
// // // //       await ensureBranchTypeTableExists();
// // // //       await debugDatabase();

// // // //       print('✅ Branch type screen ready!');
// // // //     } catch (e) {
// // // //       print('❌ Branch type initialization failed: $e');
// // // //     }
// // // //   }

// // // //   static Future<void> initializeCollectionCenterScreen() async {
// // // //     try {
// // // //       print('🚀 Initializing collection center screen...');
// // // //       await ensureCollectionCenterTableExists();
// // // //       await debugDatabase();
// // // //       print('✅ Collection center screen ready!');
// // // //     } catch (e) {
// // // //       print('❌ Collection center initialization failed: $e');
// // // //     }
// // // //   }

// // // //   static Future<void> createStaffTableDirectly() async {
// // // //     try {
// // // //       print('🆘 EMERGENCY: Creating staff table directly...');

// // // //       final db = await database;

// // // //       // First check if table exists
// // // //       final exists = await checkStaffTableExists();
// // // //       if (exists) {
// // // //         print('✅ Staff table already exists');
// // // //         return;
// // // //       }

// // // //       print('🔄 Creating staff table...');
// // // //       await _createStaffTable(db.database);

// // // //       // Verify
// // // //       final test = await db.database.query('staff', limit: 1);
// // // //       print('✅ Staff table verified, row count: ${test.length}');
// // // //     } catch (e) {
// // // //       print('❌ Direct creation failed: $e');
// // // //       rethrow;
// // // //     }
// // // //   }

// // // //   static Future<void> createBasTableDirectly() async {
// // // //     try {
// // // //       print('🆘 EMERGENCY: Creating bas table directly...');

// // // //       final db = await database;

// // // //       // First check if table exists
// // // //       final exists = await checkBasTableExists();
// // // //       if (exists) {
// // // //         print('✅ Bas table already exists');
// // // //         return;
// // // //       }

// // // //       print('🔄 Creating bas table...');
// // // //       await _createBasTable(db.database);

// // // //       // Verify
// // // //       final test = await db.database.query('bas_names', limit: 1);
// // // //       print('✅ Bas table verified, row count: ${test.length}');
// // // //     } catch (e) {
// // // //       print('❌ Direct creation failed: $e');
// // // //       rethrow;
// // // //     }
// // // //   }

// // // //   static Future<bool> checkBasTableExists() async {
// // // //     try {
// // // //       final db = await database;
// // // //       final result = await db.database.rawQuery(
// // // //         "SELECT name FROM sqlite_master WHERE type='table' AND name='bas_names'",
// // // //       );
// // // //       return result.isNotEmpty;
// // // //     } catch (e) {
// // // //       print('❌ Error checking bas table: $e');
// // // //       return false;
// // // //     }
// // // //   }

// // // //   static Future<bool> checkStaffTableExists() async {
// // // //     try {
// // // //       final db = await database;
// // // //       final result = await db.database.rawQuery(
// // // //         "SELECT name FROM sqlite_master WHERE type='table' AND name='staff'",
// // // //       );
// // // //       return result.isNotEmpty;
// // // //     } catch (e) {
// // // //       print('❌ Error checking staff table: $e');
// // // //       return false;
// // // //     }
// // // //   }

// // // //   static Future<void> createPaymentModeTableDirectly() async {
// // // //     try {
// // // //       print('🆘 EMERGENCY: Creating payment mode table directly...');

// // // //       final db = await database;

// // // //       // First check if table exists
// // // //       final exists = await checkPaymentModeTableExists();
// // // //       if (exists) {
// // // //         print('✅ Payment mode table already exists');
// // // //         return;
// // // //       }

// // // //       print('🔄 Creating payment mode table...');
// // // //       await _createPaymentModeTable(db.database);

// // // //       // Verify
// // // //       final test = await db.database.query('payment_modes', limit: 1);
// // // //       print('✅ Payment mode table verified, row count: ${test.length}');
// // // //     } catch (e) {
// // // //       print('❌ Direct creation failed: $e');
// // // //       rethrow;
// // // //     }
// // // //   }

// // // //   static Future<bool> checkPaymentModeTableExists() async {
// // // //     try {
// // // //       final db = await database;
// // // //       final result = await db.database.rawQuery(
// // // //         "SELECT name FROM sqlite_master WHERE type='table' AND name='payment_modes'",
// // // //       );
// // // //       return result.isNotEmpty;
// // // //     } catch (e) {
// // // //       print('❌ Error checking payment mode table: $e');
// // // //       return false;
// // // //     }
// // // //   }

// // // //   static Future<void> createSampleTypeTableDirectly() async {
// // // //     try {
// // // //       print('🆘 EMERGENCY: Creating sample type table directly...');

// // // //       final db = await database;

// // // //       // First check if table exists
// // // //       final exists = await checkSampleTypeTableExists();
// // // //       if (exists) {
// // // //         print('✅ Sample type table already exists');
// // // //         return;
// // // //       }

// // // //       print('🔄 Creating sample type table...');
// // // //       await _createSampleTypeTable(db.database);

// // // //       // Verify
// // // //       final test = await db.database.query('sample_types', limit: 1);
// // // //       print('✅ Sample type table verified, row count: ${test.length}');
// // // //     } catch (e) {
// // // //       print('❌ Direct creation failed: $e');
// // // //       rethrow;
// // // //     }
// // // //   }

// // // //   static Future<bool> checkSampleTypeTableExists() async {
// // // //     try {
// // // //       final db = await database;
// // // //       final result = await db.database.rawQuery(
// // // //         "SELECT name FROM sqlite_master WHERE type='table' AND name='sample_types'",
// // // //       );
// // // //       return result.isNotEmpty;
// // // //     } catch (e) {
// // // //       print('❌ Error checking sample type table: $e');
// // // //       return false;
// // // //     }
// // // //   }

// // // //   static Future<void> createBranchTypeTableDirectly() async {
// // // //     try {
// // // //       print('🆘 EMERGENCY: Creating branch type table directly...');

// // // //       final db = await database;

// // // //       // First check if table exists
// // // //       final exists = await checkBranchTypeTableExists();
// // // //       if (exists) {
// // // //         print('✅ Branch type table already exists');
// // // //         return;
// // // //       }

// // // //       print('🔄 Creating branch type table...');
// // // //       await _createBranchTypeTable(db.database);

// // // //       // Verify
// // // //       final test = await db.database.query('branch_types', limit: 1);
// // // //       print('✅ Branch type table verified, row count: ${test.length}');
// // // //     } catch (e) {
// // // //       print('❌ Direct creation failed: $e');
// // // //       rethrow;
// // // //     }
// // // //   }

// // // //   static Future<bool> checkBranchTypeTableExists() async {
// // // //     try {
// // // //       final db = await database;
// // // //       final result = await db.database.rawQuery(
// // // //         "SELECT name FROM sqlite_master WHERE type='table' AND name='branch_types'",
// // // //       );
// // // //       return result.isNotEmpty;
// // // //     } catch (e) {
// // // //       print('❌ Error checking branch type table: $e');
// // // //       return false;
// // // //     }
// // // //   }

// // // //   static Future<void> createCollectionCenterTableDirectly() async {
// // // //     try {
// // // //       print('🆘 EMERGENCY: Creating collection center table directly...');

// // // //       final db = await database;

// // // //       // First check if table exists
// // // //       final exists = await checkCollectionCenterTableExists();
// // // //       if (exists) {
// // // //         print('✅ Collection center table already exists');
// // // //         return;
// // // //       }

// // // //       print('🔄 Creating collection center table...');
// // // //       await _createCollectionCenterTable(db.database);

// // // //       // Verify
// // // //       final test = await db.database.query('collection_centers', limit: 1);
// // // //       print('✅ Collection center table verified, row count: ${test.length}');
// // // //     } catch (e) {
// // // //       print('❌ Direct creation failed: $e');
// // // //       rethrow;
// // // //     }
// // // //   }

// // // //   static Future<bool> checkCollectionCenterTableExists() async {
// // // //     try {
// // // //       final db = await database;
// // // //       final result = await db.database.rawQuery(
// // // //         "SELECT name FROM sqlite_master WHERE type='table' AND name='collection_centers'",
// // // //       );
// // // //       return result.isNotEmpty;
// // // //     } catch (e) {
// // // //       print('❌ Error checking collection center table: $e');
// // // //       return false;
// // // //     }
// // // //   }

// // // //   static Future<void> initializeDatabaseWithRetry() async {
// // // //     try {
// // // //       print('🔄 Initializing database...');
// // // //       final db = await database;

// // // //       // Force table creation if needed
// // // //       await _forceCreateTablesIfMissing(db);

// // // //       print('✅ Database initialized successfully');
// // // //     } catch (e) {
// // // //       print('❌ Database initialization failed: $e');
// // // //       print('🔄 Retrying with clean database...');
// // // //       await _recreateDatabase();
// // // //     }
// // // //   }

// // // //   static Future<void> _forceCreateTablesIfMissing(AppDatabase db) async {
// // // //     try {
// // // //       // Create categories table if missing
// // // //       await db.database.execute('''
// // // //         CREATE TABLE IF NOT EXISTS categories (
// // // //           id INTEGER PRIMARY KEY AUTOINCREMENT,
// // // //           server_id INTEGER,
// // // //           category_name TEXT NOT NULL,
// // // //           created_at TEXT,
// // // //           created_by TEXT,
// // // //           last_modified TEXT,
// // // //           last_modified_by TEXT,
// // // //           is_deleted INTEGER DEFAULT 0,
// // // //           deleted_by TEXT,
// // // //           is_synced INTEGER DEFAULT 0,
// // // //           sync_status TEXT DEFAULT 'pending'
// // // //         )
// // // //       ''');

// // // //       // Create subcategories table if missing
// // // //       await db.database.execute('''
// // // //         CREATE TABLE IF NOT EXISTS subcategories (
// // // //           id INTEGER PRIMARY KEY AUTOINCREMENT,
// // // //           server_id INTEGER,
// // // //           name TEXT NOT NULL,
// // // //           category_id INTEGER NOT NULL,
// // // //           category_server_id INTEGER,
// // // //           category_name TEXT,
// // // //           created_at TEXT,
// // // //           created_by TEXT,
// // // //           last_modified TEXT,
// // // //           last_modified_by TEXT,
// // // //           is_deleted INTEGER DEFAULT 0,
// // // //           deleted_by TEXT,
// // // //           is_synced INTEGER DEFAULT 0,
// // // //           sync_status TEXT DEFAULT 'pending'
// // // //         )
// // // //       ''');

// // // //       await _createHsnTable(db.database);
// // // //       await _createStaffTable(db.database);
// // // //       await _createBasTable(db.database);
// // // //       await _createPaymentModeTable(db.database);
// // // //       await _createSampleTypeTable(db.database);
// // // //       await _createBranchTypeTable(db.database);
// // // //       await _createCollectionCenterTable(db.database); // Add this

// // // //       print('✅ All tables created/verified successfully');
// // // //     } catch (e) {
// // // //       print('❌ Error creating tables: $e');
// // // //       rethrow;
// // // //     }
// // // //   }

// // // //   static Future<void> createHsnTableDirectly() async {
// // // //     try {
// // // //       print('🆘 EMERGENCY: Creating HSN table directly...');
// // // //       final db = await database;
// // // //       try {
// // // //         await db.database.execute('DROP TABLE IF EXISTS hsn_codes');
// // // //       } catch (_) {}
// // // //       await _createHsnTable(db.database);
// // // //       print('✅ HSN table created via direct SQL');
// // // //       final test = await db.database.query('hsn_codes', limit: 1);
// // // //       print('✅ Table verified, row count: ${test.length}');
// // // //     } catch (e) {
// // // //       print('❌ Direct creation failed: $e');
// // // //       rethrow;
// // // //     }
// // // //   }

// // // //   static Future<bool> checkHsnTableExists() async {
// // // //     try {
// // // //       final db = await database;
// // // //       final result = await db.database.rawQuery(
// // // //         "SELECT name FROM sqlite_master WHERE type='table' AND name='hsn_codes'",
// // // //       );
// // // //       return result.isNotEmpty;
// // // //     } catch (e) {
// // // //       print('❌ Error checking HSN table: $e');
// // // //       return false;
// // // //     }
// // // //   }

// // // //   static Future<void> executeRawSQL(String sql) async {
// // // //     try {
// // // //       final db = await database;
// // // //       await db.database.execute(sql);
// // // //       print('✅ SQL executed: $sql');
// // // //     } catch (e) {
// // // //       print('❌ SQL execution failed: $e');
// // // //       rethrow;
// // // //     }
// // // //   }

// // // //   // Add in the migration section

// // // //   // Add this method
// // // //   static Future<void> _createTestTable(DatabaseExecutor database) async {
// // // //     try {
// // // //       await database.execute('''
// // // //       CREATE TABLE IF NOT EXISTS test (
// // // //         id INTEGER PRIMARY KEY AUTOINCREMENT,
// // // //         server_id INTEGER,
// // // //         code TEXT NOT NULL,
// // // //         name TEXT NOT NULL,
// // // //         product_group TEXT NOT NULL,
// // // //         mrp REAL NOT NULL DEFAULT 0.0,
// // // //         sales_rate_a REAL NOT NULL DEFAULT 0.0,
// // // //         sales_rate_b REAL NOT NULL DEFAULT 0.0,
// // // //         hsn_sac TEXT,
// // // //         gst INTEGER NOT NULL DEFAULT 0,
// // // //         barcode TEXT,
// // // //         min_value REAL NOT NULL DEFAULT 0.0,
// // // //         max_value REAL NOT NULL DEFAULT 0.0,
// // // //         unit TEXT NOT NULL,
// // // //         created_at TEXT NOT NULL,
// // // //         created_by TEXT,
// // // //         last_modified TEXT,
// // // //         last_modified_by TEXT,
// // // //         is_deleted INTEGER DEFAULT 0,
// // // //         deleted_by TEXT,
// // // //         is_synced INTEGER DEFAULT 0,
// // // //         sync_status TEXT DEFAULT 'pending',
// // // //         sync_attempts INTEGER DEFAULT 0,
// // // //         last_sync_error TEXT
// // // //       )
// // // //     ''');

// // // //       // Create indexes
// // // //       await database.execute('''
// // // //       CREATE INDEX IF NOT EXISTS idx_test_code
// // // //       ON test(code)
// // // //     ''');

// // // //       await database.execute('''
// // // //       CREATE INDEX IF NOT EXISTS idx_test_name
// // // //       ON test(name)
// // // //     ''');

// // // //       await database.execute('''
// // // //       CREATE INDEX IF NOT EXISTS idx_test_group
// // // //       ON test(product_group)
// // // //     ''');

// // // //       await database.execute('''
// // // //       CREATE INDEX IF NOT EXISTS idx_test_synced
// // // //       ON test(is_synced)
// // // //     ''');

// // // //       await database.execute('''
// // // //       CREATE INDEX IF NOT EXISTS idx_test_deleted
// // // //       ON test(is_deleted)
// // // //     ''');

// // // //       print('✅ Test table created successfully');
// // // //     } catch (e) {
// // // //       print('❌ Error creating test table: $e');
// // // //       rethrow;
// // // //     }
// // // //   }

// // // //   //======================================   PACKAGE PROVIDER ===================================//

// // // //   // Add in migration section (after test migration)

// // // //   // Add this method
// // // //   static Future<void> _createPackageTable(DatabaseExecutor database) async {
// // // //     try {
// // // //       await database.execute('''
// // // //       CREATE TABLE IF NOT EXISTS packages (
// // // //         id INTEGER PRIMARY KEY AUTOINCREMENT,
// // // //         server_id INTEGER,
// // // //         code TEXT NOT NULL,
// // // //         name TEXT NOT NULL,
// // // //         gst REAL NOT NULL DEFAULT 0.0,
// // // //         rate REAL NOT NULL DEFAULT 0.0,
// // // //         tests_json TEXT NOT NULL,
// // // //         created_at TEXT NOT NULL,
// // // //         created_by TEXT,
// // // //         last_modified TEXT,
// // // //         last_modified_by TEXT,
// // // //         is_deleted INTEGER DEFAULT 0,
// // // //         deleted_by TEXT,
// // // //         is_synced INTEGER DEFAULT 0,
// // // //         sync_status TEXT DEFAULT 'pending',
// // // //         sync_attempts INTEGER DEFAULT 0,
// // // //         last_sync_error TEXT
// // // //       )
// // // //     ''');

// // // //       // Create indexes
// // // //       await database.execute('''
// // // //       CREATE INDEX IF NOT EXISTS idx_package_code
// // // //       ON packages(code)
// // // //     ''');

// // // //       await database.execute('''
// // // //       CREATE INDEX IF NOT EXISTS idx_package_name
// // // //       ON packages(name)
// // // //     ''');

// // // //       await database.execute('''
// // // //       CREATE INDEX IF NOT EXISTS idx_package_synced
// // // //       ON packages(is_synced)
// // // //     ''');

// // // //       await database.execute('''
// // // //       CREATE INDEX IF NOT EXISTS idx_package_deleted
// // // //       ON packages(is_deleted)
// // // //     ''');

// // // //       print('✅ Packages table created successfully');
// // // //     } catch (e) {
// // // //       print('❌ Error creating packages table: $e');
// // // //       rethrow;
// // // //     }
// // // //   }

// // // //   // Add the _createTestBOMTable method
// // // //   static Future<void> _createTestBOMTable(DatabaseExecutor database) async {
// // // //     try {
// // // //       await database.execute('''
// // // //       CREATE TABLE IF NOT EXISTS test_boms (
// // // //         id INTEGER PRIMARY KEY AUTOINCREMENT,
// // // //         server_id INTEGER,
// // // //         code TEXT NOT NULL UNIQUE,
// // // //         name TEXT NOT NULL,
// // // //         test_group TEXT NOT NULL,
// // // //         gender_type TEXT NOT NULL,
// // // //         description TEXT,
// // // //         rate REAL NOT NULL DEFAULT 0.0,
// // // //         gst REAL NOT NULL DEFAULT 0.0,
// // // //         turn_around_time TEXT NOT NULL,
// // // //         time_unit TEXT NOT NULL DEFAULT 'hours',
// // // //         is_active INTEGER DEFAULT 1,
// // // //         method TEXT,
// // // //         reference_range TEXT,
// // // //         clinical_significance TEXT,
// // // //         specimen_requirement TEXT,
// // // //         created_at TEXT NOT NULL,
// // // //         created_by TEXT NOT NULL,
// // // //         last_modified TEXT,
// // // //         last_modified_by TEXT,
// // // //         is_deleted INTEGER DEFAULT 0,
// // // //         deleted_by TEXT,
// // // //         is_synced INTEGER DEFAULT 0,
// // // //         sync_status TEXT DEFAULT 'pending',
// // // //         sync_attempts INTEGER DEFAULT 0,
// // // //         last_sync_error TEXT,
// // // //         parameters TEXT NOT NULL
// // // //       )
// // // //     ''');

// // // //       // Create indexes
// // // //       await database.execute('''
// // // //       CREATE INDEX IF NOT EXISTS idx_test_bom_code
// // // //       ON test_boms(code)
// // // //     ''');

// // // //       await database.execute('''
// // // //       CREATE INDEX IF NOT EXISTS idx_test_bom_name
// // // //       ON test_boms(name)
// // // //     ''');

// // // //       await database.execute('''
// // // //       CREATE INDEX IF NOT EXISTS idx_test_bom_group
// // // //       ON test_boms(test_group)
// // // //     ''');

// // // //       await database.execute('''
// // // //       CREATE INDEX IF NOT EXISTS idx_test_bom_active
// // // //       ON test_boms(is_active)
// // // //     ''');

// // // //       await database.execute('''
// // // //       CREATE INDEX IF NOT EXISTS idx_test_bom_synced
// // // //       ON test_boms(is_synced)
// // // //     ''');

// // // //       await database.execute('''
// // // //       CREATE INDEX IF NOT EXISTS idx_test_bom_deleted
// // // //       ON test_boms(is_deleted)
// // // //     ''');

// // // //       print('✅ Test BOM table created successfully');
// // // //     } catch (e) {
// // // //       print('❌ Error creating Test BOM table: $e');
// // // //       rethrow;
// // // //     }
// // // //   }

// // // //   // Add ensureTestBOMTableExists method
// // // //   static Future<void> ensureTestBOMTableExists() async {
// // // //     try {
// // // //       print('🔍 Checking Test BOM table...');

// // // //       final db = await database;

// // // //       final result = await db.database.rawQuery(
// // // //         "SELECT name FROM sqlite_master WHERE type='table' AND name='test_boms'",
// // // //       );

// // // //       if (result.isEmpty) {
// // // //         print('❌ Test BOM table NOT found! Creating immediately...');

// // // //         await db.database.execute('''
// // // //         CREATE TABLE test_boms (
// // // //           id INTEGER PRIMARY KEY AUTOINCREMENT,
// // // //           server_id INTEGER,
// // // //           code TEXT NOT NULL UNIQUE,
// // // //           name TEXT NOT NULL,
// // // //           test_group TEXT NOT NULL,
// // // //           gender_type TEXT NOT NULL,
// // // //           description TEXT,
// // // //           rate REAL NOT NULL DEFAULT 0.0,
// // // //           gst REAL NOT NULL DEFAULT 0.0,
// // // //           turn_around_time TEXT NOT NULL,
// // // //           time_unit TEXT NOT NULL DEFAULT 'hours',
// // // //           is_active INTEGER DEFAULT 1,
// // // //           method TEXT,
// // // //           reference_range TEXT,
// // // //           clinical_significance TEXT,
// // // //           specimen_requirement TEXT,
// // // //           created_at TEXT NOT NULL,
// // // //           created_by TEXT NOT NULL,
// // // //           last_modified TEXT,
// // // //           last_modified_by TEXT,
// // // //           is_deleted INTEGER DEFAULT 0,
// // // //           deleted_by TEXT,
// // // //           is_synced INTEGER DEFAULT 0,
// // // //           sync_status TEXT DEFAULT 'pending',
// // // //           sync_attempts INTEGER DEFAULT 0,
// // // //           last_sync_error TEXT,
// // // //           parameters TEXT NOT NULL
// // // //         )
// // // //       ''');

// // // //         // Create indexes
// // // //         await db.database.execute('''
// // // //         CREATE INDEX IF NOT EXISTS idx_test_bom_code ON test_boms(code)
// // // //       ''');

// // // //         await db.database.execute('''
// // // //         CREATE INDEX IF NOT EXISTS idx_test_bom_name ON test_boms(name)
// // // //       ''');

// // // //         await db.database.execute('''
// // // //         CREATE INDEX IF NOT EXISTS idx_test_bom_group ON test_boms(test_group)
// // // //       ''');

// // // //         await db.database.execute('''
// // // //         CREATE INDEX IF NOT EXISTS idx_test_bom_active ON test_boms(is_active)
// // // //       ''');

// // // //         await db.database.execute('''
// // // //         CREATE INDEX IF NOT EXISTS idx_test_bom_synced ON test_boms(is_synced)
// // // //       ''');

// // // //         await db.database.execute('''
// // // //         CREATE INDEX IF NOT EXISTS idx_test_bom_deleted ON test_boms(is_deleted)
// // // //       ''');

// // // //         print('✅ Test BOM table created successfully via direct SQL');
// // // //       } else {
// // // //         print('✅ Test BOM table already exists');
// // // //       }
// // // //     } catch (e) {
// // // //       print('❌ Error in ensureTestBOMTableExists: $e');
// // // //     }
// // // //   }

// // // //   // Add initializeTestBOMScreen method
// // // //   static Future<void> initializeTestBOMScreen() async {
// // // //     try {
// // // //       print('🚀 Initializing Test BOM screen...');
// // // //       await ensureTestBOMTableExists();
// // // //       await debugDatabase();

// // // //       print('✅ Test BOM screen ready!');
// // // //     } catch (e) {
// // // //       print('❌ Test BOM initialization failed: $e');
// // // //     }
// // // //   }

// // // //   // Add checkTestBOMTableExists method
// // // //   static Future<bool> checkTestBOMTableExists() async {
// // // //     try {
// // // //       final db = await database;
// // // //       final result = await db.database.rawQuery(
// // // //         "SELECT name FROM sqlite_master WHERE type='table' AND name='test_boms'",
// // // //       );
// // // //       return result.isNotEmpty;
// // // //     } catch (e) {
// // // //       print('❌ Error checking Test BOM table: $e');
// // // //       return false;
// // // //     }
// // // //   }

// // // //   // Add createTestBOMTableDirectly method
// // // //   static Future<void> createTestBOMTableDirectly() async {
// // // //     try {
// // // //       print('🆘 EMERGENCY: Creating Test BOM table directly...');

// // // //       final db = await database;

// // // //       // First check if table exists
// // // //       final exists = await checkTestBOMTableExists();
// // // //       if (exists) {
// // // //         print('✅ Test BOM table already exists');
// // // //         return;
// // // //       }

// // // //       print('🔄 Creating Test BOM table...');
// // // //       await _createTestBOMTable(db.database);

// // // //       // Verify
// // // //       final test = await db.database.query('test_boms', limit: 1);
// // // //       print('✅ Test BOM table verified, row count: ${test.length}');
// // // //     } catch (e) {
// // // //       print('❌ Direct creation failed: $e');
// // // //       rethrow;
// // // //     }
// // // //   }

// // // //   // Add Test BOM repository getter (you'll need to create TestBOMRepository class)

// // // //   static Future<void> ensurePackageTableExists() async {
// // // //     try {
// // // //       print('🔍 Checking packages table...');
// // // //       final db = await database;
// // // //       final result = await db.database.rawQuery(
// // // //         "SELECT name FROM sqlite_master WHERE type='table' AND name='packages'",
// // // //       );

// // // //       if (result.isEmpty) {
// // // //         print('❌ Packages table NOT found! Creating immediately...');
// // // //         await _createPackageTable(db.database);
// // // //         print('✅ Packages table created successfully via direct SQL');
// // // //       } else {
// // // //         print('✅ Packages table already exists');
// // // //       }
// // // //     } catch (e) {
// // // //       print('❌ Error in ensurePackageTableExists: $e');
// // // //     }
// // // //   }

// // // //   static Future<void> initializePackageScreen() async {
// // // //     try {
// // // //       print('🚀 Initializing package screen...');
// // // //       await ensurePackageTableExists();
// // // //       print('✅ Package screen ready!');
// // // //     } catch (e) {
// // // //       print('❌ Package initialization failed: $e');
// // // //     }
// // // //   }

// // // //   // Add helper methods
// // // //   static Future<void> ensureTestTableExists() async {
// // // //     try {
// // // //       print('🔍 Checking test table...');
// // // //       final db = await database;
// // // //       final result = await db.database.rawQuery(
// // // //         "SELECT name FROM sqlite_master WHERE type='table' AND name='test'",
// // // //       );

// // // //       if (result.isEmpty) {
// // // //         print('❌ Test table NOT found! Creating immediately...');
// // // //         await _createTestTable(db.database);
// // // //         print('✅ Test table created successfully via direct SQL');
// // // //       } else {
// // // //         print('✅ Test table already exists');
// // // //       }
// // // //     } catch (e) {
// // // //       print('❌ Error in ensureTestTableExists: $e');
// // // //     }
// // // //   }

// // // //   static Future<bool> checkTestTableExists() async {
// // // //     try {
// // // //       final db = await database;
// // // //       final result = await db.database.rawQuery(
// // // //         "SELECT name FROM sqlite_master WHERE type='table' AND name='test'",
// // // //       );
// // // //       return result.isNotEmpty;
// // // //     } catch (e) {
// // // //       print('❌ Error checking test table: $e');
// // // //       return false;
// // // //     }
// // // //   }

// // // //   static Future<void> initializeTestScreen() async {
// // // //     try {
// // // //       print('🚀 Initializing test screen...');
// // // //       await ensureTestTableExists();
// // // //       await debugDatabase();
// // // //       print('✅ Test screen ready!');
// // // //     } catch (e) {
// // // //       print('❌ Test initialization failed: $e');
// // // //     }
// // // //   }
// // // // }

// // // // ignore_for_file: avoid_print

// // // import 'dart:io';
// // // import 'package:floor/floor.dart';
// // // import 'package:nanohospic/database/app_database.dart';
// // // import 'package:nanohospic/database/repository/branch_type_repo.dart';
// // // import 'package:nanohospic/database/repository/city_repo.dart';
// // // import 'package:nanohospic/database/repository/country_repo.dart';
// // // import 'package:nanohospic/database/repository/group_repo.dart';
// // // import 'package:nanohospic/database/repository/hsn_repo.dart';
// // // import 'package:nanohospic/database/repository/item_cat_repo.dart';
// // // import 'package:nanohospic/database/repository/patient_identity_repo.dart';
// // // import 'package:nanohospic/database/repository/payment_mode_repo.dart';
// // // import 'package:nanohospic/database/repository/refrerrer_repo.dart';
// // // import 'package:nanohospic/database/repository/sample_type_repo.dart';
// // // import 'package:nanohospic/database/repository/staff_repo.dart';
// // // import 'package:nanohospic/database/repository/state_repo.dart';
// // // import 'package:nanohospic/database/repository/sucategory_rep.dart';
// // // import 'package:nanohospic/database/repository/test_bom_repo.dart';
// // // import 'package:nanohospic/database/repository/user_reposetory.dart';
// // // import 'package:nanohospic/database/repository/collection_center_repo.dart';
// // // import 'package:sqflite/sqflite.dart';

// // // class DatabaseProvider {
// // //   // Singleton instance
// // //   static final DatabaseProvider _instance = DatabaseProvider._internal();
// // //   factory DatabaseProvider() => _instance;
// // //   DatabaseProvider._internal();

// // //   // Database and state management
// // //   static AppDatabase? _database;
// // //   static bool _isInitializing = false;
// // //   static bool _initialized = false;

// // //   // Repository instances
// // //   static UserRepository? _userRepository;
// // //   static StaffRepository? _staffRepository;
// // //   static CountryRepository? _countryRepository;
// // //   static StateRepository? _stateRepository;
// // //   static CityRepository? _cityRepository;
// // //   static CategoryRepository? _categoryRepository;
// // //   static SubCategoryRepository? _subCategoryRepository;
// // //   static HsnRepository? _hsnRepository;
// // //   static BasRepository? _basRepository;
// // //   static PaymentModeRepository? _paymentModeRepository;
// // //   static SampleTypeRepository? _sampleTypeRepository;
// // //   static BranchTypeRepository? _branchTypeRepository;
// // //   static CollectionCenterRepository? _collectionCenterRepository;
// // //   static ReferrerRepository? _referrerRepository;
// // //   static GroupRepo? _groupRepository;
// // //   static TestBOMRepository? _testBOMRepository;

// // //   // Main database getter
// // //   static Future<AppDatabase> get database async {
// // //     if (_database != null && _initialized) return _database!;

// // //     if (_isInitializing) {
// // //       print('⏳ Database is already initializing, waiting...');
// // //       while (_isInitializing) {
// // //         await Future.delayed(Duration(milliseconds: 100));
// // //       }
// // //       return _database!;
// // //     }

// // //     _isInitializing = true;

// // //     try {
// // //       print('🚀 ===========================================');
// // //       print('🚀 STARTING DATABASE INITIALIZATION');
// // //       print('🚀 ===========================================');

// // //       // Clean up old database if needed
// // //       await _cleanOldDatabase();

// // //       // Build database with minimal migrations
// // //       _database = await $FloorAppDatabase
// // //           .databaseBuilder('nanohospic_database.db')
// // //           .addMigrations([
// // //             // Single comprehensive migration
// // //             Migration(1, 2, (database) async {
// // //               print('🔄 Running full database setup');
// // //               await _createAllTables(database);
// // //             }),
// // //           ])
// // //           .addCallback(
// // //             Callback(
// // //               onCreate: (database, version) async {
// // //                 print('🏗️ Creating all tables from scratch (onCreate)');
// // //                 await _createAllTables(database);
// // //               },
// // //               onOpen: (database) async {
// // //                 print('📂 Database opened successfully');
// // //                 await _verifyTables(database);
// // //               },
// // //             ),
// // //           )
// // //           .build();

// // //       // Set database version
// // //       await _database!.database.execute('PRAGMA user_version = 2');

// // //       // Verify tables
// // //       await _verifyTables(_database!.database);

// // //       _initialized = true;
// // //       print('✅ ===========================================');
// // //       print('✅ DATABASE INITIALIZED SUCCESSFULLY');
// // //       print('✅ ===========================================');

// // //       return _database!;
// // //     } catch (e, stackTrace) {
// // //       print('❌ ===========================================');
// // //       print('❌ DATABASE INITIALIZATION FAILED');
// // //       print('❌ Error: $e');
// // //       print('❌ Stack trace: $stackTrace');
// // //       print('❌ ===========================================');

// // //       // Emergency recovery
// // //       await _emergencyRecovery();

// // //       // Retry once
// // //       try {
// // //         print('🔄 Retrying database initialization...');
// // //         _database = await $FloorAppDatabase
// // //             .databaseBuilder('nanohospic_database.db')
// // //             .build();

// // //         await _createAllTables(_database!.database);
// // //         _initialized = true;
// // //         print('✅ Database recovered successfully');
// // //       } catch (retryError) {
// // //         print('❌ Recovery failed: $retryError');
// // //         rethrow;
// // //       }
// // //     } finally {
// // //       _isInitializing = false;
// // //     }

// // //     return _database!;
// // //   }

// // //   // Clean old database files
// // //   static Future<void> _cleanOldDatabase() async {
// // //     try {
// // //       final databasesPath = await getDatabasesPath();
// // //       final dbFile = File('$databasesPath/database.db');
// // //       final newDbFile = File('$databasesPath/nanohospic_database.db');

// // //       // Delete old files
// // //       final filesToDelete = [
// // //         dbFile,
// // //         newDbFile,
// // //         File('${dbFile.path}-shm'),
// // //         File('${dbFile.path}-wal'),
// // //         File('${newDbFile.path}-shm'),
// // //         File('${newDbFile.path}-wal'),
// // //       ];

// // //       for (var file in filesToDelete) {
// // //         if (await file.exists()) {
// // //           try {
// // //             await file.delete();
// // //             print('🗑️ Deleted old file: ${file.path}');
// // //           } catch (e) {
// // //             print('⚠️ Could not delete ${file.path}: $e');
// // //           }
// // //         }
// // //       }

// // //       // Also check for old journal files
// // //       final dir = Directory(databasesPath);
// // //       if (await dir.exists()) {
// // //         final files = await dir.list().toList();
// // //         for (var file in files) {
// // //           if (file is File) {
// // //             final name = file.path.split('/').last;
// // //             if (name.contains('database') &&
// // //                 (name.endsWith('-journal') ||
// // //                     name.endsWith('-shm') ||
// // //                     name.endsWith('-wal'))) {
// // //               try {
// // //                 await file.delete();
// // //                 print('🗑️ Deleted old journal: $name');
// // //               } catch (e) {
// // //                 // Ignore deletion errors
// // //               }
// // //             }
// // //           }
// // //         }
// // //       }
// // //     } catch (e) {
// // //       print('⚠️ Error during cleanup: $e');
// // //     }
// // //   }

// // //   // Create all tables
// // //   static Future<void> _createAllTables(DatabaseExecutor database) async {
// // //     try {
// // //       print('🏗️ Creating all tables...');

// // //       // User table
// // //       await database.execute('''
// // //         CREATE TABLE IF NOT EXISTS user (
// // //           id INTEGER PRIMARY KEY AUTOINCREMENT,
// // //           server_id INTEGER,
// // //           name TEXT NOT NULL,
// // //           email TEXT NOT NULL UNIQUE,
// // //           phone TEXT,
// // //           password TEXT,
// // //           role TEXT,
// // //           created_at TEXT,
// // //           updated_at TEXT,
// // //           is_active INTEGER DEFAULT 1,
// // //           is_deleted INTEGER DEFAULT 0,
// // //           is_synced INTEGER DEFAULT 0
// // //         )
// // //       ''');
// // //       print('✅ Created: user table');

// // //       // Countries table
// // //       await database.execute('''
// // //         CREATE TABLE IF NOT EXISTS countries (
// // //           id INTEGER PRIMARY KEY AUTOINCREMENT,
// // //           server_id INTEGER,
// // //           name TEXT NOT NULL,
// // //           code TEXT,
// // //           phone_code TEXT,
// // //           created_at TEXT,
// // //           updated_at TEXT,
// // //           is_deleted INTEGER DEFAULT 0,
// // //           is_synced INTEGER DEFAULT 0
// // //         )
// // //       ''');
// // //       print('✅ Created: countries table');

// // //       // States table
// // //       await database.execute('''
// // //         CREATE TABLE IF NOT EXISTS states (
// // //           id INTEGER PRIMARY KEY AUTOINCREMENT,
// // //           server_id INTEGER,
// // //           name TEXT NOT NULL,
// // //           country_id INTEGER,
// // //           country_name TEXT,
// // //           created_at TEXT,
// // //           updated_at TEXT,
// // //           is_deleted INTEGER DEFAULT 0,
// // //           is_synced INTEGER DEFAULT 0
// // //         )
// // //       ''');
// // //       print('✅ Created: states table');

// // //       // Cities table
// // //       await database.execute('''
// // //         CREATE TABLE IF NOT EXISTS cities (
// // //           id INTEGER PRIMARY KEY AUTOINCREMENT,
// // //           server_id INTEGER,
// // //           name TEXT NOT NULL,
// // //           state_id INTEGER,
// // //           state_name TEXT,
// // //           created_at TEXT,
// // //           updated_at TEXT,
// // //           is_deleted INTEGER DEFAULT 0,
// // //           is_synced INTEGER DEFAULT 0
// // //         )
// // //       ''');
// // //       print('✅ Created: cities table');

// // //       // Categories table
// // //       await database.execute('''
// // //         CREATE TABLE IF NOT EXISTS categories (
// // //           id INTEGER PRIMARY KEY AUTOINCREMENT,
// // //           server_id INTEGER,
// // //           category_name TEXT NOT NULL,
// // //           created_at TEXT,
// // //           created_by TEXT,
// // //           last_modified TEXT,
// // //           last_modified_by TEXT,
// // //           is_deleted INTEGER DEFAULT 0,
// // //           deleted_by TEXT,
// // //           is_synced INTEGER DEFAULT 0,
// // //           sync_status TEXT DEFAULT 'pending'
// // //         )
// // //       ''');
// // //       print('✅ Created: categories table');

// // //       // Subcategories table
// // //       await database.execute('''
// // //         CREATE TABLE IF NOT EXISTS subcategories (
// // //           id INTEGER PRIMARY KEY AUTOINCREMENT,
// // //           server_id INTEGER,
// // //           name TEXT NOT NULL,
// // //           category_id INTEGER NOT NULL,
// // //           category_server_id INTEGER,
// // //           category_name TEXT,
// // //           created_at TEXT,
// // //           created_by TEXT,
// // //           last_modified TEXT,
// // //           last_modified_by TEXT,
// // //           is_deleted INTEGER DEFAULT 0,
// // //           deleted_by TEXT,
// // //           is_synced INTEGER DEFAULT 0,
// // //           sync_status TEXT DEFAULT 'pending'
// // //         )
// // //       ''');
// // //       print('✅ Created: subcategories table');

// // //       // HSN codes table
// // //       await database.execute('''
// // //         CREATE TABLE IF NOT EXISTS hsn_codes (
// // //           id INTEGER PRIMARY KEY AUTOINCREMENT,
// // //           server_id INTEGER,
// // //           hsn_code TEXT NOT NULL UNIQUE,
// // //           sgst REAL DEFAULT 0,
// // //           cgst REAL DEFAULT 0,
// // //           igst REAL DEFAULT 0,
// // //           cess REAL DEFAULT 0,
// // //           hsn_type INTEGER,
// // //           tenant TEXT,
// // //           tenant_id TEXT,
// // //           created_at TEXT NOT NULL,
// // //           created_by TEXT NOT NULL,
// // //           last_modified TEXT,
// // //           last_modified_by TEXT,
// // //           deleted TEXT,
// // //           deleted_by TEXT,
// // //           is_synced INTEGER DEFAULT 0,
// // //           is_deleted INTEGER DEFAULT 0,
// // //           sync_attempts INTEGER DEFAULT 0,
// // //           last_sync_error TEXT
// // //         )
// // //       ''');
// // //       print('✅ Created: hsn_codes table');

// // //       // Staff table
// // //       await database.execute('''
// // //         CREATE TABLE IF NOT EXISTS staff (
// // //           id INTEGER PRIMARY KEY AUTOINCREMENT,
// // //           server_id INTEGER,
// // //           name TEXT NOT NULL,
// // //           department TEXT NOT NULL,
// // //           designation TEXT NOT NULL,
// // //           email TEXT,
// // //           phone TEXT NOT NULL,
// // //           required_credentials TEXT NOT NULL,
// // //           created_at TEXT NOT NULL,
// // //           created_by TEXT,
// // //           last_modified TEXT,
// // //           last_modified_by TEXT,
// // //           is_deleted INTEGER DEFAULT 0,
// // //           deleted_by TEXT,
// // //           is_synced INTEGER DEFAULT 0,
// // //           sync_status TEXT DEFAULT 'pending',
// // //           sync_attempts INTEGER DEFAULT 0,
// // //           last_sync_error TEXT
// // //         )
// // //       ''');
// // //       print('✅ Created: staff table');

// // //       // BAS names table
// // //       await database.execute('''
// // //         CREATE TABLE IF NOT EXISTS bas_names (
// // //           id INTEGER PRIMARY KEY AUTOINCREMENT,
// // //           server_id INTEGER,
// // //           name TEXT NOT NULL,
// // //           created_at TEXT,
// // //           created_by TEXT,
// // //           last_modified TEXT,
// // //           last_modified_by TEXT,
// // //           is_deleted INTEGER DEFAULT 0,
// // //           deleted_by TEXT,
// // //           is_synced INTEGER DEFAULT 0,
// // //           sync_status TEXT DEFAULT 'pending',
// // //           sync_attempts INTEGER DEFAULT 0,
// // //           last_sync_error TEXT
// // //         )
// // //       ''');
// // //       print('✅ Created: bas_names table');

// // //       // Payment modes table
// // //       await database.execute('''
// // //         CREATE TABLE IF NOT EXISTS payment_modes (
// // //           id INTEGER PRIMARY KEY AUTOINCREMENT,
// // //           server_id INTEGER,
// // //           name TEXT NOT NULL,
// // //           description TEXT,
// // //           tenant_id TEXT,
// // //           created_at TEXT,
// // //           created_by TEXT,
// // //           last_modified TEXT,
// // //           last_modified_by TEXT,
// // //           is_deleted INTEGER DEFAULT 0,
// // //           deleted_by TEXT,
// // //           is_synced INTEGER DEFAULT 0,
// // //           sync_status TEXT DEFAULT 'pending',
// // //           sync_attempts INTEGER DEFAULT 0,
// // //           last_sync_error TEXT
// // //         )
// // //       ''');
// // //       print('✅ Created: payment_modes table');

// // //       // Sample types table
// // //       await database.execute('''
// // //         CREATE TABLE IF NOT EXISTS sample_types (
// // //           id INTEGER PRIMARY KEY AUTOINCREMENT,
// // //           server_id INTEGER,
// // //           name TEXT NOT NULL,
// // //           description TEXT,
// // //           created_at TEXT,
// // //           created_by TEXT,
// // //           last_modified TEXT,
// // //           last_modified_by TEXT,
// // //           is_deleted INTEGER DEFAULT 0,
// // //           deleted_by TEXT,
// // //           is_synced INTEGER DEFAULT 0,
// // //           sync_status TEXT DEFAULT 'pending',
// // //           sync_attempts INTEGER DEFAULT 0,
// // //           last_sync_error TEXT
// // //         )
// // //       ''');
// // //       print('✅ Created: sample_types table');

// // //       // Branch types table
// // //       await database.execute('''
// // //         CREATE TABLE IF NOT EXISTS branch_types (
// // //           id INTEGER PRIMARY KEY AUTOINCREMENT,
// // //           server_id INTEGER,
// // //           company_name TEXT NOT NULL,
// // //           contact_person TEXT NOT NULL,
// // //           contact_no TEXT NOT NULL,
// // //           email TEXT NOT NULL,
// // //           address1 TEXT NOT NULL,
// // //           location TEXT NOT NULL,
// // //           type TEXT NOT NULL,
// // //           designation TEXT NOT NULL,
// // //           mobile_no TEXT NOT NULL,
// // //           address2 TEXT,
// // //           country TEXT NOT NULL,
// // //           state TEXT NOT NULL,
// // //           city TEXT NOT NULL,
// // //           created_at TEXT,
// // //           created_by TEXT,
// // //           last_modified TEXT,
// // //           last_modified_by TEXT,
// // //           is_deleted INTEGER DEFAULT 0,
// // //           deleted_by TEXT,
// // //           is_synced INTEGER DEFAULT 0,
// // //           sync_status TEXT DEFAULT 'pending',
// // //           sync_attempts INTEGER DEFAULT 0,
// // //           last_sync_error TEXT
// // //         )
// // //       ''');
// // //       print('✅ Created: branch_types table');

// // //       // Collection centers table
// // //       await database.execute('''
// // //         CREATE TABLE IF NOT EXISTS collection_centers (
// // //           id INTEGER PRIMARY KEY AUTOINCREMENT,
// // //           server_id INTEGER,
// // //           center_code TEXT NOT NULL,
// // //           center_name TEXT NOT NULL,
// // //           country TEXT NOT NULL,
// // //           state TEXT NOT NULL,
// // //           city TEXT NOT NULL,
// // //           address1 TEXT NOT NULL,
// // //           address2 TEXT,
// // //           location TEXT,
// // //           postal_code TEXT,
// // //           latitude REAL DEFAULT 0.0,
// // //           longitude REAL DEFAULT 0.0,
// // //           gst_number TEXT,
// // //           pan_number TEXT,
// // //           contact_person_name TEXT NOT NULL,
// // //           phone_no TEXT NOT NULL,
// // //           email TEXT,
// // //           centre_status TEXT NOT NULL,
// // //           branch_type_id INTEGER,
// // //           lab_affiliation_company TEXT,
// // //           operational_hours_from TEXT,
// // //           operational_hours_to TEXT,
// // //           collection_days TEXT,
// // //           sample_pickup_timing_from TEXT,
// // //           sample_pickup_timing_to TEXT,
// // //           transport_mode TEXT,
// // //           courier_agency_name TEXT,
// // //           commission_type TEXT,
// // //           commission_value REAL DEFAULT 0.0,
// // //           account_holder_name TEXT,
// // //           account_no TEXT,
// // //           ifsc_code TEXT,
// // //           agreement_file1_path TEXT,
// // //           agreement_file2_path TEXT,
// // //           created_at TEXT,
// // //           created_by TEXT,
// // //           last_modified TEXT,
// // //           last_modified_by TEXT,
// // //           is_deleted INTEGER DEFAULT 0,
// // //           deleted_by TEXT,
// // //           is_synced INTEGER DEFAULT 0,
// // //           sync_status TEXT DEFAULT 'pending',
// // //           sync_attempts INTEGER DEFAULT 0,
// // //           last_sync_error TEXT
// // //         )
// // //       ''');
// // //       print('✅ Created: collection_centers table');

// // //       // Groups table
// // //       await database.execute('''
// // //         CREATE TABLE IF NOT EXISTS groups (
// // //           id INTEGER PRIMARY KEY AUTOINCREMENT,
// // //           server_id INTEGER,
// // //           name TEXT NOT NULL,
// // //           description TEXT,
// // //           code TEXT,
// // //           type TEXT DEFAULT 'general',
// // //           status TEXT DEFAULT 'active',
// // //           tenant_id TEXT,
// // //           created_at TEXT,
// // //           created_by TEXT,
// // //           last_modified TEXT,
// // //           last_modified_by TEXT,
// // //           is_deleted INTEGER DEFAULT 0,
// // //           deleted_by TEXT,
// // //           is_synced INTEGER DEFAULT 0,
// // //           sync_status TEXT DEFAULT 'pending',
// // //           sync_attempts INTEGER DEFAULT 0,
// // //           last_sync_error TEXT
// // //         )
// // //       ''');
// // //       print('✅ Created: groups table');

// // //       // Test table
// // //       await database.execute('''
// // //         CREATE TABLE IF NOT EXISTS test (
// // //           id INTEGER PRIMARY KEY AUTOINCREMENT,
// // //           server_id INTEGER,
// // //           code TEXT NOT NULL,
// // //           name TEXT NOT NULL,
// // //           product_group TEXT NOT NULL,
// // //           mrp REAL NOT NULL DEFAULT 0.0,
// // //           sales_rate_a REAL NOT NULL DEFAULT 0.0,
// // //           sales_rate_b REAL NOT NULL DEFAULT 0.0,
// // //           hsn_sac TEXT,
// // //           gst INTEGER NOT NULL DEFAULT 0,
// // //           barcode TEXT,
// // //           min_value REAL NOT NULL DEFAULT 0.0,
// // //           max_value REAL NOT NULL DEFAULT 0.0,
// // //           unit TEXT NOT NULL,
// // //           created_at TEXT NOT NULL,
// // //           created_by TEXT,
// // //           last_modified TEXT,
// // //           last_modified_by TEXT,
// // //           is_deleted INTEGER DEFAULT 0,
// // //           deleted_by TEXT,
// // //           is_synced INTEGER DEFAULT 0,
// // //           sync_status TEXT DEFAULT 'pending',
// // //           sync_attempts INTEGER DEFAULT 0,
// // //           last_sync_error TEXT
// // //         )
// // //       ''');
// // //       print('✅ Created: test table');

// // //       // Packages table
// // //       await database.execute('''
// // //         CREATE TABLE IF NOT EXISTS packages (
// // //           id INTEGER PRIMARY KEY AUTOINCREMENT,
// // //           server_id INTEGER,
// // //           code TEXT NOT NULL,
// // //           name TEXT NOT NULL,
// // //           gst REAL NOT NULL DEFAULT 0.0,
// // //           rate REAL NOT NULL DEFAULT 0.0,
// // //           tests_json TEXT NOT NULL,
// // //           created_at TEXT NOT NULL,
// // //           created_by TEXT,
// // //           last_modified TEXT,
// // //           last_modified_by TEXT,
// // //           is_deleted INTEGER DEFAULT 0,
// // //           deleted_by TEXT,
// // //           is_synced INTEGER DEFAULT 0,
// // //           sync_status TEXT DEFAULT 'pending',
// // //           sync_attempts INTEGER DEFAULT 0,
// // //           last_sync_error TEXT
// // //         )
// // //       ''');
// // //       print('✅ Created: packages table');

// // //       // Test BOM table
// // //       await database.execute('''
// // //         CREATE TABLE IF NOT EXISTS test_boms (
// // //           id INTEGER PRIMARY KEY AUTOINCREMENT,
// // //           server_id INTEGER,
// // //           code TEXT NOT NULL UNIQUE,
// // //           name TEXT NOT NULL,
// // //           test_group TEXT NOT NULL,
// // //           gender_type TEXT NOT NULL,
// // //           description TEXT,
// // //           rate REAL NOT NULL DEFAULT 0.0,
// // //           gst REAL NOT NULL DEFAULT 0.0,
// // //           turn_around_time TEXT NOT NULL,
// // //           time_unit TEXT NOT NULL DEFAULT 'hours',
// // //           is_active INTEGER DEFAULT 1,
// // //           method TEXT,
// // //           reference_range TEXT,
// // //           clinical_significance TEXT,
// // //           specimen_requirement TEXT,
// // //           created_at TEXT NOT NULL,
// // //           created_by TEXT NOT NULL,
// // //           last_modified TEXT,
// // //           last_modified_by TEXT,
// // //           is_deleted INTEGER DEFAULT 0,
// // //           deleted_by TEXT,
// // //           is_synced INTEGER DEFAULT 0,
// // //           sync_status TEXT DEFAULT 'pending',
// // //           sync_attempts INTEGER DEFAULT 0,
// // //           last_sync_error TEXT,
// // //           parameters TEXT NOT NULL
// // //         )
// // //       ''');
// // //       print('✅ Created: test_boms table');

// // //       // Patient identities table
// // //       await database.execute('''
// // //         CREATE TABLE IF NOT EXISTS patient_identities (
// // //           id INTEGER PRIMARY KEY AUTOINCREMENT,
// // //           server_id INTEGER,
// // //           name TEXT NOT NULL,
// // //           created_at TEXT,
// // //           updated_at TEXT,
// // //           is_deleted INTEGER DEFAULT 0,
// // //           is_synced INTEGER DEFAULT 0
// // //         )
// // //       ''');
// // //       print('✅ Created: patient_identities table');

// // //       // Referrers table
// // //       await database.execute('''
// // //         CREATE TABLE IF NOT EXISTS referrers (
// // //           id INTEGER PRIMARY KEY AUTOINCREMENT,
// // //           server_id INTEGER,
// // //           name TEXT NOT NULL,
// // //           qualification TEXT,
// // //           speciality TEXT,
// // //           phone TEXT,
// // //           email TEXT,
// // //           address TEXT,
// // //           commission_type TEXT,
// // //           commission_value REAL,
// // //           created_at TEXT,
// // //           updated_at TEXT,
// // //           is_deleted INTEGER DEFAULT 0,
// // //           is_synced INTEGER DEFAULT 0
// // //         )
// // //       ''');
// // //       print('✅ Created: referrers table');

// // //       print('✅ All tables created successfully');
// // //     } catch (e, stackTrace) {
// // //       print('❌ Error creating tables: $e');
// // //       print('Stack trace: $stackTrace');
// // //       rethrow;
// // //     }
// // //   }

// // //   // Verify tables exist
// // //   static Future<void> _verifyTables(DatabaseExecutor database) async {
// // //     try {
// // //       print('🔍 Verifying all tables...');

// // //       final tables = await database.rawQuery(
// // //         "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'",
// // //       );

// // //       final tableNames = tables.map((t) => t['name'] as String).toList();
// // //       print('📋 Found ${tableNames.length} tables: ${tableNames.join(', ')}');

// // //       if (tableNames.isEmpty) {
// // //         print('⚠️ No tables found, creating them...');
// // //         await _createAllTables(database);
// // //       }

// // //       // Check for essential tables
// // //       final essentialTables = ['user', 'categories', 'test', 'packages'];
// // //       for (var table in essentialTables) {
// // //         if (!tableNames.contains(table)) {
// // //           print('⚠️ Missing essential table: $table');
// // //           await _createAllTables(database);
// // //           break;
// // //         }
// // //       }

// // //       print('✅ Table verification completed');
// // //     } catch (e) {
// // //       print('❌ Table verification failed: $e');
// // //     }
// // //   }

// // //   // Emergency recovery
// // //   static Future<void> _emergencyRecovery() async {
// // //     try {
// // //       print('🆘 Starting emergency recovery...');

// // //       // Close existing connection
// // //       if (_database != null) {
// // //         try {
// // //           await _database!.close();
// // //         } catch (e) {
// // //           print('⚠️ Error closing database: $e');
// // //         }
// // //         _database = null;
// // //       }

// // //       // Reset state
// // //       _initialized = false;
// // //       _isInitializing = false;

// // //       // Clear all repository instances
// // //       _userRepository = null;
// // //       _staffRepository = null;
// // //       _countryRepository = null;
// // //       _stateRepository = null;
// // //       _cityRepository = null;
// // //       _categoryRepository = null;
// // //       _subCategoryRepository = null;
// // //       _hsnRepository = null;
// // //       _basRepository = null;
// // //       _paymentModeRepository = null;
// // //       _sampleTypeRepository = null;
// // //       _branchTypeRepository = null;
// // //       _collectionCenterRepository = null;
// // //       _referrerRepository = null;
// // //       _groupRepository = null;
// // //       _testBOMRepository = null;
// // //       print('✅ Emergency recovery completed');
// // //     } catch (e) {
// // //       print('❌ Emergency recovery failed: $e');
// // //     }
// // //   }

// // //   static Future<UserRepository> get userRepository async {
// // //     final db = await database;
// // //     _userRepository ??= UserRepository(db);
// // //     return _userRepository!;
// // //   }

// // //   static Future<CountryRepository> get countryRepository async {
// // //     final db = await database;
// // //     _countryRepository ??= CountryRepository(db.countryDao);
// // //     return _countryRepository!;
// // //   }

// // //   static Future<StateRepository> get stateRepository async {
// // //     final db = await database;
// // //     _stateRepository ??= StateRepository(db.stateDao);
// // //     return _stateRepository!;
// // //   }

// // //   static Future<CityRepository> get cityRepository async {
// // //     final db = await database;
// // //     _cityRepository ??= CityRepository(db.cityDao);
// // //     return _cityRepository!;
// // //   }

// // //   static Future<CategoryRepository> get categoryRepository async {
// // //     final db = await database;
// // //     _categoryRepository ??= CategoryRepository(db.categoryDao);
// // //     return _categoryRepository!;
// // //   }

// // //   static Future<SubCategoryRepository> get subCategoryRepository async {
// // //     final db = await database;
// // //     _subCategoryRepository ??= SubCategoryRepository(db.subcategoryDao);
// // //     return _subCategoryRepository!;
// // //   }

// // //   static Future<HsnRepository> get hsnRepository async {
// // //     final db = await database;
// // //     _hsnRepository ??= HsnRepository(db.hsnDao);
// // //     return _hsnRepository!;
// // //   }

// // //   static Future<StaffRepository> get staffRepository async {
// // //     final db = await database;
// // //     _staffRepository ??= StaffRepository(db.staffDao);
// // //     return _staffRepository!;
// // //   }

// // //   static Future<BasRepository> get basRepository async {
// // //     final db = await database;
// // //     _basRepository ??= BasRepository(db.basDao);
// // //     return _basRepository!;
// // //   }

// // //   static Future<PaymentModeRepository> get paymentModeRepository async {
// // //     final db = await database;
// // //     _paymentModeRepository ??= PaymentModeRepository(db.paymentModeDao);
// // //     return _paymentModeRepository!;
// // //   }

// // //   static Future<SampleTypeRepository> get sampleTypeRepository async {
// // //     final db = await database;
// // //     _sampleTypeRepository ??= SampleTypeRepository(db.sampleTypeDao);
// // //     return _sampleTypeRepository!;
// // //   }

// // //   static Future<BranchTypeRepository> get branchTypeRepository async {
// // //     final db = await database;
// // //     _branchTypeRepository ??= BranchTypeRepository(db.branchTypeDao);
// // //     return _branchTypeRepository!;
// // //   }

// // //   static Future<CollectionCenterRepository>
// // //   get collectionCenterRepository async {
// // //     final db = await database;
// // //     _collectionCenterRepository ??= CollectionCenterRepository(
// // //       db.collectionCenterDao,
// // //     );
// // //     return _collectionCenterRepository!;
// // //   }

// // //   static Future<GroupRepo> get groupRepository async {
// // //     final db = await database;
// // //     _groupRepository ??= GroupRepo(db.groupDao);
// // //     return _groupRepository!;
// // //   }

// // //   static Future<TestBOMRepository> get testBOMRepository async {
// // //     final db = await database;
// // //     _testBOMRepository ??= TestBOMRepository(db);
// // //     return _testBOMRepository!;
// // //   }

// // //   // Utility methods
// // //   static Future<void> resetDatabase() async {
// // //     print('🔄 Resetting database...');
// // //     await _emergencyRecovery();
// // //     await _cleanOldDatabase();
// // //     _database = null;
// // //     _initialized = false;
// // //     print('✅ Database reset complete');
// // //   }

// // //   static Future<void> closeDatabase() async {
// // //     print('🔒 Closing database...');
// // //     if (_database != null) {
// // //       await _database!.close();
// // //       _database = null;
// // //       _initialized = false;
// // //     }
// // //     print('✅ Database closed');
// // //   }

// // //   static Future<void> debugDatabase() async {
// // //     try {
// // //       print('🔍 Debugging database...');
// // //       final db = await database;
// // //       final versionResult = await db.database.rawQuery('PRAGMA user_version');
// // //       final version = versionResult.first['user_version'];
// // //       print('📊 Database version: $version');
// // //       final tables = await db.database.rawQuery(
// // //         "SELECT name FROM sqlite_master WHERE type='table' ORDER BY name",
// // //       );
// // //       print('📋 Found ${tables.length} tables:');
// // //       for (var table in tables) {
// // //         final tableName = table['name'] as String;
// // //         try {
// // //           final countResult = await db.database.rawQuery(
// // //             'SELECT COUNT(*) as count FROM $tableName',
// // //           );
// // //           final count = countResult.first['count'];
// // //           print('   - $tableName: $count rows');
// // //         } catch (e) {
// // //           print('   - $tableName: ERROR ($e)');
// // //         }
// // //       }
// // //       print('✅ Debug completed');
// // //     } catch (e) {
// // //       print('❌ Debug failed: $e');
// // //     }
// // //   }

// // //   static Future<void> initializeGroupScreen() async {
// // //     try {
// // //       print('🚀 Initializing group screen...');
// // //       final db = await database;
// // //       await _verifyTables(db.database);
// // //       print('✅ Group screen ready');
// // //     } catch (e) {
// // //       print('❌ Group screen initialization failed: $e');
// // //     }
// // //   }

// // //   static Future<void> initializeStaffScreen() async {
// // //     try {
// // //       print('🚀 Initializing staff screen...');
// // //       final db = await database;
// // //       await _verifyTables(db.database);
// // //       print('✅ Staff screen ready');
// // //     } catch (e) {
// // //       print('❌ Staff screen initialization failed: $e');
// // //     }
// // //   }

// // //   static Future<void> initializeTestScreen() async {
// // //     try {
// // //       print('🚀 Initializing test screen...');
// // //       final db = await database;
// // //       await _verifyTables(db.database);
// // //       print('✅ Test screen ready');
// // //     } catch (e) {
// // //       print('❌ Test screen initialization failed: $e');
// // //     }
// // //   }

// // //   static Future<void> initializePackageScreen() async {
// // //     try {
// // //       print('🚀 Initializing package screen...');
// // //       final db = await database;
// // //       await _verifyTables(db.database);
// // //       print('✅ Package screen ready');
// // //     } catch (e) {
// // //       print('❌ Package screen initialization failed: $e');
// // //     }
// // //   }

// // //   static Future<void> initializeTestBOMScreen() async {
// // //     try {
// // //       print('🚀 Initializing Test BOM screen...');
// // //       final db = await database;
// // //       await _verifyTables(db.database);
// // //       print('✅ Test BOM screen ready');
// // //     } catch (e) {
// // //       print('❌ Test BOM initialization failed: $e');
// // //     }
// // //   }

// // //   // Initialize everything
// // //   static Future<void> initializeAll() async {
// // //     try {
// // //       print('🚀 Initializing all database components...');
// // //       await database;
// // //       print('✅ All database components initialized');
// // //     } catch (e) {
// // //       print('❌ Initialization failed: $e');
// // //       await resetDatabase();
// // //       rethrow;
// // //     }
// // //   }

// // //   // Quick test method
// // //   static Future<bool> testConnection() async {
// // //     try {
// // //       final db = await database;
// // //       final result = await db.database.rawQuery('SELECT 1');
// // //       return result.isNotEmpty;
// // //     } catch (e) {
// // //       print('❌ Database test failed: $e');
// // //       return false;
// // //     }
// // //   }

// // //   // Get database info
// // //   static Future<Map<String, dynamic>> getDatabaseInfo() async {
// // //     try {
// // //       final db = await database;
// // //       final versionResult = await db.database.rawQuery('PRAGMA user_version');
// // //       final tables = await db.database.rawQuery(
// // //         "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'",
// // //       );

// // //       final tableCounts = <String, int>{};
// // //       for (var table in tables) {
// // //         final tableName = table['name'] as String;
// // //         final countResult = await db.database.rawQuery(
// // //           'SELECT COUNT(*) as count FROM $tableName',
// // //         );
// // //         tableCounts[tableName] = countResult.first['count'] as int;
// // //       }

// // //       return {
// // //         'version': versionResult.first['user_version'],
// // //         'tables': tables.map((t) => t['name'] as String).toList(),
// // //         'tableCounts': tableCounts,
// // //         'isInitialized': _initialized,
// // //       };
// // //     } catch (e) {
// // //       return {'error': e.toString(), 'isInitialized': _initialized};
// // //     }
// // //   }
// // // }

// // import 'dart:io';
// // import 'package:floor/floor.dart';
// // import 'package:nanohospic/database/app_database.dart';
// // import 'package:nanohospic/database/repository/branch_type_repo.dart';
// // import 'package:nanohospic/database/repository/city_repo.dart';
// // import 'package:nanohospic/database/repository/country_repo.dart';
// // import 'package:nanohospic/database/repository/doctor_commision_repo.dart';
// // import 'package:nanohospic/database/repository/group_repo.dart';
// // import 'package:nanohospic/database/repository/hsn_repo.dart';
// // import 'package:nanohospic/database/repository/instrument_master_repo.dart';
// // import 'package:nanohospic/database/repository/item_cat_repo.dart';
// // import 'package:nanohospic/database/repository/patient_identity_repo.dart';
// // import 'package:nanohospic/database/repository/payment_mode_repo.dart';
// // import 'package:nanohospic/database/repository/refrerrer_repo.dart';
// // import 'package:nanohospic/database/repository/sample_type_repo.dart';
// // import 'package:nanohospic/database/repository/staff_repo.dart';
// // import 'package:nanohospic/database/repository/state_repo.dart';
// // import 'package:nanohospic/database/repository/sucategory_rep.dart';
// // import 'package:nanohospic/database/repository/test_bom_repo.dart';
// // import 'package:nanohospic/database/repository/test_method_master_repo.dart';
// // import 'package:nanohospic/database/repository/user_reposetory.dart';
// // import 'package:nanohospic/database/repository/collection_center_repo.dart';
// // import 'package:nanohospic/database/repository/unit_repo.dart'; // ✅ ADD THIS
// // import 'package:sqflite/sqflite.dart';

// // class DatabaseProvider {

// //   static final DatabaseProvider _instance = DatabaseProvider._internal();
// //   factory DatabaseProvider() => _instance;
// //   DatabaseProvider._internal();

// //   static AppDatabase? _database;
// //   static bool _isInitializing = false;
// //   static bool _initialized = false;

// //   static UserRepository? _userRepository;
// //   static StaffRepository? _staffRepository;
// //   static CountryRepository? _countryRepository;
// //   static StateRepository? _stateRepository;
// //   static CityRepository? _cityRepository;
// //   static CategoryRepository? _categoryRepository;
// //   static SubCategoryRepository? _subCategoryRepository;
// //   static HsnRepository? _hsnRepository;
// //   static BasRepository? _basRepository;
// //   static PaymentModeRepository? _paymentModeRepository;
// //   static SampleTypeRepository? _sampleTypeRepository;
// //   static BranchTypeRepository? _branchTypeRepository;
// //   static CollectionCenterRepository? _collectionCenterRepository;
// //   static ReferrerRepository? _referrerRepository;
// //   static GroupRepository? _groupRepository;
// //   static TestBOMRepository? _testBOMRepository;
// //   static UnitRepository? _unitRepository;
// //   static InstrumentRepository? _instrumentRepository;
// //   static DoctorCommissionRepository? _doctorCommissionRepository;
// //   static TestMethodRepository? _testMethodRepository;

// //   // Main database getter
// //   static Future<AppDatabase> get database async {
// //     if (_database != null && _initialized) return _database!;

// //     if (_isInitializing) {
// //       print('⏳ Database is already initializing, waiting...');
// //       while (_isInitializing) {
// //         await Future.delayed(Duration(milliseconds: 100));
// //       }
// //       return _database!;
// //     }

// //     _isInitializing = true;

// //     try {
// //       print('🚀 ===========================================');
// //       print('🚀 STARTING DATABASE INITIALIZATION');
// //       print('🚀 ===========================================');

// //       // Clean up old database if needed
// //       await _cleanOldDatabase();

// //       // Build database with minimal migrations
// //       _database = await $FloorAppDatabase
// //           .databaseBuilder('nanohospic_database.db')
// //           .addMigrations([
// //             // Single comprehensive migration
// //             Migration(1, 2, (database) async {
// //               print('🔄 Running full database setup');
// //               await _createAllTables(database);
// //             }),
// //           ])
// //           .addCallback(
// //             Callback(
// //               onCreate: (database, version) async {
// //                 print('🏗️ Creating all tables from scratch (onCreate)');
// //                 await _createAllTables(database);
// //               },
// //               onOpen: (database) async {
// //                 print('📂 Database opened successfully');
// //                 await _verifyTables(database);
// //               },
// //             ),
// //           )
// //           .build();
// //       await _database!.database.execute('PRAGMA user_version = 2');
// //       await _verifyTables(_database!.database);

// //       _initialized = true;
// //       print('✅ ===========================================');
// //       print('✅ DATABASE INITIALIZED SUCCESSFULLY');
// //       print('✅ ===========================================');

// //       return _database!;
// //     } catch (e, stackTrace) {
// //       print('❌ ===========================================');
// //       print('❌ DATABASE INITIALIZATION FAILED');
// //       print('❌ Error: $e');
// //       print('❌ Stack trace: $stackTrace');
// //       print('❌ ===========================================');

// //       // Emergency recovery
// //       await _emergencyRecovery();

// //       // Retry once
// //       try {
// //         print('🔄 Retrying database initialization...');
// //         _database = await $FloorAppDatabase
// //             .databaseBuilder('nanohospic_database.db')
// //             .build();

// //         await _createAllTables(_database!.database);
// //         _initialized = true;
// //         print('✅ Database recovered successfully');
// //       } catch (retryError) {
// //         print('❌ Recovery failed: $retryError');
// //         rethrow;
// //       }
// //     } finally {
// //       _isInitializing = false;
// //     }

// //     return _database!;
// //   }

// //   // Clean old database files
// //   static Future<void> _cleanOldDatabase() async {
// //     try {
// //       final databasesPath = await getDatabasesPath();
// //       final dbFile = File('$databasesPath/database.db');
// //       final newDbFile = File('$databasesPath/nanohospic_database.db');

// //       // Delete old files
// //       final filesToDelete = [
// //         dbFile,
// //         newDbFile,
// //         File('${dbFile.path}-shm'),
// //         File('${dbFile.path}-wal'),
// //         File('${newDbFile.path}-shm'),
// //         File('${newDbFile.path}-wal'),
// //       ];

// //       for (var file in filesToDelete) {
// //         if (await file.exists()) {
// //           try {
// //             await file.delete();
// //             print('🗑️ Deleted old file: ${file.path}');
// //           } catch (e) {
// //             print('⚠️ Could not delete ${file.path}: $e');
// //           }
// //         }
// //       }

// //       // Also check for old journal files
// //       final dir = Directory(databasesPath);
// //       if (await dir.exists()) {
// //         final files = await dir.list().toList();
// //         for (var file in files) {
// //           if (file is File) {
// //             final name = file.path.split('/').last;
// //             if (name.contains('database') &&
// //                 (name.endsWith('-journal') ||
// //                     name.endsWith('-shm') ||
// //                     name.endsWith('-wal'))) {
// //               try {
// //                 await file.delete();
// //                 print('🗑️ Deleted old journal: $name');
// //               } catch (e) {
// //                 // Ignore deletion errors
// //               }
// //             }
// //           }
// //         }
// //       }
// //     } catch (e) {
// //       print('⚠️ Error during cleanup: $e');
// //     }
// //   }

// //   // Create all tables
// //   static Future<void> _createAllTables(DatabaseExecutor database) async {
// //     try {
// //       print('🏗️ Creating all tables...');

// //       // User table
// //       await database.execute('''
// //         CREATE TABLE IF NOT EXISTS user (
// //           id INTEGER PRIMARY KEY AUTOINCREMENT,
// //           server_id INTEGER,
// //           name TEXT NOT NULL,
// //           email TEXT NOT NULL UNIQUE,
// //           phone TEXT,
// //           password TEXT,
// //           role TEXT,
// //           created_at TEXT,
// //           updated_at TEXT,
// //           is_active INTEGER DEFAULT 1,
// //           is_deleted INTEGER DEFAULT 0,
// //           is_synced INTEGER DEFAULT 0
// //         )
// //       ''');
// //       print('✅ Created: user table');

// //       // Countries table
// //       await database.execute('''
// //         CREATE TABLE IF NOT EXISTS countries (
// //           id INTEGER PRIMARY KEY AUTOINCREMENT,
// //           server_id INTEGER,
// //           name TEXT NOT NULL,
// //           created_at TEXT,
// //           created_by TEXT,
// //           last_modified TEXT,
// //           last_modified_by TEXT,
// //           is_deleted INTEGER DEFAULT 0,
// //           deleted_by TEXT,
// //           is_synced INTEGER DEFAULT 0,
// //           sync_status TEXT DEFAULT 'pending'
// //         )
// //       ''');
// //       print('✅ Created: countries table');

// //       // ✅ Units table - ADD THIS
// //       await database.execute('''
// //         CREATE TABLE IF NOT EXISTS units (
// //           id INTEGER PRIMARY KEY AUTOINCREMENT,
// //           server_id INTEGER,
// //           name TEXT NOT NULL,
// //           created_at TEXT,
// //           created_by TEXT,
// //           last_modified TEXT,
// //           last_modified_by TEXT,
// //           is_deleted INTEGER DEFAULT 0,
// //           deleted_by TEXT,
// //           is_synced INTEGER DEFAULT 0,
// //           sync_status TEXT DEFAULT 'pending'
// //         )
// //       ''');

// //       await database.execute('''
// //         CREATE TABLE IF NOT EXISTS instruments (
// //           id INTEGER PRIMARY KEY AUTOINCREMENT,
// //           server_id INTEGER,
// //           machine_name TEXT NOT NULL,
// //           description TEXT,
// //           created_at TEXT,
// //           created_by TEXT,
// //           last_modified TEXT,
// //           last_modified_by TEXT,
// //           is_deleted INTEGER DEFAULT 0,
// //           deleted_by TEXT,
// //           is_synced INTEGER DEFAULT 0,
// //           sync_status TEXT DEFAULT 'pending'
// //         )
// //       ''');
// //       print('✅ Created: units table');

// //       // States table
// //       await database.execute('''
// //         CREATE TABLE IF NOT EXISTS states (
// //           id INTEGER PRIMARY KEY AUTOINCREMENT,
// //           server_id INTEGER,
// //           name TEXT NOT NULL,
// //           country_id INTEGER,
// //           country_name TEXT,
// //           created_at TEXT,
// //           updated_at TEXT,
// //           is_deleted INTEGER DEFAULT 0,
// //           is_synced INTEGER DEFAULT 0
// //         )
// //       ''');
// //       print('✅ Created: states table');

// //       // Cities table
// //       await database.execute('''
// //         CREATE TABLE IF NOT EXISTS cities (
// //           id INTEGER PRIMARY KEY AUTOINCREMENT,
// //           server_id INTEGER,
// //           name TEXT NOT NULL,
// //           state_id INTEGER,
// //           state_name TEXT,
// //           created_at TEXT,
// //           updated_at TEXT,
// //           is_deleted INTEGER DEFAULT 0,
// //           is_synced INTEGER DEFAULT 0
// //         )
// //       ''');
// //       print('✅ Created: cities table');

// //       // Categories table
// //       await database.execute('''
// //         CREATE TABLE IF NOT EXISTS categories (
// //           id INTEGER PRIMARY KEY AUTOINCREMENT,
// //           server_id INTEGER,
// //           category_name TEXT NOT NULL,
// //           created_at TEXT,
// //           created_by TEXT,
// //           last_modified TEXT,
// //           last_modified_by TEXT,
// //           is_deleted INTEGER DEFAULT 0,
// //           deleted_by TEXT,
// //           is_synced INTEGER DEFAULT 0,
// //           sync_status TEXT DEFAULT 'pending'
// //         )
// //       ''');
// //       print('✅ Created: categories table');

// //       // Subcategories table
// //       await database.execute('''
// //         CREATE TABLE IF NOT EXISTS subcategories (
// //           id INTEGER PRIMARY KEY AUTOINCREMENT,
// //           server_id INTEGER,
// //           name TEXT NOT NULL,
// //           category_id INTEGER NOT NULL,
// //           category_server_id INTEGER,
// //           category_name TEXT,
// //           created_at TEXT,
// //           created_by TEXT,
// //           last_modified TEXT,
// //           last_modified_by TEXT,
// //           is_deleted INTEGER DEFAULT 0,
// //           deleted_by TEXT,
// //           is_synced INTEGER DEFAULT 0,
// //           sync_status TEXT DEFAULT 'pending'
// //         )
// //       ''');
// //       print('✅ Created: subcategories table');

// //       // HSN codes table
// //       await database.execute('''
// //         CREATE TABLE IF NOT EXISTS hsn_codes (
// //           id INTEGER PRIMARY KEY AUTOINCREMENT,
// //           server_id INTEGER,
// //           hsn_code TEXT NOT NULL UNIQUE,
// //           sgst REAL DEFAULT 0,
// //           cgst REAL DEFAULT 0,
// //           igst REAL DEFAULT 0,
// //           cess REAL DEFAULT 0,
// //           hsn_type INTEGER,
// //           tenant TEXT,
// //           tenant_id TEXT,
// //           created_at TEXT NOT NULL,
// //           created_by TEXT NOT NULL,
// //           last_modified TEXT,
// //           last_modified_by TEXT,
// //           deleted TEXT,
// //           deleted_by TEXT,
// //           is_synced INTEGER DEFAULT 0,
// //           is_deleted INTEGER DEFAULT 0,
// //           sync_attempts INTEGER DEFAULT 0,
// //           last_sync_error TEXT
// //         )
// //       ''');
// //       print('✅ Created: hsn_codes table');

// //       // Staff table
// //       await database.execute('''
// //         CREATE TABLE IF NOT EXISTS staff (
// //           id INTEGER PRIMARY KEY AUTOINCREMENT,
// //           server_id INTEGER,
// //           name TEXT NOT NULL,
// //           department TEXT NOT NULL,
// //           designation TEXT NOT NULL,
// //           email TEXT,
// //           phone TEXT NOT NULL,
// //           required_credentials TEXT NOT NULL,
// //           created_at TEXT NOT NULL,
// //           created_by TEXT,
// //           last_modified TEXT,
// //           last_modified_by TEXT,
// //           is_deleted INTEGER DEFAULT 0,
// //           deleted_by TEXT,
// //           is_synced INTEGER DEFAULT 0,
// //           sync_status TEXT DEFAULT 'pending',
// //           sync_attempts INTEGER DEFAULT 0,
// //           last_sync_error TEXT
// //         )
// //       ''');
// //       print('✅ Created: staff table');

// //       // BAS names table
// //       await database.execute('''
// //         CREATE TABLE IF NOT EXISTS bas_names (
// //           id INTEGER PRIMARY KEY AUTOINCREMENT,
// //           server_id INTEGER,
// //           name TEXT NOT NULL,
// //           created_at TEXT,
// //           created_by TEXT,
// //           last_modified TEXT,
// //           last_modified_by TEXT,
// //           is_deleted INTEGER DEFAULT 0,
// //           deleted_by TEXT,
// //           is_synced INTEGER DEFAULT 0,
// //           sync_status TEXT DEFAULT 'pending',
// //           sync_attempts INTEGER DEFAULT 0,
// //           last_sync_error TEXT
// //         )
// //       ''');

// //       print('✅ Created: bas_names table');

// //       // Payment modes table
// //       await database.execute('''
// //         CREATE TABLE IF NOT EXISTS payment_modes (
// //           id INTEGER PRIMARY KEY AUTOINCREMENT,
// //           server_id INTEGER,
// //           name TEXT NOT NULL,
// //           description TEXT,
// //           tenant_id TEXT,
// //           created_at TEXT,
// //           created_by TEXT,
// //           last_modified TEXT,
// //           last_modified_by TEXT,
// //           is_deleted INTEGER DEFAULT 0,
// //           deleted_by TEXT,
// //           is_synced INTEGER DEFAULT 0,
// //           sync_status TEXT DEFAULT 'pending',
// //           sync_attempts INTEGER DEFAULT 0,
// //           last_sync_error TEXT
// //         )
// //       ''');
// //       print('✅ Created: payment_modes table');

// //       // Sample types table
// //       await database.execute('''
// //         CREATE TABLE IF NOT EXISTS sample_types (
// //           id INTEGER PRIMARY KEY AUTOINCREMENT,
// //           server_id INTEGER,
// //           name TEXT NOT NULL,
// //           description TEXT,
// //           created_at TEXT,
// //           created_by TEXT,
// //           last_modified TEXT,
// //           last_modified_by TEXT,
// //           is_deleted INTEGER DEFAULT 0,
// //           deleted_by TEXT,
// //           is_synced INTEGER DEFAULT 0,
// //           sync_status TEXT DEFAULT 'pending',
// //           sync_attempts INTEGER DEFAULT 0,
// //           last_sync_error TEXT
// //         )
// //       ''');
// //       print('✅ Created: sample_types table');

// //       // Branch types table
// //       await database.execute('''
// //         CREATE TABLE IF NOT EXISTS branch_types (
// //           id INTEGER PRIMARY KEY AUTOINCREMENT,
// //           server_id INTEGER,
// //           company_name TEXT NOT NULL,
// //           contact_person TEXT NOT NULL,
// //           contact_no TEXT NOT NULL,
// //           email TEXT NOT NULL,
// //           address1 TEXT NOT NULL,
// //           location TEXT NOT NULL,
// //           type TEXT NOT NULL,
// //           designation TEXT NOT NULL,
// //           mobile_no TEXT NOT NULL,
// //           address2 TEXT,
// //           country TEXT NOT NULL,
// //           state TEXT NOT NULL,
// //           city TEXT NOT NULL,
// //           created_at TEXT,
// //           created_by TEXT,
// //           last_modified TEXT,
// //           last_modified_by TEXT,
// //           is_deleted INTEGER DEFAULT 0,
// //           deleted_by TEXT,
// //           is_synced INTEGER DEFAULT 0,
// //           sync_status TEXT DEFAULT 'pending',
// //           sync_attempts INTEGER DEFAULT 0,
// //           last_sync_error TEXT
// //         )
// //       ''');
// //       print('✅ Created: branch_types table');

// //       // Collection centers table
// //       await database.execute('''
// //         CREATE TABLE IF NOT EXISTS collection_centers (
// //           id INTEGER PRIMARY KEY AUTOINCREMENT,
// //           server_id INTEGER,
// //           center_code TEXT NOT NULL,
// //           center_name TEXT NOT NULL,
// //           country TEXT NOT NULL,
// //           state TEXT NOT NULL,
// //           city TEXT NOT NULL,
// //           address1 TEXT NOT NULL,
// //           address2 TEXT,
// //           location TEXT,
// //           postal_code TEXT,
// //           latitude REAL DEFAULT 0.0,
// //           longitude REAL DEFAULT 0.0,
// //           gst_number TEXT,
// //           pan_number TEXT,
// //           contact_person_name TEXT NOT NULL,
// //           phone_no TEXT NOT NULL,
// //           email TEXT,
// //           centre_status TEXT NOT NULL,
// //           branch_type_id INTEGER,
// //           lab_affiliation_company TEXT,
// //           operational_hours_from TEXT,
// //           operational_hours_to TEXT,
// //           collection_days TEXT,
// //           sample_pickup_timing_from TEXT,
// //           sample_pickup_timing_to TEXT,
// //           transport_mode TEXT,
// //           courier_agency_name TEXT,
// //           commission_type TEXT,
// //           commission_value REAL DEFAULT 0.0,
// //           account_holder_name TEXT,
// //           account_no TEXT,
// //           ifsc_code TEXT,
// //           agreement_file1_path TEXT,
// //           agreement_file2_path TEXT,
// //           created_at TEXT,
// //           created_by TEXT,
// //           last_modified TEXT,
// //           last_modified_by TEXT,
// //           is_deleted INTEGER DEFAULT 0,
// //           deleted_by TEXT,
// //           is_synced INTEGER DEFAULT 0,
// //           sync_status TEXT DEFAULT 'pending',
// //           sync_attempts INTEGER DEFAULT 0,
// //           last_sync_error TEXT
// //         )
// //       ''');
// //       print('✅ Created: collection_centers table');

// //       // Groups table
// //       await database.execute('''
// //         CREATE TABLE IF NOT EXISTS groups (
// //           id INTEGER PRIMARY KEY AUTOINCREMENT,
// //           server_id INTEGER,
// //           name TEXT NOT NULL,
// //           description TEXT,
// //           code TEXT,
// //           type TEXT DEFAULT 'general',
// //           status TEXT DEFAULT 'active',
// //           tenant_id TEXT,
// //           created_at TEXT,
// //           created_by TEXT,
// //           last_modified TEXT,
// //           last_modified_by TEXT,
// //           is_deleted INTEGER DEFAULT 0,
// //           deleted_by TEXT,
// //           is_synced INTEGER DEFAULT 0,
// //           sync_status TEXT DEFAULT 'pending',
// //           sync_attempts INTEGER DEFAULT 0,
// //           last_sync_error TEXT
// //         )
// //       ''');
// //       print('✅ Created: groups table');

// //       // Test table
// //       await database.execute('''
// //         CREATE TABLE IF NOT EXISTS test (
// //           id INTEGER PRIMARY KEY AUTOINCREMENT,
// //           server_id INTEGER,
// //           code TEXT NOT NULL,
// //           name TEXT NOT NULL,
// //           product_group TEXT NOT NULL,
// //           mrp REAL NOT NULL DEFAULT 0.0,
// //           sales_rate_a REAL NOT NULL DEFAULT 0.0,
// //           sales_rate_b REAL NOT NULL DEFAULT 0.0,
// //           hsn_sac TEXT,
// //           gst INTEGER NOT NULL DEFAULT 0,
// //           barcode TEXT,
// //           min_value REAL NOT NULL DEFAULT 0.0,
// //           max_value REAL NOT NULL DEFAULT 0.0,
// //           unit TEXT NOT NULL,
// //           created_at TEXT NOT NULL,
// //           created_by TEXT,
// //           last_modified TEXT,
// //           last_modified_by TEXT,
// //           is_deleted INTEGER DEFAULT 0,
// //           deleted_by TEXT,
// //           is_synced INTEGER DEFAULT 0,
// //           sync_status TEXT DEFAULT 'pending',
// //           sync_attempts INTEGER DEFAULT 0,
// //           last_sync_error TEXT
// //         )
// //       ''');
// //       print('✅ Created: test table');

// //       // Packages table
// //       await database.execute('''
// //         CREATE TABLE IF NOT EXISTS packages (
// //           id INTEGER PRIMARY KEY AUTOINCREMENT,
// //           server_id INTEGER,
// //           code TEXT NOT NULL,
// //           name TEXT NOT NULL,
// //           gst REAL NOT NULL DEFAULT 0.0,
// //           rate REAL NOT NULL DEFAULT 0.0,
// //           tests_json TEXT NOT NULL,
// //           created_at TEXT NOT NULL,
// //           created_by TEXT,
// //           last_modified TEXT,
// //           last_modified_by TEXT,
// //           is_deleted INTEGER DEFAULT 0,
// //           deleted_by TEXT,
// //           is_synced INTEGER DEFAULT 0,
// //           sync_status TEXT DEFAULT 'pending',
// //           sync_attempts INTEGER DEFAULT 0,
// //           last_sync_error TEXT
// //         )
// //       ''');
// //       print('✅ Created: packages table');

// //       // Test BOM table
// //       await database.execute('''
// //         CREATE TABLE IF NOT EXISTS test_boms (
// //           id INTEGER PRIMARY KEY AUTOINCREMENT,
// //           server_id INTEGER,
// //           code TEXT NOT NULL UNIQUE,
// //           name TEXT NOT NULL,
// //           test_group TEXT NOT NULL,
// //           gender_type TEXT NOT NULL,
// //           description TEXT,
// //           rate REAL NOT NULL DEFAULT 0.0,
// //           gst REAL NOT NULL DEFAULT 0.0,
// //           turn_around_time TEXT NOT NULL,
// //           time_unit TEXT NOT NULL DEFAULT 'hours',
// //           is_active INTEGER DEFAULT 1,
// //           method TEXT,
// //           reference_range TEXT,
// //           clinical_significance TEXT,
// //           specimen_requirement TEXT,
// //           created_at TEXT NOT NULL,
// //           created_by TEXT NOT NULL,
// //           last_modified TEXT,
// //           last_modified_by TEXT,
// //           is_deleted INTEGER DEFAULT 0,
// //           deleted_by TEXT,
// //           is_synced INTEGER DEFAULT 0,
// //           sync_status TEXT DEFAULT 'pending',
// //           sync_attempts INTEGER DEFAULT 0,
// //           last_sync_error TEXT,
// //           parameters TEXT NOT NULL
// //         )
// //       ''');

// //       await database.execute('''
// //   CREATE TABLE IF NOT EXISTS test_methods (
// //     id INTEGER PRIMARY KEY AUTOINCREMENT,
// //     server_id INTEGER,
// //     method_name TEXT NOT NULL,
// //     description TEXT,
// //     created_at TEXT,
// //     created_by TEXT,
// //     last_modified TEXT,
// //     last_modified_by TEXT,
// //     is_deleted INTEGER DEFAULT 0,
// //     deleted_by TEXT,
// //     is_synced INTEGER DEFAULT 0,
// //     sync_status TEXT DEFAULT 'pending'
// //   )
// // ''');
// //       print('✅ Created: test_boms table');

// //       // Patient identities table
// //       await database.execute('''
// //         CREATE TABLE IF NOT EXISTS patient_identities (
// //           id INTEGER PRIMARY KEY AUTOINCREMENT,
// //           server_id INTEGER,
// //           name TEXT NOT NULL,
// //           created_at TEXT,
// //           updated_at TEXT,
// //           is_deleted INTEGER DEFAULT 0,
// //           is_synced INTEGER DEFAULT 0
// //         )
// //       ''');
// //       print('✅ Created: patient_identities table');

// //       // Referrers table
// //       await database.execute('''
// //         CREATE TABLE IF NOT EXISTS referrers (
// //           id INTEGER PRIMARY KEY AUTOINCREMENT,
// //           server_id INTEGER,
// //           name TEXT NOT NULL,
// //           qualification TEXT,
// //           speciality TEXT,
// //           phone TEXT,
// //           email TEXT,
// //           address TEXT,
// //           commission_type TEXT,
// //           commission_value REAL,
// //           created_at TEXT,
// //           updated_at TEXT,
// //           is_deleted INTEGER DEFAULT 0,
// //           is_synced INTEGER DEFAULT 0
// //         )
// //       ''');
// //       print('✅ Created: referrers table');

// //       print('✅ All tables created successfully');
// //     } catch (e, stackTrace) {
// //       print('❌ Error creating tables: $e');
// //       print('Stack trace: $stackTrace');
// //       rethrow;
// //     }
// //   }

// //   // Verify tables exist
// //   static Future<void> _verifyTables(DatabaseExecutor database) async {
// //     try {
// //       print('🔍 Verifying all tables...');

// //       final tables = await database.rawQuery(
// //         "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'",
// //       );

// //       final tableNames = tables.map((t) => t['name'] as String).toList();
// //       print('📋 Found ${tableNames.length} tables: ${tableNames.join(', ')}');

// //       if (tableNames.isEmpty) {
// //         print('⚠️ No tables found, creating them...');
// //         await _createAllTables(database);
// //       }

// //       // Check for essential tables (including units)
// //       final essentialTables = [
// //         'user',
// //         'categories',
// //         'test',
// //         'packages',
// //         'units',
// //         'units',
// //         'instruments',
// //         'test_methods',
// //         'referrers',
// //         'patient_identities',
// //       ];
// //       for (var table in essentialTables) {
// //         if (!tableNames.contains(table)) {
// //           print('⚠️ Missing essential table: $table');
// //           await _createAllTables(database);
// //           break;
// //         }
// //       }

// //       print('✅ Table verification completed');
// //     } catch (e) {
// //       print('❌ Table verification failed: $e');
// //     }
// //   }

// //   // Emergency recovery
// //   static Future<void> _emergencyRecovery() async {
// //     try {
// //       print('🆘 Starting emergency recovery...');

// //       // Close existing connection
// //       if (_database != null) {
// //         try {
// //           await _database!.close();
// //         } catch (e) {
// //           print('⚠️ Error closing database: $e');
// //         }
// //         _database = null;
// //       }

// //       // Reset state
// //       _initialized = false;
// //       _isInitializing = false;
// //       _userRepository = null;
// //       _staffRepository = null;
// //       _countryRepository = null;
// //       _stateRepository = null;
// //       _cityRepository = null;
// //       _categoryRepository = null;
// //       _subCategoryRepository = null;
// //       _hsnRepository = null;
// //       _basRepository = null;
// //       _paymentModeRepository = null;
// //       _sampleTypeRepository = null;
// //       _branchTypeRepository = null;
// //       _collectionCenterRepository = null;
// //       _referrerRepository = null;
// //       _groupRepository = null;
// //       _testBOMRepository = null;
// //       _unitRepository = null;
// //       _instrumentRepository = null;
// //       _doctorCommissionRepository = null;
// //       print('✅ Emergency recovery completed');
// //     } catch (e) {
// //       print('❌ Emergency recovery failed: $e');
// //     }
// //   }

// //   static Future<UserRepository> get userRepository async {
// //     final db = await database;
// //     _userRepository ??= UserRepository(db);
// //     return _userRepository!;
// //   }

// //   static Future<CountryRepository> get countryRepository async {
// //     final db = await database;
// //     _countryRepository ??= CountryRepository(db.countryDao);
// //     return _countryRepository!;
// //   }

// //   static Future<TestMethodRepository> get testMethodRepository async {
// //     final db = await database;
// //     _testMethodRepository ??= TestMethodRepository(db.testMethodDao);
// //     return _testMethodRepository!;
// //   }

// //   static Future<InstrumentRepository> get instrumentRepository async {
// //     final db = await database;
// //     _instrumentRepository ??= InstrumentRepository(db.instrumentDao);
// //     return _instrumentRepository!;
// //   }

// //   static Future<UnitRepository> get unitRepository async {
// //     final db = await database;
// //     _unitRepository ??= UnitRepository(db.unitDao);
// //     return _unitRepository!;
// //   }

// //   static Future<GroupRepository> get groupRepository async {
// //     final db = await database;
// //     _groupRepository ??= GroupRepository(db.groupDao);
// //     return _groupRepository!;
// //   }

// //   static Future<DoctorCommissionRepository>
// //   get doctorCommissionRepository async {
// //     final db = await database;
// //     _doctorCommissionRepository ??= DoctorCommissionRepository(
// //       db.doctorCommissionDao,
// //     );
// //     return _doctorCommissionRepository!;
// //   }

// //   static Future<ReferrerRepository> get refrerrerRepository async {
// //     final db = await database;
// //     _referrerRepository ??= ReferrerRepository(db.referrerDao);
// //     return _referrerRepository!;
// //   }

// //   static Future<StateRepository> get stateRepository async {
// //     final db = await database;
// //     _stateRepository ??= StateRepository(db.stateDao);
// //     return _stateRepository!;
// //   }

// //   static Future<CityRepository> get cityRepository async {
// //     final db = await database;
// //     _cityRepository ??= CityRepository(db.cityDao);
// //     return _cityRepository!;
// //   }

// //   static Future<CategoryRepository> get categoryRepository async {
// //     final db = await database;
// //     _categoryRepository ??= CategoryRepository(db.categoryDao);
// //     return _categoryRepository!;
// //   }

// //   static Future<SubCategoryRepository> get subCategoryRepository async {
// //     final db = await database;
// //     _subCategoryRepository ??= SubCategoryRepository(db.subcategoryDao);
// //     return _subCategoryRepository!;
// //   }

// //   static Future<HsnRepository> get hsnRepository async {
// //     final db = await database;
// //     _hsnRepository ??= HsnRepository(db.hsnDao);
// //     return _hsnRepository!;
// //   }

// //   static Future<StaffRepository> get staffRepository async {
// //     final db = await database;
// //     _staffRepository ??= StaffRepository(db.staffDao);
// //     return _staffRepository!;
// //   }

// //   static Future<BasRepository> get basRepository async {
// //     final db = await database;
// //     _basRepository ??= BasRepository(db.basDao);
// //     return _basRepository!;
// //   }

// //   static Future<PaymentModeRepository> get paymentModeRepository async {
// //     final db = await database;
// //     _paymentModeRepository ??= PaymentModeRepository(db.paymentModeDao);
// //     return _paymentModeRepository!;
// //   }

// //   static Future<SampleTypeRepository> get sampleTypeRepository async {
// //     final db = await database;
// //     _sampleTypeRepository ??= SampleTypeRepository(db.sampleTypeDao);
// //     return _sampleTypeRepository!;
// //   }

// //   static Future<BranchTypeRepository> get branchTypeRepository async {
// //     final db = await database;
// //     _branchTypeRepository ??= BranchTypeRepository(db.branchTypeDao);
// //     return _branchTypeRepository!;
// //   }

// //   static Future<CollectionCenterRepository>
// //   get collectionCenterRepository async {
// //     final db = await database;
// //     _collectionCenterRepository ??= CollectionCenterRepository(
// //       db.collectionCenterDao,
// //     );
// //     return _collectionCenterRepository!;
// //   }

// //   static Future<TestBOMRepository> get testBOMRepository async {
// //     final db = await database;
// //     _testBOMRepository ??= TestBOMRepository(db);
// //     return _testBOMRepository!;
// //   }

// //   // Utility methods
// //   static Future<void> resetDatabase() async {
// //     print('🔄 Resetting database...');
// //     await _emergencyRecovery();
// //     await _cleanOldDatabase();
// //     _database = null;
// //     _initialized = false;
// //     print('✅ Database reset complete');
// //   }

// //   static Future<void> closeDatabase() async {
// //     print('🔒 Closing database...');
// //     if (_database != null) {
// //       await _database!.close();
// //       _database = null;
// //       _initialized = false;
// //     }
// //     print('✅ Database closed');
// //   }

// //   static Future<void> debugDatabase() async {
// //     try {
// //       print('🔍 Debugging database...');
// //       final db = await database;
// //       final versionResult = await db.database.rawQuery('PRAGMA user_version');
// //       final version = versionResult.first['user_version'];
// //       print('📊 Database version: $version');
// //       final tables = await db.database.rawQuery(
// //         "SELECT name FROM sqlite_master WHERE type='table' ORDER BY name",
// //       );
// //       print('📋 Found ${tables.length} tables:');
// //       for (var table in tables) {
// //         final tableName = table['name'] as String;
// //         try {
// //           final countResult = await db.database.rawQuery(
// //             'SELECT COUNT(*) as count FROM $tableName',
// //           );
// //           final count = countResult.first['count'];
// //           print('   - $tableName: $count rows');
// //         } catch (e) {
// //           print('   - $tableName: ERROR ($e)');
// //         }
// //       }
// //       print('✅ Debug completed');
// //     } catch (e) {
// //       print('❌ Debug failed: $e');
// //     }
// //   }

// //   static Future<void> initializeGroupScreen() async {
// //     try {
// //       print('🚀 Initializing group screen...');
// //       final db = await database;
// //       await _verifyTables(db.database);
// //       print('✅ Group screen ready');
// //     } catch (e) {
// //       print('❌ Group screen initialization failed: $e');
// //     }
// //   }

// //   static Future<void> initializeStaffScreen() async {
// //     try {
// //       print('🚀 Initializing staff screen...');
// //       final db = await database;
// //       await _verifyTables(db.database);
// //       print('✅ Staff screen ready');
// //     } catch (e) {
// //       print('❌ Staff screen initialization failed: $e');
// //     }
// //   }

// //   static Future<void> initializeTestScreen() async {
// //     try {
// //       print('🚀 Initializing test screen...');
// //       final db = await database;
// //       await _verifyTables(db.database);
// //       print('✅ Test screen ready');
// //     } catch (e) {
// //       print('❌ Test screen initialization failed: $e');
// //     }
// //   }

// //   static Future<void> initializePackageScreen() async {
// //     try {
// //       print('🚀 Initializing package screen...');
// //       final db = await database;
// //       await _verifyTables(db.database);
// //       print('✅ Package screen ready');
// //     } catch (e) {
// //       print('❌ Package screen initialization failed: $e');
// //     }
// //   }

// //   static Future<void> initializeTestBOMScreen() async {
// //     try {
// //       print('🚀 Initializing Test BOM screen...');
// //       final db = await database;
// //       await _verifyTables(db.database);
// //       print('✅ Test BOM screen ready');
// //     } catch (e) {
// //       print('❌ Test BOM initialization failed: $e');
// //     }
// //   }

// //   // ✅ ADD THIS - Unit Screen Initializer
// //   static Future<void> initializeUnitScreen() async {
// //     try {
// //       print('🚀 Initializing Unit screen...');
// //       final db = await database;
// //       await _verifyTables(db.database);
// //       print('✅ Unit screen ready');
// //     } catch (e) {
// //       print('❌ Unit screen initialization failed: $e');
// //     }
// //   }

// //   // Initialize everything
// //   static Future<void> initializeAll() async {
// //     try {
// //       print('🚀 Initializing all database components...');
// //       await database;
// //       print('✅ All database components initialized');
// //     } catch (e) {
// //       print('❌ Initialization failed: $e');
// //       await resetDatabase();
// //       rethrow;
// //     }
// //   }

// //   // Quick test method
// //   static Future<bool> testConnection() async {
// //     try {
// //       final db = await database;
// //       final result = await db.database.rawQuery('SELECT 1');
// //       return result.isNotEmpty;
// //     } catch (e) {
// //       print('❌ Database test failed: $e');
// //       return false;
// //     }
// //   }

// //   // Get database info
// //   static Future<Map<String, dynamic>> getDatabaseInfo() async {
// //     try {
// //       final db = await database;
// //       final versionResult = await db.database.rawQuery('PRAGMA user_version');
// //       final tables = await db.database.rawQuery(
// //         "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'",
// //       );

// //       final tableCounts = <String, int>{};
// //       for (var table in tables) {
// //         final tableName = table['name'] as String;
// //         final countResult = await db.database.rawQuery(
// //           'SELECT COUNT(*) as count FROM $tableName',
// //         );
// //         tableCounts[tableName] = countResult.first['count'] as int;
// //       }

// //       return {
// //         'version': versionResult.first['user_version'],
// //         'tables': tables.map((t) => t['name'] as String).toList(),
// //         'tableCounts': tableCounts,
// //         'isInitialized': _initialized,
// //       };
// //     } catch (e) {
// //       return {'error': e.toString(), 'isInitialized': _initialized};
// //     }
// //   }
// // }

// // ignore_for_file: avoid_print

// import 'dart:io';
// import 'package:floor/floor.dart';
// import 'package:nanohospic/database/app_database.dart';
// import 'package:nanohospic/database/repository/branch_type_repo.dart';
// import 'package:nanohospic/database/repository/city_repo.dart';
// import 'package:nanohospic/database/repository/country_repo.dart';
// import 'package:nanohospic/database/repository/doctor_commision_repo.dart';
// import 'package:nanohospic/database/repository/group_repo.dart';
// import 'package:nanohospic/database/repository/hsn_repo.dart';
// import 'package:nanohospic/database/repository/instrument_master_repo.dart';
// import 'package:nanohospic/database/repository/item_cat_repo.dart';
// import 'package:nanohospic/database/repository/patient_identity_repo.dart';
// import 'package:nanohospic/database/repository/payment_mode_repo.dart';
// import 'package:nanohospic/database/repository/refrerrer_repo.dart';
// import 'package:nanohospic/database/repository/sample_type_repo.dart';
// import 'package:nanohospic/database/repository/staff_repo.dart';
// import 'package:nanohospic/database/repository/state_repo.dart';
// import 'package:nanohospic/database/repository/sucategory_rep.dart';
// import 'package:nanohospic/database/repository/test_bom_repo.dart';
// import 'package:nanohospic/database/repository/test_method_master_repo.dart';
// import 'package:nanohospic/database/repository/user_reposetory.dart';
// import 'package:nanohospic/database/repository/collection_center_repo.dart';
// import 'package:nanohospic/database/repository/unit_repo.dart';
// import 'package:sqflite/sqflite.dart';

// class DatabaseProvider {
//   // Singleton instance
//   static final DatabaseProvider _instance = DatabaseProvider._internal();
//   factory DatabaseProvider() => _instance;
//   DatabaseProvider._internal();

//   // Database and state management
//   static AppDatabase? _database;
//   static bool _isInitializing = false;
//   static bool _initialized = false;

//   // Repository instances
//   static UserRepository? _userRepository;
//   static StaffRepository? _staffRepository;
//   static CountryRepository? _countryRepository;
//   static StateRepository? _stateRepository;
//   static CityRepository? _cityRepository;
//   static CategoryRepository? _categoryRepository;
//   static SubCategoryRepository? _subCategoryRepository;
//   static HsnRepository? _hsnRepository;
//   static BasRepository? _basRepository;
//   static PaymentModeRepository? _paymentModeRepository;
//   static SampleTypeRepository? _sampleTypeRepository;
//   static BranchTypeRepository? _branchTypeRepository;
//   static CollectionCenterRepository? _collectionCenterRepository;
//   static ReferrerRepository? _referrerRepository;
//   static GroupRepository? _groupRepository;
//   static TestBOMRepository? _testBOMRepository;
//   static UnitRepository? _unitRepository;
//   static InstrumentRepository? _instrumentRepository;
//   static TestMethodRepository? _testMethodRepository;
//   static DoctorCommissionRepository? _doctorCommissionRepository;

//   // Main database getter
//   static Future<AppDatabase> get database async {
//     if (_database != null && _initialized) return _database!;

//     if (_isInitializing) {
//       print('⏳ Database is already initializing, waiting...');
//       while (_isInitializing) {
//         await Future.delayed(Duration(milliseconds: 100));
//       }
//       return _database!;
//     }

//     _isInitializing = true;

//     try {
//       print('🚀 ===========================================');
//       print('🚀 STARTING DATABASE INITIALIZATION');
//       print('🚀 ===========================================');

//       // Clean up old database if needed
//       await _cleanOldDatabase();

//       // Build database with minimal migrations
//       _database = await $FloorAppDatabase
//           .databaseBuilder('nanohospic_database.db')
//           .addMigrations([
//             // Single comprehensive migration
//             Migration(1, 2, (database) async {
//               print('🔄 Running full database setup');
//               await _createAllTables(database);
//             }),
//           ])
//           .addCallback(
//             Callback(
//               onCreate: (database, version) async {
//                 print('🏗️ Creating all tables from scratch (onCreate)');
//                 await _createAllTables(database);
//               },
//               onOpen: (database) async {
//                 print('📂 Database opened successfully');
//                 await _verifyTables(database);
//               },
//             ),
//           )
//           .build();

//       // Set database version
//       await _database!.database.execute('PRAGMA user_version = 2');

//       // Verify tables
//       await _verifyTables(_database!.database);

//       _initialized = true;
//       print('✅ ===========================================');
//       print('✅ DATABASE INITIALIZED SUCCESSFULLY');
//       print('✅ ===========================================');

//       return _database!;
//     } catch (e, stackTrace) {
//       print('❌ ===========================================');
//       print('❌ DATABASE INITIALIZATION FAILED');
//       print('❌ Error: $e');
//       print('❌ Stack trace: $stackTrace');
//       print('❌ ===========================================');

//       // Emergency recovery
//       await _emergencyRecovery();

//       // Retry once
//       try {
//         print('🔄 Retrying database initialization...');
//         _database = await $FloorAppDatabase
//             .databaseBuilder('nanohospic_database.db')
//             .build();

//         await _createAllTables(_database!.database);
//         _initialized = true;
//         print('✅ Database recovered successfully');
//       } catch (retryError) {
//         print('❌ Recovery failed: $retryError');
//         rethrow;
//       }
//     } finally {
//       _isInitializing = false;
//     }

//     return _database!;
//   }

//   // Clean old database files
//   static Future<void> _cleanOldDatabase() async {
//     try {
//       final databasesPath = await getDatabasesPath();
//       final dbFile = File('$databasesPath/database.db');
//       final newDbFile = File('$databasesPath/nanohospic_database.db');

//       // Delete old files
//       final filesToDelete = [
//         dbFile,
//         newDbFile,
//         File('${dbFile.path}-shm'),
//         File('${dbFile.path}-wal'),
//         File('${newDbFile.path}-shm'),
//         File('${newDbFile.path}-wal'),
//       ];

//       for (var file in filesToDelete) {
//         if (await file.exists()) {
//           try {
//             await file.delete();
//             print('🗑️ Deleted old file: ${file.path}');
//           } catch (e) {
//             print('⚠️ Could not delete ${file.path}: $e');
//           }
//         }
//       }

//       // Also check for old journal files
//       final dir = Directory(databasesPath);
//       if (await dir.exists()) {
//         final files = await dir.list().toList();
//         for (var file in files) {
//           if (file is File) {
//             final name = file.path.split('/').last;
//             if (name.contains('database') &&
//                 (name.endsWith('-journal') ||
//                     name.endsWith('-shm') ||
//                     name.endsWith('-wal'))) {
//               try {
//                 await file.delete();
//                 print('🗑️ Deleted old journal: $name');
//               } catch (e) {
//                 // Ignore deletion errors
//               }
//             }
//           }
//         }
//       }
//     } catch (e) {
//       print('⚠️ Error during cleanup: $e');
//     }
//   }

//   // Create all tables
//   static Future<void> _createAllTables(DatabaseExecutor database) async {
//     try {
//       print('🏗️ Creating all tables...');

//       // User table
//       await database.execute('''
//         CREATE TABLE IF NOT EXISTS user (
//           id INTEGER PRIMARY KEY AUTOINCREMENT,
//           server_id INTEGER,
//           name TEXT NOT NULL,
//           email TEXT NOT NULL UNIQUE,
//           phone TEXT,
//           password TEXT,
//           role TEXT,
//           created_at TEXT,
//           updated_at TEXT,
//           is_active INTEGER DEFAULT 1,
//           is_deleted INTEGER DEFAULT 0,
//           is_synced INTEGER DEFAULT 0
//         )
//       ''');
//       print('✅ Created: user table');

//       // Countries table
//       await database.execute('''
//         CREATE TABLE IF NOT EXISTS countries (
//           id INTEGER PRIMARY KEY AUTOINCREMENT,
//           server_id INTEGER,
//           name TEXT NOT NULL,
//           created_at TEXT,
//           created_by TEXT,
//           last_modified TEXT,
//           last_modified_by TEXT,
//           is_deleted INTEGER DEFAULT 0,
//           deleted_by TEXT,
//           is_synced INTEGER DEFAULT 0,
//           sync_status TEXT DEFAULT 'pending'
//         )
//       ''');
//       print('✅ Created: countries table');

//       // Units table
//       await database.execute('''
//         CREATE TABLE IF NOT EXISTS units (
//           id INTEGER PRIMARY KEY AUTOINCREMENT,
//           server_id INTEGER,
//           name TEXT NOT NULL,
//           created_at TEXT,
//           created_by TEXT,
//           last_modified TEXT,
//           last_modified_by TEXT,
//           is_deleted INTEGER DEFAULT 0,
//           deleted_by TEXT,
//           is_synced INTEGER DEFAULT 0,
//           sync_status TEXT DEFAULT 'pending'
//         )
//       ''');
//       print('✅ Created: units table');

//       // Instruments table
//       await database.execute('''
//         CREATE TABLE IF NOT EXISTS instruments (
//           id INTEGER PRIMARY KEY AUTOINCREMENT,
//           server_id INTEGER,
//           machine_name TEXT NOT NULL,
//           description TEXT,
//           created_at TEXT,
//           created_by TEXT,
//           last_modified TEXT,
//           last_modified_by TEXT,
//           is_deleted INTEGER DEFAULT 0,
//           deleted_by TEXT,
//           is_synced INTEGER DEFAULT 0,
//           sync_status TEXT DEFAULT 'pending'
//         )
//       ''');
//       print('✅ Created: instruments table');

//       // Test Methods table
//       await database.execute('''
//         CREATE TABLE IF NOT EXISTS test_methods (
//           id INTEGER PRIMARY KEY AUTOINCREMENT,
//           server_id INTEGER,
//           method_name TEXT NOT NULL,
//           description TEXT,
//           created_at TEXT,
//           created_by TEXT,
//           last_modified TEXT,
//           last_modified_by TEXT,
//           is_deleted INTEGER DEFAULT 0,
//           deleted_by TEXT,
//           is_synced INTEGER DEFAULT 0,
//           sync_status TEXT DEFAULT 'pending'
//         )
//       ''');
//       print('✅ Created: test_methods table');

//       // States table
//       await database.execute('''
//         CREATE TABLE IF NOT EXISTS states (
//           id INTEGER PRIMARY KEY AUTOINCREMENT,
//           server_id INTEGER,
//           name TEXT NOT NULL,
//           country_id INTEGER,
//           country_name TEXT,
//           created_at TEXT,
//           updated_at TEXT,
//           is_deleted INTEGER DEFAULT 0,
//           is_synced INTEGER DEFAULT 0
//         )
//       ''');
//       print('✅ Created: states table');

//       // Cities table
//       await database.execute('''
//         CREATE TABLE IF NOT EXISTS cities (
//           id INTEGER PRIMARY KEY AUTOINCREMENT,
//           server_id INTEGER,
//           name TEXT NOT NULL,
//           state_id INTEGER,
//           state_name TEXT,
//           created_at TEXT,
//           updated_at TEXT,
//           is_deleted INTEGER DEFAULT 0,
//           is_synced INTEGER DEFAULT 0
//         )
//       ''');
//       print('✅ Created: cities table');

//       // Categories table
//       await database.execute('''
//         CREATE TABLE IF NOT EXISTS categories (
//           id INTEGER PRIMARY KEY AUTOINCREMENT,
//           server_id INTEGER,
//           category_name TEXT NOT NULL,
//           created_at TEXT,
//           created_by TEXT,
//           last_modified TEXT,
//           last_modified_by TEXT,
//           is_deleted INTEGER DEFAULT 0,
//           deleted_by TEXT,
//           is_synced INTEGER DEFAULT 0,
//           sync_status TEXT DEFAULT 'pending'
//         )
//       ''');
//       print('✅ Created: categories table');

//       // Subcategories table
//       await database.execute('''
//         CREATE TABLE IF NOT EXISTS subcategories (
//           id INTEGER PRIMARY KEY AUTOINCREMENT,
//           server_id INTEGER,
//           name TEXT NOT NULL,
//           category_id INTEGER NOT NULL,
//           category_server_id INTEGER,
//           category_name TEXT,
//           created_at TEXT,
//           created_by TEXT,
//           last_modified TEXT,
//           last_modified_by TEXT,
//           is_deleted INTEGER DEFAULT 0,
//           deleted_by TEXT,
//           is_synced INTEGER DEFAULT 0,
//           sync_status TEXT DEFAULT 'pending'
//         )
//       ''');
//       print('✅ Created: subcategories table');

//       // HSN codes table
//       await database.execute('''
//         CREATE TABLE IF NOT EXISTS hsn_codes (
//           id INTEGER PRIMARY KEY AUTOINCREMENT,
//           server_id INTEGER,
//           hsn_code TEXT NOT NULL UNIQUE,
//           sgst REAL DEFAULT 0,
//           cgst REAL DEFAULT 0,
//           igst REAL DEFAULT 0,
//           cess REAL DEFAULT 0,
//           hsn_type INTEGER,
//           tenant TEXT,
//           tenant_id TEXT,
//           created_at TEXT NOT NULL,
//           created_by TEXT NOT NULL,
//           last_modified TEXT,
//           last_modified_by TEXT,
//           deleted TEXT,
//           deleted_by TEXT,
//           is_synced INTEGER DEFAULT 0,
//           is_deleted INTEGER DEFAULT 0,
//           sync_attempts INTEGER DEFAULT 0,
//           last_sync_error TEXT
//         )
//       ''');
//       print('✅ Created: hsn_codes table');

//       // Staff table
//       await database.execute('''
//         CREATE TABLE IF NOT EXISTS staff (
//           id INTEGER PRIMARY KEY AUTOINCREMENT,
//           server_id INTEGER,
//           name TEXT NOT NULL,
//           department TEXT NOT NULL,
//           designation TEXT NOT NULL,
//           email TEXT,
//           phone TEXT NOT NULL,
//           required_credentials TEXT NOT NULL,
//           created_at TEXT NOT NULL,
//           created_by TEXT,
//           last_modified TEXT,
//           last_modified_by TEXT,
//           is_deleted INTEGER DEFAULT 0,
//           deleted_by TEXT,
//           is_synced INTEGER DEFAULT 0,
//           sync_status TEXT DEFAULT 'pending',
//           sync_attempts INTEGER DEFAULT 0,
//           last_sync_error TEXT
//         )
//       ''');
//       print('✅ Created: staff table');

//       // BAS names table
//       await database.execute('''
//         CREATE TABLE IF NOT EXISTS bas_names (
//           id INTEGER PRIMARY KEY AUTOINCREMENT,
//           server_id INTEGER,
//           name TEXT NOT NULL,
//           created_at TEXT,
//           created_by TEXT,
//           last_modified TEXT,
//           last_modified_by TEXT,
//           is_deleted INTEGER DEFAULT 0,
//           deleted_by TEXT,
//           is_synced INTEGER DEFAULT 0,
//           sync_status TEXT DEFAULT 'pending',
//           sync_attempts INTEGER DEFAULT 0,
//           last_sync_error TEXT
//         )
//       ''');
//       print('✅ Created: bas_names table');

//       // Payment modes table
//       await database.execute('''
//         CREATE TABLE IF NOT EXISTS payment_modes (
//           id INTEGER PRIMARY KEY AUTOINCREMENT,
//           server_id INTEGER,
//           name TEXT NOT NULL,
//           description TEXT,
//           tenant_id TEXT,
//           created_at TEXT,
//           created_by TEXT,
//           last_modified TEXT,
//           last_modified_by TEXT,
//           is_deleted INTEGER DEFAULT 0,
//           deleted_by TEXT,
//           is_synced INTEGER DEFAULT 0,
//           sync_status TEXT DEFAULT 'pending',
//           sync_attempts INTEGER DEFAULT 0,
//           last_sync_error TEXT
//         )
//       ''');
//       print('✅ Created: payment_modes table');

//       // Sample types table
//       await database.execute('''
//         CREATE TABLE IF NOT EXISTS sample_types (
//           id INTEGER PRIMARY KEY AUTOINCREMENT,
//           server_id INTEGER,
//           name TEXT NOT NULL,
//           description TEXT,
//           created_at TEXT,
//           created_by TEXT,
//           last_modified TEXT,
//           last_modified_by TEXT,
//           is_deleted INTEGER DEFAULT 0,
//           deleted_by TEXT,
//           is_synced INTEGER DEFAULT 0,
//           sync_status TEXT DEFAULT 'pending',
//           sync_attempts INTEGER DEFAULT 0,
//           last_sync_error TEXT
//         )
//       ''');
//       print('✅ Created: sample_types table');

//       // Branch types table
//       await database.execute('''
//         CREATE TABLE IF NOT EXISTS branch_types (
//           id INTEGER PRIMARY KEY AUTOINCREMENT,
//           server_id INTEGER,
//           company_name TEXT NOT NULL,
//           contact_person TEXT NOT NULL,
//           contact_no TEXT NOT NULL,
//           email TEXT NOT NULL,
//           address1 TEXT NOT NULL,
//           location TEXT NOT NULL,
//           type TEXT NOT NULL,
//           designation TEXT NOT NULL,
//           mobile_no TEXT NOT NULL,
//           address2 TEXT,
//           country TEXT NOT NULL,
//           state TEXT NOT NULL,
//           city TEXT NOT NULL,
//           created_at TEXT,
//           created_by TEXT,
//           last_modified TEXT,
//           last_modified_by TEXT,
//           is_deleted INTEGER DEFAULT 0,
//           deleted_by TEXT,
//           is_synced INTEGER DEFAULT 0,
//           sync_status TEXT DEFAULT 'pending',
//           sync_attempts INTEGER DEFAULT 0,
//           last_sync_error TEXT
//         )
//       ''');
//       print('✅ Created: branch_types table');

//       // Collection centers table
//       await database.execute('''
//         CREATE TABLE IF NOT EXISTS collection_centers (
//           id INTEGER PRIMARY KEY AUTOINCREMENT,
//           server_id INTEGER,
//           center_code TEXT NOT NULL,
//           center_name TEXT NOT NULL,
//           country TEXT NOT NULL,
//           state TEXT NOT NULL,
//           city TEXT NOT NULL,
//           address1 TEXT NOT NULL,
//           address2 TEXT,
//           location TEXT,
//           postal_code TEXT,
//           latitude REAL DEFAULT 0.0,
//           longitude REAL DEFAULT 0.0,
//           gst_number TEXT,
//           pan_number TEXT,
//           contact_person_name TEXT NOT NULL,
//           phone_no TEXT NOT NULL,
//           email TEXT,
//           centre_status TEXT NOT NULL,
//           branch_type_id INTEGER,
//           lab_affiliation_company TEXT,
//           operational_hours_from TEXT,
//           operational_hours_to TEXT,
//           collection_days TEXT,
//           sample_pickup_timing_from TEXT,
//           sample_pickup_timing_to TEXT,
//           transport_mode TEXT,
//           courier_agency_name TEXT,
//           commission_type TEXT,
//           commission_value REAL DEFAULT 0.0,
//           account_holder_name TEXT,
//           account_no TEXT,
//           ifsc_code TEXT,
//           agreement_file1_path TEXT,
//           agreement_file2_path TEXT,
//           created_at TEXT,
//           created_by TEXT,
//           last_modified TEXT,
//           last_modified_by TEXT,
//           is_deleted INTEGER DEFAULT 0,
//           deleted_by TEXT,
//           is_synced INTEGER DEFAULT 0,
//           sync_status TEXT DEFAULT 'pending',
//           sync_attempts INTEGER DEFAULT 0,
//           last_sync_error TEXT
//         )
//       ''');
//       print('✅ Created: collection_centers table');

//       // Groups table
//       await database.execute('''
//         CREATE TABLE IF NOT EXISTS groups (
//           id INTEGER PRIMARY KEY AUTOINCREMENT,
//           server_id INTEGER,
//           name TEXT NOT NULL,
//           description TEXT,
//           code TEXT,
//           type TEXT DEFAULT 'general',
//           status TEXT DEFAULT 'active',
//           tenant_id TEXT,
//           created_at TEXT,
//           created_by TEXT,
//           last_modified TEXT,
//           last_modified_by TEXT,
//           is_deleted INTEGER DEFAULT 0,
//           deleted_by TEXT,
//           is_synced INTEGER DEFAULT 0,
//           sync_status TEXT DEFAULT 'pending',
//           sync_attempts INTEGER DEFAULT 0,
//           last_sync_error TEXT
//         )
//       ''');
//       print('✅ Created: groups table');

//       // Test table
//       await database.execute('''
//         CREATE TABLE IF NOT EXISTS test (
//           id INTEGER PRIMARY KEY AUTOINCREMENT,
//           server_id INTEGER,
//           code TEXT NOT NULL,
//           name TEXT NOT NULL,
//           product_group TEXT NOT NULL,
//           mrp REAL NOT NULL DEFAULT 0.0,
//           sales_rate_a REAL NOT NULL DEFAULT 0.0,
//           sales_rate_b REAL NOT NULL DEFAULT 0.0,
//           hsn_sac TEXT,
//           gst INTEGER NOT NULL DEFAULT 0,
//           barcode TEXT,
//           min_value REAL NOT NULL DEFAULT 0.0,
//           max_value REAL NOT NULL DEFAULT 0.0,
//           unit TEXT NOT NULL,
//           created_at TEXT NOT NULL,
//           created_by TEXT,
//           last_modified TEXT,
//           last_modified_by TEXT,
//           is_deleted INTEGER DEFAULT 0,
//           deleted_by TEXT,
//           is_synced INTEGER DEFAULT 0,
//           sync_status TEXT DEFAULT 'pending',
//           sync_attempts INTEGER DEFAULT 0,
//           last_sync_error TEXT
//         )
//       ''');
//       print('✅ Created: test table');

//       // Packages table
//       await database.execute('''
//         CREATE TABLE IF NOT EXISTS packages (
//           id INTEGER PRIMARY KEY AUTOINCREMENT,
//           server_id INTEGER,
//           code TEXT NOT NULL,
//           name TEXT NOT NULL,
//           gst REAL NOT NULL DEFAULT 0.0,
//           rate REAL NOT NULL DEFAULT 0.0,
//           tests_json TEXT NOT NULL,
//           created_at TEXT NOT NULL,
//           created_by TEXT,
//           last_modified TEXT,
//           last_modified_by TEXT,
//           is_deleted INTEGER DEFAULT 0,
//           deleted_by TEXT,
//           is_synced INTEGER DEFAULT 0,
//           sync_status TEXT DEFAULT 'pending',
//           sync_attempts INTEGER DEFAULT 0,
//           last_sync_error TEXT
//         )
//       ''');
//       print('✅ Created: packages table');

//       // Test BOM table
//       await database.execute('''
//         CREATE TABLE IF NOT EXISTS test_boms (
//           id INTEGER PRIMARY KEY AUTOINCREMENT,
//           server_id INTEGER,
//           code TEXT NOT NULL UNIQUE,
//           name TEXT NOT NULL,
//           test_group TEXT NOT NULL,
//           gender_type TEXT NOT NULL,
//           description TEXT,
//           rate REAL NOT NULL DEFAULT 0.0,
//           gst REAL NOT NULL DEFAULT 0.0,
//           turn_around_time TEXT NOT NULL,
//           time_unit TEXT NOT NULL DEFAULT 'hours',
//           is_active INTEGER DEFAULT 1,
//           method TEXT,
//           reference_range TEXT,
//           clinical_significance TEXT,
//           specimen_requirement TEXT,
//           created_at TEXT NOT NULL,
//           created_by TEXT NOT NULL,
//           last_modified TEXT,
//           last_modified_by TEXT,
//           is_deleted INTEGER DEFAULT 0,
//           deleted_by TEXT,
//           is_synced INTEGER DEFAULT 0,
//           sync_status TEXT DEFAULT 'pending',
//           sync_attempts INTEGER DEFAULT 0,
//           last_sync_error TEXT,
//           parameters TEXT NOT NULL
//         )
//       ''');
//       print('✅ Created: test_boms table');

//       // Patient identities table
//       await database.execute('''
//         CREATE TABLE IF NOT EXISTS patient_identities (
//           id INTEGER PRIMARY KEY AUTOINCREMENT,
//           server_id INTEGER,
//           name TEXT NOT NULL,
//           created_at TEXT,
//           updated_at TEXT,
//           is_deleted INTEGER DEFAULT 0,
//           is_synced INTEGER DEFAULT 0
//         )
//       ''');
//       print('✅ Created: patient_identities table');

//       // Referrers table
//       await database.execute('''
//         CREATE TABLE IF NOT EXISTS referrers (
//           id INTEGER PRIMARY KEY AUTOINCREMENT,
//           server_id INTEGER,
//           name TEXT NOT NULL,
//           qualification TEXT,
//           speciality TEXT,
//           phone TEXT,
//           email TEXT,
//           address TEXT,
//           commission_type TEXT,
//           commission_value REAL,
//           created_at TEXT,
//           updated_at TEXT,
//           is_deleted INTEGER DEFAULT 0,
//           is_synced INTEGER DEFAULT 0
//         )
//       ''');
//       print('✅ Created: referrers table');

//       print('✅ All tables created successfully');
//     } catch (e, stackTrace) {
//       print('❌ Error creating tables: $e');
//       print('Stack trace: $stackTrace');
//       rethrow;
//     }
//   }

//   // Verify tables exist
//   static Future<void> _verifyTables(DatabaseExecutor database) async {
//     try {
//       print('🔍 Verifying all tables...');

//       final tables = await database.rawQuery(
//         "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'",
//       );

//       final tableNames = tables.map((t) => t['name'] as String).toList();
//       print('📋 Found ${tableNames.length} tables: ${tableNames.join(', ')}');

//       if (tableNames.isEmpty) {
//         print('⚠️ No tables found, creating them...');
//         await _createAllTables(database);
//       }

//       // Check for essential tables
//       final essentialTables = [
//         'user',
//         'categories',
//         'test',
//         'packages',
//         'units',
//         'instruments',
//         'test_methods',
//         'groups',
//         'referrers',
//         'patient_identities',
//       ];
//       for (var table in essentialTables) {
//         if (!tableNames.contains(table)) {
//           print('⚠️ Missing essential table: $table');
//           await _createAllTables(database);
//           break;
//         }
//       }

//       print('✅ Table verification completed');
//     } catch (e) {
//       print('❌ Table verification failed: $e');
//     }
//   }

//   // Emergency recovery
//   static Future<void> _emergencyRecovery() async {
//     try {
//       print('🆘 Starting emergency recovery...');

//       // Close existing connection
//       if (_database != null) {
//         try {
//           await _database!.close();
//         } catch (e) {
//           print('⚠️ Error closing database: $e');
//         }
//         _database = null;
//       }

//       // Reset state
//       _initialized = false;
//       _isInitializing = false;

//       // Clear all repository instances
//       _userRepository = null;
//       _staffRepository = null;
//       _countryRepository = null;
//       _stateRepository = null;
//       _cityRepository = null;
//       _categoryRepository = null;
//       _subCategoryRepository = null;
//       _hsnRepository = null;
//       _basRepository = null;
//       _paymentModeRepository = null;
//       _sampleTypeRepository = null;
//       _branchTypeRepository = null;
//       _collectionCenterRepository = null;
//       _referrerRepository = null;
//       _groupRepository = null;
//       _testBOMRepository = null;
//       _unitRepository = null;
//       _instrumentRepository = null;
//       _testMethodRepository = null;
//       _doctorCommissionRepository = null;
//       print('✅ Emergency recovery completed');
//     } catch (e) {
//       print('❌ Emergency recovery failed: $e');
//     }
//   }

//   // Repository getters
//   static Future<UserRepository> get userRepository async {
//     final db = await database;
//     _userRepository ??= UserRepository(db);
//     return _userRepository!;
//   }

//   static Future<CountryRepository> get countryRepository async {
//     final db = await database;
//     _countryRepository ??= CountryRepository(db.countryDao);
//     return _countryRepository!;
//   }

//   static Future<TestMethodRepository> get testMethodRepository async {
//     final db = await database;
//     _testMethodRepository ??= TestMethodRepository(db.testMethodDao);
//     return _testMethodRepository!;
//   }

//   static Future<InstrumentRepository> get instrumentRepository async {
//     final db = await database;
//     _instrumentRepository ??= InstrumentRepository(db.instrumentDao);
//     return _instrumentRepository!;
//   }

//   static Future<UnitRepository> get unitRepository async {
//     final db = await database;
//     _unitRepository ??= UnitRepository(db.unitDao);
//     return _unitRepository!;
//   }

//   static Future<GroupRepository> get groupRepository async {
//     final db = await database;
//     _groupRepository ??= GroupRepository(db.groupDao);
//     return _groupRepository!;
//   }

//   static Future<DoctorCommissionRepository> get doctorCommissionRepository async {
//     final db = await database;
//     _doctorCommissionRepository ??= DoctorCommissionRepository(
//       db.doctorCommissionDao,
//     );
//     return _doctorCommissionRepository!;
//   }

//   static Future<ReferrerRepository> get refrerrerRepository async {
//     final db = await database;
//     _referrerRepository ??= ReferrerRepository(db.referrerDao);
//     return _referrerRepository!;
//   }

//   static Future<StateRepository> get stateRepository async {
//     final db = await database;
//     _stateRepository ??= StateRepository(db.stateDao);
//     return _stateRepository!;
//   }

//   static Future<CityRepository> get cityRepository async {
//     final db = await database;
//     _cityRepository ??= CityRepository(db.cityDao);
//     return _cityRepository!;
//   }

//   static Future<CategoryRepository> get categoryRepository async {
//     final db = await database;
//     _categoryRepository ??= CategoryRepository(db.categoryDao);
//     return _categoryRepository!;
//   }

//   static Future<SubCategoryRepository> get subCategoryRepository async {
//     final db = await database;
//     _subCategoryRepository ??= SubCategoryRepository(db.subcategoryDao);
//     return _subCategoryRepository!;
//   }

//   static Future<HsnRepository> get hsnRepository async {
//     final db = await database;
//     _hsnRepository ??= HsnRepository(db.hsnDao);
//     return _hsnRepository!;
//   }

//   static Future<StaffRepository> get staffRepository async {
//     final db = await database;
//     _staffRepository ??= StaffRepository(db.staffDao);
//     return _staffRepository!;
//   }

//   static Future<BasRepository> get basRepository async {
//     final db = await database;
//     _basRepository ??= BasRepository(db.basDao);
//     return _basRepository!;
//   }

//   static Future<PaymentModeRepository> get paymentModeRepository async {
//     final db = await database;
//     _paymentModeRepository ??= PaymentModeRepository(db.paymentModeDao);
//     return _paymentModeRepository!;
//   }

//   static Future<SampleTypeRepository> get sampleTypeRepository async {
//     final db = await database;
//     _sampleTypeRepository ??= SampleTypeRepository(db.sampleTypeDao);
//     return _sampleTypeRepository!;
//   }

//   static Future<BranchTypeRepository> get branchTypeRepository async {
//     final db = await database;
//     _branchTypeRepository ??= BranchTypeRepository(db.branchTypeDao);
//     return _branchTypeRepository!;
//   }

//   static Future<CollectionCenterRepository> get collectionCenterRepository async {
//     final db = await database;
//     _collectionCenterRepository ??= CollectionCenterRepository(
//       db.collectionCenterDao,
//     );
//     return _collectionCenterRepository!;
//   }

//   static Future<TestBOMRepository> get testBOMRepository async {
//     final db = await database;
//     _testBOMRepository ??= TestBOMRepository(db);
//     return _testBOMRepository!;
//   }

//   // Utility methods
//   static Future<void> resetDatabase() async {
//     print('🔄 Resetting database...');
//     await _emergencyRecovery();
//     await _cleanOldDatabase();
//     _database = null;
//     _initialized = false;
//     print('✅ Database reset complete');
//   }

//   static Future<void> closeDatabase() async {
//     print('🔒 Closing database...');
//     if (_database != null) {
//       await _database!.close();
//       _database = null;
//       _initialized = false;
//     }
//     print('✅ Database closed');
//   }

//   static Future<void> debugDatabase() async {
//     try {
//       print('🔍 Debugging database...');
//       final db = await database;
//       final versionResult = await db.database.rawQuery('PRAGMA user_version');
//       final version = versionResult.first['user_version'];
//       print('📊 Database version: $version');
//       final tables = await db.database.rawQuery(
//         "SELECT name FROM sqlite_master WHERE type='table' ORDER BY name",
//       );
//       print('📋 Found ${tables.length} tables:');
//       for (var table in tables) {
//         final tableName = table['name'] as String;
//         try {
//           final countResult = await db.database.rawQuery(
//             'SELECT COUNT(*) as count FROM $tableName',
//           );
//           final count = countResult.first['count'];
//           print('   - $tableName: $count rows');
//         } catch (e) {
//           print('   - $tableName: ERROR ($e)');
//         }
//       }
//       print('✅ Debug completed');
//     } catch (e) {
//       print('❌ Debug failed: $e');
//     }
//   }

//   // Screen initialization methods
//   static Future<void> initializeGroupScreen() async {
//     try {
//       print('🚀 Initializing group screen...');
//       final db = await database;
//       await _verifyTables(db.database);
//       print('✅ Group screen ready');
//     } catch (e) {
//       print('❌ Group screen initialization failed: $e');
//     }
//   }

//   static Future<void> initializeStaffScreen() async {
//     try {
//       print('🚀 Initializing staff screen...');
//       final db = await database;
//       await _verifyTables(db.database);
//       print('✅ Staff screen ready');
//     } catch (e) {
//       print('❌ Staff screen initialization failed: $e');
//     }
//   }

//   static Future<void> initializeTestScreen() async {
//     try {
//       print('🚀 Initializing test screen...');
//       final db = await database;
//       await _verifyTables(db.database);
//       print('✅ Test screen ready');
//     } catch (e) {
//       print('❌ Test screen initialization failed: $e');
//     }
//   }

//   static Future<void> initializePackageScreen() async {
//     try {
//       print('🚀 Initializing package screen...');
//       final db = await database;
//       await _verifyTables(db.database);
//       print('✅ Package screen ready');
//     } catch (e) {
//       print('❌ Package screen initialization failed: $e');
//     }
//   }

//   static Future<void> initializeTestBOMScreen() async {
//     try {
//       print('🚀 Initializing Test BOM screen...');
//       final db = await database;
//       await _verifyTables(db.database);
//       print('✅ Test BOM screen ready');
//     } catch (e) {
//       print('❌ Test BOM initialization failed: $e');
//     }
//   }

//   static Future<void> initializeUnitScreen() async {
//     try {
//       print('🚀 Initializing Unit screen...');
//       final db = await database;
//       await _verifyTables(db.database);
//       print('✅ Unit screen ready');
//     } catch (e) {
//       print('❌ Unit screen initialization failed: $e');
//     }
//   }

//   static Future<void> initializeInstrumentScreen() async {
//     try {
//       print('🚀 Initializing Instrument screen...');
//       final db = await database;
//       await _verifyTables(db.database);
//       print('✅ Instrument screen ready');
//     } catch (e) {
//       print('❌ Instrument screen initialization failed: $e');
//     }
//   }

//   static Future<void> initializeTestMethodScreen() async {
//     try {
//       print('🚀 Initializing Test Method screen...');
//       final db = await database;
//       await _verifyTables(db.database);
//       print('✅ Test Method screen ready');
//     } catch (e) {
//       print('❌ Test Method screen initialization failed: $e');
//     }
//   }

//   // Initialize everything
//   static Future<void> initializeAll() async {
//     try {
//       print('🚀 Initializing all database components...');
//       await database;
//       print('✅ All database components initialized');
//     } catch (e) {
//       print('❌ Initialization failed: $e');
//       await resetDatabase();
//       rethrow;
//     }
//   }

//   // Quick test method
//   static Future<bool> testConnection() async {
//     try {
//       final db = await database;
//       final result = await db.database.rawQuery('SELECT 1');
//       return result.isNotEmpty;
//     } catch (e) {
//       print('❌ Database test failed: $e');
//       return false;
//     }
//   }

//   // Get database info
//   static Future<Map<String, dynamic>> getDatabaseInfo() async {
//     try {
//       final db = await database;
//       final versionResult = await db.database.rawQuery('PRAGMA user_version');
//       final tables = await db.database.rawQuery(
//         "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'",
//       );

//       final tableCounts = <String, int>{};
//       for (var table in tables) {
//         final tableName = table['name'] as String;
//         final countResult = await db.database.rawQuery(
//           'SELECT COUNT(*) as count FROM $tableName',
//         );
//         tableCounts[tableName] = countResult.first['count'] as int;
//       }

//       return {
//         'version': versionResult.first['user_version'],
//         'tables': tables.map((t) => t['name'] as String).toList(),
//         'tableCounts': tableCounts,
//         'isInitialized': _initialized,
//       };
//     } catch (e) {
//       return {'error': e.toString(), 'isInitialized': _initialized};
//     }
//   }
// }

// ignore_for_file: avoid_print

import 'dart:io';
import 'package:floor/floor.dart';
import 'package:nanohospic/database/app_database.dart';
import 'package:nanohospic/database/repository/branch_type_repo.dart';
import 'package:nanohospic/database/repository/city_repo.dart';
import 'package:nanohospic/database/repository/country_repo.dart';
import 'package:nanohospic/database/repository/designation_repo.dart';
import 'package:nanohospic/database/repository/division_repo.dart';
import 'package:nanohospic/database/repository/doctor_commision_repo.dart';
import 'package:nanohospic/database/repository/group_repo.dart';
import 'package:nanohospic/database/repository/hsn_repo.dart';
import 'package:nanohospic/database/repository/instrument_master_repo.dart';
import 'package:nanohospic/database/repository/item_cat_repo.dart';
import 'package:nanohospic/database/repository/patient_identity_repo.dart';
import 'package:nanohospic/database/repository/payment_mode_repo.dart';
import 'package:nanohospic/database/repository/refrerrer_repo.dart';
import 'package:nanohospic/database/repository/sample_type_repo.dart';
import 'package:nanohospic/database/repository/staff_repo.dart';
import 'package:nanohospic/database/repository/department_repo.dart'; // ADD THIS
import 'package:nanohospic/database/repository/state_repo.dart';
import 'package:nanohospic/database/repository/sucategory_rep.dart';
import 'package:nanohospic/database/repository/test_bom_repo.dart';
import 'package:nanohospic/database/repository/test_method_master_repo.dart';
import 'package:nanohospic/database/repository/user_reposetory.dart';
import 'package:nanohospic/database/repository/collection_center_repo.dart';
import 'package:nanohospic/database/repository/unit_repo.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  // Singleton instance
  static final DatabaseProvider _instance = DatabaseProvider._internal();
  factory DatabaseProvider() => _instance;
  DatabaseProvider._internal();

  // Database and state management
  static AppDatabase? _database;
  static bool _isInitializing = false;
  static bool _initialized = false;

  // Repository instances
  static UserRepository? _userRepository;
  static StaffRepository? _staffRepository;
  static DepartmentRepository? _departmentRepository;
  static DesignationRepository? _designationRepository;
  static CountryRepository? _countryRepository;
  static StateRepository? _stateRepository;
  static CityRepository? _cityRepository;
  static CategoryRepository? _categoryRepository;
  static SubCategoryRepository? _subCategoryRepository;
  static HsnRepository? _hsnRepository;
  static BasRepository? _basRepository;
  static PaymentModeRepository? _paymentModeRepository;
  static SampleTypeRepository? _sampleTypeRepository;
  static BranchTypeRepository? _branchTypeRepository;
  static CollectionCenterRepository? _collectionCenterRepository;
  static ReferrerRepository? _referrerRepository;
  static GroupRepository? _groupRepository;
  static TestBOMRepository? _testBOMRepository;
  static UnitRepository? _unitRepository;
  static InstrumentRepository? _instrumentRepository;
  static TestMethodRepository? _testMethodRepository;
  static DoctorCommissionRepository? _doctorCommissionRepository;
  static DivisionRepository? _divisionRepository;

  // Main database getter
  static Future<AppDatabase> get database async {
    if (_database != null && _initialized) return _database!;

    if (_isInitializing) {
      print('⏳ Database is already initializing, waiting...');
      while (_isInitializing) {
        await Future.delayed(Duration(milliseconds: 100));
      }
      return _database!;
    }

    _isInitializing = true;

    try {
      print('🚀 ===========================================');
      print('🚀 STARTING DATABASE INITIALIZATION');
      print('🚀 ===========================================');

      // Clean up old database if needed
      await _cleanOldDatabase();

      // Build database with minimal migrations
      _database = await $FloorAppDatabase
          .databaseBuilder('nanohospic_database.db')
          .addMigrations([
            // Single comprehensive migration
            Migration(1, 2, (database) async {
              print('🔄 Running full database setup');
              await _createAllTables(database);
            }),
          ])
          .addCallback(
            Callback(
              onCreate: (database, version) async {
                print('🏗️ Creating all tables from scratch (onCreate)');
                await _createAllTables(database);
              },
              onOpen: (database) async {
                print('📂 Database opened successfully');
                await _verifyTables(database);
              },
            ),
          )
          .build();

      // Set database version
      await _database!.database.execute('PRAGMA user_version = 2');

      // Verify tables
      await _verifyTables(_database!.database);

      _initialized = true;
      print('✅ ===========================================');
      print('✅ DATABASE INITIALIZED SUCCESSFULLY');
      print('✅ ===========================================');

      return _database!;
    } catch (e, stackTrace) {
      print('❌ ===========================================');
      print('❌ DATABASE INITIALIZATION FAILED');
      print('❌ Error: $e');
      print('❌ Stack trace: $stackTrace');
      print('❌ ===========================================');

      // Emergency recovery
      await _emergencyRecovery();

      // Retry once
      try {
        print('🔄 Retrying database initialization...');
        _database = await $FloorAppDatabase
            .databaseBuilder('nanohospic_database.db')
            .build();

        await _createAllTables(_database!.database);
        _initialized = true;
        print('✅ Database recovered successfully');
      } catch (retryError) {
        print('❌ Recovery failed: $retryError');
        rethrow;
      }
    } finally {
      _isInitializing = false;
    }

    return _database!;
  }

  // Clean old database files
  static Future<void> _cleanOldDatabase() async {
    try {
      final databasesPath = await getDatabasesPath();
      final dbFile = File('$databasesPath/database.db');
      final newDbFile = File('$databasesPath/nanohospic_database.db');

      // Delete old files
      final filesToDelete = [
        dbFile,
        newDbFile,
        File('${dbFile.path}-shm'),
        File('${dbFile.path}-wal'),
        File('${newDbFile.path}-shm'),
        File('${newDbFile.path}-wal'),
      ];

      for (var file in filesToDelete) {
        if (await file.exists()) {
          try {
            await file.delete();
            print('🗑️ Deleted old file: ${file.path}');
          } catch (e) {
            print('⚠️ Could not delete ${file.path}: $e');
          }
        }
      }

      // Also check for old journal files
      final dir = Directory(databasesPath);
      if (await dir.exists()) {
        final files = await dir.list().toList();
        for (var file in files) {
          if (file is File) {
            final name = file.path.split('/').last;
            if (name.contains('database') &&
                (name.endsWith('-journal') ||
                    name.endsWith('-shm') ||
                    name.endsWith('-wal'))) {
              try {
                await file.delete();
                print('🗑️ Deleted old journal: $name');
              } catch (e) {
                // Ignore deletion errors
              }
            }
          }
        }
      }
    } catch (e) {
      print('⚠️ Error during cleanup: $e');
    }
  }

  // Create all tables
  static Future<void> _createAllTables(DatabaseExecutor database) async {
    try {
      print('🏗️ Creating all tables...');

      // User table
      await database.execute('''
        CREATE TABLE IF NOT EXISTS user (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          server_id INTEGER,
          name TEXT NOT NULL,
          email TEXT NOT NULL UNIQUE,
          phone TEXT,
          password TEXT,
          role TEXT,
          created_at TEXT,
          updated_at TEXT,
          is_active INTEGER DEFAULT 1,
          is_deleted INTEGER DEFAULT 0,
          is_synced INTEGER DEFAULT 0
        )
      ''');
      print('✅ Created: user table');

      // Countries table
      await database.execute('''
        CREATE TABLE IF NOT EXISTS countries (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          server_id INTEGER,
          name TEXT NOT NULL,
          created_at TEXT,
          created_by TEXT,
          last_modified TEXT,
          last_modified_by TEXT,
          is_deleted INTEGER DEFAULT 0,
          deleted_by TEXT,
          is_synced INTEGER DEFAULT 0,
          sync_status TEXT DEFAULT 'pending'
        )
      ''');
      print('✅ Created: countries table');

      // Units table
      await database.execute('''
        CREATE TABLE IF NOT EXISTS units (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          server_id INTEGER,
          name TEXT NOT NULL,
          created_at TEXT,
          created_by TEXT,
          last_modified TEXT,
          last_modified_by TEXT,
          is_deleted INTEGER DEFAULT 0,
          deleted_by TEXT,
          is_synced INTEGER DEFAULT 0,
          sync_status TEXT DEFAULT 'pending'
        )
      ''');
      print('✅ Created: units table');

      // Instruments table
      await database.execute('''
        CREATE TABLE IF NOT EXISTS instruments (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          server_id INTEGER,
          machine_name TEXT NOT NULL,
          description TEXT,
          created_at TEXT,
          created_by TEXT,
          last_modified TEXT,
          last_modified_by TEXT,
          is_deleted INTEGER DEFAULT 0,
          deleted_by TEXT,
          is_synced INTEGER DEFAULT 0,
          sync_status TEXT DEFAULT 'pending'
        )
      ''');
      print('✅ Created: instruments table');

      // Test Methods table
      await database.execute('''
        CREATE TABLE IF NOT EXISTS test_methods (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          server_id INTEGER,
          method_name TEXT NOT NULL,
          description TEXT,
          created_at TEXT,
          created_by TEXT,
          last_modified TEXT,
          last_modified_by TEXT,
          is_deleted INTEGER DEFAULT 0,
          deleted_by TEXT,
          is_synced INTEGER DEFAULT 0,
          sync_status TEXT DEFAULT 'pending'
        )
      ''');
      print('✅ Created: test_methods table');

      // States table
      await database.execute('''
        CREATE TABLE IF NOT EXISTS states (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          server_id INTEGER,
          name TEXT NOT NULL,
          country_id INTEGER,
          country_name TEXT,
          created_at TEXT,
          updated_at TEXT,
          is_deleted INTEGER DEFAULT 0,
          is_synced INTEGER DEFAULT 0
        )
      ''');
      print('✅ Created: states table');

      // Cities table
      await database.execute('''
        CREATE TABLE IF NOT EXISTS cities (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          server_id INTEGER,
          name TEXT NOT NULL,
          state_id INTEGER,
          state_name TEXT,
          created_at TEXT,
          updated_at TEXT,
          is_deleted INTEGER DEFAULT 0,
          is_synced INTEGER DEFAULT 0
        )
      ''');
      print('✅ Created: cities table');

      // Categories table
      await database.execute('''
        CREATE TABLE IF NOT EXISTS categories (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          server_id INTEGER,
          category_name TEXT NOT NULL,
          created_at TEXT,
          created_by TEXT,
          last_modified TEXT,
          last_modified_by TEXT,
          is_deleted INTEGER DEFAULT 0,
          deleted_by TEXT,
          is_synced INTEGER DEFAULT 0,
          sync_status TEXT DEFAULT 'pending'
        )
      ''');
      print('✅ Created: categories table');

      // Subcategories table
      await database.execute('''
        CREATE TABLE IF NOT EXISTS subcategories (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          server_id INTEGER,
          name TEXT NOT NULL,
          category_id INTEGER NOT NULL,
          category_server_id INTEGER,
          category_name TEXT,
          created_at TEXT,
          created_by TEXT,
          last_modified TEXT,
          last_modified_by TEXT,
          is_deleted INTEGER DEFAULT 0,
          deleted_by TEXT,
          is_synced INTEGER DEFAULT 0,
          sync_status TEXT DEFAULT 'pending'
        )
      ''');
      print('✅ Created: subcategories table');

      // HSN codes table
      await database.execute('''
        CREATE TABLE IF NOT EXISTS hsn_codes (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          server_id INTEGER,
          hsn_code TEXT NOT NULL UNIQUE,
          sgst REAL DEFAULT 0,
          cgst REAL DEFAULT 0,
          igst REAL DEFAULT 0,
          cess REAL DEFAULT 0,
          hsn_type INTEGER,
          tenant TEXT,
          tenant_id TEXT,
          created_at TEXT NOT NULL,
          created_by TEXT NOT NULL,
          last_modified TEXT,
          last_modified_by TEXT,
          deleted TEXT,
          deleted_by TEXT,
          is_synced INTEGER DEFAULT 0,
          is_deleted INTEGER DEFAULT 0,
          sync_attempts INTEGER DEFAULT 0,
          last_sync_error TEXT
        )
      ''');
      print('✅ Created: hsn_codes table');

      // Staff table
      await database.execute('''
        CREATE TABLE IF NOT EXISTS staff (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          server_id INTEGER,
          name TEXT NOT NULL,
          department TEXT NOT NULL,
          designation TEXT NOT NULL,
          email TEXT,
          phone TEXT NOT NULL,
          required_credentials TEXT NOT NULL,
          created_at TEXT NOT NULL,
          created_by TEXT,
          last_modified TEXT,
          last_modified_by TEXT,
          is_deleted INTEGER DEFAULT 0,
          deleted_by TEXT,
          is_synced INTEGER DEFAULT 0,
          sync_status TEXT DEFAULT 'pending',
          sync_attempts INTEGER DEFAULT 0,
          last_sync_error TEXT
        )
      ''');
      print('✅ Created: staff table');

      // Department table - ADD THIS
      await database.execute('''
        CREATE TABLE IF NOT EXISTS department (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          server_id INTEGER,
          name TEXT NOT NULL,
          description TEXT,
          created_at TEXT NOT NULL,
          created_by TEXT,
          last_modified TEXT,
          last_modified_by TEXT,
          is_deleted INTEGER DEFAULT 0,
          deleted_by TEXT,
          is_synced INTEGER DEFAULT 0,
          sync_status TEXT DEFAULT 'pending',
          sync_attempts INTEGER DEFAULT 0,
          last_sync_error TEXT
        )
      ''');
      await database.execute('''
        CREATE TABLE IF NOT EXISTS designation (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          server_id INTEGER,
          name TEXT NOT NULL,
          description TEXT,
          created_at TEXT NOT NULL,
          created_by TEXT,
          last_modified TEXT,
          last_modified_by TEXT,
          is_deleted INTEGER DEFAULT 0,
          deleted_by TEXT,
          is_synced INTEGER DEFAULT 0,
          sync_status TEXT DEFAULT 'pending',
          sync_attempts INTEGER DEFAULT 0,
          last_sync_error TEXT
        )
      ''');
      print('✅ Created: department table');

      // BAS names table
      await database.execute('''
        CREATE TABLE IF NOT EXISTS bas_names (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          server_id INTEGER,
          name TEXT NOT NULL,
          created_at TEXT,
          created_by TEXT,
          last_modified TEXT,
          last_modified_by TEXT,
          is_deleted INTEGER DEFAULT 0,
          deleted_by TEXT,
          is_synced INTEGER DEFAULT 0,
          sync_status TEXT DEFAULT 'pending',
          sync_attempts INTEGER DEFAULT 0,
          last_sync_error TEXT
        )
      ''');
      print('✅ Created: bas_names table');

      // Payment modes table
      await database.execute('''
        CREATE TABLE IF NOT EXISTS payment_modes (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          server_id INTEGER,
          name TEXT NOT NULL,
          description TEXT,
          tenant_id TEXT,
          created_at TEXT,
          created_by TEXT,
          last_modified TEXT,
          last_modified_by TEXT,
          is_deleted INTEGER DEFAULT 0,
          deleted_by TEXT,
          is_synced INTEGER DEFAULT 0,
          sync_status TEXT DEFAULT 'pending',
          sync_attempts INTEGER DEFAULT 0,
          last_sync_error TEXT
        )
      ''');
      print('✅ Created: payment_modes table');

      // Sample types table
      await database.execute('''
        CREATE TABLE IF NOT EXISTS sample_types (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          server_id INTEGER,
          name TEXT NOT NULL,
          description TEXT,
          created_at TEXT,
          created_by TEXT,
          last_modified TEXT,
          last_modified_by TEXT,
          is_deleted INTEGER DEFAULT 0,
          deleted_by TEXT,
          is_synced INTEGER DEFAULT 0,
          sync_status TEXT DEFAULT 'pending',
          sync_attempts INTEGER DEFAULT 0,
          last_sync_error TEXT
        )
      ''');
      print('✅ Created: sample_types table');

      // Branch types table
      await database.execute('''
        CREATE TABLE IF NOT EXISTS branch_types (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          server_id INTEGER,
          company_name TEXT NOT NULL,
          contact_person TEXT NOT NULL,
          contact_no TEXT NOT NULL,
          email TEXT NOT NULL,
          address1 TEXT NOT NULL,
          location TEXT NOT NULL,
          type TEXT NOT NULL,
          designation TEXT NOT NULL,
          mobile_no TEXT NOT NULL,
          address2 TEXT,
          country TEXT NOT NULL,
          state TEXT NOT NULL,
          city TEXT NOT NULL,
          created_at TEXT,
          created_by TEXT,
          last_modified TEXT,
          last_modified_by TEXT,
          is_deleted INTEGER DEFAULT 0,
          deleted_by TEXT,
          is_synced INTEGER DEFAULT 0,
          sync_status TEXT DEFAULT 'pending',
          sync_attempts INTEGER DEFAULT 0,
          last_sync_error TEXT
        )
      ''');
      print('✅ Created: branch_types table');

      // Collection centers table
      await database.execute('''
        CREATE TABLE IF NOT EXISTS collection_centers (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          server_id INTEGER,
          center_code TEXT NOT NULL,
          center_name TEXT NOT NULL,
          country TEXT NOT NULL,
          state TEXT NOT NULL,
          city TEXT NOT NULL,
          address1 TEXT NOT NULL,
          address2 TEXT,
          location TEXT,
          postal_code TEXT,
          latitude REAL DEFAULT 0.0,
          longitude REAL DEFAULT 0.0,
          gst_number TEXT,
          pan_number TEXT,
          contact_person_name TEXT NOT NULL,
          phone_no TEXT NOT NULL,
          email TEXT,
          centre_status TEXT NOT NULL,
          branch_type_id INTEGER,
          lab_affiliation_company TEXT,
          operational_hours_from TEXT,
          operational_hours_to TEXT,
          collection_days TEXT,
          sample_pickup_timing_from TEXT,
          sample_pickup_timing_to TEXT,
          transport_mode TEXT,
          courier_agency_name TEXT,
          commission_type TEXT,
          commission_value REAL DEFAULT 0.0,
          account_holder_name TEXT,
          account_no TEXT,
          ifsc_code TEXT,
          agreement_file1_path TEXT,
          agreement_file2_path TEXT,
          created_at TEXT,
          created_by TEXT,
          last_modified TEXT,
          last_modified_by TEXT,
          is_deleted INTEGER DEFAULT 0,
          deleted_by TEXT,
          is_synced INTEGER DEFAULT 0,
          sync_status TEXT DEFAULT 'pending',
          sync_attempts INTEGER DEFAULT 0,
          last_sync_error TEXT
        )
      ''');
      print('✅ Created: collection_centers table');

      // Groups table
      await database.execute('''
        CREATE TABLE IF NOT EXISTS groups (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          server_id INTEGER,
          name TEXT NOT NULL,
          description TEXT,
          code TEXT,
          type TEXT DEFAULT 'general',
          status TEXT DEFAULT 'active',
          tenant_id TEXT,
          created_at TEXT,
          created_by TEXT,
          last_modified TEXT,
          last_modified_by TEXT,
          is_deleted INTEGER DEFAULT 0,
          deleted_by TEXT,
          is_synced INTEGER DEFAULT 0,
          sync_status TEXT DEFAULT 'pending',
          sync_attempts INTEGER DEFAULT 0,
          last_sync_error TEXT
        )
      ''');
      print('✅ Created: groups table');

      // Test table
      await database.execute('''
        CREATE TABLE IF NOT EXISTS test (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          server_id INTEGER,
          code TEXT NOT NULL,
          name TEXT NOT NULL,
          product_group TEXT NOT NULL,
          mrp REAL NOT NULL DEFAULT 0.0,
          sales_rate_a REAL NOT NULL DEFAULT 0.0,
          sales_rate_b REAL NOT NULL DEFAULT 0.0,
          hsn_sac TEXT,
          gst INTEGER NOT NULL DEFAULT 0,
          barcode TEXT,
          min_value REAL NOT NULL DEFAULT 0.0,
          max_value REAL NOT NULL DEFAULT 0.0,
          unit TEXT NOT NULL,
          created_at TEXT NOT NULL,
          created_by TEXT,
          last_modified TEXT,
          last_modified_by TEXT,
          is_deleted INTEGER DEFAULT 0,
          deleted_by TEXT,
          is_synced INTEGER DEFAULT 0,
          sync_status TEXT DEFAULT 'pending',
          sync_attempts INTEGER DEFAULT 0,
          last_sync_error TEXT
        )
      ''');
      print('✅ Created: test table');

      // Packages table
      await database.execute('''
        CREATE TABLE IF NOT EXISTS packages (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          server_id INTEGER,
          code TEXT NOT NULL,
          name TEXT NOT NULL,
          gst REAL NOT NULL DEFAULT 0.0,
          rate REAL NOT NULL DEFAULT 0.0,
          tests_json TEXT NOT NULL,
          created_at TEXT NOT NULL,
          created_by TEXT,
          last_modified TEXT,
          last_modified_by TEXT,
          is_deleted INTEGER DEFAULT 0,
          deleted_by TEXT,
          is_synced INTEGER DEFAULT 0,
          sync_status TEXT DEFAULT 'pending',
          sync_attempts INTEGER DEFAULT 0,
          last_sync_error TEXT
        )
      ''');
      print('✅ Created: packages table');

      // Test BOM table
      await database.execute('''
        CREATE TABLE IF NOT EXISTS test_boms (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          server_id INTEGER,
          code TEXT NOT NULL UNIQUE,
          name TEXT NOT NULL,
          test_group TEXT NOT NULL,
          gender_type TEXT NOT NULL,
          description TEXT,
          rate REAL NOT NULL DEFAULT 0.0,
          gst REAL NOT NULL DEFAULT 0.0,
          turn_around_time TEXT NOT NULL,
          time_unit TEXT NOT NULL DEFAULT 'hours',
          is_active INTEGER DEFAULT 1,
          method TEXT,
          reference_range TEXT,
          clinical_significance TEXT,
          specimen_requirement TEXT,
          created_at TEXT NOT NULL,
          created_by TEXT NOT NULL,
          last_modified TEXT,
          last_modified_by TEXT,
          is_deleted INTEGER DEFAULT 0,
          deleted_by TEXT,
          is_synced INTEGER DEFAULT 0,
          sync_status TEXT DEFAULT 'pending',
          sync_attempts INTEGER DEFAULT 0,
          last_sync_error TEXT,
          parameters TEXT NOT NULL
        )
      ''');

      await database.execute('''
        CREATE TABLE IF NOT EXISTS divisions (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          server_id INTEGER,
          name TEXT NOT NULL,
          company_id INTEGER,
          company_name TEXT,
          created_at TEXT,
          created_by TEXT,
          last_modified TEXT,
          last_modified_by TEXT,
          is_deleted INTEGER DEFAULT 0,
          deleted_by TEXT,
          is_synced INTEGER DEFAULT 0,
          sync_status TEXT DEFAULT 'pending',
          sync_attempts INTEGER DEFAULT 0,
          last_sync_error TEXT
        )
      ''');
      print('✅ Created: test_boms table');

      // Patient identities table
      await database.execute('''
        CREATE TABLE IF NOT EXISTS patient_identities (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          server_id INTEGER,
          name TEXT NOT NULL,
          created_at TEXT,
          updated_at TEXT,
          is_deleted INTEGER DEFAULT 0,
          is_synced INTEGER DEFAULT 0
        )
      ''');
      print('✅ Created: patient_identities table');

      // Referrers table
      await database.execute('''
        CREATE TABLE IF NOT EXISTS referrers (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          server_id INTEGER,
          name TEXT NOT NULL,
          qualification TEXT,
          speciality TEXT,
          phone TEXT,
          email TEXT,
          address TEXT,
          commission_type TEXT,
          commission_value REAL,
          created_at TEXT,
          updated_at TEXT,
          is_deleted INTEGER DEFAULT 0,
          is_synced INTEGER DEFAULT 0
        )
      ''');
      print('✅ Created: referrers table');

      print('✅ All tables created successfully');
    } catch (e, stackTrace) {
      print('❌ Error creating tables: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  // Verify tables exist
  static Future<void> _verifyTables(DatabaseExecutor database) async {
    try {
      print('🔍 Verifying all tables...');

      final tables = await database.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'",
      );

      final tableNames = tables.map((t) => t['name'] as String).toList();
      print('📋 Found ${tableNames.length} tables: ${tableNames.join(', ')}');

      if (tableNames.isEmpty) {
        print('⚠️ No tables found, creating them...');
        await _createAllTables(database);
      }

      // Check for essential tables
      final essentialTables = [
        'user',
        'categories',
        'test',
        'packages',
        'units',
        'instruments',
        'test_methods',
        'groups',
        'referrers',
        'patient_identities',
        'department',
        'designation',
        'divisions',
      ];
      for (var table in essentialTables) {
        if (!tableNames.contains(table)) {
          print('⚠️ Missing essential table: $table');
          await _createAllTables(database);
          break;
        }
      }

      print('✅ Table verification completed');
    } catch (e) {
      print('❌ Table verification failed: $e');
    }
  }

  // Emergency recovery
  static Future<void> _emergencyRecovery() async {
    try {
      print('🆘 Starting emergency recovery...');

      // Close existing connection
      if (_database != null) {
        try {
          await _database!.close();
        } catch (e) {
          print('⚠️ Error closing database: $e');
        }
        _database = null;
      }

      // Reset state
      _initialized = false;
      _isInitializing = false;

      // Clear all repository instances
      _userRepository = null;
      _staffRepository = null;
      _departmentRepository = null;
      _designationRepository = null;
      _countryRepository = null;
      _stateRepository = null;
      _cityRepository = null;
      _categoryRepository = null;
      _subCategoryRepository = null;
      _hsnRepository = null;
      _basRepository = null;
      _paymentModeRepository = null;
      _sampleTypeRepository = null;
      _branchTypeRepository = null;
      _collectionCenterRepository = null;
      _referrerRepository = null;
      _groupRepository = null;
      _testBOMRepository = null;
      _unitRepository = null;
      _instrumentRepository = null;
      _testMethodRepository = null;
      _doctorCommissionRepository = null;
      _divisionRepository = null;
      print('✅ Emergency recovery completed');
    } catch (e) {
      print('❌ Emergency recovery failed: $e');
    }
  }

  // Repository getters
  static Future<UserRepository> get userRepository async {
    final db = await database;
    _userRepository ??= UserRepository(db);
    return _userRepository!;
  }

  static Future<StaffRepository> get staffRepository async {
    final db = await database;
    _staffRepository ??= StaffRepository(db.staffDao);
    return _staffRepository!;
  }

  // ADD THIS
  static Future<DepartmentRepository> get departmentRepository async {
    final db = await database;
    _departmentRepository ??= DepartmentRepository(db.departmentDao);
    return _departmentRepository!;
  }

  static Future<DesignationRepository> get designationRepository async {
    final db = await database;
    _designationRepository ??= DesignationRepository(db.designationDao);
    return _designationRepository!;
  }

  static Future<CountryRepository> get countryRepository async {
    final db = await database;
    _countryRepository ??= CountryRepository(db.countryDao);
    return _countryRepository!;
  }

  static Future<TestMethodRepository> get testMethodRepository async {
    final db = await database;
    _testMethodRepository ??= TestMethodRepository(db.testMethodDao);
    return _testMethodRepository!;
  }

  static Future<InstrumentRepository> get instrumentRepository async {
    final db = await database;
    _instrumentRepository ??= InstrumentRepository(db.instrumentDao);
    return _instrumentRepository!;
  }

  static Future<UnitRepository> get unitRepository async {
    final db = await database;
    _unitRepository ??= UnitRepository(db.unitDao);
    return _unitRepository!;
  }

  static Future<GroupRepository> get groupRepository async {
    final db = await database;
    _groupRepository ??= GroupRepository(db.groupDao);
    return _groupRepository!;
  }

  static Future<DoctorCommissionRepository>
  get doctorCommissionRepository async {
    final db = await database;
    _doctorCommissionRepository ??= DoctorCommissionRepository(
      db.doctorCommissionDao,
    );
    return _doctorCommissionRepository!;
  }

  static Future<ReferrerRepository> get refrerrerRepository async {
    final db = await database;
    _referrerRepository ??= ReferrerRepository(db.referrerDao);
    return _referrerRepository!;
  }

  static Future<StateRepository> get stateRepository async {
    final db = await database;
    _stateRepository ??= StateRepository(db.stateDao);
    return _stateRepository!;
  }

  static Future<CityRepository> get cityRepository async {
    final db = await database;
    _cityRepository ??= CityRepository(db.cityDao);
    return _cityRepository!;
  }

  static Future<CategoryRepository> get categoryRepository async {
    final db = await database;
    _categoryRepository ??= CategoryRepository(db.categoryDao);
    return _categoryRepository!;
  }

  static Future<SubCategoryRepository> get subCategoryRepository async {
    final db = await database;
    _subCategoryRepository ??= SubCategoryRepository(db.subcategoryDao);
    return _subCategoryRepository!;
  }

  static Future<HsnRepository> get hsnRepository async {
    final db = await database;
    _hsnRepository ??= HsnRepository(db.hsnDao);
    return _hsnRepository!;
  }

  static Future<BasRepository> get basRepository async {
    final db = await database;
    _basRepository ??= BasRepository(db.basDao);
    return _basRepository!;
  }

  static Future<PaymentModeRepository> get paymentModeRepository async {
    final db = await database;
    _paymentModeRepository ??= PaymentModeRepository(db.paymentModeDao);
    return _paymentModeRepository!;
  }

  static Future<SampleTypeRepository> get sampleTypeRepository async {
    final db = await database;
    _sampleTypeRepository ??= SampleTypeRepository(db.sampleTypeDao);
    return _sampleTypeRepository!;
  }

  static Future<BranchTypeRepository> get branchTypeRepository async {
    final db = await database;
    _branchTypeRepository ??= BranchTypeRepository(db.branchTypeDao);
    return _branchTypeRepository!;
  }

  static Future<CollectionCenterRepository>
  get collectionCenterRepository async {
    final db = await database;
    _collectionCenterRepository ??= CollectionCenterRepository(
      db.collectionCenterDao,
    );
    return _collectionCenterRepository!;
  }

  static Future<TestBOMRepository> get testBOMRepository async {
    final db = await database;
    _testBOMRepository ??= TestBOMRepository(db);
    return _testBOMRepository!;
  }

  // Utility methods
  static Future<void> resetDatabase() async {
    print('🔄 Resetting database...');
    await _emergencyRecovery();
    await _cleanOldDatabase();
    _database = null;
    _initialized = false;
    print('✅ Database reset complete');
  }

  static Future<void> closeDatabase() async {
    print('🔒 Closing database...');
    if (_database != null) {
      await _database!.close();
      _database = null;
      _initialized = false;
    }
    print('✅ Database closed');
  }

  static Future<void> debugDatabase() async {
    try {
      print('🔍 Debugging database...');
      final db = await database;
      final versionResult = await db.database.rawQuery('PRAGMA user_version');
      final version = versionResult.first['user_version'];
      print('📊 Database version: $version');
      final tables = await db.database.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' ORDER BY name",
      );
      print('📋 Found ${tables.length} tables:');
      for (var table in tables) {
        final tableName = table['name'] as String;
        try {
          final countResult = await db.database.rawQuery(
            'SELECT COUNT(*) as count FROM $tableName',
          );
          final count = countResult.first['count'];
          print('   - $tableName: $count rows');
        } catch (e) {
          print('   - $tableName: ERROR ($e)');
        }
      }
      print('✅ Debug completed');
    } catch (e) {
      print('❌ Debug failed: $e');
    }
  }

  // Screen initialization methods
  static Future<void> initializeGroupScreen() async {
    try {
      print('🚀 Initializing group screen...');
      final db = await database;
      await _verifyTables(db.database);
      print('✅ Group screen ready');
    } catch (e) {
      print('❌ Group screen initialization failed: $e');
    }
  }

  static Future<void> initializeStaffScreen() async {
    try {
      print('🚀 Initializing staff screen...');
      final db = await database;
      await _verifyTables(db.database);
      print('✅ Staff screen ready');
    } catch (e) {
      print('❌ Staff screen initialization failed: $e');
    }
  }

  // ADD THIS
  static Future<void> initializeDepartmentScreen() async {
    try {
      print('🚀 Initializing department screen...');
      final db = await database;
      await _verifyTables(db.database);
      print('✅ Department screen ready');
    } catch (e) {
      print('❌ Department screen initialization failed: $e');
    }
  }

  static Future<void> initializeTestScreen() async {
    try {
      print('🚀 Initializing test screen...');
      final db = await database;
      await _verifyTables(db.database);
      print('✅ Test screen ready');
    } catch (e) {
      print('❌ Test screen initialization failed: $e');
    }
  }

  static Future<void> initializePackageScreen() async {
    try {
      print('🚀 Initializing package screen...');
      final db = await database;
      await _verifyTables(db.database);
      print('✅ Package screen ready');
    } catch (e) {
      print('❌ Package screen initialization failed: $e');
    }
  }

  static Future<void> initializeTestBOMScreen() async {
    try {
      print('🚀 Initializing Test BOM screen...');
      final db = await database;
      await _verifyTables(db.database);
      print('✅ Test BOM screen ready');
    } catch (e) {
      print('❌ Test BOM initialization failed: $e');
    }
  }

  static Future<void> initializeUnitScreen() async {
    try {
      print('🚀 Initializing Unit screen...');
      final db = await database;
      await _verifyTables(db.database);
      print('✅ Unit screen ready');
    } catch (e) {
      print('❌ Unit screen initialization failed: $e');
    }
  }

  static Future<void> initializeInstrumentScreen() async {
    try {
      print('🚀 Initializing Instrument screen...');
      final db = await database;
      await _verifyTables(db.database);
      print('✅ Instrument screen ready');
    } catch (e) {
      print('❌ Instrument screen initialization failed: $e');
    }
  }

  static Future<void> initializeTestMethodScreen() async {
    try {
      print('🚀 Initializing Test Method screen...');
      final db = await database;
      await _verifyTables(db.database);
      print('✅ Test Method screen ready');
    } catch (e) {
      print('❌ Test Method screen initialization failed: $e');
    }
  }

  static Future<void> initializeAll() async {
    try {
      print('🚀 Initializing all database components...');
      await database;
      print('✅ All database components initialized');
    } catch (e) {
      print('❌ Initialization failed: $e');
      await resetDatabase();
      rethrow;
    }
  }

  // Quick test method
  static Future<bool> testConnection() async {
    try {
      final db = await database;
      final result = await db.database.rawQuery('SELECT 1');
      return result.isNotEmpty;
    } catch (e) {
      print('❌ Database test failed: $e');
      return false;
    }
  }

  // Get database info
  static Future<Map<String, dynamic>> getDatabaseInfo() async {
    try {
      final db = await database;
      final versionResult = await db.database.rawQuery('PRAGMA user_version');
      final tables = await db.database.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'",
      );

      final tableCounts = <String, int>{};
      for (var table in tables) {
        final tableName = table['name'] as String;
        final countResult = await db.database.rawQuery(
          'SELECT COUNT(*) as count FROM $tableName',
        );
        tableCounts[tableName] = countResult.first['count'] as int;
      }

      return {
        'version': versionResult.first['user_version'],
        'tables': tables.map((t) => t['name'] as String).toList(),
        'tableCounts': tableCounts,
        'isInitialized': _initialized,
      };
    } catch (e) {
      return {'error': e.toString(), 'isInitialized': _initialized};
    }
  }
}
