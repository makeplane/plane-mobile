import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane_startup/config/apis.dart';
import 'package:plane_startup/config/const.dart';
import 'package:plane_startup/kanban/models/inputs.dart';
import 'package:plane_startup/models/issues.dart';
import 'package:plane_startup/screens/MainScreens/Projects/ProjectDetail/IssuesTab/create_issue.dart';
import 'package:plane_startup/services/dio_service.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/utils/enums.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/widgets/custom_text.dart';
import 'package:plane_startup/widgets/issue_card_widget.dart';

class ModuleProvider with ChangeNotifier {
  ModuleProvider(ChangeNotifierProviderRef<ModuleProvider> this.ref);
  Ref? ref;
  var modules = [];
  var favModules = [];
  var createModule = {};
  int cycleDetailSelectedIndex = 0;
  Map<String, dynamic> moduleDetailsData = {};
  List<String> selectedIssues = [];
  int statusIndex = -1;
  var moduleSatatus = [
    {
      'name': 'Backlog',
      'value': 'backlog',
      'color': const Color.fromRGBO(94, 106, 210, 1),
    },
    {
      'name': 'Planned',
      'value': 'planned',
      'color': const Color.fromRGBO(38, 181, 206, 1),
    },
    {
      'name': 'In Progress',
      'value': 'in-progress',
      'color': const Color.fromRGBO(242, 201, 76, 1),
    },
    {
      'name': 'Paused',
      'value': 'paused',
      'color': const Color.fromRGBO(255, 105, 0, 1),
    },
    {
      'name': 'Completed',
      'value': 'completed',
      'color': const Color.fromRGBO(76, 183, 130, 1),
    },
    {
      'name': 'Cancelled',
      'value': 'cancelled',
      'color': const Color.fromRGBO(204, 29, 16, 1),
    },
  ];

  Map currentModule = {};
  Issues issues = Issues.initialize();
  List issuesResponse = [];
  List shrinkStates = [];
  List stateOrdering = [];
  Map filterIssues = {};
  Map issueProperty = {};
  bool showEmptyStates = true;
  bool isIssuesEmpty = false;
  int moduleDetailSelectedIndex = 0;

  var createModuleState = StateEnum.empty;
  StateEnum moduleState = StateEnum.empty;
  StateEnum moduleDetailState = StateEnum.empty;
  StateEnum moduleIssueState = StateEnum.loading;

  void changeIndex(int index) {
    statusIndex = index;
    createModule['status'] = moduleSatatus[index]['value'];
    notifyListeners();
  }

  void changeTabIndex(int index) {
    moduleDetailSelectedIndex = index;
    notifyListeners();
  }

  void clearData() {
    modules.clear();
    favModules.clear();
    createModule.clear();
    moduleDetailsData.clear();
    selectedIssues.clear();

    notifyListeners();
  }

  void setState() {
    notifyListeners();
  }

  Future getModules(
      {required String slug,
      required String projId,
      bool disableLoading = false}) async {
    if (!disableLoading) {
      moduleState = StateEnum.loading;
      notifyListeners();
    }

    try {
      var response = await DioConfig().dioServe(
        hasAuth: true,
        url: APIs.listModules
            .replaceAll('\$SLUG', slug)
            .replaceAll('\$PROJECTID', projId),
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      favModules.clear();
      modules.clear();
      response.data.forEach((element) {
        if (element['is_favorite'] == true) {
          favModules.add(element);
        } else {
          modules.add(element);
        }
      });

      moduleState = StateEnum.success;
      notifyListeners();
      log('Modules  ===> ${favModules.length.toString()}   ${modules.length.toString()}');
    } on DioException catch (e) {
      log(e.error.toString());
      moduleState = StateEnum.error;
      notifyListeners();
    }
  }

  Future createNewModule(
      {required String slug, required String projId, String? moduleId}) async {
    createModuleState = StateEnum.loading;
    notifyListeners();
    try {
      var response = await DioConfig().dioServe(
        hasAuth: true,
        url: APIs.listModules
            .replaceAll('\$SLUG', slug)
            .replaceAll('\$PROJECTID', projId),
        hasBody: true,
        httpMethod: HttpMethod.post,
        data: createModule,
      );
      createModuleState = StateEnum.success;
      getModules(slug: slug, projId: projId);
      createModule.clear();
      notifyListeners();
      log('Create Module  ===> ${response.data.toString()}');
    } on DioException catch (e) {
      log('Create Module Error  ===> ${e.error.toString()}');

      createModuleState = StateEnum.error;
      notifyListeners();
    }
  }

  Future updateModules({
    required String slug,
    required String projId,
    required String moduleId,
    required data,
    bool disableLoading = false,
  }) async {
    if (!disableLoading) {
      moduleDetailState = StateEnum.loading;
      notifyListeners();
    }

    try {
      var response = await DioConfig().dioServe(
        hasAuth: true,
        url:
            '${APIs.listModules.replaceAll('\$SLUG', slug).replaceAll('\$PROJECTID', projId)}$moduleId/',
        hasBody: true,
        httpMethod: HttpMethod.patch,
        data: data,
      );
      moduleDetailState = StateEnum.success;
      getModuleDetails(
          slug: slug,
          projId: projId,
          moduleId: moduleId,
          disableLoading: disableLoading);
      notifyListeners();
      log('Update Module  ===> ${response.data.toString()}');
    } on DioException catch (e) {
      log(e.error.toString());
      moduleDetailState = StateEnum.error;
      notifyListeners();
    }
  }

  Future favouriteModule({
    required String slug,
    required String projId,
    required String moduleId,
    required bool isFav,
  }) async {
    // moduleState = StateEnum.loading;
    // notifyListeners();
    try {
      var response = await DioConfig().dioServe(
        hasAuth: true,
        url: isFav
            ? '${APIs.favouriteModules.replaceAll('\$SLUG', slug).replaceAll('\$PROJECTID', projId)}$moduleId/'
            : APIs.favouriteModules
                .replaceAll('\$SLUG', slug)
                .replaceAll('\$PROJECTID', projId),
        hasBody: isFav ? false : true,
        data: isFav ? null : {'module': moduleId},
        httpMethod: isFav ? HttpMethod.delete : HttpMethod.post,
      );
      moduleState = StateEnum.success;
      getModules(slug: slug, projId: projId, disableLoading: true);
      notifyListeners();
      log('Favourite Module  ===> ${response.data.toString()}');
    } on DioException catch (e) {
      log(e.error.toString());
      moduleState = StateEnum.error;
      notifyListeners();
    }
  }

  Future deleteModule({
    required String slug,
    required String projId,
    required String moduleId,
  }) async {
    moduleState = StateEnum.loading;
    notifyListeners();
    try {
      var response = await DioConfig().dioServe(
        hasAuth: true,
        url:
            '${APIs.listModules.replaceAll('\$SLUG', slug).replaceAll('\$PROJECTID', projId)}$moduleId/',
        hasBody: false,
        httpMethod: HttpMethod.delete,
      );
      moduleState = StateEnum.success;
      getModules(slug: slug, projId: projId);
      notifyListeners();
      log('Delete Module  ===> ${response.data.toString()}');
    } on DioException catch (e) {
      log(e.error.toString());
      moduleState = StateEnum.error;
      notifyListeners();
    }
  }

  Future getModuleDetails({
    required String slug,
    required String projId,
    required String moduleId,
    bool disableLoading = false,
  }) async {
    log('${APIs.listModules.replaceAll('\$SLUG', slug).replaceAll('\$PROJECTID', projId)}$moduleId/');
    if (!disableLoading) {
      moduleDetailState = StateEnum.loading;
      notifyListeners();
    }
    moduleDetailState = StateEnum.loading;
    try {
      var response = await DioConfig().dioServe(
        hasAuth: true,
        url:
            '${APIs.listModules.replaceAll('\$SLUG', slug).replaceAll('\$PROJECTID', projId)}$moduleId/',
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      moduleDetailsData = response.data;
      moduleDetailState = StateEnum.success;
      currentModule = response.data;
      notifyListeners();
      log('Module Details  ===> ${response.data.toString()}');
    } on DioException catch (e) {
      log(e.error.toString());
      moduleDetailState = StateEnum.error;
      notifyListeners();
    }
  }

  Future createModuleIssues(
      {required String slug,
      required String projID,
      required List<String> issues,
      String? moduleId}) async {
    moduleIssueState = StateEnum.loading;
    notifyListeners();
    var data = {
      'issues': issues,
    };
    log(data.toString());
    //1a6b5ed6-63af-4584-8d73-d7d3cf1a5eef
    try {
      var response = await DioConfig().dioServe(
        hasAuth: true,
        url: APIs.moduleIssues
            .replaceAll(
              '\$SLUG',
              slug,
            )
            .replaceAll(
              '\$PROJECTID',
              projID,
            )
            .replaceAll(
              '\$MODULEID',
              moduleId ?? currentModule['id'].toString(),
            ),
        hasBody: true,
        data: data,
        httpMethod: HttpMethod.post,
      );
      moduleIssueState = StateEnum.success;
      notifyListeners();
      log('Create Module Issues  ===> ${response.data.toString()}');
    } on DioException catch (e) {
      log('Create Module Issues Error  ===> ');
      log(e.error.toString());
      moduleIssueState = StateEnum.error;
      notifyListeners();
    }
  }

  Future deleteModuleIssues(
      {required String slug,
      required String projID,
      required String issueId,
      String? moduleId}) async {
    moduleIssueState = StateEnum.loading;
    notifyListeners();
    try {
      var response = await DioConfig().dioServe(
        hasAuth: true,
        url: '${APIs.moduleIssues.replaceAll(
              '\$SLUG',
              slug,
            ).replaceAll(
              '\$PROJECTID',
              projID,
            ).replaceAll(
              '\$MODULEID',
              moduleId ?? currentModule['id'].toString(),
            )}$issueId/',
        hasBody: false,
        httpMethod: HttpMethod.delete,
      );
      moduleIssueState = StateEnum.success;
      notifyListeners();
      log('Delete Module Issues  ===> ${response.data.toString()}');
    } on DioException catch (e) {
      log('Delete Module Issues Error  ===> ');
      log(e.error.toString());

      moduleIssueState = StateEnum.error;
      notifyListeners();
    }
  }

  Future filterModuleIssues({
    required String slug,
    required String projectId,
    // required Map<String, dynamic> data,
  }) async {
    moduleIssueState = StateEnum.loading;
    notifyListeners();
    try {
      var issuesProvider = ref!.read(ProviderList.issuesProvider);
      filterIssues = await issuesProvider.filterIssues(
        slug: slug,
        projID: projectId,
        issueCategory: IssueCategory.moduleIssues,
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
      moduleIssueState = StateEnum.success;
      notifyListeners();
    } catch (e) {
      log(e.toString());
      moduleIssueState = StateEnum.error;
      notifyListeners();
    }
  }

  List<BoardListsData> initializeBoard() {
    var themeProvider = ref!.read(ProviderList.themeProvider);
    var issuesProvider = ref!.read(ProviderList.issuesProvider);
    int count = 0;
    // log(issues.groupBY.name);
    issues.issues = [];
    for (int j = 0; j < filterIssues.length; j++) {
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
            issueCategory: IssueCategory.moduleIssues,
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
        backgroundColor: ref!
            .read(ProviderList.themeProvider)
            .themeManager
            .secondaryBackgroundDefaultColor,
      ));
    }

    for (var element in issues.issues) {
      //  log(issues.groupBY.toString());

      element.leading = issues.groupBY == GroupBY.priority
          ? element.title == 'Urgent'
              ? Icon(Icons.error_outline,
                  size: 18, color: themeProvider.themeManager.primaryTextColor)
              : element.title == 'High'
                  ? Icon(
                      Icons.signal_cellular_alt,
                      color: themeProvider.themeManager.primaryTextColor,
                      size: 18,
                    )
                  : element.title == 'Medium'
                      ? Icon(
                          Icons.signal_cellular_alt_2_bar,
                          color: themeProvider.themeManager.primaryTextColor,
                          size: 18,
                        )
                      : Icon(
                          Icons.signal_cellular_alt_1_bar,
                          color: themeProvider.themeManager.primaryTextColor,
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
                    fontWeight: FontWeightt.Semibold,
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
                              moduleId: currentModule['id'],
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
