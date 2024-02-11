import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/models/project/issue-filter-properties-and-view/issue_filter_and_properties.dart';
import 'package:plane/models/project/issue/issue_model.dart';
import 'package:plane/models/project/state/state_model.dart';
import 'package:plane/provider/issues/base-classes/base_issue_state.dart';
import 'package:plane/provider/issues/base-classes/base_issues_provider.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/core/extensions/list_extensions.dart';
import 'package:plane/utils/issues/group_by_issues.dart';
import 'package:plane/utils/issues/order_by_issues.dart';

class IssuesHelper {
  static ABaseIssuesProvider getIssuesProvider(
      WidgetRef ref, IssuesCategory issueCategory) {
    switch (issueCategory) {
      case IssuesCategory.GLOBAL:
        return ref.read(ProviderList.projectIssuesProvider.notifier);
      case IssuesCategory.MODULE:
        return ref.read(ProviderList.projectIssuesProvider.notifier);
      case IssuesCategory.CYCLE:
        return ref.read(ProviderList.projectIssuesProvider.notifier);
      default:
        return ref.read(ProviderList.projectIssuesProvider.notifier);
    }
  }

  static ABaseIssuesState getIssuesState(
      WidgetRef ref, IssuesCategory issueCategory) {
    switch (issueCategory) {
      case IssuesCategory.GLOBAL:
        return ref.read(ProviderList.projectIssuesProvider);
      case IssuesCategory.MODULE:
        return ref.read(ProviderList.projectIssuesProvider);
      case IssuesCategory.CYCLE:
        return ref.read(ProviderList.projectIssuesProvider);
      default:
        return ref.read(ProviderList.projectIssuesProvider);
    }
  }

  static String getFilterQueryParams(FiltersModel filters) {
    String url = '';
    url = '$url${filters.priority.toQueryParam("&priority=")}';
    url = '$url${filters.state.toQueryParam("&state=")}';
    url = '$url${filters.assignees.toQueryParam("&assignees=")}';
    url = '$url${filters.created_by.toQueryParam("&created_by=")}';
    url = '$url${filters.labels.toQueryParam("&labels=")}';
    url = '$url${filters.target_date.toQueryParam("&target_date=")}';
    url = '$url${filters.start_date.toQueryParam("&start_date=")}';
    return url;
  }

  static Map<String, List<IssueModel>> organizeIssues(
    List<IssueModel> issues,
    GroupBY groupBY,
    OrderBY orderBY, {
    FiltersModel? filter,
    required List<String> labelIDs,
    required List<String> memberIDs,
    required Map<String, StateModel> states,
  }) {
    Map<String, List<IssueModel>> groupedIssues =
        IssuesGroupBYHelper.groupIssues(
      issues,
      groupBY,
      filter: filter,
      labelIDs: labelIDs,
      memberIDs: memberIDs,
      states: states,
    );
    Map<String, List<IssueModel>> organizedIssues =
        IssuesOrderBYHelper.orderIssues(groupedIssues, orderBY);
    return organizedIssues;
  }
}
