import 'package:plane/utils/enums.dart';

class IssuesConverter {
  static IssuesLayout fromStringToIssuesLayout(String? value) {
    switch (value) {
      case 'kanban':
        return IssuesLayout.kanban;
      case 'list':
        return IssuesLayout.list;
      case 'calendar':
        return IssuesLayout.calendar;
      case 'spreadsheet':
        return IssuesLayout.spreadsheet;
      default:
        return IssuesLayout.kanban;
    }
  }

  static String fromIssuesLayoutToString(IssuesLayout value) {
    switch (value) {
      case IssuesLayout.kanban:
        return 'kanban';
      case IssuesLayout.list:
        return 'list';
      case IssuesLayout.calendar:
        return 'calendar';
      case IssuesLayout.spreadsheet:
        return 'spreadsheet';
      default:
        return 'kanban';
    }
  }

  static OrderBY fromStringToOrderby(String orderBy) {
    switch (orderBy) {
      case "sort_order":
        return OrderBY.manual;
      case "-created_at":
        return OrderBY.lastCreated;
      case "-updated_at":
        return OrderBY.lastUpdated;
      case "priority":
        return OrderBY.priority;
      case "start_date":
        return OrderBY.startDate;
      default:
        return OrderBY.manual;
    }
  }

  static String fromOrderbyToString(OrderBY orderBy) {
    switch (orderBy) {
      case OrderBY.manual:
        return "sort_order";
      case OrderBY.lastCreated:
        return "-created_at";
      case OrderBY.lastUpdated:
        return "-updated_at";
      case OrderBY.priority:
        return "priority";
      case OrderBY.startDate:
        return "start_date";
      default:
        return "manual";
    }
  }

  static IssueType fromStringToIssueType(String? issueType) {
    switch (issueType) {
      case "all":
        return IssueType.all;
      case "active":
        return IssueType.active;
      case "backlog":
        return IssueType.backlog;
      default:
        return IssueType.all;
    }
  }

  static String fromIssueTypetoString(IssueType issueType) {
    switch (issueType) {
      case IssueType.all:
        return "all";
      case IssueType.active:
        return "active";
      case IssueType.backlog:
        return "backlog";
      default:
        return "all";
    }
  }

  static GroupBY fromStringToGroupby(String? groupBY) {
    switch (groupBY) {
      case "state":
        return GroupBY.state;
      // case "state_detail.group":
      //   return GroupBY.stateGroups;
      case "priority":
        return GroupBY.priority;
      case "labels":
        return GroupBY.labels;
      case "assignees":
        return GroupBY.assignees;
      case "created_by":
        return GroupBY.createdBY;
      case "project":
        return GroupBY.project;
      case 'none':
        return GroupBY.none;
      default:
        return GroupBY.state;
    }
  }

  static String fromGroupbyToString(GroupBY groupBY) {
    switch (groupBY) {
      case GroupBY.state:
        return "state";
      case GroupBY.stateGroups:
        return "state_detail.group";
      case GroupBY.priority:
        return "priority";
      case GroupBY.labels:
        return "labels";
      case GroupBY.assignees:
        return "assignees";
      case GroupBY.createdBY:
        return "created_by";
      case GroupBY.project:
        return "project";
      case GroupBY.none:
        return "none";
      default:
        return "state";
    }
  }
}
