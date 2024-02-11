import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:plane/config/config_variables.dart';
part 'workspace_model.freezed.dart';
part 'workspace_model.g.dart';

class WorkspaceModel {
  WorkspaceModel({
    required this.workspaceName,
    required this.workspaceSlug,
    required this.workspaceSize,
    required this.workspaceId,
    required this.workspaceLogo,
    required this.workspaceUrl,
  });
  factory WorkspaceModel.fromJson(Map<String, dynamic> json) {
    return WorkspaceModel(
      workspaceName: json['name'],
      workspaceSlug: json['slug'],
      workspaceSize: json['organization_size']??'',
      workspaceId: json['id'],
      workspaceLogo: json['logo'] ?? '',
      // workspaceUrl: json['url'],
      workspaceUrl: '${Config.webUrl}${json['slug']}',
    );
  }
  String workspaceName;
  String workspaceSlug;
  String workspaceSize;
  String workspaceId;
  String workspaceLogo;
  String workspaceUrl;

  static WorkspaceModel initialize(
      {String? workspaceName,
      String? workspaceSlug,
      String? workspaceSize,
      String? workspaceId,
      String? workspaceLogo,
      String? workspaceUrl}) {
    return WorkspaceModel(
      workspaceName: workspaceName ?? '',
      workspaceSlug: workspaceSlug ?? '',
      workspaceSize: workspaceSize ?? '',
      workspaceId: workspaceId ?? '',
      workspaceLogo: workspaceLogo ?? '',
      workspaceUrl: workspaceUrl ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'name': workspaceName,
        'slug': workspaceSlug,
        'company_size': workspaceSize,
        'id': workspaceId,
        'logo': workspaceLogo,
        'url': workspaceUrl,
      };
}

@freezed
class WorkspaceLiteModel with _$WorkspaceLiteModel {
  const factory WorkspaceLiteModel({
    required final String id,
    required final String name,
    required final String slug,
  }) = _WorkspaceLiteModel;
  factory WorkspaceLiteModel.fromJson(Map<String, dynamic> json) =>
      _$WorkspaceLiteModelFromJson(json);
}
