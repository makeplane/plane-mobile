
// ignore_for_file: non_constant_identifier_names

import 'package:freezed_annotation/freezed_annotation.dart';
part 'project_member.model.freezed.dart';
part 'project_member.model.g.dart';

@freezed
class ProjectMemberLite with _$ProjectMemberLite{
  
  const factory ProjectMemberLite({
    required String id,
    String? member_avatar,
    required String member_display_name,
    required String member_id,
  })= _ProjectMemberLite;

  factory ProjectMemberLite.fromJson(Map<String, dynamic> json) =>
      _$ProjectMemberLiteFromJson(json);
}