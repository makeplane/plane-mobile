import 'package:flutter/material.dart';

class StatesModel {
  StatesModel(
      {required this.id,
      this.createdAt,
      this.updatedAt,
      this.name,
      this.description,
      this.color,
      this.slug,
      this.sequence,
      this.group,
      this.isDefault,
      this.externalSource,
      this.externalId,
      this.createdBy,
      this.updatedBy,
      this.project,
      this.workspace,
      this.stateIcon});

  factory StatesModel.fromJson(Map<String, dynamic> json) {
    return StatesModel(
        id: json['id'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
        name: json['name'],
        description: json['description'],
        color: json['color'],
        slug: json['slug'],
        sequence: json['sequence']?.toDouble(),
        group: json['group'],
        isDefault: json['default'],
        externalSource: json['external_source'],
        externalId: json['external_id'],
        createdBy: json['created_by'],
        updatedBy: json['updated_by'],
        project: json['project'],
        workspace: json['workspace'],
        stateIcon: null);
  }

  final String id;
  final String? createdAt;
  final String? updatedAt;
  final String? name;
  final String? description;
  final String? color;
  final String? slug;
  final double? sequence;
  final String? group;
  final bool? isDefault;
  final String? externalSource;
  final String? externalId;
  final String? createdBy;
  final String? updatedBy;
  final String? project;
  final String? workspace;
  Widget? stateIcon;

  StatesModel empty() {
    return StatesModel(
      id: '',
      createdAt: '',
      updatedAt: '',
      name: '',
      description: '',
      color: '',
      slug: '',
      sequence: 0,
      group: '',
      isDefault: false,
      externalSource: '',
      externalId: '',
      createdBy: '',
      updatedBy: '',
      project: '',
      workspace: '',
      stateIcon: null
    );
  }
}
