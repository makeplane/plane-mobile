import 'package:plane/config/apis.dart';
import 'package:plane/services/dio_service.dart';
import 'package:plane/utils/enums.dart';

class CycleRepository {
  final _dio = DioConfig();
  final baseApi = APIs.baseApi;

  Future<void> createCycle(String workspaceSlug, String projectId,
      Map<String, dynamic> payload) async {
    try {
      await _dio.dioServe(
          url:
              '$baseApi/api/workspaces/$workspaceSlug/projects/$projectId/cycles/',
          hasAuth: true,
          hasBody: true,
          data: payload,
          httpMethod: HttpMethod.post);
    } catch (err) {
      rethrow;
    }
  }

  Future<void> deleteCycle(
      String workspaceSlug, String projectId, String cycleId) async {
    try {
      await _dio.dioServe(
          url:
              '$baseApi/api/workspaces/$workspaceSlug/projects/$projectId/cycles/$cycleId/',
          hasAuth: true,
          hasBody: false,
          httpMethod: HttpMethod.delete);
    } catch (err) {
      rethrow;
    }
  }

  Future<void> updateCycle(String workspaceSlug, String projectId,
      String cycleId, Map<String, dynamic> payload) async {
    try {
      await _dio.dioServe(
          url:
              '$baseApi/api/workspaces/$workspaceSlug/projects/$projectId/cycles/$cycleId/',
          hasAuth: true,
          hasBody: true,
          data: payload,
          httpMethod: HttpMethod.put);
    } catch (err) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchCycle(
      String workspaceSlug, String projectId, String cycleId) async {
    try {
      final response = await _dio.dioServe(
          url:
              '$baseApi/api/workspaces/$workspaceSlug/projects/$projectId/cycles/$cycleId/',
          hasBody: false,
          hasAuth: true,
          httpMethod: HttpMethod.get);

      return response.data;
    } catch (err) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchCycles(
      String workspaceSlug, String projectId, String query) async {
    try {
      final response = await _dio.dioServe(
          url:
              '$baseApi/api/workspaces/$workspaceSlug/projects/$projectId/cycles/?$query',
          hasBody: false,
          hasAuth: true,
          httpMethod: HttpMethod.get);

      return response.data;
    } catch (err) {
      rethrow;
    }
  }
}
