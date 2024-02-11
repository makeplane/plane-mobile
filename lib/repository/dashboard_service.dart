import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:plane/core/dio/dio_service.dart';
import '../utils/enums.dart';

class DashboardService {
  DashboardService(this.dio);
  final DioClient dio;

  Future<Map<String, dynamic>> getDashboardData({required String url}) async {
    try {
      final res = await dio.request(
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
