// ignore_for_file: non_constant_identifier_names
import 'package:plane/utils/enums.dart';

class IssuesOrderBYHelper {
  static Map<String, List<dynamic>> _orderBYManual(
      Map<String, List<dynamic>> issues) {
    issues.forEach((key, value) {
      value.sort((a, b) => b['sort_order'].compareTo(a['sort_order']));
    });
    return issues;
  }

  static Map<String, List<dynamic>> _orderBYLastCreated(
      Map<String, List<dynamic>> issues) {
    issues.forEach((key, value) {
      value.sort((a, b) => DateTime.parse(b['created_at'])
          .compareTo(DateTime.parse(a['created_at'])));
    });
    return issues;
  }

  static Map<String, List<dynamic>> _orderBYLastUpdated(
      Map<String, List<dynamic>> issues) {
    issues.forEach((key, value) {
      value.sort((a, b) => DateTime.parse(b['updated_at'])
          .compareTo(DateTime.parse(a['updated_at'])));
    });
    return issues;
  }

  static Map<String, List<dynamic>> _orderBYStartDate(
      Map<String, List<dynamic>> issues) {
    issues.forEach((key, value) {
      value.sort((a, b) {
        if (a['start_date'] == null && b['start_date'] == null) {
          return 0;
        } else if (b['start_date'] == null && a['start_date'] != null) {
          return -1;
        } else if (a['start_date'] == null && b['start_date'] != null) {
          return 1;
        }
        return DateTime.parse(a['start_date'])
            .compareTo(DateTime.parse(b['start_date']));
      });
    });
    return issues;
  }

  static Map<String, List<dynamic>> _orderBYPriority(
      Map<String, List<dynamic>> issues) {
    final ISSUE_PRIORITIES = {
      'urgent': 0,
      'high': 1,
      'medium': 2,
      'low': 3,
      'none': 4
    };
    issues.forEach((key, value) {
      value.sort((a, b) {
        return ISSUE_PRIORITIES[a['priority']]!
            .compareTo(ISSUE_PRIORITIES[b['priority']]!);
      });
    });
    return issues;
  }

  static Map<String, List<dynamic>> orderIssues(
    Map<String, List<dynamic>> issues,
    OrderBY orderBY, {
    Map<String, dynamic>? filter,
    dynamic labels,
    dynamic members,
    dynamic projects,
    dynamic states,
  }) {
    // base issue order
    Map<String, List<dynamic>> orderedIssues = _orderBYLastCreated(issues);
    // order by selected filter
    switch (orderBY) {
      case OrderBY.manual:
        orderedIssues = _orderBYManual(issues);
        break;
      case OrderBY.lastCreated:
        orderedIssues = _orderBYLastCreated(issues);
        break;
      case OrderBY.lastUpdated:
        orderedIssues = _orderBYLastUpdated(issues);
        break;
      case OrderBY.startDate:
        orderedIssues = _orderBYStartDate(issues);
        break;
      case OrderBY.priority:
        orderedIssues = _orderBYPriority(issues);
        break;
      default:
        orderedIssues = _orderBYManual(issues);
        break;
    }
    return orderedIssues;
  }
}
