class PackageModel {
  final String code;
  final String name;
  final double gst;
  final double rate;
  final List<PackageTest> tests;

  PackageModel({
    required this.code,
    required this.name,
    required this.gst,
    required this.rate,
    required this.tests,
  });

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'name': name,
      'gst': gst,
      'rate': rate,
      'tests': tests.map((test) => test.toMap()).toList(),
    };
  }

  factory PackageModel.fromMap(Map<String, dynamic> map) {
    return PackageModel(
      code: map['code'] as String,
      name: map['name'] as String,
      gst: (map['gst'] as num).toDouble(),
      rate: (map['rate'] as num).toDouble(),
      tests: (map['tests'] as List<dynamic>)
          .map((test) => PackageTest.fromMap(test as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  String toString() {
    return 'PackageModel{code: $code, name: $name, gst: $gst, rate: $rate, tests: ${tests.length}}';
  }
}

class PackageTest {
  final String testName;
  final String turnAroundTime;
  final String timeUnit; // 'Hours', 'Minutes', 'Days'

  PackageTest({
    required this.testName,
    required this.turnAroundTime,
    required this.timeUnit,
  });

  Map<String, dynamic> toMap() {
    return {
      'test_name': testName,
      'turn_around_time': turnAroundTime,
      'time_unit': timeUnit,
    };
  }

  factory PackageTest.fromMap(Map<String, dynamic> map) {
    return PackageTest(
      testName: map['test_name'] as String,
      turnAroundTime: map['turn_around_time'] as String,
      timeUnit: map['time_unit'] as String,
    );
  }

  @override
  String toString() {
    return 'PackageTest{testName: $testName, turnAroundTime: $turnAroundTime, timeUnit: $timeUnit}';
  }
}