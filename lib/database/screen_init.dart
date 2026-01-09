class ScreenInitializer {
  // Initialize screen with table
  static Future<void> initializeScreen(String screenName, String tableName, 
      Future<void> Function() debugCallback) async {
    try {
      print('🚀 Initializing $screenName screen...');
      await ensureTableExists(tableName);
      await debugCallback();
      print('✅ $screenName screen ready!');
    } catch (e) {
      print('❌ $screenName initialization failed: $e');
    }
  }
  
  // Convenience methods for common screens
  static Future<void> initializeGroupScreen(Future<void> Function() debugCallback) async {
    await initializeScreen('group', 'groups', debugCallback);
  }
  
  static Future<void> initializeStaffScreen(Future<void> Function() debugCallback) async {
    await initializeScreen('staff', 'staff', debugCallback);
  }
  
  static Future<void> initializeBasScreen(Future<void> Function() debugCallback) async {
    await initializeScreen('bas', 'bas_names', debugCallback);
  }
  
  static Future<void> initializePaymentModeScreen(Future<void> Function() debugCallback) async {
    await initializeScreen('payment mode', 'payment_modes', debugCallback);
  }
  
  static Future<void> initializeSampleTypeScreen(Future<void> Function() debugCallback) async {
    await initializeScreen('sample type', 'sample_types', debugCallback);
  }
  
  static Future<void> initializeBranchTypeScreen(Future<void> Function() debugCallback) async {
    await initializeScreen('branch type', 'branch_types', debugCallback);
  }
  
  static Future<void> initializeCollectionCenterScreen(Future<void> Function() debugCallback) async {
    await initializeScreen('collection center', 'collection_centers', debugCallback);
  }
  
  // Ensure table exists
  static Future<void> ensureTableExists(String tableName) async {
    // This would use DatabaseProvider's ensureTableExists method
    // Implementation depends on how DatabaseProvider is structured
    print('🔍 Checking $tableName table...');
    // Add actual implementation here
  }
}