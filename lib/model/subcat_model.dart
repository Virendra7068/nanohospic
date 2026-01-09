class SubCategory {
  final int id;
  final String name;
  final int categoryId;
  final String? categoryName;
  final DateTime? created;
  final String? createdBy;
  final DateTime? lastModified;
  final String? lastModifiedBy;
  final bool? deleted;
  final String? deletedBy;

  SubCategory({
    required this.id,
    required this.name,
    required this.categoryId,
    this.categoryName,
    this.created,
    this.createdBy,
    this.lastModified,
    this.lastModifiedBy,
    this.deleted,
    this.deletedBy,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      id: json['id'],
      name: json['name'],
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
      created: json['created'] != null ? DateTime.parse(json['created']) : null,
      createdBy: json['createdBy'],
      lastModified: json['lastModified'] != null ? DateTime.parse(json['lastModified']) : null,
      lastModifiedBy: json['lastModifiedBy'],
      deleted: json['deleted'],
      deletedBy: json['deletedBy'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'created': created?.toIso8601String(),
      'createdBy': createdBy,
      'lastModified': lastModified?.toIso8601String(),
      'lastModifiedBy': lastModifiedBy,
      'deleted': deleted,
      'deletedBy': deletedBy,
    };
  }
}