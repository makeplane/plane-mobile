import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:plane/config/apis.dart';
import 'package:plane/services/dio_service.dart';
import 'package:plane/utils/enums.dart';

class ProjectsService {
  final dio = DioConfig();

  Future<Either<List, DioException>> getUnspalshImages() async {
    try {
      final response = await dio.dioServe(
        hasAuth: true,
        url: APIs.unsplashApi,
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      log('UNSPLASH IMAGES: ${response.data}');
      return Left(response.data);
    } on DioException catch (err) {
      log(err.response.toString());
      return Right(err);
    }
  }
}
