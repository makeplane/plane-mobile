// ignore_for_file: non_constant_identifier_names, invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
part 'issue_filter_and_properties.freezed.dart';
part 'issue_filter_and_properties.g.dart';

@freezed
class FiltersModel with _$FiltersModel {
  const factory FiltersModel({
    @Default([]) List<String> priority,
    @Default([]) List<String> state,
    @Default([]) List<String> state_group,
    @Default([]) List<String> assignees,
    @Default([]) List<String> mentions,
    @Default([]) List<String> labels,
    @Default([]) List<String> start_date,
    @Default([]) List<String> created_by,
    @Default([]) List<String> target_date,
    @Default([]) List<String> project,
    @Default([]) List<String> subscriber,
  }) = _FiltersModel;

  factory FiltersModel.fromJson(Map<String, dynamic> json) =>
      _$FiltersModelFromJson(json);
}

@freezed
class DisplayFiltersModel with _$DisplayFiltersModel {
  const factory DisplayFiltersModel({
    required String? type,
    required String layout,
    required DisplayFilterCalendarModel? calendar,
    required String? group_by,
    required String order_by,
    required bool sub_issue,
    required bool show_empty_groups,
    bool? start_target_date,
    String? calendar_date_range,
  }) = _DisplayFiltersModel;

  factory DisplayFiltersModel.fromJson(Map<String, dynamic> json) =>
      _$DisplayFiltersModelFromJson(json);

  factory DisplayFiltersModel.initial() => const DisplayFiltersModel(
        type: 'all',
        layout: 'kanban',
        group_by: 'state',
        order_by: '',
        sub_issue: false,
        show_empty_groups: false,
        start_target_date: false,
        calendar: DisplayFilterCalendarModel(
          layout: 'month',
          show_weekends: false,
        ),
      );
}

@freezed
class DisplayFilterCalendarModel with _$DisplayFilterCalendarModel {
  const factory DisplayFilterCalendarModel({
    required String layout,
    required bool show_weekends,
  }) = _DisplayFilterCalendarModel;

  factory DisplayFilterCalendarModel.fromJson(Map<String, dynamic> json) =>
      _$DisplayFilterCalendarModelFromJson(json);
}

@freezed
class DisplayPropertiesModel with _$DisplayPropertiesModel {
  const factory DisplayPropertiesModel({
    @Default(false) bool key,
    @Default(false) bool state,
    @Default(false) bool link,
    @Default(false) bool labels,
    @Default(false) bool assignee,
    @Default(false) bool due_date,
    @Default(false) bool estimate,
    @Default(false) bool priority,
    @Default(false) bool created_on,
    @Default(false) bool start_date,
    @Default(false) bool updated_on,
    @Default(false) bool sub_issue_count,
    @Default(false) bool attachment_count,
  }) = _DisplayPropertiesModel;

  factory DisplayPropertiesModel.fromJson(Map<String, dynamic> json) =>
      _$DisplayPropertiesModelFromJson(json);
}
