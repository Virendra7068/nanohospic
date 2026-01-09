import 'package:nanohospic/database/app_database.dart';
import 'package:nanohospic/database/repository/user_reposetory.dart';
import 'package:nanohospic/database/repository/staff_repo.dart';
import 'package:nanohospic/database/repository/country_repo.dart';
import 'package:nanohospic/database/repository/state_repo.dart';
import 'package:nanohospic/database/repository/city_repo.dart';
import 'package:nanohospic/database/repository/item_cat_repo.dart';
import 'package:nanohospic/database/repository/sucategory_rep.dart';
import 'package:nanohospic/database/repository/hsn_repo.dart';
import 'package:nanohospic/database/repository/branch_type_repo.dart';
import 'package:nanohospic/database/repository/payment_mode_repo.dart';
import 'package:nanohospic/database/repository/sample_type_repo.dart';
import 'package:nanohospic/database/repository/collection_center_repo.dart';
import 'package:nanohospic/database/repository/group_repo.dart';
import 'package:nanohospic/database/repository/patient_identity_repo.dart';
import 'package:nanohospic/database/repository/refrerrer_repo.dart';

class RepositoryManager {
  static UserRepository? _userRepository;
  static StaffRepository? _staffRepository;
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
  static GroupRepo? _groupRepository;
  
  static void clearAll() {
    _userRepository = null;
    _staffRepository = null;
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
  }
  
  // User Repository
  static Future<UserRepository> getUserRepository(AppDatabase db) async {
    _userRepository ??= UserRepository(db);
    return _userRepository!;
  }
  
  // Staff Repository
  static Future<StaffRepository> getStaffRepository(AppDatabase db) async {
    _staffRepository ??= StaffRepository(db.staffDao);
    return _staffRepository!;
  }
  
  // Country Repository
  static Future<CountryRepository> getCountryRepository(AppDatabase db) async {
    _countryRepository ??= CountryRepository(db.countryDao);
    return _countryRepository!;
  }
  
  // State Repository
  static Future<StateRepository> getStateRepository(AppDatabase db) async {
    _stateRepository ??= StateRepository(db.stateDao);
    return _stateRepository!;
  }
  
  // City Repository
  static Future<CityRepository> getCityRepository(AppDatabase db) async {
    _cityRepository ??= CityRepository(db.cityDao);
    return _cityRepository!;
  }
  
  // Category Repository
  static Future<CategoryRepository> getCategoryRepository(AppDatabase db) async {
    _categoryRepository ??= CategoryRepository(db.categoryDao);
    return _categoryRepository!;
  }
  
  // SubCategory Repository
  static Future<SubCategoryRepository> getSubCategoryRepository(AppDatabase db) async {
    _subCategoryRepository ??= SubCategoryRepository(db.subcategoryDao);
    return _subCategoryRepository!;
  }
  
  // HSN Repository
  static Future<HsnRepository> getHsnRepository(AppDatabase db) async {
    _hsnRepository ??= HsnRepository(db.hsnDao);
    return _hsnRepository!;
  }
  
  // BAS Repository
  static Future<BasRepository> getBasRepository(AppDatabase db) async {
    _basRepository ??= BasRepository(db.basDao);
    return _basRepository!;
  }
  
  // Payment Mode Repository
  static Future<PaymentModeRepository> getPaymentModeRepository(AppDatabase db) async {
    _paymentModeRepository ??= PaymentModeRepository(db.paymentModeDao);
    return _paymentModeRepository!;
  }
  
  // Sample Type Repository
  static Future<SampleTypeRepository> getSampleTypeRepository(AppDatabase db) async {
    _sampleTypeRepository ??= SampleTypeRepository(db.sampleTypeDao);
    return _sampleTypeRepository!;
  }
  
  // Branch Type Repository
  static Future<BranchTypeRepository> getBranchTypeRepository(AppDatabase db) async {
    _branchTypeRepository ??= BranchTypeRepository(db.branchTypeDao);
    return _branchTypeRepository!;
  }
  
  // Collection Center Repository
  static Future<CollectionCenterRepository> getCollectionCenterRepository(AppDatabase db) async {
    _collectionCenterRepository ??= CollectionCenterRepository(db.collectionCenterDao);
    return _collectionCenterRepository!;
  }
  
  // Group Repository
  static Future<GroupRepo> getGroupRepository(AppDatabase db) async {
    _groupRepository ??= GroupRepo(db.groupDao);
    return _groupRepository!;
  }
  
  // // Referrer Repository
  // static Future<ReferrerRepository> getReferrerRepository(AppDatabase db) async {
  //   _referrerRepository ??= ReferrerRepository(db.referrerDao);
  //   return _referrerRepository!;
  // }
}