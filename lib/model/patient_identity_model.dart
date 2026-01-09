// ignore_for_file: avoid_print

import 'package:nanohospic/database/entity/patient_identity_entity.dart';

class Bas {
  final int id;
  final String name;

  Bas({
    required this.id,
    required this.name,
  });

  factory Bas.fromJson(Map<String, dynamic> json) {
    return Bas(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  @override
  String toString() {
    return 'Bas(id: $id, name: $name)';
  }

  factory Bas.fromEntity(BasEntity entity) {
    return Bas(
      id: entity.serverId ?? entity.id ?? 0,
      name: entity.name,
    );
  }

  BasEntity toEntity() {
    return BasEntity(
      serverId: id > 0 ? id : null,
      name: name,
      createdAt: DateTime.now().toIso8601String(),
    );
  }
}