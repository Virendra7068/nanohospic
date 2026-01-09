import 'package:floor/floor.dart';
import '../entity/user_entity.dart';

@dao
abstract class UserDao {
  @Query('SELECT * FROM users ORDER BY created_at DESC')
  Future<List<UserEntity>> getAllUsers();
  
  @Query('SELECT * FROM users WHERE id = :id')
  Future<UserEntity?> getUserById(int id);
  
  @Query('SELECT * FROM users WHERE email = :email')
  Future<UserEntity?> getUserByEmail(String email);
  
  @Query('SELECT * FROM users WHERE name LIKE :search')
  Future<List<UserEntity>> searchUsers(String search);
  
  @Insert()
  Future<int> insertUser(UserEntity user);
  
  @Update()
  Future<int> updateUser(UserEntity user);
  
  @delete
  Future<int> deleteUser(UserEntity user);
  
  @Query('DELETE FROM users WHERE id = :id')
  Future<int?> deleteUserById(int id);
  
  @Query('DELETE FROM users')
  Future<void> deleteAllUsers();
}