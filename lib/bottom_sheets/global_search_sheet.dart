// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:plane_startup/config/const.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/screens/Import%20&%20Export/import_export.dart';
import 'package:plane_startup/screens/MainScreens/Profile/WorkpsaceSettings/members.dart';
import 'package:plane_startup/screens/MainScreens/Profile/WorkpsaceSettings/workspace_general.dart';
import 'package:plane_startup/screens/MainScreens/Projects/ProjectDetail/CyclesTab/create_cycle.dart';
import 'package:plane_startup/screens/MainScreens/Projects/ProjectDetail/CyclesTab/cycle_detail.dart';
import 'package:plane_startup/screens/MainScreens/Projects/ProjectDetail/IssuesTab/create_issue.dart';
import 'package:plane_startup/screens/MainScreens/Projects/ProjectDetail/IssuesTab/issue_detail_screen.dart';
import 'package:plane_startup/screens/MainScreens/Projects/ProjectDetail/ModulesTab/create_module.dart';
import 'package:plane_startup/screens/MainScreens/Projects/ProjectDetail/project_detail.dart';
import 'package:plane_startup/screens/MainScreens/Projects/create_page_screen.dart';
import 'package:plane_startup/screens/MainScreens/Projects/create_project_screen.dart';
import 'package:plane_startup/screens/billing_plans.dart';
import 'package:plane_startup/screens/create_view_screen.dart';
import 'package:plane_startup/screens/integrations.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/utils/custom_toast.dart';
import 'package:plane_startup/utils/enums.dart';
import 'package:plane_startup/widgets/custom_text.dart';
import 'package:url_launcher/url_launcher.dart';

class GlobalSearchSheet extends ConsumerStatefulWidget {
  const GlobalSearchSheet({super.key});

  @override
  ConsumerState<GlobalSearchSheet> createState() => _GlobalSearchSheetState();
}

class _GlobalSearchSheetState extends ConsumerState<GlobalSearchSheet> {
  TextEditingController input = TextEditingController();
  Timer? ticker;

  void timer() {
    ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timer.tick < 1) return;
      if (timer.tick > 1) {
        timer.cancel();
        return;
      }
      log(timer.tick.toString());

      var prov = ref.read(ProviderList.globalSearchProvider.notifier);
      if (input.text.isEmpty) {
        prov.setState();
      } else {
        log("HERE");
        prov.getGlobalData(
          slug: ref
              .read(ProviderList.workspaceProvider)
              .selectedWorkspace!
              .workspaceSlug,
          input: input.text.trim(),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var globalSearchProvider = ref.watch(ProviderList.globalSearchProvider);
    var globalSearchProviderRead =
        ref.read(ProviderList.globalSearchProvider.notifier);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            color: themeProvider.isDarkThemeEnabled
                ? darkBackgroundColor
                : lightBackgroundColor,
            child: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: themeProvider.isDarkThemeEnabled
                                ? lightBackgroundColor
                                : darkBackgroundColor,
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: input,
                            style: TextStyle(
                                color: themeProvider.isDarkThemeEnabled
                                    ? lightBackgroundColor
                                    : darkBackgroundColor),
                            decoration: themeProvider
                                .themeManager.textFieldDecoration
                                .copyWith(
                            
                              suffixIcon: input.text != ''
                                  ? IconButton(
                                      onPressed: () {
                                        input.clear();
                                        globalSearchProvider.data = null;
                                        globalSearchProviderRead.setState();
                                      },
                                      icon: Icon(Icons.cancel,
                                          color:
                                              themeProvider.isDarkThemeEnabled
                                                  ? greyColor
                                                  : greyColor))
                                  : IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.clear_outlined,
                                        color: Colors.transparent,
                                      )),

                              
                              filled: true,

                              hintText: 'Search for anything...',
                              hintStyle: TextStyle(
                                color: themeProvider
                                    .themeManager.placeholderTextColor,
                              ),
                              fillColor: themeProvider
                                  .themeManager.tertiaryBackgroundDefaultColor,
                              // prefixIcon:  Icon(
                              //   Icons.search,
                              //   color:  themeProvider
                              //     .themeManager.placeholderTextColor,
                              // ),
                            ),
                            onChanged: (value) {
                              ticker?.cancel();
                              timer();
                            },
                          ),
                        ),
                        // input.text == ''
                        //     ? Container()
                        //     : InkWell(
                        //         onTap: () {
                        //           input.clear();
                        //           globalSearchProvider.data = null;
                        //           globalSearchProviderRead.setState();
                        //         },
                        //         child: Container(
                        //           padding: const EdgeInsets.only(left: 10),
                        //           child: const CustomText(
                        //             'Cancel',
                        //             type: FontStyle.Medium,
                        //           ),
                        //         ),
                        //       )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: ref
                                      .watch(ProviderList.workspaceProvider)
                                      .selectWorkspaceState ==
                                  StateEnum.loading ||
                              ref
                                      .watch(ProviderList.projectProvider)
                                      .projectState ==
                                  StateEnum.loading
                          ? Center(
                              child: SizedBox(
                                width: 30,
                                height: 30,
                                child: LoadingIndicator(
                                  indicatorType: Indicator.lineSpinFadeLoader,
                                  colors: themeProvider.isDarkThemeEnabled
                                      ? [Colors.white]
                                      : [Colors.black],
                                  strokeWidth: 1.0,
                                  backgroundColor: Colors.transparent,
                                ),
                              ),
                            )
                          : ListView(
                              children: [
                                globalSearchProvider.data != null &&
                                        globalSearchProvider
                                            .data!.workspaces.isNotEmpty
                                    ? workspaceListWidget()
                                    : Container(),
                                globalSearchProvider.data != null &&
                                        globalSearchProvider
                                            .data!.projects.isNotEmpty
                                    ? projectsListWidget()
                                    : Container(),
                                globalSearchProvider.data != null &&
                                        globalSearchProvider
                                            .data!.cycles.isNotEmpty
                                    ? cyclesListWidget()
                                    : Container(),
                                globalSearchProvider.data != null &&
                                        globalSearchProvider
                                            .data!.modules.isNotEmpty
                                    ? modulesListWidget()
                                    : Container(),
                                globalSearchProvider.data != null &&
                                        globalSearchProvider
                                            .data!.views.isNotEmpty
                                    ? viewsListWidget()
                                    : Container(),
                                globalSearchProvider.data != null &&
                                        globalSearchProvider
                                            .data!.pages.isNotEmpty
                                    ? pagesListWidget()
                                    : Container(),
                                globalSearchProvider.data != null &&
                                        globalSearchProvider
                                            .data!.issues.isNotEmpty
                                    ? issuesList()
                                    : Container(),
                                createWidget(),
                                workspaceWidget(),
                                helpWidget(),
                              ],
                            ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget createWidget() {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    List items = [
      {
        'title': 'New Issue',
        'screen': const CreateIssue(
          cycleId: '',
          moduleId: '',
        ),
        'icon': 'assets/images/global_search_icons/issue.png'
      },
      {
        'title': 'New Project',
        'screen': const CreateProject(),
        'icon': 'assets/images/global_search_icons/project.png'
      },
      {
        'title': 'New Cycle',
        'screen': const CreateCycle(),
        'icon': 'assets/images/global_search_icons/cycle.png'
      },
      {
        'title': 'New Module',
        'screen': const CreateModule(),
        'icon': 'assets/images/global_search_icons/module.png'
      },
      {
        'title': 'New View',
        'screen': const CreateView(),
        'icon': 'assets/images/global_search_icons/view.png'
      },
      {
        'title': 'New Page',
        'screen': const CreatePage(),
        'icon': 'assets/images/global_search_icons/page.png'
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          'Create',
          type: FontStyle.Medium,
          color: themeProvider.isDarkThemeEnabled ? Colors.white : greyColor,
        ),
        const SizedBox(
          height: 20,
        ),
        ListView.builder(
          shrinkWrap: true,
          primary: false,
          itemCount: items.length,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () async {
                if (index == 0) {
                  if (ref
                      .watch(ProviderList.projectProvider)
                      .projects
                      .isEmpty) {
                    CustomToast().showSimpleToast(
                        'You dont have any projects yet, try creating one');
                  } else {
                    ref.watch(ProviderList.projectProvider).currentProject =
                        ref.watch(ProviderList.projectProvider).projects[0];
                    ref.watch(ProviderList.projectProvider).setState();
                    await ref
                        .read(ProviderList.projectProvider)
                        .initializeProject();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => items[index]['screen'],
                      ),
                    );
                  }
                } else {
                  if (index == 2) {
                    ref.watch(ProviderList.projectProvider).currentProject =
                        ref.watch(ProviderList.projectProvider).projects[0];
                    ref.watch(ProviderList.projectProvider).setState();
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => items[index]['screen'],
                    ),
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Row(
                  children: [
                    Image.asset(
                      items[index]['icon'],
                      height: 20,
                      width: 20,
                      color: themeProvider.isDarkThemeEnabled
                          ? Colors.white
                          : Colors.black,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    CustomText(
                      items[index]['title'],
                      type: FontStyle.Medium,
                    ),
                  ],
                ),
              ),
            );
          },
        )
      ],
    );
  }

  Widget workspaceWidget() {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    List items = [
      {
        'title': 'General',
        'screen': const WorkspaceGeneral(),
        'icon': 'assets/images/global_search_icons/general.png'
      },
      {
        'title': 'Members',
        'screen': const Members(
          fromWorkspace: true,
        ),
        'icon': 'assets/images/global_search_icons/members.png'
      },
      {
        'title': 'Billing & Plans',
        'screen': const BillingPlans(),
        'icon': 'assets/images/global_search_icons/billing&plans.png'
      },
      {
        'title': 'Integrations',
        'screen': const Integrations(),
        'icon': 'assets/images/global_search_icons/integrations.png'
      },
      {
        'title': 'Imports & Exports',
        'screen': const ImportEport(),
        'icon': 'assets/images/global_search_icons/imports&exports.png'
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          'Workspace Settings',
          type: FontStyle.Medium,
          color: themeProvider.isDarkThemeEnabled ? Colors.white : greyColor,
        ),
        const SizedBox(
          height: 20,
        ),
        ListView.builder(
          shrinkWrap: true,
          primary: false,
          itemCount: items.length,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () async {
                if (index == 0) {
                  if (ref
                      .watch(ProviderList.projectProvider)
                      .projects
                      .isEmpty) {
                    CustomToast().showSimpleToast(
                        'You dont have any projects yet, try creating one');
                  } else {
                    ref.watch(ProviderList.projectProvider).currentProject =
                        ref.watch(ProviderList.projectProvider).projects[0];
                    ref.watch(ProviderList.projectProvider).setState();
                    await ref
                        .read(ProviderList.projectProvider)
                        .initializeProject();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => items[index]['screen'],
                      ),
                    );
                  }
                } else {
                  if (index == 2) {
                    ref.watch(ProviderList.projectProvider).currentProject =
                        ref.watch(ProviderList.projectProvider).projects[0];
                    ref.watch(ProviderList.projectProvider).setState();
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => items[index]['screen'],
                    ),
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Row(
                  children: [
                    Image.asset(
                      items[index]['icon'],
                      height: 20,
                      width: 20,
                      color: themeProvider.isDarkThemeEnabled
                          ? Colors.white
                          : Colors.black,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    CustomText(
                      items[index]['title'],
                      type: FontStyle.Medium,
                    ),
                  ],
                ),
              ),
            );
          },
        )
      ],
    );
  }

  Widget inboxWidget() {
    return Container();
  }

  Widget helpWidget() {
    var themeProvider = ref.watch(ProviderList.themeProvider);

    List items = [
      {
        'title': 'Open Plane documentation',
        'url': 'https://docs.plane.so/',
        'icon': 'assets/images/global_search_icons/document.png'
      },
      {
        'title': 'Join Discord',
        'url': 'https://discord.com/invite/A92xrEGCge',
        'icon': 'assets/images/global_search_icons/discord.png'
      },
      {
        'title': 'Report a bug',
        'url': 'https://github.com/makeplane/plane-mobile/issues',
        'icon': 'assets/images/global_search_icons/report.png'
      },
      {
        'title': 'Chat with us',
        'url': '',
        'icon': 'assets/images/global_search_icons/chat.png'
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        CustomText(
          'Help',
          type: FontStyle.Medium,
          color: themeProvider.isDarkThemeEnabled ? Colors.white : greyColor,
        ),
        const SizedBox(
          height: 20,
        ),
        ListView.builder(
          shrinkWrap: true,
          primary: false,
          itemCount: items.length,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () async {
                try {
                  await launchUrl(Uri.parse(items[index]['url']));
                } catch (e) {
                  log(e.toString());
                  CustomToast().showSimpleToast(
                      'Something went wrong, please try again');
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Row(
                  children: [
                    Image.asset(
                      items[index]['icon'],
                      height: 20,
                      width: 20,
                      color: themeProvider.isDarkThemeEnabled
                          ? Colors.white
                          : Colors.black,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    CustomText(
                      items[index]['title'],
                      type: FontStyle.Medium,
                    ),
                  ],
                ),
              ),
            );
          },
        )
      ],
    );
  }

  Widget issuesList() {
    var globalSearchProvider = ref.watch(ProviderList.globalSearchProvider);
    var themeProvider = ref.watch(ProviderList.themeProvider);
    if (globalSearchProvider.globalSearchState == StateEnum.loading) {
      return Container();
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            'Issues',
            type: FontStyle.Medium,
            fontWeight: FontWeightt.Semibold,
            color: themeProvider.isDarkThemeEnabled ? Colors.white : greyColor,
          ),
          const SizedBox(
            height: 20,
          ),
          globalSearchProvider.data!.issues.isEmpty
              ? const Center(
                  child: CustomText('No issues found'),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: globalSearchProvider.data!.issues.length,
                  // globalSearchProvider.data!.issues.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () async {
                        ref
                                .watch(ProviderList.projectProvider)
                                .currentProject['id'] =
                            globalSearchProvider.data!.issues[index].projectId;
                        await ref
                            .read(ProviderList.projectProvider)
                            .initializeProject();

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => IssueDetail(
                              appBarTitle:
                                  globalSearchProvider.data!.issues[index].name,
                              issueId:
                                  globalSearchProvider.data!.issues[index].id,
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/global_search_icons/issue.png',
                              width: 20,
                              height: 20,
                              color: themeProvider.isDarkThemeEnabled
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              width: width * 0.8,
                              child: CustomText(
                                globalSearchProvider.data!.issues[index].name,
                                type: FontStyle.Medium,
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ],
      );
    }
  }

  Widget projectsListWidget() {
    var globalSearchProvider = ref.watch(ProviderList.globalSearchProvider);
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var projectProvider = ref.watch(ProviderList.projectProvider);
    if (globalSearchProvider.globalSearchState == StateEnum.loading) {
      return Container();
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          CustomText(
            'Projects',
            type: FontStyle.Medium,
            fontWeight: FontWeightt.Semibold,
            color: themeProvider.isDarkThemeEnabled ? Colors.white : greyColor,
          ),
          const SizedBox(
            height: 20,
          ),
          globalSearchProvider.data!.projects.isEmpty
              ? const Center(child: CustomText('No projects found'))
              : ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: globalSearchProvider.data!.projects.length,
                  // globalSearchProvider.data!.issues.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        projectProvider.currentProject['id'] =
                            globalSearchProvider.data!.projects[index].id;
                        projectProvider.currentProject['name'] =
                            globalSearchProvider.data!.projects[index].name;
                        projectProvider.currentProject['identifier'] =
                            globalSearchProvider
                                .data!.projects[index].identifier;
                        projectProvider.currentProject["index"] = index;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProjectDetail(
                              index: index,
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/global_search_icons/project.png',
                              width: 20,
                              height: 20,
                              color: themeProvider.isDarkThemeEnabled
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                                width: width * 0.8,
                                child: CustomText(
                                  globalSearchProvider
                                      .data!.projects[index].name,
                                  type: FontStyle.Medium,
                                  maxLines: 2,
                                )),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ],
      );
    }
  }

  Widget workspaceListWidget() {
    var globalSearchProvider = ref.watch(ProviderList.globalSearchProvider);
    var globalSearchProviderRead =
        ref.read(ProviderList.globalSearchProvider.notifier);
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var workspaceProv = ref.watch(ProviderList.workspaceProvider);
    var profileProvider = ref.watch(ProviderList.profileProvider);
    if (globalSearchProvider.globalSearchState == StateEnum.loading) {
      return Container();
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          CustomText(
            'Workspaces',
            type: FontStyle.Medium,
            fontWeight: FontWeightt.Semibold,
            color: themeProvider.isDarkThemeEnabled ? Colors.white : greyColor,
          ),
          const SizedBox(
            height: 20,
          ),
          globalSearchProvider.data!.workspaces.isEmpty
              ? const Center(child: CustomText('No workspaces found'))
              : ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: globalSearchProvider.data!.workspaces.length,
                  // globalSearchProvider.data!.issues.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () async {
                        await workspaceProv
                            .selectWorkspace(
                                id: globalSearchProvider
                                    .data!.workspaces[index].id)
                            .then(
                          (value) async {
                            ref.watch(ProviderList.cyclesProvider).clearData();
                            ref.watch(ProviderList.modulesProvider).clearData();
                            ref.watch(ProviderList.projectProvider).getProjects(
                                slug: ref
                                    .watch(ProviderList.workspaceProvider)
                                    .workspaces
                                    .where((element) =>
                                        element['id'] ==
                                        profileProvider
                                            .userProfile.lastWorkspaceId)
                                    .first['slug']);
                            ref
                                .watch(ProviderList.projectProvider)
                                .favouriteProjects(
                                  index: 0,
                                  slug: ref
                                      .watch(ProviderList.workspaceProvider)
                                      .workspaces
                                      .where((element) =>
                                          element['id'] ==
                                          profileProvider
                                              .userProfile.lastWorkspaceId)
                                      .first['slug'],
                                  method: HttpMethod.get,
                                  projectID: "",
                                );
                            ref
                                .watch(ProviderList.myIssuesProvider)
                                .getMyIssues(
                                  slug: ref
                                      .watch(ProviderList.workspaceProvider)
                                      .selectedWorkspace!
                                      .workspaceSlug,
                                );
                          },
                        );
                        globalSearchProvider.data = null;
                        globalSearchProviderRead.setState();
                        Navigator.of(Const.globalKey.currentContext!).pop();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Row(
                          children: [
                            Icon(
                              Icons.grid_view_outlined,
                              size: 16,
                              color: themeProvider.isDarkThemeEnabled
                                  ? darkPrimaryTextColor
                                  : lightPrimaryTextColor,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                                width: width * 0.8,
                                child: CustomText(
                                  globalSearchProvider
                                      .data!.workspaces[index].name,
                                  type: FontStyle.Medium,
                                  maxLines: 2,
                                )),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ],
      );
    }
  }

  Widget cyclesListWidget() {
    var globalSearchProvider = ref.watch(ProviderList.globalSearchProvider);
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var cyclesProvider = ref.watch(ProviderList.cyclesProvider);
    if (globalSearchProvider.globalSearchState == StateEnum.loading) {
      return Container();
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          CustomText(
            'Cycles',
            type: FontStyle.Medium,
            fontWeight: FontWeightt.Semibold,
            color: themeProvider.isDarkThemeEnabled ? Colors.white : greyColor,
          ),
          const SizedBox(
            height: 20,
          ),
          globalSearchProvider.data!.cycles.isEmpty
              ? const Center(child: CustomText('No cycles found'))
              : ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: globalSearchProvider.data!.cycles.length,
                  // globalSearchProvider.data!.issues.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () async {
                        ref
                                .watch(ProviderList.projectProvider)
                                .currentProject['id'] =
                            globalSearchProvider.data!.cycles[index].projectId;
                        await ref
                            .read(ProviderList.projectProvider)
                            .initializeProject();
                        cyclesProvider.currentCycle['id'] =
                            globalSearchProvider.data!.cycles[index].id;
                        cyclesProvider.currentCycle['name'] =
                            globalSearchProvider.data!.cycles[index].name;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CycleDetail(
                              cycleId:
                                  globalSearchProvider.data!.cycles[index].id,
                              cycleName:
                                  globalSearchProvider.data!.cycles[index].name,
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                              'assets/svg_images/cycles_icon.svg',
                              height: 20,
                              width: 20,
                              color: themeProvider.isDarkThemeEnabled
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            // Icon(
                            //   Icons.work_outline,
                            //   size: 16,
                            //   color: themeProvider.isDarkThemeEnabled
                            //       ? darkPrimaryTextColor
                            //       : lightPrimaryTextColor,
                            // ),
                            const SizedBox(
                              width: 5,
                            ),
                            SizedBox(
                                width: width * 0.8,
                                child: CustomText(
                                  globalSearchProvider.data!.cycles[index].name,
                                  type: FontStyle.Medium,
                                  maxLines: 2,
                                )),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ],
      );
    }
  }

  Widget modulesListWidget() {
    var globalSearchProvider = ref.watch(ProviderList.globalSearchProvider);
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var modulesProvider = ref.watch(ProviderList.modulesProvider);
    if (globalSearchProvider.globalSearchState == StateEnum.loading) {
      return Container();
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          CustomText(
            'Modules',
            type: FontStyle.Medium,
            fontWeight: FontWeightt.Semibold,
            color: themeProvider.isDarkThemeEnabled ? Colors.white : greyColor,
          ),
          const SizedBox(
            height: 20,
          ),
          globalSearchProvider.data!.modules.isEmpty
              ? const Center(child: CustomText('No modules found'))
              : ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: globalSearchProvider.data!.modules.length,
                  // globalSearchProvider.data!.issues.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () async {
                        ref
                                .watch(ProviderList.projectProvider)
                                .currentProject['id'] =
                            globalSearchProvider.data!.modules[index].projectId;
                        await ref
                            .read(ProviderList.projectProvider)
                            .initializeProject();
                        modulesProvider.currentModule['id'] =
                            globalSearchProvider.data!.modules[index].id;
                        modulesProvider.currentModule['name'] =
                            globalSearchProvider.data!.modules[index].name;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CycleDetail(
                              moduleId:
                                  globalSearchProvider.data!.modules[index].id,
                              moduleName: globalSearchProvider
                                  .data!.modules[index].name,
                              fromModule: true,
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/global_search_icons/module.png',
                              width: 20,
                              height: 20,
                              color: themeProvider.isDarkThemeEnabled
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                                width: width * 0.8,
                                child: CustomText(
                                  globalSearchProvider
                                      .data!.modules[index].name,
                                  type: FontStyle.Medium,
                                  maxLines: 2,
                                )),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ],
      );
    }
  }

  Widget viewsListWidget() {
    var globalSearchProvider = ref.watch(ProviderList.globalSearchProvider);
    var themeProvider = ref.watch(ProviderList.themeProvider);
    if (globalSearchProvider.globalSearchState == StateEnum.loading) {
      return Container();
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          CustomText(
            'Views',
            type: FontStyle.Medium,
            fontWeight: FontWeightt.Semibold,
            color: themeProvider.isDarkThemeEnabled ? Colors.white : greyColor,
          ),
          const SizedBox(
            height: 20,
          ),
          globalSearchProvider.data!.views.isEmpty
              ? const Center(child: CustomText('No views found'))
              : ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: globalSearchProvider.data!.views.length,
                  // globalSearchProvider.data!.issues.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/global_search_icons/view.png',
                            width: 20,
                            height: 20,
                            color: themeProvider.isDarkThemeEnabled
                                ? Colors.white
                                : Colors.black,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                              width: width * 0.8,
                              child: CustomText(
                                globalSearchProvider.data!.views[index].name,
                                type: FontStyle.Medium,
                                maxLines: 2,
                              )),
                        ],
                      ),
                    );
                  },
                ),
        ],
      );
    }
  }

  Widget pagesListWidget() {
    var globalSearchProvider = ref.watch(ProviderList.globalSearchProvider);
    var themeProvider = ref.watch(ProviderList.themeProvider);
    if (globalSearchProvider.globalSearchState == StateEnum.loading) {
      return Container();
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          CustomText(
            'Pages',
            type: FontStyle.Medium,
            fontWeight: FontWeightt.Semibold,
            color: themeProvider.isDarkThemeEnabled ? Colors.white : greyColor,
          ),
          const SizedBox(
            height: 20,
          ),
          globalSearchProvider.data!.pages.isEmpty
              ? const Center(child: CustomText('No pages found'))
              : ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: globalSearchProvider.data!.pages.length,
                  // globalSearchProvider.data!.issues.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/global_search_icons/page.png',
                            width: 20,
                            height: 20,
                            color: themeProvider.isDarkThemeEnabled
                                ? Colors.white
                                : Colors.black,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                              width: width * 0.8,
                              child: CustomText(
                                globalSearchProvider.data!.pages[index].name,
                                type: FontStyle.Medium,
                                maxLines: 2,
                              )),
                        ],
                      ),
                    );
                  },
                ),
        ],
      );
    }
  }
}
