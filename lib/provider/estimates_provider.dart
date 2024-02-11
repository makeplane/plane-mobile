import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:plane/config/apis.dart';
import 'package:plane/core/dio/dio_service.dart';
import 'package:plane/utils/enums.dart';

class EstimatesProvider with ChangeNotifier {
  List estimates = [];
  DataState estimateState = DataState.idle;

  Future getEstimates({required String slug, required String projID}) async {
    try {
      estimateState = DataState.loading;
      final response = await DioClient().request(
        hasAuth: true,
        url: APIs.listEstimates
            .replaceAll("\$SLUG", slug)
            .replaceAll('\$PROJECTID', projID),
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      estimates = response.data;
      estimateState = DataState.success;
      //  log('get estimates${response.data}');

      notifyListeners();
    } on DioException catch (e) {
      estimateState = DataState.error;
      log('Error in Estimates  ${e.message}');
      log(e.error.toString());
      notifyListeners();
    }
  }

  Future createEstimates(
      {required String slug, required String projID, required Map body}) async {
    try {
      estimateState = DataState.loading;
      await DioClient().request(
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
      estimateState = DataState.error;
      log('Error in Estimates  ${e.message}');
      log(e.error.toString());
      notifyListeners();
    }
  }

  Future updateEstimates(
      {required String slug,
      required String projID,
      required String estimateID,
      required Map body}) async {
    try {
      log('${APIs.listEstimates.replaceAll("\$SLUG", slug).replaceAll('\$PROJECTID', projID)}$estimateID/');
      estimateState = DataState.loading;
      await DioClient().request(
        hasAuth: true,
        url:
            '${APIs.listEstimates.replaceAll("\$SLUG", slug).replaceAll('\$PROJECTID', projID)}$estimateID/',
        hasBody: true,
        httpMethod: HttpMethod.patch,
        data: body,
      );

      getEstimates(slug: slug, projID: projID);
    } on DioException catch (e) {
      estimateState = DataState.error;
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
      estimateState = DataState.loading;
      await DioClient().request(
        hasAuth: true,
        url:
            '${APIs.listEstimates.replaceAll("\$SLUG", slug).replaceAll('\$PROJECTID', projID)}$estimateID/',
        hasBody: false,
        httpMethod: HttpMethod.delete,
      );

      getEstimates(slug: slug, projID: projID);
    } on DioException catch (e) {
      estimateState = DataState.error;
      log('Error in Estimates  ${e.message}');
      log(e.error.toString());
      notifyListeners();
    }
  }
}
