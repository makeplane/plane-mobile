// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'states_model.freezed.dart';
part 'states_model.g.dart';

@freezed
class StatesModel with _$StatesModel {
  const factory StatesModel({
    required final String id,
    required final String project_id,
    required final String workspace_id,
    required final String name,
    required final String color,
    required final String group,
    @JsonKey(name: 'default')
    required final bool is_default,
    required final String? description,
    required final double sequence,
    @JsonKey(includeFromJson: false, includeToJson: false)
    Widget? stateIcon,
  }) = _StatesModel;

  factory StatesModel.fromJson(Map<String, dynamic> json) =>
      _$StatesModelFromJson(json);

  factory StatesModel.initialize() {
    return  const StatesModel(
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
