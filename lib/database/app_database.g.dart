// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  UserDao? _userDaoInstance;

  CountryDao? _countryDaoInstance;

  CityDao? _cityDaoInstance;

  StateDao? _stateDaoInstance;

  CategoryDao? _categoryDaoInstance;

  SubCategoryDao? _subcategoryDaoInstance;

  HsnDao? _hsnDaoInstance;

  StaffDao? _staffDaoInstance;

  BasDao? _basDaoInstance;

  PaymentModeDao? _paymentModeDaoInstance;

  SampleTypeDao? _sampleTypeDaoInstance;

  BranchTypeDao? _branchTypeDaoInstance;

  CollectionCenterDao? _collectionCenterDaoInstance;

  GroupDao? _groupDaoInstance;

  TestDao? _testDaoInstance;

  PackageDao? _packageDaoInstance;

  TestBOMDao? _testBOMDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 22,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `users` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `email` TEXT NOT NULL, `age` INTEGER NOT NULL, `created_at` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `countries` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `server_id` INTEGER, `name` TEXT NOT NULL, `created_at` TEXT, `created_by` TEXT, `last_modified` TEXT, `last_modified_by` TEXT, `is_deleted` INTEGER NOT NULL, `deleted_by` TEXT, `is_synced` INTEGER NOT NULL, `sync_status` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `cities` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `server_id` INTEGER, `name` TEXT NOT NULL, `country_id` INTEGER NOT NULL, `state_id` INTEGER NOT NULL, `country_name` TEXT, `state_name` TEXT, `created_at` TEXT, `created_by` TEXT, `last_modified` TEXT, `last_modified_by` TEXT, `is_deleted` INTEGER NOT NULL, `deleted_by` TEXT, `is_synced` INTEGER NOT NULL, `sync_status` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `states` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `server_id` INTEGER, `name` TEXT NOT NULL, `country_id` INTEGER NOT NULL, `country_name` TEXT, `created_at` TEXT, `created_by` TEXT, `last_modified` TEXT, `last_modified_by` TEXT, `is_deleted` INTEGER NOT NULL, `deleted_by` TEXT, `is_synced` INTEGER NOT NULL, `sync_status` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `categories` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `server_id` INTEGER, `category_name` TEXT NOT NULL, `created_at` TEXT, `created_by` TEXT, `last_modified` TEXT, `last_modified_by` TEXT, `is_deleted` INTEGER NOT NULL, `deleted_by` TEXT, `is_synced` INTEGER NOT NULL, `sync_status` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `subcategories` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `server_id` INTEGER, `name` TEXT NOT NULL, `category_id` INTEGER NOT NULL, `category_server_id` INTEGER, `category_name` TEXT, `created_at` TEXT, `created_by` TEXT, `last_modified` TEXT, `last_modified_by` TEXT, `is_deleted` INTEGER NOT NULL, `deleted_by` TEXT, `is_synced` INTEGER NOT NULL, `sync_status` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `hsn_codes` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `server_id` INTEGER, `hsn_code` TEXT NOT NULL, `sgst` REAL NOT NULL, `cgst` REAL NOT NULL, `igst` REAL NOT NULL, `cess` REAL NOT NULL, `hsn_type` INTEGER, `tenant` TEXT, `tenant_id` TEXT, `created_at` TEXT NOT NULL, `created_by` TEXT NOT NULL, `last_modified` TEXT, `last_modified_by` TEXT, `deleted` TEXT, `deleted_by` TEXT, `is_synced` INTEGER NOT NULL, `is_deleted` INTEGER NOT NULL, `sync_attempts` INTEGER NOT NULL, `last_sync_error` TEXT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `staff` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `server_id` INTEGER, `name` TEXT NOT NULL, `department` TEXT NOT NULL, `designation` TEXT NOT NULL, `email` TEXT, `phone` TEXT NOT NULL, `required_credentials` TEXT NOT NULL, `created_at` TEXT NOT NULL, `created_by` TEXT, `last_modified` TEXT, `last_modified_by` TEXT, `is_deleted` INTEGER NOT NULL, `deleted_by` TEXT, `is_synced` INTEGER NOT NULL, `sync_status` TEXT, `sync_attempts` INTEGER NOT NULL, `last_sync_error` TEXT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `bas_names` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `server_id` INTEGER, `name` TEXT NOT NULL, `created_at` TEXT, `created_by` TEXT, `last_modified` TEXT, `last_modified_by` TEXT, `is_deleted` INTEGER NOT NULL, `deleted_by` TEXT, `is_synced` INTEGER NOT NULL, `sync_status` TEXT, `sync_attempts` INTEGER NOT NULL, `last_sync_error` TEXT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `payment_modes` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `server_id` INTEGER, `name` TEXT NOT NULL, `description` TEXT, `tenant_id` TEXT, `created_at` TEXT, `created_by` TEXT, `last_modified` TEXT, `last_modified_by` TEXT, `is_deleted` INTEGER NOT NULL, `deleted_by` TEXT, `is_synced` INTEGER NOT NULL, `sync_status` TEXT, `sync_attempts` INTEGER NOT NULL, `last_sync_error` TEXT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `sample_types` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `server_id` INTEGER, `name` TEXT NOT NULL, `description` TEXT, `created_at` TEXT, `created_by` TEXT, `last_modified` TEXT, `last_modified_by` TEXT, `is_deleted` INTEGER NOT NULL, `deleted_by` TEXT, `is_synced` INTEGER NOT NULL, `sync_status` TEXT, `sync_attempts` INTEGER NOT NULL, `last_sync_error` TEXT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `branch_types` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `server_id` INTEGER, `company_name` TEXT NOT NULL, `contact_person` TEXT NOT NULL, `contact_no` TEXT NOT NULL, `email` TEXT NOT NULL, `address1` TEXT NOT NULL, `location` TEXT NOT NULL, `type` TEXT NOT NULL, `designation` TEXT NOT NULL, `mobile_no` TEXT NOT NULL, `address2` TEXT NOT NULL, `country` TEXT NOT NULL, `state` TEXT NOT NULL, `city` TEXT NOT NULL, `created_at` TEXT, `created_by` TEXT, `last_modified` TEXT, `last_modified_by` TEXT, `is_deleted` INTEGER NOT NULL, `deleted_by` TEXT, `is_synced` INTEGER NOT NULL, `sync_status` TEXT NOT NULL, `sync_attempts` INTEGER NOT NULL, `last_sync_error` TEXT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `collection_centers` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `server_id` INTEGER, `center_code` TEXT NOT NULL, `center_name` TEXT NOT NULL, `country` TEXT NOT NULL, `state` TEXT NOT NULL, `city` TEXT NOT NULL, `address1` TEXT NOT NULL, `address2` TEXT NOT NULL, `location` TEXT NOT NULL, `postal_code` TEXT NOT NULL, `latitude` REAL NOT NULL, `longitude` REAL NOT NULL, `gst_number` TEXT NOT NULL, `pan_number` TEXT NOT NULL, `contact_person_name` TEXT NOT NULL, `phone_no` TEXT NOT NULL, `email` TEXT NOT NULL, `centre_status` TEXT NOT NULL, `branch_type_id` INTEGER, `lab_affiliation_company` TEXT NOT NULL, `operational_hours_from` TEXT NOT NULL, `operational_hours_to` TEXT NOT NULL, `collection_days` TEXT NOT NULL, `sample_pickup_timing_from` TEXT NOT NULL, `sample_pickup_timing_to` TEXT NOT NULL, `transport_mode` TEXT NOT NULL, `courier_agency_name` TEXT NOT NULL, `commission_type` TEXT NOT NULL, `commission_value` REAL NOT NULL, `account_holder_name` TEXT NOT NULL, `account_no` TEXT NOT NULL, `ifsc_code` TEXT NOT NULL, `agreement_file1_path` TEXT, `agreement_file2_path` TEXT, `created_at` TEXT, `created_by` TEXT, `last_modified` TEXT, `last_modified_by` TEXT, `is_deleted` INTEGER NOT NULL, `deleted_by` TEXT, `is_synced` INTEGER NOT NULL, `sync_status` TEXT NOT NULL, `sync_attempts` INTEGER NOT NULL, `last_sync_error` TEXT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `groups` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `server_id` INTEGER, `name` TEXT NOT NULL, `description` TEXT, `code` TEXT, `type` TEXT, `status` TEXT, `tenant_id` TEXT, `created_at` TEXT, `created_by` TEXT, `last_modified` TEXT, `last_modified_by` TEXT, `is_deleted` INTEGER NOT NULL, `deleted_by` TEXT, `is_synced` INTEGER NOT NULL, `sync_status` TEXT, `sync_attempts` INTEGER NOT NULL, `last_sync_error` TEXT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `test` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `server_id` INTEGER, `code` TEXT NOT NULL, `name` TEXT NOT NULL, `product_group` TEXT NOT NULL, `mrp` REAL NOT NULL, `sales_rate_a` REAL NOT NULL, `sales_rate_b` REAL NOT NULL, `hsn_sac` TEXT, `gst` INTEGER NOT NULL, `barcode` TEXT, `min_value` REAL NOT NULL, `max_value` REAL NOT NULL, `unit` TEXT NOT NULL, `created_at` TEXT NOT NULL, `created_by` TEXT, `last_modified` TEXT, `last_modified_by` TEXT, `is_deleted` INTEGER NOT NULL, `deleted_by` TEXT, `is_synced` INTEGER NOT NULL, `sync_status` TEXT NOT NULL, `sync_attempts` INTEGER NOT NULL, `last_sync_error` TEXT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `packages` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `server_id` INTEGER, `code` TEXT NOT NULL, `name` TEXT NOT NULL, `gst` REAL NOT NULL, `rate` REAL NOT NULL, `tests_json` TEXT NOT NULL, `created_at` TEXT NOT NULL, `created_by` TEXT, `last_modified` TEXT, `last_modified_by` TEXT, `is_deleted` INTEGER NOT NULL, `deleted_by` TEXT, `is_synced` INTEGER NOT NULL, `sync_status` TEXT NOT NULL, `sync_attempts` INTEGER NOT NULL, `last_sync_error` TEXT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `test_boms` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `server_id` INTEGER, `code` TEXT NOT NULL, `name` TEXT NOT NULL, `test_group` TEXT NOT NULL, `gender_type` TEXT NOT NULL, `description` TEXT, `rate` REAL NOT NULL, `gst` REAL NOT NULL, `turn_around_time` TEXT NOT NULL, `time_unit` TEXT NOT NULL, `is_active` INTEGER NOT NULL, `method` TEXT, `reference_range` TEXT, `clinical_significance` TEXT, `specimen_requirement` TEXT, `created_at` TEXT NOT NULL, `created_by` TEXT NOT NULL, `last_modified` TEXT, `last_modified_by` TEXT, `is_deleted` INTEGER NOT NULL, `deleted_by` TEXT, `is_synced` INTEGER NOT NULL, `sync_status` TEXT NOT NULL, `sync_attempts` INTEGER NOT NULL, `last_sync_error` TEXT, `parameters` TEXT NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  UserDao get userDao {
    return _userDaoInstance ??= _$UserDao(database, changeListener);
  }

  @override
  CountryDao get countryDao {
    return _countryDaoInstance ??= _$CountryDao(database, changeListener);
  }

  @override
  CityDao get cityDao {
    return _cityDaoInstance ??= _$CityDao(database, changeListener);
  }

  @override
  StateDao get stateDao {
    return _stateDaoInstance ??= _$StateDao(database, changeListener);
  }

  @override
  CategoryDao get categoryDao {
    return _categoryDaoInstance ??= _$CategoryDao(database, changeListener);
  }

  @override
  SubCategoryDao get subcategoryDao {
    return _subcategoryDaoInstance ??=
        _$SubCategoryDao(database, changeListener);
  }

  @override
  HsnDao get hsnDao {
    return _hsnDaoInstance ??= _$HsnDao(database, changeListener);
  }

  @override
  StaffDao get staffDao {
    return _staffDaoInstance ??= _$StaffDao(database, changeListener);
  }

  @override
  BasDao get basDao {
    return _basDaoInstance ??= _$BasDao(database, changeListener);
  }

  @override
  PaymentModeDao get paymentModeDao {
    return _paymentModeDaoInstance ??=
        _$PaymentModeDao(database, changeListener);
  }

  @override
  SampleTypeDao get sampleTypeDao {
    return _sampleTypeDaoInstance ??= _$SampleTypeDao(database, changeListener);
  }

  @override
  BranchTypeDao get branchTypeDao {
    return _branchTypeDaoInstance ??= _$BranchTypeDao(database, changeListener);
  }

  @override
  CollectionCenterDao get collectionCenterDao {
    return _collectionCenterDaoInstance ??=
        _$CollectionCenterDao(database, changeListener);
  }

  @override
  GroupDao get groupDao {
    return _groupDaoInstance ??= _$GroupDao(database, changeListener);
  }

  @override
  TestDao get testDao {
    return _testDaoInstance ??= _$TestDao(database, changeListener);
  }

  @override
  PackageDao get packageDao {
    return _packageDaoInstance ??= _$PackageDao(database, changeListener);
  }

  @override
  TestBOMDao get testBOMDao {
    return _testBOMDaoInstance ??= _$TestBOMDao(database, changeListener);
  }
}

class _$UserDao extends UserDao {
  _$UserDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _userEntityInsertionAdapter = InsertionAdapter(
            database,
            'users',
            (UserEntity item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'email': item.email,
                  'age': item.age,
                  'created_at': item.createdAt
                }),
        _userEntityUpdateAdapter = UpdateAdapter(
            database,
            'users',
            ['id'],
            (UserEntity item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'email': item.email,
                  'age': item.age,
                  'created_at': item.createdAt
                }),
        _userEntityDeletionAdapter = DeletionAdapter(
            database,
            'users',
            ['id'],
            (UserEntity item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'email': item.email,
                  'age': item.age,
                  'created_at': item.createdAt
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<UserEntity> _userEntityInsertionAdapter;

  final UpdateAdapter<UserEntity> _userEntityUpdateAdapter;

  final DeletionAdapter<UserEntity> _userEntityDeletionAdapter;

  @override
  Future<List<UserEntity>> getAllUsers() async {
    return _queryAdapter.queryList(
        'SELECT * FROM users ORDER BY created_at DESC',
        mapper: (Map<String, Object?> row) => UserEntity(
            id: row['id'] as int?,
            name: row['name'] as String,
            email: row['email'] as String,
            age: row['age'] as int,
            createdAt: row['created_at'] as String));
  }

  @override
  Future<UserEntity?> getUserById(int id) async {
    return _queryAdapter.query('SELECT * FROM users WHERE id = ?1',
        mapper: (Map<String, Object?> row) => UserEntity(
            id: row['id'] as int?,
            name: row['name'] as String,
            email: row['email'] as String,
            age: row['age'] as int,
            createdAt: row['created_at'] as String),
        arguments: [id]);
  }

  @override
  Future<UserEntity?> getUserByEmail(String email) async {
    return _queryAdapter.query('SELECT * FROM users WHERE email = ?1',
        mapper: (Map<String, Object?> row) => UserEntity(
            id: row['id'] as int?,
            name: row['name'] as String,
            email: row['email'] as String,
            age: row['age'] as int,
            createdAt: row['created_at'] as String),
        arguments: [email]);
  }

  @override
  Future<List<UserEntity>> searchUsers(String search) async {
    return _queryAdapter.queryList('SELECT * FROM users WHERE name LIKE ?1',
        mapper: (Map<String, Object?> row) => UserEntity(
            id: row['id'] as int?,
            name: row['name'] as String,
            email: row['email'] as String,
            age: row['age'] as int,
            createdAt: row['created_at'] as String),
        arguments: [search]);
  }

  @override
  Future<int?> deleteUserById(int id) async {
    return _queryAdapter.query('DELETE FROM users WHERE id = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [id]);
  }

  @override
  Future<void> deleteAllUsers() async {
    await _queryAdapter.queryNoReturn('DELETE FROM users');
  }

  @override
  Future<int> insertUser(UserEntity user) {
    return _userEntityInsertionAdapter.insertAndReturnId(
        user, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateUser(UserEntity user) {
    return _userEntityUpdateAdapter.updateAndReturnChangedRows(
        user, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteUser(UserEntity user) {
    return _userEntityDeletionAdapter.deleteAndReturnChangedRows(user);
  }
}

class _$CountryDao extends CountryDao {
  _$CountryDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _countryEntityInsertionAdapter = InsertionAdapter(
            database,
            'countries',
            (CountryEntity item) => <String, Object?>{
                  'id': item.id,
                  'server_id': item.serverId,
                  'name': item.name,
                  'created_at': item.createdAt,
                  'created_by': item.createdBy,
                  'last_modified': item.lastModified,
                  'last_modified_by': item.lastModifiedBy,
                  'is_deleted': item.isDeleted ? 1 : 0,
                  'deleted_by': item.deletedBy,
                  'is_synced': item.isSynced ? 1 : 0,
                  'sync_status': item.syncStatus
                }),
        _countryEntityUpdateAdapter = UpdateAdapter(
            database,
            'countries',
            ['id'],
            (CountryEntity item) => <String, Object?>{
                  'id': item.id,
                  'server_id': item.serverId,
                  'name': item.name,
                  'created_at': item.createdAt,
                  'created_by': item.createdBy,
                  'last_modified': item.lastModified,
                  'last_modified_by': item.lastModifiedBy,
                  'is_deleted': item.isDeleted ? 1 : 0,
                  'deleted_by': item.deletedBy,
                  'is_synced': item.isSynced ? 1 : 0,
                  'sync_status': item.syncStatus
                }),
        _countryEntityDeletionAdapter = DeletionAdapter(
            database,
            'countries',
            ['id'],
            (CountryEntity item) => <String, Object?>{
                  'id': item.id,
                  'server_id': item.serverId,
                  'name': item.name,
                  'created_at': item.createdAt,
                  'created_by': item.createdBy,
                  'last_modified': item.lastModified,
                  'last_modified_by': item.lastModifiedBy,
                  'is_deleted': item.isDeleted ? 1 : 0,
                  'deleted_by': item.deletedBy,
                  'is_synced': item.isSynced ? 1 : 0,
                  'sync_status': item.syncStatus
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<CountryEntity> _countryEntityInsertionAdapter;

  final UpdateAdapter<CountryEntity> _countryEntityUpdateAdapter;

  final DeletionAdapter<CountryEntity> _countryEntityDeletionAdapter;

  @override
  Future<CountryEntity?> getCountryById(int id) async {
    return _queryAdapter.query('SELECT * FROM countries WHERE id = ?1',
        mapper: (Map<String, Object?> row) => CountryEntity(
            id: row['id'] as int?,
            serverId: row['server_id'] as int?,
            name: row['name'] as String,
            createdAt: row['created_at'] as String?,
            createdBy: row['created_by'] as String?,
            lastModified: row['last_modified'] as String?,
            lastModifiedBy: row['last_modified_by'] as String?,
            isDeleted: (row['is_deleted'] as int) != 0,
            deletedBy: row['deleted_by'] as String?,
            isSynced: (row['is_synced'] as int) != 0,
            syncStatus: row['sync_status'] as String),
        arguments: [id]);
  }

  @override
  Future<CountryEntity?> getCountryByServerId(int serverId) async {
    return _queryAdapter.query('SELECT * FROM countries WHERE server_id = ?1',
        mapper: (Map<String, Object?> row) => CountryEntity(
            id: row['id'] as int?,
            serverId: row['server_id'] as int?,
            name: row['name'] as String,
            createdAt: row['created_at'] as String?,
            createdBy: row['created_by'] as String?,
            lastModified: row['last_modified'] as String?,
            lastModifiedBy: row['last_modified_by'] as String?,
            isDeleted: (row['is_deleted'] as int) != 0,
            deletedBy: row['deleted_by'] as String?,
            isSynced: (row['is_synced'] as int) != 0,
            syncStatus: row['sync_status'] as String),
        arguments: [serverId]);
  }

  @override
  Future<List<CountryEntity>> getAllCountries() async {
    return _queryAdapter.queryList(
        'SELECT * FROM countries WHERE is_deleted = 0 ORDER BY name ASC',
        mapper: (Map<String, Object?> row) => CountryEntity(
            id: row['id'] as int?,
            serverId: row['server_id'] as int?,
            name: row['name'] as String,
            createdAt: row['created_at'] as String?,
            createdBy: row['created_by'] as String?,
            lastModified: row['last_modified'] as String?,
            lastModifiedBy: row['last_modified_by'] as String?,
            isDeleted: (row['is_deleted'] as int) != 0,
            deletedBy: row['deleted_by'] as String?,
            isSynced: (row['is_synced'] as int) != 0,
            syncStatus: row['sync_status'] as String));
  }

  @override
  Future<List<CountryEntity>> searchCountries(String query) async {
    return _queryAdapter.queryList(
        'SELECT * FROM countries WHERE name LIKE ?1 AND is_deleted = 0 ORDER BY name ASC',
        mapper: (Map<String, Object?> row) => CountryEntity(id: row['id'] as int?, serverId: row['server_id'] as int?, name: row['name'] as String, createdAt: row['created_at'] as String?, createdBy: row['created_by'] as String?, lastModified: row['last_modified'] as String?, lastModifiedBy: row['last_modified_by'] as String?, isDeleted: (row['is_deleted'] as int) != 0, deletedBy: row['deleted_by'] as String?, isSynced: (row['is_synced'] as int) != 0, syncStatus: row['sync_status'] as String),
        arguments: [query]);
  }

  @override
  Future<List<CountryEntity>> getPendingSyncCountries() async {
    return _queryAdapter.queryList(
        'SELECT * FROM countries WHERE is_deleted = 0 AND (is_synced = 0 OR sync_status = \"pending\" OR sync_status = \"failed\") ORDER BY id ASC',
        mapper: (Map<String, Object?> row) => CountryEntity(
            id: row['id'] as int?,
            serverId: row['server_id'] as int?,
            name: row['name'] as String,
            createdAt: row['created_at'] as String?,
            createdBy: row['created_by'] as String?,
            lastModified: row['last_modified'] as String?,
            lastModifiedBy: row['last_modified_by'] as String?,
            isDeleted: (row['is_deleted'] as int) != 0,
            deletedBy: row['deleted_by'] as String?,
            isSynced: (row['is_synced'] as int) != 0,
            syncStatus: row['sync_status'] as String));
  }

  @override
  Future<int?> getCountriesCount() async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM countries WHERE is_deleted = 0',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<int?> getSyncedCountriesCount() async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM countries WHERE is_deleted = 0 AND is_synced = 1',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<int?> getPendingCountriesCount() async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM countries WHERE is_deleted = 0 AND (is_synced = 0 OR sync_status = \"pending\" OR sync_status = \"failed\")',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<int?> markAsDeleted(int id) async {
    return _queryAdapter.query(
        'UPDATE countries SET is_deleted = 1, deleted_by = \"system\", sync_status = \"pending\" WHERE id = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [id]);
  }

  @override
  Future<int?> markAsSynced(int id) async {
    return _queryAdapter.query(
        'UPDATE countries SET is_synced = 1, sync_status = \"synced\" WHERE id = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [id]);
  }

  @override
  Future<int?> markAsFailed(int id) async {
    return _queryAdapter.query(
        'UPDATE countries SET sync_status = \"failed\" WHERE id = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [id]);
  }

  @override
  Future<int> insertCountry(CountryEntity country) {
    return _countryEntityInsertionAdapter.insertAndReturnId(
        country, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateCountry(CountryEntity country) {
    return _countryEntityUpdateAdapter.updateAndReturnChangedRows(
        country, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteCountry(CountryEntity country) {
    return _countryEntityDeletionAdapter.deleteAndReturnChangedRows(country);
  }
}

class _$CityDao extends CityDao {
  _$CityDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _cityEntityInsertionAdapter = InsertionAdapter(
            database,
            'cities',
            (CityEntity item) => <String, Object?>{
                  'id': item.id,
                  'server_id': item.serverId,
                  'name': item.name,
                  'country_id': item.countryId,
                  'state_id': item.stateId,
                  'country_name': item.countryName,
                  'state_name': item.stateName,
                  'created_at': item.createdAt,
                  'created_by': item.createdBy,
                  'last_modified': item.lastModified,
                  'last_modified_by': item.lastModifiedBy,
                  'is_deleted': item.isDeleted ? 1 : 0,
                  'deleted_by': item.deletedBy,
                  'is_synced': item.isSynced ? 1 : 0,
                  'sync_status': item.syncStatus
                }),
        _cityEntityUpdateAdapter = UpdateAdapter(
            database,
            'cities',
            ['id'],
            (CityEntity item) => <String, Object?>{
                  'id': item.id,
                  'server_id': item.serverId,
                  'name': item.name,
                  'country_id': item.countryId,
                  'state_id': item.stateId,
                  'country_name': item.countryName,
                  'state_name': item.stateName,
                  'created_at': item.createdAt,
                  'created_by': item.createdBy,
                  'last_modified': item.lastModified,
                  'last_modified_by': item.lastModifiedBy,
                  'is_deleted': item.isDeleted ? 1 : 0,
                  'deleted_by': item.deletedBy,
                  'is_synced': item.isSynced ? 1 : 0,
                  'sync_status': item.syncStatus
                }),
        _cityEntityDeletionAdapter = DeletionAdapter(
            database,
            'cities',
            ['id'],
            (CityEntity item) => <String, Object?>{
                  'id': item.id,
                  'server_id': item.serverId,
                  'name': item.name,
                  'country_id': item.countryId,
                  'state_id': item.stateId,
                  'country_name': item.countryName,
                  'state_name': item.stateName,
                  'created_at': item.createdAt,
                  'created_by': item.createdBy,
                  'last_modified': item.lastModified,
                  'last_modified_by': item.lastModifiedBy,
                  'is_deleted': item.isDeleted ? 1 : 0,
                  'deleted_by': item.deletedBy,
                  'is_synced': item.isSynced ? 1 : 0,
                  'sync_status': item.syncStatus
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<CityEntity> _cityEntityInsertionAdapter;

  final UpdateAdapter<CityEntity> _cityEntityUpdateAdapter;

  final DeletionAdapter<CityEntity> _cityEntityDeletionAdapter;

  @override
  Future<CityEntity?> getCityById(int id) async {
    return _queryAdapter.query('SELECT * FROM cities WHERE id = ?1',
        mapper: (Map<String, Object?> row) => CityEntity(
            id: row['id'] as int?,
            serverId: row['server_id'] as int?,
            name: row['name'] as String,
            countryId: row['country_id'] as int,
            stateId: row['state_id'] as int,
            countryName: row['country_name'] as String?,
            stateName: row['state_name'] as String?,
            createdAt: row['created_at'] as String?,
            createdBy: row['created_by'] as String?,
            lastModified: row['last_modified'] as String?,
            lastModifiedBy: row['last_modified_by'] as String?,
            isDeleted: (row['is_deleted'] as int) != 0,
            deletedBy: row['deleted_by'] as String?,
            isSynced: (row['is_synced'] as int) != 0,
            syncStatus: row['sync_status'] as String),
        arguments: [id]);
  }

  @override
  Future<CityEntity?> getCityByServerId(int serverId) async {
    return _queryAdapter.query('SELECT * FROM cities WHERE server_id = ?1',
        mapper: (Map<String, Object?> row) => CityEntity(
            id: row['id'] as int?,
            serverId: row['server_id'] as int?,
            name: row['name'] as String,
            countryId: row['country_id'] as int,
            stateId: row['state_id'] as int,
            countryName: row['country_name'] as String?,
            stateName: row['state_name'] as String?,
            createdAt: row['created_at'] as String?,
            createdBy: row['created_by'] as String?,
            lastModified: row['last_modified'] as String?,
            lastModifiedBy: row['last_modified_by'] as String?,
            isDeleted: (row['is_deleted'] as int) != 0,
            deletedBy: row['deleted_by'] as String?,
            isSynced: (row['is_synced'] as int) != 0,
            syncStatus: row['sync_status'] as String),
        arguments: [serverId]);
  }

  @override
  Future<List<CityEntity>> getCitiesByState(int stateId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM cities WHERE state_id = ?1 AND is_deleted = 0 ORDER BY name ASC',
        mapper: (Map<String, Object?> row) => CityEntity(id: row['id'] as int?, serverId: row['server_id'] as int?, name: row['name'] as String, countryId: row['country_id'] as int, stateId: row['state_id'] as int, countryName: row['country_name'] as String?, stateName: row['state_name'] as String?, createdAt: row['created_at'] as String?, createdBy: row['created_by'] as String?, lastModified: row['last_modified'] as String?, lastModifiedBy: row['last_modified_by'] as String?, isDeleted: (row['is_deleted'] as int) != 0, deletedBy: row['deleted_by'] as String?, isSynced: (row['is_synced'] as int) != 0, syncStatus: row['sync_status'] as String),
        arguments: [stateId]);
  }

  @override
  Future<List<CityEntity>> getCitiesByStateAndCountry(
    int stateId,
    int countryId,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM cities WHERE state_id = ?1 AND country_id = ?2 AND is_deleted = 0 ORDER BY name ASC',
        mapper: (Map<String, Object?> row) => CityEntity(id: row['id'] as int?, serverId: row['server_id'] as int?, name: row['name'] as String, countryId: row['country_id'] as int, stateId: row['state_id'] as int, countryName: row['country_name'] as String?, stateName: row['state_name'] as String?, createdAt: row['created_at'] as String?, createdBy: row['created_by'] as String?, lastModified: row['last_modified'] as String?, lastModifiedBy: row['last_modified_by'] as String?, isDeleted: (row['is_deleted'] as int) != 0, deletedBy: row['deleted_by'] as String?, isSynced: (row['is_synced'] as int) != 0, syncStatus: row['sync_status'] as String),
        arguments: [stateId, countryId]);
  }

  @override
  Future<List<CityEntity>> searchCities(
    String query,
    int stateId,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM cities WHERE name LIKE ?1 AND state_id = ?2 AND is_deleted = 0 ORDER BY name ASC',
        mapper: (Map<String, Object?> row) => CityEntity(id: row['id'] as int?, serverId: row['server_id'] as int?, name: row['name'] as String, countryId: row['country_id'] as int, stateId: row['state_id'] as int, countryName: row['country_name'] as String?, stateName: row['state_name'] as String?, createdAt: row['created_at'] as String?, createdBy: row['created_by'] as String?, lastModified: row['last_modified'] as String?, lastModifiedBy: row['last_modified_by'] as String?, isDeleted: (row['is_deleted'] as int) != 0, deletedBy: row['deleted_by'] as String?, isSynced: (row['is_synced'] as int) != 0, syncStatus: row['sync_status'] as String),
        arguments: [query, stateId]);
  }

  @override
  Future<List<CityEntity>> searchCitiesWithCountry(
    String query,
    int stateId,
    int countryId,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM cities WHERE name LIKE ?1 AND state_id = ?2 AND country_id = ?3 AND is_deleted = 0 ORDER BY name ASC',
        mapper: (Map<String, Object?> row) => CityEntity(id: row['id'] as int?, serverId: row['server_id'] as int?, name: row['name'] as String, countryId: row['country_id'] as int, stateId: row['state_id'] as int, countryName: row['country_name'] as String?, stateName: row['state_name'] as String?, createdAt: row['created_at'] as String?, createdBy: row['created_by'] as String?, lastModified: row['last_modified'] as String?, lastModifiedBy: row['last_modified_by'] as String?, isDeleted: (row['is_deleted'] as int) != 0, deletedBy: row['deleted_by'] as String?, isSynced: (row['is_synced'] as int) != 0, syncStatus: row['sync_status'] as String),
        arguments: [query, stateId, countryId]);
  }

  @override
  Future<List<CityEntity>> getPendingSyncCities() async {
    return _queryAdapter.queryList(
        'SELECT * FROM cities WHERE is_deleted = 0 AND (is_synced = 0 OR sync_status = \"pending\" OR sync_status = \"failed\") ORDER BY id ASC',
        mapper: (Map<String, Object?> row) => CityEntity(
            id: row['id'] as int?,
            serverId: row['server_id'] as int?,
            name: row['name'] as String,
            countryId: row['country_id'] as int,
            stateId: row['state_id'] as int,
            countryName: row['country_name'] as String?,
            stateName: row['state_name'] as String?,
            createdAt: row['created_at'] as String?,
            createdBy: row['created_by'] as String?,
            lastModified: row['last_modified'] as String?,
            lastModifiedBy: row['last_modified_by'] as String?,
            isDeleted: (row['is_deleted'] as int) != 0,
            deletedBy: row['deleted_by'] as String?,
            isSynced: (row['is_synced'] as int) != 0,
            syncStatus: row['sync_status'] as String));
  }

  @override
  Future<List<CityEntity>> getPendingSyncByStateAndCountry(
    int stateId,
    int countryId,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM cities WHERE state_id = ?1 AND country_id = ?2 AND is_deleted = 0 AND (is_synced = 0 OR sync_status = \"pending\" OR sync_status = \"failed\") ORDER BY id ASC',
        mapper: (Map<String, Object?> row) => CityEntity(id: row['id'] as int?, serverId: row['server_id'] as int?, name: row['name'] as String, countryId: row['country_id'] as int, stateId: row['state_id'] as int, countryName: row['country_name'] as String?, stateName: row['state_name'] as String?, createdAt: row['created_at'] as String?, createdBy: row['created_by'] as String?, lastModified: row['last_modified'] as String?, lastModifiedBy: row['last_modified_by'] as String?, isDeleted: (row['is_deleted'] as int) != 0, deletedBy: row['deleted_by'] as String?, isSynced: (row['is_synced'] as int) != 0, syncStatus: row['sync_status'] as String),
        arguments: [stateId, countryId]);
  }

  @override
  Future<int?> getCitiesCountByState(int stateId) async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM cities WHERE state_id = ?1 AND is_deleted = 0',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [stateId]);
  }

  @override
  Future<int?> getCitiesCountByStateAndCountry(
    int stateId,
    int countryId,
  ) async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM cities WHERE state_id = ?1 AND country_id = ?2 AND is_deleted = 0',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [stateId, countryId]);
  }

  @override
  Future<int?> getSyncedCitiesCount() async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM cities WHERE is_deleted = 0 AND is_synced = 1',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<int?> getSyncedCountByStateAndCountry(
    int stateId,
    int countryId,
  ) async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM cities WHERE state_id = ?1 AND country_id = ?2 AND is_deleted = 0 AND is_synced = 1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [stateId, countryId]);
  }

  @override
  Future<int?> getPendingCitiesCount() async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM cities WHERE is_deleted = 0 AND (is_synced = 0 OR sync_status = \"pending\" OR sync_status = \"failed\")',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<int?> getPendingCountByStateAndCountry(
    int stateId,
    int countryId,
  ) async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM cities WHERE state_id = ?1 AND country_id = ?2 AND is_deleted = 0 AND (is_synced = 0 OR sync_status = \"pending\" OR sync_status = \"failed\")',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [stateId, countryId]);
  }

  @override
  Future<int?> getDeletedCountByStateAndCountry(
    int stateId,
    int countryId,
  ) async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM cities WHERE state_id = ?1 AND country_id = ?2 AND is_deleted = 1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [stateId, countryId]);
  }

  @override
  Future<List<CityEntity>> getAllCitiesByStateAndCountry(
    int stateId,
    int countryId,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM cities WHERE state_id = ?1 AND country_id = ?2 ORDER BY name ASC',
        mapper: (Map<String, Object?> row) => CityEntity(id: row['id'] as int?, serverId: row['server_id'] as int?, name: row['name'] as String, countryId: row['country_id'] as int, stateId: row['state_id'] as int, countryName: row['country_name'] as String?, stateName: row['state_name'] as String?, createdAt: row['created_at'] as String?, createdBy: row['created_by'] as String?, lastModified: row['last_modified'] as String?, lastModifiedBy: row['last_modified_by'] as String?, isDeleted: (row['is_deleted'] as int) != 0, deletedBy: row['deleted_by'] as String?, isSynced: (row['is_synced'] as int) != 0, syncStatus: row['sync_status'] as String),
        arguments: [stateId, countryId]);
  }

  @override
  Future<int?> markAsDeleted(int id) async {
    return _queryAdapter.query(
        'UPDATE cities SET is_deleted = 1, sync_status = \"pending\" WHERE id = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [id]);
  }

  @override
  Future<int?> markAsSynced(int id) async {
    return _queryAdapter.query(
        'UPDATE cities SET is_synced = 1, sync_status = \"synced\" WHERE id = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [id]);
  }

  @override
  Future<int?> markAsFailed(int id) async {
    return _queryAdapter.query(
        'UPDATE cities SET sync_status = \"failed\" WHERE id = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [id]);
  }

  @override
  Future<int?> markMultipleAsSynced(List<int> ids) async {
    const offset = 1;
    final _sqliteVariablesForIds =
        Iterable<String>.generate(ids.length, (i) => '?${i + offset}')
            .join(',');
    return _queryAdapter.query(
        'UPDATE cities SET is_synced = 1, sync_status = \"synced\" WHERE id IN (' +
            _sqliteVariablesForIds +
            ')',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [...ids]);
  }

  @override
  Future<int?> markMultipleAsPending(List<int> ids) async {
    const offset = 1;
    final _sqliteVariablesForIds =
        Iterable<String>.generate(ids.length, (i) => '?${i + offset}')
            .join(',');
    return _queryAdapter.query(
        'UPDATE cities SET is_synced = 0, sync_status = \"pending\" WHERE id IN (' +
            _sqliteVariablesForIds +
            ')',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [...ids]);
  }

  @override
  Future<int?> deleteAllByStateAndCountry(
    int stateId,
    int countryId,
  ) async {
    return _queryAdapter.query(
        'DELETE FROM cities WHERE state_id = ?1 AND country_id = ?2',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [stateId, countryId]);
  }

  @override
  Future<int?> softDeleteAllByStateAndCountry(
    int stateId,
    int countryId,
  ) async {
    return _queryAdapter.query(
        'UPDATE cities SET is_deleted = 1, sync_status = \"pending\" WHERE state_id = ?1 AND country_id = ?2 AND is_deleted = 0',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [stateId, countryId]);
  }

  @override
  Future<int?> restoreDeletedByStateAndCountry(
    int stateId,
    int countryId,
  ) async {
    return _queryAdapter.query(
        'UPDATE cities SET is_deleted = 0, sync_status = \"pending\" WHERE state_id = ?1 AND country_id = ?2 AND is_deleted = 1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [stateId, countryId]);
  }

  @override
  Future<CityEntity?> getCityByNameAndStateAndCountry(
    String name,
    int stateId,
    int countryId,
  ) async {
    return _queryAdapter.query(
        'SELECT * FROM cities WHERE name = ?1 AND state_id = ?2 AND country_id = ?3 AND is_deleted = 0 LIMIT 1',
        mapper: (Map<String, Object?> row) => CityEntity(id: row['id'] as int?, serverId: row['server_id'] as int?, name: row['name'] as String, countryId: row['country_id'] as int, stateId: row['state_id'] as int, countryName: row['country_name'] as String?, stateName: row['state_name'] as String?, createdAt: row['created_at'] as String?, createdBy: row['created_by'] as String?, lastModified: row['last_modified'] as String?, lastModifiedBy: row['last_modified_by'] as String?, isDeleted: (row['is_deleted'] as int) != 0, deletedBy: row['deleted_by'] as String?, isSynced: (row['is_synced'] as int) != 0, syncStatus: row['sync_status'] as String),
        arguments: [name, stateId, countryId]);
  }

  @override
  Future<int?> checkCityExists(
    String name,
    int stateId,
    int countryId,
  ) async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM cities WHERE name = ?1 AND state_id = ?2 AND country_id = ?3 AND is_deleted = 0',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [name, stateId, countryId]);
  }

  @override
  Future<int> insertCity(CityEntity city) {
    return _cityEntityInsertionAdapter.insertAndReturnId(
        city, OnConflictStrategy.abort);
  }

  @override
  Future<List<int>> insertCities(List<CityEntity> cities) {
    return _cityEntityInsertionAdapter.insertListAndReturnIds(
        cities, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateCity(CityEntity city) {
    return _cityEntityUpdateAdapter.updateAndReturnChangedRows(
        city, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateCities(List<CityEntity> cities) {
    return _cityEntityUpdateAdapter.updateListAndReturnChangedRows(
        cities, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteCity(CityEntity city) {
    return _cityEntityDeletionAdapter.deleteAndReturnChangedRows(city);
  }

  @override
  Future<int> deleteCities(List<CityEntity> cities) {
    return _cityEntityDeletionAdapter.deleteListAndReturnChangedRows(cities);
  }
}

class _$StateDao extends StateDao {
  _$StateDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _stateEntityInsertionAdapter = InsertionAdapter(
            database,
            'states',
            (StateEntity item) => <String, Object?>{
                  'id': item.id,
                  'server_id': item.serverId,
                  'name': item.name,
                  'country_id': item.countryId,
                  'country_name': item.countryName,
                  'created_at': item.createdAt,
                  'created_by': item.createdBy,
                  'last_modified': item.lastModified,
                  'last_modified_by': item.lastModifiedBy,
                  'is_deleted': item.isDeleted ? 1 : 0,
                  'deleted_by': item.deletedBy,
                  'is_synced': item.isSynced ? 1 : 0,
                  'sync_status': item.syncStatus
                }),
        _stateEntityUpdateAdapter = UpdateAdapter(
            database,
            'states',
            ['id'],
            (StateEntity item) => <String, Object?>{
                  'id': item.id,
                  'server_id': item.serverId,
                  'name': item.name,
                  'country_id': item.countryId,
                  'country_name': item.countryName,
                  'created_at': item.createdAt,
                  'created_by': item.createdBy,
                  'last_modified': item.lastModified,
                  'last_modified_by': item.lastModifiedBy,
                  'is_deleted': item.isDeleted ? 1 : 0,
                  'deleted_by': item.deletedBy,
                  'is_synced': item.isSynced ? 1 : 0,
                  'sync_status': item.syncStatus
                }),
        _stateEntityDeletionAdapter = DeletionAdapter(
            database,
            'states',
            ['id'],
            (StateEntity item) => <String, Object?>{
                  'id': item.id,
                  'server_id': item.serverId,
                  'name': item.name,
                  'country_id': item.countryId,
                  'country_name': item.countryName,
                  'created_at': item.createdAt,
                  'created_by': item.createdBy,
                  'last_modified': item.lastModified,
                  'last_modified_by': item.lastModifiedBy,
                  'is_deleted': item.isDeleted ? 1 : 0,
                  'deleted_by': item.deletedBy,
                  'is_synced': item.isSynced ? 1 : 0,
                  'sync_status': item.syncStatus
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<StateEntity> _stateEntityInsertionAdapter;

  final UpdateAdapter<StateEntity> _stateEntityUpdateAdapter;

  final DeletionAdapter<StateEntity> _stateEntityDeletionAdapter;

  @override
  Future<StateEntity?> getStateById(int id) async {
    return _queryAdapter.query('SELECT * FROM states WHERE id = ?1',
        mapper: (Map<String, Object?> row) => StateEntity(
            id: row['id'] as int?,
            serverId: row['server_id'] as int?,
            name: row['name'] as String,
            countryId: row['country_id'] as int,
            countryName: row['country_name'] as String?,
            createdAt: row['created_at'] as String?,
            createdBy: row['created_by'] as String?,
            lastModified: row['last_modified'] as String?,
            lastModifiedBy: row['last_modified_by'] as String?,
            isDeleted: (row['is_deleted'] as int) != 0,
            deletedBy: row['deleted_by'] as String?,
            isSynced: (row['is_synced'] as int) != 0,
            syncStatus: row['sync_status'] as String),
        arguments: [id]);
  }

  @override
  Future<StateEntity?> getStateByServerId(int serverId) async {
    return _queryAdapter.query('SELECT * FROM states WHERE server_id = ?1',
        mapper: (Map<String, Object?> row) => StateEntity(
            id: row['id'] as int?,
            serverId: row['server_id'] as int?,
            name: row['name'] as String,
            countryId: row['country_id'] as int,
            countryName: row['country_name'] as String?,
            createdAt: row['created_at'] as String?,
            createdBy: row['created_by'] as String?,
            lastModified: row['last_modified'] as String?,
            lastModifiedBy: row['last_modified_by'] as String?,
            isDeleted: (row['is_deleted'] as int) != 0,
            deletedBy: row['deleted_by'] as String?,
            isSynced: (row['is_synced'] as int) != 0,
            syncStatus: row['sync_status'] as String),
        arguments: [serverId]);
  }

  @override
  Future<List<StateEntity>> getStatesByCountry(int countryId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM states WHERE country_id = ?1 AND is_deleted = 0 ORDER BY name ASC',
        mapper: (Map<String, Object?> row) => StateEntity(id: row['id'] as int?, serverId: row['server_id'] as int?, name: row['name'] as String, countryId: row['country_id'] as int, countryName: row['country_name'] as String?, createdAt: row['created_at'] as String?, createdBy: row['created_by'] as String?, lastModified: row['last_modified'] as String?, lastModifiedBy: row['last_modified_by'] as String?, isDeleted: (row['is_deleted'] as int) != 0, deletedBy: row['deleted_by'] as String?, isSynced: (row['is_synced'] as int) != 0, syncStatus: row['sync_status'] as String),
        arguments: [countryId]);
  }

  @override
  Future<List<StateEntity>> searchStates(
    String query,
    int countryId,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM states WHERE name LIKE ?1 AND country_id = ?2 AND is_deleted = 0 ORDER BY name ASC',
        mapper: (Map<String, Object?> row) => StateEntity(id: row['id'] as int?, serverId: row['server_id'] as int?, name: row['name'] as String, countryId: row['country_id'] as int, countryName: row['country_name'] as String?, createdAt: row['created_at'] as String?, createdBy: row['created_by'] as String?, lastModified: row['last_modified'] as String?, lastModifiedBy: row['last_modified_by'] as String?, isDeleted: (row['is_deleted'] as int) != 0, deletedBy: row['deleted_by'] as String?, isSynced: (row['is_synced'] as int) != 0, syncStatus: row['sync_status'] as String),
        arguments: [query, countryId]);
  }

  @override
  Future<List<StateEntity>> getPendingSyncStates() async {
    return _queryAdapter.queryList(
        'SELECT * FROM states WHERE is_deleted = 0 AND (is_synced = 0 OR sync_status = \"pending\" OR sync_status = \"failed\") ORDER BY id ASC',
        mapper: (Map<String, Object?> row) => StateEntity(
            id: row['id'] as int?,
            serverId: row['server_id'] as int?,
            name: row['name'] as String,
            countryId: row['country_id'] as int,
            countryName: row['country_name'] as String?,
            createdAt: row['created_at'] as String?,
            createdBy: row['created_by'] as String?,
            lastModified: row['last_modified'] as String?,
            lastModifiedBy: row['last_modified_by'] as String?,
            isDeleted: (row['is_deleted'] as int) != 0,
            deletedBy: row['deleted_by'] as String?,
            isSynced: (row['is_synced'] as int) != 0,
            syncStatus: row['sync_status'] as String));
  }

  @override
  Future<int?> getStatesCountByCountry(int countryId) async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM states WHERE country_id = ?1 AND is_deleted = 0',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [countryId]);
  }

  @override
  Future<int?> getSyncedStatesCount() async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM states WHERE is_deleted = 0 AND is_synced = 1',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<int?> getPendingStatesCount() async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM states WHERE is_deleted = 0 AND (is_synced = 0 OR sync_status = \"pending\" OR sync_status = \"failed\")',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<int?> markAsDeleted(int id) async {
    return _queryAdapter.query(
        'UPDATE states SET is_deleted = 1, sync_status = \"pending\" WHERE id = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [id]);
  }

  @override
  Future<int?> markAsSynced(int id) async {
    return _queryAdapter.query(
        'UPDATE states SET is_synced = 1, sync_status = \"synced\" WHERE id = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [id]);
  }

  @override
  Future<int?> markAsFailed(int id) async {
    return _queryAdapter.query(
        'UPDATE states SET sync_status = \"failed\" WHERE id = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [id]);
  }

  @override
  Future<int> insertState(StateEntity state) {
    return _stateEntityInsertionAdapter.insertAndReturnId(
        state, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateState(StateEntity state) {
    return _stateEntityUpdateAdapter.updateAndReturnChangedRows(
        state, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteState(StateEntity state) {
    return _stateEntityDeletionAdapter.deleteAndReturnChangedRows(state);
  }
}

class _$CategoryDao extends CategoryDao {
  _$CategoryDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _categoryEntityInsertionAdapter = InsertionAdapter(
            database,
            'categories',
            (CategoryEntity item) => <String, Object?>{
                  'id': item.id,
                  'server_id': item.serverId,
                  'category_name': item.categoryName,
                  'created_at': item.createdAt,
                  'created_by': item.createdBy,
                  'last_modified': item.lastModified,
                  'last_modified_by': item.lastModifiedBy,
                  'is_deleted': item.isDeleted ? 1 : 0,
                  'deleted_by': item.deletedBy,
                  'is_synced': item.isSynced ? 1 : 0,
                  'sync_status': item.syncStatus
                }),
        _categoryEntityUpdateAdapter = UpdateAdapter(
            database,
            'categories',
            ['id'],
            (CategoryEntity item) => <String, Object?>{
                  'id': item.id,
                  'server_id': item.serverId,
                  'category_name': item.categoryName,
                  'created_at': item.createdAt,
                  'created_by': item.createdBy,
                  'last_modified': item.lastModified,
                  'last_modified_by': item.lastModifiedBy,
                  'is_deleted': item.isDeleted ? 1 : 0,
                  'deleted_by': item.deletedBy,
                  'is_synced': item.isSynced ? 1 : 0,
                  'sync_status': item.syncStatus
                }),
        _categoryEntityDeletionAdapter = DeletionAdapter(
            database,
            'categories',
            ['id'],
            (CategoryEntity item) => <String, Object?>{
                  'id': item.id,
                  'server_id': item.serverId,
                  'category_name': item.categoryName,
                  'created_at': item.createdAt,
                  'created_by': item.createdBy,
                  'last_modified': item.lastModified,
                  'last_modified_by': item.lastModifiedBy,
                  'is_deleted': item.isDeleted ? 1 : 0,
                  'deleted_by': item.deletedBy,
                  'is_synced': item.isSynced ? 1 : 0,
                  'sync_status': item.syncStatus
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<CategoryEntity> _categoryEntityInsertionAdapter;

  final UpdateAdapter<CategoryEntity> _categoryEntityUpdateAdapter;

  final DeletionAdapter<CategoryEntity> _categoryEntityDeletionAdapter;

  @override
  Future<List<CategoryEntity>> getAllCategories() async {
    return _queryAdapter.queryList(
        'SELECT * FROM categories ORDER BY category_name',
        mapper: (Map<String, Object?> row) => CategoryEntity(
            id: row['id'] as int?,
            serverId: row['server_id'] as int?,
            categoryName: row['category_name'] as String,
            createdAt: row['created_at'] as String?,
            createdBy: row['created_by'] as String?,
            lastModified: row['last_modified'] as String?,
            lastModifiedBy: row['last_modified_by'] as String?,
            isDeleted: (row['is_deleted'] as int) != 0,
            deletedBy: row['deleted_by'] as String?,
            isSynced: (row['is_synced'] as int) != 0,
            syncStatus: row['sync_status'] as String));
  }

  @override
  Future<CategoryEntity?> getCategoryByServerId(int serverId) async {
    return _queryAdapter.query('SELECT * FROM categories WHERE server_id = ?1',
        mapper: (Map<String, Object?> row) => CategoryEntity(
            id: row['id'] as int?,
            serverId: row['server_id'] as int?,
            categoryName: row['category_name'] as String,
            createdAt: row['created_at'] as String?,
            createdBy: row['created_by'] as String?,
            lastModified: row['last_modified'] as String?,
            lastModifiedBy: row['last_modified_by'] as String?,
            isDeleted: (row['is_deleted'] as int) != 0,
            deletedBy: row['deleted_by'] as String?,
            isSynced: (row['is_synced'] as int) != 0,
            syncStatus: row['sync_status'] as String),
        arguments: [serverId]);
  }

  @override
  Future<CategoryEntity?> getCategoryById(int id) async {
    return _queryAdapter.query('SELECT * FROM categories WHERE id = ?1',
        mapper: (Map<String, Object?> row) => CategoryEntity(
            id: row['id'] as int?,
            serverId: row['server_id'] as int?,
            categoryName: row['category_name'] as String,
            createdAt: row['created_at'] as String?,
            createdBy: row['created_by'] as String?,
            lastModified: row['last_modified'] as String?,
            lastModifiedBy: row['last_modified_by'] as String?,
            isDeleted: (row['is_deleted'] as int) != 0,
            deletedBy: row['deleted_by'] as String?,
            isSynced: (row['is_synced'] as int) != 0,
            syncStatus: row['sync_status'] as String),
        arguments: [id]);
  }

  @override
  Future<int?> getTotalCount() async {
    return _queryAdapter.query('SELECT COUNT(*) FROM categories',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<int?> getSyncedCount() async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM categories WHERE is_synced = 1',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<int?> getPendingCount() async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM categories WHERE is_synced = 0',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<List<CategoryEntity>> getPendingSync() async {
    return _queryAdapter.queryList(
        'SELECT * FROM categories WHERE is_synced = 0',
        mapper: (Map<String, Object?> row) => CategoryEntity(
            id: row['id'] as int?,
            serverId: row['server_id'] as int?,
            categoryName: row['category_name'] as String,
            createdAt: row['created_at'] as String?,
            createdBy: row['created_by'] as String?,
            lastModified: row['last_modified'] as String?,
            lastModifiedBy: row['last_modified_by'] as String?,
            isDeleted: (row['is_deleted'] as int) != 0,
            deletedBy: row['deleted_by'] as String?,
            isSynced: (row['is_synced'] as int) != 0,
            syncStatus: row['sync_status'] as String));
  }

  @override
  Future<List<CategoryEntity>> searchCategories(String query) async {
    return _queryAdapter.queryList(
        'SELECT * FROM categories WHERE category_name LIKE ?1 ORDER BY category_name',
        mapper: (Map<String, Object?> row) => CategoryEntity(id: row['id'] as int?, serverId: row['server_id'] as int?, categoryName: row['category_name'] as String, createdAt: row['created_at'] as String?, createdBy: row['created_by'] as String?, lastModified: row['last_modified'] as String?, lastModifiedBy: row['last_modified_by'] as String?, isDeleted: (row['is_deleted'] as int) != 0, deletedBy: row['deleted_by'] as String?, isSynced: (row['is_synced'] as int) != 0, syncStatus: row['sync_status'] as String),
        arguments: [query]);
  }

  @override
  Future<int?> markAsSynced(
    int id,
    String status,
  ) async {
    return _queryAdapter.query(
        'UPDATE categories SET is_synced = 1, sync_status = ?2 WHERE id = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [id, status]);
  }

  @override
  Future<int?> softDelete(int id) async {
    return _queryAdapter.query(
        'UPDATE categories SET is_deleted = 1 WHERE id = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [id]);
  }

  @override
  Future<int?> deleteCategoryById(int id) async {
    return _queryAdapter.query('DELETE FROM categories WHERE id = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [id]);
  }

  @override
  Future<int?> deleteAllCategories() async {
    return _queryAdapter.query('DELETE FROM categories',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<int> insertCategory(CategoryEntity category) {
    return _categoryEntityInsertionAdapter.insertAndReturnId(
        category, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateCategory(CategoryEntity category) {
    return _categoryEntityUpdateAdapter.updateAndReturnChangedRows(
        category, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteCategory(CategoryEntity category) {
    return _categoryEntityDeletionAdapter.deleteAndReturnChangedRows(category);
  }
}

class _$SubCategoryDao extends SubCategoryDao {
  _$SubCategoryDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _subCategoryEntityInsertionAdapter = InsertionAdapter(
            database,
            'subcategories',
            (SubCategoryEntity item) => <String, Object?>{
                  'id': item.id,
                  'server_id': item.serverId,
                  'name': item.name,
                  'category_id': item.categoryId,
                  'category_server_id': item.categoryServerId,
                  'category_name': item.categoryName,
                  'created_at': item.createdAt,
                  'created_by': item.createdBy,
                  'last_modified': item.lastModified,
                  'last_modified_by': item.lastModifiedBy,
                  'is_deleted': item.isDeleted ? 1 : 0,
                  'deleted_by': item.deletedBy,
                  'is_synced': item.isSynced ? 1 : 0,
                  'sync_status': item.syncStatus
                }),
        _subCategoryEntityUpdateAdapter = UpdateAdapter(
            database,
            'subcategories',
            ['id'],
            (SubCategoryEntity item) => <String, Object?>{
                  'id': item.id,
                  'server_id': item.serverId,
                  'name': item.name,
                  'category_id': item.categoryId,
                  'category_server_id': item.categoryServerId,
                  'category_name': item.categoryName,
                  'created_at': item.createdAt,
                  'created_by': item.createdBy,
                  'last_modified': item.lastModified,
                  'last_modified_by': item.lastModifiedBy,
                  'is_deleted': item.isDeleted ? 1 : 0,
                  'deleted_by': item.deletedBy,
                  'is_synced': item.isSynced ? 1 : 0,
                  'sync_status': item.syncStatus
                }),
        _subCategoryEntityDeletionAdapter = DeletionAdapter(
            database,
            'subcategories',
            ['id'],
            (SubCategoryEntity item) => <String, Object?>{
                  'id': item.id,
                  'server_id': item.serverId,
                  'name': item.name,
                  'category_id': item.categoryId,
                  'category_server_id': item.categoryServerId,
                  'category_name': item.categoryName,
                  'created_at': item.createdAt,
                  'created_by': item.createdBy,
                  'last_modified': item.lastModified,
                  'last_modified_by': item.lastModifiedBy,
                  'is_deleted': item.isDeleted ? 1 : 0,
                  'deleted_by': item.deletedBy,
                  'is_synced': item.isSynced ? 1 : 0,
                  'sync_status': item.syncStatus
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<SubCategoryEntity> _subCategoryEntityInsertionAdapter;

  final UpdateAdapter<SubCategoryEntity> _subCategoryEntityUpdateAdapter;

  final DeletionAdapter<SubCategoryEntity> _subCategoryEntityDeletionAdapter;

  @override
  Future<List<SubCategoryEntity>> getAllSubCategories() async {
    return _queryAdapter.queryList('SELECT * FROM subcategories ORDER BY name',
        mapper: (Map<String, Object?> row) => SubCategoryEntity(
            id: row['id'] as int?,
            serverId: row['server_id'] as int?,
            name: row['name'] as String,
            categoryId: row['category_id'] as int,
            categoryServerId: row['category_server_id'] as int?,
            categoryName: row['category_name'] as String?,
            createdAt: row['created_at'] as String?,
            createdBy: row['created_by'] as String?,
            lastModified: row['last_modified'] as String?,
            lastModifiedBy: row['last_modified_by'] as String?,
            isDeleted: (row['is_deleted'] as int) != 0,
            deletedBy: row['deleted_by'] as String?,
            isSynced: (row['is_synced'] as int) != 0,
            syncStatus: row['sync_status'] as String));
  }

  @override
  Future<List<SubCategoryEntity>> getSubCategoriesByCategoryId(
      int categoryId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM subcategories WHERE category_id = ?1 ORDER BY name',
        mapper: (Map<String, Object?> row) => SubCategoryEntity(
            id: row['id'] as int?,
            serverId: row['server_id'] as int?,
            name: row['name'] as String,
            categoryId: row['category_id'] as int,
            categoryServerId: row['category_server_id'] as int?,
            categoryName: row['category_name'] as String?,
            createdAt: row['created_at'] as String?,
            createdBy: row['created_by'] as String?,
            lastModified: row['last_modified'] as String?,
            lastModifiedBy: row['last_modified_by'] as String?,
            isDeleted: (row['is_deleted'] as int) != 0,
            deletedBy: row['deleted_by'] as String?,
            isSynced: (row['is_synced'] as int) != 0,
            syncStatus: row['sync_status'] as String),
        arguments: [categoryId]);
  }

  @override
  Future<SubCategoryEntity?> getSubCategoryByServerId(int serverId) async {
    return _queryAdapter.query(
        'SELECT * FROM subcategories WHERE server_id = ?1',
        mapper: (Map<String, Object?> row) => SubCategoryEntity(
            id: row['id'] as int?,
            serverId: row['server_id'] as int?,
            name: row['name'] as String,
            categoryId: row['category_id'] as int,
            categoryServerId: row['category_server_id'] as int?,
            categoryName: row['category_name'] as String?,
            createdAt: row['created_at'] as String?,
            createdBy: row['created_by'] as String?,
            lastModified: row['last_modified'] as String?,
            lastModifiedBy: row['last_modified_by'] as String?,
            isDeleted: (row['is_deleted'] as int) != 0,
            deletedBy: row['deleted_by'] as String?,
            isSynced: (row['is_synced'] as int) != 0,
            syncStatus: row['sync_status'] as String),
        arguments: [serverId]);
  }

  @override
  Future<SubCategoryEntity?> getSubCategoryById(int id) async {
    return _queryAdapter.query('SELECT * FROM subcategories WHERE id = ?1',
        mapper: (Map<String, Object?> row) => SubCategoryEntity(
            id: row['id'] as int?,
            serverId: row['server_id'] as int?,
            name: row['name'] as String,
            categoryId: row['category_id'] as int,
            categoryServerId: row['category_server_id'] as int?,
            categoryName: row['category_name'] as String?,
            createdAt: row['created_at'] as String?,
            createdBy: row['created_by'] as String?,
            lastModified: row['last_modified'] as String?,
            lastModifiedBy: row['last_modified_by'] as String?,
            isDeleted: (row['is_deleted'] as int) != 0,
            deletedBy: row['deleted_by'] as String?,
            isSynced: (row['is_synced'] as int) != 0,
            syncStatus: row['sync_status'] as String),
        arguments: [id]);
  }

  @override
  Future<int?> getTotalCount() async {
    return _queryAdapter.query('SELECT COUNT(*) FROM subcategories',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<int?> getSyncedCount() async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM subcategories WHERE is_synced = 1',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<int?> getPendingCount() async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM subcategories WHERE is_synced = 0',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<List<SubCategoryEntity>> getPendingSync() async {
    return _queryAdapter.queryList(
        'SELECT * FROM subcategories WHERE is_synced = 0',
        mapper: (Map<String, Object?> row) => SubCategoryEntity(
            id: row['id'] as int?,
            serverId: row['server_id'] as int?,
            name: row['name'] as String,
            categoryId: row['category_id'] as int,
            categoryServerId: row['category_server_id'] as int?,
            categoryName: row['category_name'] as String?,
            createdAt: row['created_at'] as String?,
            createdBy: row['created_by'] as String?,
            lastModified: row['last_modified'] as String?,
            lastModifiedBy: row['last_modified_by'] as String?,
            isDeleted: (row['is_deleted'] as int) != 0,
            deletedBy: row['deleted_by'] as String?,
            isSynced: (row['is_synced'] as int) != 0,
            syncStatus: row['sync_status'] as String));
  }

  @override
  Future<List<SubCategoryEntity>> searchSubCategories(String query) async {
    return _queryAdapter.queryList(
        'SELECT * FROM subcategories WHERE name LIKE ?1 ORDER BY name',
        mapper: (Map<String, Object?> row) => SubCategoryEntity(
            id: row['id'] as int?,
            serverId: row['server_id'] as int?,
            name: row['name'] as String,
            categoryId: row['category_id'] as int,
            categoryServerId: row['category_server_id'] as int?,
            categoryName: row['category_name'] as String?,
            createdAt: row['created_at'] as String?,
            createdBy: row['created_by'] as String?,
            lastModified: row['last_modified'] as String?,
            lastModifiedBy: row['last_modified_by'] as String?,
            isDeleted: (row['is_deleted'] as int) != 0,
            deletedBy: row['deleted_by'] as String?,
            isSynced: (row['is_synced'] as int) != 0,
            syncStatus: row['sync_status'] as String),
        arguments: [query]);
  }

  @override
  Future<int?> markAsSynced(
    int id,
    String status,
  ) async {
    return _queryAdapter.query(
        'UPDATE subcategories SET is_synced = 1, sync_status = ?2 WHERE id = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [id, status]);
  }

  @override
  Future<int?> softDelete(int id) async {
    return _queryAdapter.query(
        'UPDATE subcategories SET is_deleted = 1 WHERE id = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [id]);
  }

  @override
  Future<int?> deleteSubCategoryById(int id) async {
    return _queryAdapter.query('DELETE FROM subcategories WHERE id = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [id]);
  }

  @override
  Future<int?> deleteSubCategoriesByCategoryId(int categoryId) async {
    return _queryAdapter.query(
        'DELETE FROM subcategories WHERE category_id = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [categoryId]);
  }

  @override
  Future<int?> deleteAllSubCategories() async {
    return _queryAdapter.query('DELETE FROM subcategories',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<int> insertSubCategory(SubCategoryEntity subCategory) {
    return _subCategoryEntityInsertionAdapter.insertAndReturnId(
        subCategory, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateSubCategory(SubCategoryEntity subCategory) {
    return _subCategoryEntityUpdateAdapter.updateAndReturnChangedRows(
        subCategory, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteSubCategory(SubCategoryEntity subCategory) {
    return _subCategoryEntityDeletionAdapter
        .deleteAndReturnChangedRows(subCategory);
  }
}

class _$HsnDao extends HsnDao {
  _$HsnDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _hsnEntityInsertionAdapter = InsertionAdapter(
            database,
            'hsn_codes',
            (HsnEntity item) => <String, Object?>{
                  'id': item.id,
                  'server_id': item.serverId,
                  'hsn_code': item.hsnCode,
                  'sgst': item.sgst,
                  'cgst': item.cgst,
                  'igst': item.igst,
                  'cess': item.cess,
                  'hsn_type': item.hsnType,
                  'tenant': item.tenant,
                  'tenant_id': item.tenantId,
                  'created_at': item.createdAt,
                  'created_by': item.createdBy,
                  'last_modified': item.lastModified,
                  'last_modified_by': item.lastModifiedBy,
                  'deleted': item.deleted,
                  'deleted_by': item.deletedBy,
                  'is_synced': item.isSynced ? 1 : 0,
                  'is_deleted': item.isDeleted ? 1 : 0,
                  'sync_attempts': item.syncAttempts,
                  'last_sync_error': item.lastSyncError
                }),
        _hsnEntityUpdateAdapter = UpdateAdapter(
            database,
            'hsn_codes',
            ['id'],
            (HsnEntity item) => <String, Object?>{
                  'id': item.id,
                  'server_id': item.serverId,
                  'hsn_code': item.hsnCode,
                  'sgst': item.sgst,
                  'cgst': item.cgst,
                  'igst': item.igst,
                  'cess': item.cess,
                  'hsn_type': item.hsnType,
                  'tenant': item.tenant,
                  'tenant_id': item.tenantId,
                  'created_at': item.createdAt,
                  'created_by': item.createdBy,
                  'last_modified': item.lastModified,
                  'last_modified_by': item.lastModifiedBy,
                  'deleted': item.deleted,
                  'deleted_by': item.deletedBy,
                  'is_synced': item.isSynced ? 1 : 0,
                  'is_deleted': item.isDeleted ? 1 : 0,
                  'sync_attempts': item.syncAttempts,
                  'last_sync_error': item.lastSyncError
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<HsnEntity> _hsnEntityInsertionAdapter;

  final UpdateAdapter<HsnEntity> _hsnEntityUpdateAdapter;

  @override
  Future<List<HsnEntity>> getAllHsnCodes() async {
    return _queryAdapter.queryList(
        'SELECT * FROM hsn_codes WHERE is_deleted = 0 ORDER BY created_at DESC',
        mapper: (Map<String, Object?> row) => HsnEntity(
            id: row['id'] as int?,
            serverId: row['server_id'] as int?,
            hsnCode: row['hsn_code'] as String,
            sgst: row['sgst'] as double,
            cgst: row['cgst'] as double,
            igst: row['igst'] as double,
            cess: row['cess'] as double,
            hsnType: row['hsn_type'] as int?,
            tenant: row['tenant'] as String?,
            tenantId: row['tenant_id'] as String?,
            createdAt: row['created_at'] as String,
            createdBy: row['created_by'] as String,
            lastModified: row['last_modified'] as String?,
            lastModifiedBy: row['last_modified_by'] as String?,
            deleted: row['deleted'] as String?,
            deletedBy: row['deleted_by'] as String?,
            isSynced: (row['is_synced'] as int) != 0,
            isDeleted: (row['is_deleted'] as int) != 0,
            syncAttempts: row['sync_attempts'] as int,
            lastSyncError: row['last_sync_error'] as String?));
  }

  @override
  Future<HsnEntity?> getHsnByServerId(int serverId) async {
    return _queryAdapter.query('SELECT * FROM hsn_codes WHERE server_id = ?1',
        mapper: (Map<String, Object?> row) => HsnEntity(
            id: row['id'] as int?,
            serverId: row['server_id'] as int?,
            hsnCode: row['hsn_code'] as String,
            sgst: row['sgst'] as double,
            cgst: row['cgst'] as double,
            igst: row['igst'] as double,
            cess: row['cess'] as double,
            hsnType: row['hsn_type'] as int?,
            tenant: row['tenant'] as String?,
            tenantId: row['tenant_id'] as String?,
            createdAt: row['created_at'] as String,
            createdBy: row['created_by'] as String,
            lastModified: row['last_modified'] as String?,
            lastModifiedBy: row['last_modified_by'] as String?,
            deleted: row['deleted'] as String?,
            deletedBy: row['deleted_by'] as String?,
            isSynced: (row['is_synced'] as int) != 0,
            isDeleted: (row['is_deleted'] as int) != 0,
            syncAttempts: row['sync_attempts'] as int,
            lastSyncError: row['last_sync_error'] as String?),
        arguments: [serverId]);
  }

  @override
  Future<List<HsnEntity>> searchHsnCodes(String query) async {
    return _queryAdapter.queryList(
        'SELECT * FROM hsn_codes WHERE hsn_code LIKE ?1 AND is_deleted = 0',
        mapper: (Map<String, Object?> row) => HsnEntity(
            id: row['id'] as int?,
            serverId: row['server_id'] as int?,
            hsnCode: row['hsn_code'] as String,
            sgst: row['sgst'] as double,
            cgst: row['cgst'] as double,
            igst: row['igst'] as double,
            cess: row['cess'] as double,
            hsnType: row['hsn_type'] as int?,
            tenant: row['tenant'] as String?,
            tenantId: row['tenant_id'] as String?,
            createdAt: row['created_at'] as String,
            createdBy: row['created_by'] as String,
            lastModified: row['last_modified'] as String?,
            lastModifiedBy: row['last_modified_by'] as String?,
            deleted: row['deleted'] as String?,
            deletedBy: row['deleted_by'] as String?,
            isSynced: (row['is_synced'] as int) != 0,
            isDeleted: (row['is_deleted'] as int) != 0,
            syncAttempts: row['sync_attempts'] as int,
            lastSyncError: row['last_sync_error'] as String?),
        arguments: [query]);
  }

  @override
  Future<List<HsnEntity>> getPendingSync() async {
    return _queryAdapter.queryList(
        'SELECT * FROM hsn_codes WHERE is_synced = 0 AND is_deleted = 0',
        mapper: (Map<String, Object?> row) => HsnEntity(
            id: row['id'] as int?,
            serverId: row['server_id'] as int?,
            hsnCode: row['hsn_code'] as String,
            sgst: row['sgst'] as double,
            cgst: row['cgst'] as double,
            igst: row['igst'] as double,
            cess: row['cess'] as double,
            hsnType: row['hsn_type'] as int?,
            tenant: row['tenant'] as String?,
            tenantId: row['tenant_id'] as String?,
            createdAt: row['created_at'] as String,
            createdBy: row['created_by'] as String,
            lastModified: row['last_modified'] as String?,
            lastModifiedBy: row['last_modified_by'] as String?,
            deleted: row['deleted'] as String?,
            deletedBy: row['deleted_by'] as String?,
            isSynced: (row['is_synced'] as int) != 0,
            isDeleted: (row['is_deleted'] as int) != 0,
            syncAttempts: row['sync_attempts'] as int,
            lastSyncError: row['last_sync_error'] as String?));
  }

  @override
  Future<int?> getTotalCount() async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM hsn_codes WHERE is_deleted = 0',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<int?> getSyncedCount() async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM hsn_codes WHERE is_synced = 1 AND is_deleted = 0',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<int?> getPendingCount() async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM hsn_codes WHERE is_synced = 0 AND is_deleted = 0',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<HsnEntity?> getHsnByCode(String hsnCode) async {
    return _queryAdapter.query(
        'SELECT * FROM hsn_codes WHERE hsn_code = ?1 AND is_deleted = 0',
        mapper: (Map<String, Object?> row) => HsnEntity(
            id: row['id'] as int?,
            serverId: row['server_id'] as int?,
            hsnCode: row['hsn_code'] as String,
            sgst: row['sgst'] as double,
            cgst: row['cgst'] as double,
            igst: row['igst'] as double,
            cess: row['cess'] as double,
            hsnType: row['hsn_type'] as int?,
            tenant: row['tenant'] as String?,
            tenantId: row['tenant_id'] as String?,
            createdAt: row['created_at'] as String,
            createdBy: row['created_by'] as String,
            lastModified: row['last_modified'] as String?,
            lastModifiedBy: row['last_modified_by'] as String?,
            deleted: row['deleted'] as String?,
            deletedBy: row['deleted_by'] as String?,
            isSynced: (row['is_synced'] as int) != 0,
            isDeleted: (row['is_deleted'] as int) != 0,
            syncAttempts: row['sync_attempts'] as int,
            lastSyncError: row['last_sync_error'] as String?),
        arguments: [hsnCode]);
  }

  @override
  Future<void> markAsSynced(int id) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE hsn_codes SET is_synced = 1, sync_attempts = 0, last_sync_error = NULL WHERE id = ?1',
        arguments: [id]);
  }

  @override
  Future<void> markAsFailed(
    int id,
    String error,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE hsn_codes SET is_synced = 0, sync_attempts = sync_attempts + 1, last_sync_error = ?2 WHERE id = ?1',
        arguments: [id, error]);
  }

  @override
  Future<void> softDelete(
    int id,
    String timestamp,
    String deletedBy,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE hsn_codes SET is_deleted = 1, deleted = ?2, deleted_by = ?3 WHERE id = ?1',
        arguments: [id, timestamp, deletedBy]);
  }

  @override
  Future<void> updateServerId(
    int localId,
    int serverId,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE hsn_codes SET server_id = ?2 WHERE id = ?1',
        arguments: [localId, serverId]);
  }

  @override
  Future<void> deleteHsn(int id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM hsn_codes WHERE id = ?1', arguments: [id]);
  }

  @override
  Future<void> deleteAll() async {
    await _queryAdapter.queryNoReturn('DELETE FROM hsn_codes');
  }

  @override
  Future<List<int?>> getHsnTypes() async {
    return _queryAdapter.queryList(
        'SELECT DISTINCT hsn_type FROM hsn_codes WHERE is_deleted = 0',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<List<HsnEntity>> getHsnSinceDate(String date) async {
    return _queryAdapter.queryList(
        'SELECT * FROM hsn_codes WHERE created_at >= ?1 AND is_deleted = 0',
        mapper: (Map<String, Object?> row) => HsnEntity(
            id: row['id'] as int?,
            serverId: row['server_id'] as int?,
            hsnCode: row['hsn_code'] as String,
            sgst: row['sgst'] as double,
            cgst: row['cgst'] as double,
            igst: row['igst'] as double,
            cess: row['cess'] as double,
            hsnType: row['hsn_type'] as int?,
            tenant: row['tenant'] as String?,
            tenantId: row['tenant_id'] as String?,
            createdAt: row['created_at'] as String,
            createdBy: row['created_by'] as String,
            lastModified: row['last_modified'] as String?,
            lastModifiedBy: row['last_modified_by'] as String?,
            deleted: row['deleted'] as String?,
            deletedBy: row['deleted_by'] as String?,
            isSynced: (row['is_synced'] as int) != 0,
            isDeleted: (row['is_deleted'] as int) != 0,
            syncAttempts: row['sync_attempts'] as int,
            lastSyncError: row['last_sync_error'] as String?),
        arguments: [date]);
  }

  @override
  Future<int> insertHsn(HsnEntity hsn) {
    return _hsnEntityInsertionAdapter.insertAndReturnId(
        hsn, OnConflictStrategy.abort);
  }

  @override
  Future<List<int>> insertMultipleHsn(List<HsnEntity> hsnList) {
    return _hsnEntityInsertionAdapter.insertListAndReturnIds(
        hsnList, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateHsn(HsnEntity hsn) async {
    await _hsnEntityUpdateAdapter.update(hsn, OnConflictStrategy.replace);
  }
}

class _$StaffDao extends StaffDao {
  _$StaffDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _staffEntityInsertionAdapter = InsertionAdapter(
            database,
            'staff',
            (StaffEntity item) => <String, Object?>{
                  'id': item.id,
                  'server_id': item.serverId,
                  'name': item.name,
                  'department': item.department,
                  'designation': item.designation,
                  'email': item.email,
                  'phone': item.phone,
                  'required_credentials': item.requiredCredentials,
                  'created_at': item.createdAt,
                  'created_by': item.createdBy,
                  'last_modified': item.lastModified,
                  'last_modified_by': item.lastModifiedBy,
                  'is_deleted': item.isDeleted,
                  'deleted_by': item.deletedBy,
                  'is_synced': item.isSynced,
                  'sync_status': item.syncStatus,
                  'sync_attempts': item.syncAttempts,
                  'last_sync_error': item.lastSyncError
                }),
        _staffEntityUpdateAdapter = UpdateAdapter(
            database,
            'staff',
            ['id'],
            (StaffEntity item) => <String, Object?>{
                  'id': item.id,
                  'server_id': item.serverId,
                  'name': item.name,
                  'department': item.department,
                  'designation': item.designation,
                  'email': item.email,
                  'phone': item.phone,
                  'required_credentials': item.requiredCredentials,
                  'created_at': item.createdAt,
                  'created_by': item.createdBy,
                  'last_modified': item.lastModified,
                  'last_modified_by': item.lastModifiedBy,
                  'is_deleted': item.isDeleted,
                  'deleted_by': item.deletedBy,
                  'is_synced': item.isSynced,
                  'sync_status': item.syncStatus,
                  'sync_attempts': item.syncAttempts,
                  'last_sync_error': item.lastSyncError
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<StaffEntity> _staffEntityInsertionAdapter;

  final UpdateAdapter<StaffEntity> _staffEntityUpdateAdapter;

  @override
  Future<List<StaffEntity>> getAllStaff() async {
    return _queryAdapter.queryList('SELECT * FROM staff ORDER BY name ASC',
        mapper: (Map<String, Object?> row) => StaffEntity(
            id: row['id'] as int?,
            serverId: row['server_id'] as int?,
            name: row['name'] as String,
            department: row['department'] as String,
            designation: row['designation'] as String,
            email: row['email'] as String?,
            phone: row['phone'] as String,
            requiredCredentials: row['required_credentials'] as String,
            createdAt: row['created_at'] as String,
            createdBy: row['created_by'] as String?,
            lastModified: row['last_modified'] as String?,
            lastModifiedBy: row['last_modified_by'] as String?,
            isDeleted: row['is_deleted'] as int,
            deletedBy: row['deleted_by'] as String?,
            isSynced: row['is_synced'] as int,
            syncStatus: row['sync_status'] as String?,
            syncAttempts: row['sync_attempts'] as int,
            lastSyncError: row['last_sync_error'] as String?));
  }

  @override
  Future<StaffEntity?> getStaffById(int id) async {
    return _queryAdapter.query('SELECT * FROM staff WHERE id = ?1',
        mapper: (Map<String, Object?> row) => StaffEntity(
            id: row['id'] as int?,
            serverId: row['server_id'] as int?,
            name: row['name'] as String,
            department: row['department'] as String,
            designation: row['designation'] as String,
            email: row['email'] as String?,
            phone: row['phone'] as String,
            requiredCredentials: row['required_credentials'] as String,
            createdAt: row['created_at'] as String,
            createdBy: row['created_by'] as String?,
            lastModified: row['last_modified'] as String?,
            lastModifiedBy: row['last_modified_by'] as String?,
            isDeleted: row['is_deleted'] as int,
            deletedBy: row['deleted_by'] as String?,
            isSynced: row['is_synced'] as int,
            syncStatus: row['sync_status'] as String?,
            syncAttempts: row['sync_attempts'] as int,
            lastSyncError: row['last_sync_error'] as String?),
        arguments: [id]);
  }

  @override
  Future<StaffEntity?> getStaffByServerId(int serverId) async {
    return _queryAdapter.query('SELECT * FROM staff WHERE server_id = ?1',
        mapper: (Map<String, Object?> row) => StaffEntity(
            id: row['id'] as int?,
            serverId: row['server_id'] as int?,
            name: row['name'] as String,
            department: row['department'] as String,
            designation: row['designation'] as String,
            email: row['email'] as String?,
            phone: row['phone'] as String,
            requiredCredentials: row['required_credentials'] as String,
            createdAt: row['created_at'] as String,
            createdBy: row['created_by'] as String?,
            lastModified: row['last_modified'] as String?,
            lastModifiedBy: row['last_modified_by'] as String?,
            isDeleted: row['is_deleted'] as int,
            deletedBy: row['deleted_by'] as String?,
            isSynced: row['is_synced'] as int,
            syncStatus: row['sync_status'] as String?,
            syncAttempts: row['sync_attempts'] as int,
            lastSyncError: row['last_sync_error'] as String?),
        arguments: [serverId]);
  }

  @override
  Future<List<StaffEntity>> getPendingSync() async {
    return _queryAdapter.queryList(
        'SELECT * FROM staff WHERE is_deleted = 0 AND is_synced = 0',
        mapper: (Map<String, Object?> row) => StaffEntity(
            id: row['id'] as int?,
            serverId: row['server_id'] as int?,
            name: row['name'] as String,
            department: row['department'] as String,
            designation: row['designation'] as String,
            email: row['email'] as String?,
            phone: row['phone'] as String,
            requiredCredentials: row['required_credentials'] as String,
            createdAt: row['created_at'] as String,
            createdBy: row['created_by'] as String?,
            lastModified: row['last_modified'] as String?,
            lastModifiedBy: row['last_modified_by'] as String?,
            isDeleted: row['is_deleted'] as int,
            deletedBy: row['deleted_by'] as String?,
            isSynced: row['is_synced'] as int,
            syncStatus: row['sync_status'] as String?,
            syncAttempts: row['sync_attempts'] as int,
            lastSyncError: row['last_sync_error'] as String?));
  }

  @override
  Future<List<StaffEntity>> getPendingDeletions() async {
    return _queryAdapter.queryList(
        'SELECT * FROM staff WHERE is_deleted = 1 AND is_synced = 0',
        mapper: (Map<String, Object?> row) => StaffEntity(
            id: row['id'] as int?,
            serverId: row['server_id'] as int?,
            name: row['name'] as String,
            department: row['department'] as String,
            designation: row['designation'] as String,
            email: row['email'] as String?,
            phone: row['phone'] as String,
            requiredCredentials: row['required_credentials'] as String,
            createdAt: row['created_at'] as String,
            createdBy: row['created_by'] as String?,
            lastModified: row['last_modified'] as String?,
            lastModifiedBy: row['last_modified_by'] as String?,
            isDeleted: row['is_deleted'] as int,
            deletedBy: row['deleted_by'] as String?,
            isSynced: row['is_synced'] as int,
            syncStatus: row['sync_status'] as String?,
            syncAttempts: row['sync_attempts'] as int,
            lastSyncError: row['last_sync_error'] as String?));
  }

  @override
  Future<int?> getTotalCount() async {
    return _queryAdapter.query('SELECT COUNT(*) FROM staff',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<int?> getSyncedCount() async {
    return _queryAdapter.query('SELECT COUNT(*) FROM staff WHERE is_synced = 1',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<int?> getPendingCount() async {
    return _queryAdapter.query('SELECT COUNT(*) FROM staff WHERE is_synced = 0',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<List<StaffEntity>> searchStaff(String query) async {
    return _queryAdapter.queryList(
        'SELECT * FROM staff WHERE name LIKE ?1 OR phone LIKE ?1 OR email LIKE ?1 ORDER BY name ASC',
        mapper: (Map<String, Object?> row) => StaffEntity(id: row['id'] as int?, serverId: row['server_id'] as int?, name: row['name'] as String, department: row['department'] as String, designation: row['designation'] as String, email: row['email'] as String?, phone: row['phone'] as String, requiredCredentials: row['required_credentials'] as String, createdAt: row['created_at'] as String, createdBy: row['created_by'] as String?, lastModified: row['last_modified'] as String?, lastModifiedBy: row['last_modified_by'] as String?, isDeleted: row['is_deleted'] as int, deletedBy: row['deleted_by'] as String?, isSynced: row['is_synced'] as int, syncStatus: row['sync_status'] as String?, syncAttempts: row['sync_attempts'] as int, lastSyncError: row['last_sync_error'] as String?),
        arguments: [query]);
  }

  @override
  Future<List<StaffEntity>> getStaffByDepartment(String department) async {
    return _queryAdapter.queryList(
        'SELECT * FROM staff WHERE department = ?1 ORDER BY name ASC',
        mapper: (Map<String, Object?> row) => StaffEntity(
            id: row['id'] as int?,
            serverId: row['server_id'] as int?,
            name: row['name'] as String,
            department: row['department'] as String,
            designation: row['designation'] as String,
            email: row['email'] as String?,
            phone: row['phone'] as String,
            requiredCredentials: row['required_credentials'] as String,
            createdAt: row['created_at'] as String,
            createdBy: row['created_by'] as String?,
            lastModified: row['last_modified'] as String?,
            lastModifiedBy: row['last_modified_by'] as String?,
            isDeleted: row['is_deleted'] as int,
            deletedBy: row['deleted_by'] as String?,
            isSynced: row['is_synced'] as int,
            syncStatus: row['sync_status'] as String?,
            syncAttempts: row['sync_attempts'] as int,
            lastSyncError: row['last_sync_error'] as String?),
        arguments: [department]);
  }

  @override
  Future<List<String>> getAllDepartments() async {
    return _queryAdapter.queryList(
        'SELECT DISTINCT department FROM staff WHERE department IS NOT NULL AND department != \"\" ORDER BY department ASC',
        mapper: (Map<String, Object?> row) => row.values.first as String);
  }

  @override
  Future<List<String>> getAllDesignations() async {
    return _queryAdapter.queryList(
        'SELECT DISTINCT designation FROM staff WHERE designation IS NOT NULL AND designation != \"\" ORDER BY designation ASC',
        mapper: (Map<String, Object?> row) => row.values.first as String);
  }

  @override
  Future<void> markAsSynced(int id) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE staff SET is_synced = 1, sync_status = \"synced\" WHERE id = ?1',
        arguments: [id]);
  }

  @override
  Future<void> markSyncFailed(
    int id,
    String error,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE staff SET is_synced = 0, sync_status = \"failed\", sync_attempts = sync_attempts + 1, last_sync_error = ?2 WHERE id = ?1',
        arguments: [id, error]);
  }

  @override
  Future<void> deleteStaff(int id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM staff WHERE id = ?1', arguments: [id]);
  }

  @override
  Future<void> softDeleteStaff(
    int id,
    String deletedBy,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE staff SET is_deleted = 1, deleted_by = ?2 WHERE id = ?1',
        arguments: [id, deletedBy]);
  }

  @override
  Future<void> cleanupDeleted() async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM staff WHERE is_deleted = 1 AND is_synced = 1');
  }

  @override
  Future<int> insertStaff(StaffEntity staff) {
    return _staffEntityInsertionAdapter.insertAndReturnId(
        staff, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateStaff(StaffEntity staff) async {
    await _staffEntityUpdateAdapter.update(staff, OnConflictStrategy.abort);
  }
}

class _$BasDao extends BasDao {
  _$BasDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _basEntityInsertionAdapter = InsertionAdapter(
            database,
            'bas_names',
            (BasEntity item) => <String, Object?>{
                  'id': item.id,
                  'server_id': item.serverId,
                  'name': item.name,
                  'created_at': item.createdAt,
                  'created_by': item.createdBy,
                  'last_modified': item.lastModified,
                  'last_modified_by': item.lastModifiedBy,
                  'is_deleted': item.isDeleted,
                  'deleted_by': item.deletedBy,
                  'is_synced': item.isSynced,
                  'sync_status': item.syncStatus,
                  'sync_attempts': item.syncAttempts,
                  'last_sync_error': item.lastSyncError
                }),
        _basEntityUpdateAdapter = UpdateAdapter(
            database,
            'bas_names',
            ['id'],
            (BasEntity item) => <String, Object?>{
                  'id': item.id,
                  'server_id': item.serverId,
                  'name': item.name,
                  'created_at': item.createdAt,
                  'created_by': item.createdBy,
                  'last_modified': item.lastModified,
                  'last_modified_by': item.lastModifiedBy,
                  'is_deleted': item.isDeleted,
                  'deleted_by': item.deletedBy,
                  'is_synced': item.isSynced,
                  'sync_status': item.syncStatus,
                  'sync_attempts': item.syncAttempts,
                  'last_sync_error': item.lastSyncError
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<BasEntity> _basEntityInsertionAdapter;

  final UpdateAdapter<BasEntity> _basEntityUpdateAdapter;

  @override
  Future<List<BasEntity>> getAllBasNames() async {
    return _queryAdapter.queryList('SELECT * FROM bas_names ORDER BY name ASC',
        mapper: (Map<String, Object?> row) => BasEntity(
            id: row['id'] as int?,
            serverId: row['server_id'] as int?,
            name: row['name'] as String,
            createdAt: row['created_at'] as String?,
            createdBy: row['created_by'] as String?,
            lastModified: row['last_modified'] as String?,
            lastModifiedBy: row['last_modified_by'] as String?,
            isDeleted: row['is_deleted'] as int,
            deletedBy: row['deleted_by'] as String?,
            isSynced: row['is_synced'] as int,
            syncStatus: row['sync_status'] as String?,
            syncAttempts: row['sync_attempts'] as int,
            lastSyncError: row['last_sync_error'] as String?));
  }

  @override
  Future<BasEntity?> getBasById(int id) async {
    return _queryAdapter.query('SELECT * FROM bas_names WHERE id = ?1',
        mapper: (Map<String, Object?> row) => BasEntity(
            id: row['id'] as int?,
            serverId: row['server_id'] as int?,
            name: row['name'] as String,
            createdAt: row['created_at'] as String?,
            createdBy: row['created_by'] as String?,
            lastModified: row['last_modified'] as String?,
            lastModifiedBy: row['last_modified_by'] as String?,
            isDeleted: row['is_deleted'] as int,
            deletedBy: row['deleted_by'] as String?,
            isSynced: row['is_synced'] as int,
            syncStatus: row['sync_status'] as String?,
            syncAttempts: row['sync_attempts'] as int,
            lastSyncError: row['last_sync_error'] as String?),
        arguments: [id]);
  }

  @override
  Future<BasEntity?> getBasByServerId(int serverId) async {
    return _queryAdapter.query('SELECT * FROM bas_names WHERE server_id = ?1',
        mapper: (Map<String, Object?> row) => BasEntity(
            id: row['id'] as int?,
            serverId: row['server_id'] as int?,
            name: row['name'] as String,
            createdAt: row['created_at'] as String?,
            createdBy: row['created_by'] as String?,
            lastModified: row['last_modified'] as String?,
            lastModifiedBy: row['last_modified_by'] as String?,
            isDeleted: row['is_deleted'] as int,
            deletedBy: row['deleted_by'] as String?,
            isSynced: row['is_synced'] as int,
            syncStatus: row['sync_status'] as String?,
            syncAttempts: row['sync_attempts'] as int,
            lastSyncError: row['last_sync_error'] as String?),
        arguments: [serverId]);
  }

  @override
  Future<List<BasEntity>> searchBasNames(String search) async {
    return _queryAdapter.queryList(
        'SELECT * FROM bas_names WHERE name LIKE ?1 ORDER BY name ASC',
        mapper: (Map<String, Object?> row) => BasEntity(
            id: row['id'] as int?,
            serverId: row['server_id'] as int?,
            name: row['name'] as String,
            createdAt: row['created_at'] as String?,
            createdBy: row['created_by'] as String?,
            lastModified: row['last_modified'] as String?,
            lastModifiedBy: row['last_modified_by'] as String?,
            isDeleted: row['is_deleted'] as int,
            deletedBy: row['deleted_by'] as String?,
            isSynced: row['is_synced'] as int,
            syncStatus: row['sync_status'] as String?,
            syncAttempts: row['sync_attempts'] as int,
            lastSyncError: row['last_sync_error'] as String?),
        arguments: [search]);
  }

  @override
  Future<int?> getTotalCount() async {
    return _queryAdapter.query('SELECT COUNT(*) FROM bas_names',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<int?> getSyncedCount() async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM bas_names WHERE is_synced = 1',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<int?> getPendingCount() async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM bas_names WHERE is_synced = 0',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<List<BasEntity>> getPendingSync() async {
    return _queryAdapter.queryList(
        'SELECT * FROM bas_names WHERE is_synced = 0 ORDER BY id ASC',
        mapper: (Map<String, Object?> row) => BasEntity(
            id: row['id'] as int?,
            serverId: row['server_id'] as int?,
            name: row['name'] as String,
            createdAt: row['created_at'] as String?,
            createdBy: row['created_by'] as String?,
            lastModified: row['last_modified'] as String?,
            lastModifiedBy: row['last_modified_by'] as String?,
            isDeleted: row['is_deleted'] as int,
            deletedBy: row['deleted_by'] as String?,
            isSynced: row['is_synced'] as int,
            syncStatus: row['sync_status'] as String?,
            syncAttempts: row['sync_attempts'] as int,
            lastSyncError: row['last_sync_error'] as String?));
  }

  @override
  Future<List<BasEntity>> getActiveBasNames() async {
    return _queryAdapter.queryList(
        'SELECT * FROM bas_names WHERE is_deleted = 0 ORDER BY name ASC',
        mapper: (Map<String, Object?> row) => BasEntity(
            id: row['id'] as int?,
            serverId: row['server_id'] as int?,
            name: row['name'] as String,
            createdAt: row['created_at'] as String?,
            createdBy: row['created_by'] as String?,
            lastModified: row['last_modified'] as String?,
            lastModifiedBy: row['last_modified_by'] as String?,
            isDeleted: row['is_deleted'] as int,
            deletedBy: row['deleted_by'] as String?,
            isSynced: row['is_synced'] as int,
            syncStatus: row['sync_status'] as String?,
            syncAttempts: row['sync_attempts'] as int,
            lastSyncError: row['last_sync_error'] as String?));
  }

  @override
  Future<void> markAsSynced(int id) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE bas_names SET is_synced = 1, sync_status = \"synced\" WHERE id = ?1',
        arguments: [id]);
  }

  @override
  Future<void> updateServerId(
    int id,
    int serverId,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE bas_names SET server_id = ?2 WHERE id = ?1',
        arguments: [id, serverId]);
  }

  @override
  Future<void> updateSyncError(
    int id,
    String error,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE bas_names SET sync_attempts = sync_attempts + 1, last_sync_error = ?2 WHERE id = ?1',
        arguments: [id, error]);
  }

  @override
  Future<void> softDeleteBas(
    int id,
    String deletedBy,
    String timestamp,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE bas_names SET is_deleted = 1, deleted_by = ?2, last_modified = ?3 WHERE id = ?1',
        arguments: [id, deletedBy, timestamp]);
  }

  @override
  Future<void> deleteBas(int id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM bas_names WHERE id = ?1', arguments: [id]);
  }

  @override
  Future<void> deleteAllBas() async {
    await _queryAdapter.queryNoReturn('DELETE FROM bas_names');
  }

  @override
  Future<void> insertBas(BasEntity bas) async {
    await _basEntityInsertionAdapter.insert(bas, OnConflictStrategy.replace);
  }

  @override
  Future<List<int>> insertBasList(List<BasEntity> basList) {
    return _basEntityInsertionAdapter.insertListAndReturnIds(
        basList, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateBas(BasEntity bas) async {
    await _basEntityUpdateAdapter.update(bas, OnConflictStrategy.abort);
  }
}

class _$PaymentModeDao extends PaymentModeDao {
  _$PaymentModeDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _paymentModeEntityInsertionAdapter = InsertionAdapter(
            database,
            'payment_modes',
            (PaymentModeEntity item) => <String, Object?>{
                  'id': item.id,
                  'server_id': item.serverId,
                  'name': item.name,
                  'description': item.description,
                  'tenant_id': item.tenantId,
                  'created_at': item.createdAt,
                  'created_by': item.createdBy,
                  'last_modified': item.lastModified,
                  'last_modified_by': item.lastModifiedBy,
                  'is_deleted': item.isDeleted,
                  'deleted_by': item.deletedBy,
                  'is_synced': item.isSynced,
                  'sync_status': item.syncStatus,
                  'sync_attempts': item.syncAttempts,
                  'last_sync_error': item.lastSyncError
                }),
        _paymentModeEntityUpdateAdapter = UpdateAdapter(
            database,
            'payment_modes',
            ['id'],
            (PaymentModeEntity item) => <String, Object?>{
                  'id': item.id,
                  'server_id': item.serverId,
                  'name': item.name,
                  'description': item.description,
                  'tenant_id': item.tenantId,
                  'created_at': item.createdAt,
                  'created_by': item.createdBy,
                  'last_modified': item.lastModified,
                  'last_modified_by': item.lastModifiedBy,
                  'is_deleted': item.isDeleted,
                  'deleted_by': item.deletedBy,
                  'is_synced': item.isSynced,
                  'sync_status': item.syncStatus,
                  'sync_attempts': item.syncAttempts,
                  'last_sync_error': item.lastSyncError
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<PaymentModeEntity> _paymentModeEntityInsertionAdapter;

  final UpdateAdapter<PaymentModeEntity> _paymentModeEntityUpdateAdapter;

  @override
  Future<List<PaymentModeEntity>> getAllPaymentModes() async {
    return _queryAdapter.queryList(
        'SELECT * FROM payment_modes ORDER BY name ASC',
        mapper: (Map<String, Object?> row) => PaymentModeEntity(
            id: row['id'] as int?,
            serverId: row['server_id'] as int?,
            name: row['name'] as String,
            description: row['description'] as String?,
            tenantId: row['tenant_id'] as String?,
            createdAt: row['created_at'] as String?,
            createdBy: row['created_by'] as String?,
            lastModified: row['last_modified'] as String?,
            lastModifiedBy: row['last_modified_by'] as String?,
            isDeleted: row['is_deleted'] as int,
            deletedBy: row['deleted_by'] as String?,
            isSynced: row['is_synced'] as int,
            syncStatus: row['sync_status'] as String?,
            syncAttempts: row['sync_attempts'] as int,
            lastSyncError: row['last_sync_error'] as String?));
  }

  @override
  Future<PaymentModeEntity?> getPaymentModeById(int id) async {
    return _queryAdapter.query('SELECT * FROM payment_modes WHERE id = ?1',
        mapper: (Map<String, Object?> row) => PaymentModeEntity(
            id: row['id'] as int?,
            serverId: row['server_id'] as int?,
            name: row['name'] as String,
            description: row['description'] as String?,
            tenantId: row['tenant_id'] as String?,
            createdAt: row['created_at'] as String?,
            createdBy: row['created_by'] as String?,
            lastModified: row['last_modified'] as String?,
            lastModifiedBy: row['last_modified_by'] as String?,
            isDeleted: row['is_deleted'] as int,
            deletedBy: row['deleted_by'] as String?,
            isSynced: row['is_synced'] as int,
            syncStatus: row['sync_status'] as String?,
            syncAttempts: row['sync_attempts'] as int,
            lastSyncError: row['last_sync_error'] as String?),
        arguments: [id]);
  }

  @override
  Future<PaymentModeEntity?> getPaymentModeByServerId(int serverId) async {
    return _queryAdapter.query(
        'SELECT * FROM payment_modes WHERE server_id = ?1',
        mapper: (Map<String, Object?> row) => PaymentModeEntity(
            id: row['id'] as int?,
            serverId: row['server_id'] as int?,
            name: row['name'] as String,
            description: row['description'] as String?,
            tenantId: row['tenant_id'] as String?,
            createdAt: row['created_at'] as String?,
            createdBy: row['created_by'] as String?,
            lastModified: row['last_modified'] as String?,
            lastModifiedBy: row['last_modified_by'] as String?,
            isDeleted: row['is_deleted'] as int,
            deletedBy: row['deleted_by'] as String?,
            isSynced: row['is_synced'] as int,
            syncStatus: row['sync_status'] as String?,
            syncAttempts: row['sync_attempts'] as int,
            lastSyncError: row['last_sync_error'] as String?),
        arguments: [serverId]);
  }

  @override
  Future<List<PaymentModeEntity>> searchPaymentModes(String search) async {
    return _queryAdapter.queryList(
        'SELECT * FROM payment_modes WHERE name LIKE ?1 ORDER BY name ASC',
        mapper: (Map<String, Object?> row) => PaymentModeEntity(
            id: row['id'] as int?,
            serverId: row['server_id'] as int?,
            name: row['name'] as String,
            description: row['description'] as String?,
            tenantId: row['tenant_id'] as String?,
            createdAt: row['created_at'] as String?,
            createdBy: row['created_by'] as String?,
            lastModified: row['last_modified'] as String?,
            lastModifiedBy: row['last_modified_by'] as String?,
            isDeleted: row['is_deleted'] as int,
            deletedBy: row['deleted_by'] as String?,
            isSynced: row['is_synced'] as int,
            syncStatus: row['sync_status'] as String?,
            syncAttempts: row['sync_attempts'] as int,
            lastSyncError: row['last_sync_error'] as String?),
        arguments: [search]);
  }

  @override
  Future<int?> getTotalCount() async {
    return _queryAdapter.query('SELECT COUNT(*) FROM payment_modes',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<int?> getSyncedCount() async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM payment_modes WHERE is_synced = 1',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<int?> getPendingCount() async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM payment_modes WHERE is_synced = 0',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<List<PaymentModeEntity>> getPendingSync() async {
    return _queryAdapter.queryList(
        'SELECT * FROM payment_modes WHERE is_synced = 0 ORDER BY id ASC',
        mapper: (Map<String, Object?> row) => PaymentModeEntity(
            id: row['id'] as int?,
            serverId: row['server_id'] as int?,
            name: row['name'] as String,
            description: row['description'] as String?,
            tenantId: row['tenant_id'] as String?,
            createdAt: row['created_at'] as String?,
            createdBy: row['created_by'] as String?,
            lastModified: row['last_modified'] as String?,
            lastModifiedBy: row['last_modified_by'] as String?,
            isDeleted: row['is_deleted'] as int,
            deletedBy: row['deleted_by'] as String?,
            isSynced: row['is_synced'] as int,
            syncStatus: row['sync_status'] as String?,
            syncAttempts: row['sync_attempts'] as int,
            lastSyncError: row['last_sync_error'] as String?));
  }

  @override
  Future<List<PaymentModeEntity>> getActivePaymentModes() async {
    return _queryAdapter.queryList(
        'SELECT * FROM payment_modes WHERE is_deleted = 0 ORDER BY name ASC',
        mapper: (Map<String, Object?> row) => PaymentModeEntity(
            id: row['id'] as int?,
            serverId: row['server_id'] as int?,
            name: row['name'] as String,
            description: row['description'] as String?,
            tenantId: row['tenant_id'] as String?,
            createdAt: row['created_at'] as String?,
            createdBy: row['created_by'] as String?,
            lastModified: row['last_modified'] as String?,
            lastModifiedBy: row['last_modified_by'] as String?,
            isDeleted: row['is_deleted'] as int,
            deletedBy: row['deleted_by'] as String?,
            isSynced: row['is_synced'] as int,
            syncStatus: row['sync_status'] as String?,
            syncAttempts: row['sync_attempts'] as int,
            lastSyncError: row['last_sync_error'] as String?));
  }

  @override
  Future<void> markAsSynced(int id) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE payment_modes SET is_synced = 1, sync_status = \"synced\" WHERE id = ?1',
        arguments: [id]);
  }

  @override
  Future<void> updateServerId(
    int id,
    int serverId,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE payment_modes SET server_id = ?2 WHERE id = ?1',
        arguments: [id, serverId]);
  }

  @override
  Future<void> updateSyncError(
    int id,
    String error,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE payment_modes SET sync_attempts = sync_attempts + 1, last_sync_error = ?2 WHERE id = ?1',
        arguments: [id, error]);
  }

  @override
  Future<void> softDeletePaymentMode(
    int id,
    String deletedBy,
    String timestamp,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE payment_modes SET is_deleted = 1, deleted_by = ?2, last_modified = ?3 WHERE id = ?1',
        arguments: [id, deletedBy, timestamp]);
  }

  @override
  Future<void> deletePaymentMode(int id) async {
    await _queryAdapter.queryNoReturn('DELETE FROM payment_modes WHERE id = ?1',
        arguments: [id]);
  }

  @override
  Future<void> deleteAllPaymentModes() async {
    await _queryAdapter.queryNoReturn('DELETE FROM payment_modes');
  }

  @override
  Future<void> insertPaymentMode(PaymentModeEntity paymentMode) async {
    await _paymentModeEntityInsertionAdapter.insert(
        paymentMode, OnConflictStrategy.replace);
  }

  @override
  Future<List<int>> insertPaymentModeList(
      List<PaymentModeEntity> paymentModes) {
    return _paymentModeEntityInsertionAdapter.insertListAndReturnIds(
        paymentModes, OnConflictStrategy.replace);
  }

  @override
  Future<void> updatePaymentMode(PaymentModeEntity paymentMode) async {
    await _paymentModeEntityUpdateAdapter.update(
        paymentMode, OnConflictStrategy.abort);
  }
}

class _$SampleTypeDao extends SampleTypeDao {
  _$SampleTypeDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _sampleTypeEntityInsertionAdapter = InsertionAdapter(
            database,
            'sample_types',
            (SampleTypeEntity item) => <String, Object?>{
                  'id': item.id,
                  'server_id': item.serverId,
                  'name': item.name,
                  'description': item.description,
                  'created_at': item.createdAt,
                  'created_by': item.createdBy,
                  'last_modified': item.lastModified,
                  'last_modified_by': item.lastModifiedBy,
                  'is_deleted': item.isDeleted,
                  'deleted_by': item.deletedBy,
                  'is_synced': item.isSynced,
                  'sync_status': item.syncStatus,
                  'sync_attempts': item.syncAttempts,
                  'last_sync_error': item.lastSyncError
                }),
        _sampleTypeEntityUpdateAdapter = UpdateAdapter(
            database,
            'sample_types',
            ['id'],
            (SampleTypeEntity item) => <String, Object?>{
                  'id': item.id,
                  'server_id': item.serverId,
                  'name': item.name,
                  'description': item.description,
                  'created_at': item.createdAt,
                  'created_by': item.createdBy,
                  'last_modified': item.lastModified,
                  'last_modified_by': item.lastModifiedBy,
                  'is_deleted': item.isDeleted,
                  'deleted_by': item.deletedBy,
                  'is_synced': item.isSynced,
                  'sync_status': item.syncStatus,
                  'sync_attempts': item.syncAttempts,
                  'last_sync_error': item.lastSyncError
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<SampleTypeEntity> _sampleTypeEntityInsertionAdapter;

  final UpdateAdapter<SampleTypeEntity> _sampleTypeEntityUpdateAdapter;

  @override
  Future<List<SampleTypeEntity>> getAllSampleTypes() async {
    return _queryAdapter.queryList(
        'SELECT * FROM sample_types ORDER BY name ASC',
        mapper: (Map<String, Object?> row) => SampleTypeEntity(
            id: row['id'] as int?,
            serverId: row['server_id'] as int?,
            name: row['name'] as String,
            description: row['description'] as String?,
            createdAt: row['created_at'] as String?,
            createdBy: row['created_by'] as String?,
            lastModified: row['last_modified'] as String?,
            lastModifiedBy: row['last_modified_by'] as String?,
            isDeleted: row['is_deleted'] as int,
            deletedBy: row['deleted_by'] as String?,
            isSynced: row['is_synced'] as int,
            syncStatus: row['sync_status'] as String?,
            syncAttempts: row['sync_attempts'] as int,
            lastSyncError: row['last_sync_error'] as String?));
  }

  @override
  Future<SampleTypeEntity?> getSampleTypeById(int id) async {
    return _queryAdapter.query('SELECT * FROM sample_types WHERE id = ?1',
        mapper: (Map<String, Object?> row) => SampleTypeEntity(
            id: row['id'] as int?,
            serverId: row['server_id'] as int?,
            name: row['name'] as String,
            description: row['description'] as String?,
            createdAt: row['created_at'] as String?,
            createdBy: row['created_by'] as String?,
            lastModified: row['last_modified'] as String?,
            lastModifiedBy: row['last_modified_by'] as String?,
            isDeleted: row['is_deleted'] as int,
            deletedBy: row['deleted_by'] as String?,
            isSynced: row['is_synced'] as int,
            syncStatus: row['sync_status'] as String?,
            syncAttempts: row['sync_attempts'] as int,
            lastSyncError: row['last_sync_error'] as String?),
        arguments: [id]);
  }

  @override
  Future<SampleTypeEntity?> getSampleTypeByServerId(int serverId) async {
    return _queryAdapter.query(
        'SELECT * FROM sample_types WHERE server_id = ?1',
        mapper: (Map<String, Object?> row) => SampleTypeEntity(
            id: row['id'] as int?,
            serverId: row['server_id'] as int?,
            name: row['name'] as String,
            description: row['description'] as String?,
            createdAt: row['created_at'] as String?,
            createdBy: row['created_by'] as String?,
            lastModified: row['last_modified'] as String?,
            lastModifiedBy: row['last_modified_by'] as String?,
            isDeleted: row['is_deleted'] as int,
            deletedBy: row['deleted_by'] as String?,
            isSynced: row['is_synced'] as int,
            syncStatus: row['sync_status'] as String?,
            syncAttempts: row['sync_attempts'] as int,
            lastSyncError: row['last_sync_error'] as String?),
        arguments: [serverId]);
  }

  @override
  Future<List<SampleTypeEntity>> searchSampleTypes(String search) async {
    return _queryAdapter.queryList(
        'SELECT * FROM sample_types WHERE name LIKE ?1 ORDER BY name ASC',
        mapper: (Map<String, Object?> row) => SampleTypeEntity(
            id: row['id'] as int?,
            serverId: row['server_id'] as int?,
            name: row['name'] as String,
            description: row['description'] as String?,
            createdAt: row['created_at'] as String?,
            createdBy: row['created_by'] as String?,
            lastModified: row['last_modified'] as String?,
            lastModifiedBy: row['last_modified_by'] as String?,
            isDeleted: row['is_deleted'] as int,
            deletedBy: row['deleted_by'] as String?,
            isSynced: row['is_synced'] as int,
            syncStatus: row['sync_status'] as String?,
            syncAttempts: row['sync_attempts'] as int,
            lastSyncError: row['last_sync_error'] as String?),
        arguments: [search]);
  }

  @override
  Future<int?> getTotalCount() async {
    return _queryAdapter.query('SELECT COUNT(*) FROM sample_types',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<int?> getSyncedCount() async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM sample_types WHERE is_synced = 1',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<int?> getPendingCount() async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM sample_types WHERE is_synced = 0',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<List<SampleTypeEntity>> getPendingSync() async {
    return _queryAdapter.queryList(
        'SELECT * FROM sample_types WHERE is_synced = 0 ORDER BY id ASC',
        mapper: (Map<String, Object?> row) => SampleTypeEntity(
            id: row['id'] as int?,
            serverId: row['server_id'] as int?,
            name: row['name'] as String,
            description: row['description'] as String?,
            createdAt: row['created_at'] as String?,
            createdBy: row['created_by'] as String?,
            lastModified: row['last_modified'] as String?,
            lastModifiedBy: row['last_modified_by'] as String?,
            isDeleted: row['is_deleted'] as int,
            deletedBy: row['deleted_by'] as String?,
            isSynced: row['is_synced'] as int,
            syncStatus: row['sync_status'] as String?,
            syncAttempts: row['sync_attempts'] as int,
            lastSyncError: row['last_sync_error'] as String?));
  }

  @override
  Future<List<SampleTypeEntity>> getActiveSampleTypes() async {
    return _queryAdapter.queryList(
        'SELECT * FROM sample_types WHERE is_deleted = 0 ORDER BY name ASC',
        mapper: (Map<String, Object?> row) => SampleTypeEntity(
            id: row['id'] as int?,
            serverId: row['server_id'] as int?,
            name: row['name'] as String,
            description: row['description'] as String?,
            createdAt: row['created_at'] as String?,
            createdBy: row['created_by'] as String?,
            lastModified: row['last_modified'] as String?,
            lastModifiedBy: row['last_modified_by'] as String?,
            isDeleted: row['is_deleted'] as int,
            deletedBy: row['deleted_by'] as String?,
            isSynced: row['is_synced'] as int,
            syncStatus: row['sync_status'] as String?,
            syncAttempts: row['sync_attempts'] as int,
            lastSyncError: row['last_sync_error'] as String?));
  }

  @override
  Future<void> markAsSynced(int id) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE sample_types SET is_synced = 1, sync_status = \"synced\" WHERE id = ?1',
        arguments: [id]);
  }

  @override
  Future<void> updateServerId(
    int id,
    int serverId,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE sample_types SET server_id = ?2 WHERE id = ?1',
        arguments: [id, serverId]);
  }

  @override
  Future<void> updateSyncError(
    int id,
    String error,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE sample_types SET sync_attempts = sync_attempts + 1, last_sync_error = ?2 WHERE id = ?1',
        arguments: [id, error]);
  }

  @override
  Future<void> softDeleteSampleType(
    int id,
    String deletedBy,
    String timestamp,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE sample_types SET is_deleted = 1, deleted_by = ?2, last_modified = ?3 WHERE id = ?1',
        arguments: [id, deletedBy, timestamp]);
  }

  @override
  Future<void> deleteSampleType(int id) async {
    await _queryAdapter.queryNoReturn('DELETE FROM sample_types WHERE id = ?1',
        arguments: [id]);
  }

  @override
  Future<void> deleteAllSampleTypes() async {
    await _queryAdapter.queryNoReturn('DELETE FROM sample_types');
  }

  @override
  Future<void> insertSampleType(SampleTypeEntity sampleType) async {
    await _sampleTypeEntityInsertionAdapter.insert(
        sampleType, OnConflictStrategy.replace);
  }

  @override
  Future<List<int>> insertSampleTypeList(List<SampleTypeEntity> sampleTypes) {
    return _sampleTypeEntityInsertionAdapter.insertListAndReturnIds(
        sampleTypes, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateSampleType(SampleTypeEntity sampleType) async {
    await _sampleTypeEntityUpdateAdapter.update(
        sampleType, OnConflictStrategy.abort);
  }
}

class _$BranchTypeDao extends BranchTypeDao {
  _$BranchTypeDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _branchTypeEntityInsertionAdapter = InsertionAdapter(
            database,
            'branch_types',
            (BranchTypeEntity item) => <String, Object?>{
                  'id': item.id,
                  'server_id': item.serverId,
                  'company_name': item.companyName,
                  'contact_person': item.contactPerson,
                  'contact_no': item.contactNo,
                  'email': item.email,
                  'address1': item.address1,
                  'location': item.location,
                  'type': item.type,
                  'designation': item.designation,
                  'mobile_no': item.mobileNo,
                  'address2': item.address2,
                  'country': item.country,
                  'state': item.state,
                  'city': item.city,
                  'created_at': item.createdAt,
                  'created_by': item.createdBy,
                  'last_modified': item.lastModified,
                  'last_modified_by': item.lastModifiedBy,
                  'is_deleted': item.isDeleted,
                  'deleted_by': item.deletedBy,
                  'is_synced': item.isSynced,
                  'sync_status': item.syncStatus,
                  'sync_attempts': item.syncAttempts,
                  'last_sync_error': item.lastSyncError
                }),
        _branchTypeEntityUpdateAdapter = UpdateAdapter(
            database,
            'branch_types',
            ['id'],
            (BranchTypeEntity item) => <String, Object?>{
                  'id': item.id,
                  'server_id': item.serverId,
                  'company_name': item.companyName,
                  'contact_person': item.contactPerson,
                  'contact_no': item.contactNo,
                  'email': item.email,
                  'address1': item.address1,
                  'location': item.location,
                  'type': item.type,
                  'designation': item.designation,
                  'mobile_no': item.mobileNo,
                  'address2': item.address2,
                  'country': item.country,
                  'state': item.state,
                  'city': item.city,
                  'created_at': item.createdAt,
                  'created_by': item.createdBy,
                  'last_modified': item.lastModified,
                  'last_modified_by': item.lastModifiedBy,
                  'is_deleted': item.isDeleted,
                  'deleted_by': item.deletedBy,
                  'is_synced': item.isSynced,
                  'sync_status': item.syncStatus,
                  'sync_attempts': item.syncAttempts,
                  'last_sync_error': item.lastSyncError
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<BranchTypeEntity> _branchTypeEntityInsertionAdapter;

  final UpdateAdapter<BranchTypeEntity> _branchTypeEntityUpdateAdapter;

  @override
  Future<List<BranchTypeEntity>> getAllBranchTypes() async {
    return _queryAdapter.queryList(
        'SELECT * FROM branch_types WHERE is_deleted = 0 ORDER BY company_name',
        mapper: (Map<String, Object?> row) => BranchTypeEntity(
            id: row['id'] as int?,
            serverId: row['server_id'] as int?,
            companyName: row['company_name'] as String,
            contactPerson: row['contact_person'] as String,
            contactNo: row['contact_no'] as String,
            email: row['email'] as String,
            address1: row['address1'] as String,
            location: row['location'] as String,
            type: row['type'] as String,
            designation: row['designation'] as String,
            mobileNo: row['mobile_no'] as String,
            address2: row['address2'] as String,
            country: row['country'] as String,
            state: row['state'] as String,
            city: row['city'] as String,
            createdAt: row['created_at'] as String?,
            createdBy: row['created_by'] as String?,
            lastModified: row['last_modified'] as String?,
            lastModifiedBy: row['last_modified_by'] as String?,
            isDeleted: row['is_deleted'] as int,
            deletedBy: row['deleted_by'] as String?,
            isSynced: row['is_synced'] as int,
            syncStatus: row['sync_status'] as String,
            syncAttempts: row['sync_attempts'] as int,
            lastSyncError: row['last_sync_error'] as String?));
  }

  @override
  Future<BranchTypeEntity?> getBranchTypeById(int id) async {
    return _queryAdapter.query('SELECT * FROM branch_types WHERE id = ?1',
        mapper: (Map<String, Object?> row) => BranchTypeEntity(
            id: row['id'] as int?,
            serverId: row['server_id'] as int?,
            companyName: row['company_name'] as String,
            contactPerson: row['contact_person'] as String,
            contactNo: row['contact_no'] as String,
            email: row['email'] as String,
            address1: row['address1'] as String,
            location: row['location'] as String,
            type: row['type'] as String,
            designation: row['designation'] as String,
            mobileNo: row['mobile_no'] as String,
            address2: row['address2'] as String,
            country: row['country'] as String,
            state: row['state'] as String,
            city: row['city'] as String,
            createdAt: row['created_at'] as String?,
            createdBy: row['created_by'] as String?,
            lastModified: row['last_modified'] as String?,
            lastModifiedBy: row['last_modified_by'] as String?,
            isDeleted: row['is_deleted'] as int,
            deletedBy: row['deleted_by'] as String?,
            isSynced: row['is_synced'] as int,
            syncStatus: row['sync_status'] as String,
            syncAttempts: row['sync_attempts'] as int,
            lastSyncError: row['last_sync_error'] as String?),
        arguments: [id]);
  }

  @override
  Future<BranchTypeEntity?> getBranchTypeByServerId(int serverId) async {
    return _queryAdapter.query(
        'SELECT * FROM branch_types WHERE server_id = ?1',
        mapper: (Map<String, Object?> row) => BranchTypeEntity(
            id: row['id'] as int?,
            serverId: row['server_id'] as int?,
            companyName: row['company_name'] as String,
            contactPerson: row['contact_person'] as String,
            contactNo: row['contact_no'] as String,
            email: row['email'] as String,
            address1: row['address1'] as String,
            location: row['location'] as String,
            type: row['type'] as String,
            designation: row['designation'] as String,
            mobileNo: row['mobile_no'] as String,
            address2: row['address2'] as String,
            country: row['country'] as String,
            state: row['state'] as String,
            city: row['city'] as String,
            createdAt: row['created_at'] as String?,
            createdBy: row['created_by'] as String?,
            lastModified: row['last_modified'] as String?,
            lastModifiedBy: row['last_modified_by'] as String?,
            isDeleted: row['is_deleted'] as int,
            deletedBy: row['deleted_by'] as String?,
            isSynced: row['is_synced'] as int,
            syncStatus: row['sync_status'] as String,
            syncAttempts: row['sync_attempts'] as int,
            lastSyncError: row['last_sync_error'] as String?),
        arguments: [serverId]);
  }

  @override
  Future<List<BranchTypeEntity>> getPendingSync() async {
    return _queryAdapter.queryList(
        'SELECT * FROM branch_types WHERE is_synced = 0 AND is_deleted = 0',
        mapper: (Map<String, Object?> row) => BranchTypeEntity(
            id: row['id'] as int?,
            serverId: row['server_id'] as int?,
            companyName: row['company_name'] as String,
            contactPerson: row['contact_person'] as String,
            contactNo: row['contact_no'] as String,
            email: row['email'] as String,
            address1: row['address1'] as String,
            location: row['location'] as String,
            type: row['type'] as String,
            designation: row['designation'] as String,
            mobileNo: row['mobile_no'] as String,
            address2: row['address2'] as String,
            country: row['country'] as String,
            state: row['state'] as String,
            city: row['city'] as String,
            createdAt: row['created_at'] as String?,
            createdBy: row['created_by'] as String?,
            lastModified: row['last_modified'] as String?,
            lastModifiedBy: row['last_modified_by'] as String?,
            isDeleted: row['is_deleted'] as int,
            deletedBy: row['deleted_by'] as String?,
            isSynced: row['is_synced'] as int,
            syncStatus: row['sync_status'] as String,
            syncAttempts: row['sync_attempts'] as int,
            lastSyncError: row['last_sync_error'] as String?));
  }

  @override
  Future<int?> getTotalCount() async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM branch_types WHERE is_deleted = 0',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<int?> getSyncedCount() async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM branch_types WHERE is_synced = 1 AND is_deleted = 0',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<int?> getPendingCount() async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM branch_types WHERE is_synced = 0 AND is_deleted = 0',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<List<BranchTypeEntity>> searchBranchTypes(String query) async {
    return _queryAdapter.queryList(
        'SELECT * FROM branch_types      WHERE is_deleted = 0      AND (       company_name LIKE ?1 OR       contact_person LIKE ?1 OR       contact_no LIKE ?1 OR       email LIKE ?1 OR       location LIKE ?1     )     ORDER BY company_name',
        mapper: (Map<String, Object?> row) => BranchTypeEntity(id: row['id'] as int?, serverId: row['server_id'] as int?, companyName: row['company_name'] as String, contactPerson: row['contact_person'] as String, contactNo: row['contact_no'] as String, email: row['email'] as String, address1: row['address1'] as String, location: row['location'] as String, type: row['type'] as String, designation: row['designation'] as String, mobileNo: row['mobile_no'] as String, address2: row['address2'] as String, country: row['country'] as String, state: row['state'] as String, city: row['city'] as String, createdAt: row['created_at'] as String?, createdBy: row['created_by'] as String?, lastModified: row['last_modified'] as String?, lastModifiedBy: row['last_modified_by'] as String?, isDeleted: row['is_deleted'] as int, deletedBy: row['deleted_by'] as String?, isSynced: row['is_synced'] as int, syncStatus: row['sync_status'] as String, syncAttempts: row['sync_attempts'] as int, lastSyncError: row['last_sync_error'] as String?),
        arguments: [query]);
  }

  @override
  Future<void> deleteBranchType(int id) async {
    await _queryAdapter.queryNoReturn('DELETE FROM branch_types WHERE id = ?1',
        arguments: [id]);
  }

  @override
  Future<void> softDeleteBranchType(
    int id,
    String deletedBy,
    String lastModified,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE branch_types      SET is_deleted = 1,          deleted_by = ?2,         last_modified = ?3,         is_synced = 0,         sync_status = \'pending\'     WHERE id = ?1',
        arguments: [id, deletedBy, lastModified]);
  }

  @override
  Future<void> markAsSynced(int id) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE branch_types SET is_synced = 1, sync_status = \"synced\" WHERE id = ?1',
        arguments: [id]);
  }

  @override
  Future<void> updateServerId(
    int id,
    int serverId,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE branch_types SET server_id = ?2 WHERE id = ?1',
        arguments: [id, serverId]);
  }

  @override
  Future<void> updateSyncError(
    int id,
    String error,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE branch_types SET last_sync_error = ?2 WHERE id = ?1',
        arguments: [id, error]);
  }

  @override
  Future<void> incrementSyncAttempts(int id) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE branch_types SET sync_attempts = sync_attempts + 1 WHERE id = ?1',
        arguments: [id]);
  }

  @override
  Future<List<int>> insertBranchTypeList(List<BranchTypeEntity> branchTypes) {
    return _branchTypeEntityInsertionAdapter.insertListAndReturnIds(
        branchTypes, OnConflictStrategy.replace);
  }

  @override
  Future<int> insertBranchType(BranchTypeEntity branchType) {
    return _branchTypeEntityInsertionAdapter.insertAndReturnId(
        branchType, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateBranchType(BranchTypeEntity branchType) async {
    await _branchTypeEntityUpdateAdapter.update(
        branchType, OnConflictStrategy.abort);
  }
}

class _$CollectionCenterDao extends CollectionCenterDao {
  _$CollectionCenterDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _collectionCenterEntityInsertionAdapter = InsertionAdapter(
            database,
            'collection_centers',
            (CollectionCenterEntity item) => <String, Object?>{
                  'id': item.id,
                  'server_id': item.serverId,
                  'center_code': item.centerCode,
                  'center_name': item.centerName,
                  'country': item.country,
                  'state': item.state,
                  'city': item.city,
                  'address1': item.address1,
                  'address2': item.address2,
                  'location': item.location,
                  'postal_code': item.postalCode,
                  'latitude': item.latitude,
                  'longitude': item.longitude,
                  'gst_number': item.gstNumber,
                  'pan_number': item.panNumber,
                  'contact_person_name': item.contactPersonName,
                  'phone_no': item.phoneNo,
                  'email': item.email,
                  'centre_status': item.centreStatus,
                  'branch_type_id': item.branchTypeId,
                  'lab_affiliation_company': item.labAffiliationCompany,
                  'operational_hours_from': item.operationalHoursFrom,
                  'operational_hours_to': item.operationalHoursTo,
                  'collection_days': item.collectionDays,
                  'sample_pickup_timing_from': item.samplePickupTimingFrom,
                  'sample_pickup_timing_to': item.samplePickupTimingTo,
                  'transport_mode': item.transportMode,
                  'courier_agency_name': item.courierAgencyName,
                  'commission_type': item.commissionType,
                  'commission_value': item.commissionValue,
                  'account_holder_name': item.accountHolderName,
                  'account_no': item.accountNo,
                  'ifsc_code': item.ifscCode,
                  'agreement_file1_path': item.agreementFile1Path,
                  'agreement_file2_path': item.agreementFile2Path,
                  'created_at': item.createdAt,
                  'created_by': item.createdBy,
                  'last_modified': item.lastModified,
                  'last_modified_by': item.lastModifiedBy,
                  'is_deleted': item.isDeleted,
                  'deleted_by': item.deletedBy,
                  'is_synced': item.isSynced,
                  'sync_status': item.syncStatus,
                  'sync_attempts': item.syncAttempts,
                  'last_sync_error': item.lastSyncError
                }),
        _collectionCenterEntityUpdateAdapter = UpdateAdapter(
            database,
            'collection_centers',
            ['id'],
            (CollectionCenterEntity item) => <String, Object?>{
                  'id': item.id,
                  'server_id': item.serverId,
                  'center_code': item.centerCode,
                  'center_name': item.centerName,
                  'country': item.country,
                  'state': item.state,
                  'city': item.city,
                  'address1': item.address1,
                  'address2': item.address2,
                  'location': item.location,
                  'postal_code': item.postalCode,
                  'latitude': item.latitude,
                  'longitude': item.longitude,
                  'gst_number': item.gstNumber,
                  'pan_number': item.panNumber,
                  'contact_person_name': item.contactPersonName,
                  'phone_no': item.phoneNo,
                  'email': item.email,
                  'centre_status': item.centreStatus,
                  'branch_type_id': item.branchTypeId,
                  'lab_affiliation_company': item.labAffiliationCompany,
                  'operational_hours_from': item.operationalHoursFrom,
                  'operational_hours_to': item.operationalHoursTo,
                  'collection_days': item.collectionDays,
                  'sample_pickup_timing_from': item.samplePickupTimingFrom,
                  'sample_pickup_timing_to': item.samplePickupTimingTo,
                  'transport_mode': item.transportMode,
                  'courier_agency_name': item.courierAgencyName,
                  'commission_type': item.commissionType,
                  'commission_value': item.commissionValue,
                  'account_holder_name': item.accountHolderName,
                  'account_no': item.accountNo,
                  'ifsc_code': item.ifscCode,
                  'agreement_file1_path': item.agreementFile1Path,
                  'agreement_file2_path': item.agreementFile2Path,
                  'created_at': item.createdAt,
                  'created_by': item.createdBy,
                  'last_modified': item.lastModified,
                  'last_modified_by': item.lastModifiedBy,
                  'is_deleted': item.isDeleted,
                  'deleted_by': item.deletedBy,
                  'is_synced': item.isSynced,
                  'sync_status': item.syncStatus,
                  'sync_attempts': item.syncAttempts,
                  'last_sync_error': item.lastSyncError
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<CollectionCenterEntity>
      _collectionCenterEntityInsertionAdapter;

  final UpdateAdapter<CollectionCenterEntity>
      _collectionCenterEntityUpdateAdapter;

  @override
  Future<List<CollectionCenterEntity>> getAllCollectionCenters() async {
    return _queryAdapter.queryList(
        'SELECT * FROM collection_centers WHERE is_deleted = 0 ORDER BY center_name',
        mapper: (Map<String, Object?> row) => CollectionCenterEntity(
            id: row['id'] as int?,
            serverId: row['server_id'] as int?,
            centerCode: row['center_code'] as String,
            centerName: row['center_name'] as String,
            country: row['country'] as String,
            state: row['state'] as String,
            city: row['city'] as String,
            address1: row['address1'] as String,
            address2: row['address2'] as String,
            location: row['location'] as String,
            postalCode: row['postal_code'] as String,
            latitude: row['latitude'] as double,
            longitude: row['longitude'] as double,
            gstNumber: row['gst_number'] as String,
            panNumber: row['pan_number'] as String,
            contactPersonName: row['contact_person_name'] as String,
            phoneNo: row['phone_no'] as String,
            email: row['email'] as String,
            centreStatus: row['centre_status'] as String,
            branchTypeId: row['branch_type_id'] as int?,
            labAffiliationCompany: row['lab_affiliation_company'] as String,
            operationalHoursFrom: row['operational_hours_from'] as String,
            operationalHoursTo: row['operational_hours_to'] as String,
            collectionDays: row['collection_days'] as String,
            samplePickupTimingFrom: row['sample_pickup_timing_from'] as String,
            samplePickupTimingTo: row['sample_pickup_timing_to'] as String,
            transportMode: row['transport_mode'] as String,
            courierAgencyName: row['courier_agency_name'] as String,
            commissionType: row['commission_type'] as String,
            commissionValue: row['commission_value'] as double,
            accountHolderName: row['account_holder_name'] as String,
            accountNo: row['account_no'] as String,
            ifscCode: row['ifsc_code'] as String,
            agreementFile1Path: row['agreement_file1_path'] as String?,
            agreementFile2Path: row['agreement_file2_path'] as String?,
            createdAt: row['created_at'] as String?,
            createdBy: row['created_by'] as String?,
            lastModified: row['last_modified'] as String?,
            lastModifiedBy: row['last_modified_by'] as String?,
            isDeleted: row['is_deleted'] as int,
            deletedBy: row['deleted_by'] as String?,
            isSynced: row['is_synced'] as int,
            syncStatus: row['sync_status'] as String,
            syncAttempts: row['sync_attempts'] as int,
            lastSyncError: row['last_sync_error'] as String?));
  }

  @override
  Future<CollectionCenterEntity?> getCollectionCenterById(int id) async {
    return _queryAdapter.query('SELECT * FROM collection_centers WHERE id = ?1',
        mapper: (Map<String, Object?> row) => CollectionCenterEntity(
            id: row['id'] as int?,
            serverId: row['server_id'] as int?,
            centerCode: row['center_code'] as String,
            centerName: row['center_name'] as String,
            country: row['country'] as String,
            state: row['state'] as String,
            city: row['city'] as String,
            address1: row['address1'] as String,
            address2: row['address2'] as String,
            location: row['location'] as String,
            postalCode: row['postal_code'] as String,
            latitude: row['latitude'] as double,
            longitude: row['longitude'] as double,
            gstNumber: row['gst_number'] as String,
            panNumber: row['pan_number'] as String,
            contactPersonName: row['contact_person_name'] as String,
            phoneNo: row['phone_no'] as String,
            email: row['email'] as String,
            centreStatus: row['centre_status'] as String,
            branchTypeId: row['branch_type_id'] as int?,
            labAffiliationCompany: row['lab_affiliation_company'] as String,
            operationalHoursFrom: row['operational_hours_from'] as String,
            operationalHoursTo: row['operational_hours_to'] as String,
            collectionDays: row['collection_days'] as String,
            samplePickupTimingFrom: row['sample_pickup_timing_from'] as String,
            samplePickupTimingTo: row['sample_pickup_timing_to'] as String,
            transportMode: row['transport_mode'] as String,
            courierAgencyName: row['courier_agency_name'] as String,
            commissionType: row['commission_type'] as String,
            commissionValue: row['commission_value'] as double,
            accountHolderName: row['account_holder_name'] as String,
            accountNo: row['account_no'] as String,
            ifscCode: row['ifsc_code'] as String,
            agreementFile1Path: row['agreement_file1_path'] as String?,
            agreementFile2Path: row['agreement_file2_path'] as String?,
            createdAt: row['created_at'] as String?,
            createdBy: row['created_by'] as String?,
            lastModified: row['last_modified'] as String?,
            lastModifiedBy: row['last_modified_by'] as String?,
            isDeleted: row['is_deleted'] as int,
            deletedBy: row['deleted_by'] as String?,
            isSynced: row['is_synced'] as int,
            syncStatus: row['sync_status'] as String,
            syncAttempts: row['sync_attempts'] as int,
            lastSyncError: row['last_sync_error'] as String?),
        arguments: [id]);
  }

  @override
  Future<CollectionCenterEntity?> getCollectionCenterByServerId(
      int serverId) async {
    return _queryAdapter.query(
        'SELECT * FROM collection_centers WHERE server_id = ?1',
        mapper: (Map<String, Object?> row) => CollectionCenterEntity(
            id: row['id'] as int?,
            serverId: row['server_id'] as int?,
            centerCode: row['center_code'] as String,
            centerName: row['center_name'] as String,
            country: row['country'] as String,
            state: row['state'] as String,
            city: row['city'] as String,
            address1: row['address1'] as String,
            address2: row['address2'] as String,
            location: row['location'] as String,
            postalCode: row['postal_code'] as String,
            latitude: row['latitude'] as double,
            longitude: row['longitude'] as double,
            gstNumber: row['gst_number'] as String,
            panNumber: row['pan_number'] as String,
            contactPersonName: row['contact_person_name'] as String,
            phoneNo: row['phone_no'] as String,
            email: row['email'] as String,
            centreStatus: row['centre_status'] as String,
            branchTypeId: row['branch_type_id'] as int?,
            labAffiliationCompany: row['lab_affiliation_company'] as String,
            operationalHoursFrom: row['operational_hours_from'] as String,
            operationalHoursTo: row['operational_hours_to'] as String,
            collectionDays: row['collection_days'] as String,
            samplePickupTimingFrom: row['sample_pickup_timing_from'] as String,
            samplePickupTimingTo: row['sample_pickup_timing_to'] as String,
            transportMode: row['transport_mode'] as String,
            courierAgencyName: row['courier_agency_name'] as String,
            commissionType: row['commission_type'] as String,
            commissionValue: row['commission_value'] as double,
            accountHolderName: row['account_holder_name'] as String,
            accountNo: row['account_no'] as String,
            ifscCode: row['ifsc_code'] as String,
            agreementFile1Path: row['agreement_file1_path'] as String?,
            agreementFile2Path: row['agreement_file2_path'] as String?,
            createdAt: row['created_at'] as String?,
            createdBy: row['created_by'] as String?,
            lastModified: row['last_modified'] as String?,
            lastModifiedBy: row['last_modified_by'] as String?,
            isDeleted: row['is_deleted'] as int,
            deletedBy: row['deleted_by'] as String?,
            isSynced: row['is_synced'] as int,
            syncStatus: row['sync_status'] as String,
            syncAttempts: row['sync_attempts'] as int,
            lastSyncError: row['last_sync_error'] as String?),
        arguments: [serverId]);
  }

  @override
  Future<List<CollectionCenterEntity>> getPendingSync() async {
    return _queryAdapter.queryList(
        'SELECT * FROM collection_centers WHERE is_synced = 0 AND is_deleted = 0',
        mapper: (Map<String, Object?> row) => CollectionCenterEntity(
            id: row['id'] as int?,
            serverId: row['server_id'] as int?,
            centerCode: row['center_code'] as String,
            centerName: row['center_name'] as String,
            country: row['country'] as String,
            state: row['state'] as String,
            city: row['city'] as String,
            address1: row['address1'] as String,
            address2: row['address2'] as String,
            location: row['location'] as String,
            postalCode: row['postal_code'] as String,
            latitude: row['latitude'] as double,
            longitude: row['longitude'] as double,
            gstNumber: row['gst_number'] as String,
            panNumber: row['pan_number'] as String,
            contactPersonName: row['contact_person_name'] as String,
            phoneNo: row['phone_no'] as String,
            email: row['email'] as String,
            centreStatus: row['centre_status'] as String,
            branchTypeId: row['branch_type_id'] as int?,
            labAffiliationCompany: row['lab_affiliation_company'] as String,
            operationalHoursFrom: row['operational_hours_from'] as String,
            operationalHoursTo: row['operational_hours_to'] as String,
            collectionDays: row['collection_days'] as String,
            samplePickupTimingFrom: row['sample_pickup_timing_from'] as String,
            samplePickupTimingTo: row['sample_pickup_timing_to'] as String,
            transportMode: row['transport_mode'] as String,
            courierAgencyName: row['courier_agency_name'] as String,
            commissionType: row['commission_type'] as String,
            commissionValue: row['commission_value'] as double,
            accountHolderName: row['account_holder_name'] as String,
            accountNo: row['account_no'] as String,
            ifscCode: row['ifsc_code'] as String,
            agreementFile1Path: row['agreement_file1_path'] as String?,
            agreementFile2Path: row['agreement_file2_path'] as String?,
            createdAt: row['created_at'] as String?,
            createdBy: row['created_by'] as String?,
            lastModified: row['last_modified'] as String?,
            lastModifiedBy: row['last_modified_by'] as String?,
            isDeleted: row['is_deleted'] as int,
            deletedBy: row['deleted_by'] as String?,
            isSynced: row['is_synced'] as int,
            syncStatus: row['sync_status'] as String,
            syncAttempts: row['sync_attempts'] as int,
            lastSyncError: row['last_sync_error'] as String?));
  }

  @override
  Future<int?> getTotalCount() async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM collection_centers WHERE is_deleted = 0',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<int?> getSyncedCount() async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM collection_centers WHERE is_synced = 1 AND is_deleted = 0',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<int?> getPendingCount() async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM collection_centers WHERE is_synced = 0 AND is_deleted = 0',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<List<CollectionCenterEntity>> searchCollectionCenters(
      String query) async {
    return _queryAdapter.queryList(
        'SELECT * FROM collection_centers      WHERE is_deleted = 0      AND (       center_code LIKE ?1 OR       center_name LIKE ?1 OR       contact_person_name LIKE ?1 OR       phone_no LIKE ?1 OR       email LIKE ?1 OR       location LIKE ?1     )     ORDER BY center_name',
        mapper: (Map<String, Object?> row) => CollectionCenterEntity(id: row['id'] as int?, serverId: row['server_id'] as int?, centerCode: row['center_code'] as String, centerName: row['center_name'] as String, country: row['country'] as String, state: row['state'] as String, city: row['city'] as String, address1: row['address1'] as String, address2: row['address2'] as String, location: row['location'] as String, postalCode: row['postal_code'] as String, latitude: row['latitude'] as double, longitude: row['longitude'] as double, gstNumber: row['gst_number'] as String, panNumber: row['pan_number'] as String, contactPersonName: row['contact_person_name'] as String, phoneNo: row['phone_no'] as String, email: row['email'] as String, centreStatus: row['centre_status'] as String, branchTypeId: row['branch_type_id'] as int?, labAffiliationCompany: row['lab_affiliation_company'] as String, operationalHoursFrom: row['operational_hours_from'] as String, operationalHoursTo: row['operational_hours_to'] as String, collectionDays: row['collection_days'] as String, samplePickupTimingFrom: row['sample_pickup_timing_from'] as String, samplePickupTimingTo: row['sample_pickup_timing_to'] as String, transportMode: row['transport_mode'] as String, courierAgencyName: row['courier_agency_name'] as String, commissionType: row['commission_type'] as String, commissionValue: row['commission_value'] as double, accountHolderName: row['account_holder_name'] as String, accountNo: row['account_no'] as String, ifscCode: row['ifsc_code'] as String, agreementFile1Path: row['agreement_file1_path'] as String?, agreementFile2Path: row['agreement_file2_path'] as String?, createdAt: row['created_at'] as String?, createdBy: row['created_by'] as String?, lastModified: row['last_modified'] as String?, lastModifiedBy: row['last_modified_by'] as String?, isDeleted: row['is_deleted'] as int, deletedBy: row['deleted_by'] as String?, isSynced: row['is_synced'] as int, syncStatus: row['sync_status'] as String, syncAttempts: row['sync_attempts'] as int, lastSyncError: row['last_sync_error'] as String?),
        arguments: [query]);
  }

  @override
  Future<void> deleteCollectionCenter(int id) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM collection_centers WHERE id = ?1',
        arguments: [id]);
  }

  @override
  Future<void> softDeleteCollectionCenter(
    int id,
    String deletedBy,
    String lastModified,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE collection_centers      SET is_deleted = 1,          deleted_by = ?2,         last_modified = ?3,         is_synced = 0,         sync_status = \'pending\'     WHERE id = ?1',
        arguments: [id, deletedBy, lastModified]);
  }

  @override
  Future<void> markAsSynced(int id) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE collection_centers SET is_synced = 1, sync_status = \"synced\" WHERE id = ?1',
        arguments: [id]);
  }

  @override
  Future<void> updateServerId(
    int id,
    int serverId,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE collection_centers SET server_id = ?2 WHERE id = ?1',
        arguments: [id, serverId]);
  }

  @override
  Future<void> updateSyncError(
    int id,
    String error,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE collection_centers SET last_sync_error = ?2 WHERE id = ?1',
        arguments: [id, error]);
  }

  @override
  Future<void> incrementSyncAttempts(int id) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE collection_centers SET sync_attempts = sync_attempts + 1 WHERE id = ?1',
        arguments: [id]);
  }

  @override
  Future<List<String>> getDistinctCountries() async {
    return _queryAdapter.queryList(
        'SELECT DISTINCT country FROM collection_centers WHERE is_deleted = 0 AND country IS NOT NULL AND country != \"\"',
        mapper: (Map<String, Object?> row) => row.values.first as String);
  }

  @override
  Future<List<String>> getDistinctStates() async {
    return _queryAdapter.queryList(
        'SELECT DISTINCT state FROM collection_centers WHERE is_deleted = 0 AND state IS NOT NULL AND state != \"\"',
        mapper: (Map<String, Object?> row) => row.values.first as String);
  }

  @override
  Future<List<String>> getDistinctCities() async {
    return _queryAdapter.queryList(
        'SELECT DISTINCT city FROM collection_centers WHERE is_deleted = 0 AND city IS NOT NULL AND city != \"\"',
        mapper: (Map<String, Object?> row) => row.values.first as String);
  }

  @override
  Future<List<String>> getDistinctCentreStatus() async {
    return _queryAdapter.queryList(
        'SELECT DISTINCT centre_status FROM collection_centers WHERE is_deleted = 0 AND centre_status IS NOT NULL AND centre_status != \"\"',
        mapper: (Map<String, Object?> row) => row.values.first as String);
  }

  @override
  Future<List<String>> getDistinctTransportModes() async {
    return _queryAdapter.queryList(
        'SELECT DISTINCT transport_mode FROM collection_centers WHERE is_deleted = 0 AND transport_mode IS NOT NULL AND transport_mode != \"\"',
        mapper: (Map<String, Object?> row) => row.values.first as String);
  }

  @override
  Future<List<String>> getDistinctCommissionTypes() async {
    return _queryAdapter.queryList(
        'SELECT DISTINCT commission_type FROM collection_centers WHERE is_deleted = 0 AND commission_type IS NOT NULL AND commission_type != \"\"',
        mapper: (Map<String, Object?> row) => row.values.first as String);
  }

  @override
  Future<List<CollectionCenterEntity>> getActiveCollectionCenters() async {
    return _queryAdapter.queryList(
        'SELECT * FROM collection_centers WHERE is_deleted = 0 AND centre_status = \"Active\" ORDER BY center_name',
        mapper: (Map<String, Object?> row) => CollectionCenterEntity(
            id: row['id'] as int?,
            serverId: row['server_id'] as int?,
            centerCode: row['center_code'] as String,
            centerName: row['center_name'] as String,
            country: row['country'] as String,
            state: row['state'] as String,
            city: row['city'] as String,
            address1: row['address1'] as String,
            address2: row['address2'] as String,
            location: row['location'] as String,
            postalCode: row['postal_code'] as String,
            latitude: row['latitude'] as double,
            longitude: row['longitude'] as double,
            gstNumber: row['gst_number'] as String,
            panNumber: row['pan_number'] as String,
            contactPersonName: row['contact_person_name'] as String,
            phoneNo: row['phone_no'] as String,
            email: row['email'] as String,
            centreStatus: row['centre_status'] as String,
            branchTypeId: row['branch_type_id'] as int?,
            labAffiliationCompany: row['lab_affiliation_company'] as String,
            operationalHoursFrom: row['operational_hours_from'] as String,
            operationalHoursTo: row['operational_hours_to'] as String,
            collectionDays: row['collection_days'] as String,
            samplePickupTimingFrom: row['sample_pickup_timing_from'] as String,
            samplePickupTimingTo: row['sample_pickup_timing_to'] as String,
            transportMode: row['transport_mode'] as String,
            courierAgencyName: row['courier_agency_name'] as String,
            commissionType: row['commission_type'] as String,
            commissionValue: row['commission_value'] as double,
            accountHolderName: row['account_holder_name'] as String,
            accountNo: row['account_no'] as String,
            ifscCode: row['ifsc_code'] as String,
            agreementFile1Path: row['agreement_file1_path'] as String?,
            agreementFile2Path: row['agreement_file2_path'] as String?,
            createdAt: row['created_at'] as String?,
            createdBy: row['created_by'] as String?,
            lastModified: row['last_modified'] as String?,
            lastModifiedBy: row['last_modified_by'] as String?,
            isDeleted: row['is_deleted'] as int,
            deletedBy: row['deleted_by'] as String?,
            isSynced: row['is_synced'] as int,
            syncStatus: row['sync_status'] as String,
            syncAttempts: row['sync_attempts'] as int,
            lastSyncError: row['last_sync_error'] as String?));
  }

  @override
  Future<List<CollectionCenterEntity>> getInactiveCollectionCenters() async {
    return _queryAdapter.queryList(
        'SELECT * FROM collection_centers WHERE is_deleted = 0 AND centre_status = \"Inactive\" ORDER BY center_name',
        mapper: (Map<String, Object?> row) => CollectionCenterEntity(
            id: row['id'] as int?,
            serverId: row['server_id'] as int?,
            centerCode: row['center_code'] as String,
            centerName: row['center_name'] as String,
            country: row['country'] as String,
            state: row['state'] as String,
            city: row['city'] as String,
            address1: row['address1'] as String,
            address2: row['address2'] as String,
            location: row['location'] as String,
            postalCode: row['postal_code'] as String,
            latitude: row['latitude'] as double,
            longitude: row['longitude'] as double,
            gstNumber: row['gst_number'] as String,
            panNumber: row['pan_number'] as String,
            contactPersonName: row['contact_person_name'] as String,
            phoneNo: row['phone_no'] as String,
            email: row['email'] as String,
            centreStatus: row['centre_status'] as String,
            branchTypeId: row['branch_type_id'] as int?,
            labAffiliationCompany: row['lab_affiliation_company'] as String,
            operationalHoursFrom: row['operational_hours_from'] as String,
            operationalHoursTo: row['operational_hours_to'] as String,
            collectionDays: row['collection_days'] as String,
            samplePickupTimingFrom: row['sample_pickup_timing_from'] as String,
            samplePickupTimingTo: row['sample_pickup_timing_to'] as String,
            transportMode: row['transport_mode'] as String,
            courierAgencyName: row['courier_agency_name'] as String,
            commissionType: row['commission_type'] as String,
            commissionValue: row['commission_value'] as double,
            accountHolderName: row['account_holder_name'] as String,
            accountNo: row['account_no'] as String,
            ifscCode: row['ifsc_code'] as String,
            agreementFile1Path: row['agreement_file1_path'] as String?,
            agreementFile2Path: row['agreement_file2_path'] as String?,
            createdAt: row['created_at'] as String?,
            createdBy: row['created_by'] as String?,
            lastModified: row['last_modified'] as String?,
            lastModifiedBy: row['last_modified_by'] as String?,
            isDeleted: row['is_deleted'] as int,
            deletedBy: row['deleted_by'] as String?,
            isSynced: row['is_synced'] as int,
            syncStatus: row['sync_status'] as String,
            syncAttempts: row['sync_attempts'] as int,
            lastSyncError: row['last_sync_error'] as String?));
  }

  @override
  Future<List<int>> insertCollectionCenterList(
      List<CollectionCenterEntity> collectionCenters) {
    return _collectionCenterEntityInsertionAdapter.insertListAndReturnIds(
        collectionCenters, OnConflictStrategy.replace);
  }

  @override
  Future<int> insertCollectionCenter(CollectionCenterEntity collectionCenter) {
    return _collectionCenterEntityInsertionAdapter.insertAndReturnId(
        collectionCenter, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateCollectionCenter(
      CollectionCenterEntity collectionCenter) async {
    await _collectionCenterEntityUpdateAdapter.update(
        collectionCenter, OnConflictStrategy.abort);
  }
}

class _$GroupDao extends GroupDao {
  _$GroupDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _groupEntityInsertionAdapter = InsertionAdapter(
            database,
            'groups',
            (GroupEntity item) => <String, Object?>{
                  'id': item.id,
                  'server_id': item.serverId,
                  'name': item.name,
                  'description': item.description,
                  'code': item.code,
                  'type': item.type,
                  'status': item.status,
                  'tenant_id': item.tenantId,
                  'created_at': item.createdAt,
                  'created_by': item.createdBy,
                  'last_modified': item.lastModified,
                  'last_modified_by': item.lastModifiedBy,
                  'is_deleted': item.isDeleted,
                  'deleted_by': item.deletedBy,
                  'is_synced': item.isSynced,
                  'sync_status': item.syncStatus,
                  'sync_attempts': item.syncAttempts,
                  'last_sync_error': item.lastSyncError
                }),
        _groupEntityUpdateAdapter = UpdateAdapter(
            database,
            'groups',
            ['id'],
            (GroupEntity item) => <String, Object?>{
                  'id': item.id,
                  'server_id': item.serverId,
                  'name': item.name,
                  'description': item.description,
                  'code': item.code,
                  'type': item.type,
                  'status': item.status,
                  'tenant_id': item.tenantId,
                  'created_at': item.createdAt,
                  'created_by': item.createdBy,
                  'last_modified': item.lastModified,
                  'last_modified_by': item.lastModifiedBy,
                  'is_deleted': item.isDeleted,
                  'deleted_by': item.deletedBy,
                  'is_synced': item.isSynced,
                  'sync_status': item.syncStatus,
                  'sync_attempts': item.syncAttempts,
                  'last_sync_error': item.lastSyncError
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<GroupEntity> _groupEntityInsertionAdapter;

  final UpdateAdapter<GroupEntity> _groupEntityUpdateAdapter;

  @override
  Future<List<GroupEntity>> getAllGroups() async {
    return _queryAdapter.queryList(
        'SELECT * FROM groups WHERE is_deleted = 0 ORDER BY name',
        mapper: (Map<String, Object?> row) => GroupEntity(
            id: row['id'] as int?,
            serverId: row['server_id'] as int?,
            name: row['name'] as String,
            description: row['description'] as String?,
            code: row['code'] as String?,
            type: row['type'] as String?,
            status: row['status'] as String?,
            tenantId: row['tenant_id'] as String?,
            createdAt: row['created_at'] as String?,
            createdBy: row['created_by'] as String?,
            lastModified: row['last_modified'] as String?,
            lastModifiedBy: row['last_modified_by'] as String?,
            isDeleted: row['is_deleted'] as int,
            deletedBy: row['deleted_by'] as String?,
            isSynced: row['is_synced'] as int,
            syncStatus: row['sync_status'] as String?,
            syncAttempts: row['sync_attempts'] as int,
            lastSyncError: row['last_sync_error'] as String?));
  }

  @override
  Future<GroupEntity?> getGroupById(int id) async {
    return _queryAdapter.query('SELECT * FROM groups WHERE id = ?1',
        mapper: (Map<String, Object?> row) => GroupEntity(
            id: row['id'] as int?,
            serverId: row['server_id'] as int?,
            name: row['name'] as String,
            description: row['description'] as String?,
            code: row['code'] as String?,
            type: row['type'] as String?,
            status: row['status'] as String?,
            tenantId: row['tenant_id'] as String?,
            createdAt: row['created_at'] as String?,
            createdBy: row['created_by'] as String?,
            lastModified: row['last_modified'] as String?,
            lastModifiedBy: row['last_modified_by'] as String?,
            isDeleted: row['is_deleted'] as int,
            deletedBy: row['deleted_by'] as String?,
            isSynced: row['is_synced'] as int,
            syncStatus: row['sync_status'] as String?,
            syncAttempts: row['sync_attempts'] as int,
            lastSyncError: row['last_sync_error'] as String?),
        arguments: [id]);
  }

  @override
  Future<GroupEntity?> getGroupByServerId(int serverId) async {
    return _queryAdapter.query('SELECT * FROM groups WHERE server_id = ?1',
        mapper: (Map<String, Object?> row) => GroupEntity(
            id: row['id'] as int?,
            serverId: row['server_id'] as int?,
            name: row['name'] as String,
            description: row['description'] as String?,
            code: row['code'] as String?,
            type: row['type'] as String?,
            status: row['status'] as String?,
            tenantId: row['tenant_id'] as String?,
            createdAt: row['created_at'] as String?,
            createdBy: row['created_by'] as String?,
            lastModified: row['last_modified'] as String?,
            lastModifiedBy: row['last_modified_by'] as String?,
            isDeleted: row['is_deleted'] as int,
            deletedBy: row['deleted_by'] as String?,
            isSynced: row['is_synced'] as int,
            syncStatus: row['sync_status'] as String?,
            syncAttempts: row['sync_attempts'] as int,
            lastSyncError: row['last_sync_error'] as String?),
        arguments: [serverId]);
  }

  @override
  Future<void> deleteGroup(int id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM groups WHERE id = ?1', arguments: [id]);
  }

  @override
  Future<int?> getTotalCount() async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM groups WHERE is_deleted = 0',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<int?> getSyncedCount() async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM groups WHERE is_synced = 1 AND is_deleted = 0',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<int?> getPendingCount() async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM groups WHERE is_synced = 0 AND is_deleted = 0',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<List<GroupEntity>> getPendingSync() async {
    return _queryAdapter.queryList(
        'SELECT * FROM groups WHERE is_synced = 0 AND is_deleted = 0',
        mapper: (Map<String, Object?> row) => GroupEntity(
            id: row['id'] as int?,
            serverId: row['server_id'] as int?,
            name: row['name'] as String,
            description: row['description'] as String?,
            code: row['code'] as String?,
            type: row['type'] as String?,
            status: row['status'] as String?,
            tenantId: row['tenant_id'] as String?,
            createdAt: row['created_at'] as String?,
            createdBy: row['created_by'] as String?,
            lastModified: row['last_modified'] as String?,
            lastModifiedBy: row['last_modified_by'] as String?,
            isDeleted: row['is_deleted'] as int,
            deletedBy: row['deleted_by'] as String?,
            isSynced: row['is_synced'] as int,
            syncStatus: row['sync_status'] as String?,
            syncAttempts: row['sync_attempts'] as int,
            lastSyncError: row['last_sync_error'] as String?));
  }

  @override
  Future<void> markAsSynced(int id) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE groups SET is_synced = 1, sync_status = \"synced\" WHERE id = ?1',
        arguments: [id]);
  }

  @override
  Future<void> updateServerId(
    int id,
    int serverId,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE groups SET server_id = ?2 WHERE id = ?1',
        arguments: [id, serverId]);
  }

  @override
  Future<void> updateSyncError(
    int id,
    String error,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE groups SET sync_attempts = sync_attempts + 1, last_sync_error = ?2 WHERE id = ?1',
        arguments: [id, error]);
  }

  @override
  Future<List<GroupEntity>> searchGroups(String query) async {
    return _queryAdapter.queryList(
        'SELECT * FROM groups WHERE (name LIKE ?1 OR code LIKE ?1) AND is_deleted = 0',
        mapper: (Map<String, Object?> row) => GroupEntity(id: row['id'] as int?, serverId: row['server_id'] as int?, name: row['name'] as String, description: row['description'] as String?, code: row['code'] as String?, type: row['type'] as String?, status: row['status'] as String?, tenantId: row['tenant_id'] as String?, createdAt: row['created_at'] as String?, createdBy: row['created_by'] as String?, lastModified: row['last_modified'] as String?, lastModifiedBy: row['last_modified_by'] as String?, isDeleted: row['is_deleted'] as int, deletedBy: row['deleted_by'] as String?, isSynced: row['is_synced'] as int, syncStatus: row['sync_status'] as String?, syncAttempts: row['sync_attempts'] as int, lastSyncError: row['last_sync_error'] as String?),
        arguments: [query]);
  }

  @override
  Future<void> softDeleteGroup(
    int id,
    String deletedBy,
    String timestamp,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE groups SET is_deleted = 1, deleted_by = ?2, last_modified = ?3 WHERE id = ?1',
        arguments: [id, deletedBy, timestamp]);
  }

  @override
  Future<List<GroupEntity>> getDeletedGroups() async {
    return _queryAdapter.queryList(
        'SELECT * FROM groups WHERE is_deleted = 1 ORDER BY name',
        mapper: (Map<String, Object?> row) => GroupEntity(
            id: row['id'] as int?,
            serverId: row['server_id'] as int?,
            name: row['name'] as String,
            description: row['description'] as String?,
            code: row['code'] as String?,
            type: row['type'] as String?,
            status: row['status'] as String?,
            tenantId: row['tenant_id'] as String?,
            createdAt: row['created_at'] as String?,
            createdBy: row['created_by'] as String?,
            lastModified: row['last_modified'] as String?,
            lastModifiedBy: row['last_modified_by'] as String?,
            isDeleted: row['is_deleted'] as int,
            deletedBy: row['deleted_by'] as String?,
            isSynced: row['is_synced'] as int,
            syncStatus: row['sync_status'] as String?,
            syncAttempts: row['sync_attempts'] as int,
            lastSyncError: row['last_sync_error'] as String?));
  }

  @override
  Future<void> restoreGroup(int id) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE groups SET is_deleted = 0, deleted_by = NULL WHERE id = ?1',
        arguments: [id]);
  }

  @override
  Future<void> insertGroup(GroupEntity group) async {
    await _groupEntityInsertionAdapter.insert(
        group, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertGroups(List<GroupEntity> groups) async {
    await _groupEntityInsertionAdapter.insertList(
        groups, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateGroup(GroupEntity group) async {
    await _groupEntityUpdateAdapter.update(group, OnConflictStrategy.abort);
  }
}

class _$TestDao extends TestDao {
  _$TestDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _testEntityInsertionAdapter = InsertionAdapter(
            database,
            'test',
            (TestEntity item) => <String, Object?>{
                  'id': item.id,
                  'server_id': item.serverId,
                  'code': item.code,
                  'name': item.name,
                  'product_group': item.group,
                  'mrp': item.mrp,
                  'sales_rate_a': item.salesRateA,
                  'sales_rate_b': item.salesRateB,
                  'hsn_sac': item.hsnSac,
                  'gst': item.gst,
                  'barcode': item.barcode,
                  'min_value': item.minValue,
                  'max_value': item.maxValue,
                  'unit': item.unit,
                  'created_at': item.createdAt,
                  'created_by': item.createdBy,
                  'last_modified': item.lastModified,
                  'last_modified_by': item.lastModifiedBy,
                  'is_deleted': item.isDeleted,
                  'deleted_by': item.deletedBy,
                  'is_synced': item.isSynced,
                  'sync_status': item.syncStatus,
                  'sync_attempts': item.syncAttempts,
                  'last_sync_error': item.lastSyncError
                }),
        _testEntityUpdateAdapter = UpdateAdapter(
            database,
            'test',
            ['id'],
            (TestEntity item) => <String, Object?>{
                  'id': item.id,
                  'server_id': item.serverId,
                  'code': item.code,
                  'name': item.name,
                  'product_group': item.group,
                  'mrp': item.mrp,
                  'sales_rate_a': item.salesRateA,
                  'sales_rate_b': item.salesRateB,
                  'hsn_sac': item.hsnSac,
                  'gst': item.gst,
                  'barcode': item.barcode,
                  'min_value': item.minValue,
                  'max_value': item.maxValue,
                  'unit': item.unit,
                  'created_at': item.createdAt,
                  'created_by': item.createdBy,
                  'last_modified': item.lastModified,
                  'last_modified_by': item.lastModifiedBy,
                  'is_deleted': item.isDeleted,
                  'deleted_by': item.deletedBy,
                  'is_synced': item.isSynced,
                  'sync_status': item.syncStatus,
                  'sync_attempts': item.syncAttempts,
                  'last_sync_error': item.lastSyncError
                }),
        _testEntityDeletionAdapter = DeletionAdapter(
            database,
            'test',
            ['id'],
            (TestEntity item) => <String, Object?>{
                  'id': item.id,
                  'server_id': item.serverId,
                  'code': item.code,
                  'name': item.name,
                  'product_group': item.group,
                  'mrp': item.mrp,
                  'sales_rate_a': item.salesRateA,
                  'sales_rate_b': item.salesRateB,
                  'hsn_sac': item.hsnSac,
                  'gst': item.gst,
                  'barcode': item.barcode,
                  'min_value': item.minValue,
                  'max_value': item.maxValue,
                  'unit': item.unit,
                  'created_at': item.createdAt,
                  'created_by': item.createdBy,
                  'last_modified': item.lastModified,
                  'last_modified_by': item.lastModifiedBy,
                  'is_deleted': item.isDeleted,
                  'deleted_by': item.deletedBy,
                  'is_synced': item.isSynced,
                  'sync_status': item.syncStatus,
                  'sync_attempts': item.syncAttempts,
                  'last_sync_error': item.lastSyncError
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<TestEntity> _testEntityInsertionAdapter;

  final UpdateAdapter<TestEntity> _testEntityUpdateAdapter;

  final DeletionAdapter<TestEntity> _testEntityDeletionAdapter;

  @override
  Future<List<TestEntity>> getAllTests() async {
    return _queryAdapter.queryList(
        'SELECT * FROM test WHERE is_deleted = 0 ORDER BY name',
        mapper: (Map<String, Object?> row) => TestEntity(
            id: row['id'] as int?,
            serverId: row['server_id'] as int?,
            code: row['code'] as String,
            name: row['name'] as String,
            group: row['product_group'] as String,
            mrp: row['mrp'] as double,
            salesRateA: row['sales_rate_a'] as double,
            salesRateB: row['sales_rate_b'] as double,
            hsnSac: row['hsn_sac'] as String?,
            gst: row['gst'] as int,
            barcode: row['barcode'] as String?,
            minValue: row['min_value'] as double,
            maxValue: row['max_value'] as double,
            unit: row['unit'] as String,
            createdAt: row['created_at'] as String,
            createdBy: row['created_by'] as String?,
            lastModified: row['last_modified'] as String?,
            lastModifiedBy: row['last_modified_by'] as String?,
            isDeleted: row['is_deleted'] as int,
            deletedBy: row['deleted_by'] as String?,
            isSynced: row['is_synced'] as int,
            syncStatus: row['sync_status'] as String,
            syncAttempts: row['sync_attempts'] as int,
            lastSyncError: row['last_sync_error'] as String?));
  }

  @override
  Future<TestEntity?> getTestByCode(String code) async {
    return _queryAdapter.query(
        'SELECT * FROM test WHERE code = ?1 AND is_deleted = 0',
        mapper: (Map<String, Object?> row) => TestEntity(
            id: row['id'] as int?,
            serverId: row['server_id'] as int?,
            code: row['code'] as String,
            name: row['name'] as String,
            group: row['product_group'] as String,
            mrp: row['mrp'] as double,
            salesRateA: row['sales_rate_a'] as double,
            salesRateB: row['sales_rate_b'] as double,
            hsnSac: row['hsn_sac'] as String?,
            gst: row['gst'] as int,
            barcode: row['barcode'] as String?,
            minValue: row['min_value'] as double,
            maxValue: row['max_value'] as double,
            unit: row['unit'] as String,
            createdAt: row['created_at'] as String,
            createdBy: row['created_by'] as String?,
            lastModified: row['last_modified'] as String?,
            lastModifiedBy: row['last_modified_by'] as String?,
            isDeleted: row['is_deleted'] as int,
            deletedBy: row['deleted_by'] as String?,
            isSynced: row['is_synced'] as int,
            syncStatus: row['sync_status'] as String,
            syncAttempts: row['sync_attempts'] as int,
            lastSyncError: row['last_sync_error'] as String?),
        arguments: [code]);
  }

  @override
  Future<List<TestEntity>> getUnsyncedTests() async {
    return _queryAdapter.queryList('SELECT * FROM test WHERE is_synced = 0',
        mapper: (Map<String, Object?> row) => TestEntity(
            id: row['id'] as int?,
            serverId: row['server_id'] as int?,
            code: row['code'] as String,
            name: row['name'] as String,
            group: row['product_group'] as String,
            mrp: row['mrp'] as double,
            salesRateA: row['sales_rate_a'] as double,
            salesRateB: row['sales_rate_b'] as double,
            hsnSac: row['hsn_sac'] as String?,
            gst: row['gst'] as int,
            barcode: row['barcode'] as String?,
            minValue: row['min_value'] as double,
            maxValue: row['max_value'] as double,
            unit: row['unit'] as String,
            createdAt: row['created_at'] as String,
            createdBy: row['created_by'] as String?,
            lastModified: row['last_modified'] as String?,
            lastModifiedBy: row['last_modified_by'] as String?,
            isDeleted: row['is_deleted'] as int,
            deletedBy: row['deleted_by'] as String?,
            isSynced: row['is_synced'] as int,
            syncStatus: row['sync_status'] as String,
            syncAttempts: row['sync_attempts'] as int,
            lastSyncError: row['last_sync_error'] as String?));
  }

  @override
  Future<void> softDeleteTest(
    String code,
    String deletedBy,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE test SET is_deleted = 1, deleted_by = ?2 WHERE code = ?1',
        arguments: [code, deletedBy]);
  }

  @override
  Future<void> deleteTestByCode(String code) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM test WHERE code = ?1', arguments: [code]);
  }

  @override
  Future<int?> getTestCount() async {
    return _queryAdapter.query('SELECT COUNT(*) FROM test WHERE is_deleted = 0',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<List<TestEntity>> searchTests(String query) async {
    return _queryAdapter.queryList(
        'SELECT * FROM test WHERE (name LIKE ?1 OR code LIKE ?1) AND is_deleted = 0',
        mapper: (Map<String, Object?> row) => TestEntity(id: row['id'] as int?, serverId: row['server_id'] as int?, code: row['code'] as String, name: row['name'] as String, group: row['product_group'] as String, mrp: row['mrp'] as double, salesRateA: row['sales_rate_a'] as double, salesRateB: row['sales_rate_b'] as double, hsnSac: row['hsn_sac'] as String?, gst: row['gst'] as int, barcode: row['barcode'] as String?, minValue: row['min_value'] as double, maxValue: row['max_value'] as double, unit: row['unit'] as String, createdAt: row['created_at'] as String, createdBy: row['created_by'] as String?, lastModified: row['last_modified'] as String?, lastModifiedBy: row['last_modified_by'] as String?, isDeleted: row['is_deleted'] as int, deletedBy: row['deleted_by'] as String?, isSynced: row['is_synced'] as int, syncStatus: row['sync_status'] as String, syncAttempts: row['sync_attempts'] as int, lastSyncError: row['last_sync_error'] as String?),
        arguments: [query]);
  }

  @override
  Future<void> insertTest(TestEntity test) async {
    await _testEntityInsertionAdapter.insert(test, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateTest(TestEntity test) async {
    await _testEntityUpdateAdapter.update(test, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteTest(TestEntity test) async {
    await _testEntityDeletionAdapter.delete(test);
  }
}

class _$PackageDao extends PackageDao {
  _$PackageDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _packageEntityInsertionAdapter = InsertionAdapter(
            database,
            'packages',
            (PackageEntity item) => <String, Object?>{
                  'id': item.id,
                  'server_id': item.serverId,
                  'code': item.code,
                  'name': item.name,
                  'gst': item.gst,
                  'rate': item.rate,
                  'tests_json': item.testsJson,
                  'created_at': item.createdAt,
                  'created_by': item.createdBy,
                  'last_modified': item.lastModified,
                  'last_modified_by': item.lastModifiedBy,
                  'is_deleted': item.isDeleted,
                  'deleted_by': item.deletedBy,
                  'is_synced': item.isSynced,
                  'sync_status': item.syncStatus,
                  'sync_attempts': item.syncAttempts,
                  'last_sync_error': item.lastSyncError
                }),
        _packageEntityUpdateAdapter = UpdateAdapter(
            database,
            'packages',
            ['id'],
            (PackageEntity item) => <String, Object?>{
                  'id': item.id,
                  'server_id': item.serverId,
                  'code': item.code,
                  'name': item.name,
                  'gst': item.gst,
                  'rate': item.rate,
                  'tests_json': item.testsJson,
                  'created_at': item.createdAt,
                  'created_by': item.createdBy,
                  'last_modified': item.lastModified,
                  'last_modified_by': item.lastModifiedBy,
                  'is_deleted': item.isDeleted,
                  'deleted_by': item.deletedBy,
                  'is_synced': item.isSynced,
                  'sync_status': item.syncStatus,
                  'sync_attempts': item.syncAttempts,
                  'last_sync_error': item.lastSyncError
                }),
        _packageEntityDeletionAdapter = DeletionAdapter(
            database,
            'packages',
            ['id'],
            (PackageEntity item) => <String, Object?>{
                  'id': item.id,
                  'server_id': item.serverId,
                  'code': item.code,
                  'name': item.name,
                  'gst': item.gst,
                  'rate': item.rate,
                  'tests_json': item.testsJson,
                  'created_at': item.createdAt,
                  'created_by': item.createdBy,
                  'last_modified': item.lastModified,
                  'last_modified_by': item.lastModifiedBy,
                  'is_deleted': item.isDeleted,
                  'deleted_by': item.deletedBy,
                  'is_synced': item.isSynced,
                  'sync_status': item.syncStatus,
                  'sync_attempts': item.syncAttempts,
                  'last_sync_error': item.lastSyncError
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<PackageEntity> _packageEntityInsertionAdapter;

  final UpdateAdapter<PackageEntity> _packageEntityUpdateAdapter;

  final DeletionAdapter<PackageEntity> _packageEntityDeletionAdapter;

  @override
  Future<List<PackageEntity>> getAllPackages() async {
    return _queryAdapter.queryList(
        'SELECT * FROM packages WHERE is_deleted = 0 ORDER BY name',
        mapper: (Map<String, Object?> row) => PackageEntity(
            id: row['id'] as int?,
            serverId: row['server_id'] as int?,
            code: row['code'] as String,
            name: row['name'] as String,
            gst: row['gst'] as double,
            rate: row['rate'] as double,
            testsJson: row['tests_json'] as String,
            createdAt: row['created_at'] as String,
            createdBy: row['created_by'] as String?,
            lastModified: row['last_modified'] as String?,
            lastModifiedBy: row['last_modified_by'] as String?,
            isDeleted: row['is_deleted'] as int,
            deletedBy: row['deleted_by'] as String?,
            isSynced: row['is_synced'] as int,
            syncStatus: row['sync_status'] as String,
            syncAttempts: row['sync_attempts'] as int,
            lastSyncError: row['last_sync_error'] as String?));
  }

  @override
  Future<PackageEntity?> getPackageByCode(String code) async {
    return _queryAdapter.query(
        'SELECT * FROM packages WHERE code = ?1 AND is_deleted = 0',
        mapper: (Map<String, Object?> row) => PackageEntity(
            id: row['id'] as int?,
            serverId: row['server_id'] as int?,
            code: row['code'] as String,
            name: row['name'] as String,
            gst: row['gst'] as double,
            rate: row['rate'] as double,
            testsJson: row['tests_json'] as String,
            createdAt: row['created_at'] as String,
            createdBy: row['created_by'] as String?,
            lastModified: row['last_modified'] as String?,
            lastModifiedBy: row['last_modified_by'] as String?,
            isDeleted: row['is_deleted'] as int,
            deletedBy: row['deleted_by'] as String?,
            isSynced: row['is_synced'] as int,
            syncStatus: row['sync_status'] as String,
            syncAttempts: row['sync_attempts'] as int,
            lastSyncError: row['last_sync_error'] as String?),
        arguments: [code]);
  }

  @override
  Future<List<PackageEntity>> getUnsyncedPackages() async {
    return _queryAdapter.queryList('SELECT * FROM packages WHERE is_synced = 0',
        mapper: (Map<String, Object?> row) => PackageEntity(
            id: row['id'] as int?,
            serverId: row['server_id'] as int?,
            code: row['code'] as String,
            name: row['name'] as String,
            gst: row['gst'] as double,
            rate: row['rate'] as double,
            testsJson: row['tests_json'] as String,
            createdAt: row['created_at'] as String,
            createdBy: row['created_by'] as String?,
            lastModified: row['last_modified'] as String?,
            lastModifiedBy: row['last_modified_by'] as String?,
            isDeleted: row['is_deleted'] as int,
            deletedBy: row['deleted_by'] as String?,
            isSynced: row['is_synced'] as int,
            syncStatus: row['sync_status'] as String,
            syncAttempts: row['sync_attempts'] as int,
            lastSyncError: row['last_sync_error'] as String?));
  }

  @override
  Future<void> softDeletePackage(
    String code,
    String deletedBy,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE packages SET is_deleted = 1, deleted_by = ?2 WHERE code = ?1',
        arguments: [code, deletedBy]);
  }

  @override
  Future<void> deletePackageByCode(String code) async {
    await _queryAdapter.queryNoReturn('DELETE FROM packages WHERE code = ?1',
        arguments: [code]);
  }

  @override
  Future<int?> getPackageCount() async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM packages WHERE is_deleted = 0',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<List<PackageEntity>> searchPackages(String query) async {
    return _queryAdapter.queryList(
        'SELECT * FROM packages WHERE name LIKE ?1 OR code LIKE ?1 AND is_deleted = 0',
        mapper: (Map<String, Object?> row) => PackageEntity(id: row['id'] as int?, serverId: row['server_id'] as int?, code: row['code'] as String, name: row['name'] as String, gst: row['gst'] as double, rate: row['rate'] as double, testsJson: row['tests_json'] as String, createdAt: row['created_at'] as String, createdBy: row['created_by'] as String?, lastModified: row['last_modified'] as String?, lastModifiedBy: row['last_modified_by'] as String?, isDeleted: row['is_deleted'] as int, deletedBy: row['deleted_by'] as String?, isSynced: row['is_synced'] as int, syncStatus: row['sync_status'] as String, syncAttempts: row['sync_attempts'] as int, lastSyncError: row['last_sync_error'] as String?),
        arguments: [query]);
  }

  @override
  Future<void> insertPackage(PackageEntity package) async {
    await _packageEntityInsertionAdapter.insert(
        package, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertPackages(List<PackageEntity> packages) async {
    await _packageEntityInsertionAdapter.insertList(
        packages, OnConflictStrategy.replace);
  }

  @override
  Future<void> updatePackage(PackageEntity package) async {
    await _packageEntityUpdateAdapter.update(package, OnConflictStrategy.abort);
  }

  @override
  Future<void> deletePackage(PackageEntity package) async {
    await _packageEntityDeletionAdapter.delete(package);
  }
}

class _$TestBOMDao extends TestBOMDao {
  _$TestBOMDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _testBOMInsertionAdapter = InsertionAdapter(
            database,
            'test_boms',
            (TestBOM item) => <String, Object?>{
                  'id': item.id,
                  'server_id': item.serverId,
                  'code': item.code,
                  'name': item.name,
                  'test_group': item.testGroup,
                  'gender_type': item.genderType,
                  'description': item.description,
                  'rate': item.rate,
                  'gst': item.gst,
                  'turn_around_time': item.turnAroundTime,
                  'time_unit': item.timeUnit,
                  'is_active': item.isActive,
                  'method': item.method,
                  'reference_range': item.referenceRange,
                  'clinical_significance': item.clinicalSignificance,
                  'specimen_requirement': item.specimenRequirement,
                  'created_at': item.createdAt,
                  'created_by': item.createdBy,
                  'last_modified': item.lastModified,
                  'last_modified_by': item.lastModifiedBy,
                  'is_deleted': item.isDeleted,
                  'deleted_by': item.deletedBy,
                  'is_synced': item.isSynced,
                  'sync_status': item.syncStatus,
                  'sync_attempts': item.syncAttempts,
                  'last_sync_error': item.lastSyncError,
                  'parameters': item.parameters
                }),
        _testBOMUpdateAdapter = UpdateAdapter(
            database,
            'test_boms',
            ['id'],
            (TestBOM item) => <String, Object?>{
                  'id': item.id,
                  'server_id': item.serverId,
                  'code': item.code,
                  'name': item.name,
                  'test_group': item.testGroup,
                  'gender_type': item.genderType,
                  'description': item.description,
                  'rate': item.rate,
                  'gst': item.gst,
                  'turn_around_time': item.turnAroundTime,
                  'time_unit': item.timeUnit,
                  'is_active': item.isActive,
                  'method': item.method,
                  'reference_range': item.referenceRange,
                  'clinical_significance': item.clinicalSignificance,
                  'specimen_requirement': item.specimenRequirement,
                  'created_at': item.createdAt,
                  'created_by': item.createdBy,
                  'last_modified': item.lastModified,
                  'last_modified_by': item.lastModifiedBy,
                  'is_deleted': item.isDeleted,
                  'deleted_by': item.deletedBy,
                  'is_synced': item.isSynced,
                  'sync_status': item.syncStatus,
                  'sync_attempts': item.syncAttempts,
                  'last_sync_error': item.lastSyncError,
                  'parameters': item.parameters
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<TestBOM> _testBOMInsertionAdapter;

  final UpdateAdapter<TestBOM> _testBOMUpdateAdapter;

  @override
  Future<List<TestBOM>> getAllTestBOMs() async {
    return _queryAdapter.queryList(
        'SELECT * FROM test_boms WHERE is_deleted = 0 ORDER BY name ASC',
        mapper: (Map<String, Object?> row) => TestBOM(
            id: row['id'] as int?,
            serverId: row['server_id'] as int?,
            code: row['code'] as String,
            name: row['name'] as String,
            testGroup: row['test_group'] as String,
            genderType: row['gender_type'] as String,
            description: row['description'] as String?,
            rate: row['rate'] as double,
            gst: row['gst'] as double,
            turnAroundTime: row['turn_around_time'] as String,
            timeUnit: row['time_unit'] as String,
            isActive: row['is_active'] as int,
            method: row['method'] as String?,
            referenceRange: row['reference_range'] as String?,
            clinicalSignificance: row['clinical_significance'] as String?,
            specimenRequirement: row['specimen_requirement'] as String?,
            createdAt: row['created_at'] as String,
            createdBy: row['created_by'] as String,
            lastModified: row['last_modified'] as String?,
            lastModifiedBy: row['last_modified_by'] as String?,
            isDeleted: row['is_deleted'] as int,
            deletedBy: row['deleted_by'] as String?,
            isSynced: row['is_synced'] as int,
            syncStatus: row['sync_status'] as String,
            syncAttempts: row['sync_attempts'] as int,
            lastSyncError: row['last_sync_error'] as String?,
            parameters: row['parameters'] as String));
  }

  @override
  Future<TestBOM?> getTestBOMByCode(String code) async {
    return _queryAdapter.query(
        'SELECT * FROM test_boms WHERE code = ?1 AND is_deleted = 0',
        mapper: (Map<String, Object?> row) => TestBOM(
            id: row['id'] as int?,
            serverId: row['server_id'] as int?,
            code: row['code'] as String,
            name: row['name'] as String,
            testGroup: row['test_group'] as String,
            genderType: row['gender_type'] as String,
            description: row['description'] as String?,
            rate: row['rate'] as double,
            gst: row['gst'] as double,
            turnAroundTime: row['turn_around_time'] as String,
            timeUnit: row['time_unit'] as String,
            isActive: row['is_active'] as int,
            method: row['method'] as String?,
            referenceRange: row['reference_range'] as String?,
            clinicalSignificance: row['clinical_significance'] as String?,
            specimenRequirement: row['specimen_requirement'] as String?,
            createdAt: row['created_at'] as String,
            createdBy: row['created_by'] as String,
            lastModified: row['last_modified'] as String?,
            lastModifiedBy: row['last_modified_by'] as String?,
            isDeleted: row['is_deleted'] as int,
            deletedBy: row['deleted_by'] as String?,
            isSynced: row['is_synced'] as int,
            syncStatus: row['sync_status'] as String,
            syncAttempts: row['sync_attempts'] as int,
            lastSyncError: row['last_sync_error'] as String?,
            parameters: row['parameters'] as String),
        arguments: [code]);
  }

  @override
  Future<List<String>> getAllTestGroups() async {
    return _queryAdapter.queryList(
        'SELECT DISTINCT test_group FROM test_boms WHERE is_deleted = 0 ORDER BY test_group ASC',
        mapper: (Map<String, Object?> row) => row.values.first as String);
  }

  @override
  Future<List<TestBOM>> getTestBOMsByGroup(String group) async {
    return _queryAdapter.queryList(
        'SELECT * FROM test_boms WHERE test_group = ?1 AND is_deleted = 0 ORDER BY name ASC',
        mapper: (Map<String, Object?> row) => TestBOM(id: row['id'] as int?, serverId: row['server_id'] as int?, code: row['code'] as String, name: row['name'] as String, testGroup: row['test_group'] as String, genderType: row['gender_type'] as String, description: row['description'] as String?, rate: row['rate'] as double, gst: row['gst'] as double, turnAroundTime: row['turn_around_time'] as String, timeUnit: row['time_unit'] as String, isActive: row['is_active'] as int, method: row['method'] as String?, referenceRange: row['reference_range'] as String?, clinicalSignificance: row['clinical_significance'] as String?, specimenRequirement: row['specimen_requirement'] as String?, createdAt: row['created_at'] as String, createdBy: row['created_by'] as String, lastModified: row['last_modified'] as String?, lastModifiedBy: row['last_modified_by'] as String?, isDeleted: row['is_deleted'] as int, deletedBy: row['deleted_by'] as String?, isSynced: row['is_synced'] as int, syncStatus: row['sync_status'] as String, syncAttempts: row['sync_attempts'] as int, lastSyncError: row['last_sync_error'] as String?, parameters: row['parameters'] as String),
        arguments: [group]);
  }

  @override
  Future<int?> getTestBOMCount() async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM test_boms WHERE is_deleted = 0',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<int?> getActiveTestBOMCount() async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM test_boms WHERE is_deleted = 0 AND is_active = 1',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<int?> deleteTestBOM(
    String code,
    String deletedBy,
    String lastModified,
  ) async {
    return _queryAdapter.query(
        'UPDATE test_boms SET is_deleted = 1, deleted_by = ?2, last_modified = ?3 WHERE code = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [code, deletedBy, lastModified]);
  }

  @override
  Future<int?> updateSyncStatus(
    String code,
    String status,
    String lastModified,
  ) async {
    return _queryAdapter.query(
        'UPDATE test_boms SET is_synced = 1, sync_status = ?2, last_modified = ?3 WHERE code = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [code, status, lastModified]);
  }

  @override
  Future<int?> incrementSyncAttempts(
    String code,
    String error,
  ) async {
    return _queryAdapter.query(
        'UPDATE test_boms SET sync_attempts = sync_attempts + 1, last_sync_error = ?2 WHERE code = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [code, error]);
  }

  @override
  Future<int> insertTestBOM(TestBOM testBOM) {
    return _testBOMInsertionAdapter.insertAndReturnId(
        testBOM, OnConflictStrategy.replace);
  }

  @override
  Future<int> updateTestBOM(TestBOM testBOM) {
    return _testBOMUpdateAdapter.updateAndReturnChangedRows(
        testBOM, OnConflictStrategy.abort);
  }
}
