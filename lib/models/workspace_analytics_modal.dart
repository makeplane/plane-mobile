class WorkspaceAnalyticsModal {
  int totalIssues;
  List<IssueStateCount> totalIssuesClassified;
  int openIssues;
  List<IssueStateCount> openIssuesClassified;
  List<IssueMonthCount> issueCompletedMonthWise;
  List<MostIssueCreatedUser> mostIssueCreatedUser;
  List<MostIssueClosedUser> mostIssueClosedUser;
  List<PendingIssueUser> pendingIssueUser;
  int openEstimateSum;
  int totalEstimateSum;

  WorkspaceAnalyticsModal({
    required this.totalIssues,
    required this.totalIssuesClassified,
    required this.openIssues,
    required this.openIssuesClassified,
    required this.issueCompletedMonthWise,
    required this.mostIssueCreatedUser,
    required this.mostIssueClosedUser,
    required this.pendingIssueUser,
    required this.openEstimateSum,
    required this.totalEstimateSum,
  });

  factory WorkspaceAnalyticsModal.fromJson(Map<String, dynamic> json) {
    return WorkspaceAnalyticsModal(
      totalIssues: json['total_issues'],
      totalIssuesClassified: (json['total_issues_classified'] as List)
          .map((item) => IssueStateCount.fromJson(item))
          .toList(),
      openIssues: json['open_issues'],
      openIssuesClassified: (json['open_issues_classified'] as List)
          .map((item) => IssueStateCount.fromJson(item))
          .toList(),
      issueCompletedMonthWise: (json['issue_completed_month_wise'] as List)
          .map((item) => IssueMonthCount.fromJson(item))
          .toList(),
      mostIssueCreatedUser: (json['most_issue_created_user'] as List)
          .map((item) => MostIssueCreatedUser.fromJson(item))
          .toList(),
      mostIssueClosedUser: (json['most_issue_closed_user'] as List)
          .map((item) => MostIssueClosedUser.fromJson(item))
          .toList(),
      pendingIssueUser: (json['pending_issue_user'] as List)
          .map((item) => PendingIssueUser.fromJson(item))
          .toList(),
      openEstimateSum: json['open_estimate_sum'],
      totalEstimateSum: json['total_estimate_sum'],
    );
  }
}

class IssueStateCount {
  String stateGroup;
  int stateCount;

  IssueStateCount({
    required this.stateGroup,
    required this.stateCount,
  });

  factory IssueStateCount.fromJson(Map<String, dynamic> json) {
    return IssueStateCount(
      stateGroup: json['state_group'],
      stateCount: json['state_count'],
    );
  }
}

class IssueMonthCount {
  int month;
  int count;

  IssueMonthCount({
    required this.month,
    required this.count,
  });

  factory IssueMonthCount.fromJson(Map<String, dynamic> json) {
    return IssueMonthCount(
      month: json['month'],
      count: json['count'],
    );
  }
}

class MostIssueClosedUser {
  String assigneesFirstName;
  String assigneesLastName;
  String assigneesAvatar;
  String assigneesEmail;
  int count;

  MostIssueClosedUser({
    required this.assigneesFirstName,
    required this.assigneesLastName,
    required this.assigneesAvatar,
    required this.assigneesEmail,
    required this.count,
  });

  factory MostIssueClosedUser.fromJson(Map<String, dynamic> json) {
    return MostIssueClosedUser(
      assigneesFirstName: json['assignees__first_name'],
      assigneesLastName: json['assignees__last_name'],
      assigneesAvatar: json['assignees__avatar'],
      assigneesEmail: json['assignees__email'],
      count: json['count'],
    );
  }
}


class MostIssueCreatedUser {
  String createdByFirstName;
  String createdByLastName;
  String createdByAvatar;
  String createdByEmail;
  int count;

  MostIssueCreatedUser({
    required this.createdByFirstName,
    required this.createdByLastName,
    required this.createdByAvatar,
    required this.createdByEmail,
    required this.count,
  });

  factory MostIssueCreatedUser.fromJson(Map<String, dynamic> json) {
    return MostIssueCreatedUser(
      createdByFirstName: json['created_by__first_name'],
      createdByLastName: json['created_by__last_name'],
      createdByAvatar: json['created_by__avatar'],
      createdByEmail: json['created_by__email'],
      count: json['count'],
    );
  }
}


class PendingIssueUser {
  String? assigneesFirstName;
  String? assigneesLastName;
  String? assigneesAvatar;
  String? assigneesEmail;
  int count;

  PendingIssueUser({
    this.assigneesFirstName,
    this.assigneesLastName,
    this.assigneesAvatar,
    this.assigneesEmail,
    required this.count,
  });

  factory PendingIssueUser.fromJson(Map<String, dynamic> json) {
    return PendingIssueUser(
      assigneesFirstName: json['assignees__first_name'],
      assigneesLastName: json['assignees__last_name'],
      assigneesAvatar: json['assignees__avatar'],
      assigneesEmail: json['assignees__email'],
      count: json['count'],
    );
  }
}

