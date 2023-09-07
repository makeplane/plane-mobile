import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:plane/config/apis.dart';
import 'package:plane/services/dio_service.dart';
import 'package:plane/utils/enums.dart';

class FilterProvider with ChangeNotifier {
  StateEnum filterState = StateEnum.loading;

  Future applyFilter({required String slug, required String projectId}) async {
    try {
      filterState = StateEnum.loading;
      notifyListeners();
      await DioConfig().dioServe(
        hasAuth: true,
        url: APIs.issueDetails
            .replaceFirst("\$SLUG", slug)
            .replaceFirst('\$PROJECTID', projectId),
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      filterState = StateEnum.success;
      notifyListeners();
    } on DioException catch (e) {
      log(e.message.toString());
      filterState = StateEnum.error;
      notifyListeners();
    }
  }
}
