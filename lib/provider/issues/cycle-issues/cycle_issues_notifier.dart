// ignore_for_file: non_constant_identifier_names
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/core/exception/plane_exception.dart';
import 'package:plane/kanban/models/inputs.dart';
import 'package:plane/models/project/issue-filter-properties-and-view/issue_filter_and_properties.dart';
import 'package:plane/models/project/layout-properties/layout_properties.model.dart';
import 'package:plane/provider/issues/base-classes/base_issues_provider.dart';
import 'package:plane/models/project/issue/issue_model.dart';
import 'package:plane/provider/issues/cycle-issues/cycle_issues_state.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/repository/issues/cycle_issues_repository.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/utils/issues/issues.helper.dart';
import 'package:plane/utils/issues/issues_converter.helper.dart';
import 'package:plane/utils/issues/kanban_board.helper.dart';

class CycleIssuesNotifier extends StateNotifier<CycleIssuesState>
    implements ABaseIssuesProvider {
  CycleIssuesNotifier(this.ref, this._cycleIssuesRepository)
      : super(CycleIssuesState.initial(ref));
  Ref ref;
  final CycleIssuesRepository _cycleIssuesRepository;

  @override
  DisplayFiltersModel get displayFilters =>
      state.layoutProperties.display_filters;

  @override
  IssuesLayout get layout =>
      IssuesConverter.fromStringToIssuesLayout(displayFilters.layout);

  @override
  GroupBY get group_by =>
      IssuesConverter.fromStringToGroupby(displayFilters.group_by);

  @override
  OrderBY get order_by =>
      IssuesConverter.fromStringToOrderby(displayFilters.order_by);

  @override
  DisplayPropertiesModel get displayProperties =>
      state.layoutProperties.display_properties;

  @override
  FiltersModel get appliedFilters => state.layoutProperties.filters;

  @override
  IssuesLayout get issuesLayout => IssuesConverter.fromStringToIssuesLayout(
      state.layoutProperties.display_filters.layout);

  @override
  bool get isDisplayPropertiesEnabled {
    final displayProperties = state.layoutProperties.display_properties;
    return displayProperties.assignee ||
        displayProperties.due_date ||
        displayProperties.labels ||
        displayProperties.state ||
        displayProperties.sub_issue_count ||
        displayProperties.priority ||
        displayProperties.link ||
        displayProperties.attachment_count;
  }

  void resetState() {
    state = CycleIssuesState.initial(ref);
  }

  @override
  void updateCurrentLayoutIssues(Map<String, List<IssueModel>> issues) {
    state = state.copyWith(currentLayoutIssues: issues);
  }

  @override
  Future<Either<PlaneException, IssueModel>> createIssue(
      IssueModel payload) async {
    final workspaceSlug = ref.read(ProviderList.workspaceProvider).slug;
    final projectId = ref.read(ProviderList.projectProvider).currentProjectId;
    state = state.copyWith(createIssueState: DataState.loading);
    final result = await _cycleIssuesRepository.createIssue(
        workspaceSlug, projectId, payload);
    final issues = state.rawIssues;
    return result.fold((err) {
      state = state.copyWith(createIssueState: DataState.error);
      return Left(err);
    }, (issue) {
      issues.addEntries([MapEntry(issue.id, issue)]);
      state = state.copyWith(
          createIssueState: DataState.success, rawIssues: issues);
      return Right(issue);
    });
  }

  @override
  Future<Either<PlaneException, void>> deleteIssue(String issueId) async {
    final workspaceSlug = ref.read(ProviderList.workspaceProvider).slug;
    final projectId = ref.read(ProviderList.projectProvider).currentProjectId;
    state = state.copyWith(createIssueState: DataState.loading);
    final result = await _cycleIssuesRepository.deleteIssue(
        workspaceSlug, projectId, issueId);
    final issues = state.rawIssues;
    return result.fold((err) {
      state = state.copyWith(createIssueState: DataState.error);
      return Left(err);
    }, (issue) {
      issues.remove(issueId);
      state = state.copyWith(
          createIssueState: DataState.success, rawIssues: issues);
      return const Right(null);
    });
  }

  @override
  Future<Either<PlaneException, IssueModel>> updateIssue(
      IssueModel payload) async {
    final workspaceSlug = ref.read(ProviderList.workspaceProvider).slug;
    final projectId = ref.read(ProviderList.projectProvider).currentProjectId;
    final result = await _cycleIssuesRepository.updateIssue(
        workspaceSlug, projectId, payload);
    final issues = state.rawIssues;
    return result.fold((err) {
      state = state.copyWith(createIssueState: DataState.error);
      return Left(err);
    }, (issue) {
      issues[issue.id] = issue;
      state = state.copyWith(
          createIssueState: DataState.success, rawIssues: issues);
      return Right(issue);
    });
  }

  Map<String, List<IssueModel>> _getIssuesOrganized(List<IssueModel> issues) {
    return IssuesHelper.organizeIssues(issues, group_by, order_by,
        labelIDs: ref.read(ProviderList.labelProvider.notifier).getLabelIds,
        memberIDs: ref
            .read(ProviderList.projectProvider)
            .projectMembers
            .map((e) => e['member']['id'].toString())
            .toList(),
        states: ref.read(ProviderList.statesProvider).projectStates);
  }

  List<BoardListsData> _getBoardOrganizedIssues(
      Map<String, List<IssueModel>> issues) {
    final kanbanHelper = KanbanBoardHelper(
      ref: ref,
      groupBY: group_by,
      orderBY: order_by,
      issues: issues,
      issuesProvider: this,
    );
    return kanbanHelper.organizeBoardIssues();
  }

  @override
  Future<Either<PlaneException, Map<String, IssueModel>>> fetchIssues() async {
    final workspaceSlug = ref.read(ProviderList.workspaceProvider).slug;
    final projectId = ref.read(ProviderList.projectProvider).currentProjectId;
    final cycleId =
        ref.read(ProviderList.cycleProvider).currentCycleDetails?.id;
    state = state.copyWith(fetchIssuesState: DataState.loading);

    /// prepare [query] params
    String query =
        IssuesHelper.getFilterQueryParams(state.layoutProperties.filters);
    query = '$query&sub_issue=${displayFilters.sub_issue}';

    /// fetch cycle-issues from api
    final result = await _cycleIssuesRepository.fetchIssues(
        workspaceSlug, projectId, cycleId!, query);

    return result.fold((err) {
      state = state.copyWith(fetchIssuesState: DataState.error);
      return Left(err);
    }, (issues) async {
      /// if layout is [kanban] then organize issues in board format, else organize in group format
      final currentLayoutIssues = _getIssuesOrganized(issues.values.toList());
      state = state.copyWith(
        fetchIssuesState: DataState.success,
        rawIssues: issues,
        currentLayoutIssues: currentLayoutIssues,
        kanbanOrganizedIssues: layout == IssuesLayout.kanban
            ? _getBoardOrganizedIssues(currentLayoutIssues)
            : state.kanbanOrganizedIssues,
      );
      return Right(issues);
    });
  }

  @override
  Future<Either<PlaneException, LayoutPropertiesModel>>
      fetchLayoutProperties() async {
    final workspaceSlug = ref.read(ProviderList.workspaceProvider).slug;
    final projectId = ref.read(ProviderList.projectProvider).currentProjectId;
    final cycleId =
        ref.read(ProviderList.cycleProvider).currentCycleDetails?.id;
    state = state.copyWith(
        fetchIssueLayoutViewState: DataState.loading,
        fetchIssuesState: DataState.loading);
    final result = await _cycleIssuesRepository.fetchLayoutProperties(
        workspaceSlug, projectId, cycleId!);
    return result.fold((err) {
      state = state.copyWith(fetchIssueLayoutViewState: DataState.error);
      return Left(err);
    }, (layoutProperties) {
      state = state.copyWith(
          fetchIssueLayoutViewState: DataState.success,
          layoutProperties: layoutProperties);
      return Right(layoutProperties);
    });
  }

  @override
  Future<Either<PlaneException, LayoutPropertiesModel>> updateLayoutProperties(
      LayoutPropertiesModel payload) async {
    final workspaceSlug = ref.read(ProviderList.workspaceProvider).slug;
    final projectId = ref.read(ProviderList.projectProvider).currentProjectId;
    final cycleId =
        ref.read(ProviderList.cycleProvider).currentCycleDetails?.id;

    /// if layout is updated to [kanban] from any other layout
    /// then organize issues in board format
    state = state.copyWith(layoutProperties: payload);
    final currentLayoutIssues =
        _getIssuesOrganized(state.rawIssues.values.toList());
    state = state.copyWith(
        kanbanOrganizedIssues: payload.display_filters.layout == 'kanban'
            ? _getBoardOrganizedIssues(currentLayoutIssues)
            : state.kanbanOrganizedIssues,
        currentLayoutIssues: currentLayoutIssues,
        layoutProperties: payload);

    final result = await _cycleIssuesRepository.updateLayoutProperties(
        workspaceSlug, projectId, cycleId!, payload);
    return result.fold((err) {
      state = state.copyWith(fetchIssueLayoutViewState: DataState.error);
      return Left(err);
    }, (layoutProperties) {
      return Right(layoutProperties);
    });
  }

  @override
  Future<void> onDragEnd(
      {required int newCardIndex,
      required int newListIndex,
      required int oldCardIndex,
      required int oldListIndex,
      required BuildContext context,
      required ABaseIssuesProvider issuesProvider}) async {
    KanbanBoardHelper.reorderIssue(
        newCardIndex: newCardIndex,
        oldCardIndex: oldCardIndex,
        newListIndex: newListIndex,
        oldListIndex: oldListIndex,
        groupBY: group_by,
        orderBY: order_by,
        context: context,
        currentLayoutIssues: state.currentLayoutIssues,
        issuesProvider: issuesProvider);
  }

  @override
  void applyIssueLayoutView() {
    final projectMembers =
        ref.read(ProviderList.projectProvider).projectMembers;
    final labelIds = ref.read(ProviderList.labelProvider.notifier).getLabelIds;
    final states = ref.read(ProviderList.statesProvider).projectStates;

    state = state.copyWith(
        currentLayoutIssues: IssuesHelper.organizeIssues(
            state.rawIssues.values.toList(), group_by, order_by,
            labelIDs: labelIds,
            memberIDs: projectMembers
                .map((e) => e['member']['id'].toString())
                .toList(),
            states: states));
  }

  @override
  IssuesCategory get category => IssuesCategory.PROJECT;
}
