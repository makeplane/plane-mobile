// Dart imports:
import 'dart:async';
import 'dart:io';

// Package imports:
import 'package:dio/dio.dart';
import 'package:dio_http2_adapter/dio_http2_adapter.dart';
import 'package:plane/config/const.dart';
import 'package:plane/core/dio/interceptors/network_logger.dart';
import 'package:plane/utils/enums.dart';
import 'package:retry/retry.dart';
import 'interceptors/token_refresh_interceptor.dart';

class DioClient {
  DioClient() {
    dio.interceptors.addAll([NetworkLogger(), ReGenerateToken(dio)]);
  }

  final dio = Dio(BaseOptions(
    receiveTimeout: const Duration(seconds: 10),
    connectTimeout: const Duration(seconds: 10),
  ))
    ..httpClientAdapter = Http2Adapter(
        ConnectionManager(idleTimeout: const Duration(seconds: 50)));

  Future<Response> request({
    dynamic data,
    bool hasAuth = true,
    bool hasBody = true,
    required String url,
    HttpMethod httpMethod = HttpMethod.get,
  }) async {
    // Passing Headers
    final requestHeaders = {
      if (hasAuth) 'Authorization': 'Bearer ${Const.accessToken}',
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Credentials': 'true',
      'Access-Control-Allow-Headers': 'Content-Type',
    };
    const timeoutDuration = Duration(seconds: 5);

    switch (httpMethod) {
      case HttpMethod.get:
        return await dio
            .get(url, options: Options(headers: requestHeaders))
            .timeout(timeoutDuration);
      case HttpMethod.post:
        return await dio
            .post(url, options: Options(headers: requestHeaders), data: data)
            .timeout(timeoutDuration);
      case HttpMethod.put:
        return await dio
            .put(url, options: Options(headers: requestHeaders), data: data)
            .timeout(timeoutDuration);
      case HttpMethod.delete:
        return await dio
            .delete(url, options: Options(headers: requestHeaders), data: data)
            .timeout(timeoutDuration);
      case HttpMethod.patch:
        return await dio
            .patch(url, options: Options(headers: requestHeaders), data: data)
            .timeout(timeoutDuration);
      default:
        return await dio
            .get(url, options: Options(headers: requestHeaders))
            .timeout(timeoutDuration);
    }
  }
}


// InterceptorsWrapper(
//       onError: (DioException error, ErrorInterceptorHandler handler) async {
//         if (error.response?.statusCode == 401) {
//           await SharedPrefrenceServices.instance.clear();
//           Const.accessToken = '';
//           Const.userId = null;
//           Navigator.push(Const.globalKey.currentContext!,
//               MaterialPageRoute(builder: (ctx) => const OnBoardingScreen()));
//         }
//         // Retrieve the error response data
//         final errorResponse = error.response?.data;

//         // Create a new DioError instance with the error response data
//         final DioException newError = DioException(
//           response: error.response,
//           requestOptions: error.requestOptions,
//           error: errorResponse,
//         );

//         // Return the new DioError instance
//         handler.reject(newError);
//       },
//     )
