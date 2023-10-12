import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:plane/config/const.dart';
import 'package:plane/screens/on_boarding/on_boarding_screen.dart';
import 'package:plane/services/jwt_decoder.dart';
import 'package:plane/services/log.dart';
import 'package:plane/services/shared_preference_service.dart';


class ReGenerateToken extends Interceptor {
  ReGenerateToken(this.dio);
  final Dio dio;
  int retryCount = 0;
  bool isRefreshing = false;
  List<Map> failedApis = [];

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if ((JwtDecoder.tryDecode(Const.accessToken!) == null ||
            !JwtDecoder.isExpired(Const.accessToken!)) &&
        !isRefreshing) {
      try {
        isRefreshing = true;
        Log.warn('TOKEN EXPIRED');
        await generateToken(dio);
        options.headers['Authorization'] = 'Bearer ${Const.accessToken!}';
        return handler.next(options);
      } catch (error) {
        Log.error('GENERATE TOKEN FAILED');
        isRefreshing = false;
        await SharedPrefrenceServices.instance.clear();
        Const.accessToken = '';
        Const.userId = null;
        Navigator.push(Const.globalKey.currentContext!,
            MaterialPageRoute(builder: (ctx) => const OnBoardingScreen()));
        return handler.reject(DioException(requestOptions: options));
      }
    } else {
      if (isRefreshing) {
        Timer.periodic(const Duration(seconds: 6), (timer) async {
          if (timer.tick == 1) {
            timer.cancel();
            return handler.reject(DioException(requestOptions: options));
          }
          if (!isRefreshing) {
            timer.cancel();
            options.headers['Authorization'] = 'Bearer ${Const.accessToken!}';
            return handler.next(options);
          }
        });
      } else {
        return handler.next(options);
      }
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    Log.debug(
      'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
    );
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    Log.error(
      'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
    );
    super.onError(err, handler);
  }

  Future<void> generateToken(Dio dio) async {
    await Future.delayed(const Duration(seconds: 1));
    Log.info('TOKEN GENERATED');
    Const.accessToken = Const.accessToken!.split('|').first;
    dio.options.headers['Authorization'] = 'Bearer ${Const.accessToken!}';
    isRefreshing = false;
    // try {
    //   final response = await DioConfig().dioServe(
    //     hasAuth: false,
    //     url: '${APIs.baseApi}/api/token/refresh/',
    //     hasBody: true,
    //     data: {"refresh": Const.refreshToken},
    //     httpMethod: HttpMethod.post,
    //   );
    //   SharedPrefrenceServices.setTokens(
    //     accessToken: response.data['access'],
    //     refreshToken: Const.refreshToken!,
    //   );
    //   dio.options.headers['Authorization'] = 'Bearer ${Const.accessToken!}';
    // } on DioException catch (error) {
    //   log(error.toString());
    //   rethrow;
    // }
  }

  Future _retry(
      {required Dio dio, required RequestOptions requestOptions}) async {
    String endpoint = requestOptions.uri.toString();
    final Response response;
    try {
      switch (requestOptions.method) {
        case 'GET':
          response = await dio.get(endpoint);
          break;
        case 'POST':
          response = await dio.post(endpoint);
          break;
        case 'PUT':
          response = await dio.put(endpoint);
          break;
        case 'DELETE':
          response = await dio.delete(endpoint);
          break;
        case 'PATCH':
          response = await dio.patch(endpoint);
          break;
        default:
          response = await dio.get(endpoint);
          break;
      }
      return response;
    } on DioException catch (_) {
      rethrow;
    }
  }
}
