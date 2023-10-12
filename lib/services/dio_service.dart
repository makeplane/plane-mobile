// Dart imports:
import 'dart:async';
import 'dart:io';

// Package imports:
import 'package:dio/dio.dart';
import 'package:plane/config/const.dart';
import 'package:plane/services/interceptors/token_refresh_handler.dart';
import 'package:plane/services/log.dart';
import 'package:plane/utils/enums.dart';
import 'package:retry/retry.dart';

class DioConfig {
  // Static Dio created to directly access Dio client
  static Dio dio = Dio();
  static bool refreshingToken = false;
  static RequestInterceptorHandler? nextHandler;
  static RequestOptions? nextOptions;

  Dio getDio({
    dynamic data,
    bool hasAuth = true,
    bool hasBody = true,
  }) {
    Map<String, String> requestHeaders;

    // Passing Headers
    requestHeaders = {
      // 'Accept': 'application/json;charset=UTF-8',
      if (hasAuth) 'Authorization': 'Bearer ${Const.accessToken}',
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Credentials': 'true',
      'Access-Control-Allow-Headers': 'Content-Type',
      // 'User-Agent': Platform.isAndroid ? 'Android' : 'iOS',
    };

    BaseOptions options;
    // Adding Additional Options
    options = BaseOptions(
      receiveTimeout: const Duration(seconds: 15),
      connectTimeout: const Duration(seconds: 15),
      headers: requestHeaders,
    );

    dio.options = options;
    if (dio.interceptors.length == 1) {
      Log.info('Interceptor added');
      dio.interceptors.addAll([
        ReGenerateToken(dio),
        // InterceptorsWrapper(
        //   onRequest: (RequestOptions options,
        //       RequestInterceptorHandler handler) async {
        //     if (hasBody) options.data = data;
        //     return handler.reject(DioException(requestOptions: options));
        //   },
        // ),
      ]);
    }

    return dio;
  }

  Future<Response> dioServe({
    dynamic data,
    bool hasAuth = true,
    bool hasBody = true,
    required String url,
    HttpMethod httpMethod = HttpMethod.get,
  }) async {
    Response response;
    const timeoutDuration = Duration(seconds: 5);
    final dio = getDio(
      data: data,
      hasAuth: hasAuth,
      hasBody: hasBody,
    );
    try {
      response = await retry(
        () async {
          Response inResponse;
          switch (httpMethod) {
            case HttpMethod.get:
              inResponse = await dio.get(url).timeout(timeoutDuration);
              break;
            case HttpMethod.post:
              inResponse = await dio.post(url).timeout(timeoutDuration);
              break;
            case HttpMethod.put:
              inResponse = await dio.put(url).timeout(timeoutDuration);
              break;
            case HttpMethod.delete:
              inResponse = await dio.delete(url).timeout(timeoutDuration);
              break;
            case HttpMethod.patch:
              inResponse = await dio.patch(url).timeout(timeoutDuration);
              break;
            default:
              inResponse = await dio.get(url).timeout(timeoutDuration);
              break;
          }

          return inResponse;
        },
        // Retry on SocketException or TimeoutException
        retryIf: (e) => e is SocketException || e is TimeoutException,
      );
      return response;
    } finally {
      // dio.close();
    }
  }
}
