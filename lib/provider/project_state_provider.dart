import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/models/project/state/state_model.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/repository/project_state_service.dart';
import 'package:plane/utils/enums.dart';

final defaultStateGroups = [
  'backlog',
  'unstarted',
  'started',
  'completed',
  'cancelled',
];

class StatesData {
  StatesData(
      {required this.projectStates,
      required this.statesState,
      required this.createStateLoading,
      required this.updateState,
      required this.deleteState,
      required this.stateGroups});

  factory StatesData.initialize() {
    return StatesData(
        projectStates: {},
        statesState: StateEnum.empty,
        createStateLoading: StateEnum.empty,
        updateState: StateEnum.empty,
        deleteState: StateEnum.empty,
        stateGroups: {});
  }

  StatesData copyWith(
      {Map<String, StateModel>? states,
      StateEnum? statesState,
      StateEnum? createStateLoading,
      StateEnum? updateState,
      StateEnum? deleteState,
      Map<String, List<StateModel>>? stateGroups}) {
    return StatesData(
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

class StatesProvider extends StateNotifier<StatesData> {
  StatesProvider(this.ref, this.statesService) : super(StatesData.initialize());
  Ref ref;
  StatesService statesService;

  Future getStates({required String slug, required String projectId}) async {
    state = state.copyWith(statesState: StateEnum.loading);
    final states =
        await statesService.getStates(slug: slug, projectId: projectId);
    states.fold(
      (states) {
        state = state.copyWith(states: states, statesState: StateEnum.success);
        getGroupedStates();
      },
      (err) {
        if (err.response!.statusCode == 403) {
          state = state.copyWith(statesState: StateEnum.restricted);
        } else {
          state = state.copyWith(statesState: StateEnum.error);
        }
      },
    );
  }

  void getGroupedStates() {
    state = state.copyWith(stateGroups: {
      for (final stateGroup in defaultStateGroups)
        stateGroup: state.projectStates.values.where((state) {
          return state.group == stateGroup;
        }).toList()
    });
  }

  Future createState({required Map data}) async {
    final projectId =
        ref.read(ProviderList.projectProvider).currentProject['id'];
    final slug = ref
        .read(ProviderList.workspaceProvider)
        .selectedWorkspace
        .workspaceSlug;
    state = state.copyWith(createStateLoading: StateEnum.loading);
    final newState = await statesService.createState(
        data: data, slug: slug, projectId: projectId);
    newState.fold((addedState) {
      final projectStates = state.projectStates;
      final newStateGroupData = state.stateGroups;
      projectStates.addEntries({addedState.id: addedState}.entries);
      newStateGroupData.update(
        addedState.group,
        (existingStates) => [...existingStates, addedState],
        ifAbsent: () => [addedState],
      );
      state = state.copyWith(
          stateGroups: newStateGroupData,
          states: projectStates,
          createStateLoading: StateEnum.success);
    }, (err) {
      log(err.response.toString());
      state = state.copyWith(createStateLoading: StateEnum.error);
    });
  }

  Future updateState({
    required Map data,
    required String slug,
    required String projectId,
    required String stateId,
  }) async {
    state = state.copyWith(updateState: StateEnum.loading);
    final response = await statesService.updateState(
        data: data, slug: slug, projectId: projectId, stateId: stateId);
    response.fold((updateState) {
      final projectStates = state.projectStates;
      projectStates[updateState.id] = updateState;
      final Map<String, List<StateModel>> updatedGroups = {
        ...state.stateGroups
      };
      final String groupId = updateState.group;
      final List<StateModel>? groupStates = updatedGroups[groupId];
      if (groupStates != null) {
        final int indexToUpdate =
            groupStates.indexWhere((s) => s.id == updateState.id);
        if (indexToUpdate != -1) {
          groupStates[indexToUpdate] = updateState;
          updatedGroups[groupId] = groupStates;
          state = state.copyWith(
              states: projectStates,
              stateGroups: updatedGroups,
              updateState: StateEnum.success);
        }
      }
    }, (err) {
      state = state.copyWith(updateState: StateEnum.error);
      log(err.response.toString());
    });
  }

  Future deleteState({required String stateId}) async {
    state = state.copyWith(deleteState: StateEnum.loading);
    final delete = await statesService.deleteState(
      slug: ref
          .watch(ProviderList.workspaceProvider)
          .selectedWorkspace
          .workspaceSlug,
      projectId: ref.watch(ProviderList.projectProvider).currentProject['id'],
      stateId: stateId,
    );

    delete.fold((deleted) {
      final projectStates = state.projectStates;
      projectStates.removeWhere((key, value) => key == stateId);
      final Map<String, List<StateModel>> updatedGroups = {
        ...state.stateGroups
      };
      updatedGroups.forEach((groupId, groupStates) {
        final int indexToRemove =
            groupStates.indexWhere((s) => s.id == stateId);
        if (indexToRemove != -1) {
          groupStates.removeAt(indexToRemove);
          updatedGroups[groupId] = groupStates;
        }
      });
      state = state.copyWith(
          states: projectStates,
          stateGroups: updatedGroups,
          deleteState: StateEnum.success);
    }, (err) {
      state = state.copyWith(deleteState: StateEnum.error);
      log(err.response.toString());
    });
  }
}
