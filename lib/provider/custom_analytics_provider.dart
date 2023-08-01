import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane_startup/config/apis.dart';
import 'package:plane_startup/models/workpsace_custom_analytics_modal.dart';
import 'package:plane_startup/services/dio_service.dart';
import 'package:plane_startup/utils/enums.dart';

class CustomAnalyticsModal {
  StateEnum customAnalyticsState = StateEnum.empty;
  WorkspaceCustomAnalyticsModal? customData;

  CustomAnalyticsModal(
      {required this.customAnalyticsState, required this.customData});

  CustomAnalyticsModal copyWith(
      {StateEnum? customAnalyticsState,
      WorkspaceCustomAnalyticsModal? customData}) {
    return CustomAnalyticsModal(
        customData: customData,
        customAnalyticsState:
            customAnalyticsState ?? this.customAnalyticsState);
  }
}

class WorkspaceCusomtAnalyticsProvider
    extends StateNotifier<CustomAnalyticsModal> {
  WorkspaceCusomtAnalyticsProvider(
      StateNotifierProviderRef<WorkspaceCusomtAnalyticsProvider,
              CustomAnalyticsModal>
          this.ref)
      : super(CustomAnalyticsModal(
            customData: null, customAnalyticsState: StateEnum.empty));
  Ref ref;

  Future getWorkspaceCustomAnalytics({
    required String slug,
  }) async {
    var url =
        '${APIs.workspaceCustomAnlytics.replaceFirst('\$SLUG', slug)}?x_axis=assignees__email&y_axis=issue_count';
    try {
      var response = await DioConfig().dioServe(
        hasAuth: true,
        url: url,
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      state = state.copyWith(
          customData: WorkspaceCustomAnalyticsModal.fromJson(response.data),
          customAnalyticsState: StateEnum.success);
    } catch (e) {
      if (e is DioException) {
        log(e.error.toString());
      }
      log(e.toString());
      state = state.copyWith(customAnalyticsState: StateEnum.error);
    }
  }
}
