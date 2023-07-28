import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:plane_startup/bottom_sheets/issues_list_sheet.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/screens/MainScreens/Projects/ProjectDetail/CyclesTab/create_cycle.dart';
import 'package:plane_startup/screens/MainScreens/Projects/ProjectDetail/IssuesTab/create_issue.dart';
import 'package:plane_startup/screens/MainScreens/Projects/ProjectDetail/ModulesTab/create_module.dart';
import 'package:plane_startup/screens/MainScreens/Projects/ProjectDetail/Settings/create_label.dart';
import 'package:plane_startup/screens/MainScreens/Projects/create_page_screen.dart';
import 'package:plane_startup/screens/MainScreens/Projects/create_project_screen.dart';
import 'package:plane_startup/screens/create_view_screen.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/utils/enums.dart';


import 'custom_text.dart';

class EmptyPlaceholder {
  static Widget emptyCycles(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      //  margin: const EdgeInsets.only(top: 150),
      child: Wrap(
        direction: Axis.vertical,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          SvgPicture.asset(
            "assets/svg_images/empty_cycles.svg",
            width: 130,
          ),
          Container(
            padding: const EdgeInsets.only(top: 35),
            child: const CustomText(
              'Cycles',
              type: FontStyle.heading,
            ),
          ),
          Container(
            width: 300,
            padding: const EdgeInsets.only(top: 10),
            child: const CustomText(
              'Sprint more effectively with Cycles by confining your project to a fixed amount of time. Create new cycle now.',
              color: Color.fromRGBO(133, 142, 150, 1),
              textAlign: TextAlign.center,
              type: FontStyle.title,
              maxLines: 3,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const CreateCycle()));
            },
            child: Container(
              height: 40,
              width: 150,
              margin: const EdgeInsets.only(top: 30),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: const Color.fromRGBO(63, 118, 255, 1),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 24,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  CustomText(
                    'Add Cycle',
                    type: FontStyle.buttonText,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  static Widget emptyIssues(BuildContext context,
      {String? cycleId, String? moduleId}) {
    return Container(
      alignment: Alignment.center,
      //  margin: const EdgeInsets.only(top: 150),
      child: Column(
        // direction: Axis.vertical,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 35),
            child: const CustomText(
              'Create New Issue',
              type: FontStyle.heading,
            ),
          ),
          Container(
            width: 300,
            padding: const EdgeInsets.only(top: 10),
            child: const CustomText(
              //create issues text
              'Issues help you track individual pieces of work. With Issues, keep track of what\'s going on, who is working on it, and what\'s done.',

              color: Color.fromRGBO(133, 142, 150, 1),
              textAlign: TextAlign.center,
              type: FontStyle.title,
              maxLines: 6,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreateIssue(
                            cycleId: cycleId,
                            moduleId: moduleId,
                          )));
            },
            child: Container(
              height: 40,
              width: 150,
              margin: const EdgeInsets.only(top: 30),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: const Color.fromRGBO(63, 118, 255, 1),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 24,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  CustomText(
                    'Add Issues',
                    type: FontStyle.buttonText,
                  )
                ],
              ),
            ),
          ),
          (cycleId != null || moduleId != null)
              ? GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (ctx) => IssuesListSheet(
                        // parent: false,
                        type: cycleId != null
                            ? IssueDetailCategory.addCycleIssue
                            : IssueDetailCategory.addModuleIssue,
                        issueId: '',
                        createIssue: false,
                        // blocking: true,
                        
                      ),
                    );
                  },
                  child: Container(
                    width: 215,
                    height: 40,
                    margin: const EdgeInsets.only(top: 30),
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: const Color.fromRGBO(63, 118, 255, 1),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 24,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        CustomText(
                          'Add Existing Issues',
                          type: FontStyle.buttonText,
                        )
                      ],
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  static Widget emptyModules(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      //  margin: const EdgeInsets.only(top: 150),
      child: Wrap(
        direction: Axis.vertical,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          SvgPicture.asset(
            "assets/svg_images/empty_modules.svg",
            width: 130,
          ),
          Container(
            padding: const EdgeInsets.only(top: 35),
            child: const CustomText(
              'Modules',
              type: FontStyle.heading,
            ),
          ),
          Container(
            width: 300,
            padding: const EdgeInsets.only(top: 10),
            child: const CustomText(
              'Modules are smaller, focused projects that help you group and organize issues within a specific time frame.',
              color: Color.fromRGBO(133, 142, 150, 1),
              textAlign: TextAlign.center,
              type: FontStyle.title,
              maxLines: 3,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CreateModule()));
            },
            child: Container(
              height: 40,
              width: 150,
              margin: const EdgeInsets.only(top: 30),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: const Color.fromRGBO(63, 118, 255, 1),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 24,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  CustomText(
                    'Add Module',
                    type: FontStyle.buttonText,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget emptyPages(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      //  margin: const EdgeInsets.only(top: 150),
      child: Wrap(
        direction: Axis.vertical,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Stack(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 30),
                height: 110,
                width: 300,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.grey.shade300)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 10, top: 10),
                      child: const CustomText(
                        'Client Meeting Notes',
                        color: Color.fromRGBO(133, 142, 150, 1),
                        type: FontStyle.subtitle,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 30),
                height: 110,
                width: 300,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.grey.shade300)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 10, top: 10),
                      child: const CustomText(
                        'Evening Standup Notes',
                        color: Color.fromRGBO(133, 142, 150, 1),
                        type: FontStyle.subtitle,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          height: 12,
                          width: 120,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10, left: 15),
                      height: 10,
                      width: 220,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromRGBO(222, 226, 230, 0.6),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10, left: 15),
                      height: 10,
                      width: 220,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromRGBO(222, 226, 230, 0.6),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          Container(
            padding: const EdgeInsets.only(top: 35),
            child: const CustomText(
              'Pages',
              type: FontStyle.heading,
            ),
          ),
          Container(
            width: 300,
            padding: const EdgeInsets.only(top: 10),
            child: const CustomText(
              'Create and document issues effortlessly in one place with Plane Notes, AI-powered for ease.',
              color: Color.fromRGBO(133, 142, 150, 1),
              maxLines: 3,
              textAlign: TextAlign.center,
              type: FontStyle.title,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const CreatePage()));
            },
            child: Container(
              height: 40,
              width: 150,
              margin: const EdgeInsets.only(top: 30),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: const Color.fromRGBO(63, 118, 255, 1),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 24,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  CustomText(
                    'Add Page',
                    type: FontStyle.buttonText,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  static Widget emptyView(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      //  margin: const EdgeInsets.only(top: 150),
      child: Wrap(
        direction: Axis.vertical,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Stack(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 30),
                height: 85,
                width: 300,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.grey.shade300)),
                child: Container(
                  padding: const EdgeInsets.only(left: 10, top: 10),
                  child: const CustomText(
                    'Completed Urgent Issues',
                    type: FontStyle.subtitle,
                    color: Color.fromRGBO(133, 142, 150, 1),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 30),
                height: 85,
                width: 300,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.grey.shade300)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 10, top: 10),
                      child: const CustomText(
                        'Active High Priority Issues',
                        type: FontStyle.subtitle,
                        color: Color.fromRGBO(133, 142, 150, 1),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 15, right: 15),
                      child: SvgPicture.asset(
                        "assets/svg_images/view_empty.svg",
                        width: 300,
                        fit: BoxFit.cover,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          Container(
            padding: const EdgeInsets.only(top: 35),
            child: const CustomText(
              'Views',
              type: FontStyle.heading,
            ),
          ),
          Container(
            width: 300,
            padding: const EdgeInsets.only(top: 10),
            child: const CustomText(
              'Views aid in saving your issues by applying various filters and grouping options.',
              textAlign: TextAlign.center,
              type: FontStyle.title,
              color: Color.fromRGBO(133, 142, 150, 1),
              maxLines: 3,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const CreateView()));
            },
            child: Container(
              height: 40,
              width: 150,
              margin: const EdgeInsets.only(top: 30),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: const Color.fromRGBO(63, 118, 255, 1),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 24,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  CustomText(
                    'Add View',
                    type: FontStyle.buttonText,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  static Widget joinProject(
      BuildContext context, WidgetRef ref, String projectId, String slug) {
    return Container(
      alignment: Alignment.center,
      //  margin: const EdgeInsets.only(top: 150),
      child: Wrap(
        direction: Axis.vertical,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          SvgPicture.asset("assets/svg_images/empty_project.svg"),
          Container(
            padding: const EdgeInsets.only(top: 35),
            width: width * 0.7,
            child: const CustomText(
              'You are not a member of this project',
              type: FontStyle.heading,
              textAlign: TextAlign.center,
              maxLines: 5,
            ),
          ),
          Container(
            width: 300,
            padding: const EdgeInsets.only(top: 10),
            child: const CustomText(
              'You are not a member of this project, but you can join this project by clicking the button below.',
              textAlign: TextAlign.center,
              type: FontStyle.title,
              color: Color.fromRGBO(133, 142, 150, 1),
              maxLines: 3,
            ),
          ),
          GestureDetector(
            onTap: () {
              ref
                  .read(ProviderList.issuesProvider)
                  .joinProject(projectId: projectId, slug: slug);
            },
            child: Container(
              height: 40,
              width: 150,
              margin: const EdgeInsets.only(top: 30),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: const Color.fromRGBO(63, 118, 255, 1),
              ),
              child: ref.watch(ProviderList.issuesProvider).joinprojectState ==
                      StateEnum.loading
                  ? const Center(
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.assignment_outlined,
                          color: Colors.white,
                          size: 24,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        CustomText(
                          'Click to join',
                          type: FontStyle.buttonText,
                        ),
                      ],
                    ),
            ),
          )
        ],
      ),
    );
  }

  static Widget emptyProject(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      //  margin: const EdgeInsets.only(top: 150),
      child: Wrap(
        direction: Axis.vertical,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          SvgPicture.asset(
            "assets/svg_images/empty_project.svg",
            width: 130,

            // color: themeProvider.isDarkThemeEnabled
            //     ? darkPrimaryTextColor
            //     : lightPrimaryTextColor,
          ),
          Container(
            padding: const EdgeInsets.only(top: 35),
            child: const CustomText(
              'No projects yet',
              type: FontStyle.heading,
            ),
          ),
          Container(
            width: 300,
            padding: const EdgeInsets.only(top: 10),
            child: const CustomText(
              'Get started by creating your first project.',
              color: Color.fromRGBO(133, 142, 150, 1),
              textAlign: TextAlign.center,
              type: FontStyle.title,
              maxLines: 3,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CreateProject()));
            },
            child: Container(
              height: 40,
              width: 150,
              margin: const EdgeInsets.only(top: 30),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: const Color.fromRGBO(63, 118, 255, 1),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 24,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  CustomText(
                    'Add Project',
                    type: FontStyle.buttonText,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  static Widget emptyLabels(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      //  margin: const EdgeInsets.only(top: 150),
      child: Wrap(
        direction: Axis.vertical,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          SvgPicture.asset(
            "assets/svg_images/labels_empty.svg",
            width: 130,
          ),
          Container(
            padding: const EdgeInsets.only(top: 35),
            child: const CustomText(
              'No labels yet',
              type: FontStyle.heading,
            ),
          ),
          Container(
            width: 300,
            padding: const EdgeInsets.only(top: 10),
            child: const CustomText(
              'Create labels to help organize and filter issues in you project',
              color: Color.fromRGBO(133, 142, 150, 1),
              textAlign: TextAlign.center,
              type: FontStyle.title,
              maxLines: 3,
            ),
          ),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                enableDrag: true,
                isScrollControlled: true,
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.8,
                ),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                context: context,
                builder: (context) {
                  return Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: const CreateLabel(
                      method: CRUD.create,
                    ),
                  );
                },
              );
            },
            child: Container(
              height: 40,
              width: 150,
              margin: const EdgeInsets.only(top: 30),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: const Color.fromRGBO(63, 118, 255, 1),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 24,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  CustomText(
                    'Add Label',
                    type: FontStyle.buttonText,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
