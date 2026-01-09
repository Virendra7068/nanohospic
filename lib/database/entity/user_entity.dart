import 'package:floor/floor.dart';

@Entity(tableName: 'users')
class UserEntity {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  
  @ColumnInfo(name: 'name')
  final String name;
  
  @ColumnInfo(name: 'email')
  final String email;
  
  @ColumnInfo(name: 'age')
  final int age;
  
  @ColumnInfo(name: 'created_at')
  final String createdAt;

  UserEntity({
    this.id,
    required this.name,
    required this.email,
    required this.age,
    required this.createdAt,
  });

  UserEntity copyWith({
    int? id,
    String? name,
    String? email,
    int? age,
    String? createdAt,
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      age: age ?? this.age,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'UserEntity{id: $id, name: $name, email: $email, age: $age, createdAt: $createdAt}';
  }
}