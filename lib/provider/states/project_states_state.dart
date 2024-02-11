import 'package:plane/models/project/state/state_model.dart';
import 'package:plane/utils/enums.dart';

final defaultStateGroups = [
  'backlog',
  'unstarted',
  'started',
  'completed',
  'cancelled',
];

class ProjectStatesState {
  ProjectStatesState(
      {required this.projectStates,
      required this.statesState,
      required this.createStateLoading,
      required this.updateState,
      required this.deleteState,
      required this.stateGroups});

  factory ProjectStatesState.initialize() {
    return ProjectStatesState(
        projectStates: {},
        statesState: DataState.empty,
        createStateLoading: DataState.empty,
        updateState: DataState.empty,
        deleteState: DataState.empty,
        stateGroups: {});
  }

  ProjectStatesState copyWith(
      {Map<String, StateModel>? states,
      DataState? statesState,
      DataState? createStateLoading,
      DataState? updateState,
      DataState? deleteState,
      Map<String, List<StateModel>>? stateGroups}) {
    return ProjectStatesState(
        projectStates: states ?? projectStates,
        statesState: statesState ?? this.statesState,
        stateGroups: stateGroups ?? this.stateGroups,
        createStateLoading: createStateLoading ?? this.createStateLoading,
        updateState: updateState ?? this.updateState,
        deleteState: deleteState ?? this.deleteState);
  }

  Map<String, StateModel> projectStates = {};
  Map<String, List<StateModel>> stateGroups = {};
  DataState statesState = DataState.empty;
  DataState createStateLoading = DataState.empty;
  DataState updateState = DataState.empty;
  DataState deleteState = DataState.empty;
}
