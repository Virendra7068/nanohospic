// import 'dart:async';
// import 'package:floor/floor.dart';
// import 'package:nanohospic/database/dao/city_dao.dart';
// import 'package:nanohospic/database/dao/country_dao_screen.dart';
// import 'package:nanohospic/database/dao/item_cat_dao.dart';
// import 'package:nanohospic/database/dao/state_dao.dart';
// import 'package:nanohospic/database/dao/subcat_dao.dart';
// import 'package:nanohospic/database/dao/user_dao_screen.dart';
// import 'package:nanohospic/database/entity/category_entity.dart';
// import 'package:nanohospic/database/entity/city_entity.dart';
// import 'package:nanohospic/database/entity/country_entity.dart';
// import 'package:nanohospic/database/entity/state_entity.dart';
// import 'package:nanohospic/database/entity/subcat_entity.dart';
// import 'package:sqflite/sqflite.dart' as sqflite;
// import 'entity/user_entity.dart';

// part 'app_database.g.dart';

// @Database(
//   version: 1,
//   entities: [
//     UserEntity,
//     CountryEntity,
//     CityEntity,
//     StateEntity,
//     SubCategoryEntity,
//     CategoryEntity,
//   ],
// )
// abstract class AppDatabase extends FloorDatabase {
//   UserDao get userDao;
//   CountryDao get countryDao;
//   CityDao get cityDao;
//   StateDao get stateDao;
//   CategoryDao get categoryDao;
//   SubCategoryDao get subCategoryDao;
// }

import 'dart:async';
import 'package:floor/floor.dart';
import 'package:nanohospic/database/dao/branch_type_dao.dart';
import 'package:nanohospic/database/dao/city_dao.dart';
import 'package:nanohospic/database/dao/collection_center_dao.dart';
import 'package:nanohospic/database/dao/country_dao_screen.dart';
import 'package:nanohospic/database/dao/department_dao.dart';
import 'package:nanohospic/database/dao/designation_dao.dart';
import 'package:nanohospic/database/dao/division_dao.dart';
import 'package:nanohospic/database/dao/doctor_commision_dao.dart';
import 'package:nanohospic/database/dao/group_dao.dart';
import 'package:nanohospic/database/dao/hsn_dao.dart';
import 'package:nanohospic/database/dao/instrument_master_dao.dart';
import 'package:nanohospic/database/dao/item_cat_dao.dart';
import 'package:nanohospic/database/dao/package_dao.dart';
import 'package:nanohospic/database/dao/patient_identity_dao.dart';
import 'package:nanohospic/database/dao/payment_mode_dao.dart';
import 'package:nanohospic/database/dao/referrer_dao.dart';
import 'package:nanohospic/database/dao/sample_type_dao.dart';
import 'package:nanohospic/database/dao/staff_dao.dart';
import 'package:nanohospic/database/dao/state_dao.dart';
import 'package:nanohospic/database/dao/subcat_dao.dart';
import 'package:nanohospic/database/dao/test_bom_dao.dart';
import 'package:nanohospic/database/dao/test_dao.dart';
import 'package:nanohospic/database/dao/test_mesthod_master_dao.dart';
import 'package:nanohospic/database/dao/unit_dao.dart';
import 'package:nanohospic/database/dao/user_dao_screen.dart';
import 'package:nanohospic/database/entity/branch_type_entity.dart';
import 'package:nanohospic/database/entity/category_entity.dart';
import 'package:nanohospic/database/entity/city_entity.dart';
import 'package:nanohospic/database/entity/collection_center_entity.dart';
import 'package:nanohospic/database/entity/country_entity.dart';
import 'package:nanohospic/database/entity/department_entity.dart';
import 'package:nanohospic/database/entity/designation_entity.dart';
import 'package:nanohospic/database/entity/division_entity.dart';
import 'package:nanohospic/database/entity/doctor_commision_entity.dart';
import 'package:nanohospic/database/entity/group_entity.dart';
import 'package:nanohospic/database/entity/hsn_entity.dart';
import 'package:nanohospic/database/entity/instrument_entity.dart';
import 'package:nanohospic/database/entity/package_entity.dart';
import 'package:nanohospic/database/entity/patient_identity_entity.dart';
import 'package:nanohospic/database/entity/payment_mode_entity.dart';
import 'package:nanohospic/database/entity/referrer_entity.dart';
import 'package:nanohospic/database/entity/sample_type_entity.dart';
import 'package:nanohospic/database/entity/staff_entity.dart';
import 'package:nanohospic/database/entity/state_entity.dart';
import 'package:nanohospic/database/entity/subcat_entity.dart';
import 'package:nanohospic/database/entity/test_bom_entity.dart';
import 'package:nanohospic/database/entity/test_entity.dart';
import 'package:nanohospic/database/entity/test_method_master_entity.dart';
import 'package:nanohospic/database/entity/unit_entity.dart';
import 'package:nanohospic/database/entity/user_entity.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
part 'app_database.g.dart';

@Database(
  version: 22,
  entities: [
    UserEntity,
    CountryEntity,
    CityEntity,
    StateEntity,
    CategoryEntity,
    SubCategoryEntity,
    HsnEntity,
    StaffEntity,
    BasEntity,
    PaymentModeEntity,
    SampleTypeEntity,
    BranchTypeEntity,
    CollectionCenterEntity,
    GroupEntity,
    TestEntity,
    PackageEntity,
    TestBOM,
    UnitEntity,
    ReferrerEntity,
    DoctorCommissionEntity,
    InstrumentEntity,
    TestMethodEntity,
    DepartmentEntity,
    DesignationEntity,
    DivisionEntity,
  ],
)
abstract class AppDatabase extends FloorDatabase {
  UserDao get userDao;
  CountryDao get countryDao;
  CityDao get cityDao;
  StateDao get stateDao;
  CategoryDao get categoryDao;
  SubCategoryDao get subcategoryDao;
  HsnDao get hsnDao;
  StaffDao get staffDao;
  BasDao get basDao;
  PaymentModeDao get paymentModeDao;
  SampleTypeDao get sampleTypeDao;
  BranchTypeDao get branchTypeDao;
  CollectionCenterDao get collectionCenterDao;
  GroupDao get groupDao;
  TestDao get testDao;
  PackageDao get packageDao;
  TestBOMDao get testBOMDao;
  UnitDao get unitDao;
  ReferrerDao get referrerDao;
  DoctorCommissionDao get doctorCommissionDao;
  InstrumentDao get instrumentDao;
  TestMethodDao get testMethodDao;
  DepartmentDao get departmentDao;
  DesignationDao get designationDao;
  DivisionDao get divisionDao;
}
