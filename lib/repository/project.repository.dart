import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:plane/config/apis.dart';
import 'package:plane/core/exception/plane_exception.dart';
import 'package:plane/models/project/project.model.dart';
import 'package:plane/core/dio/dio_service.dart';
import 'package:plane/utils/enums.dart';

class ProjectRepository {
  final _dio = DioClient();
  final _baseApi = APIs.baseApi;

  Future<Either<PlaneException, void>> joinProject(
      String workspaceSlug, String projectId) async {
    try {
      final response = await _dio.request(
        hasAuth: true,
        url: '$_baseApi/api/workspaces/$workspaceSlug/projects/join/',
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      return const Right(null);
    } on DioException catch (err) {
      return Left(
          throw PlaneException(err.message ?? 'Failed to join project.'));
    }
  }

  Future<Either<PlaneException, Map<String, ProjectModel>>> fetchProjects(
      String workspaceSlug) async {
    try {
      final response = await _dio.request(
        hasAuth: true,
        url: '$_baseApi/api/workspaces/$workspaceSlug/projects/',
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      final projects = {
        for (final ProjectModel project
            in response.data.map((data) => ProjectModel.fromJson(data)))
          project.id: project
      };
      return Right(projects);
    } on DioException catch (err) {
      return Left(
          throw PlaneException(err.message ?? 'Failed to fetch projects.'));
    }
  }

  Future<Either<PlaneException, ProjectModel>> fetchProjectDetails(
      String workspaceSlug, String projectId) async {
    try {
      final response = await _dio.request(
        hasAuth: true,
        url: '$_baseApi/api/workspaces/$workspaceSlug/projects/$projectId',
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      return Right(ProjectModel.fromJson(response.data));
    } on DioException catch (err) {
      return Left(throw PlaneException(
          err.message ?? 'Failed to fetch project details.'));
    }
  }

  Future<Either<PlaneException, ProjectModel>> createProject(
      String workspaceSlug, ProjectModel payload) async {
    try {
      final response = await _dio.request(
        hasAuth: true,
        url: '$_baseApi/api/workspaces/$workspaceSlug/projects/',
        hasBody: true,
        data: payload.toJson(),
        httpMethod: HttpMethod.post,
      );
      return Right(ProjectModel.fromJson(response.data));
    } on DioException catch (err) {
      return Left(
          throw PlaneException(err.message ?? 'Failed to create project.'));
    }
  }

  Future<Either<PlaneException, ProjectModel>> updateProject(
      String workspaceSlug, ProjectModel payload) async {
    try {
      final response = await _dio.request(
        hasAuth: true,
        url: '$_baseApi/api/workspaces/$workspaceSlug/projects/${payload.id}',
        hasBody: true,
        data: payload.toJson(),
        httpMethod: HttpMethod.patch,
      );
      return Right(ProjectModel.fromJson(response.data));
    } on DioException catch (err) {
      return Left(
          throw PlaneException(err.message ?? 'Failed to update project.'));
    }
  }

  Future<Either<PlaneException, void>> deleteProject(
      String workspaceSlug, String projectId) async {
    try {
      await _dio.request(
        hasAuth: true,
        url: '$_baseApi/api/workspaces/$workspaceSlug/projects/$projectId',
        hasBody: false,
        httpMethod: HttpMethod.delete,
      );
      return const Right(null);
    } on DioException catch (err) {
      return Left(
          throw PlaneException(err.message ?? 'Failed to delete project.'));
    }
  }

  Future<Either<PlaneException, void>> leaveProject(
      String workspaceSlug, String projectId) async {
    try {
      await _dio.request(
        hasAuth: true,
        url:
            '$_baseApi/api/workspaces/$workspaceSlug/projects/$projectId/members/leave/',
        hasBody: false,
        httpMethod: HttpMethod.post,
      );
      return const Right(null);
    } on DioException catch (err) {
      return Left(
          throw PlaneException(err.message ?? 'Failed to leave project.'));
    }
  }
}
