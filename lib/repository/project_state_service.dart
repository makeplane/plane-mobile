import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:plane/config/apis.dart';
import 'package:plane/models/project/state/state_model.dart';
import 'package:plane/core/dio/dio_service.dart';
import 'package:plane/utils/enums.dart';

class StatesService {
  final dio = DioClient();

  Future<Either<Map<String, StateModel>, DioException>> getStates(
      {required String slug, required String projectId}) async {
    try {
      final response = await dio.request(
        hasAuth: true,
        url: APIs.states
            .replaceAll("\$SLUG", slug)
            .replaceAll('\$PROJECTID', projectId),
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      // for (final element in (response.data as List)) {
      //   final statesModel = StatesModel.fromJson(element);
      //   statesModel.stateIcon = SvgPicture.asset(
      //     element['id'] == 'backlog'
      //         ? 'assets/svg_images/circle.svg'
      //         : element['id'] == 'cancelled'
      //             ? 'assets/svg_images/cancelled.svg'
      //             : element['id'] == 'completed'
      //                 ? 'assets/svg_images/done.svg'
      //                 : element['id'] == 'started'
      //                     ? 'assets/svg_images/in_progress.svg'
      //                     : 'assets/svg_images/unstarted.svg',
      //     height: 22,
      //     width: 22,
      //     colorFilter: int.tryParse(
      //                 "FF${element['color'].toString().replaceAll('#', '')}",
      //                 radix: 16) !=
      //             null
      //         ? ColorFilter.mode(
      //             Color(
      //               int.parse(
      //                 "FF${element['color'].toString().replaceAll('#', '')}",
      //                 radix: 16,
      //               ),
      //             ),
      //             BlendMode.srcIn)
      //         : null,
      //   );
      // }
      final states = {
        for (final state in response.data)
          state['id'].toString(): StateModel.fromJson(state)
      };
      return Left(states);
    } on DioException catch (err) {
      log(err.response.toString());
      return Right(err);
    }
  }

  Future<Either<StateModel, DioException>> createState(
      {required Map data,
      required String slug,
      required String projectId}) async {
    try {
      final response = await dio.request(
          hasAuth: true,
          url: APIs.states
              .replaceFirst('\$SLUG', slug)
              .replaceFirst('\$PROJECTID', projectId),
          hasBody: true,
          httpMethod: HttpMethod.post,
          data: data);
      return Left(StateModel.fromJson(response.data));
    } on DioException catch (err) {
      log(err.response.toString());
      return Right(err);
    }
  }

  Future<Either<StateModel, DioException>> updateState(
      {required Map data,
      required String slug,
      required String projectId,
      required String stateId}) async {
    try {
      final response = await dio.request(
          hasAuth: true,
          url:
              '${APIs.states.replaceFirst('\$SLUG', slug).replaceFirst('\$PROJECTID', projectId)}$stateId/',
          hasBody: true,
          httpMethod: HttpMethod.patch,
          data: data);
      return Left(StateModel.fromJson(response.data));
    } on DioException catch (err) {
      log(err.response.toString());
      return Right(err);
    }
  }

  Future<Either<void, DioException>> deleteState(
      {required String slug,
      required String projectId,
      required String stateId}) async {
    try {
      await dio.request(
        hasAuth: true,
        url:
            '${APIs.states.replaceFirst('\$SLUG', slug).replaceFirst('\$PROJECTID', projectId)}$stateId/',
        hasBody: true,
        httpMethod: HttpMethod.delete,
      );
      return const Left(null);
    } on DioException catch (err) {
      log(err.response.toString());
      return Right(err);
    }
  }
}