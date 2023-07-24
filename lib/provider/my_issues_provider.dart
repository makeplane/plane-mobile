
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:plane_startup/config/apis.dart';
import 'package:plane_startup/services/dio_service.dart';
import 'package:plane_startup/utils/enums.dart';


class MyIssuesProvider extends ChangeNotifier {
  StateEnum getMyIssuesState = StateEnum.loading;
  List<dynamic> data = [];

  Future getMyIssues({required String slug}) async {
    getMyIssuesState = StateEnum.loading;
    notifyListeners();
    try {
      var response = await DioConfig().dioServe(
        hasAuth: true,
        url: APIs.myIssues.replaceFirst('\$SLUG', slug),
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      data.clear();
      data = response.data;
      getMyIssuesState = StateEnum.success;
      notifyListeners();
    } catch (e) {
      if (e is DioException) {
        log(e.message.toString());
      }
      log(e.toString());
      getMyIssuesState = StateEnum.error;
      notifyListeners();
    }
  }
}
