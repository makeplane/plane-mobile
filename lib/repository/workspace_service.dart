import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:plane/core/dio/dio_service.dart';

import '../config/apis.dart';
import '../utils/enums.dart';

class WorkspaceService {
  WorkspaceService(this.dio);
  DioClient dio;

  Future<Either<List<dynamic>, DioException>> getWorkspaces() async {
    try {
      final response = await dio.request(
        hasAuth: true,
        url: APIs.listWorkspaces,
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      return Left(response.data);
    } on DioException catch (err) {
      log(err.error.toString());
      return Right(DioException(requestOptions: RequestOptions()));
    }
  }

  Future<Either<List, DioException>> getWorkspaceMembers(
      {required String url}) async {
    try {
      final response = await dio.request(
        hasAuth: true,
        url: url,
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      return Left(response.data);
    } on DioException catch (err) {
      log(err.error.toString());
      return Right(DioException(requestOptions: RequestOptions()));
    }
  }

  Future<Either<List, DioException>> getWorkspaceMembersInvitations(
      {required String url}) async {
    try {
      final response = await dio.request(
        hasAuth: true,
        url: url,
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      return Left(response.data);
    } on DioException catch (err) {
      log(err.error.toString());
      return Right(err);
    }
  }

  Future<Either<bool, DioException>> removeWorkspaceMembersInvitations(
      {required String url}) async {
    try {
      await dio.request(
        hasAuth: true,
        url: url,
        hasBody: false,
        httpMethod: HttpMethod.delete,
      );
      return const Left(true);
    } on DioException catch (err) {
      log(err.error.toString());
      return Right(err);
    }
  }
}
