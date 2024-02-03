// ignore_for_file: non_constant_identifier_names
import 'package:freezed_annotation/freezed_annotation.dart';
import 'cycle_detail.model.dart';

part 'cycle.model.freezed.dart';
part 'cycle.model.g.dart';

@freezed
class CycleModel with _$CycleModel {
  const factory CycleModel({
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
  }) = _CycleModel;

  factory CycleModel.fromJson(Map<String, dynamic> json) =>
      _$CycleModelFromJson(json);
}
