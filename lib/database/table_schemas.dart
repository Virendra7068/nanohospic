class TableSchemas {
  // Categories table schema
  static final String categories = '''
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
  ''';

  // Subcategories table schema
  static final String subcategories = '''
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
  ''';

  // Groups table schema
  static final String groups = '''
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
  ''';

  // HSN Codes table schema
  static final String hsnCodes = '''
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
  ''';

  // Staff table schema
  static final String staff = '''
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
  ''';

  // BAS Names table schema
  static final String basNames = '''
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
  ''';

  // Payment Modes table schema
  static final String paymentModes = '''
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
  ''';

  // Sample Types table schema
  static final String sampleTypes = '''
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
  ''';

  // Branch Types table schema
  static final String branchTypes = '''
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
  ''';

  // Collection Centers table schema
  static final String collectionCenters = '''
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
  ''';

  // Index definitions for each table
  static final Map<String, List<String>> tableIndexes = {
    'hsn_codes': [
      'CREATE INDEX IF NOT EXISTS idx_hsn_code ON hsn_codes(hsn_code)',
      'CREATE INDEX IF NOT EXISTS idx_hsn_synced ON hsn_codes(is_synced)',
      'CREATE INDEX IF NOT EXISTS idx_hsn_deleted ON hsn_codes(is_deleted)',
    ],
    'staff': [
      'CREATE INDEX IF NOT EXISTS idx_staff_name ON staff(name)',
      'CREATE INDEX IF NOT EXISTS idx_staff_department ON staff(department)',
      'CREATE INDEX IF NOT EXISTS idx_staff_designation ON staff(designation)',
      'CREATE INDEX IF NOT EXISTS idx_staff_synced ON staff(is_synced)',
      'CREATE INDEX IF NOT EXISTS idx_staff_deleted ON staff(is_deleted)',
    ],
    'bas_names': [
      'CREATE INDEX IF NOT EXISTS idx_bas_name ON bas_names(name)',
      'CREATE INDEX IF NOT EXISTS idx_bas_synced ON bas_names(is_synced)',
      'CREATE INDEX IF NOT EXISTS idx_bas_deleted ON bas_names(is_deleted)',
    ],
    'payment_modes': [
      'CREATE INDEX IF NOT EXISTS idx_payment_mode_name ON payment_modes(name)',
      'CREATE INDEX IF NOT EXISTS idx_payment_mode_synced ON payment_modes(is_synced)',
      'CREATE INDEX IF NOT EXISTS idx_payment_mode_deleted ON payment_modes(is_deleted)',
    ],
    'sample_types': [
      'CREATE INDEX IF NOT EXISTS idx_sample_type_name ON sample_types(name)',
      'CREATE INDEX IF NOT EXISTS idx_sample_type_synced ON sample_types(is_synced)',
      'CREATE INDEX IF NOT EXISTS idx_sample_type_deleted ON sample_types(is_deleted)',
    ],
    'branch_types': [
      'CREATE INDEX IF NOT EXISTS idx_branch_type_company ON branch_types(company_name)',
      'CREATE INDEX IF NOT EXISTS idx_branch_type_contact ON branch_types(contact_person)',
      'CREATE INDEX IF NOT EXISTS idx_branch_type_synced ON branch_types(is_synced)',
      'CREATE INDEX IF NOT EXISTS idx_branch_type_deleted ON branch_types(is_deleted)',
    ],
    'collection_centers': [
      'CREATE INDEX IF NOT EXISTS idx_collection_center_code ON collection_centers(center_code)',
      'CREATE INDEX IF NOT EXISTS idx_collection_center_name ON collection_centers(center_name)',
      'CREATE INDEX IF NOT EXISTS idx_collection_center_status ON collection_centers(centre_status)',
      'CREATE INDEX IF NOT EXISTS idx_collection_center_city ON collection_centers(city)',
      'CREATE INDEX IF NOT EXISTS idx_collection_center_synced ON collection_centers(is_synced)',
      'CREATE INDEX IF NOT EXISTS idx_collection_center_deleted ON collection_centers(is_deleted)',
    ],
    'groups': [
      'CREATE INDEX IF NOT EXISTS idx_group_name ON groups(name)',
      'CREATE INDEX IF NOT EXISTS idx_group_code ON groups(code)',
      'CREATE INDEX IF NOT EXISTS idx_group_type ON groups(type)',
      'CREATE INDEX IF NOT EXISTS idx_group_synced ON groups(is_synced)',
      'CREATE INDEX IF NOT EXISTS idx_group_deleted ON groups(is_deleted)',
    ],
  };

  // Get schema by table name
  static String? getSchema(String tableName) {
    final schemas = {
      'categories': categories,
      'subcategories': subcategories,
      'groups': groups,
      'hsn_codes': hsnCodes,
      'staff': staff,
      'bas_names': basNames,
      'payment_modes': paymentModes,
      'sample_types': sampleTypes,
      'branch_types': branchTypes,
      'collection_centers': collectionCenters,
    };
    return schemas[tableName];
  }

  // Get indexes by table name
  static List<String>? getIndexes(String tableName) {
    return tableIndexes[tableName];
  }

  // Get all table names
  static List<String> getAllTableNames() {
    return [
      'categories',
      'subcategories',
      'groups',
      'hsn_codes',
      'staff',
      'bas_names',
      'payment_modes',
      'sample_types',
      'branch_types',
      'collection_centers',
    ];
  }
}