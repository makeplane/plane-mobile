import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/models/Project/Label/label.model.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/repository/labels.service.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/utils/global_functions.dart';

class LabelState {
  // Properties
  StateEnum labelState = StateEnum.empty;
  Map<String, LabelModel> projectLabels = {};
  Map<String, LabelModel> workspaceLabels = {};

  // Constructor
  LabelState({
    required this.projectLabels,
    required this.workspaceLabels,
    required this.labelState,
  });

  // CopyWith
  LabelState copyWith(
      {StateEnum? labelState,
      Map<String, LabelModel>? projectLabels,
      Map<String, LabelModel>? workspaceLabels}) {
    return LabelState(
        labelState: labelState ?? this.labelState,
        projectLabels: projectLabels ?? this.projectLabels,
        workspaceLabels: workspaceLabels ?? this.workspaceLabels);
  }

  // Initialize with empty states
  factory LabelState.initialize() {
    return LabelState(
        projectLabels: {}, workspaceLabels: {}, labelState: StateEnum.empty);
  }
}

class LabelNotifier extends StateNotifier<LabelState> {
  LabelNotifier(this.ref, this._labelsService) : super(LabelState.initialize());
  // Ref for accessing other providers
  final Ref ref;
  // Labels Service
  final LabelsService _labelsService;

  // Get Label by Id
  LabelModel? getLabelById(String id) {
    return state.projectLabels[id];
  }

  // Get List of Label IDs I
  List<String> getLabelIds() {
    return state.projectLabels.keys.toList();
  }

  // Get Project Labels
  Future getProjectLabels() async {
    state = state.copyWith(labelState: StateEnum.loading);
    final projectID =
        ref.read(ProviderList.projectProvider).currentProject['id'];
    final slug = ref
        .read(ProviderList.workspaceProvider)
        .selectedWorkspace
        .workspaceSlug;
    final response = await _labelsService.getProjectLabels(slug, projectID);
    response.fold(
      (labels) {
        state = state.copyWith(
            projectLabels: labels, labelState: StateEnum.success);
      },
      (err) {
        state = state.copyWith(labelState: StateEnum.error);
      },
    );
  }

  // Get Workspace Labels
  Future getWorkspaceLabels() async {
    state = state.copyWith(labelState: StateEnum.loading);
    final slug = ref
        .read(ProviderList.workspaceProvider)
        .selectedWorkspace
        .workspaceSlug;
    final response = await _labelsService.getProjectLabels(slug, '');
    response.fold(
      (labels) {
        state = state.copyWith(
            workspaceLabels: labels, labelState: StateEnum.success);
      },
      (err) {
        state = state.copyWith(labelState: StateEnum.error);
      },
    );
  }

  // Create Label
  Future createLabel(Map<String, dynamic> payload) async {
    state = state.copyWith(labelState: StateEnum.loading);
    final slug = ref
        .read(ProviderList.workspaceProvider)
        .selectedWorkspace
        .workspaceSlug;
    final projectID =
        ref.read(ProviderList.projectProvider).currentProject['id'];
    final response = await _labelsService.createLabel(slug, projectID, payload);
    response.fold(
      (label) {
        state = state.copyWith(projectLabels: {
          ...state.projectLabels,
          label.id: label,
        }, labelState: StateEnum.success);
        sendPostHogEvent(method: CRUD.create, labelID: label.id);
      },
      (err) {
        state = state.copyWith(labelState: StateEnum.error);
      },
    );
  }

  // Update Label
  Future updateLabel(Map<String, dynamic> payload) async {
    state = state.copyWith(labelState: StateEnum.loading);
    final slug = ref
        .read(ProviderList.workspaceProvider)
        .selectedWorkspace
        .workspaceSlug;
    final projectID =
        ref.read(ProviderList.projectProvider).currentProject['id'];
    final response = await _labelsService.updateLabel(slug, projectID, payload);
    response.fold(
      (label) {
        final projectLabels = state.projectLabels;
        projectLabels[label.id] = LabelModel.fromJson({
          ...projectLabels[label.id]!.toJson(),
          ...label.toJson(),
        });
        state = state.copyWith(
            projectLabels: projectLabels, labelState: StateEnum.success);
        sendPostHogEvent(method: CRUD.update, labelID: label.id);
      },
      (err) {
        state = state.copyWith(labelState: StateEnum.error);
      },
    );
  }

  // Delete Label
  Future deleteLabel(String labelID) async {
    state = state.copyWith(labelState: StateEnum.loading);
    final slug = ref
        .read(ProviderList.workspaceProvider)
        .selectedWorkspace
        .workspaceSlug;
    final projectID =
        ref.read(ProviderList.projectProvider).currentProject['id'];
    final response = await _labelsService.deleteLabel(slug, projectID, labelID);
    response.fold(
      (label) {
        state = state.copyWith(
            projectLabels: state.projectLabels..remove(labelID),
            labelState: StateEnum.success);
      },
      (err) {
        state = state.copyWith(labelState: StateEnum.error);
      },
    );
    sendPostHogEvent(method: CRUD.delete, labelID: labelID);
  }

  // SEND POSTHOG EVENT
  void sendPostHogEvent({required CRUD method, required String labelID}) {
    final workspaceProvider = ref.read(ProviderList.workspaceProvider);
    final projectProvider = ref.read(ProviderList.projectProvider);
    final profileProvider = ref.read(ProviderList.profileProvider);
    postHogService(
        eventName: method == CRUD.create
            ? 'ISSUE_LABEL_CREATE'
            : method == CRUD.update
                ? 'ISSUE_LABEL_UPDATE'
                : method == CRUD.delete
                    ? 'ISSUE_LABEL_DELETE'
                    : '',
        properties: {
          'WORKSPACE_ID': workspaceProvider.selectedWorkspace.workspaceId,
          'WORKSPACE_SLUG': workspaceProvider.selectedWorkspace.workspaceSlug,
          'WORKSPACE_NAME': workspaceProvider.selectedWorkspace.workspaceName,
          'PROJECT_ID': projectProvider.projectDetailModel!.id,
          'PROJECT_NAME': projectProvider.projectDetailModel!.name,
          'LABEL_ID': labelID
        },
        userEmail: profileProvider.userProfile.email ?? '',
        userID: profileProvider.userProfile.id ?? '');
  }
}
