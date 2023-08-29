import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/services/dio_service.dart';
import 'package:plane_startup/utils/enums.dart';
import '../config/apis.dart';

class ViewsModel {
  StateEnum viewsState = StateEnum.empty;
  var views = [];

  ViewsModel({required this.views, required this.viewsState});

  ViewsModel copyWith({StateEnum? viewsState, List? views}) {
    return ViewsModel(
        views: views ?? this.views, viewsState: viewsState ?? this.viewsState);
  }
}

class ViewsNotifier extends StateNotifier<ViewsModel> {
  ViewsNotifier(StateNotifierProviderRef<ViewsNotifier, ViewsModel> this.ref)
      : super(ViewsModel(views: [], viewsState: StateEnum.empty));
  Ref ref;

  Future getViews() async {
    state = state.copyWith(viewsState: StateEnum.loading);

    try {
      var response = await DioConfig().dioServe(
        hasAuth: true,
        url: APIs.views
            .replaceAll(
                '\$SLUG',
                ref
                    .read(ProviderList.workspaceProvider)
                    .selectedWorkspace!
                    .workspaceSlug)
            .replaceAll('\$PROJECTID',
                ref.read(ProviderList.projectProvider).currentProject["id"]),
        hasBody: false,
        httpMethod: HttpMethod.get,
      );

      state =
          state.copyWith(views: response.data, viewsState: StateEnum.success);
    } on DioException catch (e) {
      log(e.error.toString());
      state = state.copyWith(viewsState: StateEnum.error);
    }
  }

  Future createViews({required dynamic data}) async {
    try {
      var response = await DioConfig().dioServe(
          hasAuth: true,
          url: APIs.views
              .replaceAll(
                  '\$SLUG',
                  ref
                      .read(ProviderList.workspaceProvider)
                      .selectedWorkspace!
                      .workspaceSlug)
              .replaceAll('\$PROJECTID',
                  ref.read(ProviderList.projectProvider).currentProject["id"]),
          hasBody: true,
          httpMethod: HttpMethod.post,
          data: data);
      state = state.copyWith(
          views: [...state.views, response.data],
          viewsState: StateEnum.success);
    } on DioException catch (e) {
      log(e.error.toString());
      state = state.copyWith(viewsState: StateEnum.error);
      rethrow;
    }
  }

  Future favouriteViews(
      {required int index, required HttpMethod method}) async {
    //  viewsState = StateEnum.loading;
    try {
      String url = APIs.viewsFavourite
          .replaceAll(
              '\$SLUG',
              ref
                  .read(ProviderList.workspaceProvider)
                  .selectedWorkspace!
                  .workspaceSlug)
          .replaceAll('\$PROJECTID',
              ref.read(ProviderList.projectProvider).currentProject["id"]);

      if (method == HttpMethod.delete) {
        url = "${url + state.views[index]["id"]}/";
      }
      await DioConfig().dioServe(
          hasAuth: true,
          url: url,
          hasBody: method == HttpMethod.post ? true : false,
          httpMethod: method,
          data: method == HttpMethod.post
              ? {"view": state.views[index]["id"]}
              : null);

      // log(views[index].toString());
      state = state.copyWith(viewsState: StateEnum.success);

      // log(response.data.toString());
    } on DioException catch (e) {
      log(e.error.toString());
      state = state.copyWith(viewsState: StateEnum.error);
    }
  }

  Future updateViews(
      {required int index,
      required String id,
      required Map<String, dynamic> data}) async {
    state = state.copyWith(viewsState: StateEnum.loading);

    log(data.toString());
    log("${APIs.views.replaceAll('\$SLUG', ref.read(ProviderList.workspaceProvider).selectedWorkspace!.workspaceSlug).replaceAll('\$PROJECTID', ref.read(ProviderList.projectProvider).currentProject['id'])}$id/");
    try {
      var response = await DioConfig().dioServe(
        hasAuth: true,
        url:
            "${APIs.views.replaceAll('\$SLUG', ref.read(ProviderList.workspaceProvider).selectedWorkspace!.workspaceSlug).replaceAll('\$PROJECTID', ref.read(ProviderList.projectProvider).currentProject['id'])}$id/",
        hasBody: true,
        httpMethod: HttpMethod.patch,
        data: data,
      );
      log('API success');
      state = state.copyWith(views: [
        ...state.views.sublist(0, index),
        response.data,
        ...state.views.sublist(index + 1)
      ], viewsState: StateEnum.success);
    } on DioException catch (e) {
      log('Update views error: ');
      log(e.error.toString());
      state = state.copyWith(viewsState: StateEnum.error);
      rethrow;
    }
  }
}
