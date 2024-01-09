class UserSettingModel {
  UserSettingModel({
    required this.id,
    required this.email,
    required this.workspace,
  });

  factory UserSettingModel.fromJson(Map<String, dynamic> json) {
    return UserSettingModel(
      id: json['id'],
      email: json['email'],
      workspace: WorkspaceModel.fromJson(json['workspace']),
    );
  }

  final String id;
  final String email;
  final WorkspaceModel workspace;

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'workspace': workspace.toJson(),
      };

  //initialize the user setting

  static UserSettingModel initialize() {
    return UserSettingModel(
      id: '',
      email: '',
      workspace: WorkspaceModel.initialize(),
    );
  }
}

class WorkspaceModel {
  WorkspaceModel({
    required this.lastWorkspaceId,
    required this.lastWorkspaceSlug,
    required this.fallbackWorkspaceId,
    required this.fallbackWorkspaceSlug,
    required this.invites,
  });

  factory WorkspaceModel.fromJson(Map<String, dynamic> json) {
    return WorkspaceModel(
      lastWorkspaceId: json['last_workspace_id'],
      lastWorkspaceSlug: json['last_workspace_slug'],
      fallbackWorkspaceId: json['fallback_workspace_id'],
      fallbackWorkspaceSlug: json['fallback_workspace_slug'],
      invites: json['invites'],
    );
  }
  final String lastWorkspaceId;
  final String lastWorkspaceSlug;
  final String fallbackWorkspaceId;
  final String fallbackWorkspaceSlug;
  final int invites;

  Map<String, dynamic> toJson() => {
        'last_workspace_id': lastWorkspaceId,
        'last_workspace_slug': lastWorkspaceSlug,
        'fallback_workspace_id': fallbackWorkspaceId,
        'fallback_workspace_slug': fallbackWorkspaceSlug,
        'invites': invites,
      };

  //initialize the workspace

  static WorkspaceModel initialize() {
    return WorkspaceModel(
      lastWorkspaceId: '',
      lastWorkspaceSlug: '',
      fallbackWorkspaceId: '',
      fallbackWorkspaceSlug: '',
      invites: 0,
    );
  }
}
