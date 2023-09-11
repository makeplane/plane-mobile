import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:plane/config/apis.dart';
import 'package:plane/config/const.dart';
import 'package:plane/kanban/models/inputs.dart';
import 'package:plane/models/issues.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/screens/MainScreens/Projects/ProjectDetail/IssuesTab/create_issue.dart';
//import 'package:plane/screens/MainScreens/Projects/ProjectDetail/Settings/states_pages.dart';
import 'package:plane/services/dio_service.dart';
import 'package:plane/utils/constants.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/custom_text.dart';
import 'package:plane/widgets/issue_card_widget.dart';

import '../screens/MainScreens/Projects/ProjectDetail/IssuesTab/issue_detail.dart';

class MyIssuesProvider extends ChangeNotifier {
  MyIssuesProvider(ChangeNotifierProviderRef<MyIssuesProvider> this.ref);
  Ref? ref;
  StateEnum getMyIssuesState = StateEnum.empty;
  StateEnum myIssuesViewState = StateEnum.empty;
  StateEnum myIssuesFilterState = StateEnum.empty;
  StateEnum labelState = StateEnum.empty;
  var groupByResponse = {};
  List<dynamic> data = [];
  var labels = [];
  var issuesResponse = [];
  var createIssuedata = {};
  bool isISsuesEmpty = true;
  var issuesList = [];
  var shrinkStates = [];
  List stateOrdering = [];
  var myIssueView = {};
  int pageIndex = 0;

  Issues issues = Issues.initialize();
  bool showEmptyStates = true;
  List defaultStateGroups = [
    'backlog',
    'unstarted',
    'started',
    'completed',
    'cancelled',
  ];

  bool isTagsEnabled() {
    return true;
  }

  setState() {
    notifyListeners();
  }

  changePage(value) {
    pageIndex = value;
    filterIssues();
  }

  void clear() {
    myIssueView = {};
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
    createIssuedata = {};
    issuesResponse = [];
    labels = [];
    //states = [];
    groupByResponse = {};

    shrinkStates = [];
  }

  Future getMyIssues({required String slug}) async {
    getMyIssuesState = StateEnum.loading;
    // notifyListeners();
    try {
      var response = await DioConfig().dioServe(
        hasAuth: true,
        url: APIs.myIssues.replaceFirst('\$SLUG', slug),
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      data.clear();
      data = response.data;
      getMyIssuesState = StateEnum.success;
      notifyListeners();
    } catch (e) {
      if (e is DioException) {
        log(e.message.toString());
      }
      log(e.toString());
      getMyIssuesState = StateEnum.error;
      notifyListeners();
    }
  }

  Future getMyIssuesView() async {
    myIssuesViewState = StateEnum.loading;
    log('Get My Issues View');
    try {
      var response = await DioConfig().dioServe(
        hasAuth: true,
        url: APIs.myIssuesView.replaceAll(
            "\$SLUG",
            ref!
                .read(ProviderList.workspaceProvider)
                .selectedWorkspace!
                .workspaceSlug),
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      myIssueView = response.data["view_props"];
      log("project view=>${response.data["view_props"]}");
      issues.projectView = myIssueView["issueView"] == 'list'
          ? ProjectView.list
          : myIssueView['issueView'] == 'calendar'
              ? ProjectView.calendar
              : myIssueView['issueView'] == 'spreadsheet'
                  ? ProjectView.spreadsheet
                  : ProjectView.kanban;
      issues.groupBY = Issues.toGroupBY(myIssueView["groupByProperty"]);
      issues.orderBY = Issues.toOrderBY(myIssueView["orderBy"]);
      issues.issueType = Issues.toIssueType(myIssueView["filters"]["type"]);
      issues.filters.priorities = myIssueView["filters"]["priority"] ?? [];
      issues.filters.states = myIssueView["filters"]["state_group"] ?? [];
      issues.filters.assignees = myIssueView["filters"]["assignees"] ?? [];
      issues.filters.createdBy = myIssueView["filters"]["created_by"] ?? [];
      issues.filters.labels = myIssueView["filters"]["labels"] ?? [];
      issues.filters.startDate = myIssueView["filters"]["start_date"] ?? [];
      // issues.displayProperties = myIssueView["displayProperties"];
      issues.filters.targetDate = myIssueView["filters"]["target_date"] ?? [];
      showEmptyStates = myIssueView["showEmptyGroups"];
      issues.displayProperties.assignee = myIssueView['properties']['assignee'];
      issues.displayProperties.dueDate = myIssueView['properties']['due_date'];
      issues.displayProperties.id = myIssueView['properties']['key'];
      issues.displayProperties.label = myIssueView['properties']['labels'];
      issues.displayProperties.state = myIssueView['properties']['state'];
      issues.displayProperties.subIsseCount =
          myIssueView['properties']['sub_issue_count'];
      issues.displayProperties.linkCount = myIssueView['properties']['link'];
      issues.displayProperties.attachmentCount =
          myIssueView['properties']['attachment_count'];
      issues.displayProperties.priority = myIssueView['properties']['priority'];
      issues.displayProperties.estimate = myIssueView['properties']['estimate'];
      issues.displayProperties.startDate =
          myIssueView['properties']['start_date'] ?? false;

      // log("My Issues view=>${myIssueView.toString()}");

      myIssuesViewState = StateEnum.success;
      notifyListeners();
    } on DioException catch (e) {
      log("MY ISSUES:${e.response}");
      issues.projectView = ProjectView.kanban;
      myIssuesViewState = StateEnum.error;
      notifyListeners();
    }
  }

  Future getLabels() async {
    labelState = StateEnum.loading;
    // notifyListeners();
    var slug = ref!
        .read(ProviderList.workspaceProvider)
        .selectedWorkspace!
        .workspaceSlug;

    try {
      var response = await DioConfig().dioServe(
        hasAuth: true,
        // url: APIs.issueLabels
        //     .replaceAll("\$SLUG", slug)
        //     .replaceAll('\$PROJECTID', projID),
        url: '${APIs.baseApi}/api/workspaces/$slug/labels/',
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

  Future filterIssues({
    bool created = false,
    bool assigned = false,
  }) async {
    var slug = ref!
        .read(ProviderList.workspaceProvider)
        .selectedWorkspace!
        .workspaceSlug;

    myIssuesFilterState = StateEnum.loading;
    notifyListeners();

    issues.filters.assignees = [];
    issues.filters.createdBy = [];

    if (pageIndex == 0) {
      issues.filters.assignees = [
        ref!.read(ProviderList.profileProvider).userProfile.id
      ];
    }
    if (pageIndex == 1) {
      issues.filters.createdBy = [
        ref!.read(ProviderList.profileProvider).userProfile.id
      ];
    }

    if (assigned) {
      issues.filters.assignees
          .add(ref!.read(ProviderList.profileProvider).userProfile.id);
    }
    if (created) {
      issues.filters.createdBy
          .add(ref!.read(ProviderList.profileProvider).userProfile.id);
    }

    if (issues.groupBY == GroupBY.labels) {
      getLabels();
    }
    String url;
    var groupBy = issues.groupBY == GroupBY.state
        ? 'state_detail.group'
        : Issues.fromGroupBY(issues.groupBY);
    if (issues.issueType != IssueType.all) {
      url = APIs.myIssues
          .replaceAll("\$SLUG", slug)
          .replaceAll('\$ORDERBY', Issues.fromOrderBY(issues.orderBY))
          .replaceAll('\$GROUPBY', groupBy)
          .replaceAll('\$TYPE', Issues.fromIssueType(issues.issueType));
      if (issues.filters.priorities.isNotEmpty) {
        url =
            '$url&priority=${issues.filters.priorities.toString().replaceAll('[', '').replaceAll(']', '').replaceAll(' ', '')}';
      }
      if (issues.filters.states.isNotEmpty) {
        url =
            '$url&state_group=${issues.filters.states.toString().replaceAll('[', '').replaceAll(']', '').replaceAll(' ', '')}';
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
      //start_date
      if (issues.filters.startDate.isNotEmpty) {
        url =
            '$url&start_date=${issues.filters.startDate.toString().replaceAll('[', '').replaceAll(']', '').replaceAll(' ', '')}';
      }
      if (pageIndex == 2) {
        url =
            '$url&subscriber=${ref!.read(ProviderList.profileProvider).userProfile.id}';
      } else {
        url = url;
      }
    } else {
      url = APIs.myIssues
          .replaceAll("\$SLUG", slug)
          .replaceAll('\$ORDERBY', Issues.fromOrderBY(issues.orderBY))
          .replaceAll('\$GROUPBY', groupBy);
      if (issues.filters.states.isNotEmpty) {
        url = url.replaceAll('&type=\$TYPE', '');
        log(url);
      } else {
        url = url.replaceAll('\$TYPE', Issues.fromIssueType(issues.issueType));
      }

      if (issues.filters.priorities.isNotEmpty) {
        url =
            '$url&priority=${issues.filters.priorities.toString().replaceAll('[', '').replaceAll(']', '').replaceAll(' ', '')}';
      }
      if (issues.filters.states.isNotEmpty) {
        url =
            '$url&state_group=${issues.filters.states.toString().replaceAll('[', '').replaceAll(']', '').replaceAll(' ', '')}';
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
      }
      if (pageIndex == 2) {
        url =
            '$url&subscriber=${ref!.read(ProviderList.profileProvider).userProfile.id}';
      } else {
        url = url;
      }
    }
    // dynamic temp;
    log('URL======>: $url');
    try {
      var response = await DioConfig().dioServe(
        hasAuth: true,
        url: url,
        hasBody: false,
        httpMethod: HttpMethod.get,
      );

      // log('filter myIssue issue success ${response.data.toString()}');

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

      // if (issues.groupBY == GroupBY.state) {
      //   groupByResponse = {};

      //   if (issues.filters.states.isNotEmpty) {
      //     for (var element in issues.filters.states) {
      //       if (response.data[element] == null) {
      //         groupByResponse[element] = [];
      //       } else {
      //         groupByResponse[element] = response.data[element];
      //       }
      //     }
      //   } else {
      //     for (var element in stateOrdering) {
      //       groupByResponse[element] = response.data[element] ?? [];
      //     }
      //   }
      //   shrinkStates = List.generate(stateOrdering.length, (index) => false);
      // } else {
      stateOrdering = [];
      response.data.forEach((key, value) {
        stateOrdering.add(key);
      });
      groupByResponse = response.data;
      shrinkStates = List.generate(stateOrdering.length, (index) => false);
      // }

      log('StateOrdering: $stateOrdering');

      myIssuesFilterState = StateEnum.success;
      notifyListeners();
    } on DioException catch (e) {
      log('filter myIssue issue error');
      log(e.message.toString());
      myIssuesFilterState = StateEnum.error;
      notifyListeners();
    }
  }

  List<BoardListsData> initializeBoard() {
    var themeProvider = ref!.read(ProviderList.themeProvider);
    var projectProvider = ref!.read(ProviderList.projectProvider);
    int count = 0;
    //   log(issues.groupBY.name);
    issues.issues = [];
    var projectIcons = {};
    var stateIcons = {
      'Backlog': SvgPicture.asset('assets/svg_images/circle.svg'),
      'Unstarted': SvgPicture.asset('assets/svg_images/circle.svg'),
      'Started': SvgPicture.asset('assets/svg_images/in_progress.svg'),
      'Completed': SvgPicture.asset('assets/svg_images/done.svg'),
      'Cancelled': SvgPicture.asset('assets/svg_images/cancelled.svg'),
    };
    // for (int i = 0; i < defaultStateGroups.length; i++) {
    //   var state = defaultStateGroups[i];
    //   state == 'backlog'
    //       ? 'assets/svg_images/circle.svg'
    //       : state == 'cancelled'
    //           ? 'assets/svg_images/cancelled.svg'
    //           : state == 'completed'
    //               ? 'assets/svg_images/done.svg'
    //               : state == 'started'
    //                   ? 'assets/svg_images/in_progress.svg'
    //                   : 'assets/svg_images/circle.svg';
    // }
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
            from: PreviousScreen.myIssues,
            fromMyIssues: true,
            cardIndex: count++,
            listIndex: j,
            issueCategory: IssueCategory.myIssues,
          ),
        );
      }
      Map label = {};
      // String userName = '';

      bool labelFound = false;
      // bool userFound = false;

      for (int i = 0; i < labels.length; i++) {
        if (stateOrdering[j] == labels[i]['id']) {
          label = labels[i];
          labelFound = true;
          break;
        }
      }

      // log(label.toString());
      if (myIssuesFilterState == StateEnum.success) {
        var title = issues.groupBY == GroupBY.priority
            ? stateOrdering[j]
            : issues.groupBY == GroupBY.project
                ? projectProvider.projects.firstWhere(
                    (element) => element['id'] == stateOrdering[j])['name']
                : stateOrdering[j];

        if (issues.groupBY == GroupBY.project) {
          int index = projectProvider.projects
              .indexWhere((element) => element['name'] == title);
          if (projectProvider.projects[index]['emoji'] != null) {
            //convert title to lowercase

            projectIcons[title.toLowerCase()] = {
              'name': projectProvider.projects[index]['emoji'],
              'is_emoji': true,
            };
          } else {
            projectIcons[title.toLowerCase()] = {
              'name': projectProvider.projects[index]['icon_prop']['name'],
              'is_emoji': false,
              'color': projectProvider.projects[index]['icon_prop']['color'],
            };
          }
        }
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
    }

    for (var element in issues.issues) {
      //  log(issues.groupBY.toString());
      log(element.title.toString());

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
                  : issues.groupBY == GroupBY.project
                      ? projectIcons[element.title!.toLowerCase()]['is_emoji']
                          ? Text(
                              int.tryParse(projectIcons[element.title!
                                              .toLowerCase()]['name']
                                          .toString()) !=
                                      null
                                  ? String.fromCharCode(int.parse(
                                      projectIcons[element.title!.toLowerCase()]
                                          ['name']))
                                  : '🚀',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                              ),
                            )
                          : Icon(
                              iconList[
                                  projectIcons[element.title!.toLowerCase()]
                                      ['name']],
                              color: Color(int.parse(
                                  projectIcons[element.title!.toLowerCase()]
                                          ['color']
                                      .replaceAll('#', '0xff'))),
                              size: 22,
                            )
                      : SizedBox(
                          height: 22,
                          width: 22,
                          child: stateIcons[element.title]);

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
            GestureDetector(
                onTap: () {
                  if (issues.groupBY == GroupBY.state) {
                    createIssuedata['state'] = element.id;
                  } else {
                    createIssuedata['priority'] =
                        'de3c90cd-25cd-42ec-ac6c-a66caf8029bc';
                    // createIssuedata['s'] = element.id;
                  }

                  ref!.read(ProviderList.projectProvider).currentProject =
                      ref!.read(ProviderList.projectProvider).projects[0];
                  ref!.read(ProviderList.projectProvider).setState();

                  Navigator.push(
                      Const.globalKey.currentContext!,
                      MaterialPageRoute(
                          builder: (ctx) => CreateIssue(
                                projectId: ref!
                                    .read(ProviderList.projectProvider)
                                    .projects[0]['id'],
                                fromMyIssues: true,
                              )));
                },
                child: Icon(
                  Icons.add,
                  color: themeProvider.themeManager.placeholderTextColor,
                )),
          ],
        ),
      );
    }

    return issues.issues;
  }

  bool checkIsCardsDaraggable() {
    return (issues.groupBY == GroupBY.priority);
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
      (groupByResponse[stateOrdering[newListIndex]] as List).insert(
          newCardIndex,
          groupByResponse[stateOrdering[oldListIndex]].removeAt(oldCardIndex));
      notifyListeners();
      var issue = groupByResponse[stateOrdering[newListIndex]][newCardIndex];
      await DioConfig().dioServe(
          hasAuth: true,
          url: APIs.issueDetails
              .replaceAll(
                  "\$SLUG",
                  ref!
                      .read(ProviderList.workspaceProvider)
                      .selectedWorkspace!
                      .workspaceSlug)
              .replaceAll('\$PROJECTID', issue['project'])
              .replaceAll('\$ISSUEID', issue['id']),
          hasBody: true,
          httpMethod: HttpMethod.patch,
          data: {
            'priority': stateOrdering[newListIndex].toString().toLowerCase(),
          });

      // log(response.data.toString());
      if (issues.groupBY == GroupBY.priority) {
        log(groupByResponse[stateOrdering[newListIndex]][newCardIndex]['name']);
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

      log("ISSUE REPOSITIONED");
      notifyListeners();
    } on DioException catch (err) {
      (groupByResponse[stateOrdering[oldListIndex]] as List).insert(
          oldCardIndex,
          groupByResponse[stateOrdering[newListIndex]].removeAt(newCardIndex));
      log(err.toString());
      notifyListeners();
      log('Error : issues_provider : upDateIssue');
      rethrow;
    }
  }

  Future updateMyIssueView() async {
    dynamic filterPriority;
    if (issues.filters.priorities.isNotEmpty) {
      filterPriority = issues.filters.priorities
          .map((element) => element == 'none' ? null : element)
          .toList();
    }

    try {
      var response = await DioConfig().dioServe(
        hasAuth: true,
        url: APIs.updateMyIssuesView.replaceAll(
            "\$SLUG",
            ref!
                .read(ProviderList.workspaceProvider)
                .selectedWorkspace!
                .workspaceSlug),
        hasBody: true,
        data: {
          "view_props": {
            // "calendarDateRange": "",
            // "collapsed": false,
            // "filterIssue": null,
            "filters": {
              'type': null,
              "priority": filterPriority,
              if (issues.filters.states.isNotEmpty)
                "state_group": issues.filters.states,
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
            "groupByProperty": issues.groupBY == GroupBY.state
                ? 'state_detail.group'
                : Issues.fromGroupBY(issues.groupBY),
            'issueView': issues.projectView == ProjectView.kanban
                ? 'kanban'
                : issues.projectView == ProjectView.list
                    ? 'list'
                    : issues.projectView == ProjectView.calendar
                        ? 'calendar'
                        : 'spreadsheet',
            "orderBy": Issues.fromOrderBY(issues.orderBY),
            "showEmptyGroups": showEmptyStates,
            "properties": {
              "assignee": issues.displayProperties.assignee,
              "due_date": issues.displayProperties.dueDate,
              "key": issues.displayProperties.id,
              "labels": issues.displayProperties.label,
              "state": issues.displayProperties.state,
              "sub_issue_count": issues.displayProperties.subIsseCount,
              "link": issues.displayProperties.linkCount,
              "attachment_count": issues.displayProperties.attachmentCount,
              "priority": issues.displayProperties.priority,
              "estimate": issues.displayProperties.estimate,
              "start_date": issues.displayProperties.startDate,
            }
          }
        },
        httpMethod: HttpMethod.post,
      );
      log('project view => ${response.data}');
      notifyListeners();
    } on DioException catch (e) {
      log("ERROR");
      log(e.response.toString());
      notifyListeners();
    }
  }
}
