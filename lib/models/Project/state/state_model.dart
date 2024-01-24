// ignore_for_file: non_constant_identifier_names, invalid_annotation_target

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'state_model.freezed.dart';
part 'state_model.g.dart';

@freezed
class StateModel with _$StateModel {
  const factory StateModel({
    required final String id,
    required final String project_id,
    required final String workspace_id,
    required final String name,
    required final String color,
    required final String group,
    @JsonKey(name: 'default') required final bool is_default,
    required final String? description,
    required final double sequence,
    @JsonKey(includeFromJson: false, includeToJson: false) Widget? stateIcon,
  }) = _StateModel;

  factory StateModel.fromJson(Map<String, dynamic> json) =>
      _$StateModelFromJson(json);

  factory StateModel.initialize() {
    return const StateModel(
      id: '',
      project_id: '',
      workspace_id: '',
      name: '',
      color: '',
      group: '',
      is_default: false,
      description: '',
      sequence: 0,
      stateIcon: null,
    );
  }
}
