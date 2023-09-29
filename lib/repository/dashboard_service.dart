import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:plane/services/dio_service.dart';
import '../utils/enums.dart';

class DashboardService {
  DashboardService(this.dio);
  final DioConfig dio;

  Future<Map<String, dynamic>> getDashboardData({required String url}) async {
    try {
      final res = await dio.dioServe(
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
