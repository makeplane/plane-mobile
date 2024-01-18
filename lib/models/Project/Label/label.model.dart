// ignore_for_file: non_constant_identifier_names

import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:plane/models/Project/project.model.dart';
import 'package:plane/models/Workspace/workspace_model.dart';
part 'label.model.freezed.dart';
part 'label.model.g.dart';

@freezed
class LabelModel with _$LabelModel {
  const factory LabelModel({
    required String id,
    required DateTime created_at,
    required DateTime updated_at,
    required String name,
    required String description,
    required String color,
    required String created_by,
    required String updated_by,
    required String project,
    required ProjectLiteModel project_detail,
    required String workspace,
    required WorkspaceLiteModel workspace_detail,
    String? parent,
    required double sort_order,
  }) = _LabelModel;

  factory LabelModel.fromJson(Map<String, dynamic> json) =>
      _$LabelModelFromJson(json);
}
