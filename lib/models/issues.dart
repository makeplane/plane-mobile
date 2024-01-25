import 'package:plane/kanban/models/inputs.dart';
import 'package:plane/utils/enums.dart';

class DisplayProperties {
  DisplayProperties({
    required this.assignee,
    required this.dueDate,
    required this.id,
    required this.label,
    required this.state,
    required this.estimate,
    required this.subIsseCount,
    required this.linkCount,
    required this.attachmentCount,
    required this.priority,
    required this.createdOn,
    required this.updatedOn,
    required this.startDate,
  });

  static DisplayProperties initialize() {
    return DisplayProperties(
      assignee: true,
      estimate: false,
      dueDate: false,
      id: true,
      label: false,
      state: true,
      subIsseCount: false,
      linkCount: false,
      attachmentCount: false,
      priority: false,
      createdOn: false,
      updatedOn: false,
      startDate: false,
    );
  }

  bool assignee = false;
  bool dueDate = false;
  bool id = false;
  bool label = false;
  bool state = false;
  bool subIsseCount = false;
  bool priority = false;
  bool linkCount = false;
  bool attachmentCount = false;
  bool estimate = false;
  bool createdOn = false;
  bool updatedOn = false;
  bool startDate = false;
}

class Issues {
  Issues(
      {required this.issues,
      required this.projectView,
      required this.groupBY,
      required this.orderBY,
      required this.issueType,
      required this.showSubIssues,
      required this.displayProperties});
  List<BoardListsData> issues = [];
  IssueLayout projectView;
  GroupBY groupBY = GroupBY.state;
  OrderBY orderBY = OrderBY.manual;
  bool showSubIssues = true;
  IssueType issueType = IssueType.all;
  Filters filters = Filters(
    assignees: [],
    createdBy: [],
    labels: [],
    priorities: [],
    states: [],
    targetDate: [],
    startDate: [],
    stateGroup: [],
    subscriber: [],
  );

  DisplayProperties displayProperties;

  static Issues initialize() {
    return Issues(
      issues: [],
      showSubIssues: true,
      projectView: IssueLayout.kanban,
      groupBY: GroupBY.state,
      orderBY: OrderBY.lastCreated,
      issueType: IssueType.all,
      displayProperties: DisplayProperties.initialize(),
    );
  }

  static OrderBY toOrderBY(String orderBy) {
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

  static String fromOrderBY(OrderBY orderBy) {
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

  static IssueType toIssueType(String? issueType) {
    switch (issueType) {
      case "all":
        return IssueType.all;
      case "active":
        return IssueType.activeIssues;
      case "backlog":
        return IssueType.backlogIssues;
      default:
        return IssueType.all;
    }
  }

  static String fromIssueType(IssueType issueType) {
    switch (issueType) {
      case IssueType.all:
        return "all";
      case IssueType.activeIssues:
        return "active";
      case IssueType.backlogIssues:
        return "backlog";
      default:
        return "all";
    }
  }

  static GroupBY toGroupBY(String? groupBY) {
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

  static String fromGroupBY(GroupBY groupBY) {
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

class Filters {
  Filters({
    required this.priorities,
    required this.states,
    required this.assignees,
    required this.createdBy,
    required this.labels,
    required this.targetDate,
    required this.startDate,
    required this.stateGroup,
    required this.subscriber,
  });
  factory Filters.fromJson(Map json) {
    return Filters(
      priorities: json['priority'] ?? [],
      states: json['state'] ?? [],
      assignees: json['assignees'] ?? [],
      createdBy: json['created_by'] ?? [],
      labels: json['labels'] ?? [],
      targetDate: json['target_date'] ?? [],
      startDate: json['start_date'] ?? [],
      stateGroup: json['state_group'] ?? [],
      subscriber: json['subscriber'] ?? [],
    );
  }
  List priorities = [];
  List states = [];
  List assignees = [];
  List createdBy = [];
  List labels = [];
  List targetDate = [];
  List startDate = [];
  List stateGroup = [];
  List subscriber = [];

  static Map<String, List<dynamic>> toJson(Filters filters) {
    return {
      "assignees": List.from(filters.assignees),
      "created_by": List.from(filters.createdBy),
      "labels": List.from(filters.labels),
      "priority": List.from(filters.priorities),
      "state": List.from(filters.states),
      "target_date": List.from(filters.targetDate),
      "start_date": List.from(filters.startDate),
      "state_group": List.from(filters.stateGroup),
      "subscriber": List.from(filters.subscriber),
    };
  }
}
