import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:plane/config/apis.dart';
import 'package:plane/models/project/layout-properties/layout_properties.model.dart';
import 'package:plane/models/project/issue/issue_model.dart';
import 'package:plane/services/dio_service.dart';
import 'package:plane/utils/enums.dart';

class ProjectIssuesRepository {
  final _dio = DioConfig();
  final baseApi = APIs.baseApi;

  Future<Either<DioException, IssueModel>> createIssue(
      String workspaceSlug, String projectId, IssueModel payload) async {
    try {
      final response = await _dio.dioServe(
          url:
              '$baseApi/api/workspaces/$workspaceSlug/projects/$projectId/issues/',
          hasAuth: true,
          hasBody: true,
          data: payload.toJson(),
          httpMethod: HttpMethod.post);

      return Right(IssueModel.fromJson(response.data));
    } on DioException catch (err) {
      return Left(err);
    }
  }

  Future<Either<DioException, void>> deleteIssue(
      String workspaceSlug, String projectId, String issueId) async {
    try {
      await _dio.dioServe(
          url:
              '$baseApi/api/workspaces/$workspaceSlug/projects/$projectId/issues/$issueId/',
          hasAuth: true,
          hasBody: false,
          httpMethod: HttpMethod.delete);

      return const Right(null);
    } on DioException catch (err) {
      return Left(err);
    }
  }

  Future<Either<DioException, Map<String, IssueModel>>> fetchIssues(
      String workspaceSlug, String projectId, String query) async {
    try {
      final response = await _dio.dioServe(
          url:
              '$baseApi/api/workspaces/$workspaceSlug/projects/$projectId/issues/?$query',
          hasBody: false,
          hasAuth: true,
          httpMethod: HttpMethod.get);

      Map<String, IssueModel> issues = Map.fromEntries((response.data as List)
          .map((issue) =>
              MapEntry(issue['id'].toString(), IssueModel.fromJson(issue))));

      return Right(issues);
    } on DioException catch (err) {
      log('Failed to fetch project-issues ${err.toString()}');
      return Left(err);
    }
  }

  Future<Either<DioException, IssueModel>> updateIssue(
      String workspaceSlug, String projectId, IssueModel payload) async {
    try {
      final response = await _dio.dioServe(
          url:
              '$baseApi/api/workspaces/$workspaceSlug/projects/$projectId/issues/${payload.id}/',
          hasAuth: true,
          hasBody: true,
          data: payload.toJson(),
          httpMethod: HttpMethod.patch);

      return Right(IssueModel.fromJson(response.data));
    } on DioException catch (err) {
      return Left(err);
    }
  }

  Future<Either<DioException, LayoutPropertiesModel>> fetchLayoutProperties(
      String workspaceSlug, String projectId) async {
    try {
      final response = await _dio.dioServe(
          url:
              '$baseApi/api/workspaces/$workspaceSlug/projects/$projectId/user-properties/',
          hasAuth: true,
          hasBody: false,
          httpMethod: HttpMethod.get);

      return Right(LayoutPropertiesModel.fromJson(response.data));
    } on DioException catch (err) {
      return Left(err);
    }
  }

  Future<Either<DioException, LayoutPropertiesModel>> updateLayoutProperties(
      String workspaceSlug,
      String projectId,
      LayoutPropertiesModel payload) async {
    try {
      final response = await _dio.dioServe(
          url:
              '$baseApi/api/workspaces/$workspaceSlug/projects/$projectId/user-properties/',
          hasAuth: true,
          hasBody: true,
          data: payload.toJson(),
          httpMethod: HttpMethod.patch);

      return Right(LayoutPropertiesModel.fromJson(response.data));
    } on DioException catch (err) {
      log('Failed to update layout-view ${err.toString()}');
      return Left(err);
    }
  }
}
