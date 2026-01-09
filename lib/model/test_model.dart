class TestModel {
  final String code;
  final String name;
  final String group;
  final double mrp;
  final double salesRateA;
  final double salesRateB;
  final String? hsnSac;
  final int gst;
  final String? barcode;
  final double minValue;
  final double maxValue;
  final String unit;

  TestModel({
    required this.code,
    required this.name,
    required this.group,
    required this.mrp,
    required this.salesRateA,
    required this.salesRateB,
    this.hsnSac,
    required this.gst,
    this.barcode,
    required this.minValue,
    required this.maxValue,
    required this.unit,
  });

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'name': name,
      'product_group': group,
      'mrp': mrp,
      'sales_rate_a': salesRateA,
      'sales_rate_b': salesRateB,
      'hsn_sac': hsnSac,
      'gst': gst,
      'barcode': barcode,
      'min_value': minValue,
      'max_value': maxValue,
      'unit': unit,
      'created_at': DateTime.now().toIso8601String(),
      'is_synced': 0,
      'sync_status': 'pending',
      'is_deleted': 0,
    };
  }

  factory TestModel.fromMap(Map<String, dynamic> map) {
    return TestModel(
      code: map['code'] as String,
      name: map['name'] as String,
      group: map['product_group'] as String,
      mrp: (map['mrp'] as num).toDouble(),
      salesRateA: (map['sales_rate_a'] as num).toDouble(),
      salesRateB: (map['sales_rate_b'] as num).toDouble(),
      hsnSac: map['hsn_sac'] as String?,
      gst: map['gst'] as int,
      barcode: map['barcode'] as String?,
      minValue: (map['min_value'] as num).toDouble(),
      maxValue: (map['max_value'] as num).toDouble(),
      unit: map['unit'] as String,
    );
  }

  @override
  String toString() {
    return 'TestModel{code: $code, name: $name, group: $group}';
  }
}