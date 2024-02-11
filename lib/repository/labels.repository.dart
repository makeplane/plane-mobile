import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:plane/config/apis.dart';
import 'package:plane/core/exception/plane_exception.dart';
import 'package:plane/models/project/label/label.model.dart';
import 'package:plane/core/dio/dio_service.dart';
import 'package:plane/utils/enums.dart';

class LabelRepository {
  final DioClient dio = DioClient();

  // Fetch project labels
  Future<Either<PlaneException, Map<String, LabelModel>>> getProjectLabels(
      String slug, String projectID) async {
    try {
      final response = await dio.request(
        hasAuth: true,
        url:
            '${APIs.baseApi}/api/workspaces/$slug/projects/$projectID/issue-labels/',
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      return Right({
        for (final label in response.data!)
          label['id']: LabelModel.fromJson(label)
      });
    } on DioException catch (err) {
      return Left(throw PlaneException(
          err.message ?? 'Failed to fetch project-labels.'));
    }
  }

  // Fetch workspace labels
  Future<Either<PlaneException, Map<String, LabelModel>>> getWorkspaceLabels(
      String slug, String projectID) async {
    try {
      final response = await dio.request(
        hasAuth: true,
        url: '${APIs.baseApi}/api/workspaces/labels/',
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      return Right({
        for (final label in response.data!)
          label['id']: LabelModel.fromJson(label)
      });
    } on DioException catch (err) {
      return Left(throw PlaneException(
          err.message ?? 'Failed to fetch workspace-labels.'));
    }
  }

  // Create new label
  Future<Either<PlaneException, LabelModel>> createLabel(
      String slug, String projectID, Map<String, dynamic> payload) async {
    try {
      final response = await dio.request(
        hasAuth: true,
        url:
            '${APIs.baseApi}/api/workspaces/$slug/projects/$projectID/issue-labels/',
        hasBody: true,
        data: payload,
        httpMethod: HttpMethod.post,
      );
      return Right(LabelModel.fromJson(response.data));
    } on DioException catch (err) {
      log(err.response.toString());
      return Left(
          throw PlaneException(err.message ?? 'Failed to create label.'));
    }
  }

  // Update label
  Future<Either<PlaneException, LabelModel>> updateLabel(
      String slug, String projectID, Map<String, dynamic> payload) async {
    try {
      final response = await dio.request(
        hasAuth: true,
        url:
            '${APIs.baseApi}/api/workspaces/$slug/projects/$projectID/issue-labels/${payload['id']}/',
        hasBody: true,
        data: payload,
        httpMethod: HttpMethod.patch,
      );
      return Right(LabelModel.fromJson(response.data));
    } on DioException catch (err) {
      log(err.response.toString());
      return Left(
          throw PlaneException(err.message ?? 'Failed to update label.'));
    }
  }

  // Delete label
  Future<Either<PlaneException, void>> deleteLabel(
      String slug, String projectID, String labelID) async {
    try {
      await dio.request(
        hasAuth: true,
        url:
            '${APIs.baseApi}/api/workspaces/$slug/projects/$projectID/issue-labels/$labelID/',
        hasBody: false,
        httpMethod: HttpMethod.delete,
      );
      return const Right(null);
    } on DioException catch (err) {
      log(err.response.toString());
      return Left(
          throw PlaneException(err.message ?? 'Failed to delete label.'));
    }
  }
}
