import 'package:plane/models/issues.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/utils/extensions/list_extensions.dart';
import 'package:plane/utils/issues_filter/group_by_issues.dart';
import 'package:plane/utils/issues_filter/order_by_issues.dart';

class IssueFilterHelper {
  static String getFilterQueryParams(Filters filters) {
    String url = '';
    url = '$url${filters.priorities.toQueryParam("&priority=")}';
    url = '$url${filters.states.toQueryParam("&state=")}';
    url = '$url${filters.assignees.toQueryParam("&assignees=")}';
    url = '$url${filters.createdBy.toQueryParam("&created_by=")}';
    url = '$url${filters.labels.toQueryParam("&labels=")}';
    url = '$url${filters.targetDate.toQueryParam("&target_date=")}';
    url = '$url${filters.startDate.toQueryParam("&start_date=")}';
    return url;
  }

  static Map<String, dynamic> organizeIssues(
    List<dynamic> issues,
    GroupBY groupBY,
    OrderBY orderBY, {
    Map<String, dynamic>? filter,
    dynamic labels,
    dynamic members,
    dynamic projects,
    dynamic states,
  }) {
    Map<String, List<dynamic>> groupedIssues = IssuesGroupBYHelper.groupIssues(
      issues,
      groupBY,
      filter: filter,
      labels: labels,
      members: members,
      projects: projects,
      states: states,
    );
    Map<String, dynamic> organizedIssues =
        IssuesOrderBYHelper.orderIssues(groupedIssues, orderBY);
    return organizedIssues;
  }
}
