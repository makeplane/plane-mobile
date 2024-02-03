import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/kanban/models/inputs.dart';
import 'package:plane/models/project/issue/issue_model.dart';
import 'package:plane/models/project/layout-properties/layout_properties.model.dart';
import 'package:plane/utils/enums.dart';

abstract class ABaseIssuesState {
  /// Ref to the [ProviderContainer]
  Ref? ref;

  /// A state that represents the state of [getIssues] api
  StateEnum fetchIssuesState = StateEnum.empty;

  /// A state that represents the state of [deleteIssue] api
  StateEnum deleteIssueState = StateEnum.empty;

  /// A state that represents the state of [getIssueLayoutView] api
  StateEnum fetchLayoutViewState = StateEnum.empty;

  /// A state that represents the state of [getIssueDisplayProperties] api
  StateEnum fetchDPropertiesState = StateEnum.empty;

  /// A state that represents the state of [updateIssueDisplayProperties] api
  StateEnum updateDPropertiesState = StateEnum.empty;

  /// A state that represents the state of [updateIssue] api
  StateEnum updateIssueState = StateEnum.empty;

  /// A state that represents the state of [createIssue] api
  StateEnum createIssueState = StateEnum.empty;

  /// A map that contains all the [rawIssues] with their [issueId] as key
  Map<String, IssueModel> rawIssues = {};

  /// A map that contains all the [issues] with applies [filters] and [properties] w.r.t current [issuesLayout]
  Map<String, List<IssueModel>> currentLayoutIssues = {};

  /// A model that contains the overall details of the layout
  /// like [layout], [groupBY], [orderBY], [showSubIssues], [issueType], [filtersModel], [displayProperties]
  LayoutPropertiesModel layoutProperties = LayoutPropertiesModel.initial();

  /// List of [BoardListsData] that contains the issues organized in the kanban layout format
  List<BoardListsData> kanbanOrganizedIssues = [];
}
