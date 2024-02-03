import 'package:plane/models/project/issue-filter-properties-and-view/issue_filter_and_properties.dart';
import 'package:plane/models/project/issue/issue_model.dart';
import 'package:plane/models/project/state/state_model.dart';
import 'package:plane/utils/enums.dart';

class IssuesGroupBYHelper {
  static List defaultStateGroups = [
    'backlog',
    'unstarted',
    'started',
    'completed',
    'cancelled',
  ];

  static Map<String, List<IssueModel>> _groupByState(
      List<IssueModel> issues, Map<String, StateModel> states) {
    Map<String, List<IssueModel>> groupedIssues = {};
    Map<String, List<StateModel>> stateGroups = {};
    for (final state in defaultStateGroups) {
      stateGroups[state] =
          states.values.where((e) => e.group == state).toList();
      stateGroups[state]!.sort((a, b) => a.sequence.compareTo(b.sequence));
    }

    for (final stateGroup in stateGroups.keys) {
      for (final state in stateGroups[stateGroup]!) {
        groupedIssues[state.id] =
            issues.where((issue) => issue.state_id == state.id).toList();
      }
    }
    return groupedIssues;
  }

  static Map<String, List<IssueModel>> _groupByStateGroups(
      Map<String, StateModel> states, List<IssueModel> issues) {
    Map<String, List<IssueModel>> groupedIssues = {};

    for (final stateGroup in defaultStateGroups) {
      groupedIssues[stateGroup] = [];
    }
    for (final issue in issues) {
      groupedIssues[states[issue.state_id]?.group]!.add(issue);
    }

    return groupedIssues;
  }

  static Map<String, List<IssueModel>> _groupByPriority(
      List<IssueModel> issues) {
    Map<String, List<IssueModel>> groupedIssues = {};
    final priorities = ['urgent', 'high', 'medium', 'low', 'none'];
    for (final priority in priorities) {
      groupedIssues[priority] =
          issues.where((issue) => issue.priority == priority).toList();
    }
    return groupedIssues;
  }

  static Map<String, List<IssueModel>> _groupByLabels(
      List<IssueModel> issues, List<String> labelIDs) {
    Map<String, List<IssueModel>> groupedIssues = {};
    for (final label in labelIDs) {
      groupedIssues[label] =
          issues.where((issue) => issue.label_ids.contains(label)).toList();
    }
    groupedIssues['None'] =
        issues.where((issue) => issue.label_ids.isEmpty).toList();
    if (groupedIssues['None']!.isEmpty) {
      groupedIssues.remove('None');
    }
    return groupedIssues;
  }

  static Map<String, List<IssueModel>> _groupByAssignees(
      List<IssueModel> issues, List<String> memberIDs) {
    Map<String, List<IssueModel>> groupedIssues = {};
    for (final memberID in memberIDs) {
      groupedIssues[memberID] = issues
          .where((issue) => issue.assignee_ids.contains(memberID))
          .toList();
    }
    return groupedIssues;
  }

  static Map<String, List<IssueModel>> _groupByCreator(
      List<IssueModel> issues, List<String> memberIDs) {
    Map<String, List<IssueModel>> groupedIssues = {};
    for (final memberID in memberIDs) {
      groupedIssues[memberID] =
          issues.where((issue) => (issue.created_by == memberID)).toList();
    }
    return groupedIssues;
  }

  static Map<String, List<IssueModel>> _groupByProject(
      List<IssueModel> issues, List<dynamic> projectIDs) {
    Map<String, List<IssueModel>> groupedIssues = {};
    for (final project in projectIDs) {
      groupedIssues[project['id']] =
          issues.where((issue) => (issue.project_id == project['id'])).toList();
    }
    return groupedIssues;
  }

  static Map<String, List<IssueModel>> _groupByNone(List<IssueModel> issues) {
    Map<String, List<IssueModel>> groupedIssues = {};
    groupedIssues['All Issues'] = issues;
    return groupedIssues;
  }

  static Map<String, List<IssueModel>> groupIssues(
    List<IssueModel> issues,
    GroupBY groupBY, {
    FiltersModel? filter,
    required List<String> labelIDs,
    required List<String> memberIDs,
    required Map<String, StateModel> states,
  }) {
    Map<String, List<IssueModel>> groupedIssues = {};
    switch (groupBY) {
      case GroupBY.state:
        groupedIssues = _groupByState(issues, states);
        break;
      case GroupBY.stateGroups:
        groupedIssues = _groupByStateGroups(states, issues);
        break;
      case GroupBY.priority:
        groupedIssues = _groupByPriority(issues);
        break;
      case GroupBY.labels:
        groupedIssues = _groupByLabels(issues, labelIDs);
        break;
      case GroupBY.assignees:
        groupedIssues = _groupByAssignees(issues, memberIDs);
        break;
      case GroupBY.createdBY:
        groupedIssues = _groupByCreator(issues, memberIDs);
        break;
      // case GroupBY.project:
      //   groupedIssues = _groupByProject(issues, projectIDs);
      // break;
      case GroupBY.none:
        groupedIssues = _groupByNone(issues);
        break;
    }
    return groupedIssues;
  }
}
