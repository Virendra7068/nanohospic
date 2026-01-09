// models/item_model.dart
class ItemMasterResponse {
  final int totalItems;
  final int currentPage;
  final int pageSize;
  final List<Item> data;

  ItemMasterResponse({
    required this.totalItems,
    required this.currentPage,
    required this.pageSize,
    required this.data,
  });

  factory ItemMasterResponse.fromJson(Map<String, dynamic> json) {
    return ItemMasterResponse(
      totalItems: json['totalItems'] ?? 0,
      currentPage: json['currentPage'] ?? 1,
      pageSize: json['pageSize'] ?? 10,
      data: (json['data'] as List? ?? [])
          .map((item) => Item.fromJson(item))
          .toList(),
    );
  }
}

class Item {
  final int id;
  final String name;
  final String code;
  final String? barcode;
  final String unit1;
  final String? unit2;
  final String packing;
  final int categoryId;
  final Category? category;
  final int? divisionId;
  final Division? division;
  final int hsnId;
  final double mrp;
  final double salesRate1;
  final double salesRate2;
  final int companyId;
  final Company? company;
  bool isSelected;

  Item({
    required this.id,
    required this.name,
    required this.code,
    this.barcode,
    required this.unit1,
    this.unit2,
    required this.packing,
    required this.categoryId,
    this.category,
    this.divisionId,
    this.division,
    required this.hsnId,
    required this.mrp,
    required this.salesRate1,
    required this.salesRate2,
    required this.companyId,
    this.company,
    this.isSelected = false,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      barcode: json['barcode'],
      unit1: json['unit1'] ?? '',
      unit2: json['unit2'],
      packing: json['packing'] ?? '',
      categoryId: json['categoryId'] ?? 0,
      category: json['category'] != null ? Category.fromJson(json['category']) : null,
      divisionId: json['divisionId'],
      division: json['division'] != null ? Division.fromJson(json['division']) : null,
      hsnId: json['hsnId'] ?? 0,
      mrp: (json['mrp'] ?? 0).toDouble(),
      salesRate1: (json['salesRate1'] ?? 0).toDouble(),
      salesRate2: (json['salesRate2'] ?? 0).toDouble(),
      companyId: json['companyId'] ?? 0,
      company: json['company'] != null ? Company.fromJson(json['company']) : null,
      isSelected: false,
    );
  }

  Item copyWith({bool? isSelected}) {
    return Item(
      id: id,
      name: name,
      code: code,
      barcode: barcode,
      unit1: unit1,
      unit2: unit2,
      packing: packing,
      categoryId: categoryId,
      category: category,
      divisionId: divisionId,
      division: division,
      hsnId: hsnId,
      mrp: mrp,
      salesRate1: salesRate1,
      salesRate2: salesRate2,
      companyId: companyId,
      company: company,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

class Category {
  final int id;
  final String categoryName;

  Category({required this.id, required this.categoryName});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? 0,
      categoryName: json['categoryName'] ?? '',
    );
  }
}

class Division {
  final int id;
  final String name;
  final Company? company;

  Division({required this.id, required this.name, this.company});

  factory Division.fromJson(Map<String, dynamic> json) {
    return Division(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      company: json['company'] != null ? Company.fromJson(json['company']) : null,
    );
  }
}

class Company {
  final int id;
  final String name;

  Company({required this.id, required this.name});

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(id: json['id'] ?? 0, name: json['name'] ?? '');
  }
}