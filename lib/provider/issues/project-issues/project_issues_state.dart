import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/kanban/models/inputs.dart';
import 'package:plane/models/project/layout-properties/layout_properties.model.dart';
import 'package:plane/provider/issues/base-classes/base_issue_state.dart';
import 'package:plane/models/project/issue/issue_model.dart';
import 'package:plane/utils/enums.dart';

class ProjectIssuesState implements ABaseIssuesState {
  @override
  Ref? ref;
  @override
  StateEnum fetchIssuesState = StateEnum.empty;
  @override
  StateEnum deleteIssueState = StateEnum.empty;
  @override
  StateEnum fetchLayoutViewState = StateEnum.empty;
  @override
  StateEnum fetchDPropertiesState = StateEnum.empty;
  @override
  StateEnum updateDPropertiesState = StateEnum.empty;
  @override
  StateEnum updateIssueState = StateEnum.empty;
  @override
  StateEnum createIssueState = StateEnum.empty;
  @override
  Map<String, IssueModel> rawIssues = {};
  @override
  Map<String, List<IssueModel>> currentLayoutIssues = {};
  @override
  LayoutPropertiesModel layoutProperties = LayoutPropertiesModel.initial();
  @override
  List<BoardListsData> kanbanOrganizedIssues = [];
  IssueModel createIssuePayload = IssueModel.initial();

  ProjectIssuesState(
      {required this.fetchIssuesState,
      required this.deleteIssueState,
      required this.fetchLayoutViewState,
      required this.fetchDPropertiesState,
      required this.updateDPropertiesState,
      required this.updateIssueState,
      required this.createIssueState,
      required this.rawIssues,
      required this.currentLayoutIssues,
      required this.createIssuePayload,
      required this.layoutProperties,
      required this.kanbanOrganizedIssues,
      this.ref});

  ProjectIssuesState copyWith({
    Ref? ref,
    StateEnum? fetchIssuesState,
    StateEnum? deleteIssueState,
    StateEnum? fetchIssueLayoutViewState,
    StateEnum? fetchDPropertiesState,
    StateEnum? updateDPropertiesState,
    StateEnum? updateIssueState,
    StateEnum? createIssueState,
    IssueModel? createIssuePayload,
    Map<String, IssueModel>? rawIssues,
    Map<String, List<IssueModel>>? currentLayoutIssues,
    LayoutPropertiesModel? layoutProperties,
    List<BoardListsData>? kanbanOrganizedIssues,
  }) {
    return ProjectIssuesState(
      ref: ref ?? this.ref,
      createIssuePayload: createIssuePayload ?? this.createIssuePayload,
      fetchIssuesState: fetchIssuesState ?? this.fetchIssuesState,
      deleteIssueState: deleteIssueState ?? this.deleteIssueState,
      fetchLayoutViewState: fetchIssueLayoutViewState ?? fetchLayoutViewState,
      fetchDPropertiesState:
          fetchDPropertiesState ?? this.fetchDPropertiesState,
      updateDPropertiesState:
          updateDPropertiesState ?? this.updateDPropertiesState,
      updateIssueState: updateIssueState ?? this.updateIssueState,
      createIssueState: createIssueState ?? this.createIssueState,
      rawIssues: rawIssues ?? this.rawIssues,
      currentLayoutIssues: currentLayoutIssues ?? this.currentLayoutIssues,
      layoutProperties: layoutProperties ?? this.layoutProperties,
      kanbanOrganizedIssues:
          kanbanOrganizedIssues ?? this.kanbanOrganizedIssues,
    );
  }

  factory ProjectIssuesState.initial(Ref ref) {
    return ProjectIssuesState(
      ref: ref,
      fetchIssuesState: StateEnum.empty,
      deleteIssueState: StateEnum.empty,
      fetchLayoutViewState: StateEnum.empty,
      fetchDPropertiesState: StateEnum.empty,
      updateDPropertiesState: StateEnum.empty,
      updateIssueState: StateEnum.empty,
      createIssueState: StateEnum.empty,
      createIssuePayload: IssueModel.initial(),
      rawIssues: {},
      currentLayoutIssues: {},
      kanbanOrganizedIssues: [],
      layoutProperties: LayoutPropertiesModel.initial(),
    );
  }
}
