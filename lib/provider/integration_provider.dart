import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/config/apis.dart';
import 'package:plane/core/dio/dio_service.dart';
import 'package:plane/utils/enums.dart';

class IntegrationProvider extends ChangeNotifier {
  IntegrationProvider(ChangeNotifierProviderRef<IntegrationProvider> this.ref);
  Ref ref;
  DataState getIntegrationState = DataState.empty;
  DataState getInstalledIntegrationState = DataState.empty;

  final integrations = {};
  dynamic githubIntegration;
  dynamic slackIntegration;

  Future getAllAvailableIntegrations() async {
    getIntegrationState = DataState.loading;
    try {
      final response = await DioClient().request(
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
      getIntegrationState = DataState.success;
      //  log(response.data.toString());
      notifyListeners();
    } catch (e) {
      if (e is DioException) {
        log(e.response.toString());
      }
      log(e.toString());
      getIntegrationState = DataState.error;
      notifyListeners();
    }
  }

  Future getInstalledIntegrations() async {
    getInstalledIntegrationState = DataState.loading;
    try {
      final response = await DioClient().request(
        hasAuth: true,
        url: APIs.wokspaceIntegrations.replaceAll(
            '\$SLUG',
            ref
                .read(ProviderList.workspaceProvider)
                .selectedWorkspace
                .workspaceSlug),
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      final installed = [];
      response.data.forEach((element) {
        installed.add(element['integration_detail']['provider']);
      });
      for (final element in installed) {
        integrations[element]["installed"] = true;
      }
      getInstalledIntegrationState = DataState.success;
      //  log(response.data.toString());
      notifyListeners();
    } catch (e) {
      if (e is DioException) {
        log(e.response.toString());
      }
      log(e.toString());
      getInstalledIntegrationState = DataState.error;
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
      final response = await DioClient().request(
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
      final response = await DioClient().request(
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
