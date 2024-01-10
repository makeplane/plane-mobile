import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:plane/config/const.dart';
import 'package:plane/kanban/models/inputs.dart';
import 'package:plane/models/issues.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/screens/MainScreens/Projects/ProjectDetail/IssuesTab/CreateIssue/create_issue.dart';
import 'package:plane/utils/constants.dart';
import 'package:plane/utils/global_functions.dart';
import 'package:plane/utils/custom_toast.dart';
import 'package:plane/utils/issues_filter/issue_filter.helper.dart';
import 'package:plane/widgets/custom_text.dart';
import 'package:plane/widgets/issue_card_widget.dart';
import 'package:plane/config/apis.dart';
import 'package:plane/services/dio_service.dart';
import 'package:plane/utils/enums.dart';

import '../screens/MainScreens/Projects/ProjectDetail/IssuesTab/issue_detail.dart';

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
  StateEnum createIssueState = StateEnum.empty;
  String createIssueParent = '';
  String createIssueParentId = '';
  Map issueView = {};
  bool showEmptyStates = true;
  bool isISsuesEmpty = true;
  Issues issues = Issues.initialize();
  GroupBY tempGroupBy = GroupBY.state;
  Filters tempFilters = Filters(
    assignees: [],
    createdBy: [],
    labels: [],
    priorities: [],
    states: [],
    targetDate: [],
    startDate: [],
    stateGroup: [],
    subscriber: [],
  );
  IssueType tempIssueType = IssueType.all;
  ProjectView tempProjectView = ProjectView.kanban;
  OrderBY tempOrderBy = OrderBY.lastCreated;
  Map stateIcons = {};
  Map issueProperty = {};
  Map createIssuedata = {};
  Map createIssueProjectData = {};
  List issuesResponse = [];
  List issuesList = [];
  List labels = [];
  Map states = {};
  Map statesData = {};
  List members = [];
  Map projectView = {};
  Map groupByResponse = {};
  List shrinkStates = [];
  List blockingIssues = [];
  List blockedByIssues = [];
  List selectedLabels = [];
  List blockingIssuesIds = [];
  List blockedByIssuesIds = [];
  List subIssuesIds = [];
  Map defaultStatedetails = {
    'backlog': {
      'name': 'Backlog',
      'icon': SvgPicture.asset(
        'assets/svg_images/circle.svg',
        height: 22,
        width: 22,
        colorFilter: ColorFilter.mode(
            Color(int.parse("FF${"#A3A3A3".replaceAll('#', '')}", radix: 16)),
            BlendMode.srcIn),
      )
    },
    'unstarted': {
      'name': 'Unstarted',
      'icon': SvgPicture.asset(
        'assets/svg_images/unstarted.svg',
        height: 22,
        width: 22,
        colorFilter: ColorFilter.mode(
            Color(int.parse("FF${"#3A3A3A".replaceAll('#', '')}", radix: 16)),
            BlendMode.srcIn),
      )
    },
    'started': {
      'name': 'Started',
      'icon': SvgPicture.asset(
        'assets/svg_images/in_progress.svg',
        height: 22,
        width: 22,
        colorFilter: ColorFilter.mode(
            Color(int.parse("FF${"#F59E0B".replaceAll('#', '')}", radix: 16)),
            BlendMode.srcIn),
      )
    },
    'completed': {
      'name': 'Completed',
      'icon': SvgPicture.asset(
        'assets/svg_images/done.svg',
        height: 22,
        width: 22,
        colorFilter: ColorFilter.mode(
            Color(int.parse("FF${"#16A34A".replaceAll('#', '')}", radix: 16)),
            BlendMode.srcIn),
      )
    },
    'cancelled': {
      'name': 'Cancelled',
      'icon': SvgPicture.asset(
        'assets/svg_images/cancelled.svg',
        height: 22,
        width: 22,
        colorFilter: ColorFilter.mode(
            Color(int.parse("FF${"#DC2626".replaceAll('#', '')}", radix: 16)),
            BlendMode.srcIn),
      )
    },
  };
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
        showSubIssues: true,
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

  bool isFiltersEmpty() {
    return issues.filters.assignees.isEmpty &&
        issues.filters.createdBy.isEmpty &&
        issues.filters.labels.isEmpty &&
        issues.filters.priorities.isEmpty &&
        issues.filters.states.isEmpty &&
        issues.filters.targetDate.isEmpty &&
        issues.filters.startDate.isEmpty &&
        issues.filters.stateGroup.isEmpty &&
        issues.filters.subscriber.isEmpty;
  }

  List<BoardListsData> initializeBoard(
      {bool views = false, bool isArchive = false}) {
    final themeProvider = ref!.read(ProviderList.themeProvider);
    int count = 0;
    issuesResponse = [];
    issues.issues = [];
    for (int j = 0; j < groupByResponse.length; j++) {
      final List<Widget> items = [];
      final groupedIssues = groupByResponse.values.elementAt(j);
      final groupID = groupByResponse.keys.elementAt(j);
      for (int i = 0; i < groupedIssues.length; i++) {
        issuesResponse.add(groupedIssues[i]);

        items.add(
          IssueCardWidget(
            from: views ? PreviousScreen.views : PreviousScreen.projectDetail,
            isArchive: isArchive,
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
        if (groupID == labels[i]['id']) {
          label = labels[i];
          labelFound = true;
          break;
        }
      }

      for (int i = 0; i < members.length; i++) {
        if (groupID == members[i]['member']['id']) {
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

      if (!userFound) {
        userFound = true;
        userName = 'None';
      }

      String title = issues.groupBY == GroupBY.priority
          ? groupID
          : issues.groupBY == GroupBY.state
              ? states[groupID]['name']
              : groupID;
      issues.issues.add(BoardListsData(
        id: groupID,
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
                      ? defaultStatedetails[element.id]['icon']
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
                maxLines: 1,
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
    final projProv = ref!.read(ProviderList.projectProvider);

    return (issues.groupBY == GroupBY.state ||
            issues.groupBY == GroupBY.priority) &&
        (projProv.role == Role.admin || projProv.role == Role.member);
  }

  Future reorderIssue({
    required BuildContext context,
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
      (groupByResponse[stateOrdering[newListIndex]] as List).insert(
          newCardIndex,
          groupByResponse[stateOrdering[oldListIndex]].removeAt(oldCardIndex));
      updateIssueState = StateEnum.loading;
      notifyListeners();
      final issue = groupByResponse[stateOrdering[newListIndex]][newCardIndex];
      final response = await DioConfig().dioServe(
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
      groupByResponse[stateOrdering[newListIndex]][newCardIndex] =
          response.data;

      final List labelDetails = [];

      groupByResponse[stateOrdering[newListIndex]][newCardIndex]['labels']
          .forEach((element) {
        for (int i = 0; i < labels.length; i++) {
          if (labels[i]['id'] == element) {
            labelDetails.add(labels[i]);
            break;
          }
        }

        // labelDetails.add(labels.firstWhere((e) => e['id'] == element));
      });

      groupByResponse[stateOrdering[newListIndex]][newCardIndex]
          ['label_details'] = labelDetails;
      updateIssueState = StateEnum.success;
      if (issues.groupBY == GroupBY.priority) {
        groupByResponse[stateOrdering[newListIndex]][newCardIndex]['priority'] =
            stateOrdering[newListIndex];
      }
      if (issues.orderBY != OrderBY.manual) {
        (groupByResponse[stateOrdering[newListIndex]] as List).sort((a, b) {
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
      // ignore: unused_catch_clause
    } on DioException catch (err) {
      (groupByResponse[stateOrdering[oldListIndex]] as List).insert(
          oldCardIndex,
          groupByResponse[stateOrdering[newListIndex]].removeAt(newCardIndex));

      // ignore: use_build_context_synchronously
      CustomToast.showToast(context,
          message: 'Failed to update issue', toastType: ToastType.failure);
      updateIssueState = StateEnum.error;
      notifyListeners();
      rethrow;
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
      final response = await DioConfig().dioServe(
        hasAuth: true,
        // url: APIs.issueLabels
        //     .replaceAll("\$SLUG", slug)
        //     .replaceAll('\$PROJECTID', projID),
        url:
            '${APIs.baseApi}/api/workspaces/$slug/projects/$projID/issue-labels/',
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      labels = response.data;
      labelState = StateEnum.success;

      notifyListeners();
    } on DioException catch (e) {
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
    final workspaceProvider = ref.read(ProviderList.workspaceProvider);
    final projectProvider = ref.read(ProviderList.projectProvider);
    labelState = StateEnum.loading;
    notifyListeners();
    final String url = method == CRUD.update || method == CRUD.delete
        ? '${APIs.issueLabels.replaceAll("\$SLUG", slug).replaceAll('\$PROJECTID', projID)}$labelId/'
        : APIs.issueLabels
            .replaceAll("\$SLUG", slug)
            .replaceAll('\$PROJECTID', projID);

    try {
      final response = await DioConfig().dioServe(
          hasAuth: true,
          url: url,
          hasBody: true,
          httpMethod: method == CRUD.update
              ? HttpMethod.patch
              : method == CRUD.delete
                  ? HttpMethod.delete
                  : HttpMethod.post,
          data: data);
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
                          workspaceProvider.selectedWorkspace.workspaceId,
                      'WORKSPACE_SLUG':
                          workspaceProvider.selectedWorkspace.workspaceSlug,
                      'WORKSPACE_NAME':
                          workspaceProvider.selectedWorkspace.workspaceName,
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
      final response = await DioConfig().dioServe(
        hasAuth: true,
        url: APIs.states
            .replaceAll("\$SLUG", slug)
            .replaceAll('\$PROJECTID', projID),
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      //   log(response.data.toString());
      statesData = {for (final value in response.data) value['id']: value};
      states = {};
      for (int i = 0; i < statesData.length; i++) {
        final String stateId = statesData.keys.elementAt(i);
        states[stateId] = statesData[stateId];
        stateIcons[stateId] = SvgPicture.asset(
            stateId == 'backlog'
                ? 'assets/svg_images/circle.svg'
                : stateId == 'cancelled'
                    ? 'assets/svg_images/cancelled.svg'
                    : stateId == 'completed'
                        ? 'assets/svg_images/done.svg'
                        : stateId == 'started'
                            ? 'assets/svg_images/in_progress.svg'
                            : 'assets/svg_images/unstarted.svg',
            height: 22,
            width: 22,
            colorFilter: int.tryParse(
                        "FF${statesData[stateId]['color'].toString().replaceAll('#', '')}",
                        radix: 16) !=
                    null
                ? ColorFilter.mode(
                    Color(int.parse(
                        "FF${statesData[stateId]['color'].toString().replaceAll('#', '')}",
                        radix: 16)),
                    BlendMode.srcIn)
                : null);

        if (statesData[stateId]['default'] == true) {
          defaultStatedetails[stateId] = {
            'name': statesData[stateId]['name'],
            'icon': stateIcons[statesData[stateId]['id']]
          };
        }
      }
      stateOrdering = [];
      for (final element in defaultStateGroups) {
        if (statesData[element] != null) {
          for (final element in (statesData[element] as List)) {
            stateOrdering.add(element['id']);
          }
        }
      }
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
    final workspaceProvider = ref.read(ProviderList.workspaceProvider);
    notifyListeners();
    try {
      final response = await DioConfig().dioServe(
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
            "description_html": createIssuedata['description_html'] ?? '',
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
            "priority":
                createIssuedata['priority']['name'].toString().toLowerCase(),
            "project": projID,
            "state": createIssuedata['state'],
            if (createIssuedata['module'] != null)
              "module": createIssuedata['module'],
            if (createIssuedata['cycle'] != null)
              "cycle": createIssuedata['cycle'],
            if (ref
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
            'WORKSPACE_ID': workspaceProvider.selectedWorkspace.workspaceId,
            'WORKSPACE_SLUG': workspaceProvider.selectedWorkspace.workspaceSlug,
            'WORKSPACE_NAME': workspaceProvider.selectedWorkspace.workspaceName,
            'PROJECT_ID': projID,
            'PROJECT_NAME': ref
                .read(ProviderList.projectProvider)
                .projects
                .firstWhere((element) => element['id'] == projID)['name'],
            'ISSUE_ID': response.data['id']
          },
          ref: ref);
      // issuesResponse.add(response.data);
      if (issueCategory == IssueCategory.moduleIssues) {
        await ref.read(ProviderList.modulesProvider).createModuleIssues(
          slug: ref
              .read(ProviderList.workspaceProvider)
              .selectedWorkspace
              .workspaceSlug,
          projID: ref.read(ProviderList.projectProvider).currentProject["id"],
          issues: [response.data['id']],
        );

        ref.read(ProviderList.modulesProvider).filterModuleIssues(
              slug: slug,
              projectId:
                  ref.read(ProviderList.projectProvider).currentProject["id"],
            );
        filterIssues(
          slug: ref
              .read(ProviderList.workspaceProvider)
              .selectedWorkspace
              .workspaceSlug,
          projID: ref.read(ProviderList.projectProvider).currentProject["id"],
          issueCategory: IssueCategory.moduleIssues,
        );
      }
      if (issueCategory == IssueCategory.cycleIssues) {
        await ref.read(ProviderList.cyclesProvider).createCycleIssues(
          slug: slug,
          projId: projID,
          issues: [response.data['id']],
        );
        ref.read(ProviderList.cyclesProvider).filterCycleIssues(
              slug: slug,
              projectId: projID,
            );
        filterIssues(
          slug: slug,
          projID: projID,
          issueCategory: IssueCategory.cycleIssues,
        );
      }
      await ref.read(ProviderList.myIssuesProvider).filterIssues();
      if (issueCategory == IssueCategory.issues) {
        if (projID ==
            ref.read(ProviderList.projectProvider).currentProject["id"]) {
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
    try {
      final response = await DioConfig().dioServe(
        hasAuth: true,
        url: APIs.projectIssues
            .replaceAll("\$SLUG", slug)
            .replaceAll('\$PROJECTID', projID),
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
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
      final response = await DioConfig().dioServe(
        hasAuth: true,
        url: APIs.projectMembers
            .replaceAll("\$SLUG", slug)
            .replaceAll('\$PROJECTID', projID),
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      members = response.data;
      for (final element in members) {
        if (element["member"]['id'] ==
            ref!.read(ProviderList.profileProvider).userProfile.id) {
          ref!.read(ProviderList.projectProvider).role =
              roleParser(role: element["role"]);
          break;
        }
      }
      membersState = StateEnum.success;
      notifyListeners();
    } on DioException catch (e) {
      log(e.response.toString());
      membersState = StateEnum.error;
      notifyListeners();
    }
  }

  Future getIssueDisplayProperties({required Enum issueCategory}) async {
    final cyclesProvider = ref!.read(ProviderList.cyclesProvider);
    final modulesProvider = ref!.read(ProviderList.modulesProvider);
    issueState = StateEnum.loading;
    try {
      var response = await DioConfig().dioServe(
        hasAuth: true,
        url: APIs.issueDisplayProperties
            .replaceAll(
                "\$SLUG",
                ref!
                    .read(ProviderList.workspaceProvider)
                    .selectedWorkspace
                    .workspaceSlug)
            .replaceAll('\$PROJECTID',
                ref!.read(ProviderList.projectProvider).currentProject['id']),
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      if (response.data.isEmpty) {
        response = await DioConfig().dioServe(
            hasAuth: true,
            url: APIs.issueDisplayProperties
                .replaceAll(
                    "\$SLUG",
                    ref!
                        .read(ProviderList.workspaceProvider)
                        .selectedWorkspace
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
                "created_on": false,
                "updated_on": false,
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
          issues.displayProperties.startDate =
              issueProperty['properties']['start_date'];
          issues.displayProperties.createdOn =
              issueProperty['properties']['created_on'];
          issues.displayProperties.updatedOn =
              issueProperty['properties']['updated_on'];
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
          cyclesProvider.issues.displayProperties.label =
              cyclesProvider.issueProperty['properties']['labels'];
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
          modulesProvider.issues.displayProperties.createdOn =
              modulesProvider.issueProperty['properties']?['created_on'] ??
                  false;
          modulesProvider.issues.displayProperties.updatedOn =
              modulesProvider.issueProperty['properties']['updated_on'];
          ref!.read(ProviderList.modulesProvider).issues.displayProperties =
              modulesProvider.issues.displayProperties;
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
          issues.displayProperties.startDate =
              issueProperty['properties']['start_date'] ?? false;
          issues.displayProperties.createdOn =
              issueProperty['properties']['created_on'] ?? false;
          issues.displayProperties.updatedOn =
              issueProperty['properties']['updated_on'] ?? false;

          // ref!.read(ProviderList.cyclesProvider).issues.displayProperties = issues.displayProperties;
        }
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
    final cyclesProvider = ref!.read(ProviderList.cyclesProvider);
    final modulesProvider = ref!.read(ProviderList.modulesProvider);
    try {
      final response = await DioConfig().dioServe(
        hasAuth: true,
        url:
            ("${APIs.issueDisplayProperties}${issueCategory == IssueCategory.cycleIssues ? cyclesProvider.issueProperty['id'] : issueCategory == IssueCategory.moduleIssues ? modulesProvider.issueProperty['id'] : issueProperty['id']}/")
                .replaceAll(
                    "\$SLUG",
                    ref!
                        .read(ProviderList.workspaceProvider)
                        .selectedWorkspace
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

      if (issueCategory == IssueCategory.cycleIssues) {
        cyclesProvider.issueProperty = response.data;
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

  Future updateProjectView(
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
            "layout": issues.projectView == ProjectView.kanban
                ? 'kanban'
                : issues.projectView == ProjectView.list
                    ? 'list'
                    : issues.projectView == ProjectView.calendar
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
        url: APIs.projectViews
            .replaceAll(
                "\$SLUG",
                ref!
                    .read(ProviderList.workspaceProvider)
                    .selectedWorkspace
                    .workspaceSlug)
            .replaceAll('\$PROJECTID',
                ref!.read(ProviderList.projectProvider).currentProject['id']),
        hasBody: true,
        data: view,
        httpMethod: HttpMethod.post,
      );
      projectViewState = StateEnum.success;
      notifyListeners();
    } on DioException catch (e) {
      log(e.response.toString());
      projectViewState = StateEnum.error;
      notifyListeners();
    }
  }

  Future getProjectView({bool reset = false}) async {
    projectViewState = StateEnum.loading;
    if (reset) {
      notifyListeners();
    }
    try {
      final response = await DioConfig().dioServe(
        hasAuth: true,
        url: APIs.userIssueView
            .replaceAll(
                "\$SLUG",
                ref!
                    .read(ProviderList.workspaceProvider)
                    .selectedWorkspace
                    .workspaceSlug)
            .replaceAll('\$PROJECTID',
                ref!.read(ProviderList.projectProvider).currentProject['id']),
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      issueView =
          reset ? response.data["default_props"] : response.data["view_props"];
      issues.projectView = issueView['display_filters']['layout'] == 'list'
          ? ProjectView.list
          : issueView['display_filters']['layout'] == 'calendar'
              ? ProjectView.calendar
              : issueView['display_filters']['layout'] == 'spreadsheet'
                  ? ProjectView.spreadsheet
                  : ProjectView.kanban;
      issues.showSubIssues = issueView['display_filters']['sub_issue'] ?? true;
      issues.groupBY =
          Issues.toGroupBY(issueView["display_filters"]["group_by"]);
      issues.orderBY =
          Issues.toOrderBY(issueView["display_filters"]["order_by"]);
      issues.issueType =
          Issues.toIssueType(issueView["display_filters"]["type"]);
      issues.filters.priorities = (issueView["filters"]["priority"] == 'none'
              ? []
              : issueView["filters"]["priority"]) ??
          [];
      issues.filters.states = issueView["filters"]["state"] ?? [];
      issues.filters.assignees = issueView["filters"]["assignees"] ?? [];
      issues.filters.createdBy = issueView["filters"]["created_by"] ?? [];
      issues.filters.labels = issueView["filters"]["labels"] ?? [];
      issues.filters.targetDate = issueView["filters"]["target_date"] ?? [];
      issues.filters.startDate = issueView["filters"]["start_date"] ?? [];
      issues.filters.subscriber = issueView["filters"]["subscriber"] ?? [];
      issues.filters.stateGroup = issueView["filters"]["state_group"] ?? [];
      showEmptyStates = issueView["display_filters"]["show_empty_groups"];

      if (issues.groupBY == GroupBY.none) {
        issues.projectView = ProjectView.list;
      }
      if (reset) {
        updateProjectView();
      }
      projectViewState = StateEnum.success;
      notifyListeners();
    } on DioException catch (e) {
      log(e.response.toString());
      issues.projectView = ProjectView.kanban;
      projectViewState = StateEnum.error;
      notifyListeners();
    }
  }

  void applyIssueView() {
    final labelIds = labels.map((e) => e['id']).toList();
    groupByResponse = IssueFilterHelper.organizeIssues(
        issuesList, issues.groupBY, issues.orderBY,
        labels: labelIds, members: members, states: states);
  }

  Future filterIssues({
    required String slug,
    required String projID,
    bool fromViews = false,
    bool isArchived = false,
    String? cycleId,
    String? moduleId,
    Enum issueCategory = IssueCategory.issues,
  }) async {
    orderByState = StateEnum.loading;
    notifyListeners();

    if (issues.groupBY == GroupBY.labels) {
      getLabels(slug: slug, projID: projID);
    } else if (issues.groupBY == GroupBY.createdBY) {
      getProjectMembers(slug: slug, projID: projID);
    } else if (issues.groupBY == GroupBY.state) {
      getStates(
        slug: slug,
        projID: projID,
        showLoading: false,
      );
    }

    String url;
    if (issueCategory == IssueCategory.issues && !fromViews && !isArchived) {
      tempGroupBy = issues.groupBY;
      tempFilters = issues.filters;
      tempOrderBy = issues.orderBY;
      tempIssueType = issues.issueType;
      tempProjectView = issues.projectView;
    }

    url = APIs.orderByGroupByTypeIssues
        .replaceAll("\$SLUG", slug)
        .replaceAll('\$PROJECTID', projID)
        .replaceAll('\$TYPE', Issues.fromIssueType(issues.issueType));
    url = '$url${IssueFilterHelper.getFilterQueryParams(issues.filters)}';
    url = '$url&sub_issue=${issues.showSubIssues}';
    log('URL: $url');
    try {
      final response = await DioConfig().dioServe(
        hasAuth: true,
        url: url,
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      issuesList = response.data.values.toList();
      final organizedIssues = IssueFilterHelper.organizeIssues(
          issuesList, issues.groupBY, issues.orderBY,
          labels: labels.map((e) => e['id']).toList(),
          members: members,
          states: states);

      if (issueCategory == IssueCategory.issues) {
        groupByResponse = organizedIssues;
      } else if (issueCategory == IssueCategory.cycleIssues ||
          issueCategory == IssueCategory.moduleIssues) {
        return organizedIssues;
      }
      orderByState = StateEnum.success;
      notifyListeners();
    } on DioException catch (e) {
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
