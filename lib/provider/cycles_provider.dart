// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/config/apis.dart';
import 'package:plane/config/const.dart';
import 'package:plane/kanban/models/inputs.dart';
import 'package:plane/models/issues.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/screens/project/issues/create_issue.dart';
import 'package:plane/screens/project/issues/issue_detail.dart';
import 'package:plane/services/dio_service.dart';
import 'package:plane/utils/constants.dart';
import 'package:plane/utils/custom_toast.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/utils/global_functions.dart';
import 'package:plane/utils/issues_filter/issue_filter.helper.dart';
import 'package:plane/widgets/custom_text.dart';
import 'package:plane/widgets/issue_card_widget.dart';

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
  List<String> selectedIssues = [];
  List<dynamic> cyclesActiveData = [];
  List<dynamic> cyclesUpcomingData = [];
  List<dynamic> cyclesCompletedData = [];
  List<dynamic> cyclesiCompleteData = [];
  List<dynamic> cyclesDraftData = [];
  Map<String, dynamic> cyclesDetailsData = {};
  Map currentCycle = {};
  Map cycleView = {};
  int cyclesTabIndex = 0;
  Issues issues = Issues.initialize();
  List issuesResponse = [];
  List shrinkStates = [];
  Map filterIssues = {};
  List<dynamic> cycleIssuesList = [];
  Map issueProperty = {};
  bool showEmptyStates = true;
  bool isIssuesEmpty = false;
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

  List<BoardListsData> initializeBoard() {
    final themeProvider = ref!.read(ProviderList.themeProvider);
    final issuesProvider = ref!.read(ProviderList.issuesProvider);
    final labelNotifier = ref!.read(ProviderList.labelProvider.notifier);
    final statesProvider = ref!.read(ProviderList.statesProvider);
    int count = 0;
    // log(issues.groupBY.name);
    issues.issues = [];
    issuesResponse = [];
    final projectMembers =
        ref!.read(ProviderList.projectProvider).projectMembers;

    for (int j = 0; j < filterIssues.length; j++) {
      final List<Widget> items = [];
      final groupedIssues = filterIssues.values.toList()[j];
      final groupID = filterIssues.keys.elementAt(j);
      for (int i = 0; i < groupedIssues.length; i++) {
        issuesResponse.add(groupedIssues[i]);
        items.add(
          IssueCardWidget(
            from: PreviousScreen.cycles,
            cardIndex: count++,
            listIndex: j,
            issueCategory: IssueCategory.cycleIssues,
          ),
        );
      }
      String userName = '';
      bool userFound = false;
      final label = labelNotifier.getLabelById(groupID);

      for (int i = 0; i < projectMembers.length; i++) {
        if (groupID == projectMembers[i]['member']['id']) {
          userName = projectMembers[i]['member']['first_name'] +
              ' ' +
              projectMembers[i]['member']['last_name'];
          userName = userName.trim().isEmpty
              ? projectMembers[i]['member']['email']
              : userName;
          userFound = true;
          break;
        }
      }
      var title = issues.groupBY == GroupBY.priority
          ? groupID
          : issues.groupBY == GroupBY.state
              ? statesProvider.projectStates[groupID]!.name
              : groupID;
      issues.issues.add(BoardListsData(
        id: groupID,
        items: items,
        shrink: shrinkStates[j],
        index: j,
        width: issuesProvider.issues.projectView == IssueLayout.list
            ? MediaQuery.of(Const.globalKey.currentContext!).size.width
            : 300,
        // shrink: shrinkissuesProvider.states[count++],
        title: issues.groupBY == GroupBY.labels && label != null
            ? label.name[0].toUpperCase() + label.name.toString().substring(1)
            : userFound &&
                    (issues.groupBY == GroupBY.createdBY ||
                        issues.groupBY == GroupBY.assignees)
                ? userName = userName[0].toString().toUpperCase() +
                    userName.toString().substring(1)
                : title = title[0].toString().toUpperCase() +
                    title.toString().substring(1),
        header: Text(
          groupID,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: ref!
                .read(ProviderList.themeProvider)
                .themeManager
                .secondaryTextColor,
          ),
        ),

        // backgroundColor: const Color.fromRGBO(250, 250, 250, 1),
        backgroundColor: ref!
            .read(ProviderList.themeProvider)
            .themeManager
            .secondaryBackgroundDefaultColor,
      ));
    }

    for (final element in issues.issues) {
      //  log(issues.groupBY.toString());

      element.leading = issues.groupBY == GroupBY.priority
          ? element.title == 'Urgent'
              ? Icon(
                  Icons.error_outline,
                  size: 18,
                  color: Color(int.parse("FF${"#EF4444".replaceAll('#', '')}",
                      radix: 16)),
                )
              : element.title == 'High'
                  ? Icon(
                      Icons.signal_cellular_alt,
                      size: 18,
                      color: Color(int.parse(
                          "FF${"#F59E0B".replaceAll('#', '')}",
                          radix: 16)),
                    )
                  : element.title == 'Medium'
                      ? Icon(
                          Icons.signal_cellular_alt_2_bar,
                          color: Color(int.parse(
                              "FF${"#F59E0B".replaceAll('#', '')}",
                              radix: 16)),
                          size: 18,
                        )
                      : element.title == 'Low'
                          ? Icon(
                              Icons.signal_cellular_alt_1_bar,
                              color: Color(int.parse(
                                  "FF${"#22C55E".replaceAll('#', '')}",
                                  radix: 16)),
                              size: 18,
                            )
                          : Icon(
                              Icons.do_disturb_alt_outlined,
                              color: Color(int.parse(
                                  "FF${"#A3A3A3".replaceAll('#', '')}",
                                  radix: 16)),
                              size: 18,
                            )
          : issues.groupBY == GroupBY.createdBY ||
                  issues.groupBY == GroupBY.assignees
              ? Container(
                  height: 22,
                  alignment: Alignment.center,
                  width: 22,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromRGBO(55, 65, 81, 1),
                  ),
                  child: CustomText(
                    element.title.toString().toUpperCase()[0],
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeightt.Medium,
                  ),
                )
              : issues.groupBY == GroupBY.labels
                  ? Container(
                      margin: const EdgeInsets.only(top: 3),
                      height: 15,
                      alignment: Alignment.center,
                      width: 15,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: element.title == 'None' ? Colors.black : null
                          // color: Color(int.parse(element.title)),
                          ),
                    )
                  : issues.groupBY == GroupBY.stateGroups
                      ? issuesProvider.defaultStatedetails[element.id]['icon']
                      : issuesProvider.stateIcons[element.id];

      element.header = SizedBox(
        // margin: const EdgeInsets.only(bottom: 10),
        height: 50,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            element.leading ?? Container(),
            const SizedBox(
              width: 10,
            ),
            SizedBox(
              width: element.width - 150,
              child: CustomText(
                element.title.toString(),
                type: FontStyle.Large,
                fontWeight: FontWeightt.Semibold,
                textAlign: TextAlign.start,
                maxLines: 3,
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(
                left: 15,
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: themeProvider
                      .themeManager.tertiaryBackgroundDefaultColor),
              height: 25,
              width: 35,
              child: CustomText(
                element.items.length.toString(),
                type: FontStyle.Small,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                shrinkStates[element.index] = !shrinkStates[element.index];
                notifyListeners();
              },
              child: Icon(
                Icons.zoom_in_map,
                color: themeProvider.themeManager.placeholderTextColor,
                size: 20,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: () {
                issuesProvider.createIssuedata['state'] = element.id;
                Navigator.push(
                    Const.globalKey.currentContext!,
                    MaterialPageRoute(
                        builder: (ctx) => CreateIssue(
                              cycleId: currentCycle['id'],
                            )));
              },
              child: Icon(
                Icons.add,
                color: themeProvider.themeManager.placeholderTextColor,
              ),
            ),
          ],
        ),
      );
    }
    return issues.issues;
  }

  Future reorderIssue({
    required int newCardIndex,
    required int oldCardIndex,
    required int newListIndex,
    required int oldListIndex,
  }) async {
    try {
      if (oldListIndex == newListIndex) {
        notifyListeners();
        return;
      }

      final List newList = filterIssues.values.toList()[newListIndex];
      final List oldList = filterIssues.values.toList()[oldListIndex];

      newList.insert(newCardIndex, oldList.removeAt(oldCardIndex));

      notifyListeners();
      final issue = newList[newCardIndex];
      // log(issue.toString());
      final response = await DioConfig().dioServe(
          hasAuth: true,
          url: APIs.issueDetails
              .replaceAll(
                  "\$SLUG",
                  ref!
                      .read(ProviderList.workspaceProvider)
                      .workspaces
                      .firstWhere((element) =>
                          element['id'] == issue['workspace'])['slug'])
              .replaceAll('\$PROJECTID', issue['project_detail']['id'])
              .replaceAll('\$ISSUEID', issue['id']),
          hasBody: true,
          httpMethod: HttpMethod.patch,
          data: issues.groupBY == GroupBY.state
              ? {
                  'state': filterIssues.keys.elementAt(newListIndex),
                  'priority': issue['priority']
                }
              : {
                  'state': issue['state'],
                  'priority': filterIssues.keys.elementAt(newListIndex)
                });
      newList[newCardIndex] = response.data;
      if (issues.groupBY == GroupBY.priority) {
        log(newList[newCardIndex]['name']);
        newList[newCardIndex]['priority'] =
            filterIssues.keys.elementAt(newListIndex);
      }
      if (issues.orderBY != OrderBY.manual) {
        newList.sort((a, b) {
          if (issues.orderBY == OrderBY.priority) {
            return priorityParser(a['priority'])
                .compareTo(priorityParser(b['priority']));
          } else if (issues.orderBY == OrderBY.lastCreated) {
            return DateTime.parse(b['created_at'])
                .compareTo(DateTime.parse(a['created_at']));
          } else if (issues.orderBY == OrderBY.lastUpdated) {
            return DateTime.parse(a['updated_at'])
                .compareTo(DateTime.parse(b['updated_at']));
          } else {
            return 0;
          }
        });
      }
      notifyListeners();
    } on DioException catch (err) {
      filterIssues.values.elementAt(oldListIndex).insert(oldCardIndex,
          filterIssues.values.elementAt(newListIndex).removeAt(newCardIndex));
      log(err.toString());
      notifyListeners();
      rethrow;
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

  Future getCycleView({bool reset = false, required String cycleId}) async {
    cycleViewState = StateEnum.loading;
    if (reset) {
      notifyListeners();
    }
    try {
      var url = APIs.cycleIssueView
          .replaceAll(
              "\$SLUG",
              ref!
                  .read(ProviderList.workspaceProvider)
                  .selectedWorkspace
                  .workspaceSlug)
          .replaceAll('\$PROJECTID',
              ref!.read(ProviderList.projectProvider).currentProject['id'])
          .replaceAll('\$CYCLEID', cycleId);
      final response = await DioConfig().dioServe(
        hasAuth: true,
        url: url,
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      cycleView = response.data;
      issues.projectView = cycleView['display_filters']['layout'] == 'list'
          ? IssueLayout.list
          : cycleView['display_filters']['layout'] == 'calendar'
              ? IssueLayout.calendar
              : cycleView['display_filters']['layout'] == 'spreadsheet'
                  ? IssueLayout.spreadsheet
                  : IssueLayout.kanban;
      issues.showSubIssues = cycleView['display_filters']['sub_issue'] ?? true;
      issues.groupBY =
          Issues.toGroupBY(cycleView["display_filters"]["group_by"]);
      issues.orderBY =
          Issues.toOrderBY(cycleView["display_filters"]["order_by"]);
      issues.issueType =
          Issues.toIssueType(cycleView["display_filters"]["type"]);
      issues.filters.priorities = (cycleView["filters"]["priority"] == 'none'
              ? []
              : cycleView["filters"]["priority"]) ??
          [];
      issues.filters.states = cycleView["filters"]["state"] ?? [];
      issues.filters.assignees = cycleView["filters"]["assignees"] ?? [];
      issues.filters.createdBy = cycleView["filters"]["created_by"] ?? [];
      issues.filters.labels = cycleView["filters"]["labels"] ?? [];
      issues.filters.targetDate = cycleView["filters"]["target_date"] ?? [];
      issues.filters.startDate = cycleView["filters"]["start_date"] ?? [];
      issues.filters.subscriber = cycleView["filters"]["subscriber"] ?? [];
      issues.filters.stateGroup = cycleView["filters"]["state_group"] ?? [];
      showEmptyStates = cycleView["display_filters"]["show_empty_groups"];

      if (issues.groupBY == GroupBY.none) {
        issues.projectView = IssueLayout.list;
      }
      if (reset) {
        updateCycleView();
      }
      cycleViewState = StateEnum.success;
      notifyListeners();
    } on DioException catch (e) {
      log(e.response.toString());
      issues.projectView = IssueLayout.kanban;
      cycleViewState = StateEnum.error;
      notifyListeners();
    }
  }

  void applyCycleIssuesView({required WidgetRef ref}) {
    final projectProvider = ref.read(ProviderList.projectProvider);
    final statesProvider = ref.read(ProviderList.statesProvider);

    final labelIds =
        ref.read(ProviderList.labelProvider.notifier).getLabelIds();
    filterIssues = IssueFilterHelper.organizeIssues(
        cycleIssuesList, issues.groupBY, issues.orderBY,
        labelIDs: labelIds,
        memberIDs: projectProvider.projectMembers
            .map((e) => e['member']['id'].toString())
            .toList(),
        states: statesProvider.projectStates);
    notifyListeners();
  }

  Future filterCycleIssues(
      {required String slug,
      required String projectId,
      String? cycleID,
      required WidgetRef ref
      // required Map<String, dynamic> data,
      }) async {
    cyclesIssueState = StateEnum.loading;
    notifyListeners();
    final projectProvider = ref.read(ProviderList.projectProvider);
    final statesProvider = ref.read(ProviderList.statesProvider.notifier);
    final labelNotifier = ref.read(ProviderList.labelProvider.notifier);
    final states = ref.read(ProviderList.statesProvider).projectStates;

    if (issues.groupBY == GroupBY.labels) {
      labelNotifier.getProjectLabels();
    } else if (issues.groupBY == GroupBY.createdBY) {
      projectProvider.getProjectMembers(slug: slug, projId: projectId);
    } else if (issues.groupBY == GroupBY.state) {
      statesProvider.getStates(
        slug: slug,
        projectId: projectId,
      );
    }

    String url;
    url = APIs.orderByGroupByCycleIssues
        .replaceAll("\$SLUG", slug)
        .replaceAll('\$PROJECTID', projectId)
        .replaceAll('\$CYCLEID', cycleID!)
        .replaceAll('\$TYPE', Issues.fromIssueType(issues.issueType));
    url = '$url${IssueFilterHelper.getFilterQueryParams(issues.filters)}';
    url = '$url&sub_issue=${issues.showSubIssues}&show_empty_groups=true';
    log(url.toString());
    try {
      final response = await DioConfig().dioServe(
        hasAuth: true,
        url: url,
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      // cycleIssuesList = [];
      cycleIssuesList = response.data;
      final organizedIssues = IssueFilterHelper.organizeIssues(
          cycleIssuesList, issues.groupBY, issues.orderBY,
          labelIDs: labelNotifier.getLabelIds(),
          memberIDs: projectProvider.projectMembers
              .map((e) => e['member']['id'].toString())
              .toList(),
          states: states);
      filterIssues = organizedIssues;
      issuesResponse = [];
      isIssuesEmpty = true;
      if (issues.groupBY != GroupBY.none) {
        for (final key in filterIssues.keys) {
          if (filterIssues[key].isNotEmpty) {
            isIssuesEmpty = false;
            break;
          }
        }
      } else {
        isIssuesEmpty = filterIssues.values.first.isEmpty;
      }
      if (issues.groupBY == GroupBY.state) {
        states.forEach((key, value) {
          if (issues.filters.states.isEmpty && filterIssues[key] == null) {
            filterIssues[key] = [];
          }
          shrinkStates.add(false);
        });
      } else {
        shrinkStates = [];
        filterIssues.forEach((key, value) {
          shrinkStates.add(false);
        });
      }

      initializeBoard();

      cyclesIssueState = StateEnum.success;
      notifyListeners();
    } on DioException catch (e) {
      log(e.toString());
      cyclesIssueState = StateEnum.error;
      notifyListeners();
    }
  }

  Future updateCycleView(
      {bool isArchive = false, bool setDefault = false}) async {
    final Map<String, dynamic> view = {
      "view_props": {
        "calendarDateRange": "",
        "collapsed": false,
        "filterIssue": null,
        "filters": {
          // 'type': null,
          // "priority": filterPriority,
          if (issues.filters.priorities.isNotEmpty)
            "priority": issues.filters.priorities,
          if (issues.filters.states.isNotEmpty) "state": issues.filters.states,
          if (issues.filters.assignees.isNotEmpty)
            "assignees": issues.filters.assignees,
          if (issues.filters.createdBy.isNotEmpty)
            "created_by": issues.filters.createdBy,
          if (issues.filters.labels.isNotEmpty) "labels": issues.filters.labels,
          if (issues.filters.targetDate.isNotEmpty)
            "target_date": issues.filters.targetDate,
          if (issues.filters.startDate.isNotEmpty)
            "start_date": issues.filters.startDate,
          if (issues.filters.subscriber.isNotEmpty)
            "subscriber": issues.filters.subscriber,
          if (issues.filters.stateGroup.isNotEmpty)
            "state_group": issues.filters.stateGroup,
        },
        "display_filters": {
          "group_by": Issues.fromGroupBY(issues.groupBY),
          "order_by": Issues.fromOrderBY(issues.orderBY),
          "type": Issues.fromIssueType(issues.issueType),
          "show_empty_groups": showEmptyStates,
          if (!isArchive)
            "layout": issues.projectView == IssueLayout.kanban
                ? 'kanban'
                : issues.projectView == IssueLayout.list
                    ? 'list'
                    : issues.projectView == IssueLayout.calendar
                        ? 'calendar'
                        : 'spreadsheet',
          "sub_issue": false,
        },
      }
    };
    if (setDefault) {
      view['default_props'] = view['view_props'];
    }
    try {
      await DioConfig().dioServe(
        hasAuth: true,
        url: APIs.cycleIssueView
            .replaceAll(
                "\$SLUG",
                ref!
                    .read(ProviderList.workspaceProvider)
                    .selectedWorkspace
                    .workspaceSlug)
            .replaceAll('\$PROJECTID',
                ref!.read(ProviderList.projectProvider).currentProject['id'])
            .replaceAll('\$CYCLEID', currentCycle['id']),
        hasBody: true,
        data: view,
        httpMethod: HttpMethod.patch,
      );
      cycleViewState = StateEnum.success;
      notifyListeners();
    } on DioException catch (e) {
      log(e.response.toString());
      cycleViewState = StateEnum.error;
      notifyListeners();
    }
    notifyListeners();
  }

  bool isTagsEnabled() {
    return issues.displayProperties.assignee ||
        issues.displayProperties.dueDate ||
        issues.displayProperties.label ||
        issues.displayProperties.state ||
        issues.displayProperties.subIsseCount ||
        issues.displayProperties.priority ||
        issues.displayProperties.linkCount ||
        issues.displayProperties.attachmentCount;
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
