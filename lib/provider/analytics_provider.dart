import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane_startup/config/apis.dart';
import 'package:plane_startup/models/workpsace_custom_analytics_modal.dart';
import 'package:plane_startup/models/workspace_analytics_modal.dart';
import 'package:plane_startup/services/dio_service.dart';
import 'package:plane_startup/utils/enums.dart';

class AnalyticsModal {
  StateEnum analyticsState = StateEnum.empty;
  WorkspaceAnalyticsModal? data;

  AnalyticsModal({required this.analyticsState, required this.data});

  AnalyticsModal copyWith(
      {StateEnum? analyticsState, WorkspaceAnalyticsModal? data}) {
    return AnalyticsModal(
        data: data, analyticsState: analyticsState ?? this.analyticsState);
  }
}

class AnalyticsProvider extends StateNotifier<AnalyticsModal> {
  AnalyticsProvider(
      StateNotifierProviderRef<AnalyticsProvider, AnalyticsModal> this.ref)
      : super(AnalyticsModal(data: null, analyticsState: StateEnum.empty));
  Ref ref;

  Future getWorkspaceAnalytics({
    required String slug,
  }) async {
    state = state.copyWith(analyticsState: StateEnum.loading);
    var url = APIs.workspaceDefaultAnlytics.replaceFirst('\$SLUG', slug);
    try {
      var response = await DioConfig().dioServe(
        hasAuth: true,
        url: url,
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      state = state.copyWith(
          data: WorkspaceAnalyticsModal.fromJson(response.data),
          analyticsState: StateEnum.success);
    } catch (e) {
      if (e is DioException) {
        log(e.error.toString());
      }
      log(e.toString());
      state = state.copyWith(analyticsState: StateEnum.error);
    }
  }
}
