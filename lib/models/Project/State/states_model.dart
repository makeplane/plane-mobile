// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'states_model.freezed.dart';
part 'states_model.g.dart';

@freezed
class StatesModel with _$StatesModel {
  const factory StatesModel({
    required final String id,
    required final String created_at,
    required final String updated_at,
    required final String name,
    required final String? description,
    required final String color,
    required final String slug,
    required final double sequence,
    required final String group,
    required final bool? is_default,
    required final String? external_source,
    required final String? external_id,
    required final String created_by,
    required final String? updated_by,
    required final String project,
    required final String workspace,
    @JsonKey(includeFromJson: false, includeToJson: false)
    Widget? stateIcon,
  }) = _StatesModel;

  factory StatesModel.fromJson(Map<String, dynamic> json) =>
      _$StatesModelFromJson(json);

  factory StatesModel.initialize() {
    return const StatesModel(
        id: '',
        created_at: '',
        updated_at: '',
        name: '',
        description: '',
        color: '',
        slug: '',
        sequence: 0,
        group: '',
        is_default: false,
        external_source: '',
        external_id: '',
        created_by: '',
        updated_by: '',
        project: '',
        workspace: '',
        stateIcon: null);
  }
}
