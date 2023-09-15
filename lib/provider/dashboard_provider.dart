import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/config/apis.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/services/dio_service.dart';
import 'package:plane/utils/enums.dart';

class DashBoardProvider extends ChangeNotifier {
  DashBoardProvider(ChangeNotifierProviderRef<DashBoardProvider> this.ref);
  Ref? ref;
  StateEnum getDashboardState = StateEnum.loading;
  Map dashboardData = {};
  Map issuesClosedByMonth = {};
  int selectedMonthForissuesClosedByMonthWidget = DateTime.now().month;
  bool hideGithubBlock = false;
  Future getDashboard() async {
    getIssuesClosedByMonth(DateTime.now().month);
    getDashboardState = StateEnum.loading;
    try {
      var response = await DioConfig().dioServe(
        hasAuth: true,
        url: APIs.dashboard.replaceAll(
            '\$SLUG',
            ref!
                .read(ProviderList.workspaceProvider)
                .selectedWorkspace!
                .workspaceSlug),
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      dashboardData = response.data;
      getDashboardState = StateEnum.success;
      notifyListeners();
    } catch (e) {
      if (e is DioException) {
        log(e.response.toString());
      }
      log(e.toString());
      getDashboardState = StateEnum.error;
      notifyListeners();
    }
  }

  Future getIssuesClosedByMonth(int month) async {
    try {
      var response = await DioConfig().dioServe(
        hasAuth: true,
        url: '${APIs.dashboard}?month=$month'.replaceAll(
            '\$SLUG',
            ref!
                .read(ProviderList.workspaceProvider)
                .selectedWorkspace!
                .workspaceSlug),
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      issuesClosedByMonth = response.data;
      selectedMonthForissuesClosedByMonthWidget = month;
      notifyListeners();
    } catch (e) {
      if (e is DioException) {
        log(e.response.toString());
      }
      log(e.toString());
      notifyListeners();
    }
  }
}
