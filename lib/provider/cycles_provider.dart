import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane_startup/config/apis.dart';
import 'package:plane_startup/config/const.dart';
import 'package:plane_startup/kanban/models/inputs.dart';
import 'package:plane_startup/models/issues.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/screens/MainScreens/Projects/ProjectDetail/IssuesTab/create_issue.dart';
import 'package:plane_startup/services/dio_service.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/utils/enums.dart';
import 'package:plane_startup/widgets/custom_text.dart';
import 'package:plane_startup/widgets/issue_card_widget.dart';

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
  Issues issues = Issues.initialize();
  List issuesResponse = [];
  List shrinkStates = [];
  Map filterIssues = {};
  Map issueProperty = {};
  bool showEmptyStates = false;
  bool isIssuesEmpty = false;
  int cycleDetailSelectedIndex = 0;
  List queries = ['all', 'current', 'upcoming', 'completed', 'draft'];
  List stateOrdering = [];
  setState() {
    notifyListeners();
  }

  changeTabIndex(int index) {
    cycleDetailSelectedIndex = index;
    notifyListeners();
  }

  clearData() {
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
    var url = APIs.dateCheck
        .replaceFirst('\$SLUG', slug)
        .replaceFirst('\$PROJECTID', projectId);

    try {
      cyclesState = StateEnum.loading;
      notifyListeners();
      var response = await DioConfig().dioServe(
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

  Future cyclesCrud({
    bool disableLoading = false,
    required String slug,
    required String projectId,
    required CRUD method,
    required String query,
    Map<String, dynamic>? data,
  }) async {
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
    var url = query == ''
        ? APIs.cycles
            .replaceFirst('\$SLUG', slug)
            .replaceFirst('\$PROJECTID', projectId)
        : '${APIs.cycles.replaceFirst('\$SLUG', slug).replaceFirst('\$PROJECTID', projectId)}?cycle_view=$query';

    try {
      // if (!disableLoading) {
      //   cyclesState = StateEnum.loading;
      //   notifyListeners();
      // }
      var response = await DioConfig().dioServe(
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

      // log('CYCLES =========> ${response.data.toString()}');

      // * RESPONSE FROM API CONVERTED TO MODEL IS THROWING ERRORS FOR VIEW PROPS ATTRIBUTE * //
      // cyclesData = CyclesModel.fromJson(response.data);
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
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    } on DioException catch (e) {
      log(e.message.toString());
      cyclesState = StateEnum.error;
      notifyListeners();
    }
  }

  void changeStateToLoading(StateEnum state) {
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
      if (!disableLoading) {
        cyclesDetailState = StateEnum.loading;
        notifyListeners();
      }

      var url =
          '${APIs.cycles.replaceFirst('\$SLUG', slug).replaceFirst('\$PROJECTID', projectId)}$cycleId/';
      var response = await DioConfig().dioServe(
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
        log('CYCLE DETAILS =========> ${response.data.toString()}');
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

  Future updateCycle({
    required String slug,
    required String projectId,
    Map<String, dynamic>? data,
    required String cycleId,
    required bool isFavorite,
    required String query,
    bool disableLoading = false,
  }) async {
    var url = !isFavorite
        ? APIs.toggleFavoriteCycle
            .replaceFirst('\$SLUG', slug)
            .replaceFirst('\$PROJECTID', projectId)
        : '${APIs.toggleFavoriteCycle.replaceAll('\$SLUG', slug).replaceAll('\$PROJECTID', projectId)}$cycleId/';

    try {
      if (!disableLoading) {
        cyclesState = StateEnum.loading;
        notifyListeners();
      }

      var response = await DioConfig().dioServe(
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
          );
        }
      }

      await cyclesCrud(
        slug: slug,
        projectId: projectId,
        method: CRUD.read,
        query: query,
      );
      cyclesCrud(
        slug: slug,
        projectId: projectId,
        method: CRUD.read,
        query: 'all',
      );
      cyclesState = StateEnum.success;
      notifyListeners();
    } on DioException catch (e) {
      log(e.message.toString());
      cyclesState = StateEnum.error;
      notifyListeners();
    }
  }

  List<BoardListsData> initializeBoard() {
    var themeProvider = ref!.read(ProviderList.themeProvider);
    var issuesProvider = ref!.read(ProviderList.issuesProvider);
    int count = 0;
    // log(issues.groupBY.name);
    issues.issues = [];
    for (int j = 0; j < stateOrdering.length; j++) {
      List<Widget> items = [];

      for (int i = 0;
          filterIssues[stateOrdering[j]] != null &&
              i < filterIssues[stateOrdering[j]]!.length;
          i++) {
        issuesResponse.add(filterIssues[stateOrdering[j]]![i]);

        items.add(
          IssueCardWidget(
            cardIndex: count++,
            listIndex: j,
            issueCategory: IssueCategory.cycleIssues,
          ),
        );
      }
      Map label = {};
      String userName = '';

      bool labelFound = false;
      bool userFound = false;

      for (int i = 0; i < issuesProvider.labels.length; i++) {
        if (stateOrdering[j] == issuesProvider.labels[i]['id']) {
          label = issuesProvider.labels[i];
          labelFound = true;
          break;
        }
      }

      for (int i = 0; i < issuesProvider.members.length; i++) {
        if (stateOrdering[j] == issuesProvider.members[i]['member']['id']) {
          userName = issuesProvider.members[i]['member']['first_name'] +
              ' ' +
              issuesProvider.members[i]['member']['last_name'];
          userName = userName.trim().isEmpty
              ? issuesProvider.members[i]['member']['email']
              : userName;
          userFound = true;
          break;
        }
      }
      //log('RESPONSE : ' + filterIssues.toString());
      log(stateOrdering[j]);
      var title = issues.groupBY == GroupBY.priority
          ? stateOrdering[j]
          : issues.groupBY == GroupBY.state
              ? issuesProvider.states[stateOrdering[j]]['name']
              : stateOrdering[j];
      issues.issues.add(BoardListsData(
        id: stateOrdering[j],
        items: items,
        shrink: shrinkStates[j],
        index: j,
        width: issuesProvider.issues.projectView == ProjectView.list
            ? MediaQuery.of(Const.globalKey.currentContext!).size.width
            : 300,
        // shrink: shrinkissuesProvider.states[count++],
        title: issues.groupBY == GroupBY.labels && labelFound
            ? label['name'][0].toString().toUpperCase() +
                label['name'].toString().substring(1)
            : userFound && issues.groupBY == GroupBY.createdBY
                ? userName = userName[0].toString().toUpperCase() +
                    userName.toString().substring(1)
                : title = title[0].toString().toUpperCase() +
                    title.toString().substring(1),
        header: Text(
          stateOrdering[j],
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: ref!.read(ProviderList.themeProvider).isDarkThemeEnabled
                ? darkSecondaryTextColor
                : lightSecondaryTextColor,
          ),
        ),

        // backgroundColor: const Color.fromRGBO(250, 250, 250, 1),
        backgroundColor:
            ref!.read(ProviderList.themeProvider).isDarkThemeEnabled
                ? darkSecondaryBackgroundDefaultColor
                : lightSecondaryBackgroundDefaultColor,
      ));
    }

    for (var element in issues.issues) {
      //  log(issues.groupBY.toString());

      element.leading = issues.groupBY == GroupBY.priority
          ? element.title == 'Urgent'
              ? Icon(Icons.error_outline,
                  size: 18,
                  color: themeProvider.isDarkThemeEnabled
                      ? Colors.white
                      : Colors.black)
              : element.title == 'High'
                  ? Icon(
                      Icons.signal_cellular_alt,
                      color: themeProvider.isDarkThemeEnabled
                          ? Colors.white
                          : Colors.black,
                      size: 18,
                    )
                  : element.title == 'Medium'
                      ? Icon(
                          Icons.signal_cellular_alt_2_bar,
                          color: themeProvider.isDarkThemeEnabled
                              ? Colors.white
                              : Colors.black,
                          size: 18,
                        )
                      : Icon(
                          Icons.signal_cellular_alt_1_bar,
                          color: themeProvider.isDarkThemeEnabled
                              ? Colors.white
                              : Colors.black,
                          size: 18,
                        )
          : issues.groupBY == GroupBY.createdBY
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
                    fontWeight: FontWeight.w500,
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
                type: FontStyle.heading,
                textAlign: TextAlign.start,
                fontSize: 20,
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
                  color: themeProvider.isDarkThemeEnabled
                      ? const Color.fromRGBO(39, 42, 45, 1)
                      : const Color.fromRGBO(222, 226, 230, 1)),
              height: 25,
              width: 35,
              child: CustomText(
                element.items.length.toString(),
                type: FontStyle.subtitle,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                shrinkStates[element.index] = !shrinkStates[element.index];
                notifyListeners();
              },
              child: const Icon(
                Icons.zoom_in_map,
                color: Color.fromRGBO(133, 142, 150, 1),
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
              child: const Icon(
                Icons.add,
                color: primaryColor,
              ),
            ),
          ],
        ),
      );
    }
    //   log(issues.issues.toString());
    return issues.issues;
  }

  Future createCycleIssues(
      {required String slug,
      required String projId,
      required List<String> issues,
      String? cycleId}) async {
    cyclesIssueState = StateEnum.loading;
    notifyListeners();
    var data = {
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

  Future filterCycleIssues({
    required String slug,
    required String projectId,
    // required Map<String, dynamic> data,
  }) async {
    cyclesIssueState = StateEnum.loading;
    notifyListeners();
    try {
      var issuesProvider = ref!.read(ProviderList.issuesProvider);
      filterIssues = await issuesProvider.filterIssues(
        slug: slug,
        projID: projectId,
        issueCategory: IssueCategory.cycleIssues,
      );

      issuesResponse = [];
      isIssuesEmpty = true;
      for (var key in filterIssues.keys) {
        log("KEY=$key");
        if (filterIssues[key].isNotEmpty) {
          isIssuesEmpty = false;
          break;
        }
      }
      if (issues.groupBY == GroupBY.state) {
        issuesProvider.states.forEach((key, value) {
          if (issues.filters.states.isEmpty && filterIssues[key] == null) {
            filterIssues[key] = [];
          }
          shrinkStates.add(false);
        });
      } else {
        stateOrdering = [];
        filterIssues.forEach((key, value) {
          stateOrdering.add(key);
        });
      }
      cyclesIssueState = StateEnum.success;
      notifyListeners();
    } catch (e) {
      log(e.toString());
      cyclesIssueState = StateEnum.error;
      notifyListeners();
    }
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
}
