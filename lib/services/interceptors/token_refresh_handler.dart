import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:plane/config/apis.dart';
import 'package:plane/config/const.dart';
import 'package:plane/config/http_satus_codes.dart';
import 'package:plane/screens/on_boarding/on_boarding_screen.dart';
import 'package:plane/services/dio_service.dart';
import 'package:plane/services/shared_preference_service.dart';
import 'package:plane/utils/enums.dart';

class ReGenerateToken extends Interceptor {
  ReGenerateToken(this.dio);
  final Dio dio;
  int retryCount = 0;
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    try {
      if (err.response?.statusCode == status401Unauthorized && retryCount < 1) {
        retryCount++;
        final Response response;
        await generateToken(dio);
        switch (err.requestOptions.method) {
          case 'GET':
            response = await dio.get(err.requestOptions.uri.toString());
            break;
          case 'POST':
            response = await dio.post(err.requestOptions.uri.toString());
            break;
          case 'PUT':
            response = await dio.put(err.requestOptions.uri.toString());
            break;
          case 'DELETE':
            response = await dio.delete(err.requestOptions.uri.toString());
            break;
          case 'PATCH':
            response = await dio.patch(err.requestOptions.uri.toString());
            break;
          default:
            response = await dio.get(err.requestOptions.uri.toString());
            break;
        }

        retryCount = 0;
        log(response.toString());
        handler.resolve(response);
      } else {
        handler.reject(err);
      }
    } catch (error) {
      await SharedPrefrenceServices.instance.clear();
      Const.accessToken = '';
      Const.userId = null;
      Navigator.push(Const.globalKey.currentContext!,
          MaterialPageRoute(builder: (ctx) => const OnBoardingScreen()));
      handler.reject(err);
    }
  }

  Future<void> generateToken(Dio dio) async {
    // await Future.delayed(const Duration(seconds: 1));
    // log('TOKEN GENERATED');
    // Const.accessToken = Const.accessToken!.split('|').first;
    // dio.options.headers['Authorization'] = 'Bearer ${Const.accessToken!}';

    try {
      final response = await DioConfig().dioServe(
        hasAuth: false,
        url: '${APIs.baseApi}/api/token/refresh/',
        hasBody: true,
        data: {"refresh": Const.refreshToken},
        httpMethod: HttpMethod.post,
      );
      SharedPrefrenceServices.setTokens(
        accessToken: response.data['access'],
        refreshToken: Const.refreshToken!,
      );
      dio.options.headers['Authorization'] = 'Bearer ${Const.accessToken!}';
    } on DioException catch (error) {
      log(error.toString());
      rethrow;
    }
  }
}
