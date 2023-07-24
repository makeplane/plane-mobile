class WorkspaceModel {
  String workspaceName;
  String workspaceSlug;
  String workspaceSize;
  String workspaceId;
  String workspaceLogo;
  String workspaceUrl;

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
      workspaceSize: json['organization_size'],
      workspaceId: json['id'],
      workspaceLogo: json['logo'] ?? '',
      // workspaceUrl: json['url'],
      workspaceUrl: 'https://takeoff.plane.so/${json['slug']}',
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
