import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/config/apis.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/core/dio/dio_service.dart';
import 'package:plane/utils/enums.dart';

import '../repository/dashboard_service.dart';

class DashBoardProvider extends ChangeNotifier {
  DashBoardProvider(
      {required ChangeNotifierProviderRef<DashBoardProvider>? this.ref,
      required this.dashboardService});
  Ref? ref;
  DashboardService dashboardService;

  DataState getDashboardState = DataState.loading;
  DataState getIssuesClosedThisMonthState = DataState.loading;
  Map dashboardData = {};
  Map issuesClosedByMonth = {};
  int selectedMonthForissuesClosedByMonthWidget = DateTime.now().month;
  bool hideGithubBlock = false;

  Future getDashboard() async {
    getIssuesClosedByMonth(DateTime.now().month);
    getDashboardState = DataState.loading;
    try {
      final workspaceSlug = ref!
          .read(ProviderList.workspaceProvider)
          .selectedWorkspace
          .workspaceSlug;

      dashboardData = await dashboardService.getDashboardData(
          url: APIs.dashboard.replaceAll('\$SLUG', workspaceSlug));
      getDashboardState = DataState.success;
      notifyListeners();
    } on DioException catch (err) {
      log(err.toString());
      getDashboardState = DataState.error;
      notifyListeners();
    }
  }

  Future getIssuesClosedByMonth(int month) async {
    try {
      getIssuesClosedThisMonthState = DataState.loading;
      notifyListeners();
      final response = await DioClient().request(
        hasAuth: true,
        url: '${APIs.dashboard}?month=$month'.replaceAll(
            '\$SLUG',
            ref!
                .read(ProviderList.workspaceProvider)
                .selectedWorkspace
                .workspaceSlug),
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      issuesClosedByMonth = response.data;
      selectedMonthForissuesClosedByMonthWidget = month;
      getIssuesClosedThisMonthState = DataState.success;
      notifyListeners();
    } catch (e) {
      if (e is DioException) {
        log(e.response.toString());
      }
      log(e.toString());
      getIssuesClosedThisMonthState = DataState.error;
      notifyListeners();
    }
  }
}
