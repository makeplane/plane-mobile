// ignore_for_file: non_constant_identifier_names

import 'package:plane/models/project/issue-filter-and-properties/issue_filter_and_properties.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'view_model.freezed.dart';
part 'view_model.g.dart';

@freezed
class ViewModel with _$ViewModel{

  const factory ViewModel({
    required String id,
    required bool is_favorite,
    required String created_at,
    required String updated_at,
    required String name,
    required String? description,
    required FiltersModel filters,
    required DisplayFiltersModel display_filters,
    required DisplayPropertiesModel display_properties,
    required int access,
    required double sort_order,
    required String created_by,
    required String updated_by,
    required String workspace,
    required String project,
  }) = _ViewModel;

  factory ViewModel.fromJson(Map<String, dynamic> json) =>
      _$ViewModelFromJson(json);

}

