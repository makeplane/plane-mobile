class UserSubscribedIssuesModel {
  UserSubscribedIssuesModel({
    this.id,
    this.workspaceDetail,
    this.projectDetail,
    this.stateDetail,
    this.labelDetails,
    this.assigneeDetails,
    this.assigneesList,
    this.subIssuesCount,
    this.attachmentCount,
    this.linkCount,
    this.issueReactions,
    this.createdAt,
    this.updatedAt,
    this.estimatePoint,
    this.name,
    this.description,
    this.descriptionHtml,
    this.descriptionStripped,
    this.priority,
    this.startDate,
    this.targetDate,
    this.sequenceId,
    this.sortOrder,
    this.completedAt,
    this.archivedAt,
    this.createdBy,
    this.updatedBy,
    this.project,
    this.workspace,
    this.parent,
    this.state,
    this.labels,
  });

  factory UserSubscribedIssuesModel.fromJson(Map<String, dynamic> json) {
    return UserSubscribedIssuesModel(
      id: json['id'],
      workspaceDetail: WorkspaceDetail.fromJson(json['workspace_detail']),
      projectDetail: ProjectDetail.fromJson(json['project_detail']),
      stateDetail: StateDetail.fromJson(json['state_detail']),
      labelDetails: json['label_details'],
      assigneeDetails: (json['assignee_details'] as List<dynamic>)
          .map((assignee) => AssigneeDetail.fromJson(assignee))
          .toList(),
      assigneesList: json['assignee_details'] as List<dynamic>,
      subIssuesCount: json['sub_issues_count'],
      attachmentCount: json['attachment_count'],
      linkCount: json['link_count'],
      issueReactions: json['issue_reactions'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      estimatePoint: json['estimate_point'],
      name: json['name'],
      description: Description.fromJson(json['description']),
      descriptionHtml: json['description_html'],
      descriptionStripped: json['description_stripped'],
      priority: json['priority'],
      startDate: json['start_date'],
      targetDate: json['target_date'],
      sequenceId: json['sequence_id'],
      sortOrder: json['sort_order'],
      completedAt: json['completed_at'],
      archivedAt: json['archived_at'],
      createdBy: json['created_by'],
      updatedBy: json['updated_by'],
      project: json['project'],
      workspace: json['workspace'],
      parent: json['parent'],
      state: json['state'],
      labels: json['labels'],
    );
  }

  factory UserSubscribedIssuesModel.empty() {
    return UserSubscribedIssuesModel(
      id: '',
      workspaceDetail: null,
      projectDetail: null,
      stateDetail: null,
      labelDetails: null,
      assigneeDetails: null,
      assigneesList: [],
      subIssuesCount: 0,
      attachmentCount: 0,
      linkCount: 0,
      issueReactions: [],
      createdAt: '',
      updatedAt: '',
      estimatePoint: null,
      name: '',
      description: null,
      descriptionHtml: '',
      descriptionStripped: '',
      priority: null,
      startDate: '',
      targetDate: '',
      sequenceId: 0,
      sortOrder: 0.0,
      completedAt: '',
      archivedAt: '',
      createdBy: '',
      updatedBy: '',
      project: '',
      workspace: '',
      parent: null,
      state: '',
      labels: [],
    );
  }
  String? id;
  WorkspaceDetail? workspaceDetail;
  ProjectDetail? projectDetail;
  StateDetail? stateDetail;
  List<dynamic>?
      labelDetails; // You can change the type if you have more specific label details
  List<AssigneeDetail>? assigneeDetails;
  List<dynamic>? assigneesList;
  int? subIssuesCount;
  int? attachmentCount;
  int? linkCount;
  List<dynamic>?
      issueReactions; // You can change the type if you have more specific issue reactions
  String? createdAt;
  String? updatedAt;
  dynamic
      estimatePoint; // Change the type if estimate points have a specific data type
  String? name;
  Description? description;
  String? descriptionHtml;
  String? descriptionStripped;
  dynamic priority; // Change the type if priorities have a specific data type
  String? startDate; // Change the type if start dates have a specific data type
  String? targetDate;
  int? sequenceId;
  double? sortOrder;
  String?
      completedAt; // Change the type if completed dates have a specific data type
  String?
      archivedAt; // Change the type if archived dates have a specific data type
  String? createdBy;
  String? updatedBy;
  String? project;
  String? workspace;
  dynamic parent; // Change the type if parent issues have a specific data type
  String? state;
  List<dynamic>?
      labels; // You can change the type if labels have a specific data type
}

class WorkspaceDetail {
  WorkspaceDetail({
    this.name,
    this.slug,
    this.id,
  });

  factory WorkspaceDetail.fromJson(Map<String, dynamic> json) {
    return WorkspaceDetail(
      name: json['name'],
      slug: json['slug'],
      id: json['id'],
    );
  }
  String? name;
  String? slug;
  String? id;
}

class ProjectDetail {
  ProjectDetail({
    this.id,
    this.identifier,
    this.name,
    this.coverImage,
    this.iconProp,
    this.emoji,
    this.description,
  });
  factory ProjectDetail.fromJson(Map<String, dynamic> json) {
    return ProjectDetail(
      id: json['id'],
      identifier: json['identifier'],
      name: json['name'],
      coverImage: json['cover_image'],
      iconProp: json['icon_prop'],
      emoji: json['emoji'],
      description: json['description'],
    );
  }
  String? id;
  String? identifier;
  String? name;
  String? coverImage;
  dynamic iconProp;
  String? emoji;
  String? description;
}

class StateDetail {
  StateDetail({
    this.id,
    this.name,
    this.color,
    this.group,
  });

  factory StateDetail.fromJson(Map<String, dynamic> json) {
    return StateDetail(
      id: json['id'],
      name: json['name'],
      color: json['color'],
      group: json['group'],
    );
  }
  String? id;
  String? name;
  String? color;
  String? group;
}

class AssigneeDetail {
  AssigneeDetail({
    this.id,
    this.firstName,
    this.lastName,
    this.avatar,
    this.isBot,
    this.displayName,
  });

  factory AssigneeDetail.fromJson(Map<String, dynamic> json) {
    return AssigneeDetail(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      avatar: json['avatar'],
      isBot: json['is_bot'],
      displayName: json['display_name'],
    );
  }
  String? id;
  String? firstName;
  String? lastName;
  dynamic avatar;
  bool? isBot;
  String? displayName;
}

class Description {
  Description({
    this.type,
    this.content,
  });

  factory Description.fromJson(Map<String, dynamic> json) {
    return Description(
      type: json['type'],
      content: (json['content'] as List<dynamic>)
          .map((content) => Content.fromJson(content))
          .toList(),
    );
  }
  String? type;
  List<Content>? content;
}

class Content {
  Content({
    this.text,
    this.type,
  });

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      text: json['text'],
      type: json['type'],
    );
  }
  String? text;
  String? type;
}
