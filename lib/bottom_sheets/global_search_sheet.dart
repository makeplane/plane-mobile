// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:plane/config/const.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/screens/Import%20&%20Export/import_export.dart';
import 'package:plane/screens/MainScreens/Profile/WorkpsaceSettings/members.dart';
import 'package:plane/screens/MainScreens/Profile/WorkpsaceSettings/workspace_general.dart';
import 'package:plane/screens/MainScreens/Projects/ProjectDetail/CyclesTab/create_cycle.dart';
import 'package:plane/screens/MainScreens/Projects/ProjectDetail/CyclesTab/cycle_detail.dart';
import 'package:plane/screens/MainScreens/Projects/ProjectDetail/IssuesTab/CreateIssue/create_issue.dart';
import 'package:plane/screens/MainScreens/Projects/ProjectDetail/ModulesTab/create_module.dart';
import 'package:plane/screens/MainScreens/Projects/ProjectDetail/ViewsTab/views_detail.dart';
import 'package:plane/screens/MainScreens/Projects/ProjectDetail/project_detail.dart';
import 'package:plane/screens/MainScreens/Projects/create_project_screen.dart';
import 'package:plane/screens/create_view_screen.dart';
import 'package:plane/screens/integrations.dart';
import 'package:plane/screens/on_boarding/auth/join_workspaces.dart';
import 'package:plane/utils/constants.dart';
import 'package:plane/utils/custom_toast.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/custom_text.dart';
import 'package:url_launcher/url_launcher.dart';

import '../screens/MainScreens/Projects/ProjectDetail/IssuesTab/issue_detail.dart';

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

      final prov = ref.read(ProviderList.globalSearchProvider.notifier);
      if (input.text.isEmpty) {
        prov.clear();
      } else {
        log("HERE");
        prov.getGlobalData(
          slug: ref
              .read(ProviderList.workspaceProvider)
              .selectedWorkspace
              .workspaceSlug,
          input: input.text.trim(),
        );
      }
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(ProviderList.globalSearchProvider.notifier).clear();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = ref.watch(ProviderList.themeProvider);
    final globalSearchProvider = ref.watch(ProviderList.globalSearchProvider);
    final globalSearchProviderRead =
        ref.read(ProviderList.globalSearchProvider.notifier);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            color: themeProvider.themeManager.primaryBackgroundDefaultColor,
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
                            color:
                                themeProvider.themeManager.placeholderTextColor,
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            style: TextStyle(
                                color: themeProvider
                                    .themeManager.primaryTextColor),
                            controller: input,
                            decoration: themeProvider
                                .themeManager.textFieldDecoration
                                .copyWith(
                              fillColor: themeProvider
                                  .themeManager.tertiaryBackgroundDefaultColor,
                              focusColor: themeProvider
                                  .themeManager.tertiaryBackgroundDefaultColor,
                              filled: true,

                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 0),
                              suffixIcon: input.text != ''
                                  ? IconButton(
                                      onPressed: () {
                                        input.clear();
                                        globalSearchProvider.data = null;
                                        globalSearchProviderRead.clear();
                                      },
                                      icon: Icon(Icons.cancel,
                                          color: themeProvider.themeManager
                                              .placeholderTextColor))
                                  : IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.clear_outlined,
                                        color: Colors.transparent,
                                      )),

                              //filled: true,

                              hintText: 'Search for anything...',
                              hintStyle: TextStyle(
                                color: themeProvider
                                    .themeManager.placeholderTextColor,
                              ),
                              // fillColor: themeProvider
                              //     .themeManager.tertiaryBackgroundDefaultColor,
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
                                  colors: [
                                    themeProvider.themeManager.primaryTextColor
                                  ],
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
    final themeProvider = ref.watch(ProviderList.themeProvider);
    final List items = [
      {
        'title': 'New Issue',
        'screen': () async {
          ref.watch(ProviderList.projectProvider).currentProject =
              ref.watch(ProviderList.projectProvider).projects[0];
          ref.watch(ProviderList.projectProvider).setState();
          // await ref
          //     .read(ProviderList.projectProvider)
          //     .initializeProject(ref: ref);
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => CreateIssue(
                    projectId: ref
                        .read(ProviderList.projectProvider)
                        .projects[0]['id'],
                    fromMyIssues: true,
                  )));
        },
        'icon': 'assets/images/global_search_icons/issue.png'
      },
      {
        'title': 'New Project',
        'screen': () => {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const CreateProject()))
            },
        'icon': 'assets/images/global_search_icons/project.png'
      },
      {
        'title': 'New Cycle',
        'screen': () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const CreateCycle()));
        },
        'icon': 'assets/images/global_search_icons/cycle.png'
      },
      {
        'title': 'New Module',
        'screen': () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const CreateModule()));
        },
        'icon': 'assets/images/global_search_icons/module.png'
      },
      {
        'title': 'New View',
        'screen': () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const CreateView()));
        },
        'icon': 'assets/images/global_search_icons/view.png'
      },
      // {
      //   'title': 'New Page',
      //   'screen': () {
      //     Navigator.of(context).push(
      //         MaterialPageRoute(builder: (context) => const CreatePage()));
      //   },
      //   'icon': 'assets/images/global_search_icons/page.png'
      // },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          'Create',
          type: FontStyle.Medium,
          color: themeProvider.themeManager.placeholderTextColor,
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
                    CustomToast.showToast(
                      context,
                      message:
                          'You dont have any projects yet, try creating one',
                    );
                  } else if (ref
                          .watch(ProviderList.projectProvider)
                          .memberCount ==
                      0) {
                    CustomToast.showToast(
                      context,
                      message:
                          'You are not a member of any project, try joining one',
                    );
                  } else {
                    items[index]['screen']();
                  }
                } else {
                  items[index]['screen']();
                }
              },
              child: ((index == 2 || index == 3 || index == 4) &&
                      ref
                              .read(ProviderList.projectProvider)
                              .currentProject['id'] ==
                          null)
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Row(
                        children: [
                          Image.asset(
                            items[index]['icon'],
                            height: 20,
                            width: 20,
                            color: themeProvider.themeManager.primaryTextColor,
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
    final themeProvider = ref.watch(ProviderList.themeProvider);
    final workspaceProv = ref.watch(ProviderList.workspaceProvider);
    final List items = [
      {
        'title': 'General',
        'screen': () => {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const WorkspaceGeneral()))
            },
        'icon': 'assets/images/global_search_icons/general.png'
      },
      {
        'title': 'Members',
        'screen': () => {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const Members(
                        fromWorkspace: true,
                      )))
            },
        'icon': 'assets/images/global_search_icons/members.png'
      },
      // {
      //   'title': 'Billing & Plans',
      //   'screen': () => {
      //         Navigator.of(context).push(
      //             MaterialPageRoute(builder: (context) => const BillingPlans()))
      //       },
      //   'icon': 'assets/images/global_search_icons/billing&plans.png'
      // },
      {
        'title': 'Integrations',
        'screen': () => {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Integrations()))
            },
        'icon': 'assets/images/global_search_icons/integrations.png'
      },
      {
        'title': 'Imports & Exports',
        'screen': () => {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const ImportEport()))
            },
        'icon': 'assets/images/global_search_icons/imports&exports.png'
      },
      {
        'title': 'Workspace Invites',
        'screen': () => {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const JoinWorkspaces(
                        fromOnboard: false,
                      )))
            },
        'icon': 'assets/images/global_search_icons/workspace_invites.png'
      }
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          'Workspace Settings',
          type: FontStyle.Medium,
          color: themeProvider.themeManager.placeholderTextColor,
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
            return (index != 0 &&
                    index != 5 &&
                    workspaceProv.role != Role.admin)
                ? Container()
                : InkWell(
                    onTap: () async {
                      items[index]['screen']();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Row(
                        children: [
                          Image.asset(
                            items[index]['icon'],
                            height: 20,
                            width: 20,
                            color: themeProvider.themeManager.primaryTextColor,
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
    final themeProvider = ref.watch(ProviderList.themeProvider);

    final List items = [
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
      // {
      //   'title': 'Chat with us',
      //   'url': '',
      //   'icon': 'assets/images/global_search_icons/chat.png'
      // },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // const SizedBox(
        //   height: 20,
        // ),
        CustomText(
          'Help',
          type: FontStyle.Medium,
          color: themeProvider.themeManager.placeholderTextColor,
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
                  CustomToast.showToast(
                    context,
                    message: 'Something went wrong, please try again',
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
                      color: themeProvider.themeManager.primaryTextColor,
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
    final globalSearchProvider = ref.watch(ProviderList.globalSearchProvider);
    final themeProvider = ref.watch(ProviderList.themeProvider);
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
            color: themeProvider.themeManager.primaryTextColor,
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
                            .initializeProject(ref: ref);

                        Navigator.of(Const.globalKey.currentContext!).push(
                          MaterialPageRoute(
                            builder: (context) => IssueDetail(
                              from: PreviousScreen.globalSearch,
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
                              color:
                                  themeProvider.themeManager.primaryTextColor,
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
    final globalSearchProvider = ref.watch(ProviderList.globalSearchProvider);
    final themeProvider = ref.watch(ProviderList.themeProvider);
    final projectProvider = ref.watch(ProviderList.projectProvider);
    if (globalSearchProvider.globalSearchState == StateEnum.loading) {
      return Container();
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          const CustomText(
            'Projects',
            type: FontStyle.Medium,
            fontWeight: FontWeightt.Semibold,
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
                              color:
                                  themeProvider.themeManager.primaryTextColor,
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
    final globalSearchProvider = ref.watch(ProviderList.globalSearchProvider);
    final globalSearchProviderRead =
        ref.read(ProviderList.globalSearchProvider.notifier);
    final themeProvider = ref.watch(ProviderList.themeProvider);
    final workspaceProv = ref.watch(ProviderList.workspaceProvider);
    final profileProvider = ref.watch(ProviderList.profileProvider);
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
            color: themeProvider.themeManager.primaryTextColor,
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
                          id: globalSearchProvider.data!.workspaces[index].id,
                          context: context,
                        )
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
                                      .selectedWorkspace
                                      .workspaceSlug,
                                );
                          },
                        );
                        globalSearchProvider.data = null;
                        globalSearchProviderRead.clear();
                        Navigator.of(Const.globalKey.currentContext!).pop();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Row(
                          children: [
                            Icon(
                              Icons.grid_view_outlined,
                              size: 16,
                              color:
                                  themeProvider.themeManager.primaryTextColor,
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
    final globalSearchProvider = ref.watch(ProviderList.globalSearchProvider);
    final themeProvider = ref.watch(ProviderList.themeProvider);
    final cyclesProvider = ref.watch(ProviderList.cyclesProvider);
    if (globalSearchProvider.globalSearchState == StateEnum.loading) {
      return Container();
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          const CustomText(
            'Cycles',
            type: FontStyle.Medium,
            fontWeight: FontWeightt.Semibold,
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
                            .initializeProject(ref: ref);
                        cyclesProvider.currentCycle['id'] =
                            globalSearchProvider.data!.cycles[index].id;
                        cyclesProvider.currentCycle['name'] =
                            globalSearchProvider.data!.cycles[index].name;
                        Navigator.push(
                          Const.globalKey.currentContext!,
                          MaterialPageRoute(
                            builder: (context) => CycleDetail(
                              cycleId:
                                  globalSearchProvider.data!.cycles[index].id,
                              cycleName:
                                  globalSearchProvider.data!.cycles[index].name,
                              projId: globalSearchProvider
                                  .data!.cycles[index].projectId,
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
                                colorFilter: ColorFilter.mode(
                                    themeProvider
                                        .themeManager.placeholderTextColor,
                                    BlendMode.srcIn)),
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
    final globalSearchProvider = ref.watch(ProviderList.globalSearchProvider);
    final themeProvider = ref.watch(ProviderList.themeProvider);
    final modulesProvider = ref.watch(ProviderList.modulesProvider);
    if (globalSearchProvider.globalSearchState == StateEnum.loading) {
      return Container();
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          const CustomText(
            'Modules',
            type: FontStyle.Medium,
            fontWeight: FontWeightt.Semibold,
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
                            .initializeProject(ref: ref);
                        modulesProvider.currentModule['id'] =
                            globalSearchProvider.data!.modules[index].id;
                        modulesProvider.currentModule['name'] =
                            globalSearchProvider.data!.modules[index].name;
                        Navigator.push(
                          Const.globalKey.currentContext!,
                          MaterialPageRoute(
                            builder: (context) => CycleDetail(
                              moduleId:
                                  globalSearchProvider.data!.modules[index].id,
                              moduleName: globalSearchProvider
                                  .data!.modules[index].name,
                              projId: globalSearchProvider
                                  .data!.modules[index].projectId,
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
                              color:
                                  themeProvider.themeManager.primaryTextColor,
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
    final globalSearchProvider = ref.watch(ProviderList.globalSearchProvider);
    final themeProvider = ref.watch(ProviderList.themeProvider);
    if (globalSearchProvider.globalSearchState == StateEnum.loading) {
      return Container();
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          const CustomText(
            'Views',
            type: FontStyle.Medium,
            fontWeight: FontWeightt.Semibold,
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
                    return GestureDetector(
                      onTap: () async {
                        await ref
                            .read(ProviderList.viewsProvider.notifier)
                            .getViewDetail(
                                projId: globalSearchProvider
                                    .data!.views[index].projectId,
                                id: globalSearchProvider.data!.views[index].id);

                        Navigator.push(
                          Const.globalKey.currentContext!,
                          MaterialPageRoute(
                            builder: (context) => ViewsDetail(
                              index: 0,
                              viewID:
                                  globalSearchProvider.data!.views[index].id,
                              fromGlobalSearch: true,
                              projId: globalSearchProvider
                                  .data!.views[index].projectId,
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/global_search_icons/view.png',
                              width: 20,
                              height: 20,
                              color:
                                  themeProvider.themeManager.primaryTextColor,
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
                      ),
                    );
                  },
                ),
        ],
      );
    }
  }

  Widget pagesListWidget() {
    final globalSearchProvider = ref.watch(ProviderList.globalSearchProvider);
    final themeProvider = ref.watch(ProviderList.themeProvider);
    if (globalSearchProvider.globalSearchState == StateEnum.loading) {
      return Container();
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          const CustomText(
            'Pages',
            type: FontStyle.Medium,
            fontWeight: FontWeightt.Semibold,
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
                            color: themeProvider.themeManager.primaryTextColor,
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
