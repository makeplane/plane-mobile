class CyclesModel {
  CyclesModel(
      {this.id,
      this.ownedBy,
      this.isFavorite,
      this.totalIssues,
      this.cancelledIssues,
      this.completedIssues,
      this.startedIssues,
      this.unstartedIssues,
      this.backlogIssues,
      this.assignees,
      this.totalEstimates,
      this.completedEstimates,
      this.startedEstimates,
      this.workspaceDetail,
      this.projectDetail,
      this.createdAt,
      this.updatedAt,
      this.name,
      this.description,
      this.startDate,
      this.endDate,
      this.createdBy,
      this.updatedBy,
      this.project,
      this.workspace});

  CyclesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ownedBy =
        json['owned_by'] != null ? OwnedBy.fromJson(json['owned_by']) : null;
    isFavorite = json['is_favorite'];
    totalIssues = json['total_issues'];
    cancelledIssues = json['cancelled_issues'];
    completedIssues = json['completed_issues'];
    startedIssues = json['started_issues'];
    unstartedIssues = json['unstarted_issues'];
    backlogIssues = json['backlog_issues'];
    if (json['assignees'] != null) {
      assignees = <Assignees>[];
      json['assignees'].forEach((v) {
        assignees!.add(Assignees.fromJson(v));
      });
    }
    totalEstimates = json['total_estimates'];
    completedEstimates = json['completed_estimates'];
    startedEstimates = json['started_estimates'];
    workspaceDetail = json['workspace_detail'] != null
        ? WorkspaceDetail.fromJson(json['workspace_detail'])
        : null;
    projectDetail = json['project_detail'] != null
        ? ProjectDetail.fromJson(json['project_detail'])
        : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    name = json['name'];
    description = json['description'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    // viewProps = json['view_props'] != null ? new ViewProps.fromJson(json['view_props']) : null;
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    project = json['project'];
    workspace = json['workspace'];
  }
  String? id;
  OwnedBy? ownedBy;
  bool? isFavorite;
  int? totalIssues;
  int? cancelledIssues;
  int? completedIssues;
  int? startedIssues;
  int? unstartedIssues;
  int? backlogIssues;
  List<Assignees>? assignees;
  dynamic totalEstimates;
  dynamic completedEstimates;
  dynamic startedEstimates;
  WorkspaceDetail? workspaceDetail;
  ProjectDetail? projectDetail;
  String? createdAt;
  String? updatedAt;
  String? name;
  String? description;
  String? startDate;
  String? endDate;
  // ViewProps? viewProps;
  String? createdBy;
  String? updatedBy;
  String? project;
  String? workspace;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    if (ownedBy != null) {
      data['owned_by'] = ownedBy!.toJson();
    }
    data['is_favorite'] = isFavorite;
    data['total_issues'] = totalIssues;
    data['cancelled_issues'] = cancelledIssues;
    data['completed_issues'] = completedIssues;
    data['started_issues'] = startedIssues;
    data['unstarted_issues'] = unstartedIssues;
    data['backlog_issues'] = backlogIssues;
    if (assignees != null) {
      data['assignees'] = assignees!.map((v) => v.toJson()).toList();
    }
    data['total_estimates'] = totalEstimates;
    data['completed_estimates'] = completedEstimates;
    data['started_estimates'] = startedEstimates;
    if (workspaceDetail != null) {
      data['workspace_detail'] = workspaceDetail!.toJson();
    }
    if (projectDetail != null) {
      data['project_detail'] = projectDetail!.toJson();
    }
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['name'] = name;
    data['description'] = description;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    // if (this.viewProps != null) {
    //   data['view_props'] = this.viewProps!.toJson();
    // }
    data['created_by'] = createdBy;
    data['updated_by'] = updatedBy;
    data['project'] = project;
    data['workspace'] = workspace;
    return data;
  }
}

class OwnedBy {
  OwnedBy(
      {this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.avatar,
      this.isBot});

  OwnedBy.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    avatar = json['avatar'];
    isBot = json['is_bot'];
  }
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? avatar;
  bool? isBot;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['avatar'] = avatar;
    data['is_bot'] = isBot;
    return data;
  }
}

class Assignees {
  Assignees({this.id, this.avatar, this.firstName});

  Assignees.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    avatar = json['avatar'];
    firstName = json['first_name'];
  }
  String? id;
  String? avatar;
  String? firstName;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['avatar'] = avatar;
    data['first_name'] = firstName;
    return data;
  }
}

class WorkspaceDetail {
  WorkspaceDetail({this.name, this.slug, this.id});

  WorkspaceDetail.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    slug = json['slug'];
    id = json['id'];
  }
  String? name;
  String? slug;
  String? id;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['name'] = name;
    data['slug'] = slug;
    data['id'] = id;
    return data;
  }
}

class ProjectDetail {
  ProjectDetail({this.id, this.identifier, this.name});

  ProjectDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    identifier = json['identifier'];
    name = json['name'];
  }
  String? id;
  String? identifier;
  String? name;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['identifier'] = identifier;
    data['name'] = name;
    return data;
  }
}

// class ViewProps {

// 	ViewProps({});

// 	ViewProps.fromJson(Map<String, dynamic> json) {
// 	}

// 	Map<String, dynamic> toJson() {
// 		final Map<String, dynamic> data = new Map<String, dynamic>();
// 		return data;
// 	}
// }
