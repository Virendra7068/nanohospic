import '../app_database.dart';
import '../entity/user_entity.dart';

class UserRepository {
  final AppDatabase _database;

  UserRepository(this._database);

  Future<List<UserEntity>> getAllUsers() async {
    return await _database.userDao.getAllUsers();
  }

  Future<UserEntity?> getUserById(int id) async {
    return await _database.userDao.getUserById(id);
  }

  Future<UserEntity?> getUserByEmail(String email) async {
    return await _database.userDao.getUserByEmail(email);
  }

  Future<List<UserEntity>> searchUsers(String query) async {
    return await _database.userDao.searchUsers('%$query%');
  }

  Future<int> insertUser(UserEntity user) async {
    return await _database.userDao.insertUser(user);
  }

  Future<int> updateUser(UserEntity user) async {
    return await _database.userDao.updateUser(user);
  }

  Future<int> deleteUser(UserEntity user) async {
    return await _database.userDao.deleteUser(user);
  }

  Future<void> deleteAllUsers() async {
    return await _database.userDao.deleteAllUsers();
  }
}