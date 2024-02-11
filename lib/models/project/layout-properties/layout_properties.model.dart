// ignore_for_file: non_constant_identifier_names

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:plane/models/project/issue-filter-properties-and-view/issue_filter_and_properties.dart';

part 'layout_properties.model.freezed.dart';
part 'layout_properties.model.g.dart';

@freezed
class LayoutPropertiesModel with _$LayoutPropertiesModel {
  const factory LayoutPropertiesModel({
    required String id,
    required String created_at,
    String? updated_at,
    required FiltersModel filters,
    required DisplayFiltersModel display_filters,
    required DisplayPropertiesModel display_properties,
    String? created_by,
    String? updated_by,
    required String project,
    required String workspace,
    required String user,
  }) = _LayoutPropertiesModel;

  factory LayoutPropertiesModel.fromJson(Map<String, dynamic> json) =>
      _$LayoutPropertiesModelFromJson(json);

  factory LayoutPropertiesModel.initial() => LayoutPropertiesModel(
        id: '',
        created_at: '',
        updated_at: '',
        filters: const FiltersModel(),
        display_filters: DisplayFiltersModel.initial(),
        display_properties: const DisplayPropertiesModel(),
        created_by: '',
        updated_by: '',
        project: '',
        workspace: '',
        user: '',
      );
}
