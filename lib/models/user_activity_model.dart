class UserActivityModel {
  UserActivityModel({
    this.nextCursor,
    this.prevCursor,
    this.nextPageResults,
    this.prevPageResults,
    this.count,
    this.totalPages,
    this.extraStats,
    this.results,
  });

  factory UserActivityModel.fromJson(Map<String, dynamic> json) {
    final resultsList = json['results'] as List<dynamic>;
    final resultsData = resultsList
        .map((result) =>
            UserActivityResult.fromJson(result as Map<String, dynamic>))
        .toList();

    return UserActivityModel(
      nextCursor: json['next_cursor'] as String,
      prevCursor: json['prev_cursor'] as String,
      nextPageResults: json['next_page_results'] as bool,
      prevPageResults: json['prev_page_results'] as bool,
      count: json['count'] as int,
      totalPages: json['total_pages'] as int,
      extraStats: json['extra_stats'],
      results: resultsData,
    );
  }

  factory UserActivityModel.userActivityEmpty() {
    return UserActivityModel(
      count: 0,
      nextCursor: '',
      prevCursor: '',
      nextPageResults: false,
      prevPageResults: false,
      totalPages: 0,
      extraStats: null,
      results: [],
    );
  }
  String? nextCursor;
  String? prevCursor;
  bool? nextPageResults;
  bool? prevPageResults;
  int? count;
  int? totalPages;
  dynamic extraStats;
  List<UserActivityResult>? results;
}

class UserActivityResult {
  UserActivityResult({
    this.id,
    this.actorDetail,
    this.issueDetail,
    this.projectDetail,
    this.createdAt,
    this.updatedAt,
    this.verb,
    this.field,
    this.oldValue,
    this.newValue,
    this.comment,
    this.attachments,
    this.oldIdentifier,
    this.newIdentifier,
    this.createdBy,
    this.updatedBy,
    this.project,
    this.workspace,
    this.issue,
    this.issueComment,
    this.actor,
  });

  factory UserActivityResult.fromJson(Map<String, dynamic> json) {
    return UserActivityResult(
      id: json['id'] as String,
      actorDetail:
          UserDetail.fromJson(json['actor_detail'] as Map<String, dynamic>),
      issueDetail: IssueDetail.fromJson(json['issue_detail']),
      projectDetail: ProjectDetail.fromJson(
          json['project_detail']),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      verb: json['verb'] as String,
      field: json['field'],
      oldValue: json['old_value'],
      newValue: json['new_value'],
      comment: json['comment'] as String,
      attachments: json['attachments'] as List<dynamic>,
      oldIdentifier: json['old_identifier'] as String?,
      newIdentifier: json['new_identifier'] as String?,
      createdBy: json['created_by'],
      updatedBy: json['updated_by'],
      project: json['project'] as String,
      workspace: json['workspace'] as String,
      issue: json['issue'],
      issueComment: json['issue_comment'],
      actor: json['actor'] as String,
    );
  }
  String? id;
  UserDetail? actorDetail;
  IssueDetail? issueDetail;
  ProjectDetail? projectDetail;
  String? createdAt;
  String? updatedAt;
  String? verb;
  String? field;
  String? oldValue;
  String? newValue;
  String? comment;
  List<dynamic>? attachments;
  String? oldIdentifier;
  String? newIdentifier;
  String? createdBy;
  String? updatedBy;
  String? project;
  String? workspace;
  String? issue;
  dynamic issueComment;
  String? actor;
}

class UserDetail {
  UserDetail({
    this.id,
    this.firstName,
    this.lastName,
    this.avatar,
    this.isBot,
    this.displayName,
  });
  factory UserDetail.fromJson(Map<String, dynamic> json) {
    return UserDetail(
      id: json['id'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      avatar: json['avatar'] as String,
      isBot: json['is_bot'] as bool,
      displayName: json['display_name'] as String,
    );
  }
  String? id;
  String? firstName;
  String? lastName;
  String? avatar;
  bool? isBot;
  String? displayName;
}

class IssueDetail {
  IssueDetail({
    this.id,
    this.name,
    //  this.description,
    this.descriptionHtml,
    this.priority,
    this.startDate,
    this.targetDate,
    this.sequenceId,
    this.sortOrder,
  });

  factory IssueDetail.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return IssueDetail(
        id: '',
        name: '',
        descriptionHtml: '',
        priority: '',
        startDate: '',
        targetDate: '',
        sequenceId: 0,
        sortOrder: 0.0,
      );
    } else {
      return IssueDetail(
        id: json['id'],
        name: json['name'],
        // description: json['description'] ?? '',
        descriptionHtml: json['description_html'],
        priority: json['priority'],
        startDate: json['start_date'],
        targetDate: json['target_date'],
        sequenceId: json['sequence_id'],
        sortOrder: json['sort_order'],
      );
    }
  }
  String? id;
  String? name;
  //  String? description;
  String? descriptionHtml;
  String? priority;
  String? startDate;
  String? targetDate;
  int? sequenceId;
  double? sortOrder;
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
      id: json['id'] as String,
      identifier: json['identifier'] as String,
      name: json['name'] as String,
      coverImage: json['cover_image'] as String,
      iconProp: json['icon_prop'],
      emoji: json['emoji'],
      description: json['description'] as String,
    );
  }
  String? id;
  String? identifier;
  String? name;
  String? coverImage;
  Map<String, dynamic>? iconProp;
  String? emoji;
  String? description;
}

class IconProp{
  IconProp({
    this.iconName,
    this.iconColor,
  });
  
  factory IconProp.fromJson(Map<String, dynamic> json) {
    return IconProp(
      iconName: json['name'] as String,
      iconColor: json['#adf672'] as String,
    );
  }
  String? iconName;
  String? iconColor;
}
