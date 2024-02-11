import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/config/apis.dart';
import 'package:plane/core/dio/dio_service.dart';

class SearchIssueProvider with ChangeNotifier {
  List<dynamic> issues = [];
  DataState searchIssuesState = DataState.loading;

  void clear() {
    issues = [];
  }

  Future getIssues(
      {required String slug,
      required String projectId,
      required String issueId,
      String input = '',
      // required bool parent
      required IssueDetailCategory type}) async {
    searchIssuesState = DataState.loading;
    final String query = type == IssueDetailCategory.parent
        ? 'parent'
        : type == IssueDetailCategory.subIssue
            ? 'sub_issue'
            : type == IssueDetailCategory.addCycleIssue
                ? 'cycle'
                : type == IssueDetailCategory.addModuleIssue
                    ? 'module'
                    : 'blocker_blocked_by';
    String url = '';
    if (input != '') {
      url = issueId.isEmpty
          ? '${APIs.searchIssues.replaceFirst('\$SLUG', slug).replaceFirst('\$PROJECTID', projectId)}?search=$input&$query=true'
          : '${APIs.searchIssues.replaceFirst('\$SLUG', slug).replaceFirst('\$PROJECTID', projectId)}?search=$input&$query=true&issue_id=$issueId';
    } else {
      url = issueId.isEmpty
          ? '${APIs.searchIssues.replaceFirst('\$SLUG', slug).replaceFirst('\$PROJECTID', projectId)}?search&$query=true'
          : '${APIs.searchIssues.replaceFirst('\$SLUG', slug).replaceFirst('\$PROJECTID', projectId)}?search&$query=true&issue_id=$issueId';
    }
    try {
      final response = await DioClient().request(
        hasAuth: true,
        url: url,
        hasBody: false,
        httpMethod: HttpMethod.get,
      );

      issues.clear();
      issues = response.data;
      searchIssuesState = DataState.success;
      notifyListeners();
    } on DioException catch (e) {
      log(e.message.toString());
      searchIssuesState = DataState.error;
      notifyListeners();
    }
  }

  void clearIssues() {
    searchIssuesState = DataState.loading;
    issues.clear();
    notifyListeners();
  }

  void setStateToLoading() {
    searchIssuesState = DataState.loading;
    notifyListeners();
  }
}
