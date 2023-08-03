import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:plane_startup/bottom_sheets/global_search_sheet.dart';
import 'package:plane_startup/screens/MainScreens/Projects/ProjectDetail/project_detail.dart';
import 'package:plane_startup/screens/MainScreens/Projects/create_project_screen.dart';
import 'package:plane_startup/utils/enums.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/widgets/empty.dart';
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
            const CustomText(
              'Projects',
              // color: themeProvider.primaryTextColor,
              type: FontStyle.mainHeading,
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
                          backgroundColor: themeProvider.isDarkThemeEnabled
                              ? darkSecondaryBGC
                              : lightGreeyColor,
                          radius: 20,
                          child: Icon(
                            size: 20,
                            Icons.add,
                            color: !themeProvider.isDarkThemeEnabled
                                ? Colors.black
                                : Colors.white,
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
                    backgroundColor: themeProvider.isDarkThemeEnabled
                        ? darkSecondaryBGC
                        : lightGreeyColor,
                    radius: 20,
                    child: Icon(
                      size: 20,
                      Icons.search,
                      color: !themeProvider.isDarkThemeEnabled
                          ? Colors.black
                          : Colors.white,
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
        widgetClass: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: projectProvider.projects.isEmpty &&
                  projectProvider.starredProjects.isEmpty
              ? Center(
                  child: EmptyPlaceholder.emptyProject(context),
                )
              : SingleChildScrollView(
                  // physics: NeverScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      checkStarredProjects(projects: projectProvider.projects)
                          ? const SizedBox(height: 10)
                          : Container(),
                      checkStarredProjects(projects: projectProvider.projects)
                          ? const CustomText(
                              'Favorites',
                              type: FontStyle.description,
                            )
                          : const SizedBox.shrink(),
                      checkStarredProjects(projects: projectProvider.projects)
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
                                    color: themeProvider.isDarkThemeEnabled
                                        ? darkThemeBorder
                                        : const Color.fromRGBO(
                                            238, 238, 238, 1),
                                  ),
                                );
                        },
                        itemCount: projectProvider.projects.length,
                        itemBuilder: (context, index) {
                          return projectProvider.projects[index]
                                      ['is_favorite'] ==
                                  false
                              ? Container()
                              : ListTile(
                                  onTap: () {
                                    if (projectProvider.currentProject !=
                                        projectProvider.projects[index]) {
                                      ref
                                          .read(ProviderList.issuesProvider)
                                          .clearData();
                                    }
                                    projectProvider.currentProject =
                                        projectProvider.projects[index];
                                    projectProvider.currentProject["index"] =
                                        index;
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
                                      color: themeProvider.isDarkThemeEnabled
                                          ? darkThemeBorder
                                          : const Color(0xFFF5F5F5),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Text(
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
                                    // child: Text(
                                    //   starredProject[index].title,
                                    //   style: TextStyle(
                                    //     color: themeProvider.primaryTextColor,
                                    //     fontSize: 18,
                                    //     fontWeight: FontWeight.w500,
                                    //   ),
                                    // ),
                                    child: CustomText(
                                      projectProvider.projects[index]['name'],
                                      // color: themeProvider.primaryTextColor,
                                      type: FontStyle.heading2,
                                      textAlign: TextAlign.start,
                                      maxLines: 1,
                                    ),
                                  ),
                                  subtitle: Row(
                                    children: [
                                      // Text(
                                      //   starredProject[index].subtitle,
                                      //   style: TextStyle(
                                      //     color: themeProvider.strokeColor,
                                      //     fontSize: 16,
                                      //     fontWeight: FontWeight.w500,
                                      //   ),
                                      // ),
                                      CustomText(
                                        projectProvider.projects[index]
                                                ['is_member']
                                            ? 'Member'
                                            : 'Not a Member',
                                        // color: themeProvider.strokeColor,
                                        type: FontStyle.title,
                                      ),
                                      const SizedBox(width: 10),
                                      //dot as a separator
                                      CircleAvatar(
                                        radius: 3,
                                        backgroundColor:
                                            themeProvider.isDarkThemeEnabled
                                                ? darkSecondaryTextColor
                                                : lightSecondaryTextColor,
                                      ),
                                      const SizedBox(width: 10),
                                      CustomText(
                                        DateFormat('d MMMM').format(
                                            DateTime.parse(
                                                projectProvider.projects[index]
                                                    ['created_at'])),
                                        // color: themeProvider.strokeColor,
                                        type: FontStyle.title,
                                        // fontSize: 16,
                                      ),
                                      // Text(
                                      //   starredProject[index].date,
                                      //   style: TextStyle(
                                      //     color: themeProvider.strokeColor,
                                      //     fontSize: 16,
                                      //     fontWeight: FontWeight.w500,
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
                                    icon: const Icon(Icons.star,
                                        color: Colors.amber),
                                  ),
                                );
                        },
                      ),
                      projectProvider.projects.isNotEmpty &&
                              checkStarredProjects(
                                  projects: projectProvider.projects)
                          ? const CustomText(
                              'All',
                              // color: themeProvider.secondaryTextColor,
                              type: FontStyle.description,
                            )
                          : Container(),
                      const SizedBox(height: 7),
                      ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        separatorBuilder: (context, index) {
                          return projectProvider.projects[index]
                                      ['is_favorite'] ==
                                  true
                              ? Container()
                              : Container(
                                  margin: const EdgeInsets.only(
                                      top: 10, bottom: 10),
                                  child: Divider(
                                    height: 1,
                                    thickness: 1,
                                    indent: 0,
                                    endIndent: 0,
                                    color: themeProvider.isDarkThemeEnabled
                                        ? darkThemeBorder
                                        : const Color.fromRGBO(
                                            238, 238, 238, 1),
                                  ),
                                );
                        },
                        itemCount: projectProvider.projects.length,
                        itemBuilder: (context, index) {
                          return projectProvider.projects[index]
                                      ['is_favorite'] ==
                                  true
                              ? Container()
                              : ListTile(
                                  onTap: () {
                                    //   log(projectProvider.projects[index].toString());
                                    if (projectProvider.currentProject !=
                                        projectProvider.projects[index]) {
                                      ref
                                          .read(ProviderList.issuesProvider)
                                          .clearData();
                                    }
                                    projectProvider.currentProject =
                                        projectProvider.projects[index];
                                    projectProvider.currentProject["index"] =
                                        index;
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
                                      color: themeProvider.isDarkThemeEnabled
                                          ? darkThemeBorder
                                          : const Color(0xFFF5F5F5),
                                    ),
                                    child: Center(
                                      child: Text(
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
                                    // child: Text(
                                    //   allProject[index].title,
                                    //   style: TextStyle(
                                    //     color: themeProvider.primaryTextColor,
                                    //     fontSize: 18,
                                    //     fontWeight: FontWeight.w500,
                                    //   ),
                                    // ),
                                    child: CustomText(
                                      projectProvider.projects[index]['name'],
                                      // color: themeProvider.primaryTextColor,
                                      type: FontStyle.heading2,
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
                                      //     fontWeight: FontWeight.w500,
                                      //   ),
                                      // ),
                                      CustomText(
                                        projectProvider.projects[index]
                                                ['is_member']
                                            ? 'Member'
                                            : 'Not a Member',
                                        // color: themeProvider.strokeColor,
                                        type: FontStyle.title,
                                      ),
                                      const SizedBox(width: 10),
                                      //dot as a separator
                                      CircleAvatar(
                                        radius: 3,
                                        backgroundColor:
                                            themeProvider.isDarkThemeEnabled
                                                ? darkSecondaryTextColor
                                                : lightSecondaryTextColor,
                                      ),
                                      const SizedBox(width: 10),
                                      // Text(
                                      //   allProject[index].date,
                                      //   style: TextStyle(
                                      //     color: themeProvider.strokeColor,
                                      //     fontSize: 16,
                                      //     fontWeight: FontWeight.w500,
                                      //   ),
                                      // ),
                                      CustomText(
                                        DateFormat('d MMMM').format(
                                            DateTime.parse(
                                                projectProvider.projects[index]
                                                    ['created_at'])),
                                        // color: themeProvider.strokeColor,
                                        type: FontStyle.title,
                                        color: themeProvider.isDarkThemeEnabled
                                            ? darkSecondaryTextColor
                                            : Colors.black,
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
                                      color: themeProvider.isDarkThemeEnabled
                                          ? darkSecondaryTextColor
                                          : lightSecondaryTextColor,
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
        ),
      ),
    );
  }

  bool checkStarredProjects({List? projects}) {
    bool hasItems = false;
    for (var element in projects!) {
      if (element['is_favorite'] == true) {
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
