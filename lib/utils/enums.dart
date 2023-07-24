enum Environment { production, staging, dev }

enum StateEnum {
  error,
  success,
  failed,
  loading,
  empty,
  incomplete,
  pending,
  restricted,
  idle,
}

enum HttpMethod { connect, delete, get, head, options, patch, post, put, trace }

// enum Theme { light, dark }

enum ProjectView { kanban, list, calendar }

enum GroupBY { state, priority, labels, createdBY }

enum OrderBY { manual, lastCreated, lastUpdated, priority }

enum IssueType { all, activeIssues, backlogIssues }

enum CRUD { create, read, update, delete }

enum IssueCategory { issues, cycleIssues, moduleIssues }

enum IssueDetailCategory {
  parent,
  blocked,
  blocking,
  subIssue,
  addCycleIssue,
  addModuleIssue
}

enum Role { admin, member, viewer, guest, none }
