// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/config/apis.dart';
import 'package:plane/models/issues.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/services/dio_service.dart';
import 'package:plane/utils/custom_toast.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/utils/global_functions.dart';

class CyclesProvider with ChangeNotifier {
  CyclesProvider(ChangeNotifierProviderRef<CyclesProvider> this.ref);
  Ref? ref;
  StateEnum cyclesState = StateEnum.empty;
  StateEnum cyclesDetailState = StateEnum.empty;
  StateEnum cyclesIssueState = StateEnum.loading;
  StateEnum allCyclesState = StateEnum.loading;
  StateEnum activeCyclesState = StateEnum.loading;
  StateEnum upcomingCyclesState = StateEnum.loading;
  StateEnum completedCyclesState = StateEnum.loading;
  StateEnum draftCyclesState = StateEnum.loading;
  StateEnum transferIssuesState = StateEnum.empty;
  StateEnum cycleViewState = StateEnum.empty;
  List<dynamic> cyclesAllData = [];
  List<dynamic> cycleFavoriteData = [];
  List<dynamic> cycleUpcomingFavoriteData = [];
  List<dynamic> cycleCompletedFavoriteData = [];
  List<dynamic> cycleDraftFavoriteData = [];
  List<dynamic> cyclesActiveData = [];
  List<dynamic> cyclesUpcomingData = [];
  List<dynamic> cyclesCompletedData = [];
  List<dynamic> cyclesiCompleteData = [];
  List<dynamic> cyclesDraftData = [];
  Map<String, dynamic> cyclesDetailsData = {};
  Map currentCycle = {};
  int cyclesTabIndex = 0;
  int cycleDetailSelectedIndex = 0;
  List queries = ['all', 'current', 'upcoming', 'completed', 'draft'];
  List<String> loadingCycleId = [];
  Enum issueCategory = IssueCategory.cycleIssues;

  void setState() {
    notifyListeners();
  }

  void changeTabIndex(int index) {
    cycleDetailSelectedIndex = index;
    notifyListeners();
  }

  void clearData() {
    cyclesAllData = [];
    cycleFavoriteData = [];
    cycleUpcomingFavoriteData = [];
    cycleCompletedFavoriteData = [];
    cycleDraftFavoriteData = [];
    cyclesActiveData = [];
    cyclesUpcomingData = [];
    cyclesCompletedData = [];
    cyclesiCompleteData = [];
    cyclesDraftData = [];
    cyclesDetailsData = {};
    currentCycle = {};
  }

  Future<bool> dateCheck({
    required String slug,
    required String projectId,
    required Map<String, dynamic> data,
  }) async {
    final url = APIs.dateCheck
        .replaceFirst('\$SLUG', slug)
        .replaceFirst('\$PROJECTID', projectId);

    try {
      cyclesState = StateEnum.loading;
      notifyListeners();
      final response = await DioConfig().dioServe(
        hasAuth: true,
        url: url,
        hasBody: true,
        data: data,
        httpMethod: HttpMethod.post,
      );
      log(response.data.toString());
      cyclesState = StateEnum.success;

      notifyListeners();
      return response.data['status'];
    } on DioException catch (e) {
      log(e.message.toString());
      cyclesState = StateEnum.error;
      notifyListeners();
      return false;
    }
  }

  Future cyclesCrud(
      {bool disableLoading = false,
      required String slug,
      required String projectId,
      required CRUD method,
      required String query,
      Map<String, dynamic>? data,
      required String cycleId,
      required WidgetRef ref}) async {
    final workspaceProvider = ref.watch(ProviderList.workspaceProvider);
    final projectProvider = ref.watch(ProviderList.projectProvider);
    final profileProvider = ref.watch(ProviderList.profileProvider);
    if (query == 'all') {
      allCyclesState = StateEnum.loading;
    } else if (query == 'current') {
      activeCyclesState = StateEnum.loading;
    } else if (query == 'upcoming') {
      upcomingCyclesState = StateEnum.loading;
    } else if (query == 'completed') {
      completedCyclesState = StateEnum.loading;
    } else if (query == 'draft') {
      draftCyclesState = StateEnum.loading;
    }
    final url = query == ''
        ? APIs.cycles
            .replaceFirst('\$SLUG', slug)
            .replaceFirst('\$PROJECTID', projectId)
        : '${APIs.cycles.replaceFirst('\$SLUG', slug).replaceFirst('\$PROJECTID', projectId)}?cycle_view=$query';

    try {
      // if (!disableLoading) {
      cyclesState = StateEnum.loading;
      //   notifyListeners();
      // }
      final response = await DioConfig().dioServe(
        hasAuth: true,
        url: url,
        hasBody: data != null ? true : false,
        httpMethod: method == CRUD.read
            ? HttpMethod.get
            : method == CRUD.create
                ? HttpMethod.post
                : HttpMethod.patch,
        data: data,
      );

      if (query == 'all') {
        cyclesAllData = [];
        cycleFavoriteData = [];
        response.data.forEach((element) {
          if (element['is_favorite'] == true) {
            cycleFavoriteData.add(element);
          } else {
            cyclesAllData.add(element);
          }
        });
        allCyclesState = StateEnum.success;
      }
      if (query == 'current') {
        cyclesActiveData = response.data;
        activeCyclesState = StateEnum.success;
      }
      if (query == 'upcoming') {
        cyclesUpcomingData = response.data;
        cyclesUpcomingData = [];
        cycleUpcomingFavoriteData = [];
        response.data.forEach((element) {
          if (element['is_favorite'] == true) {
            cycleUpcomingFavoriteData.add(element);
          } else {
            cyclesUpcomingData.add(element);
          }
        });
        upcomingCyclesState = StateEnum.success;
      }
      if (query == 'completed') {
        cyclesCompletedData = response.data;
        cyclesCompletedData = [];
        cycleCompletedFavoriteData = [];
        response.data.forEach((element) {
          if (element['is_favorite'] == true) {
            cycleCompletedFavoriteData.add(element);
          } else {
            cyclesCompletedData.add(element);
          }
        });
        completedCyclesState = StateEnum.success;
      }
      if (query == 'draft') {
        cyclesDraftData = response.data;
        cyclesDraftData = [];
        cycleDraftFavoriteData = [];
        response.data.forEach((element) {
          if (element['is_favorite'] == true) {
            cycleDraftFavoriteData.add(element);
          } else {
            cyclesDraftData.add(element);
          }
        });
        draftCyclesState = StateEnum.success;
      }
      cyclesState = StateEnum.success;
      method == CRUD.read
          ? null
          : postHogService(
              eventName: method == CRUD.create
                  ? 'CYCLE_CREATE'
                  : method == CRUD.update
                      ? 'CYCLE_UPDATE'
                      : method == CRUD.delete
                          ? 'CYCLE_DELETE'
                          : '',
              properties: method == CRUD.delete
                  ? {}
                  : {
                      'WORKSPACE_ID':
                          workspaceProvider.selectedWorkspace.workspaceId,
                      'WORKSPACE_SLUG':
                          workspaceProvider.selectedWorkspace.workspaceSlug,
                      'WORKSPACE_NAME':
                          workspaceProvider.selectedWorkspace.workspaceName,
                      'PROJECT_ID': projectProvider.projectDetailModel!.id,
                      'PROJECT_NAME': projectProvider.projectDetailModel!.name,
                      'CYCLE_ID': response.data['id']
                    },
              userEmail: profileProvider.userProfile.email!,
              userID: profileProvider.userProfile.id!);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    } on DioException catch (e) {
      log(e.message.toString());
      cyclesState = StateEnum.error;
      notifyListeners();
    }
  }

  void changeState(StateEnum state) {
    state = StateEnum.loading;
    notifyListeners();
  }

  Future cycleDetailsCrud({
    bool disableLoading = false,
    required String slug,
    required String projectId,
    required CRUD method,
    required String cycleId,
    Map<String, dynamic>? data,
  }) async {
    try {
      // if (!disableLoading) {
      cyclesDetailState = StateEnum.loading;
      notifyListeners();
      // }
      final url =
          '${APIs.cycles.replaceFirst('\$SLUG', slug).replaceFirst('\$PROJECTID', projectId)}$cycleId/';
      final response = await DioConfig().dioServe(
        hasAuth: true,
        url: url,
        hasBody: data != null ? true : false,
        data: data,
        httpMethod: method == CRUD.read
            ? HttpMethod.get
            : method == CRUD.delete
                ? HttpMethod.delete
                : method == CRUD.create
                    ? HttpMethod.post
                    : HttpMethod.patch,
      );
      if (method == CRUD.read) {
        cyclesDetailsData = response.data;
      }
      if (method == CRUD.update) {
        cycleDetailsCrud(
            slug: slug,
            projectId: projectId,
            method: CRUD.read,
            cycleId: cycleId);
      }
      cyclesDetailState = StateEnum.success;
      notifyListeners();
    } catch (e) {
      log(e.toString());
      cyclesDetailState = StateEnum.error;
      notifyListeners();
    }
  }

  Future updateCycle(
      {required String slug,
      required String projectId,
      Map<String, dynamic>? data,
      required CRUD method,
      required String cycleId,
      required bool isFavorite,
      required String query,
      bool disableLoading = false,
      required WidgetRef ref}) async {
    final url = !isFavorite
        ? APIs.toggleFavoriteCycle
            .replaceFirst('\$SLUG', slug)
            .replaceFirst('\$PROJECTID', projectId)
        : '${APIs.toggleFavoriteCycle.replaceAll('\$SLUG', slug).replaceAll('\$PROJECTID', projectId)}$cycleId/';

    try {
      if (!disableLoading) {
        cyclesState = StateEnum.loading;
      }
      loadingCycleId.add(cycleId);
      notifyListeners();

      final response = await DioConfig().dioServe(
        hasAuth: true,
        url: url,
        hasBody: !isFavorite ? true : false,
        httpMethod: !isFavorite ? HttpMethod.post : HttpMethod.delete,
        data: data,
      );

      log('UPDATE CYCLES ======> ${response.data.toString()}');
      cycleFavoriteData = [];
      cyclesAllData = [];

      if (query == 'all') {
        for (int i = 0; i < queries.length; i++) {
          cyclesCrud(
              slug: slug,
              projectId: projectId,
              method: CRUD.read,
              query: queries[i],
              ref: ref,
              cycleId: cycleId);
        }
      }

      await cyclesCrud(
          slug: slug,
          projectId: projectId,
          method: CRUD.read,
          query: query,
          ref: ref,
          cycleId: cycleId);
      cyclesCrud(
          slug: slug,
          projectId: projectId,
          method: CRUD.read,
          query: 'all',
          ref: ref,
          cycleId: cycleId);
      cyclesState = StateEnum.success;
      loadingCycleId.remove(cycleId);
      notifyListeners();
    } on DioException catch (e) {
      log(e.message.toString());
      cyclesState = StateEnum.error;
      loadingCycleId.remove(cycleId);
      notifyListeners();
    }
  }


  Future createCycleIssues(
      {required String slug,
      required String projId,
      required List<String> issues,
      String? cycleId}) async {
    cyclesIssueState = StateEnum.loading;
    notifyListeners();
    final data = {
      'issues': issues,
    };

    log(APIs.cycleIssues
        .replaceAll(
          '\$SLUG',
          slug,
        )
        .replaceAll(
          '\$PROJECTID',
          projId,
        )
        .replaceAll(
          '\$CYCLEID',
          cycleId ?? currentCycle['id'].toString(),
        ));
    try {
      await DioConfig().dioServe(
        hasAuth: true,
        url: APIs.cycleIssues
            .replaceAll(
              '\$SLUG',
              slug,
            )
            .replaceAll(
              '\$PROJECTID',
              projId,
            )
            .replaceAll(
              '\$CYCLEID',
              cycleId ?? currentCycle['id'].toString(),
            ),
        hasBody: true,
        data: data,
        httpMethod: HttpMethod.post,
      );
      cyclesIssueState = StateEnum.success;
      notifyListeners();
      // log('Create Cycle Issues  ===> ${response.data.toString()}');
    } on DioException catch (e) {
      log('Create Cycle Issues Error  ===> ');
      log(e.error.toString());
      cyclesIssueState = StateEnum.error;
      notifyListeners();
    }
  }

  Future deleteCycleIssue(
      {required String slug,
      required String projId,
      required String issueId,
      String? cycleId}) async {
    cyclesIssueState = StateEnum.loading;
    notifyListeners();
    try {
      await DioConfig().dioServe(
        hasAuth: true,
        url: '${APIs.cycleIssues.replaceAll(
              '\$SLUG',
              slug,
            ).replaceAll(
              '\$PROJECTID',
              projId,
            ).replaceAll(
              '\$CYCLEID',
              cycleId ?? currentCycle['id'].toString(),
            )}$issueId/',
        hasBody: false,
        httpMethod: HttpMethod.delete,
      );
      cyclesIssueState = StateEnum.success;
      notifyListeners();
    } on DioException catch (e) {
      log('Delete Cycle Issues Error  ===> ');
      log(e.error.toString());
      cyclesIssueState = StateEnum.error;
      notifyListeners();
    }
  }

  bool showAddFloatingButton() {
    switch (cyclesTabIndex) {
      case 0:
        return (cyclesAllData.isNotEmpty || cycleFavoriteData.isNotEmpty) &&
            cyclesState != StateEnum.loading;
      case 1:
        return false;
      case 2:
        return (cyclesUpcomingData.isNotEmpty ||
                cycleUpcomingFavoriteData.isNotEmpty) &&
            cyclesState != StateEnum.loading;
      case 3:
        return false;
      case 4:
        return (cycleDraftFavoriteData.isNotEmpty &&
                cyclesDraftData.isNotEmpty) &&
            cyclesState != StateEnum.loading;
      default:
        return cyclesState != StateEnum.loading;
    }
  }

  Future transferIssues(
      {required String newCycleID, required BuildContext context}) async {
    try {
      transferIssuesState = StateEnum.loading;
      notifyListeners();
      final response = await DioConfig().dioServe(
        hasAuth: true,
        url: APIs.transferIssues
            .replaceAll(
              '\$SLUG',
              ref!
                  .read(ProviderList.workspaceProvider)
                  .selectedWorkspace
                  .workspaceSlug,
            )
            .replaceAll(
              '\$PROJECTID',
              ref!.read(ProviderList.projectProvider).currentProject['id'],
            )
            .replaceAll(
              '\$CYCLEID',
              currentCycle['id'].toString(),
            ),
        hasBody: true,
        data: {"new_cycle_id": newCycleID},
        httpMethod: HttpMethod.post,
      );
      log(response.data.toString());
      CustomToast.showToast(context,
          message: 'Successfully transfered', toastType: ToastType.success);
      Navigator.pop(context);
      transferIssuesState = StateEnum.success;
      notifyListeners();
    } on DioException catch (e) {
      log('cycle transfer Error  ===> ');
      log(e.error.toString());
      cyclesIssueState = StateEnum.error;
      CustomToast.showToast(context,
          message: 'Failed to transfer', toastType: ToastType.failure);
      transferIssuesState = StateEnum.failed;
      notifyListeners();
    }
  }
}
