import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:plane/bottom_sheets/global_search_sheet.dart';
import 'package:plane/provider/projects_provider.dart';
import 'package:plane/provider/theme_provider.dart';
import 'package:plane/screens/MainScreens/Projects/ProjectDetail/project_detail.dart';
import 'package:plane/screens/MainScreens/Projects/create_project_screen.dart';
import 'package:plane/utils/color_manager.dart';
import 'package:plane/utils/constants.dart';
import 'package:plane/utils/custom_toast.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/custom_app_bar.dart';
import 'package:plane/widgets/empty.dart';
import 'package:plane/widgets/error_state.dart';
import 'package:plane/widgets/loading_widget.dart';
import 'package:plane/provider/provider_list.dart';

import 'package:plane/widgets/custom_text.dart';

class ProjectScreen extends ConsumerStatefulWidget {
  const ProjectScreen({super.key});

  @override
  ConsumerState<ProjectScreen> createState() => _ProjectScreenState();
}

@override
class _ProjectScreenState extends ConsumerState<ProjectScreen>
    with TickerProviderStateMixin {
  int selected = 0;
  late TabController controller;

  @override
  void initState() {
    controller = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var projectProvider = ref.watch(ProviderList.projectProvider);
    var workspaceProvider = ref.watch(ProviderList.workspaceProvider);
    return Scaffold(
        appBar: CustomAppBar(
          onPressed: () {},
          text: 'Projects',
          centerTitle: false,
          leading: false,
          fontType: FontStyle.H4,
          elevation: false,
          actions: [
            workspaceProvider.role != Role.admin &&
                    workspaceProvider.role != Role.member
                ? Container()
                : GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreateProject(),
                        ),
                      );
                    },
                    child: CircleAvatar(
                      backgroundColor: themeProvider
                          .themeManager.primaryBackgroundSelectedColour,
                      radius: 20,
                      child: Icon(
                        size: 20,
                        Icons.add,
                        color: themeProvider.themeManager.secondaryTextColor,
                      ),
                    ),
                  ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const GlobalSearchSheet()));
              },
              child: CircleAvatar(
                backgroundColor:
                    themeProvider.themeManager.primaryBackgroundSelectedColour,
                radius: 20,
                child: Icon(
                  size: 20,
                  Icons.search,
                  color: themeProvider.themeManager.secondaryTextColor,
                ),
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
        body: projectProvider.getProjectState == StateEnum.error
            ? errorState(
                context: context,
                ontap: () {
                  refresh();
                },
              )
            : LoadingWidget(
                loading: projectProvider.getProjectState == StateEnum.loading,
                widgetClass: projectProvider.projects.isEmpty &&
                        projectProvider.starredProjects.isEmpty
                    ? EmptyPlaceholder.emptyProject(context, refresh, ref)
                    : Column(
                        children: [
                          TabBar(
                              controller: controller,
                              indicatorColor:
                                  themeProvider.themeManager.primaryColour,
                              indicatorWeight: 6,
                              unselectedLabelStyle: GoogleFonts.inter(
                                  letterSpacing:
                                      -(fontSIZE[FontStyle.Medium]! * 0.02),
                                  height: lineHeight[FontStyle.Medium],
                                  fontSize: fontSIZE[FontStyle.Medium],
                                  color: themeProvider
                                      .themeManager.placeholderTextColor),
                              labelStyle: GoogleFonts.inter(
                                  letterSpacing:
                                      -(fontSIZE[FontStyle.Medium]! * 0.02),
                                  height: lineHeight[FontStyle.Medium],
                                  fontSize: fontSIZE[FontStyle.Medium],
                                  fontWeight: FontWeight.w500,
                                  color:
                                      themeProvider.themeManager.primaryColour),
                              unselectedLabelColor: themeProvider
                                  .themeManager.placeholderTextColor,
                              labelColor:
                                  themeProvider.themeManager.primaryColour,
                              tabs: const [
                                Tab(
                                  text: 'Projects',
                                ),
                                Tab(
                                  text: 'Favorites',
                                ),
                                Tab(
                                  text: 'Unjoined',
                                ),
                              ]),
                          Container(
                            height: 1,
                            width: double.infinity,
                            color:
                                themeProvider.themeManager.borderSubtle01Color,
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 15, right: 15),
                              child: TabBarView(
                                controller: controller,
                                children: [
                                  allJoinedProjects(
                                      projectProvider, themeProvider),
                                  starredProjects(
                                      projectProvider, themeProvider),
                                  unJoinedProjects(
                                      projectProvider, themeProvider),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
              ));
  }

  Future refresh() async {
    var projectProvider = ref.read(ProviderList.projectProvider);
    await projectProvider.getProjects(
        slug: ref
            .read(ProviderList.workspaceProvider)
            .selectedWorkspace
            .workspaceSlug);
    setState(() {
      selected = 0;
    });
  }

  Widget unstarredProjects(
      ProjectsProvider projectProvider, ThemeProvider themeProvider) {
    return LoadingWidget(
      loading: false, //projectProvider.projectState == StateEnum.loading,
      widgetClass: checkUnstarredProject(projects: projectProvider.projects)
          ? RefreshIndicator(
              color: themeProvider.themeManager.primaryColour,
              backgroundColor:
                  themeProvider.themeManager.primaryBackgroundDefaultColor,
              onRefresh: refresh,
              child: ListView.separated(
                padding: const EdgeInsets.only(bottom: 20, top: 20),
                physics: const AlwaysScrollableScrollPhysics(),
                shrinkWrap: false,
                separatorBuilder: (context, index) {
                  return projectProvider.projects[index]['is_favorite'] ==
                              true ||
                          projectProvider.projects[index]['is_member'] == false
                      ? Container()
                      : Container(
                          margin: const EdgeInsets.only(top: 10, bottom: 10),
                          child: Divider(
                              height: 1,
                              thickness: 1,
                              indent: 0,
                              endIndent: 0,
                              color: themeProvider
                                  .themeManager.borderSubtle01Color),
                        );
                },
                itemCount: projectProvider.projects.length,
                itemBuilder: (context, index) {
                  return projectProvider.projects[index]['is_favorite'] ==
                              true ||
                          projectProvider.projects[index]['is_member'] == false
                      ? Container()
                      : ListTile(
                          onTap: () {
                            if (projectProvider.currentProject !=
                                projectProvider.projects[index]) {
                              ref.read(ProviderList.issuesProvider).clearData();
                            }
                            projectProvider.currentProject =
                                projectProvider.projects[index];
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
                          contentPadding: EdgeInsets.zero,
                          leading: Container(
                            height: 54,
                            width: 54,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: ColorManager.getColorWithIndex(index),
                            ),
                            child: Center(
                              child: projectProvider.projects[index]
                                          ['icon_prop'] !=
                                      null
                                  ? Icon(
                                      iconList[projectProvider.projects[index]
                                          ['icon_prop']['name']],
                                      color: projectProvider.projects[index]
                                                  ['icon_prop']["color"] !=
                                              null
                                          ? Color(
                                              int.parse(
                                                projectProvider.projects[index]
                                                        ['icon_prop']["color"]
                                                    .toString()
                                                    .replaceAll('#', '0xFF'),
                                              ),
                                            )
                                          : Color(
                                              int.parse(
                                                '#3A3A3A'
                                                    .replaceAll('#', '0xFF'),
                                              ),
                                            ))
                                  : Text(
                                      int.tryParse(projectProvider
                                                  .projects[index]['emoji']
                                                  .toString()) !=
                                              null
                                          ? String.fromCharCode(int.parse(
                                              projectProvider.projects[index]
                                                  ['emoji']))
                                          : '🚀',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                      ),
                                    ),
                            ),
                          ),
                          title: Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: CustomText(
                              projectProvider.projects[index]['name'],
                              // color: themeProvider.primaryTextColor,

                              type: FontStyle.H6,
                              fontWeight: FontWeightt.Medium,
                              color:
                                  themeProvider.themeManager.primaryTextColor,
                              textAlign: TextAlign.start,
                              maxLines: 1,
                            ),
                          ),
                          subtitle: Row(
                            children: [
                              CustomText(
                                projectProvider.projects[index]['is_member']
                                    ? 'Member'
                                    : 'Not a Member',
                                // color: themeProvider.strokeColor,
                                type: FontStyle.Medium,
                                fontWeight: FontWeightt.Medium,
                                color: themeProvider
                                    .themeManager.placeholderTextColor,
                              ),
                              const SizedBox(width: 10),
                              //dot as a separator
                              CircleAvatar(
                                radius: 3,
                                backgroundColor: themeProvider
                                    .themeManager.borderSubtle01Color,
                              ),
                              const SizedBox(width: 10),
                              CustomText(
                                DateFormat('d MMMM').format(DateTime.parse(
                                    projectProvider.projects[index]
                                        ['created_at'])),
                                // color: themeProvider.strokeColor,
                                type: FontStyle.Medium,
                                fontWeight: FontWeightt.Medium,
                                color: themeProvider
                                    .themeManager.placeholderTextColor,
                              ),
                            ],
                          ),
                          //clickable star icon
                          trailing: Container(
                              margin: const EdgeInsets.only(right: 15),
                              height: 25,
                              width: 25,
                              child: Center(
                                child: projectProvider.loadingProjectIndex
                                        .contains(index)
                                    ? Padding(
                                        padding: const EdgeInsets.all(2),
                                        child: CircularProgressIndicator(
                                          color: themeProvider.themeManager
                                              .placeholderTextColor,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : IconButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: () async {
                                          await projectProvider.favouriteProjects(
                                              index: index,
                                              slug: ref
                                                  .read(ProviderList
                                                      .workspaceProvider)
                                                  .workspaces
                                                  .where((element) =>
                                                      element['id'] ==
                                                      ref
                                                          .read(ProviderList
                                                              .profileProvider)
                                                          .userProfile
                                                          .lastWorkspaceId)
                                                  .first['slug'],
                                              method: HttpMethod.post,
                                              projectID: projectProvider
                                                  .projects[index]["id"]);

                                          if (projectProvider.projectState !=
                                              StateEnum.success) {
                                            // ignore: use_build_context_synchronously
                                            CustomToast.showToast(context,
                                                message: "Something went wrong",
                                                toastType: ToastType.failure);
                                          } else {
                                            // ignore: use_build_context_synchronously
                                            CustomToast.showToast(context,
                                                message:
                                                    "Project favourited successfully",
                                                toastType: ToastType.success);
                                          }
                                        },
                                        icon: Icon(
                                          Icons.star_border,
                                          size: 25,
                                          color: themeProvider.themeManager
                                              .placeholderTextColor,
                                        ),
                                      ),
                              )),
                        );
                },
              ),
            )
          : EmptyPlaceholder.emptyUnstaredProject(context, ref, refresh),
    );
  }

  Widget allJoinedProjects(
      ProjectsProvider projectProvider, ThemeProvider themeProvider) {
    return LoadingWidget(
      loading: false, //projectProvider.projectState == StateEnum.loading,
      widgetClass: checkAllJoinedProject(projects: projectProvider.projects)
          ? RefreshIndicator(
              color: themeProvider.themeManager.primaryColour,
              backgroundColor:
                  themeProvider.themeManager.primaryBackgroundDefaultColor,
              onRefresh: refresh,
              child: ListView.separated(
                padding: const EdgeInsets.only(bottom: 20, top: 20),
                physics: const AlwaysScrollableScrollPhysics(),
                shrinkWrap: false,
                separatorBuilder: (context, index) {
                  return projectProvider.projects[index]['is_member'] == false
                      ? Container()
                      : Container(
                          margin: const EdgeInsets.only(top: 10, bottom: 10),
                          child: Divider(
                              height: 1,
                              thickness: 1,
                              indent: 0,
                              endIndent: 0,
                              color: themeProvider
                                  .themeManager.borderSubtle01Color),
                        );
                },
                itemCount: projectProvider.projects.length,
                itemBuilder: (context, index) {
                  return projectProvider.projects[index]['is_member'] == false
                      ? Container()
                      : ListTile(
                          onTap: () {
                            if (projectProvider.currentProject !=
                                projectProvider.projects[index]) {
                              ref.read(ProviderList.issuesProvider).clearData();
                            }
                            projectProvider.currentProject =
                                projectProvider.projects[index];
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
                          contentPadding: EdgeInsets.zero,
                          leading: Container(
                            height: 54,
                            width: 54,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: ColorManager.getColorWithIndex(index),
                            ),
                            child: Center(
                              child: projectProvider.projects[index]
                                          ['icon_prop'] !=
                                      null
                                  ? Icon(
                                      iconList[projectProvider.projects[index]
                                          ['icon_prop']['name']],
                                      color: projectProvider.projects[index]
                                                  ['icon_prop']["color"] !=
                                              null
                                          ? Color(
                                              int.parse(
                                                projectProvider.projects[index]
                                                        ['icon_prop']["color"]
                                                    .toString()
                                                    .replaceAll('#', '0xFF'),
                                              ),
                                            )
                                          : Color(
                                              int.parse(
                                                '#3A3A3A'
                                                    .replaceAll('#', '0xFF'),
                                              ),
                                            ))
                                  : Text(
                                      int.tryParse(projectProvider
                                                  .projects[index]['emoji']
                                                  .toString()) !=
                                              null
                                          ? String.fromCharCode(int.parse(
                                              projectProvider.projects[index]
                                                  ['emoji']))
                                          : '🚀',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                      ),
                                    ),
                            ),
                          ),
                          title: Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: CustomText(
                              projectProvider.projects[index]['name'],
                              // color: themeProvider.primaryTextColor,

                              type: FontStyle.H6,
                              fontWeight: FontWeightt.Medium,
                              color:
                                  themeProvider.themeManager.primaryTextColor,
                              textAlign: TextAlign.start,
                              maxLines: 1,
                            ),
                          ),
                          subtitle: Row(
                            children: [
                              CustomText(
                                projectProvider.projects[index]['is_member']
                                    ? 'Member'
                                    : 'Not a Member',
                                // color: themeProvider.strokeColor,
                                type: FontStyle.Medium,
                                fontWeight: FontWeightt.Medium,
                                color: themeProvider
                                    .themeManager.placeholderTextColor,
                              ),
                              const SizedBox(width: 10),
                              //dot as a separator
                              CircleAvatar(
                                radius: 3,
                                backgroundColor: themeProvider
                                    .themeManager.borderSubtle01Color,
                              ),
                              const SizedBox(width: 10),
                              CustomText(
                                DateFormat('d MMMM').format(DateTime.parse(
                                    projectProvider.projects[index]
                                        ['created_at'])),
                                type: FontStyle.Medium,
                                fontWeight: FontWeightt.Medium,
                                color: themeProvider
                                    .themeManager.placeholderTextColor,
                              ),
                            ],
                          ),
                          //clickable star icon
                          trailing: Container(
                              margin: const EdgeInsets.only(right: 15),
                              height: 25,
                              width: 25,
                              child: Center(
                                child: projectProvider.loadingProjectIndex
                                        .contains(index)
                                    ? Padding(
                                        padding: const EdgeInsets.all(2),
                                        child: CircularProgressIndicator(
                                          color: themeProvider.themeManager
                                              .placeholderTextColor,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : IconButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: projectProvider
                                                        .projects[index]
                                                    ['is_favorite'] ==
                                                false
                                            ? () async {
                                                await projectProvider.favouriteProjects(
                                                    index: index,
                                                    slug: ref
                                                        .read(ProviderList
                                                            .workspaceProvider)
                                                        .workspaces
                                                        .where((element) =>
                                                            element['id'] ==
                                                            ref
                                                                .read(ProviderList
                                                                    .profileProvider)
                                                                .userProfile
                                                                .lastWorkspaceId)
                                                        .first['slug'],
                                                    method: HttpMethod.post,
                                                    projectID: projectProvider
                                                        .projects[index]["id"]);

                                                if (projectProvider
                                                        .projectState !=
                                                    StateEnum.success) {
                                                  // ignore: use_build_context_synchronously
                                                  CustomToast.showToast(context,
                                                      message:
                                                          "Something went wrong",
                                                      toastType:
                                                          ToastType.failure);
                                                } else {
                                                  // ignore: use_build_context_synchronously
                                                  CustomToast.showToast(context,
                                                      message:
                                                          "Successfully Added the project to favourites",
                                                      toastType:
                                                          ToastType.success);
                                                }
                                              }
                                            : () async {
                                                await projectProvider.favouriteProjects(
                                                    index: index,
                                                    slug: ref
                                                        .read(ProviderList
                                                            .workspaceProvider)
                                                        .workspaces
                                                        .where((element) =>
                                                            element['id'] ==
                                                            ref
                                                                .read(ProviderList
                                                                    .profileProvider)
                                                                .userProfile
                                                                .lastWorkspaceId)
                                                        .first['slug'],
                                                    method: HttpMethod.delete,
                                                    projectID: projectProvider
                                                        .projects[index]["id"]);
                                                if (projectProvider
                                                        .projectState !=
                                                    StateEnum.success) {
                                                  // ignore: use_build_context_synchronously
                                                  CustomToast.showToast(context,
                                                      message:
                                                          "Something went wrong",
                                                      toastType:
                                                          ToastType.failure);
                                                } else {
                                                  // ignore: use_build_context_synchronously
                                                  CustomToast.showToast(context,
                                                      message:
                                                          "Successfully removed the project from favourites",
                                                      toastType:
                                                          ToastType.success);
                                                }
                                              },
                                        icon: Icon(
                                          projectProvider.projects[index]
                                                      ['is_favorite'] ==
                                                  false
                                              ? Icons.star_border
                                              : Icons.star,
                                          size: 25,
                                          color: themeProvider
                                              .themeManager.tertiaryTextColor,
                                        ),
                                      ),
                              )),
                        );
                },
              ),
            )
          : EmptyPlaceholder.emptyUnstaredProject(context, ref, refresh),
    );
  }

  Widget starredProjects(
      ProjectsProvider projectProvider, ThemeProvider themeProvider) {
    return LoadingWidget(
      loading: false, //projectProvider.projectState == StateEnum.loading,
      widgetClass: checkStarredProjects(projects: projectProvider.projects)
          ? RefreshIndicator(
              color: themeProvider.themeManager.primaryColour,
              backgroundColor:
                  themeProvider.themeManager.primaryBackgroundDefaultColor,
              onRefresh: refresh,
              child: ListView.separated(
                padding: const EdgeInsets.only(bottom: 20, top: 20),
                physics: const AlwaysScrollableScrollPhysics(),
                shrinkWrap: false,
                separatorBuilder: (context, index) {
                  return projectProvider.projects[index]['is_favorite'] ==
                              false ||
                          projectProvider.projects[index]['is_member'] == false
                      ? Container()
                      : Container(
                          margin: const EdgeInsets.only(top: 10, bottom: 10),
                          child: Divider(
                              height: 1,
                              thickness: 1,
                              indent: 0,
                              endIndent: 0,
                              color: themeProvider
                                  .themeManager.borderSubtle01Color),
                        );
                },
                itemCount: projectProvider.projects.length,
                itemBuilder: (context, index) {
                  return projectProvider.projects[index]['is_favorite'] ==
                              false ||
                          projectProvider.projects[index]['is_member'] == false
                      ? Container()
                      : ListTile(
                          onTap: () {
                            if (projectProvider.currentProject !=
                                projectProvider.projects[index]) {
                              ref.read(ProviderList.issuesProvider).clearData();
                            }
                            projectProvider.currentProject =
                                projectProvider.projects[index];

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
                          contentPadding: EdgeInsets.zero,
                          leading: Container(
                            height: 54,
                            width: 54,
                            decoration: BoxDecoration(
                              color: ColorManager.getColorWithIndex(index),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: projectProvider.projects[index]
                                          ['icon_prop'] !=
                                      null
                                  ? Icon(
                                      iconList[projectProvider.projects[index]
                                          ['icon_prop']['name']],
                                      color: Color(
                                        int.parse(
                                          projectProvider.projects[index]
                                                  ['icon_prop']["color"]
                                              .toString()
                                              .replaceAll('#', '0xFF'),
                                        ),
                                      ),
                                    )
                                  : Text(
                                      int.tryParse(projectProvider
                                                  .projects[index]['emoji']
                                                  .toString()) !=
                                              null
                                          ? String.fromCharCode(int.parse(
                                              projectProvider.projects[index]
                                                  ['emoji']))
                                          : '🚀',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                      ),
                                    ),
                            ),
                          ),
                          title: Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: CustomText(
                              projectProvider.projects[index]['name'],
                              color:
                                  themeProvider.themeManager.primaryTextColor,
                              type: FontStyle.H6,
                              fontWeight: FontWeightt.Medium,
                              textAlign: TextAlign.start,
                              maxLines: 1,
                            ),
                          ),
                          subtitle: Row(
                            children: [
                              CustomText(
                                projectProvider.projects[index]['is_member']
                                    ? 'Member'
                                    : 'Not a Member',
                                type: FontStyle.Medium,
                                fontWeight: FontWeightt.Medium,
                                color: themeProvider
                                    .themeManager.placeholderTextColor,
                              ),
                              const SizedBox(width: 10),
                              //dot as a separator
                              CircleAvatar(
                                radius: 3,
                                backgroundColor: themeProvider
                                    .themeManager.borderSubtle01Color,
                              ),
                              const SizedBox(width: 10),
                              CustomText(
                                DateFormat('d MMMM').format(DateTime.parse(
                                    projectProvider.projects[index]
                                        ['created_at'])),
                                // color: themeProvider.strokeColor,
                                type: FontStyle.Medium,
                                fontWeight: FontWeightt.Medium,
                                color: themeProvider
                                    .themeManager.placeholderTextColor,
                                // fontSize: 16,
                              ),
                            ],
                          ),
                          //clickable star icon

                          trailing: Container(
                            height: 25,
                            width: 25,
                            margin: const EdgeInsets.only(right: 15),
                            child: Center(
                              child: projectProvider.loadingProjectIndex
                                      .contains(index)
                                  ? Padding(
                                      padding: const EdgeInsets.all(2),
                                      child: CircularProgressIndicator(
                                        color: themeProvider
                                            .themeManager.placeholderTextColor,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : IconButton(
                                      padding: EdgeInsets.zero,
                                      onPressed: () async {
                                        await projectProvider.favouriteProjects(
                                            index: index,
                                            slug: ref
                                                .read(ProviderList
                                                    .workspaceProvider)
                                                .workspaces
                                                .where((element) =>
                                                    element['id'] ==
                                                    ref
                                                        .read(ProviderList
                                                            .profileProvider)
                                                        .userProfile
                                                        .lastWorkspaceId)
                                                .first['slug'],
                                            method: HttpMethod.delete,
                                            projectID: projectProvider
                                                .projects[index]["id"]);
                                        if (projectProvider.projectState !=
                                            StateEnum.success) {
                                          // ignore: use_build_context_synchronously
                                          CustomToast.showToast(context,
                                              message: "Something went wrong",
                                              toastType: ToastType.failure);
                                        } else {
                                          // ignore: use_build_context_synchronously
                                          CustomToast.showToast(context,
                                              message:
                                                  "Project unfavourited successfully",
                                              toastType: ToastType.success);
                                        }
                                      },
                                      icon: Icon(Icons.star,
                                          size: 25,
                                          color: themeProvider
                                              .themeManager.tertiaryTextColor),
                                    ),
                            ),
                          ),
                        );
                },
              ),
            )
          : EmptyPlaceholder.emptyFavoriteProject(context, ref, refresh),
    );
  }

  Widget unJoinedProjects(
      ProjectsProvider projectProvider, ThemeProvider themeProvider) {
    return LoadingWidget(
      loading: projectProvider.projectState == StateEnum.loading,
      widgetClass: checkUnJoinedProject(projects: projectProvider.projects)
          ? RefreshIndicator(
              color: themeProvider.themeManager.primaryColour,
              backgroundColor:
                  themeProvider.themeManager.primaryBackgroundDefaultColor,
              onRefresh: refresh,
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 20, top: 20),
                shrinkWrap: false,
                separatorBuilder: (context, index) {
                  return projectProvider.projects[index]['is_member'] == true
                      ? Container()
                      : Container(
                          margin: const EdgeInsets.only(top: 10, bottom: 10),
                          child: Divider(
                              height: 1,
                              thickness: 1,
                              indent: 0,
                              endIndent: 0,
                              color: themeProvider
                                  .themeManager.borderSubtle01Color),
                        );
                },
                itemCount: projectProvider.projects.length,
                itemBuilder: (context, index) {
                  return projectProvider.projects[index]['is_member'] == true
                      ? Container()
                      : ListTile(
                          onTap: () {
                            if (projectProvider.currentProject !=
                                projectProvider.projects[index]) {
                              ref.read(ProviderList.issuesProvider).clearData();
                            }
                            projectProvider.currentProject =
                                projectProvider.projects[index];
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
                          contentPadding: EdgeInsets.zero,
                          leading: Container(
                            height: 54,
                            width: 54,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: ColorManager.getColorWithIndex(index),
                            ),
                            child: Center(
                              child: projectProvider.projects[index]
                                          ['icon_prop'] !=
                                      null
                                  ? Icon(
                                      iconList[projectProvider.projects[index]
                                          ['icon_prop']['name']],
                                      color: Color(
                                        int.parse(
                                          projectProvider.projects[index]
                                                  ['icon_prop']["color"]
                                              .toString()
                                              .replaceAll('#', '0xFF'),
                                        ),
                                      ),
                                    )
                                  : Text(
                                      int.tryParse(projectProvider
                                                  .projects[index]['emoji']
                                                  .toString()) !=
                                              null
                                          ? String.fromCharCode(int.parse(
                                              projectProvider.projects[index]
                                                  ['emoji']))
                                          : '🚀',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                      ),
                                    ),
                            ),
                          ),
                          title: Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: CustomText(
                              projectProvider.projects[index]['name'],
                              type: FontStyle.H6,
                              fontWeight: FontWeightt.Medium,
                              color:
                                  themeProvider.themeManager.primaryTextColor,
                              textAlign: TextAlign.start,
                              maxLines: 1,
                            ),
                          ),
                          subtitle: Row(
                            children: [
                              CustomText(
                                projectProvider.projects[index]['is_member']
                                    ? 'Member'
                                    : 'Not a Member',
                                type: FontStyle.Medium,
                                fontWeight: FontWeightt.Medium,
                                color: themeProvider
                                    .themeManager.placeholderTextColor,
                              ),
                              const SizedBox(width: 10),
                              //dot as a separator
                              CircleAvatar(
                                radius: 3,
                                backgroundColor: themeProvider
                                    .themeManager.borderSubtle01Color,
                              ),
                              const SizedBox(width: 10),
                              CustomText(
                                DateFormat('d MMMM').format(DateTime.parse(
                                    projectProvider.projects[index]
                                        ['created_at'])),
                                // color: themeProvider.strokeColor,
                                type: FontStyle.Medium,
                                fontWeight: FontWeightt.Medium,
                                color: themeProvider
                                    .themeManager.placeholderTextColor,
                              ),
                            ],
                          ),
                          //clickable star icon
                          trailing: Padding(
                            padding: const EdgeInsets.only(right: 15, left: 0),
                            child: Icon(
                              Icons.arrow_forward_ios,
                              size: 20,
                              color: themeProvider
                                  .themeManager.placeholderTextColor,
                            ),
                          ),
                        );
                },
              ),
            )
          : EmptyPlaceholder.emptyUnjoinedProject(context, ref, refresh),
    );
  }

  bool checkStarredProjects({List? projects}) {
    bool hasItems = false;
    for (var element in projects!) {
      if (element['is_favorite'] == true && element['is_member']) {
        setState(() {
          hasItems = true;
        });
        break;
      } else {
        setState(() {
          hasItems = false;
        });
      }
    }
    return hasItems;
  }

  bool checkUnstarredProject({List? projects}) {
    bool hasItems = false;
    for (var element in projects!) {
      if (element['is_favorite'] == false && element['is_member']) {
        setState(() {
          hasItems = true;
        });
        break;
      } else {
        setState(() {
          hasItems = false;
        });
      }
    }
    return hasItems;
  }

  bool checkAllJoinedProject({List? projects}) {
    bool hasItems = false;
    for (var element in projects!) {
      if (element['is_member']) {
        setState(() {
          hasItems = true;
        });
        break;
      } else {
        setState(() {
          hasItems = false;
        });
      }
    }
    return hasItems;
  }

  bool checkUnJoinedProject({List? projects}) {
    bool hasItems = false;
    for (var element in projects!) {
      if (element['is_member'] == false) {
        setState(() {
          hasItems = true;
        });
        break;
      } else {
        setState(() {
          hasItems = false;
        });
      }
    }
    return hasItems;
  }
}
