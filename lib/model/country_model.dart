// lib/models/country_model.dart
class Country {
  final int id;
  final String name;
  final DateTime? created;
  final String? createdBy;
  final DateTime? lastModified;
  final String? lastModifiedBy;
  final DateTime? deleted;
  final String? deletedBy;

  Country({
    required this.id,
    required this.name,
    this.created,
    this.createdBy,
    this.lastModified,
    this.lastModifiedBy,
    this.deleted,
    this.deletedBy,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      created: json['created'] != null ? DateTime.parse(json['created']) : null,
      createdBy: json['createdBy'],
      lastModified: json['lastModified'] != null ? DateTime.parse(json['lastModified']) : null,
      lastModifiedBy: json['lastModifiedBy'],
      deleted: json['deleted'] != null ? DateTime.parse(json['deleted']) : null,
      deletedBy: json['deletedBy'],
    );
  }

  get serverId => null;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'created': created?.toIso8601String(),
      'createdBy': createdBy,
      'lastModified': lastModified?.toIso8601String(),
      'lastModifiedBy': lastModifiedBy,
      'deleted': deleted?.toIso8601String(),
      'deletedBy': deletedBy,
    };
  }
}