import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/config/apis.dart';
import 'package:plane_startup/services/dio_service.dart';
import 'package:plane_startup/utils/enums.dart';

class IntegrationProvider extends ChangeNotifier {
  IntegrationProvider(ChangeNotifierProviderRef<IntegrationProvider> this.ref);
  Ref ref;
  StateEnum getIntegrationState = StateEnum.empty;
  StateEnum getInstalledIntegrationState = StateEnum.empty;

  var integrations = {};
  var githubIntegration;
  var slackIntegration;

  Future getAllAvailableIntegrations() async {
    getIntegrationState = StateEnum.loading;
    try {
      var response = await DioConfig().dioServe(
        hasAuth: true,
        url: APIs.integrations,
        hasBody: false,
        httpMethod: HttpMethod.get,
      );

      //  log(response.data.toString());
      response.data.forEach((element) {
        integrations[element['provider']] = element;
        integrations[element['provider']]["installed"] = false;
      });
      await getInstalledIntegrations();
      getIntegrationState = StateEnum.success;
      //  log(response.data.toString());
      notifyListeners();
    } catch (e) {
      if (e is DioException) {
        log(e.response.toString());
      }
      log(e.toString());
      getIntegrationState = StateEnum.error;
      notifyListeners();
    }
  }

  Future getInstalledIntegrations() async {
    getInstalledIntegrationState = StateEnum.loading;
    try {
      var response = await DioConfig().dioServe(
        hasAuth: true,
        url: APIs.wokspaceIntegrations.replaceAll(
            '\$SLUG',
            ref
                .read(ProviderList.workspaceProvider)
                .selectedWorkspace!
                .workspaceSlug),
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      var installed = [];
      response.data.forEach((element) {
        installed.add(element['integration_detail']['provider']);
      });
      for (var element in installed) {
        integrations[element]["installed"] = true;
      }
      getInstalledIntegrationState = StateEnum.success;
      //  log(response.data.toString());
      notifyListeners();
    } catch (e) {
      if (e is DioException) {
        log(e.response.toString());
      }
      log(e.toString());
      getInstalledIntegrationState = StateEnum.error;
      notifyListeners();
    }
  }

  Future getGitHubIntegration({
    required String slug,
    required String projectId,
    required String integrationId,
  }) async {
    githubIntegration = null;
    notifyListeners();
    try {
      var response = await DioConfig().dioServe(
        hasAuth: true,
        url: APIs.retrieveGithubIntegrations
            .replaceAll('\$SLUG', slug)
            .replaceAll('\$PROJECTID', projectId)
            .replaceAll('\$INTEGRATIONID', integrationId),
        hasBody: false,
        httpMethod: HttpMethod.get,
      );

      githubIntegration = response.data;
      notifyListeners();
    } catch (e) {
      if (e is DioException) {
        log(e.response.toString());
      }
    }
  }

  Future getSlackIntegration({
    required String slug,
    required String projectId,
    required String integrationId,
  }) async {
    slackIntegration = null;
    notifyListeners();
    try {
      var response = await DioConfig().dioServe(
        hasAuth: true,
        url: APIs.retrieveSlackIntegrations
            .replaceAll('\$SLUG', slug)
            .replaceAll('\$PROJECTID', projectId)
            .replaceAll('\$INTEGRATIONID', integrationId),
        hasBody: false,
        httpMethod: HttpMethod.get,
      );

      slackIntegration = response.data;
      notifyListeners();
    } catch (e) {
      if (e is DioException) {
        log(e.response.toString());
      }
    }
  }
}
