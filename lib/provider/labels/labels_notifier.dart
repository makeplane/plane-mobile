import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/core/exception/plane_exception.dart';
import 'package:plane/models/project/label/label.model.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/repository/labels.repository.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/utils/global_functions.dart';
import 'labels_state.dart';

class LabelNotifier extends StateNotifier<LabelState> {
  LabelNotifier(this.ref, this._labelRepository)
      : super(LabelState.initialize());
  // Ref for accessing other providers
  final Ref ref;
  // Label repository
  final LabelRepository _labelRepository;

  // Returns the label from label-id
  LabelModel? getLabelById(String id) {
    return state.projectLabels[id];
  }

  // Returns the list of label ids I
  List<String> get getLabelIds => state.projectLabels.keys.toList();

  // Fetches project labels and store it in provider.
  Future<Either<PlaneException, Map<String, LabelModel>>>
      getProjectLabels() async {
    state = state.copyWith(labelState: DataState.loading);
    final projectID =
        ref.read(ProviderList.projectProvider).currentProject['id'];
    final slug = ref
        .read(ProviderList.workspaceProvider)
        .selectedWorkspace
        .workspaceSlug;
    final response = await _labelRepository.getProjectLabels(slug, projectID);
    return response.fold(
      (err) {
        state = state.copyWith(labelState: DataState.error);
        return Left(err);
      },
      (labels) {
        state = state.copyWith(
            projectLabels: labels, labelState: DataState.success);
        return Right(labels);
      },
    );
  }

  // Fetches workspace labels and store it in provider.
  Future<Either<PlaneException, Map<String, LabelModel>>>
      getWorkspaceLabels() async {
    state = state.copyWith(labelState: DataState.loading);
    final slug = ref
        .read(ProviderList.workspaceProvider)
        .selectedWorkspace
        .workspaceSlug;
    final response = await _labelRepository.getProjectLabels(slug, '');
    return response.fold(
      (err) {
        state = state.copyWith(labelState: DataState.error);
        return Left(err);
      },
      (labels) {
        state = state.copyWith(
            workspaceLabels: labels, labelState: DataState.success);
        return Right(labels);
      },
    );
  }

  /// Creates new label and adds it in [projectLabels]
  ///
  Future<Either<PlaneException, LabelModel>> createLabel(
      Map<String, dynamic> payload) async {
    state = state.copyWith(labelState: DataState.loading);
    final slug = ref
        .read(ProviderList.workspaceProvider)
        .selectedWorkspace
        .workspaceSlug;
    final projectID =
        ref.read(ProviderList.projectProvider).currentProject['id'];
    final response =
        await _labelRepository.createLabel(slug, projectID, payload);
    return response.fold(
      (err) {
        state = state.copyWith(labelState: DataState.error);
        return Left(err);
      },
      (label) {
        state = state.copyWith(projectLabels: {
          ...state.projectLabels,
          label.id: label,
        }, labelState: DataState.success);
        sendPostHogEvent(method: CRUD.create, labelID: label.id);
        return Right(label);
      },
    );
  }

  // Update Label
  Future<Either<PlaneException, LabelModel>> updateLabel(
      Map<String, dynamic> payload) async {
    state = state.copyWith(labelState: DataState.loading);
    final slug = ref
        .read(ProviderList.workspaceProvider)
        .selectedWorkspace
        .workspaceSlug;
    final projectID =
        ref.read(ProviderList.projectProvider).currentProject['id'];
    final response =
        await _labelRepository.updateLabel(slug, projectID, payload);
    return response.fold(
      (err) {
        state = state.copyWith(labelState: DataState.error);
        return Left(err);
      },
      (label) {
        final projectLabels = state.projectLabels;
        projectLabels[label.id] = LabelModel.fromJson({
          ...projectLabels[label.id]!.toJson(),
          ...label.toJson(),
        });
        state = state.copyWith(
            projectLabels: projectLabels, labelState: DataState.success);
        sendPostHogEvent(method: CRUD.update, labelID: label.id);
        return Right(label);
      },
    );
  }

  // Delete Label
  Future<Either<PlaneException, void>> deleteLabel(String labelID) async {
    state = state.copyWith(labelState: DataState.loading);
    final slug = ref
        .read(ProviderList.workspaceProvider)
        .selectedWorkspace
        .workspaceSlug;
    final projectID =
        ref.read(ProviderList.projectProvider).currentProject['id'];
    final response =
        await _labelRepository.deleteLabel(slug, projectID, labelID);
    return response.fold(
      (err) {
        state = state.copyWith(labelState: DataState.error);
        return Left(err);
      },
      (label) {
        state = state.copyWith(
            projectLabels: state.projectLabels..remove(labelID),
            labelState: DataState.success);
        sendPostHogEvent(method: CRUD.delete, labelID: labelID);
        return const Right(null);
      },
    );
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
          'PROJECT_ID': projectProvider.currentprojectDetails!.id,
          'PROJECT_NAME': projectProvider.currentprojectDetails!.name,
          'LABEL_ID': labelID
        },
        userEmail: profileProvider.userProfile.email ?? '',
        userID: profileProvider.userProfile.id ?? '');
  }
}
