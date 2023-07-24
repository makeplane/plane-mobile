import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/utils/enums.dart';
import 'package:plane_startup/widgets/custom_button.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/widgets/custom_expansion_tile.dart';

import 'package:plane_startup/widgets/custom_text.dart';

class FilterSheet extends ConsumerStatefulWidget {
  const FilterSheet({super.key, required this.issueCategory});
  final Enum issueCategory;
  @override
  ConsumerState<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends ConsumerState<FilterSheet> {
  List priorities = [
    {'icon': Icons.error_outline_rounded, 'text': 'urgent'},
    {'icon': Icons.signal_cellular_alt, 'text': 'high'},
    {'icon': Icons.signal_cellular_alt_2_bar, 'text': 'medium'},
    {'icon': Icons.signal_cellular_alt_1_bar, 'text': 'low'},
    {'icon': Icons.do_disturb_alt_outlined, 'text': 'none'}
  ];

  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var issuesProvider = ref.watch(ProviderList.issuesProvider);
    var projectProvider = ref.watch(ProviderList.projectProvider);

    Widget expandedWidget(
        {required Widget icon,
        required String text,
        Color? color,
        required bool selected}) {
      return Container(
        margin: const EdgeInsets.all(6),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
                color: selected || themeProvider.isDarkThemeEnabled
                    ? Colors.transparent
                    : Colors.grey.shade400),
            color: color ?? Colors.white),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            const SizedBox(width: 5),
            CustomText(
              text.isNotEmpty
                  ? text.replaceFirst(text[0], text[0].toUpperCase())
                  : text,
              color: selected
                  ? Colors.white
                  : themeProvider.isDarkThemeEnabled
                      ? Colors.grey.shade500
                      : greyColor,
            )
          ],
        ),
      );
    }

    Widget horizontalLine() {
      return Container(
        height: 1,
        width: double.infinity,
        color: themeProvider.isDarkThemeEnabled
            ? darkThemeBorder
            : Colors.grey[300],
      );
    }

    return Container(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
      // color: themeProvider.isDarkThemeEnabled
      //     ? darkSecondaryBackgroundColor
      //     : lightSecondaryBackgroundColor,
      child: SingleChildScrollView(
        child: Wrap(
          children: [
            Row(
              children: [
                const CustomText(
                  'Filter',
                  type: FontStyle.heading,
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.close,
                    size: 27,
                    color: Color.fromRGBO(143, 143, 147, 1),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            CustomExpansionTile(
              title: 'Priority',
              child: Wrap(
                  children: priorities
                      .map((e) => GestureDetector(
                          onTap: () {
                            setState(() {
                              if (issuesProvider.issues.filters.priorities
                                  .contains(e['text'])) {
                                issuesProvider.issues.filters.priorities
                                    .remove(e['text']);
                              } else {
                                issuesProvider.issues.filters.priorities
                                    .add(e['text']);
                              }
                            });
                          },
                          child: expandedWidget(
                              icon: Icon(
                                e['icon'],
                                size: 15,
                                color: issuesProvider.issues.filters.priorities
                                        .contains(e['text'])
                                    ? Colors.white
                                    : greyColor,
                              ),
                              text: e['text'],
                              color: issuesProvider.issues.filters.priorities
                                      .contains(e['text'])
                                  ? primaryColor
                                  : themeProvider.isDarkThemeEnabled
                                      ? darkBackgroundColor
                                      : Colors.white,
                              selected: issuesProvider.issues.filters.priorities
                                  .contains(e['text']))))
                      .toList()),
            ),

            horizontalLine(),

            CustomExpansionTile(
              title: 'State',
              child: Wrap(
                  children: issuesProvider.states.values
                      .map((e) => GestureDetector(
                            onTap: () {
                              setState(() {
                                if (issuesProvider.issues.filters.states
                                    .contains(e['id'])) {
                                  issuesProvider.issues.filters.states
                                      .remove(e['id']);
                                } else {
                                  issuesProvider.issues.filters.states
                                      .add(e['id']);
                                }
                              });
                            },
                            child: expandedWidget(
                              icon: SvgPicture.asset(
                                e['name'] == 'Backlog'
                                    ? 'assets/svg_images/circle.svg'
                                    : e['name'] == 'Cancelled'
                                        ? 'assets/svg_images/cancelled.svg'
                                        : e['name'] == 'Todo'
                                            ? 'assets/svg_images/in_progress.svg'
                                            : e['name'] == 'Done'
                                                ? 'assets/svg_images/done.svg'
                                                : 'assets/svg_images/circle.svg',
                                colorFilter: ColorFilter.mode(
                                    issuesProvider.issues.filters.states
                                            .contains(e['id'])
                                        ? Colors.white
                                        : Colors.grey.shade500,
                                    BlendMode.srcIn),
                                height: 15,
                                width: 15,
                              ),
                              text: e['name'],
                              color: issuesProvider.issues.filters.states
                                      .contains(e['id'])
                                  ? primaryColor
                                  : themeProvider.isDarkThemeEnabled
                                      ? darkBackgroundColor
                                      : Colors.white,
                              selected: issuesProvider.issues.filters.states
                                  .contains(e['id']),
                            ),
                          ))
                      .toList()
                  // children: [
                  //   expandedWidget(
                  //       icon: Icons.dangerous_outlined, text: 'Backlog', selected: false),
                  //   expandedWidget(
                  //       icon: Icons.wifi_calling_3_outlined, text: 'To Do', selected: false),
                  //   expandedWidget(
                  //       icon: Icons.wifi_2_bar_outlined, text: 'In Progress', selected: false),
                  //   expandedWidget(
                  //       icon: Icons.wifi_1_bar_outlined, text: 'Done', selected: false),
                  //   expandedWidget(
                  //       icon: Icons.dangerous_outlined, text: 'Cancelled', selected: false),
                  // ],
                  ),
            ),

            horizontalLine(),

            CustomExpansionTile(
              title: 'Assignees',
              child: Wrap(
                children: projectProvider.projectMembers
                    .map(
                      (e) => GestureDetector(
                        onTap: () {
                          setState(() {
                            if (issuesProvider.issues.filters.assignees
                                .contains(e['member']['id'])) {
                              issuesProvider.issues.filters.assignees
                                  .remove(e['member']['id']);
                            } else {
                              issuesProvider.issues.filters.assignees
                                  .add(e['member']['id']);
                            }
                          });
                        },
                        child: expandedWidget(
                          icon: e['member']['avatar'] != '' &&
                                  e['member']['avatar'] != null
                              ? CircleAvatar(
                                  radius: 10,
                                  backgroundImage:
                                      NetworkImage(e['member']['avatar']),
                                )
                              : CircleAvatar(
                                  radius: 10,
                                  backgroundColor:
                                      const Color.fromRGBO(55, 65, 81, 1),
                                  child: Center(
                                      child: CustomText(
                                    e['member']['email'][0]
                                        .toString()
                                        .toUpperCase(),
                                    color: Colors.white,
                                  )),
                                ),
                          text: e['member']['first_name'] != null &&
                                  e['member']['first_name'] != ''
                              ? e['member']['first_name']
                              : '',
                          selected: issuesProvider.issues.filters.assignees
                              .contains(e['member']['id']),
                          color: issuesProvider.issues.filters.assignees
                                  .contains(e['member']['id'])
                              ? primaryColor
                              : themeProvider.isDarkThemeEnabled
                                  ? darkBackgroundColor
                                  : Colors.white,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),

            horizontalLine(),

            CustomExpansionTile(
              title: 'Created by',
              child: Wrap(
                children: projectProvider.projectMembers
                    .map(
                      (e) => GestureDetector(
                        onTap: () {
                          setState(() {
                            if (issuesProvider.issues.filters.createdBy
                                .contains(e['member']['id'])) {
                              issuesProvider.issues.filters.createdBy
                                  .remove(e['member']['id']);
                            } else {
                              issuesProvider.issues.filters.createdBy
                                  .add(e['member']['id']);
                            }
                          });
                        },
                        child: expandedWidget(
                          icon: e['member']['avatar'] != '' &&
                                  e['member']['avatar'] != null
                              ? CircleAvatar(
                                  radius: 10,
                                  backgroundImage:
                                      NetworkImage(e['member']['avatar']),
                                )
                              : CircleAvatar(
                                  radius: 10,
                                  backgroundColor:
                                      const Color.fromRGBO(55, 65, 81, 1),
                                  child: Center(
                                      child: CustomText(
                                    e['member']['email'][0]
                                        .toString()
                                        .toUpperCase(),
                                    color: Colors.white,
                                  )),
                                ),
                          text: e['member']['first_name'] != null &&
                                  e['member']['first_name'] != ''
                              ? e['member']['first_name']
                              : '',
                          selected: issuesProvider.issues.filters.createdBy
                              .contains(e['member']['id']),
                          color: issuesProvider.issues.filters.createdBy
                                  .contains(e['member']['id'])
                              ? primaryColor
                              : themeProvider.isDarkThemeEnabled
                                  ? darkBackgroundColor
                                  : Colors.white,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),

            horizontalLine(),

            CustomExpansionTile(
              title: 'Labels',
              child: Wrap(
                  children: issuesProvider.labels
                      .map((e) => GestureDetector(
                            onTap: () {
                              setState(() {
                                if (issuesProvider.issues.filters.labels
                                    .contains(e['id'])) {
                                  issuesProvider.issues.filters.labels
                                      .remove(e['id']);
                                } else {
                                  issuesProvider.issues.filters.labels
                                      .add(e['id']);
                                }
                              });
                            },
                            child: expandedWidget(
                              icon: CircleAvatar(
                                radius: 5,
                                backgroundColor: Color(int.parse(
                                    "0xFF${e['color'].toString().toUpperCase().replaceAll("#", "")}")),
                              ),
                              text: e['name'],
                              selected: issuesProvider.issues.filters.labels
                                  .contains(e['id']),
                              color: issuesProvider.issues.filters.labels
                                      .contains(e['id'])
                                  ? primaryColor
                                  : themeProvider.isDarkThemeEnabled
                                      ? darkBackgroundColor
                                      : Colors.white,
                            ),
                          ))
                      .toList()),
            ),

            // horizontalLine(),

            // Expanded(child: Container()),

            Container(height: 50),

            //long blue button to apply filter
            Container(
              margin: const EdgeInsets.only(bottom: 18),
              child: Button(
                text: 'Apply Filter',
                ontap: () {
                  if (widget.issueCategory == IssueCategory.cycleIssues) {
                    ref
                        .watch(ProviderList.cyclesProvider)
                        .filterCycleIssues(
                          slug: ref
                              .read(ProviderList.workspaceProvider)
                              .selectedWorkspace!
                              .workspaceSlug,
                          projectId: ref
                              .read(ProviderList.projectProvider)
                              .currentProject["id"],
                        )
                        .then((value) => ref
                            .watch(ProviderList.cyclesProvider)
                            .initializeBoard());
                  } else if (widget.issueCategory ==
                      IssueCategory.moduleIssues) {
                    ref
                        .watch(ProviderList.modulesProvider)
                        .filterModuleIssues(
                          slug: ref
                              .read(ProviderList.workspaceProvider)
                              .selectedWorkspace!
                              .workspaceSlug,
                          projectId: ref
                              .read(ProviderList.projectProvider)
                              .currentProject["id"],
                        )
                        .then((value) => ref
                            .watch(ProviderList.modulesProvider)
                            .initializeBoard());
                  } else {
                    issuesProvider.updateProjectView();
                    issuesProvider.filterIssues(
                      slug: ref
                          .read(ProviderList.workspaceProvider)
                          .selectedWorkspace!
                          .workspaceSlug,
                      projID: ref
                          .read(ProviderList.projectProvider)
                          .currentProject["id"],
                    );
                  }
                  Navigator.of(context).pop();
                },
                textColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
