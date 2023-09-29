import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/config/apis.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/services/dio_service.dart';
import 'package:plane/utils/enums.dart';

import '../repository/dashboard_service.dart';

class DashBoardProvider extends ChangeNotifier {
  DashBoardProvider(
      {required ChangeNotifierProviderRef<DashBoardProvider>? this.ref,
      required this.dashboardService});
  Ref? ref;
  DashboardService dashboardService;

  StateEnum getDashboardState = StateEnum.loading;
  Map dashboardData = {};
  Map issuesClosedByMonth = {};
  int selectedMonthForissuesClosedByMonthWidget = DateTime.now().month;
  bool hideGithubBlock = false;

  Future getDashboard() async {
    getIssuesClosedByMonth(DateTime.now().month);
    getDashboardState = StateEnum.loading;
    try {
      final workspaceSlug = ref!
          .read(ProviderList.workspaceProvider)
          .selectedWorkspace
          .workspaceSlug;

      dashboardData = await dashboardService.getDashboardData(
          url: APIs.dashboard.replaceAll('\$SLUG', workspaceSlug));
      getDashboardState = StateEnum.success;
      notifyListeners();
    } on DioException catch (err) {
      log(err.toString());
      getDashboardState = StateEnum.error;
      notifyListeners();
    }
  }

  Future getIssuesClosedByMonth(int month) async {
    try {
      final response = await DioConfig().dioServe(
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
