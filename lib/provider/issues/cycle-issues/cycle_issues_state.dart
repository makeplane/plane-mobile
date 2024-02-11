import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/kanban/models/inputs.dart';
import 'package:plane/models/project/layout-properties/layout_properties.model.dart';
import 'package:plane/provider/issues/base-classes/base_issue_state.dart';
import 'package:plane/models/project/issue/issue_model.dart';
import 'package:plane/utils/enums.dart';

class CycleIssuesState implements ABaseIssuesState {
  @override
  Ref? ref;
  @override
  DataState fetchIssuesState = DataState.empty;
  @override
  DataState deleteIssueState = DataState.empty;
  @override
  DataState fetchLayoutViewState = DataState.empty;
  @override
  DataState fetchDPropertiesState = DataState.empty;
  @override
  DataState updateDPropertiesState = DataState.empty;
  @override
  DataState updateIssueState = DataState.empty;
  @override
  DataState createIssueState = DataState.empty;
  @override
  Map<String, IssueModel> rawIssues = {};
  @override
  Map<String, List<IssueModel>> currentLayoutIssues = {};
  @override
  LayoutPropertiesModel layoutProperties = LayoutPropertiesModel.initial();
  @override
  List<BoardListsData> kanbanOrganizedIssues = [];
  IssueModel createIssuePayload = IssueModel.initial();

  CycleIssuesState(
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

  CycleIssuesState copyWith({
    Ref? ref,
    DataState? fetchIssuesState,
    DataState? deleteIssueState,
    DataState? fetchIssueLayoutViewState,
    DataState? fetchDPropertiesState,
    DataState? updateDPropertiesState,
    DataState? updateIssueState,
    DataState? createIssueState,
    IssueModel? createIssuePayload,
    Map<String, IssueModel>? rawIssues,
    Map<String, List<IssueModel>>? currentLayoutIssues,
    LayoutPropertiesModel? layoutProperties,
    List<BoardListsData>? kanbanOrganizedIssues,
  }) {
    return CycleIssuesState(
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

  factory CycleIssuesState.initial(Ref ref) {
    return CycleIssuesState(
      ref: ref,
      fetchIssuesState: DataState.empty,
      deleteIssueState: DataState.empty,
      fetchLayoutViewState: DataState.empty,
      fetchDPropertiesState: DataState.empty,
      updateDPropertiesState: DataState.empty,
      updateIssueState: DataState.empty,
      createIssueState: DataState.empty,
      createIssuePayload: IssueModel.initial(),
      rawIssues: {},
      currentLayoutIssues: {},
      kanbanOrganizedIssues: [],
      layoutProperties: LayoutPropertiesModel.initial(),
    );
  }
}
