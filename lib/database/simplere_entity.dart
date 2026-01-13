// lib/database/entity/simple_patient.dart
import 'package:floor/floor.dart';

@Entity(tableName: 'simple_patients')
class SimplePatient {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  
  @ColumnInfo(name: 'name')
  final String name;
  
  @ColumnInfo(name: 'uhid')
  final String uhid;

  SimplePatient({
    this.id,
    required this.name,
    required this.uhid,
  });
}