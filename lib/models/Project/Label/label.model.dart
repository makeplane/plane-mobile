// ignore_for_file: non_constant_identifier_names

import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:plane/models/Project/project.model.dart';
import 'package:plane/models/Workspace/workspace_model.dart';
part 'label.model.freezed.dart';
part 'label.model.g.dart';

@freezed
class LabelModel with _$LabelModel {
  const factory LabelModel({
    String? parent,
    required String name,
    required String color,
    required String id,
    required String project_id,
    required String workspace_id,
    required double sort_order,
  }) = _LabelModel;

  factory LabelModel.fromJson(Map<String, dynamic> json) =>
      _$LabelModelFromJson(json);
}
