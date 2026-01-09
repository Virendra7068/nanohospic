// lib/model/hsn_model.dart
class HsnModel {
  final int id;
  final String hsnCode;
  final double sgst;
  final double cgst;
  final double igst;
  final double cess;
  final int? hsnType;
  final String? tenant;
  final String? tenantId;
  final DateTime created;
  final String createdBy;
  final DateTime? lastModified;
  final String? lastModifiedBy;
  final DateTime? deleted;
  final String? deletedBy;

  HsnModel({
    required this.id,
    required this.hsnCode,
    required this.sgst,
    required this.cgst,
    required this.igst,
    required this.cess,
    this.hsnType,
    this.tenant,
    this.tenantId,
    required this.created,
    required this.createdBy,
    this.lastModified,
    this.lastModifiedBy,
    this.deleted,
    this.deletedBy,
  });

  factory HsnModel.fromJson(Map<String, dynamic> json) {
    return HsnModel(
      id: json['id'] ?? 0,
      hsnCode: json['hsnCode'] ?? '',
      sgst: (json['sgst'] ?? 0).toDouble(),
      cgst: (json['cgst'] ?? 0).toDouble(),
      igst: (json['igst'] ?? 0).toDouble(),
      cess: (json['cess'] ?? 0).toDouble(),
      hsnType: json['hsnType'],
      tenant: json['tenant'],
      tenantId: json['tenantId'],
      created: json['created'] != null
          ? DateTime.parse(json['created'])
          : DateTime.now(),
      createdBy: json['createdBy'] ?? 'System',
      lastModified: json['lastModified'] != null
          ? DateTime.parse(json['lastModified'])
          : null,
      lastModifiedBy: json['lastModifiedBy'],
      deleted: json['deleted'] != null ? DateTime.parse(json['deleted']) : null,
      deletedBy: json['deletedBy'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hsnCode': hsnCode,
      'sgst': sgst,
      'cgst': cgst,
      'igst': igst,
      'cess': cess,
      'hsnType': hsnType,
      'tenant': tenant,
      'tenantId': tenantId,
      'created': created.toIso8601String(),
      'createdBy': createdBy,
      'lastModified': lastModified?.toIso8601String(),
      'lastModifiedBy': lastModifiedBy,
      'deleted': deleted?.toIso8601String(),
      'deletedBy': deletedBy,
    };
  }

  // For creating new HSN
  factory HsnModel.createNew({
    required String hsnCode,
    double sgst = 0,
    double cgst = 0,
    double igst = 0,
    double cess = 0,
    int? hsnType,
    String? tenant,
    String? tenantId,
  }) {
    return HsnModel(
      id: 0,
      hsnCode: hsnCode,
      sgst: sgst,
      cgst: cgst,
      igst: igst,
      cess: cess,
      hsnType: hsnType,
      tenant: tenant,
      tenantId: tenantId,
      created: DateTime.now(),
      createdBy: 'User',
    );
  }

  // Check if HSN is valid
  bool isValid() {
    return hsnCode.isNotEmpty;
  }

  // Check if HSN is deleted
  bool get isDeleted => deleted != null;

  // Get tax summary
  Map<String, double> get taxSummary {
    return {
      'sgst': sgst,
      'cgst': cgst,
      'igst': igst,
      'cess': cess,
      'total': sgst + cgst + igst + cess,
    };
  }
}