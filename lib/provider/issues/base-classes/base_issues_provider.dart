// ignore_for_file: non_constant_identifier_names

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:plane/models/project/issue-filter-properties-and-view/issue_filter_and_properties.dart';
import 'package:plane/models/project/issue/issue_model.dart';
import 'package:plane/models/project/layout-properties/layout_properties.model.dart';
import 'package:plane/utils/enums.dart';

import 'base_issue_state.dart';

abstract class ABaseIssuesProvider {
  /// Returns the [state] of the issues
  ABaseIssuesState get state;

  /// Returns the [category] of the issues
  IssueCategory get category;

  /// Returns whether display properties are enabled or not
  bool get isDisplayPropertiesEnabled;

  /// Returns the [issuesLayout] of the project
  IssuesLayout get issuesLayout;

  /// Returns the [layout] of the issues
  /// [layout] can be [kanban], [list], [table]
  /// [kanban] is the default layout
  IssuesLayout get layout;

  /// Returns the [display-filters] of the issues-layout
  DisplayFiltersModel get displayFilters;

  /// Returns the [display-properties] of the issues-layout
  /// [display-properties] can be [assignee], [priority], [state], [label],
  /// Returns the [display-properties] of the issues-layout
  DisplayPropertiesModel get displayProperties;

  /// Returns the group_by property of the issues-layout
  /// [group_by] can be [assignee], [priority], [state], [label],
  GroupBY get group_by;

  /// Returns the order_by property of the issues-layout
  /// [order_by] can be [manual], [lastCreated], [lastUpdated], [priority], [startDate]
  OrderBY get order_by;

  /// Applies the [filters], [display-properties], [dispaly-filters] to the [issuesLayout]
  void applyIssueLayoutView();

  /// Update current Layout issues
  void updateCurrentLayoutIssues(Map<String, List<IssueModel>> issues);

  /// Update [issue] position in kanban layout
  Future<void> onDragEnd(
      {required int newCardIndex,
      required int newListIndex,
      required int oldCardIndex,
      required int oldListIndex,
      required BuildContext context,
      required ABaseIssuesProvider issuesProvider});

  /// Fetches all [issues] with filters and properties
  Future<Either<DioException, Map<String, IssueModel>>> fetchIssues();

  /// param: [IssueModel]
  /// Creates a new [issue] with the given [payload]
  Future<Either<DioException, IssueModel>> createIssue(IssueModel payload);

  /// param: [IssueModel]
  /// Updates an existing [issue] with the given [payload]
  Future<Either<DioException, IssueModel>> updateIssue(IssueModel payload);

  /// param: [issueId]
  /// Deletes an existing [issue] with the given [issueId]
  Future<Either<DioException, void>> deleteIssue(String issueId);

  /// Fetches the view of the issues-layout
  Future<Either<DioException, LayoutPropertiesModel>> fetchLayoutProperties();

  /// param: [IssueLayoutDetails]
  /// Updates the view of the issues-layout with the given [viewId]
  Future<Either<DioException, LayoutPropertiesModel>> updateLayoutProperties(
      LayoutPropertiesModel payload);
}
