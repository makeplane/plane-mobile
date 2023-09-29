import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:plane/config/apis.dart';
import 'package:plane/services/dio_service.dart';
import 'package:plane/utils/enums.dart';

class ActivityProvider extends ChangeNotifier {
  StateEnum getActivityState = StateEnum.loading;
  List<dynamic> data = [];

  void clear() {
    data = [];
    getActivityState = StateEnum.loading;
    notifyListeners();
  }

  void setState() {
    notifyListeners();
  }

  void getAcivity({
    required String slug,
  }) async {
    getActivityState = StateEnum.loading;
    try {
      final response = await DioConfig().dioServe(
        hasAuth: true,
        url: APIs.activity.replaceAll('\$SLUG', slug),
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      data = response.data['results'];
      getActivityState = StateEnum.success;
      notifyListeners();
    } catch (e) {
      if (e is DioException) {
        log(e.response.toString());
      }
      getActivityState = StateEnum.error;
      notifyListeners();
    }
  }
}
