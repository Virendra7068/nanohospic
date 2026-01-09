class Category {
  final int id;
  final String categoryName;
  final DateTime? created;
  final String? createdBy;
  final DateTime? lastModified;
  final String? lastModifiedBy;
  final bool? deleted;
  final String? deletedBy;

  Category({
    required this.id,
    required this.categoryName,
    this.created,
    this.createdBy,
    this.lastModified,
    this.lastModifiedBy,
    this.deleted,
    this.deletedBy,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
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