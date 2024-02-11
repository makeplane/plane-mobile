import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:plane/config/apis.dart';
import 'package:plane/core/dio/dio_service.dart';
import 'package:plane/utils/enums.dart';

class FilterProvider with ChangeNotifier {
  DataState filterState = DataState.loading;

  Future applyFilter({required String slug, required String projectId}) async {
    try {
      filterState = DataState.loading;
      notifyListeners();
      await DioClient().request(
        hasAuth: true,
        url: APIs.issueDetails
            .replaceFirst("\$SLUG", slug)
            .replaceFirst('\$PROJECTID', projectId),
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      filterState = DataState.success;
      notifyListeners();
    } on DioException catch (e) {
      log(e.message.toString());
      filterState = DataState.error;
      notifyListeners();
    }
  }
}
