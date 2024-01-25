// ignore_for_file: non_constant_identifier_names, invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
part 'issue_filter_and_properties.freezed.dart';
part 'issue_filter_and_properties.g.dart';

@freezed
class FiltersModel with _$FiltersModel{

  const factory FiltersModel({
    required List<String>? priority,
    required List<String>? state,
    required List<String>? assignees,
    required List<String>? labels,
    required List<String>? created_by,
    required List<String>? target_date,
  }) = _FiltersModel;

  factory FiltersModel.fromJson(Map<String, dynamic> json) =>
      _$FiltersModelFromJson(json);

}

@freezed
class DisplayFiltersModel with _$DisplayFiltersModel{
  const factory DisplayFiltersModel({

    required String? type,
    required String layout,
    required String? group_by,
    required String order_by,
    required bool sub_issue,
    required bool show_empty_groups,
    required String calendar_date_range,
  }) = _DisplayFiltersModel;

  factory DisplayFiltersModel.fromJson(Map<String, dynamic> json) =>
      _$DisplayFiltersModelFromJson(json);

}

@freezed
class DisplayPropertiesModel with _$DisplayPropertiesModel{

  const factory DisplayPropertiesModel({
    @JsonKey(defaultValue: false)
    required bool key,
    @JsonKey(defaultValue: false)
    required bool link,
    @JsonKey(defaultValue: false)
    required bool state,
    @JsonKey(defaultValue: false)
    required bool labels,
    @JsonKey(defaultValue: false)
    required bool assignee,
    @JsonKey(defaultValue: false)
    required bool due_date,
    @JsonKey(defaultValue: false)
    required bool estimate,
    @JsonKey(defaultValue: false)
    required bool priority,
    @JsonKey(defaultValue: false)
    required bool created_on,
    @JsonKey(defaultValue: false)
    required bool start_date,
    @JsonKey(defaultValue: false)
    required bool updated_on,
    @JsonKey(defaultValue: false)
    required bool sub_issue_count,
    @JsonKey(defaultValue: false)
    required bool attachment_count,
  }) = _DisplayPropertiesModel;

  factory DisplayPropertiesModel.fromJson(Map<String, dynamic> json) =>
      _$DisplayPropertiesModelFromJson(json);

}