import 'package:dio/dio.dart';
import 'package:plane/core/logger/logger.dart';

class NetworkLogger extends Interceptor {
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
}
