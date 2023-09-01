import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:plane_startup/config/const.dart';
import 'package:plane_startup/kanban/models/inputs.dart';
import 'package:plane_startup/models/issues.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/screens/MainScreens/Projects/ProjectDetail/IssuesTab/create_issue.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/utils/global_functions.dart';
import 'package:plane_startup/widgets/custom_text.dart';
import 'package:plane_startup/widgets/issue_card_widget.dart';
import 'package:plane_startup/config/apis.dart';
import 'package:plane_startup/services/dio_service.dart';
import 'package:plane_startup/utils/enums.dart';

class IssuesProvider extends ChangeNotifier {
  IssuesProvider(ChangeNotifierProviderRef<IssuesProvider> this.ref);
  Ref? ref;
  StateEnum statesState = StateEnum.empty;
  StateEnum membersState = StateEnum.empty;
  StateEnum issueState = StateEnum.empty;
  StateEnum labelState = StateEnum.empty;
  StateEnum orderByState = StateEnum.empty;
  StateEnum projectViewState = StateEnum.empty;
  StateEnum issuePropertyState = StateEnum.empty;
  StateEnum joinprojectState = StateEnum.empty;
  StateEnum updateIssueState = StateEnum.empty;
  var createIssueState = StateEnum.empty;
  String createIssueParent = '';
  String createIssueParentId = '';
  var issueView = {};
  bool showEmptyStates = true;
  bool isISsuesEmpty = true;
  Issues issues = Issues.initialize();
  var tempGroupBy = GroupBY.state;
  var tempFilters = Filters(
    assignees: [],
    createdBy: [],
    labels: [],
    priorities: [],
    states: [],
    targetDate: [],
    startDate: [],
  );
  var tempIssueType = IssueType.all;
  var tempProjectView = ProjectView.kanban;
  var tempOrderBy = OrderBY.lastCreated;
  var stateIcons = {};
  var issueProperty = {};
  var createIssuedata = {};
  var createIssueProjectData = {};
  var issuesResponse = [];
  var issuesList = [];
  var labels = [];
  var states = {};
  var statesData = {};
  var members = [];
  var projectView = {};
  var groupByResponse = {};
  var shrinkStates = [];
  List blockingIssues = [];
  List blockedByIssues = [];
  List<Map> selectedLabels = [];
  List blockingIssuesIds = [];
  List blockedByIssuesIds = [];
  List subIssuesIds = [];
  List defaultStateGroups = [
    'backlog',
    'unstarted',
    'started',
    'completed',
    'cancelled',
  ];
  List stateOrdering = [];

  void clear() {
    issueView = {};
    showEmptyStates = true;
    issues = Issues(
        issues: [],
        projectView: ProjectView.kanban,
        groupBY: GroupBY.state,
        orderBY: OrderBY.manual,
        issueType: IssueType.all,
        displayProperties: DisplayProperties(
          estimate: false,
          assignee: false,
          dueDate: false,
          startDate: false,
          id: false,
          label: false,
          state: false,
          subIsseCount: false,
          priority: false,
          attachmentCount: false,
          linkCount: false,
          createdOn: false,
          updatedOn: false,
        ));
    stateIcons = {};
    issueProperty = {};
    createIssuedata = {};
    createIssueParent = '';
    createIssueParentId = '';
    issuesResponse = [];
    subIssuesIds = [];
    labels = [];
    states = {};
    statesData = {};
    members = [];
    projectView = {};
    groupByResponse = {};

    shrinkStates = [];
    blockingIssues = [];
    blockedByIssues = [];
  }

  void setsState() {
    notifyListeners();
  }

  void clearData() {
    groupByResponse = {};
    issues.groupBY = GroupBY.state;
    issues.orderBY = OrderBY.manual;
    issues.issueType = IssueType.all;
    //notifyListeners();
  }

  List<BoardListsData> initializeBoard() {
    var themeProvider = ref!.read(ProviderList.themeProvider);
    int count = 0;
    //   log(issues.groupBY.name);
    issuesResponse = [];
    issues.issues = [];
    for (int j = 0; j < stateOrdering.length; j++) {
      List<Widget> items = [];
      if (groupByResponse[stateOrdering[j]] == null) {
        continue;
      }
      // log(states[stateOrdering[j]]["name"]);
      for (int i = 0;
          groupByResponse[stateOrdering[j]] != null &&
              i < groupByResponse[stateOrdering[j]]!.length;
          i++) {
        issuesResponse.add(groupByResponse[stateOrdering[j]]![i]);

        items.add(
          IssueCardWidget(
            cardIndex: count++,
            listIndex: j,
            issueCategory: IssueCategory.issues,
          ),
        );
      }
      Map label = {};
      String userName = '';

      bool labelFound = false;
      bool userFound = false;

      for (int i = 0; i < labels.length; i++) {
        if (stateOrdering[j] == labels[i]['id']) {
          label = labels[i];
          labelFound = true;
          break;
        }
      }

      for (int i = 0; i < members.length; i++) {
        if (stateOrdering[j] == members[i]['member']['id']) {
          userName = members[i]['member']['first_name'] +
              ' ' +
              members[i]['member']['last_name'];
          userName = userName.trim().isEmpty
              ? members[i]['member']['email']
              : userName;
          userFound = true;
          break;
        }
      }
      // log(label.toString());
      var title = issues.groupBY == GroupBY.priority
          ? stateOrdering[j]
          : issues.groupBY == GroupBY.state
              ? states[stateOrdering[j]]['name']
              : stateOrdering[j];
      issues.issues.add(BoardListsData(
        id: stateOrdering[j],
        items: items,
        shrink: j >= shrinkStates.length ? false : shrinkStates[j],
        index: j,
        width: issues.projectView == ProjectView.list
            ? MediaQuery.of(Const.globalKey.currentContext!).size.width
            : (width > 500 ? 400 : width * 0.8),
        // shrink: shrinkStates[count++],
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
                  size: 18,
                  color: themeProvider.themeManager.placeholderTextColor)
              : element.title == 'High'
                  ? Icon(
                      Icons.signal_cellular_alt,
                      color: themeProvider.themeManager.placeholderTextColor,
                      size: 18,
                    )
                  : element.title == 'Medium'
                      ? Icon(
                          Icons.signal_cellular_alt_2_bar,
                          color:
                              themeProvider.themeManager.placeholderTextColor,
                          size: 18,
                        )
                      : Icon(
                          Icons.signal_cellular_alt_1_bar,
                          color:
                              themeProvider.themeManager.placeholderTextColor,
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
                  : stateIcons[element.id];

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

                // log(element.index.toString() +
                //     shrinkStates[element.index].toString());

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
            ref!.read(ProviderList.projectProvider).role == Role.admin ||
                    ref!.read(ProviderList.projectProvider).role == Role.member
                ? GestureDetector(
                    onTap: () {
                      if (issues.groupBY == GroupBY.state) {
                        createIssuedata['state'] = element.id;
                      } else {
                        createIssuedata['priority'] =
                            'de3c90cd-25cd-42ec-ac6c-a66caf8029bc';
                        // createIssuedata['s'] = element.id;
                      }

                      Navigator.push(
                          Const.globalKey.currentContext!,
                          MaterialPageRoute(
                              builder: (ctx) => const CreateIssue()));
                    },
                    child: Icon(
                      Icons.add,
                      color: themeProvider.themeManager.placeholderTextColor,
                    ))
                : Container(),
          ],
        ),
      );
    }

    return issues.issues;
  }

  bool checkIsCardsDaraggable() {
    var projProv = ref!.read(ProviderList.projectProvider);

    return (issues.groupBY == GroupBY.state ||
            issues.groupBY == GroupBY.priority) &&
        (projProv.role == Role.admin || projProv.role == Role.member) &&
        (issues.filters.assignees.isEmpty &&
            issues.filters.labels.isEmpty &&
            issues.filters.states.isEmpty &&
            issues.filters.priorities.isEmpty &&
            issues.filters.createdBy.isEmpty &&
            issues.filters.targetDate.isEmpty);
  }

  Future reorderIssue({
    required int newCardIndex,
    required int oldCardIndex,
    required int newListIndex,
    required int oldListIndex,
  }) async {
    try {
      (groupByResponse[stateOrdering[newListIndex]] as List).insert(
          newCardIndex,
          groupByResponse[stateOrdering[oldListIndex]].removeAt(oldCardIndex));
      updateIssueState = StateEnum.loading;
      notifyListeners();
      var issue = groupByResponse[stateOrdering[newListIndex]][newCardIndex];
      await DioConfig().dioServe(
          hasAuth: true,
          url: APIs.issueDetails
              .replaceAll("\$SLUG", issue['workspace_detail']['slug'])
              .replaceAll('\$PROJECTID', issue['project_detail']['id'])
              .replaceAll('\$ISSUEID', issue['id']),
          hasBody: true,
          httpMethod: HttpMethod.patch,
          data: issues.groupBY == GroupBY.state
              ? {
                  'state': stateOrdering[newListIndex],
                  'priority': issue['priority']
                }
              : {
                  'state': issue['state'],
                  'priority': stateOrdering[newListIndex],
                });

      updateIssueState = StateEnum.success;
      // log(response.data.toString());
      if (issues.groupBY == GroupBY.priority) {
        log(groupByResponse[stateOrdering[newListIndex]][newCardIndex]['name']);
        groupByResponse[stateOrdering[newListIndex]][newCardIndex]['priority'] =
            stateOrdering[newListIndex];
      }
      notifyListeners();
    } on DioException catch (e) {
      log('Error : issues_provider : upDateIssue : ${e.message.toString()}');
      updateIssueState = StateEnum.error;
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

  Future getLabels({required String slug, required String projID}) async {
    labelState = StateEnum.loading;
    // notifyListeners();

    try {
      var response = await DioConfig().dioServe(
        hasAuth: true,
        // url: APIs.issueLabels
        //     .replaceAll("\$SLUG", slug)
        //     .replaceAll('\$PROJECTID', projID),
        url:
            '${APIs.baseApi}/api/workspaces/$slug/projects/$projID/issue-labels/',
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      // log('getLabels' + response.data.toString());
      labels = response.data;
      labelState = StateEnum.success;

      notifyListeners();
    } on DioException catch (e) {
      log('Error in getLabels  ${e.message}');
      log(e.error.toString());
      labelState = StateEnum.error;
      notifyListeners();
    }
  }

  Future issueLabels(
      {required String slug,
      required String projID,
      required dynamic data,
      CRUD? method,
      String? labelId,
      required WidgetRef ref}) async {
    var workspaceProvider = ref.watch(ProviderList.workspaceProvider);
    var projectProvider = ref.watch(ProviderList.projectProvider);
    labelState = StateEnum.loading;
    notifyListeners();
    String url = method == CRUD.update || method == CRUD.delete
        ? '${APIs.issueLabels.replaceAll("\$SLUG", slug).replaceAll('\$PROJECTID', projID)}$labelId/'
        : APIs.issueLabels
            .replaceAll("\$SLUG", slug)
            .replaceAll('\$PROJECTID', projID);

    try {
      var response = await DioConfig().dioServe(
          hasAuth: true,
          url: url,
          hasBody: true,
          httpMethod: method == CRUD.update
              ? HttpMethod.patch
              : method == CRUD.delete
                  ? HttpMethod.delete
                  : HttpMethod.post,
          data: data);
      //   log(response.data.toString());
      method != CRUD.read
          ? postHogService(
              eventName: method == CRUD.create
                  ? 'ISSUE_LABEL_CREATE'
                  : method == CRUD.update
                      ? 'ISSUE_LABEL_UPDATE'
                      : method == CRUD.delete
                          ? 'ISSUE_LABEL_DELETE'
                          : '',
              properties: method == CRUD.delete
                  ? {}
                  : {
                      'WORKSPACE_ID':
                          workspaceProvider.selectedWorkspace!.workspaceId,
                      'WORKSPACE_SLUG':
                          workspaceProvider.selectedWorkspace!.workspaceSlug,
                      'WORKSPACE_NAME':
                          workspaceProvider.selectedWorkspace!.workspaceName,
                      'PROJECT_ID': projectProvider.projectDetailModel!.id,
                      'PROJECT_NAME': projectProvider.projectDetailModel!.name,
                      'LABEL_ID': response.data['id']
                    },
              ref: ref)
          : null;
      await getLabels(slug: slug, projID: projID);
      labelState = StateEnum.success;
      notifyListeners();
    } on DioException catch (e) {
      log(e.error.toString());
      labelState = StateEnum.error;
      notifyListeners();
    }
  }

  Future getStates({
    required String slug,
    required String projID,
    bool showLoading = true,
  }) async {
    if (showLoading) {
      statesState = StateEnum.loading;
      notifyListeners();
    }
    try {
      var response = await DioConfig().dioServe(
        hasAuth: true,
        url: APIs.states
            .replaceAll("\$SLUG", slug)
            .replaceAll('\$PROJECTID', projID),
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      //   log(response.data.toString());
      statesData = response.data;
      states = {};
      for (int i = 0; i < response.data.length; i++) {
        String state = response.data.keys.elementAt(i);
        for (int j = 0; j < response.data[state].length; j++) {
          states[response.data[state][j]['id']] = response.data[state][j];
          stateIcons[response.data[state][j]['id']] = SvgPicture.asset(
              state == 'backlog'
                  ? 'assets/svg_images/circle.svg'
                  : state == 'cancelled'
                      ? 'assets/svg_images/cancelled.svg'
                      : state == 'completed'
                          ? 'assets/svg_images/done.svg'
                          : state == 'started'
                              ? 'assets/svg_images/in_progress.svg'
                              : 'assets/svg_images/circle.svg',
              height: 22,
              width: 22,
              colorFilter: int.tryParse(
                          "FF${response.data[state][j]['color'].toString().replaceAll('#', '')}",
                          radix: 16) !=
                      null
                  ? ColorFilter.mode(
                      Color(int.parse(
                          "FF${response.data[state][j]['color'].toString().replaceAll('#', '')}",
                          radix: 16)),
                      BlendMode.srcIn)
                  : null);
        }
      }
      stateOrdering = [];
      for (var element in defaultStateGroups) {
        //  log(element);
        for (var element in (statesData[element] as List)) {
          stateOrdering.add(element['id']);
        }
      }
      //  log(states.toString());
      statesState = StateEnum.success;
      notifyListeners();
    } on DioException catch (e) {
      log(e.response!.statusCode.toString());
      if (e.response!.statusCode == 403) {
        statesState = StateEnum.restricted;
        notifyListeners();
      } else {
        statesState = StateEnum.error;
        notifyListeners();
      }
    }
  }

  Future createIssue(
      {required String slug,
      required String projID,
      required Enum issueCategory,
      required WidgetRef ref}) async {
    createIssueState = StateEnum.loading;
    var workspaceProvider = ref.watch(ProviderList.workspaceProvider);
    var projectProvider = ref.watch(ProviderList.projectProvider);
    notifyListeners();
    try {
      var response = await DioConfig().dioServe(
          hasAuth: true,
          url: APIs.projectIssues
              .replaceAll("\$SLUG", slug)
              .replaceAll('\$PROJECTID', projID),
          hasBody: true,
          httpMethod: HttpMethod.post,
          data: {
            "assignees": createIssuedata["members"] == null
                ? []
                : (createIssuedata["members"] as Map).keys.toList(),
            "assignees_list": createIssuedata["members"] == null
                ? []
                : (createIssuedata["members"] as Map).keys.toList(),
            "cycle": null,
            "estimate_point": null,
            "labels": createIssuedata["labels"] == null
                ? []
                : (createIssuedata['labels'] as List)
                    .map((e) => e["id"])
                    .toList(),
            "labels_list": createIssuedata["labels"] == null
                ? []
                : (createIssuedata['labels'] as List)
                    .map((e) => e["id"])
                    .toList(),
            "name": createIssuedata['title'],
            "priority": createIssuedata['priority']['name'] == 'None'
                ? null
                : createIssuedata['priority']['name'].toString().toLowerCase(),
            "project": projID,
            "state": createIssuedata['state'],
            if (createIssuedata['module'] != null)
              "module": createIssuedata['module'],
            if (createIssuedata['cycle'] != null)
              "cycle": createIssuedata['cycle'],
            if (ref!
                    .read(ProviderList.projectProvider)
                    .currentProject['estimate'] !=
                null)
              "estimate_point": createIssuedata['estimate_point'],
            if (createIssuedata['due_date'] != null)
              "target_date":
                  DateFormat('yyyy-MM-dd').format(createIssuedata['due_date']),
            if (createIssuedata['start_date'] != null)
              "start_date": DateFormat('yyyy-MM-dd')
                  .format(createIssuedata['start_date']),
            if (createIssueParentId.isNotEmpty) "parent": createIssueParentId
          });
      postHogService(
          eventName: 'ISSUE_CREATE',
          properties: {
            'WORKSPACE_ID': workspaceProvider.selectedWorkspace!.workspaceId,
            'WORKSPACE_SLUG':
                workspaceProvider.selectedWorkspace!.workspaceSlug,
            'WORKSPACE_NAME':
                workspaceProvider.selectedWorkspace!.workspaceName,
            'PROJECT_ID': projID ?? projectProvider.projectDetailModel!.id,
            'PROJECT_NAME': ref!
                .read(ProviderList.projectProvider)
                .projects
                .firstWhere((element) => element['id'] == projID)['name'],
            'ISSUE_ID': response.data['id']
          },
          ref: ref);
      // issuesResponse.add(response.data);
      if (issueCategory == IssueCategory.moduleIssues) {
        await ref!.read(ProviderList.modulesProvider).createModuleIssues(
          slug: ref!
              .read(ProviderList.workspaceProvider)
              .selectedWorkspace!
              .workspaceSlug,
          projID: ref!.read(ProviderList.projectProvider).currentProject["id"],
          issues: [response.data['id']],
        );

        ref!.read(ProviderList.modulesProvider).filterModuleIssues(
              slug: slug,
              projectId:
                  ref!.read(ProviderList.projectProvider).currentProject["id"],
            );
        filterIssues(
          slug: ref!
              .read(ProviderList.workspaceProvider)
              .selectedWorkspace!
              .workspaceSlug,
          projID: ref!.read(ProviderList.projectProvider).currentProject["id"],
          issueCategory: IssueCategory.moduleIssues,
        );
      }
      if (issueCategory == IssueCategory.cycleIssues) {
        await ref!.read(ProviderList.cyclesProvider).createCycleIssues(
          slug: ref!
              .read(ProviderList.workspaceProvider)
              .selectedWorkspace!
              .workspaceSlug,
          projId: ref!.read(ProviderList.projectProvider).currentProject["id"],
          issues: [response.data['id']],
        );
        ref!.read(ProviderList.cyclesProvider).filterCycleIssues(
              slug: slug,
              projectId:
                  ref!.read(ProviderList.projectProvider).currentProject["id"],
            );
        filterIssues(
          slug: ref!
              .read(ProviderList.workspaceProvider)
              .selectedWorkspace!
              .workspaceSlug,
          projID: projID ??
              ref!.read(ProviderList.projectProvider).currentProject["id"],
          issueCategory: IssueCategory.cycleIssues,
        );
      }
      await ref!.read(ProviderList.myIssuesProvider).filterIssues();
      if (issueCategory == IssueCategory.issues) {
        if (projID ==
            ref!.read(ProviderList.projectProvider).currentProject["id"]) {
          filterIssues(
            slug: slug,
            projID: projID,
          );

          isISsuesEmpty = issuesResponse.isEmpty;
        }
      }

      createIssueState = StateEnum.success;
      notifyListeners();
    } on DioException catch (e) {
      log(e.response.toString());
      createIssueState = StateEnum.error;
      notifyListeners();
    }
  }

  Future getIssues({required String slug, required String projID}) async {
    // issueState = StateEnum.loading;
    try {
      var response = await DioConfig().dioServe(
        hasAuth: true,
        url: APIs.projectIssues
            .replaceAll("\$SLUG", slug)
            .replaceAll('\$PROJECTID', projID),
        hasBody: false,
        httpMethod: HttpMethod.get,
      );

      log("DONE");
      issuesResponse = response.data;
      issuesList = response.data;
      isISsuesEmpty = issuesResponse.isEmpty;
      issueState = StateEnum.success;
      notifyListeners();
    } on DioException catch (e) {
      log(e.response.toString());
      if (e.response!.statusCode == 403) {
        issueState = StateEnum.restricted;
        notifyListeners();
      } else {
        issueState = StateEnum.error;
        notifyListeners();
      }
    }
  }

  Future createState(
      {required String slug,
      required String projID,
      required dynamic data}) async {
    statesState = StateEnum.loading;
    notifyListeners();
    try {
      await DioConfig().dioServe(
          hasAuth: true,
          url: APIs.states
              .replaceAll("\$SLUG", slug)
              .replaceAll('\$PROJECTID', projID),
          hasBody: true,
          httpMethod: HttpMethod.post,
          data: data);
      getStates(slug: slug, projID: projID);
      statesState = StateEnum.success;
      notifyListeners();
    } on DioException catch (e) {
      log(e.response.toString());
      statesState = StateEnum.error;
      notifyListeners();
    }
  }

  Future getProjectMembers({
    required String slug,
    required String projID,
  }) async {
    membersState = StateEnum.loading;
    //notifyListeners();
    try {
      var response = await DioConfig().dioServe(
        hasAuth: true,
        url: APIs.projectMembers
            .replaceAll("\$SLUG", slug)
            .replaceAll('\$PROJECTID', projID),
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      // log('Project Members    ${response.data.toString()}');
      members = response.data;
      for (var element in members) {
        if (element["member"]['id'] ==
            ref!.read(ProviderList.profileProvider).userProfile.id) {
          ref!.read(ProviderList.projectProvider).role =
              roleParser(role: element["role"]);
          log('Role ${ref!.read(ProviderList.projectProvider).role}');
          break;
        }
      }
      membersState = StateEnum.success;
      notifyListeners();
    } on DioException catch (e) {
      log('Error in getProjectMembers ');
      log(e.response.toString());
      membersState = StateEnum.error;
      notifyListeners();
    }
  }

  Future getIssueProperties({required Enum issueCategory}) async {
    var cyclesProvider = ref!.read(ProviderList.cyclesProvider);
    var modulesProvider = ref!.read(ProviderList.modulesProvider);
    issueState = StateEnum.loading;
    log(APIs.issueProperties
        .replaceAll(
            "\$SLUG",
            ref!
                .read(ProviderList.workspaceProvider)
                .selectedWorkspace!
                .workspaceSlug)
        .replaceAll('\$PROJECTID',
            ref!.read(ProviderList.projectProvider).currentProject['id']));
    try {
      var response = await DioConfig().dioServe(
        hasAuth: true,
        url: APIs.issueProperties
            .replaceAll(
                "\$SLUG",
                ref!
                    .read(ProviderList.workspaceProvider)
                    .selectedWorkspace!
                    .workspaceSlug)
            .replaceAll('\$PROJECTID',
                ref!.read(ProviderList.projectProvider).currentProject['id']),
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      // log('Issue Properties    ${response.data.toString()}');
      if (response.data.isEmpty) {
        response = await DioConfig().dioServe(
            hasAuth: true,
            url: APIs.issueProperties
                .replaceAll(
                    "\$SLUG",
                    ref!
                        .read(ProviderList.workspaceProvider)
                        .selectedWorkspace!
                        .workspaceSlug)
                .replaceAll(
                    '\$PROJECTID',
                    ref!
                        .read(ProviderList.projectProvider)
                        .currentProject['id']),
            hasBody: true,
            httpMethod: HttpMethod.post,
            data: {
              "properties": {
                "assignee": true,
                "attachment_count": true,
                "due_date": true,
                "estimate": true,
                "key": true,
                "labels": true,
                "link": true,
                "priority": true,
                "state": true,
                "sub_issue_count": false,
                "start_date": false,
              },
            });
        if (issueCategory == IssueCategory.cycleIssues) {
          cyclesProvider.issueProperty = response.data;
        } else if (issueCategory == IssueCategory.moduleIssues) {
          modulesProvider.issueProperty = response.data;
        } else {
          issueProperty = response.data;
          issues.displayProperties.assignee =
              issueProperty['properties']['assignee'];
          issues.displayProperties.dueDate =
              issueProperty['properties']['due_date'];
          issues.displayProperties.id = issueProperty['properties']['key'];
          issues.displayProperties.label =
              issueProperty['properties']['labels'];
          issues.displayProperties.state = issueProperty['properties']['state'];
          issues.displayProperties.subIsseCount =
              issueProperty['properties']['sub_issue_count'];
          issues.displayProperties.linkCount =
              issueProperty['properties']['link'];
          issues.displayProperties.attachmentCount =
              issueProperty['properties']['attachment_count'];
          issues.displayProperties.priority =
              issueProperty['properties']['priority'];
          issues.displayProperties.estimate =
              issueProperty['properties']['estimate'];
        }
      } else {
        if (issueCategory == IssueCategory.cycleIssues) {
          cyclesProvider.issueProperty = response.data;
          issues.displayProperties.assignee =
              cyclesProvider.issueProperty['properties']['assignee'];
          cyclesProvider.issues.displayProperties.dueDate =
              cyclesProvider.issueProperty['properties']['due_date'];
          cyclesProvider.issues.displayProperties.id =
              cyclesProvider.issueProperty['properties']['key'];
          issues.displayProperties.label =
              issueProperty['properties']['labels'];
          cyclesProvider.issues.displayProperties.state =
              cyclesProvider.issueProperty['properties']['state'];
          cyclesProvider.issues.displayProperties.subIsseCount =
              cyclesProvider.issueProperty['properties']['sub_issue_count'];
          cyclesProvider.issues.displayProperties.linkCount =
              cyclesProvider.issueProperty['properties']['link'];
          cyclesProvider.issues.displayProperties.attachmentCount =
              cyclesProvider.issueProperty['properties']['attachment_count'];
          cyclesProvider.issues.displayProperties.priority =
              cyclesProvider.issueProperty['properties']['priority'];
          cyclesProvider.issues.displayProperties.estimate =
              cyclesProvider.issueProperty['properties']['estimate'];
          cyclesProvider.issues.displayProperties.startDate =
              cyclesProvider.issueProperty['properties']['start_date'];
          ref!.read(ProviderList.cyclesProvider).issues.displayProperties =
              cyclesProvider.issues.displayProperties;
        } else if (issueCategory == IssueCategory.moduleIssues) {
          modulesProvider.issueProperty = response.data;
          issues.displayProperties.assignee =
              modulesProvider.issueProperty['properties']['assignee'];
          modulesProvider.issues.displayProperties.dueDate =
              modulesProvider.issueProperty['properties']['due_date'];
          modulesProvider.issues.displayProperties.id =
              modulesProvider.issueProperty['properties']['key'];
          issues.displayProperties.label =
              issueProperty['properties']['labels'];
          modulesProvider.issues.displayProperties.state =
              modulesProvider.issueProperty['properties']['state'];
          modulesProvider.issues.displayProperties.subIsseCount =
              modulesProvider.issueProperty['properties']['sub_issue_count'];
          modulesProvider.issues.displayProperties.linkCount =
              modulesProvider.issueProperty['properties']['link'];
          modulesProvider.issues.displayProperties.attachmentCount =
              modulesProvider.issueProperty['properties']['attachment_count'];
          modulesProvider.issues.displayProperties.priority =
              modulesProvider.issueProperty['properties']['priority'];
          modulesProvider.issues.displayProperties.estimate =
              modulesProvider.issueProperty['properties']['estimate'];
          modulesProvider.issues.displayProperties.startDate =
              modulesProvider.issueProperty['properties']['start_date'];
          ref!.read(ProviderList.modulesProvider).issues.displayProperties =
              modulesProvider.issues.displayProperties;
        } else {
          issueProperty = response.data;
          log('issueProperty ${issueProperty.toString()}');
          issues.displayProperties.assignee =
              issueProperty['properties']['assignee'];
          issues.displayProperties.dueDate =
              issueProperty['properties']['due_date'];
          issues.displayProperties.id = issueProperty['properties']['key'];
          issues.displayProperties.label =
              issueProperty['properties']['labels'];
          issues.displayProperties.state = issueProperty['properties']['state'];
          issues.displayProperties.subIsseCount =
              issueProperty['properties']['sub_issue_count'];
          issues.displayProperties.linkCount =
              issueProperty['properties']['link'];
          issues.displayProperties.attachmentCount =
              issueProperty['properties']['attachment_count'];
          issues.displayProperties.priority =
              issueProperty['properties']['priority'];
          issues.displayProperties.estimate =
              issueProperty['properties']['estimate'];
          issues.displayProperties.startDate =
              issueProperty['properties']['start_date'] ?? false;

          // ref!.read(ProviderList.cyclesProvider).issues.displayProperties = issues.displayProperties;
        }
        //log('ISSUE PROPERTY =====  > $issueProperty');
      }

      issueState = StateEnum.success;
      notifyListeners();
    } on DioException catch (e) {
      log(e.message.toString());
      issueState = StateEnum.error;
      notifyListeners();
    }
  }

  Future updateIssueProperties({
    required DisplayProperties properties,
    required Enum issueCategory,
  }) async {
    var cyclesProvider = ref!.read(ProviderList.cyclesProvider);
    var modulesProvider = ref!.read(ProviderList.modulesProvider);
    issuePropertyState = StateEnum.loading;
    notifyListeners();
    log(issueProperty.toString());
    try {
      var response = await DioConfig().dioServe(
        hasAuth: true,
        url:
            ("${APIs.issueProperties}${issueCategory == IssueCategory.cycleIssues ? cyclesProvider.issueProperty['id'] : issueCategory == IssueCategory.moduleIssues ? modulesProvider.issueProperty['id'] : issueProperty['id']}/")
                .replaceAll(
                    "\$SLUG",
                    ref!
                        .read(ProviderList.workspaceProvider)
                        .selectedWorkspace!
                        .workspaceSlug)
                .replaceAll(
                    '\$PROJECTID',
                    ref!
                        .read(ProviderList.projectProvider)
                        .currentProject['id']),
        hasBody: true,
        data: {
          "properties": {
            "assignee": properties.assignee,
            "attachment_count": properties.attachmentCount,
            "due_date": properties.dueDate,
            "estimate": properties.estimate,
            "key": properties.id,
            "labels": properties.label,
            "link": properties.linkCount,
            "priority": properties.priority,
            "state": properties.state,
            "sub_issue_count": properties.subIsseCount,
            'updated_on': properties.updatedOn,
            'created_on': properties.createdOn,
            'start_date': properties.startDate,
          },
          "user": ref!.read(ProviderList.profileProvider).userProfile.id
        },
        httpMethod: HttpMethod.patch,
      );

      // log(response.data.toString());
      if (issueCategory == IssueCategory.cycleIssues) {
        cyclesProvider.issueProperty = response.data;
        log('cycle issue property ${cyclesProvider.issueProperty.toString()}');
      } else if (issueCategory == IssueCategory.moduleIssues) {
        modulesProvider.issueProperty = response.data;
      } else {
        issueProperty = response.data;
      }
      issuePropertyState = StateEnum.success;
      notifyListeners();
    } on DioException catch (e) {
      log(e.response.toString());
      issuePropertyState = StateEnum.error;
      notifyListeners();
    }
  }

  Future updateProjectView() async {
    log(tempProjectView.toString());
    dynamic filterPriority;
    if (issues.filters.priorities.isNotEmpty) {
      filterPriority = issues.filters.priorities
          .map((element) => element == 'none' ? null : element)
          .toList();
    }
    try {
      var response = await DioConfig().dioServe(
        hasAuth: true,
        url: APIs.projectViews
            .replaceAll(
                "\$SLUG",
                ref!
                    .read(ProviderList.workspaceProvider)
                    .selectedWorkspace!
                    .workspaceSlug)
            .replaceAll('\$PROJECTID',
                ref!.read(ProviderList.projectProvider).currentProject['id']),
        hasBody: true,
        data: {
          "view_props": {
            "calendarDateRange": "",
            "collapsed": false,
            "filterIssue": null,
            "filters": {
              'type': null,
              "priority": filterPriority,
              if (issues.filters.states.isNotEmpty)
                "state": issues.filters.states,
              if (issues.filters.assignees.isNotEmpty)
                "assignees": issues.filters.assignees,
              if (issues.filters.createdBy.isNotEmpty)
                "created_by": issues.filters.createdBy,
              if (issues.filters.labels.isNotEmpty)
                "labels": issues.filters.labels,
              if (issues.filters.targetDate.isNotEmpty)
                "target_date": issues.filters.targetDate,
              if (issues.filters.startDate.isNotEmpty)
                "start_date": issues.filters.startDate,
            },
            "type": null,
            "groupByProperty": Issues.fromGroupBY(issues.groupBY),
            'issueView': issues.projectView == ProjectView.kanban
                ? 'kanban'
                : issues.projectView == ProjectView.list
                    ? 'list'
                    : issues.projectView == ProjectView.calendar
                        ? 'calendar'
                        : 'spreadsheet',
            "orderBy": Issues.fromOrderBY(issues.orderBY),
            "showEmptyGroups": showEmptyStates
          }
        },
        httpMethod: HttpMethod.post,
      );
      log('project view => ${response.data}');
      projectViewState = StateEnum.success;
      notifyListeners();
    } on DioException catch (e) {
      log("ERROR");
      log(e.response.toString());
      projectViewState = StateEnum.error;
      notifyListeners();
    }
  }

  Future getProjectView() async {
    projectViewState = StateEnum.loading;
    try {
      var response = await DioConfig().dioServe(
        hasAuth: true,
        url: APIs.userIssueView
            .replaceAll(
                "\$SLUG",
                ref!
                    .read(ProviderList.workspaceProvider)
                    .selectedWorkspace!
                    .workspaceSlug)
            .replaceAll('\$PROJECTID',
                ref!.read(ProviderList.projectProvider).currentProject['id']),
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      issueView = response.data["view_props"];
      log("project view=>${response.data["view_props"]}");
      issues.projectView = issueView["issueView"] == 'list'
          ? ProjectView.list
          : issueView['issueView'] == 'calendar'
              ? ProjectView.calendar
              : issueView['issueView'] == 'spreadsheet'
                  ? ProjectView.spreadsheet
                  : ProjectView.kanban;
      issues.groupBY = Issues.toGroupBY(issueView["groupByProperty"]);
      issues.orderBY = Issues.toOrderBY(issueView["orderBy"]);
      issues.issueType = Issues.toIssueType(issueView["filters"]["type"]);
      issues.filters.priorities = issueView["filters"]["priority"] ?? [];
      issues.filters.states = issueView["filters"]["state"] ?? [];
      issues.filters.assignees = issueView["filters"]["assignees"] ?? [];
      issues.filters.createdBy = issueView["filters"]["created_by"] ?? [];
      issues.filters.labels = issueView["filters"]["labels"] ?? [];
      issues.filters.targetDate = issueView["filters"]["target_date"] ?? [];
      issues.filters.startDate = issueView["filters"]["start_date"] ?? [];
      showEmptyStates = issueView["showEmptyGroups"];

      projectViewState = StateEnum.success;
      notifyListeners();
    } on DioException catch (e) {
      log(e.response.toString());
      issues.projectView = ProjectView.kanban;
      projectViewState = StateEnum.error;
      notifyListeners();
    }
  }

  Future filterIssues({
    required String slug,
    required String projID,
    // String? cycleId,
    // String? moduleId,
    Enum issueCategory = IssueCategory.issues,
  }) async {
    var cyclesProvider = ref!.read(ProviderList.cyclesProvider);
    var modulesProvider = ref!.read(ProviderList.modulesProvider);
    if (issueCategory == IssueCategory.issues) {
      orderByState = StateEnum.loading;
      notifyListeners();
    }

    // if(cycleIssues){
    //   issues.groupBY = cyclesProvider.issues.groupBY;
    //   issues.orderBY = cyclesProvider.issues.orderBY;
    //   issues.issueType = cyclesProvider.issues.issueType;
    // }
    // else {
    cyclesProvider.issues.groupBY = issues.groupBY;
    log('CycleProvider GroupBy ${cyclesProvider.issues.groupBY}');
    cyclesProvider.issues.orderBY = issues.orderBY;
    cyclesProvider.issues.issueType = issues.issueType;

    modulesProvider.issues.groupBY = issues.groupBY;
    modulesProvider.issues.orderBY = issues.orderBY;
    modulesProvider.issues.issueType = issues.issueType;
    // }
    if (issues.groupBY == GroupBY.labels) {
      getLabels(slug: slug, projID: projID);
    } else if (issues.groupBY == GroupBY.createdBY) {
      getProjectMembers(slug: slug, projID: projID);
    } else if (issues.groupBY == GroupBY.state) {
      log('Getting States from filterIssues=======================================');
      getStates(
        slug: slug,
        projID: projID,
        showLoading: false,
      );
    }

    String url;
    // log(issues.issueType.toString());
    if (issueCategory == IssueCategory.issues) {
      log('Updating temp GroupBy');
      tempGroupBy = issues.groupBY;
      tempFilters = issues.filters;
      tempOrderBy = issues.orderBY;
      tempIssueType = issues.issueType;
      tempProjectView = issues.projectView;
    }
    if (issues.issueType != IssueType.all) {
      url = (issueCategory == IssueCategory.cycleIssues
              ? APIs.orderByGroupByCycleIssues
              : issueCategory == IssueCategory.moduleIssues
                  ? APIs.orderByGroupByModuleIssues
                  : APIs.orderByGroupByTypeIssues)
          .replaceAll("\$SLUG", slug)
          .replaceAll('\$PROJECTID', projID)
          .replaceAll('\$CYCLEID', cyclesProvider.currentCycle['id'] ?? '')
          .replaceAll('\$MODULEID', modulesProvider.currentModule['id'] ?? '')
          .replaceAll('\$ORDERBY', Issues.fromOrderBY(issues.orderBY))
          .replaceAll('\$GROUPBY', Issues.fromGroupBY(issues.groupBY))
          .replaceAll('\$TYPE', Issues.fromIssueType(issues.issueType));
      if (issues.filters.priorities.isNotEmpty) {
        url =
            '$url&priority=${issues.filters.priorities.toString().replaceAll('[', '').replaceAll(']', '').replaceAll(' ', '')}';
      }
      if (issues.filters.states.isNotEmpty) {
        url =
            '$url&state=${issues.filters.states.toString().replaceAll('[', '').replaceAll(']', '').replaceAll(' ', '')}';
        //  print(url);
      }
      if (issues.filters.assignees.isNotEmpty) {
        url =
            '$url&assignees=${issues.filters.assignees.toString().replaceAll('[', '').replaceAll(']', '').replaceAll(' ', '')}';
        //   print(url);
      }
      if (issues.filters.createdBy.isNotEmpty) {
        url =
            '$url&created_by=${issues.filters.createdBy.toString().replaceAll('[', '').replaceAll(']', '').replaceAll(' ', '')}';
      }
      if (issues.filters.labels.isNotEmpty) {
        url =
            '$url&labels=${issues.filters.labels.toString().replaceAll('[', '').replaceAll(']', '').replaceAll(' ', '')}';
        // print(url);
      }
      if (issues.filters.targetDate.isNotEmpty) {
        url =
            '$url&target_date=${issues.filters.targetDate.toString().replaceAll('[', '').replaceAll(']', '').replaceAll(' ', '')}';
      }
      if (issues.filters.startDate.isNotEmpty) {
        url =
            '$url&start_date=${issues.filters.startDate.toString().replaceAll('[', '').replaceAll(']', '').replaceAll(' ', '')}';
      } else {
        url = url;
      }
    } else {
      url = (issueCategory == IssueCategory.cycleIssues
              ? APIs.orderByGroupByCycleIssues
              : issueCategory == IssueCategory.moduleIssues
                  ? APIs.orderByGroupByModuleIssues
                  : APIs.orderByGroupByTypeIssues)
          .replaceAll("\$SLUG", slug)
          .replaceAll('\$PROJECTID', projID)
          .replaceAll('\$CYCLEID', cyclesProvider.currentCycle['id'] ?? '')
          .replaceAll('\$MODULEID', modulesProvider.currentModule['id'] ?? '')
          .replaceAll('\$ORDERBY', Issues.fromOrderBY(issues.orderBY))
          .replaceAll('\$GROUPBY', Issues.fromGroupBY(issues.groupBY))
          .replaceAll('\$TYPE', Issues.fromIssueType(issues.issueType));
      if (issues.filters.priorities.isNotEmpty) {
        url =
            '$url&priority=${issues.filters.priorities.toString().replaceAll('[', '').replaceAll(']', '').replaceAll(' ', '')}';
      }
      if (issues.filters.states.isNotEmpty) {
        url =
            '$url&state=${issues.filters.states.toString().replaceAll('[', '').replaceAll(']', '').replaceAll(' ', '')}';
      }
      if (issues.filters.assignees.isNotEmpty) {
        url =
            '$url&assignees=${issues.filters.assignees.toString().replaceAll('[', '').replaceAll(']', '').replaceAll(' ', '')}';
      }
      if (issues.filters.createdBy.isNotEmpty) {
        url =
            '$url&created_by=${issues.filters.createdBy.toString().replaceAll('[', '').replaceAll(']', '').replaceAll(' ', '')}';
      }
      if (issues.filters.labels.isNotEmpty) {
        url =
            '$url&labels=${issues.filters.labels.toString().replaceAll('[', '').replaceAll(']', '').replaceAll(' ', '')}';
      }
      if (issues.filters.targetDate.isNotEmpty) {
        url =
            '$url&target_date=${issues.filters.targetDate.toString().replaceAll('[', '').replaceAll(']', '').replaceAll(' ', '')}';
      }
      if (issues.filters.startDate.isNotEmpty) {
        url =
            '$url&start_date=${issues.filters.startDate.toString().replaceAll('[', '').replaceAll(']', '').replaceAll(' ', '')}';
      } else {
        url = url;
      }
    }
    dynamic temp;
    log('URL: $url');
    try {
      //  log('====CAME TO CYCLES TRY');
      var response = await DioConfig().dioServe(
        hasAuth: true,
        url: url,
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      if (issueCategory == IssueCategory.cycleIssues) {
        // log('Cycle Issues :::: ${response.data}');
        issuesList = [];
        temp = response.data;
        for (var key in response.data.keys) {
          issuesList.addAll(response.data[key]);
        }
      } else if (issueCategory == IssueCategory.moduleIssues) {
        // log('Module Issues :::: ${response.data}');
        temp = response.data;
        issuesList = [];
        for (var key in response.data.keys) {
          issuesList.addAll(response.data[key]);
        }
      }

      if (issueCategory == IssueCategory.issues) {
        // log('Issues :::: ${response.data}');

        issuesResponse = [];
        isISsuesEmpty = true;
        shrinkStates = [];
        issuesList = [];
        for (var key in response.data.keys) {
          //  log("KEY=$key");
          if (response.data[key].isNotEmpty) {
            isISsuesEmpty = false;
          }

          issuesList.addAll(response.data[key]);
        }
      }

      //log("shrink states=${shrinkStates.toString()}");
      if (issueCategory == IssueCategory.issues) {
        if (issues.groupBY == GroupBY.state) {
          groupByResponse = {};

          if (issues.filters.states.isNotEmpty) {
            for (var element in issues.filters.states) {
              if (response.data[element] == null) {
                groupByResponse[element] = [];
              } else {
                groupByResponse[element] = response.data[element];
              }
            }
          } else {
            for (var element in stateOrdering) {
              groupByResponse[element] = response.data[element] ?? [];
            }
          }
          shrinkStates = List.generate(stateOrdering.length, (index) => false);
        } else {
          stateOrdering = [];
          response.data.forEach((key, value) {
            stateOrdering.add(key);
          });
          groupByResponse = response.data;
          shrinkStates = List.generate(stateOrdering.length, (index) => false);
        }
      }

      if (issueCategory == IssueCategory.cycleIssues ||
          issueCategory == IssueCategory.moduleIssues) {
        log(stateOrdering.toString());
        cyclesProvider.stateOrdering = stateOrdering;
        modulesProvider.stateOrdering = stateOrdering;
        return temp;
      }
      orderByState = StateEnum.success;
      notifyListeners();
    } on DioException catch (e) {
      log('filter issue error');
      log(e.message.toString());
      orderByState = StateEnum.error;
      notifyListeners();
    }
  }

  Future joinProject(
      {String? projectId, String? slug, required WidgetRef refs}) async {
    try {
      joinprojectState = StateEnum.loading;
      notifyListeners();
      await DioConfig().dioServe(
          hasAuth: true,
          url: APIs.joinProject.replaceAll("\$SLUG", slug!),
          hasBody: true,
          httpMethod: HttpMethod.post,
          data: {
            "project_ids": [projectId]
          });
      joinprojectState = StateEnum.success;
      // updating local projects List
      ref!.read(ProviderList.projectProvider).projects[ref!
          .read(ProviderList.projectProvider)
          .currentProject["index"]]["is_member"] = true;
      ref!.read(ProviderList.projectProvider).initializeProject(ref: refs);
      notifyListeners();
    } on DioException catch (e) {
      log(e.message.toString());
      joinprojectState = StateEnum.error;
      notifyListeners();
    }
  }
}
