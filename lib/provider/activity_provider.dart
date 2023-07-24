import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:plane_startup/config/apis.dart';
import 'package:plane_startup/services/dio_service.dart';
import 'package:plane_startup/utils/enums.dart';

class ActivityProvider extends ChangeNotifier {
  StateEnum getActivityState = StateEnum.loading;
  List<dynamic> data = [];

  getAcivity() async {
    getActivityState = StateEnum.loading;
    try {
      var response = await DioConfig().dioServe(
        hasAuth: true,
        url: APIs.activity,
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      data = response.data['results'];
      getActivityState = StateEnum.success;
      log(response.data.toString());
      notifyListeners();
    } catch (e) {
      if (e is DioException) {
        log(e.response.toString());
      }
      log(e.toString());
      getActivityState = StateEnum.error;
      notifyListeners();
    }
  }
}
