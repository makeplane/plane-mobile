import 'dart:developer';

import 'package:plane/models/Project/State/states_model.dart';
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
      List<dynamic> issues, Map<String, StatesModel> states) {
    Map<String, List<dynamic>> groupedIssues = {};
    Map<String, List<StatesModel>> stateGroups = {};
    for (final state in defaultStateGroups) {
      stateGroups[state] = states.values.where((e) =>  e.group == state).toList();
      stateGroups[state]!
          .sort((a, b) => a.sequence.compareTo(b.sequence));
    }

    for (final stateGroup in stateGroups.keys) {
      for (final state in stateGroups[stateGroup]!) {
        groupedIssues[state.id] =
            issues.where((issue) => issue['state_id'] == state.id).toList();
      }
    }
    return groupedIssues;
  }

  static Map<String, List<dynamic>> _groupByStateGroups(List<dynamic> issues) {
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
      List<dynamic> issues, List<String> labelIDs) {
    Map<String, List<dynamic>> groupedIssues = {};
    for (final label in labelIDs) {
      groupedIssues[label] = issues
          .where((issue) => (issue['label_ids'] as List).contains(label))
          .toList();
    }
    return groupedIssues;
  }

  static Map<String, List<dynamic>> _groupByAssignees(
      List<dynamic> issues, List<String> memberIDs) {
    Map<String, List<dynamic>> groupedIssues = {};
    for (final memberID in memberIDs) {
      groupedIssues[memberID] = issues
          .where((issue) => (issue['assignee_ids'] as List).contains(memberID))
          .toList();
    }
    return groupedIssues;
  }

  static Map<String, List<dynamic>> _groupByCreator(
      List<dynamic> issues, List<String> memberIDs) {
    Map<String, List<dynamic>> groupedIssues = {};
    for (final memberID in memberIDs) {
      groupedIssues[memberID] =
          issues.where((issue) => (issue['created_by'] == memberID)).toList();
    }
    return groupedIssues;
  }

  static Map<String, List<dynamic>> _groupByProject(
      List<dynamic> issues, List<dynamic> projectIDs) {
    Map<String, List<dynamic>> groupedIssues = {};
    for (final project in projectIDs) {
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
    required List<String> labelIDs,
    required List<String> memberIDs,
    required dynamic stateIDs,
  }) {
    Map<String, List<dynamic>> groupedIssues = {};
    switch (groupBY) {
      case GroupBY.state:
        groupedIssues = _groupByState(issues, stateIDs);
        break;
      case GroupBY.stateGroups:
        groupedIssues = _groupByStateGroups(issues);
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
