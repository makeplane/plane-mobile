import 'package:plane/utils/enums.dart';

class IssuesGroupBYHelper {
  static List defaultStateGroups = [
    'backlog',
    'unstarted',
    'started',
    'completed',
    'cancelled',
  ];

  static Map<String, List<dynamic>> _groupByState(
      List<dynamic> issues, Map<dynamic, dynamic> states) {
    Map<String, List<dynamic>> groupedIssues = {};
    Map<String, List<dynamic>> stateGroups = {};
    for (final state in defaultStateGroups) {
      stateGroups[state] =
          states.values.where((e) => e['group'] == state).toList();
      stateGroups[state]!
          .sort((a, b) => a['sequence'].compareTo(b['sequence']));
    }
    for (final stateGroup in stateGroups.keys) {
      for (final state in stateGroups[stateGroup]!) {
        groupedIssues[state['id']] =
            issues.where((issue) => issue['state'] == state['id']).toList();
      }
    }
    return groupedIssues;
  }

  static Map<String, List<dynamic>> _groupByStateGroups(
      List<dynamic> issues, Map<String, dynamic> states) {
    Map<String, List<dynamic>> groupedIssues = {};

    for (final stateGroup in defaultStateGroups) {
      groupedIssues[stateGroup] = [];
    }
    for (final issue in issues) {
      groupedIssues[issue['state_detail']['group']]!.add(issue);
    }

    return groupedIssues;
  }

  static Map<String, List<dynamic>> _groupByPriority(List<dynamic> issues) {
    Map<String, List<dynamic>> groupedIssues = {};
    final priorities = ['urgent', 'high', 'medium', 'low', 'none'];
    for (final priority in priorities) {
      groupedIssues[priority] =
          issues.where((issue) => issue['priority'] == priority).toList();
    }
    return groupedIssues;
  }

  static Map<String, List<dynamic>> _groupByLabels(
      List<dynamic> issues, List<dynamic> labels) {
    Map<String, List<dynamic>> groupedIssues = {};
    for (final label in labels) {
      groupedIssues[label] = issues
          .where((issue) => (issue['labels'] as List).contains(label))
          .toList();
    }
    return groupedIssues;
  }

  static Map<String, List<dynamic>> _groupByAssignees(
      List<dynamic> issues, List<dynamic> assignees) {
    Map<String, List<dynamic>> groupedIssues = {};
    for (final assignee in assignees) {
      groupedIssues[assignee['member']['id']] = issues
          .where((issue) =>
              (issue['assignees'] as List).contains(assignee['member']['id']))
          .toList();
    }
    return groupedIssues;
  }

  static Map<String, List<dynamic>> _groupByCreator(
      List<dynamic> issues, List<dynamic> members) {
    Map<String, List<dynamic>> groupedIssues = {};
    for (final member in members) {
      groupedIssues[member['member']['id']] = issues
          .where((issue) => (issue['created_by'] == member['member']['id']))
          .toList();
    }
    return groupedIssues;
  }

  static Map<String, List<dynamic>> _groupByProject(
      List<dynamic> issues, List<dynamic> projects) {
    Map<String, List<dynamic>> groupedIssues = {};
    for (final project in projects) {
      groupedIssues[project['id']] =
          issues.where((issue) => (issue['project'] == project['id'])).toList();
    }
    return groupedIssues;
  }

  static Map<String, List<dynamic>> _groupByNone(List<dynamic> issues) {
    Map<String, List<dynamic>> groupedIssues = {};
    groupedIssues['All Issues'] = issues;
    return groupedIssues;
  }

  static Map<String, List<dynamic>> groupIssues(
    List<dynamic> issues,
    GroupBY groupBY, {
    Map<String, dynamic>? filter,
    dynamic labels,
    dynamic members,
    dynamic projects,
    dynamic states,
  }) {
    Map<String, List<dynamic>> groupedIssues = {};
    switch (groupBY) {
      case GroupBY.state:
        groupedIssues = _groupByState(issues, states);
        break;
      case GroupBY.stateGroups:
        groupedIssues = _groupByStateGroups(issues, states);
        break;
      case GroupBY.priority:
        groupedIssues = _groupByPriority(issues);
        break;
      case GroupBY.labels:
        groupedIssues = _groupByLabels(issues, labels);
        break;
      case GroupBY.assignees:
        groupedIssues = _groupByAssignees(issues, members);
        break;
      case GroupBY.createdBY:
        groupedIssues = _groupByCreator(issues, members);
        break;
      case GroupBY.project:
        groupedIssues = _groupByProject(issues, projects);
        break;
      case GroupBY.none:
        groupedIssues = _groupByNone(issues);
        break;
    }
    return groupedIssues;
  }
}
