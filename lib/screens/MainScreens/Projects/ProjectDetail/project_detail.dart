import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane_startup/bottom_sheets/filter_sheet.dart';
import 'package:plane_startup/bottom_sheets/page_filter_sheet.dart';
import 'package:plane_startup/bottom_sheets/type_sheet.dart';
import 'package:plane_startup/bottom_sheets/views_sheet.dart';
import 'package:plane_startup/screens/MainScreens/Projects/ProjectDetail/PagesTab/page_screen.dart';
import 'package:plane_startup/screens/MainScreens/Projects/ProjectDetail/calender_view.dart';
import 'package:plane_startup/kanban/custom/board.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/screens/MainScreens/Projects/ProjectDetail/CyclesTab/project_details_cycles.dart';
import 'package:plane_startup/screens/MainScreens/Projects/ProjectDetail/IssuesTab/create_issue.dart';
import 'package:plane_startup/screens/MainScreens/Projects/ProjectDetail/ModulesTab/module_screen.dart';
import 'package:plane_startup/screens/MainScreens/Projects/ProjectDetail/ViewsTab/views.dart';
import 'package:plane_startup/screens/MainScreens/Projects/ProjectDetail/spreadsheet_view.dart';
import 'package:plane_startup/screens/MainScreens/Projects/create_page_screen.dart';
import 'package:plane_startup/screens/settings_screen.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/utils/enums.dart';
import 'package:plane_startup/widgets/custom_app_bar.dart';
import 'package:plane_startup/widgets/custom_text.dart';
import 'package:plane_startup/widgets/empty.dart';
import 'package:plane_startup/widgets/error_state.dart';
import 'package:plane_startup/widgets/loading_widget.dart';

import '../../../../kanban/models/inputs.dart';
import '../../../create_view_screen.dart';
import 'CyclesTab/create_cycle.dart';
import 'ModulesTab/create_module.dart';

class ProjectDetail extends ConsumerStatefulWidget {
  const ProjectDetail({super.key, required this.index});
  final int index;

  @override
  ConsumerState<ProjectDetail> createState() => _ProjectDetailState();
}

class _ProjectDetailState extends ConsumerState<ProjectDetail> {
  // var tabs = [
  //   {'title': 'Issues', 'width': 60},
  //   {'title': 'Cycles', 'width': 60},
  //   {'title': 'Modules', 'width': 75},
  //   {'title': 'Views', 'width': 60},
  //   {'title': 'Pages', 'width': 50},
  // ];
  var controller = PageController(initialPage: 0);

  var selected = 0;
  var pages = [];

  @override
  void initState() {
    ref.read(ProviderList.issuesProvider).orderByState = StateEnum.loading;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(ProviderList.projectProvider).initializeProject();
    });

    pages = [
      cycles(),
      cycles(),
      const ModuleScreen(),
      const Views(),
      const PageScreen()
    ];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var issueProvider = ref.watch(ProviderList.issuesProvider);
    var projectProvider = ref.watch(ProviderList.projectProvider);
    var cycleProvider = ref.watch(ProviderList.cyclesProvider);
    var moduleProvider = ref.watch(ProviderList.modulesProvider);
    var viewsProvider = ref.watch(ProviderList.viewsProvider);

    // log(issueProvider.issues.groupBY.name);

    return Scaffold(
      appBar: CustomAppBar(
        elevation: false,
        onPressed: () {
          Navigator.pop(context);
        },
        text: ref.read(ProviderList.projectProvider).currentProject['name'],
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingScreen(),
                ),
              );
            },
            icon: issueProvider.statesState == StateEnum.restricted
                ? Container()
                : Icon(
                    Icons.settings_outlined,
                    color: themeProvider.themeManager.placeholderTextColor,
                  ),
          ),
        ],
      ),
      floatingActionButton: selected != 0 &&
              (projectProvider.role == Role.admin ||
                  projectProvider.role == Role.member) &&
              ((selected == 1 &&
                      (cycleProvider.cyclesAllData.isNotEmpty ||
                          cycleProvider.cycleFavoriteData.isNotEmpty) &&
                      cycleProvider.cyclesState != StateEnum.loading) ||
                  (selected == 2 &&
                      moduleProvider.moduleState != StateEnum.loading &&
                      (moduleProvider.modules.isNotEmpty ||
                          moduleProvider.favModules.isNotEmpty)) ||
                  (selected == 3 &&
                      viewsProvider.viewsState != StateEnum.loading &&
                      viewsProvider.views.isNotEmpty))
          // selected != 0 &&
          //         (projectProvider.role == Role.admin ||
          //             projectProvider.role == Role.member) &&
          //         (selected == 3 &&
          //             viewsProvider.viewsState != StateEnum.loading &&
          //             viewsProvider.views.isNotEmpty)
          ? FloatingActionButton(
              backgroundColor: themeProvider.themeManager.primaryColour,
              child: Icon(
                Icons.add,
                color: themeProvider.themeManager.textonColor,
              ),
              onPressed: () {
                if (selected == 1) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => const CreateCycle(),
                    ),
                  );
                }
                if (selected == 2) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => const CreateModule(),
                    ),
                  );
                }
                if (selected == 3) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => const CreateView(),
                    ),
                  );
                }
                if (selected == 4) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => const CreatePage(),
                    ),
                  );
                }
              },
            )
          : Container(),
      body: SafeArea(
        child: Container(
          // color: themeProvider.backgroundColor,
          color: themeProvider.themeManager.primaryBackgroundDefaultColor,
          child: projectProvider.projectDetailState == StateEnum.error
              ? errorState(
                  context: context,
                  ontap: () {
                    ref.read(ProviderList.projectProvider).initializeProject();
                  })
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: projectProvider.features.map((e) {
                        return e['show']
                            ? Expanded(
                                child: InkWell(
                                  onTap: () {
                                    controller.jumpToPage(
                                        projectProvider.features.indexOf(e));
                                    setState(() {
                                      selected =
                                          projectProvider.features.indexOf(e);
                                    });
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 15),
                                        child: CustomText(
                                          e['title'].toString(),
                                          color: projectProvider.features
                                                      .indexOf(e) ==
                                                  selected
                                              ? themeProvider
                                                  .themeManager.primaryColour
                                              : themeProvider.themeManager
                                                  .placeholderTextColor,
                                          overrride: true,
                                          type: FontStyle.Medium,
                                          fontWeight: projectProvider.features
                                                      .indexOf(e) ==
                                                  selected
                                              ? FontWeightt.Medium
                                              : null,
                                        ),
                                      ),
                                      selected ==
                                                  projectProvider.features
                                                      .indexOf(e) &&
                                              (projectProvider.features
                                                          .elementAt(
                                                              1)['show'] ==
                                                      true ||
                                                  projectProvider.features
                                                          .elementAt(
                                                              2)['show'] ==
                                                      true)
                                          ? Container(
                                              height: 6,
                                              decoration: BoxDecoration(
                                                  color: themeProvider
                                                      .themeManager
                                                      .primaryColour,
                                                  borderRadius:
                                                      BorderRadius.circular(6)),
                                            )
                                          : Container(
                                              height: 6,
                                            )
                                    ],
                                  ),
                                ),
                              )
                            : Container();
                      }).toList(),
                    ),
                    Container(
                      height: 2,
                      width: MediaQuery.of(context).size.width,
                      color: themeProvider.themeManager.borderSubtle01Color,
                    ),
                    Expanded(
                        child: PageView.builder(
                      controller: controller,
                      onPageChanged: (page) {
                        setState(() {
                          selected = page;
                        });
                      },
                      itemBuilder: (ctx, index) {
                        return Container(
                            child:
                                index == 0 ? issues(ctx, ref) : pages[index]);
                      },
                      itemCount: pages.length,
                    )),
                    issueProvider.statesState == StateEnum.loading ||
                            issueProvider.issueState == StateEnum.loading
                        ? Container()
                        : selected == 0 &&
                                issueProvider.statesState ==
                                    StateEnum.restricted
                            ? Container()
                            : selected == 0 &&
                                    issueProvider.statesState ==
                                        StateEnum.success
                                ?
                                //////////////////////////////////////////////////
                                Container(
                                    decoration: BoxDecoration(
                                        color: themeProvider.themeManager
                                            .primaryBackgroundDefaultColor,
                                        boxShadow: [
                                          BoxShadow(
                                              color: themeProvider
                                                  .themeManager.shadowColor,
                                              blurRadius: 5,
                                              offset: const Offset(0, -5))
                                        ]),
                                    height: 50,
                                    width: MediaQuery.of(context).size.width,
                                    child: Row(
                                      children: [
                                        projectProvider.role == Role.admin
                                            ? Expanded(
                                                child: InkWell(
                                                  onTap: () {
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            const CreateIssue(),
                                                      ),
                                                    );
                                                  },
                                                  child: SizedBox.expand(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons.add,
                                                          color: themeProvider
                                                              .themeManager
                                                              .primaryTextColor,
                                                          size: 20,
                                                        ),
                                                        const CustomText(
                                                          ' Issue',
                                                          type:
                                                              FontStyle.Medium,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                        Container(
                                          height: 50,
                                          width: 0.5,
                                          color: themeProvider
                                              .themeManager.borderSubtle01Color,
                                        ),
                                        Expanded(
                                            child: InkWell(
                                          onTap: () {
                                            showModalBottomSheet(
                                                isScrollControlled: true,
                                                enableDrag: true,
                                                constraints: BoxConstraints(
                                                    maxHeight: height * 0.5),
                                                shape:
                                                    const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                  topLeft: Radius.circular(30),
                                                  topRight: Radius.circular(30),
                                                )),
                                                context: context,
                                                builder: (ctx) {
                                                  return const TypeSheet(
                                                    issueCategory:
                                                        IssueCategory.issues,
                                                  );
                                                });
                                          },
                                          child: SizedBox.expand(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.list_outlined,
                                                  color: themeProvider
                                                      .themeManager
                                                      .primaryTextColor,
                                                  size: 19,
                                                ),
                                                const CustomText(
                                                  ' Layout',
                                                  type: FontStyle.Medium,
                                                )
                                              ],
                                            ),
                                          ),
                                        )),
                                        Container(
                                          height: 50,
                                          width: 0.5,
                                          color: themeProvider
                                              .themeManager.borderSubtle01Color,
                                        ),
                                        issueProvider.issues.projectView ==
                                                ProjectView.calendar
                                            ? Container()
                                            : Expanded(
                                                child: InkWell(
                                                onTap: () {
                                                  showModalBottomSheet(
                                                      isScrollControlled: true,
                                                      enableDrag: true,
                                                      constraints: BoxConstraints(
                                                          maxHeight:
                                                              MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.9),
                                                      shape:
                                                          const RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .only(
                                                        topLeft:
                                                            Radius.circular(30),
                                                        topRight:
                                                            Radius.circular(30),
                                                      )),
                                                      context: context,
                                                      builder: (ctx) {
                                                        return const ViewsSheet(
                                                          issueCategory:
                                                              IssueCategory
                                                                  .issues,
                                                        );
                                                      });
                                                },
                                                child: SizedBox.expand(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.wysiwyg_outlined,
                                                        color: themeProvider
                                                            .themeManager
                                                            .primaryTextColor,
                                                        size: 19,
                                                      ),
                                                      const CustomText(
                                                        ' Views',
                                                        type: FontStyle.Medium,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              )),
                                        Container(
                                          height: 50,
                                          width: 0.5,
                                          color: themeProvider
                                              .themeManager.borderSubtle01Color,
                                        ),
                                        Expanded(
                                            child: InkWell(
                                          onTap: () {
                                            showModalBottomSheet(
                                                isScrollControlled: true,
                                                enableDrag: true,
                                                constraints: BoxConstraints(
                                                    minHeight:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.75,
                                                    maxHeight:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.85),
                                                shape:
                                                    const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                  topLeft: Radius.circular(30),
                                                  topRight: Radius.circular(30),
                                                )),
                                                context: context,
                                                builder: (ctx) {
                                                  return FilterSheet(
                                                    issueCategory:
                                                        IssueCategory.issues,
                                                  );
                                                });
                                          },
                                          child: SizedBox.expand(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.filter_list_outlined,
                                                  color: themeProvider
                                                      .themeManager
                                                      .primaryTextColor,
                                                  size: 19,
                                                ),
                                                const CustomText(
                                                  ' Filters',
                                                  type: FontStyle.Medium,
                                                )
                                              ],
                                            ),
                                          ),
                                        )),
                                      ],
                                    ),
                                  )
                                : Container(),
                    selected == 4
                        ? Container(
                            height: 51,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: themeProvider
                                    .themeManager.primaryBackgroundDefaultColor,
                                boxShadow: [
                                  BoxShadow(
                                      color: themeProvider
                                          .themeManager.shadowColor,
                                      blurRadius: 5,
                                      offset: const Offset(0, -5))
                                ]),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 50,
                                  child: Row(
                                    children: [
                                      projectProvider.role == Role.admin
                                          ? Expanded(
                                              child: InkWell(
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          const CreatePage(),
                                                    ),
                                                  );
                                                },
                                                child: SizedBox.expand(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.add,
                                                        color: themeProvider
                                                            .themeManager
                                                            .primaryTextColor,
                                                        size: 20,
                                                      ),
                                                      const CustomText(
                                                        ' Page',
                                                        type: FontStyle.Medium,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Container(),
                                      Container(
                                        height: 50,
                                        width: 0.5,
                                        color: themeProvider
                                            .themeManager.borderSubtle01Color,
                                      ),
                                      Expanded(
                                          child: InkWell(
                                        onTap: () {
                                          showModalBottomSheet(
                                              isScrollControlled: true,
                                              enableDrag: true,
                                              constraints: BoxConstraints(
                                                  maxHeight:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.8),
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                topLeft: Radius.circular(30),
                                                topRight: Radius.circular(30),
                                              )),
                                              context: context,
                                              builder: (ctx) {
                                                return const FilterPageSheet();
                                              });
                                        },
                                        child: SizedBox.expand(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.filter_list_outlined,
                                                color: themeProvider
                                                    .themeManager
                                                    .primaryTextColor,
                                                size: 19,
                                              ),
                                              const CustomText(
                                                ' Filters',
                                                type: FontStyle.Medium,
                                              )
                                            ],
                                          ),
                                        ),
                                      )),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(),

                    // GestureDetector(
                    //     onTap: () {
                    //       selected == 1
                    //           ? Navigator.of(context).push(
                    //               MaterialPageRoute(
                    //                   builder: (ctx) =>
                    //                       const CreateCycle()))
                    //           : selected == 2
                    //               ? Navigator.of(context).push(
                    //                   MaterialPageRoute(
                    //                       builder: (ctx) =>
                    //                           const CreateModule()))
                    //               : selected == 3
                    //                   ? Navigator.of(context).push(
                    //                       MaterialPageRoute(
                    //                           builder: (ctx) =>
                    //                               const CreateView()))
                    //                   : Navigator.of(context).push(
                    //                       MaterialPageRoute(
                    //                           builder: (ctx) =>
                    //                               const CreatePage()));
                    //     },
                    //     child: Container(
                    //       height: 50,
                    //       width: MediaQuery.of(context).size.width,
                    //       color: Colors.black,
                    //       child: Row(
                    //         children: [
                    //           Expanded(
                    //               child: SizedBox(
                    //             child: Row(
                    //               mainAxisAlignment:
                    //                   MainAxisAlignment.center,
                    //               children: [
                    //                 const Icon(
                    //                   Icons.add,
                    //                   color: Colors.white,
                    //                 ),
                    //                 CustomText(
                    //                   selected == 1
                    //                       ? ' Add Cycle'
                    //                       : selected == 2
                    //                           ? 'Add Module'
                    //                           : selected == 3
                    //                               ? 'Add View'
                    //                               : 'Add Page',
                    //                   type: FontStyle.Medium,
                    //                   color: Colors.white,
                    //                 )
                    //               ],
                    //             ),
                    //           )),
                    //           Container(
                    //             height: 50,
                    //             width: 0.5,
                    //             color: greyColor,
                    //           ),
                    //           Expanded(
                    //               child: SizedBox(
                    //             child: Row(
                    //               mainAxisAlignment:
                    //                   MainAxisAlignment.center,
                    //               children: [
                    //                 const Icon(
                    //                   Icons.filter_alt,
                    //                   color: Colors.white,
                    //                 ),
                    //                 CustomText(
                    //                   ' Filters',
                    //                   type: FontStyle.Medium,
                    //                   color: Colors.white,
                    //                 )
                    //               ],
                    //             ),
                    //           )),
                    //         ],
                    //       ),
                    //     ),
                    //   )
                  ],
                ),
        ),
      ),
    );
  }
}

Widget issues(BuildContext context, WidgetRef ref) {
  var themeProvider = ref.watch(ProviderList.themeProvider);
  var issueProvider = ref.watch(ProviderList.issuesProvider);
  var projectProvider = ref.watch(ProviderList.projectProvider);
  // log(issueProvider.issueState.name);
  if (issueProvider.issues.projectView == ProjectView.list) {
    issueProvider.initializeBoard();
  }

  return LoadingWidget(
    loading: issueProvider.issuePropertyState == StateEnum.loading ||
        issueProvider.issueState == StateEnum.loading ||
        issueProvider.statesState == StateEnum.loading ||
        issueProvider.projectViewState == StateEnum.loading ||
        issueProvider.orderByState == StateEnum.loading,
    widgetClass: issueProvider.statesState == StateEnum.restricted
        ? EmptyPlaceholder.joinProject(
            context,
            ref,
            projectProvider.currentProject['id'],
            ref
                .read(ProviderList.workspaceProvider)
                .selectedWorkspace!
                .workspaceSlug)
        : Container(
            color: themeProvider.themeManager.secondaryBackgroundDefaultColor,
            padding: issueProvider.issues.projectView == ProjectView.kanban
                ? const EdgeInsets.only(top: 15, left: 0)
                : null,
            child: issueProvider.issueState == StateEnum.loading ||
                    issueProvider.statesState == StateEnum.loading ||
                    issueProvider.projectViewState == StateEnum.loading ||
                    issueProvider.orderByState == StateEnum.loading
                ? Container()
                : issueProvider.isISsuesEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          EmptyPlaceholder.emptyIssues(context, ref: ref),
                        ],
                      )
                    : issueProvider.issues.projectView == ProjectView.list
                        ? Container(
                            color: themeProvider
                                .themeManager.secondaryBackgroundDefaultColor,
                            margin: const EdgeInsets.only(top: 5),
                            child: SingleChildScrollView(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: issueProvider.issues.issues
                                      .map((state) => state.items.isEmpty &&
                                              !issueProvider.showEmptyStates
                                          ? Container()
                                          : SizedBox(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 15),
                                                    margin:
                                                        const EdgeInsets.only(
                                                            bottom: 10),
                                                    child: Row(
                                                      children: [
                                                        state.leading ??
                                                            Container(),
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                            left: 10,
                                                          ),
                                                          child: CustomText(
                                                            state.title!,
                                                            type:
                                                                FontStyle.Large,
                                                            color: themeProvider
                                                                .themeManager
                                                                .primaryTextColor,
                                                            fontWeight:
                                                                FontWeightt
                                                                    .Semibold,
                                                          ),
                                                        ),
                                                        Container(
                                                          alignment:
                                                              Alignment.center,
                                                          margin:
                                                              const EdgeInsets
                                                                  .only(
                                                            left: 15,
                                                          ),
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15),
                                                              color: themeProvider
                                                                  .themeManager
                                                                  .tertiaryBackgroundDefaultColor),
                                                          height: 25,
                                                          width: 30,
                                                          child: CustomText(
                                                            state.items.length
                                                                .toString(),
                                                            type:
                                                                FontStyle.Small,
                                                          ),
                                                        ),
                                                        const Spacer(),
                                                        projectProvider.role ==
                                                                    Role
                                                                        .admin ||
                                                                projectProvider
                                                                        .role ==
                                                                    Role.member
                                                            ? IconButton(
                                                                onPressed: () {
                                                                  if (issueProvider
                                                                          .issues
                                                                          .groupBY ==
                                                                      GroupBY
                                                                          .state) {
                                                                    issueProvider
                                                                            .createIssuedata['state'] =
                                                                        state
                                                                            .id;
                                                                  } else {
                                                                    issueProvider
                                                                            .createIssuedata['prioriry'] =
                                                                        'de3c90cd-25cd-42ec-ac6c-a66caf8029bc';
                                                                    // createIssuedata['s'] = element.id;
                                                                  }
                                                                  Navigator.of(
                                                                          context)
                                                                      .push(MaterialPageRoute(
                                                                          builder: (ctx) =>
                                                                              const CreateIssue()));
                                                                },
                                                                icon: Icon(
                                                                  Icons.add,
                                                                  color: themeProvider
                                                                      .themeManager
                                                                      .tertiaryTextColor,
                                                                ))
                                                            : Container(
                                                                height: 40,
                                                              ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: state.items
                                                          .map((e) => e)
                                                          .toList()),
                                                  state.items.isEmpty
                                                      ? Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  bottom: 10),
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          color: themeProvider
                                                              .themeManager
                                                              .primaryBackgroundDefaultColor,
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 15,
                                                                  bottom: 15,
                                                                  left: 15),
                                                          child:
                                                              const CustomText(
                                                            'No issues.',
                                                            type:
                                                                FontStyle.Small,
                                                            maxLines: 10,
                                                            textAlign:
                                                                TextAlign.start,
                                                          ),
                                                        )
                                                      : Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  bottom: 10),
                                                        )
                                                ],
                                              ),
                                            ))
                                      .toList()),
                            ),
                          )
                        : issueProvider.issues.projectView == ProjectView.kanban
                            ? KanbanBoard(
                                issueProvider.initializeBoard(),
                                isCardsDraggable:
                                    issueProvider.checkIsCardsDaraggable(),
                                onItemReorder: (
                                    {newCardIndex,
                                    newListIndex,
                                    oldCardIndex,
                                    oldListIndex}) {
                                  //  print('newCardIndex: $newCardIndex, newListIndex: $newListIndex, oldCardIndex: $oldCardIndex, oldListIndex: $oldListIndex');
                                  issueProvider.reorderIssue(
                                    newCardIndex: newCardIndex!,
                                    newListIndex: newListIndex!,
                                    oldCardIndex: oldCardIndex!,
                                    oldListIndex: oldListIndex!,
                                  );
                                },
                                groupEmptyStates:
                                    !issueProvider.showEmptyStates,
                                backgroundColor: themeProvider.themeManager
                                    .secondaryBackgroundDefaultColor,
                                cardPlaceHolderColor: themeProvider
                                    .themeManager.primaryBackgroundDefaultColor,
                                cardPlaceHolderDecoration: BoxDecoration(
                                    color: themeProvider.themeManager
                                        .primaryBackgroundDefaultColor,
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 2,
                                        color: themeProvider
                                            .themeManager.borderSubtle01Color,
                                        spreadRadius: 0,
                                      )
                                    ]),
                                listScrollConfig: ScrollConfig(
                                    offset: 65,
                                    duration: const Duration(milliseconds: 100),
                                    curve: Curves.linear),
                                listTransitionDuration:
                                    const Duration(milliseconds: 200),
                                cardTransitionDuration:
                                    const Duration(milliseconds: 400),
                              )
                            : issueProvider.issues.projectView ==
                                    ProjectView.calendar
                                ? const CalendarView()
                                : const SpreadSheetView(
                                    issueCategory: IssueCategory.issues,
                                  ),
          ),
  );
}

Widget cycles() {
  return const CycleWidget();
}

// Widget modules() {
//   var themeProvider = ref.read(ProviderList.themeProvider);
//   return Container(
//     color: themeProvider.isDarkThemeEnabled ? darkSecondaryBGC : Colors.white,
//     padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: const [
//         // SizedBox(
//         //   child: Text(
//         //     'Current Cycles',
//         //     style: TextStyle(fontSize: 20, fontWeight: FontWeightt.Medium),
//         //   ),
//         // ),
//         ModuleCard()
//       ],
//     ),
//   );
// }

Widget view(WidgetRef ref) {
  var themeProvider = ref.read(ProviderList.themeProvider);
  return Container(
    color: themeProvider.isDarkThemeEnabled ? darkSecondaryBGC : Colors.white,
    padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
    child: const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // SizedBox(
        //   child: Text(
        //     'Current Cycles',
        //     style: TextStyle(fontSize: 20, fontWeight: FontWeightt.Medium),
        //   ),
        // ),
        Views()
      ],
    ),
  );
}

  // bool checkVisbility(int index) {
  //   var featuresProvider = ref.watch(ProviderList.featuresProvider);
  //   if(featuresProvider.features[index]['title'] == featuresProvider.features[index]){
  //     return true;
  //   }
  //   return false;
  // }