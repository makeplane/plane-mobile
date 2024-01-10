import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/config/apis.dart';
import 'package:plane/config/config_variables.dart';
import 'package:plane/models/config_model.dart';
import 'package:plane/services/dio_service.dart';
import 'package:plane/utils/enums.dart';

class ConfigModel {
  ConfigModel({required this.data, required this.getConfigState});
  // Map<String, dynamic> configData;
  ConfigsModel? data;
  StateEnum getConfigState;
  ConfigModel copyWith({ConfigsModel? data, StateEnum? getConfigState}) {
    return ConfigModel(
        data: data ?? this.data,
        getConfigState: getConfigState ?? this.getConfigState);
  }
}

class ConfigProvider extends StateNotifier<ConfigModel> {
  ConfigProvider(this.ref)
      : super(
          ConfigModel(
              data: ConfigsModel().empty(), getConfigState: StateEnum.loading),
        );
  Ref ref;

  Future getConfig() async {
    state.copyWith(
        data: ConfigsModel().empty(), getConfigState: StateEnum.loading);
    try {
      var url = APIs.configApi;
      var response = await DioConfig().dioServe(
        hasAuth: false,
        hasBody: false,
        url: url,
        httpMethod: HttpMethod.get,
      );
      log(response.data.toString());
      state = state.copyWith(
          data: ConfigsModel.fromJson(response.data),
          getConfigState: StateEnum.success);
      initializeEnvs(state.data!);
    } on DioException catch (e) {
      log(e.error.toString());
      state = state.copyWith(
          data: ConfigsModel().empty(), getConfigState: StateEnum.error);
    }
  }
}

void initializeEnvs(ConfigsModel data) {
  Config.googleClientId = data.googleClientId!;
  Config.googleServerClientId = data.googleServerClientId!;
  Config.googleIosClientId = data.googleIosClientId!;
  // Config.reversedGoogleIosClientId = data.reversedGoogleIosClientId!;
  Config.posthogApiKey = data.posthogApiKey!;
  Config.posthogHost = data.posthogHost!;
  Config.magicLogin = data.magicLogin!;
  Config.emailPasswordLogin = data.emailPasswordLogin!;
  Config.hasUnsplashConfigured = data.hasUnsplashConfigured!;
  Config.hasOpenaiConfigured = data.hasOpenaiConfigured!;
  Config.fileSizeLimit = data.fileSizeLimit!;
  Config.isSmtpConfigured = data.isSmtpConfigured!;
  Config.webUrl = dotenv.env['WEB_URL'];
  Config.sentryDsn = dotenv.env['SENTRY_DSN'];
}
