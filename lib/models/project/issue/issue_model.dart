// ignore_for_file: non_constant_identifier_names, invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
part 'issue_model.freezed.dart';
part 'issue_model.g.dart';

@freezed
class IssueModel with _$IssueModel {
  const factory IssueModel({
    required String id,
    required String name,
    required String state_id,
    required String description_html,
    required double sort_order,
    String? completed_at,
    String? estimate_point,
    required String priority,
    String? start_date,
    String? target_date,
    required int sequence_id,
    required String project_id,
    String? parent_id,
    String? cycle_id,
    String? module_id,
    @JsonKey(defaultValue: []) required List<String> label_ids,
    @JsonKey(defaultValue: []) required List<String> assignee_ids,
    required int sub_issues_count,
    required String created_at,
    required String updated_at,
    required String created_by,
    required String updated_by,
    required int attachment_count,
    required int link_count,
    required bool is_draft,
    String? archived_at,
  }) = _IssueModel;

  factory IssueModel.fromJson(Map<String, dynamic> json) =>
      _$IssueModelFromJson(json);

  factory IssueModel.initial() => const IssueModel(
        id: '',
        name: '',
        state_id: '',
        description_html: '',
        sort_order: 0,
        completed_at: '',
        estimate_point: '',
        priority: '',
        start_date: '',
        target_date: '',
        sequence_id: 0,
        project_id: '',
        parent_id: '',
        cycle_id: '',
        module_id: '',
        label_ids: [],
        assignee_ids: [],
        sub_issues_count: 0,
        created_at: '',
        updated_at: '',
        created_by: '',
        updated_by: '',
        attachment_count: 0,
        link_count: 0,
        is_draft: false,
        archived_at: '',
      );
}
