import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:plane/config/apis.dart';
import 'package:plane/core/exception/plane_exception.dart';
import 'package:plane/models/cycle/cycle_detail.model.dart';
import 'package:plane/core/dio/dio_service.dart';
import 'package:plane/utils/enums.dart';

class CycleRepository {
  final _dio = DioClient();
  final baseApi = APIs.baseApi;

  Future<Either<PlaneException, bool>> checkCycleDate(
    String workspaceSlug,
    String projectId,
    String? startDate,
    String? endDate,
  ) async {
    if (startDate == null || endDate == null) return const Right(true);
    try {
      final response = await _dio.request(
          url:
              '$baseApi/api/workspaces/$workspaceSlug/projects/$projectId/cycles/date-check',
          hasAuth: true,
          hasBody: true,
          data: {'start_date': startDate, 'end_date': endDate},
          httpMethod: HttpMethod.post);

      return Right(response.data['status']);
    } on DioException catch (err) {
      return Left(PlaneException(err.message ?? 'Failed to check cycle date'));
    }
  }

  Future<Either<PlaneException, CycleDetailModel>> createCycle(
      String workspaceSlug, String projectId, CycleDetailModel payload) async {
    try {
      final response = await _dio.request(
          url:
              '$baseApi/api/workspaces/$workspaceSlug/projects/$projectId/cycles/',
          hasAuth: true,
          hasBody: true,
          data: payload.toJson(),
          httpMethod: HttpMethod.post);
      return Right(CycleDetailModel.fromJson(response.data));
    } on DioException catch (err) {
      return Left(PlaneException(err.message ?? 'Failed to create cycle.'));
    }
  }

  Future<Either<PlaneException, void>> deleteCycle(
      String workspaceSlug, String projectId, String cycleId) async {
    try {
      await _dio.request(
          url:
              '$baseApi/api/workspaces/$workspaceSlug/projects/$projectId/cycles/$cycleId/',
          hasAuth: true,
          hasBody: false,
          httpMethod: HttpMethod.delete);
      return const Right(null);
    } on DioException catch (err) {
      return Left(
          throw PlaneException(err.message ?? 'Failed to delete cycle.'));
    }
  }

  Future<Either<PlaneException, CycleDetailModel>> updateCycle(
      String workspaceSlug, String projectId, CycleDetailModel payload) async {
    try {
      final response = await _dio.request(
          url:
              '$baseApi/api/workspaces/$workspaceSlug/projects/$projectId/cycles/${payload.id}/',
          hasAuth: true,
          hasBody: true,
          data: payload.toJson(),
          httpMethod: HttpMethod.patch);
      return Right(CycleDetailModel.fromJson(response.data));
    } on DioException catch (err) {
      return Left(PlaneException(err.message ?? 'Failed to update cycle.'));
    }
  }

  Future<Either<PlaneException, CycleDetailModel>> fetchCycleDetails(
      String workspaceSlug, String projectId, String cycleId) async {
    try {
      final response = await _dio.request(
          url:
              '$baseApi/api/workspaces/$workspaceSlug/projects/$projectId/cycles/$cycleId/',
          hasBody: false,
          hasAuth: true,
          httpMethod: HttpMethod.get);
      return Right(CycleDetailModel.fromJson(response.data));
    } on DioException catch (err) {
      return Left(
          PlaneException(err.message ?? 'Failed to fetch cycle detail.'));
    }
  }

  Future<Either<PlaneException, Map<String, CycleDetailModel>>> fetchCycles(
      String workspaceSlug, String projectId) async {
    try {
      String api =
          '$baseApi/api/workspaces/$workspaceSlug/projects/$projectId/cycles/';
      final response = await _dio.request(
          url: api, hasBody: false, hasAuth: true, httpMethod: HttpMethod.get);
      final cycles = {
        for (final CycleDetailModel cycle in response.data
            .map<CycleDetailModel>((cycle) => CycleDetailModel.fromJson(cycle)))
          cycle.id: cycle
      };
      return Right(cycles);
    } on DioException catch (err) {
      return Left(PlaneException(err.message ?? 'Failed to fetch cycles'));
    }
  }

  Future<Either<PlaneException, CycleDetailModel>> fetchActiveCycle(
    String workspaceSlug,
    String projectId,
  ) async {
    try {
      String api =
          '$baseApi/api/workspaces/$workspaceSlug/projects/$projectId/cycles/?current_view=current';
      final response = await _dio.request(
          url: api, hasBody: false, hasAuth: true, httpMethod: HttpMethod.get);
      return Right(CycleDetailModel.fromJson(response.data[0]));
    } on DioException catch (err) {
      return Left(PlaneException(err.message ?? 'Failed to fetch cycles'));
    }
  }

  Future<Either<PlaneException, void>> transferIssues(String workspaceSlug,
      String projectId, String currentCycleId, String newCycleId) async {
    try {
      await _dio.request(
          url:
              '$baseApi/api/workspaces/$workspaceSlug/projects/$projectId/cycles/$currentCycleId/transfer-issues/',
          hasBody: false,
          hasAuth: true,
          data: {"new_cycle_id": newCycleId},
          httpMethod: HttpMethod.post);

      return const Right(null);
    } on DioException catch (err) {
      return Left(PlaneException(err.message ?? 'Failed to transfer issues'));
    }
  }
}
