// ignore_for_file: non_constant_identifier_names

import 'package:freezed_annotation/freezed_annotation.dart';

part 'cycle_detail.model.freezed.dart';
part 'cycle_detail.model.g.dart';

@freezed
class CycleDetailModel with _$CycleDetailModel {
  const factory CycleDetailModel({
    required String id,
    required OwnedBy owned_by,
    required bool is_favorite,
    required int total_issues,
    required int cancelled_issues,
    required int completed_issues,
    required int started_issues,
    required int unstarted_issues,
    required int backlog_issues,
    required List<String> assignees,
    required int total_estimates,
    required int completed_estimates,
    required int started_estimates,
    required String status,
    required String created_at,
    String? updated_at,
    required String name,
    required String description,
    String? start_date,
    String? end_date,
    required double sort_order,
    required String created_by,
    String? updated_by,
    required String project,
    required String workspace,
    required Distribution distribution,
  }) = _CycleDetailModel;

  factory CycleDetailModel.fromJson(Map<String, dynamic> json) =>
      _$CycleDetailModelFromJson(json);
}

@freezed
class OwnedBy with _$OwnedBy {
  const factory OwnedBy({
    required String id,
    required String first_name,
    required String last_name,
    required String avatar,
    required bool is_bot,
    required String display_name,
  }) = _OwnedBy;

  factory OwnedBy.fromJson(Map<String, dynamic> json) =>
      _$OwnedByFromJson(json);
}

@freezed
class Distribution with _$Distribution {
  const factory Distribution({
    required List<AssigneeDistribution> assignees,
    required List<LabelDistribution> labels,
    required CompletionChart completion_chart,
  }) = _Distribution;

  factory Distribution.fromJson(Map<String, dynamic> json) =>
      _$DistributionFromJson(json);
}

@freezed
class AssigneeDistribution with _$AssigneeDistribution {
  const factory AssigneeDistribution({
    required String first_name,
    required String last_name,
    required String assignee_id,
    required String avatar,
    required String display_name,
    required int total_issues,
    required int completed_issues,
    required int pending_issues,
  }) = _AssigneeDistribution;

  factory AssigneeDistribution.fromJson(Map<String, dynamic> json) =>
      _$AssigneeDistributionFromJson(json);
}

@freezed
class LabelDistribution with _$LabelDistribution {
  const factory LabelDistribution({
    required String label_name,
    required String color,
    required String label_id,
    required int total_issues,
    required int completed_issues,
    required int pending_issues,
  }) = _LabelDistribution;

  factory LabelDistribution.fromJson(Map<String, dynamic> json) =>
      _$LabelDistributionFromJson(json);
}

@freezed
class CompletionChart with _$CompletionChart {
  const factory CompletionChart({
    required String date,
    required int value,
  }) = _CompletionChart;

  factory CompletionChart.fromJson(Map<String, dynamic> json) =>
      _$CompletionChartFromJson(json);
}
