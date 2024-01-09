// ignore_for_file: constant_identifier_names

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

enum PageFilters { all, recent, favourites, createdByMe, createdByOthers }

enum HttpMethod { connect, delete, get, head, options, patch, post, put, trace }

enum ProjectView { kanban, list, calendar, spreadsheet }

enum GroupBY {
  state,
  priority,
  labels,
  assignees,
  createdBY,
  project,
  none,
  stateGroups
}

enum OrderBY { manual, lastCreated, lastUpdated, priority, startDate }

enum IssueType { all, activeIssues, backlogIssues }

enum CRUD { create, read, update, delete }

enum IssueCategory {
  issues,
  cycleIssues,
  moduleIssues,
  myIssues,
  views,
  archivedIssues,
}

enum IssueDetailCategory {
  parent,
  blocked,
  blocking,
  subIssue,
  addCycleIssue,
  addModuleIssue
}

enum Role { admin, member, viewer, guest, none }

enum FontStyle {
  H1,
  H2,
  H3,
  H4,
  H5,
  H6,
  Large,
  Medium,
  Small,
  XSmall,
  overline
}

enum FontWeightt {
  Regular,
  Medium,
  Semibold,
  Bold,
  ExtraBold,
}

enum THEME {
  light,
  dark,
  lightHighContrast,
  darkHighContrast,
  custom,
  systemPreferences
}

enum LoadingType { translucent, opaque, error, wrap, none }
