import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:plane/services/dio_service.dart';
import '../utils/enums.dart';

class DashboardService {
  final DioConfig dio;
  DashboardService(this.dio);

  Future<Map<String, dynamic>> getDashboardData({required String url}) async {
    try {
      var res = await dio.dioServe(
        hasAuth: true,
        url: url,
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      return res.data;
    } on DioException catch (err) {
      log(err.response.toString());
      rethrow;
    }
  }
}
