// ignore_for_file: non_constant_identifier_names

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:plane/models/project/project-member/project_member.model.dart';
import 'package:plane/models/workspace/workspace_model.dart';
import 'package:plane/utils/enums.dart';

part 'project.model.freezed.dart';
part 'project.model.g.dart';

@freezed
class ProjectLiteModel with _$ProjectLiteModel {
  const factory ProjectLiteModel({
    required String id,
    required String identifier,
    required String name,
    required String description,
    required String emoji,
  }) = _ProjectLiteModel;

  factory ProjectLiteModel.fromJson(Map<String, dynamic> json) =>
      _$ProjectLiteModelFromJson(json);
}


@freezed
class ProjectModel with _$ProjectModel {
  const factory ProjectModel({
    required int archive_in,
    required int close_in,
    required DateTime created_at,
    required String created_by,
    required String? cover_image,
    required bool cycle_view,
    required bool issue_views_view,
    required bool module_view,
    required bool page_view,
    required bool inbox_view,
    String? default_assigne,
    String? default_state,
    required String description,
    String? emoji,
    String? estimate,
    IconProp? icon_prop,
    required String id,
    required String identifier,
    required bool is_deployed,
    required bool is_favorite,
    required bool is_member,
    Role? member_role,
    required List<ProjectMemberLite> members,
    required String name,
    required int network,
    String? project_lead,
    required int? sort_order,
    required int total_cycles,
    required int total_members,
    required int total_modules,
    required DateTime updated_at,
    required String updated_by,
    required String workspace,
    required WorkspaceLiteModel workspace_detail,
  }) = _ProjectModel;

  factory ProjectModel.fromJson(Map<String, dynamic> json) =>
      _$ProjectModelFromJson(json);
}

@freezed
class IconProp with _$IconProp {
  const factory IconProp({
    required final String name,
    required final String color,
  }) = _IconProp;

  factory IconProp.fromJson(Map<String, dynamic> json) =>
      _$IconPropFromJson(json);
}


