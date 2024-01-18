import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:plane/config/apis.dart';
import 'package:plane/models/Project/Label/label.model.dart';
import 'package:plane/services/dio_service.dart';
import 'package:plane/utils/enums.dart';

class LabelsService {
  final DioConfig dio = DioConfig();

  // GET Project Labels
  Future<Either<Map<String, LabelModel>, DioException>> getProjectLabels(
      String slug, String projectID) async {
    try {
      final response = await dio.dioServe(
        hasAuth: true,
        url:
            '${APIs.baseApi}/api/workspaces/$slug/projects/$projectID/issue-labels/',
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      return Left({
        for (final label in response.data!)
          label['id']: LabelModel.fromJson(label)
      });
    } on DioException catch (err) {
      log(err.response.toString());
      return Right(err);
    }
  }

  // GET Workspace Labels
  Future<Either<Map<String, LabelModel>, DioException>> getWorkspaceLabels(
      String slug, String projectID) async {
    try {
      final response = await dio.dioServe(
        hasAuth: true,
        url: '${APIs.baseApi}/api/workspaces/labels/',
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      return Left({
        for (final label in response.data!)
          label['id']: LabelModel.fromJson(label)
      });
    } on DioException catch (err) {
      log(err.response.toString());
      return Right(err);
    }
  }

  // CREATE Label
  Future<Either<LabelModel, DioException>> createLabel(
      String slug, String projectID, Map<String,dynamic> payload) async {
    try {
      final response = await dio.dioServe(
        hasAuth: true,
        url:
            '${APIs.baseApi}/api/workspaces/$slug/projects/$projectID/issue-labels/',
        hasBody: true,
        data: payload,
        httpMethod: HttpMethod.post,
      );
      return Left(LabelModel.fromJson(response.data));
    } on DioException catch (err) {
      log(err.response.toString());
      return Right(err);
    }
  }

  // UPDATE Label
  Future<Either<LabelModel, DioException>> updateLabel(
      String slug, String projectID,  Map<String,dynamic> payload) async {
    try {
      final response = await dio.dioServe(
        hasAuth: true,
        url:
            '${APIs.baseApi}/api/workspaces/$slug/projects/$projectID/issue-labels/${payload['id']}/',
        hasBody: true,
        data: payload,
        httpMethod: HttpMethod.post,
      );
      return Left(LabelModel.fromJson(response.data));
    } on DioException catch (err) {
      log(err.response.toString());
      return Right(err);
    }
  }

  // DELETE Label
  Future<Either<void, DioException>> deleteLabel(
      String slug, String projectID, String labelID) async {
    try {
       await dio.dioServe(
        hasAuth: true,
        url:
            '${APIs.baseApi}/api/workspaces/$slug/projects/$projectID/issue-labels/$labelID/',
        hasBody: false,
        httpMethod: HttpMethod.delete,
      );
      return const Left(null);
    } on DioException catch (err) {
      log(err.response.toString());
      return Right(err);
    }
  }
}
