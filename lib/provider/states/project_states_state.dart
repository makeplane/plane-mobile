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
        statesState: StateEnum.empty,
        createStateLoading: StateEnum.empty,
        updateState: StateEnum.empty,
        deleteState: StateEnum.empty,
        stateGroups: {});
  }

  ProjectStatesState copyWith(
      {Map<String, StateModel>? states,
      StateEnum? statesState,
      StateEnum? createStateLoading,
      StateEnum? updateState,
      StateEnum? deleteState,
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
  StateEnum statesState = StateEnum.empty;
  StateEnum createStateLoading = StateEnum.empty;
  StateEnum updateState = StateEnum.empty;
  StateEnum deleteState = StateEnum.empty;
}
