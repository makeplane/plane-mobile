import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/services/dio_service.dart';
import 'package:plane/utils/custom_toast.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/utils/global_functions.dart';
import '../config/apis.dart';

class ViewsModel {
  ViewsModel(
      {required this.views,
      required this.viewsState,
      required this.viewDetail});
  StateEnum viewsState = StateEnum.empty;
  List views = [];
  Map viewDetail = {};

  ViewsModel copyWith({StateEnum? viewsState, List? views, Map? viewDetail}) {
    return ViewsModel(
        views: views ?? this.views,
        viewsState: viewsState ?? this.viewsState,
        viewDetail: viewDetail ?? this.viewDetail);
  }
}

class ViewsNotifier extends StateNotifier<ViewsModel> {
  ViewsNotifier(StateNotifierProviderRef<ViewsNotifier, ViewsModel> this.ref)
      : super(
            ViewsModel(views: [], viewsState: StateEnum.empty, viewDetail: {}));
  Ref ref;

  Future getViews() async {
    state = state.copyWith(viewsState: StateEnum.loading);

    try {
      final response = await DioConfig().dioServe(
        hasAuth: true,
        url: APIs.views
            .replaceAll(
                '\$SLUG',
                ref
                    .read(ProviderList.workspaceProvider)
                    .selectedWorkspace
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

  Future createViews(
      {required dynamic data,
      required WidgetRef ref,
      required BuildContext context}) async {
    final workspaceProvider = ref.watch(ProviderList.workspaceProvider);
    final projectProvider = ref.watch(ProviderList.projectProvider);
    try {
      final response = await DioConfig().dioServe(
          hasAuth: true,
          url: APIs.views
              .replaceAll(
                  '\$SLUG',
                  ref
                      .read(ProviderList.workspaceProvider)
                      .selectedWorkspace
                      .workspaceSlug)
              .replaceAll('\$PROJECTID',
                  ref.read(ProviderList.projectProvider).currentProject["id"]),
          hasBody: true,
          httpMethod: HttpMethod.post,
          data: data);
      state = state.copyWith(
          views: [...state.views, response.data],
          viewsState: StateEnum.success);

      // ignore: use_build_context_synchronously
      CustomToast.showToast(context,
          message: 'View created successfully', toastType: ToastType.success);
      postHogService(
          eventName: 'VIEW_CREATE',
          properties: {
            'WORKSPACE_ID': workspaceProvider.selectedWorkspace.workspaceId,
            'WORKSPACE_NAME': workspaceProvider.selectedWorkspace.workspaceName,
            'WORKSPACE_SLUG': workspaceProvider.selectedWorkspace.workspaceSlug,
            'PROJECT_ID': projectProvider.projectDetailModel!.id,
            'PROJECT_NAME': projectProvider.projectDetailModel!.name,
            'VIEW_ID': response.data['id']
          },
          ref: ref);
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
                  .selectedWorkspace
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

  Future<Map> updateViews(
      {required int index,
      required String id,
      bool fromGlobalSearch = false,
      required Map<String, dynamic> data}) async {
    state = state.copyWith(viewsState: StateEnum.loading);

    log(data.toString());
    log("${APIs.views.replaceAll('\$SLUG', ref.read(ProviderList.workspaceProvider).selectedWorkspace.workspaceSlug).replaceAll('\$PROJECTID', ref.read(ProviderList.projectProvider).currentProject['id'])}$id/");
    try {
      final response = await DioConfig().dioServe(
        hasAuth: true,
        url:
            "${APIs.views.replaceAll('\$SLUG', ref.read(ProviderList.workspaceProvider).selectedWorkspace.workspaceSlug).replaceAll('\$PROJECTID', ref.read(ProviderList.projectProvider).currentProject['id'])}$id/",
        hasBody: true,
        httpMethod: HttpMethod.patch,
        data: data,
      );
      log('API success');

      if (!fromGlobalSearch) {
        state = state.copyWith(views: [
          ...state.views.sublist(0, index),
          response.data,
          ...state.views.sublist(index + 1)
        ]);
      }
      state = state.copyWith(viewsState: StateEnum.success);
      return response.data;
    } on DioException catch (e) {
      log('Update views error: ');
      log(e.error.toString());
      state = state.copyWith(viewsState: StateEnum.error);
      rethrow;
    }
  }

  Future deleteViews({required int index, required String id}) async {
    state = state.copyWith(viewsState: StateEnum.loading);

    try {
      await DioConfig().dioServe(
        hasAuth: true,
        url:
            "${APIs.views.replaceAll('\$SLUG', ref.read(ProviderList.workspaceProvider).selectedWorkspace.workspaceSlug).replaceAll('\$PROJECTID', ref.read(ProviderList.projectProvider).currentProject['id'])}$id/",
        hasBody: false,
        httpMethod: HttpMethod.delete,
      );
      state = state.copyWith(views: [
        ...state.views.sublist(0, index),
        ...state.views.sublist(index + 1)
      ], viewsState: StateEnum.success);
    } on DioException catch (e) {
      log(e.error.toString());
      state = state.copyWith(viewsState: StateEnum.error);
      rethrow;
    }
  }

  Future getViewDetail({required String id, required String projId}) async {
    state = state.copyWith(viewsState: StateEnum.loading);

    try {
      final response = await DioConfig().dioServe(
        hasAuth: true,
        url:
            "${APIs.views.replaceAll('\$SLUG', ref.read(ProviderList.workspaceProvider).selectedWorkspace.workspaceSlug).replaceAll('\$PROJECTID', projId)}$id/",
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      state = state.copyWith(
          viewsState: StateEnum.success, viewDetail: response.data);
    } on DioException catch (e) {
      log(e.error.toString());
      state = state.copyWith(viewsState: StateEnum.error);
      rethrow;
    }
  }
}
