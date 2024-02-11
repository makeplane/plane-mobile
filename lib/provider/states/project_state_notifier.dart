import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/models/project/state/state_model.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/provider/states/project_states_state.dart';
import 'package:plane/repository/project_state_service.dart';
import 'package:plane/utils/enums.dart';

class StatesProvider extends StateNotifier<ProjectStatesState> {
  StatesProvider(this.ref, this.statesService)
      : super(ProjectStatesState.initialize());
  Ref ref;
  StatesService statesService;

  StateModel? getStateById(String stateId) {
    return state.projectStates[stateId];
  }  
  void getGroupedStates() {
    state = state.copyWith(stateGroups: {
      for (final stateGroup in defaultStateGroups)
        stateGroup: state.projectStates.values.where((state) {
          return state.group == stateGroup;
        }).toList()
    });
  }

  Future getStates() async {
    state = state.copyWith(statesState: DataState.loading);
    final projectId =
        ref.read(ProviderList.projectProvider).currentProject['id'];
    final slug = ref.read(ProviderList.workspaceProvider).slug;
    final states =
        await statesService.getStates(slug: slug, projectId: projectId);
    states.fold(
      (states) {
        state = state.copyWith(states: states, statesState: DataState.success);
        getGroupedStates();
      },
      (err) {
        if (err.response!.statusCode == 403) {
          state = state.copyWith(statesState: DataState.restricted);
        } else {
          state = state.copyWith(statesState: DataState.error);
        }
      },
    );
  }

  Future createState({required Map data}) async {
    final projectId =
        ref.read(ProviderList.projectProvider).currentProject['id'];
    final slug = ref
        .read(ProviderList.workspaceProvider)
        .selectedWorkspace
        .workspaceSlug;
    state = state.copyWith(createStateLoading: DataState.loading);
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
          createStateLoading: DataState.success);
    }, (err) {
      log(err.response.toString());
      state = state.copyWith(createStateLoading: DataState.error);
    });
  }

  Future updateState({
    required Map data,
    required String slug,
    required String projectId,
    required String stateId,
  }) async {
    state = state.copyWith(updateState: DataState.loading);
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
              updateState: DataState.success);
        }
      }
    }, (err) {
      state = state.copyWith(updateState: DataState.error);
      log(err.response.toString());
    });
  }

  Future deleteState({required String stateId}) async {
    state = state.copyWith(deleteState: DataState.loading);
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
          deleteState: DataState.success);
    }, (err) {
      state = state.copyWith(deleteState: DataState.error);
      log(err.response.toString());
    });
  }
}
