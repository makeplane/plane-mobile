import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:plane/models/user_profile_model.dart';
import 'package:plane/services/dio_service.dart';

import '../config/apis.dart';
import '../utils/enums.dart';

class ProfileService {
  DioConfig dio;
  ProfileService(this.dio);

  Future<Either<UserProfile, DioException>> getProfile() async {
    try {
      var response = await dio.dioServe(
        hasAuth: true,
        url: '${APIs.baseApi}${APIs.profile}',
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      return Left(UserProfile.fromMap(response.data));
    } on DioException catch (err) {
      log(err.response.toString());
      return Right(DioException(requestOptions: RequestOptions()));
    }
  }

  Future<Either<UserProfile, DioException>> updateProfile(
      {required Map data}) async {
    try {
      var response = await dio.dioServe(
          hasAuth: true,
          url: APIs.baseApi + APIs.profile,
          hasBody: true,
          httpMethod: HttpMethod.patch,
          data: data);
      return Left(UserProfile.fromMap(response.data));
    } on DioException catch (err) {
      log(err.response.toString());
      return Right(DioException(requestOptions: RequestOptions()));
    }
  }
}
