class CurrentRouteDetail {
  String? workspaceSlug;
  String? projectId;
  String? cycleId;
  String? moduleId;
  String? viewId;
  String? issueId;

  CurrentRouteDetail({
    required this.workspaceSlug,
    required this.projectId,
    required this.cycleId,
    required this.moduleId,
    required this.viewId,
    required this.issueId,
  });

  CurrentRouteDetail copyWith({
    String? workspaceSlug,
    String? projectId,
    String? cycleId,
    String? moduleId,
    String? viewId,
    String? issueId,
  }) {
    return CurrentRouteDetail(
      workspaceSlug: workspaceSlug ?? this.workspaceSlug,
      projectId: projectId ?? this.projectId,
      cycleId: cycleId ?? this.cycleId,
      moduleId: moduleId ?? this.moduleId,
      viewId: viewId ?? this.viewId,
      issueId: issueId ?? this.issueId,
    );
  }

  factory CurrentRouteDetail.initial() {
    return CurrentRouteDetail(
      workspaceSlug: null,
      projectId: null,
      cycleId: null,
      moduleId: null,
      viewId: null,
      issueId: null,
    );
  }

  void update({
    String? workspaceSlug,
    String? projectId,
    String? cycleId,
    String? moduleId,
    String? viewId,
    String? issueId,
  }) {
    currentRouteDetails.workspaceSlug = workspaceSlug ?? this.workspaceSlug;
    currentRouteDetails.projectId = projectId ?? this.projectId;
    currentRouteDetails.cycleId = cycleId ?? this.cycleId;
    currentRouteDetails.moduleId = moduleId ?? this.moduleId;
    currentRouteDetails.viewId = viewId ?? this.viewId;
    currentRouteDetails.issueId = issueId ?? this.issueId;
  }
}

CurrentRouteDetail currentRouteDetails = CurrentRouteDetail.initial();
