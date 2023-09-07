import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:plane/config/apis.dart';
import 'package:plane/services/dio_service.dart';
import 'package:plane/utils/enums.dart';

class EstimatesProvider with ChangeNotifier {
  var estimates = [];
  StateEnum estimateState = StateEnum.idle;

  Future getEstimates({required String slug, required String projID}) async {
    try {
      estimateState = StateEnum.loading;
      var response = await DioConfig().dioServe(
        hasAuth: true,
        url: APIs.listEstimates
            .replaceAll("\$SLUG", slug)
            .replaceAll('\$PROJECTID', projID),
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      estimates = response.data;
      estimateState = StateEnum.success;
      //  log('get estimates${response.data}');

      notifyListeners();
    } on DioException catch (e) {
      estimateState = StateEnum.error;
      log('Error in Estimates  ${e.message}');
      log(e.error.toString());
      notifyListeners();
    }
  }

  Future createEstimates(
      {required String slug, required String projID, required body}) async {
    try {
      estimateState = StateEnum.loading;
      await DioConfig().dioServe(
        hasAuth: true,
        url: APIs.listEstimates
            .replaceAll("\$SLUG", slug)
            .replaceAll('\$PROJECTID', projID),
        hasBody: true,
        httpMethod: HttpMethod.post,
        data: body,
      );

      getEstimates(slug: slug, projID: projID);
    } on DioException catch (e) {
      estimateState = StateEnum.error;
      log('Error in Estimates  ${e.message}');
      log(e.error.toString());
      notifyListeners();
    }
  }

  Future updateEstimates(
      {required String slug,
      required String projID,
      required String estimateID,
      required body}) async {
    try {
      log('${APIs.listEstimates.replaceAll("\$SLUG", slug).replaceAll('\$PROJECTID', projID)}$estimateID/');
      estimateState = StateEnum.loading;
      await DioConfig().dioServe(
        hasAuth: true,
        url:
            '${APIs.listEstimates.replaceAll("\$SLUG", slug).replaceAll('\$PROJECTID', projID)}$estimateID/',
        hasBody: true,
        httpMethod: HttpMethod.patch,
        data: body,
      );

      getEstimates(slug: slug, projID: projID);
    } on DioException catch (e) {
      estimateState = StateEnum.error;
      log('Error in Estimates  ${e.message}');
      log(e.error.toString());
      notifyListeners();
    }
  }

  Future deleteEstimates(
      {required String slug,
      required String projID,
      required String estimateID}) async {
    try {
      estimateState = StateEnum.loading;
      await DioConfig().dioServe(
        hasAuth: true,
        url:
            '${APIs.listEstimates.replaceAll("\$SLUG", slug).replaceAll('\$PROJECTID', projID)}$estimateID/',
        hasBody: false,
        httpMethod: HttpMethod.delete,
      );

      getEstimates(slug: slug, projID: projID);
    } on DioException catch (e) {
      estimateState = StateEnum.error;
      log('Error in Estimates  ${e.message}');
      log(e.error.toString());
      notifyListeners();
    }
  }
}
