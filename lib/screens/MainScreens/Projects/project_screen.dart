import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:plane_startup/bottom_sheets/global_search_sheet.dart';
import 'package:plane_startup/screens/MainScreens/Projects/ProjectDetail/project_detail.dart';
import 'package:plane_startup/screens/MainScreens/Projects/create_project_screen.dart';
import 'package:plane_startup/utils/enums.dart';
import 'package:plane_startup/widgets/empty.dart';
import 'package:plane_startup/widgets/error_state.dart';
import 'package:plane_startup/widgets/loading_widget.dart';
import 'package:plane_startup/provider/provider_list.dart';

import 'package:plane_startup/widgets/custom_text.dart';

class ProjectScreen extends ConsumerStatefulWidget {
  const ProjectScreen({super.key});

  @override
  ConsumerState<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends ConsumerState<ProjectScreen> {
  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var projectProvider = ref.watch(ProviderList.projectProvider);
    var workspaceProvider = ref.watch(ProviderList.workspaceProvider);
    //   log(projectProvider.starredProjects.toString());
    return Scaffold(
      appBar: AppBar(
        //back ground color same as scaffold
        backgroundColor: Colors.transparent,

        elevation: 0,
        actions: const [
          //switch theme
        ],
        leadingWidth: 0,
        leading: const Text(''),
        title: Row(
          children: [
            CustomText(
              'Projects',
              type: FontStyle.H4,
              fontWeight: FontWeightt.Semibold,
              color: themeProvider.themeManager.primaryTextColor,
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                              .themeManager.tertiaryBackgroundDefaultColor,
                          radius: 20,
                          child: Icon(
                            size: 20,
                            Icons.add,
                            color:
                                themeProvider.themeManager.secondaryTextColor,
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
                    backgroundColor: themeProvider
                        .themeManager.tertiaryBackgroundDefaultColor,
                    radius: 20,
                    child: Icon(
                      size: 20,
                      Icons.search,
                      color: themeProvider.themeManager.secondaryTextColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: LoadingWidget(
          loading: projectProvider.projectState == StateEnum.loading,
          widgetClass: projectProvider.projectState == StateEnum.success
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: projectProvider.projects.isEmpty &&
                          projectProvider.starredProjects.isEmpty
                      ? Center(
                          child: EmptyPlaceholder.emptyProject(context, ref),
                        )
                      : SingleChildScrollView(
                          // physics: NeverScrollableScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              checkStarredProjects(
                                      projects: projectProvider.projects)
                                  ? const SizedBox(height: 10)
                                  : Container(),
                              checkStarredProjects(
                                      projects: projectProvider.projects)
                                  ? CustomText(
                                      'Favorites',
                                      type: FontStyle.Medium,
                                      fontWeight: FontWeightt.Medium,
                                      color: themeProvider
                                          .themeManager.placeholderTextColor,
                                    )
                                  : const SizedBox.shrink(),
                              checkStarredProjects(
                                      projects: projectProvider.projects)
                                  ? const SizedBox(height: 10)
                                  : const SizedBox.shrink(),
                              ListView.separated(
                                padding: checkStarredProjects(
                                        projects: projectProvider.projects)
                                    ? const EdgeInsets.only(bottom: 20)
                                    : EdgeInsets.zero,
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                separatorBuilder: (context, index) {
                                  return projectProvider.projects[index]
                                                  ['is_favorite'] ==
                                              false ||
                                          projectProvider.projects[index]
                                                  ['is_member'] ==
                                              false
                                      ? Container()
                                      : Container(
                                          margin: const EdgeInsets.only(
                                              top: 10, bottom: 10),
                                          child: Divider(
                                              height: 1,
                                              thickness: 1,
                                              indent: 0,
                                              endIndent: 0,
                                              color: themeProvider.themeManager
                                                  .borderDisabledColor
                                              // themeProvider.isDarkThemeEnabled
                                              //     ? darkThemeBorder
                                              //     : const Color.fromRGBO(
                                              //         238, 238, 238, 1),
                                              ),
                                        );
                                },
                                itemCount: projectProvider.projects.length,
                                itemBuilder: (context, index) {
                                  return projectProvider.projects[index]
                                                  ['is_favorite'] ==
                                              false ||
                                          projectProvider.projects[index]
                                                  ['is_member'] ==
                                              false
                                      ? Container()
                                      : ListTile(
                                          onTap: () {
                                            if (projectProvider
                                                    .currentProject !=
                                                projectProvider
                                                    .projects[index]) {
                                              ref
                                                  .read(ProviderList
                                                      .issuesProvider)
                                                  .clearData();
                                            }
                                            projectProvider.currentProject =
                                                projectProvider.projects[index];
                                            projectProvider
                                                    .currentProject["index"] =
                                                index;
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ProjectDetail(
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
                                              color: themeProvider.themeManager
                                                  .tertiaryBackgroundDefaultColor,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Center(
                                              child: Text(
                                                int.tryParse(projectProvider
                                                            .projects[index]
                                                                ['emoji']
                                                            .toString()) !=
                                                        null
                                                    ? String.fromCharCode(int
                                                        .parse(projectProvider
                                                                .projects[index]
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
                                            padding: const EdgeInsets.only(
                                                bottom: 8),
                                            // child: Text(
                                            //   starredProject[index].title,
                                            //   style: TextStyle(
                                            //     color: themeProvider.primaryTextColor,
                                            //     fontSize: 18,
                                            //     fontWeight: FontWeightt.Medium,
                                            //   ),
                                            // ),
                                            child: CustomText(
                                              projectProvider.projects[index]
                                                  ['name'],
                                              color: themeProvider.themeManager
                                                  .primaryTextColor,
                                              type: FontStyle.H6,
                                              fontWeight: FontWeightt.Medium,
                                              textAlign: TextAlign.start,
                                              maxLines: 1,
                                            ),
                                          ),
                                          subtitle: Row(
                                            children: [
                                              CustomText(
                                                projectProvider.projects[index]
                                                        ['is_member']
                                                    ? 'Member'
                                                    : 'Not a Member',
                                                type: FontStyle.Medium,
                                                fontWeight: FontWeightt.Medium,
                                                color: themeProvider
                                                    .themeManager
                                                    .placeholderTextColor,
                                              ),
                                              const SizedBox(width: 10),
                                              //dot as a separator
                                              CircleAvatar(
                                                radius: 3,
                                                backgroundColor: themeProvider
                                                    .themeManager
                                                    .borderStrong01Color,
                                              ),
                                              const SizedBox(width: 10),
                                              CustomText(
                                                DateFormat('d MMMM').format(
                                                    DateTime.parse(
                                                        projectProvider
                                                                .projects[index]
                                                            ['created_at'])),
                                                // color: themeProvider.strokeColor,
                                                type: FontStyle.Medium,
                                                fontWeight: FontWeightt.Medium,
                                                color: themeProvider
                                                    .themeManager
                                                    .placeholderTextColor,
                                                // fontSize: 16,
                                              ),
                                              // Text(
                                              //   starredProject[index].date,
                                              //   style: TextStyle(
                                              //     color: themeProvider.strokeColor,
                                              //     fontSize: 16,
                                              //     fontWeight: FontWeightt.Medium,
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                          //clickable star icon

                                          trailing: IconButton(
                                            onPressed: () {
                                              projectProvider.favouriteProjects(
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
                                            },
                                            icon: Icon(Icons.star,
                                                color: themeProvider
                                                    .themeManager
                                                    .secondaryIcon),
                                          ),
                                        );
                                },
                              ),
                              projectProvider.projects.isNotEmpty &&
                                      checkUnstarredProject(
                                          projects: projectProvider.projects)
                                  ? CustomText(
                                      'Projects',
                                      type: FontStyle.Medium,
                                      fontWeight: FontWeightt.Medium,
                                      color: themeProvider
                                          .themeManager.placeholderTextColor,
                                    )
                                  : Container(),
                              const SizedBox(height: 7),
                              ListView.separated(
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                separatorBuilder: (context, index) {
                                  return projectProvider.projects[index]
                                                  ['is_favorite'] ==
                                              true ||
                                          projectProvider.projects[index]
                                                  ['is_member'] ==
                                              false
                                      ? Container()
                                      : Container(
                                          margin: const EdgeInsets.only(
                                              top: 10, bottom: 10),
                                          child: Divider(
                                              height: 1,
                                              thickness: 1,
                                              indent: 0,
                                              endIndent: 0,
                                              color: themeProvider.themeManager
                                                  .borderDisabledColor),
                                        );
                                },
                                itemCount: projectProvider.projects.length,
                                itemBuilder: (context, index) {
                                  return projectProvider.projects[index]
                                                  ['is_favorite'] ==
                                              true ||
                                          projectProvider.projects[index]
                                                  ['is_member'] ==
                                              false
                                      ? Container()
                                      : ListTile(
                                          onTap: () {
                                            //   log(projectProvider.projects[index].toString());
                                            if (projectProvider
                                                    .currentProject !=
                                                projectProvider
                                                    .projects[index]) {
                                              ref
                                                  .read(ProviderList
                                                      .issuesProvider)
                                                  .clearData();
                                            }
                                            projectProvider.currentProject =
                                                projectProvider.projects[index];
                                            projectProvider
                                                    .currentProject["index"] =
                                                index;
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ProjectDetail(
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
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: themeProvider.themeManager
                                                  .tertiaryBackgroundDefaultColor,
                                            ),
                                            child: Center(
                                              child: Text(
                                                int.tryParse(projectProvider
                                                            .projects[index]
                                                                ['emoji']
                                                            .toString()) !=
                                                        null
                                                    ? String.fromCharCode(int
                                                        .parse(projectProvider
                                                                .projects[index]
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
                                            padding: const EdgeInsets.only(
                                                bottom: 8),
                                            // child: Text(
                                            //   allProject[index].title,
                                            //   style: TextStyle(
                                            //     color: themeProvider.primaryTextColor,
                                            //     fontSize: 18,
                                            //     fontWeight: FontWeightt.Medium,
                                            //   ),
                                            // ),
                                            child: CustomText(
                                              projectProvider.projects[index]
                                                  ['name'],
                                              // color: themeProvider.primaryTextColor,

                                              type: FontStyle.H6,
                                              fontWeight: FontWeightt.Medium,
                                              color: themeProvider.themeManager
                                                  .primaryTextColor,
                                              textAlign: TextAlign.start,
                                              maxLines: 1,
                                            ),
                                          ),
                                          subtitle: Row(
                                            children: [
                                              // Text(
                                              //   allProject[index].subtitle,
                                              //   style: TextStyle(
                                              //     color: themeProvider.strokeColor,
                                              //     fontSize: 16,
                                              //     fontWeight: FontWeightt.Medium,
                                              //   ),
                                              // ),
                                              CustomText(
                                                projectProvider.projects[index]
                                                        ['is_member']
                                                    ? 'Member'
                                                    : 'Not a Member',
                                                // color: themeProvider.strokeColor,
                                                type: FontStyle.Medium,
                                                fontWeight: FontWeightt.Medium,
                                                color: themeProvider
                                                    .themeManager
                                                    .placeholderTextColor,
                                              ),
                                              const SizedBox(width: 10),
                                              //dot as a separator
                                              CircleAvatar(
                                                radius: 3,
                                                backgroundColor: themeProvider
                                                    .themeManager
                                                    .borderStrong01Color,
                                              ),
                                              const SizedBox(width: 10),
                                              // Text(
                                              //   allProject[index].date,
                                              //   style: TextStyle(
                                              //     color: themeProvider.strokeColor,
                                              //     fontSize: 16,
                                              //     fontWeight: FontWeightt.Medium,
                                              //   ),
                                              // ),
                                              CustomText(
                                                DateFormat('d MMMM').format(
                                                    DateTime.parse(
                                                        projectProvider
                                                                .projects[index]
                                                            ['created_at'])),
                                                // color: themeProvider.strokeColor,
                                                type: FontStyle.Medium,
                                                fontWeight: FontWeightt.Medium,
                                                color: themeProvider
                                                    .themeManager
                                                    .placeholderTextColor,

                                                // fontSize: 16,
                                              ),
                                            ],
                                          ),
                                          //clickable star icon
                                          trailing: IconButton(
                                            onPressed: () {
                                              projectProvider.favouriteProjects(
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
                                            },
                                            icon: Icon(
                                              Icons.star_border,
                                              color: themeProvider.themeManager
                                                  .placeholderTextColor,
                                            ),
                                          ),
                                        );
                                },
                              ),
                              // ElevatedButton(
                              //     onPressed: () {
                              //       print('SABI : starredProjects.length : ' +
                              //           projectProvider.starredProjects.length
                              //               .toString());
                              //     },
                              //     child: Text('Stared Projects'))
                            ],
                          ),
                        ),
                )
              : errorState(context: context, showButton: false)),
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
}
