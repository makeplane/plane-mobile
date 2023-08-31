import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane_startup/config/apis.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/services/dio_service.dart';
import 'package:plane_startup/utils/custom_toast.dart';
import 'package:plane_startup/utils/enums.dart';
import 'package:plane_startup/utils/global_functions.dart';

class PageProvider with ChangeNotifier {
  StateEnum pagesListState = StateEnum.empty;
  StateEnum blockState = StateEnum.empty;
  StateEnum pageFavoriteState = StateEnum.empty;
  StateEnum blockSheetState = StateEnum.empty;

  PageFilters selectedFilter = PageFilters.all;
  Map<PageFilters, List<dynamic>> pages = {
    PageFilters.all: [],
    PageFilters.recent: [],
    PageFilters.favourites: [],
    PageFilters.createdByMe: [],
    PageFilters.createdByOthers: [],
  };
  List blocks = [];
  List selectedLabels = [];

  String getQuery(PageFilters filters) {
    switch (filters) {
      case PageFilters.all:
        return '?page_view=all';
      case PageFilters.recent:
        return '?page_view=recent';
      case PageFilters.favourites:
        return '?page_view=favorite';
      case PageFilters.createdByMe:
        return '?page_view=created_by_me';
      case PageFilters.createdByOthers:
        return '?page_view=created_by_other';
      default:
        return '?page_view=all';
    }
  }

  Future filterPageList(
      {required PageFilters pageFilter,
      required slug,
      required projectId,
      required userId}) async {
    selectedFilter = pageFilter;
    await updatepageList(
      slug: slug,
      projectId: projectId,
    );
  }

  Future handleBlocks(
      {required String pageID,
      required String slug,
      required HttpMethod httpMethod,
      required String blockID,
      String? name,
      String? description,
      required WidgetRef ref,
      BuildContext? context,
      required String projectId}) async {
    var workspaceProvider = ref.watch(ProviderList.workspaceProvider);
    var projectProvider = ref.watch(ProviderList.projectProvider);
    try {
      if (httpMethod != HttpMethod.get || httpMethod == HttpMethod.delete) {
        if (httpMethod == HttpMethod.delete) {
          blockState = StateEnum.loading;
        }
        blockSheetState = StateEnum.loading;
        notifyListeners();
      } else {
        blockState = StateEnum.loading;
      }
      var res = await DioConfig().dioServe(
          httpMethod: httpMethod,
          hasAuth: true,
          hasBody: httpMethod == HttpMethod.get ? false : true,
          url: APIs.pageBlock
                  .replaceAll("\$SLUG", slug)
                  .replaceAll("\$PAGEID", pageID)
                  .replaceAll("\$PROJECTID", projectId) +
              (httpMethod == HttpMethod.patch || httpMethod == HttpMethod.delete
                  ? "$blockID/"
                  : ""),
          data: httpMethod == HttpMethod.get || httpMethod == HttpMethod.delete
              ? null
              : {
                  'name': name,
                  "description": {
                    "type": "doc",
                    "content": [
                      {
                        "type": "paragraph",
                        "content": [
                          {"text": description, "type": "text"}
                        ]
                      }
                    ]
                  },
                });
      log(res.data.toString());
      httpMethod != HttpMethod.get
          ? postHogService(
              eventName: httpMethod == HttpMethod.post
                  ? 'BLOCK_CREATE'
                  : httpMethod == HttpMethod.patch
                      ? 'BLOCK_UPDATE'
                      : httpMethod == HttpMethod.delete
                          ? 'BLOCK_DELETE'
                          : '',
              properties: httpMethod == HttpMethod.delete
                  ? {}
                  : {
                      'WORKSPACE_ID':
                          workspaceProvider.selectedWorkspace!.workspaceId,
                      'WORKSPACE_NAME':
                          workspaceProvider.selectedWorkspace!.workspaceName,
                      'WORKSPACE_SLUG':
                          workspaceProvider.selectedWorkspace!.workspaceSlug,
                      'PROJECT_ID': projectProvider.projectDetailModel!.id,
                      'PROJECT_NAME': projectProvider.projectDetailModel!.name,
                      'PAGE_ID': pageID,
                      'BLOCK_ID': res.data['id']
                    },
              ref: ref)
          : null;
      if (httpMethod == HttpMethod.delete) {
        blocks.removeWhere((element) => element['id'] == blockID);
      } else if (httpMethod == HttpMethod.post) {
        blocks.add(res.data);
      } else if (httpMethod == HttpMethod.patch) {
        blocks[blocks.indexWhere((element) => element["id"] == blockID)] =
            res.data;
      } else {
        blocks = res.data;
      }
      blockSheetState = StateEnum.success;
      blockState = StateEnum.success;
      notifyListeners();
    } on DioException catch (e) {
      //log(e.response.toString());
      log(e.response!.data.toString());
      if (context != null) {
        CustomToast().showToastWithColors(
            context, e.response!.data['detail'] ?? e.response!.data,
            toastType: ToastType.failure);
      }
      blockSheetState = StateEnum.failed;
      blockState = StateEnum.error;
      notifyListeners();
    }
  }

  Future updatepageList({
    required String slug,
    required String projectId,
  }) async {
    pagesListState = StateEnum.loading;
    notifyListeners();
    try {
      log(APIs.getPages
              .replaceAll("\$SLUG", slug)
              .replaceAll("\$PROJECTID", projectId) +
          getQuery(selectedFilter));
      Response response = await DioConfig().dioServe(
          httpMethod: HttpMethod.get,
          url: APIs.getPages
                  .replaceAll("\$SLUG", slug)
                  .replaceAll("\$PROJECTID", projectId) +
              getQuery(selectedFilter));

      if (selectedFilter == PageFilters.recent) {
        pages[PageFilters.recent] = [];
        response.data.forEach((key, element) {
          pages[PageFilters.recent]!.addAll(element);
        });
      } else {
        pages[selectedFilter] = response.data;
      }

      pagesListState = StateEnum.success;
      setState();
    } on DioException catch (e) {
      log(e.response.toString());
      pagesListState = StateEnum.error;
      setState();
    }
  }

  Future makePageFavorite(
      {required String pageId,
      required String slug,
      required String projectId,
      required bool shouldItBeFavorite}) async {
    pageFavoriteState = StateEnum.loading;
    setState();
    try {
      if (shouldItBeFavorite) {
        await DioConfig().dioServe(
            httpMethod: HttpMethod.post,
            data: {"page": pageId},
            hasAuth: true,
            hasBody: true,
            url: APIs.favouritePage
                .replaceAll("\$SLUG", slug)
                .replaceAll("\$PROJECTID", projectId));
      } else {
        await DioConfig().dioServe(
            hasAuth: true,
            hasBody: false,
            httpMethod: HttpMethod.delete,
            url:
                '${APIs.favouritePage.replaceAll("\$SLUG", slug).replaceAll("\$PROJECTID", projectId)}$pageId/');
      }

      pageFavoriteState = StateEnum.success;
      setState();
    } on DioException catch (e) {
      pageFavoriteState = StateEnum.error;
      log(e.response.toString());

      setState();
    }
  }

  Future editPage(
      {required String slug,
      required String projectId,
      required String pageId,
      required dynamic data,
      required WidgetRef ref,
      BuildContext? context,
      bool? fromDispose = false}) async {
    blockSheetState = StateEnum.loading;
    notifyListeners();
    var workspaceProvider = ref.watch(ProviderList.workspaceProvider);
    var projectProvider = ref.watch(ProviderList.projectProvider);
    try {
      var res = await DioConfig().dioServe(
          httpMethod: HttpMethod.patch,
          hasAuth: true,
          hasBody: true,
          url:
              "${APIs.getPages.replaceAll("\$SLUG", slug).replaceAll("\$PROJECTID", projectId)}$pageId/",
          data: data);
      postHogService(
          eventName: 'PAGE_UPDATE',
          properties: {
            'WORKSPACE_ID': workspaceProvider.selectedWorkspace!.workspaceId,
            'WORKSPACE_NAME':
                workspaceProvider.selectedWorkspace!.workspaceName,
            'WORKSPACE_SLUG':
                workspaceProvider.selectedWorkspace!.workspaceSlug,
            'PROJECT_ID': projectProvider.projectDetailModel!.id,
            'PROJECT_NAME': projectProvider.projectDetailModel!.name,
            'PAGE_ID': res.data['id']
          },
          ref: ref);
      int index = pages[selectedFilter]!
          .indexWhere((element) => element["id"] == pageId);
      pagesListState = StateEnum.success;
      res.data["is_favorite"] = pages[selectedFilter]![index]["is_favorite"];
      pages[selectedFilter]![index] = res.data;

      blockSheetState = StateEnum.success;
      notifyListeners();
    } on DioException catch (e) {
      //log(e.response.toString());
      if (fromDispose == false) {
        if (context != null) {
          CustomToast().showToastWithColors(
              context,
              e.response!.data['detail'] != null
                  ? e.response!.data['detail'].toString()
                  : e.response!.data.toString(),
              toastType: ToastType.failure);
        }
      }
      log(e.response!.data.toString());
      blockSheetState = StateEnum.error;
      notifyListeners();
      setState();
    }
  }

  Future converToIssues(
      {required String slug,
      required String pageID,
      required String projectId,
      required String blockID,
      required WidgetRef ref,
      BuildContext? context}) async {
    try {
      blockState = StateEnum.loading;
      notifyListeners();
      var res = await DioConfig().dioServe(
          httpMethod: HttpMethod.post,
          hasAuth: true,
          hasBody: true,
          data: {},
          url:
              "${APIs.pageBlock.replaceAll("\$SLUG", slug).replaceAll("\$PAGEID", pageID).replaceAll("\$PROJECTID", projectId)}$blockID/issues/");

      await handleBlocks(
          pageID: pageID,
          slug: slug,
          httpMethod: HttpMethod.get,
          blockID: blockID,
          projectId: projectId,
          ref: ref);
      blockState = StateEnum.success;

      log(res.data.toString());
      notifyListeners();
    } on DioException catch (e) {
      log(e.response!.data.toString());
      if (context != null) {
        CustomToast().showToastWithColors(
            context, e.response!.data['detail'] ?? e.response!.data,
            toastType: ToastType.failure);
      }
      blockState = StateEnum.error;
      notifyListeners();
    }
  }

  Future addPage(
      {required String pageTitle,
      required String slug,
      required String projectId,
      required String userId,
      required WidgetRef ref}) async {
    pagesListState = StateEnum.loading;
    setState();
    var workspaceProvider = ref.watch(ProviderList.workspaceProvider);
    var projectProvider = ref.watch(ProviderList.projectProvider);
    try {
      var response = await DioConfig().dioServe(
          httpMethod: HttpMethod.post,
          url: APIs.createPage
              .replaceAll("\$SLUG", slug)
              .replaceAll("\$PROJECTID", projectId),
          data: {"name": pageTitle});
      pagesListState = StateEnum.success;
      postHogService(
          eventName: 'PAGE_CREATE',
          properties: {
            'WORKSPACE_ID': workspaceProvider.selectedWorkspace!.workspaceId,
            'WORKSPACE_NAME':
                workspaceProvider.selectedWorkspace!.workspaceName,
            'WORKSPACE_SLUG':
                workspaceProvider.selectedWorkspace!.workspaceSlug,
            'PROJECT_ID': projectProvider.projectDetailModel!.id,
            'PROJECT_NAME': projectProvider.projectDetailModel!.name,
            'PAGE_ID': response.data['id']
          },
          ref: ref);
      updatepageList(
        slug: slug,
        projectId: projectId,
      );
      setState();
    } on DioException catch (e) {
      log(e.response.toString());
      pagesListState = StateEnum.error;
      setState();
    }
  }

  Future deletePage({
    required String pageId,
    required String slug,
    required String projectId,
  }) async {
    pagesListState = StateEnum.loading;
    setState();
    try {
      await DioConfig().dioServe(
        httpMethod: HttpMethod.delete,
        url: APIs.deletePage
            .replaceAll("\$SLUG", slug)
            .replaceAll("\$PAGEID", pageId)
            .replaceAll("\$PROJECTID", projectId),
      );

      updatepageList(slug: slug, projectId: projectId);
      pagesListState = StateEnum.success;
      setState();
    } on DioException catch (e) {
      log(e.response.toString());
      pagesListState = StateEnum.error;
      setState();
    }
  }

  void clear() {}
  void setState() {
    notifyListeners();
  }
}
