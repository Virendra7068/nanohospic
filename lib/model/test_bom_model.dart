// test_bom_model.dart
import 'dart:convert';

enum GenderType { male, female, both, na }

class TestBOM {
  final String code;
  final String name;
  final String testGroup;
  final GenderType genderType;
  final String? description;
  final double rate;
  final double gst;
  final String turnAroundTime;
  final String timeUnit;
  final bool isActive;
  final String? method;
  final DateTime createdAt;
  final String createdBy;
  final List<TestParameter> parameters;

  TestBOM({
    required this.code,
    required this.name,
    required this.testGroup,
    required this.genderType,
    this.description,
    required this.rate,
    required this.gst,
    required this.turnAroundTime,
    required this.timeUnit,
    this.isActive = true,
    this.method,
    required this.createdAt,
    required this.createdBy,
    required this.parameters,
  });

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'name': name,
      'testGroup': testGroup,
      'genderType': genderType.toString(),
      'description': description,
      'rate': rate,
      'gst': gst,
      'turnAroundTime': turnAroundTime,
      'timeUnit': timeUnit,
      'isActive': isActive ? 1 : 0,
      'method': method,
      'createdAt': createdAt.toIso8601String(),
      'createdBy': createdBy,
      'parameters': json.encode(parameters.map((p) => p.toMap()).toList()),
    };
  }

  factory TestBOM.fromMap(Map<String, dynamic> map) {
    return TestBOM(
      code: map['code'] ?? '',
      name: map['name'] ?? '',
      testGroup: map['testGroup'] ?? '',
      genderType: _parseGenderType(map['genderType']),
      description: map['description'],
      rate: map['rate']?.toDouble() ?? 0.0,
      gst: map['gst']?.toDouble() ?? 0.0,
      turnAroundTime: map['turnAroundTime'] ?? '',
      timeUnit: map['timeUnit'] ?? 'hours',
      isActive: map['isActive'] == 1,
      method: map['method'],
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      createdBy: map['createdBy'] ?? 'system',
      parameters: List<Map<String, dynamic>>.from(json.decode(map['parameters'] ?? '[]'))
          .map((p) => TestParameter.fromMap(p))
          .toList(),
    );
  }

  static GenderType _parseGenderType(String? type) {
    if (type == null) return GenderType.both;
    switch (type) {
      case 'GenderType.male': return GenderType.male;
      case 'GenderType.female': return GenderType.female;
      case 'GenderType.na': return GenderType.na;
      default: return GenderType.both;
    }
  }
}

class TestParameter {
  final String testName;
  final String? minValue;
  final String? maxValue;
  final String? testMethod;
  final String? unit;
  final String? description;

  TestParameter({
    required this.testName,
    this.minValue,
    this.maxValue,
    this.testMethod,
    this.unit,
    this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'testName': testName,
      'minValue': minValue,
      'maxValue': maxValue,
      'testMethod': testMethod,
      'unit': unit,
      'description': description,
    };
  }

  factory TestParameter.fromMap(Map<String, dynamic> map) {
    return TestParameter(
      testName: map['testName'] ?? '',
      minValue: map['minValue'],
      maxValue: map['maxValue'],
      testMethod: map['testMethod'],
      unit: map['unit'],
      description: map['description'],
    );
  }
}