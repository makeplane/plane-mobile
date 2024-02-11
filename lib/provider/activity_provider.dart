import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:plane/config/apis.dart';
import 'package:plane/core/dio/dio_service.dart';
import 'package:plane/utils/enums.dart';

class ActivityProvider extends ChangeNotifier {
  DataState getActivityState = DataState.loading;
  List<dynamic> data = [];

  void clear() {
    data = [];
    getActivityState = DataState.loading;
    notifyListeners();
  }

  void setState() {
    notifyListeners();
  }

  void getAcivity({
    required String slug,
  }) async {
    getActivityState = DataState.loading;
    try {
      final response = await DioClient().request(
        hasAuth: true,
        url: APIs.activity.replaceAll('\$SLUG', slug),
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      data = response.data['results'];
      getActivityState = DataState.success;
      notifyListeners();
    } catch (e) {
      if (e is DioException) {
        log(e.response.toString());
      }
      getActivityState = DataState.error;
      notifyListeners();
    }
  }
}
