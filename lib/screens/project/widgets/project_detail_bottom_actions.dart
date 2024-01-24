import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/bottom-sheets/filters/filter_sheet.dart';
import 'package:plane/bottom-sheets/page_filter_sheet.dart';
import 'package:plane/bottom-sheets/type_sheet.dart';
import 'package:plane/bottom-sheets/views_sheet.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/screens/project/issues/create_issue.dart';
import 'package:plane/screens/project/pages/create_page_screen.dart';
import 'package:plane/utils/bottom_sheet.helper.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/custom_text.dart';

class ProjectDetailBottomActions extends ConsumerStatefulWidget {
  const ProjectDetailBottomActions({required this.selectedTab, super.key});
  final int selectedTab;
  @override
  ConsumerState<ProjectDetailBottomActions> createState() =>
      _PDBottomActionsState();
}

class _PDBottomActionsState extends ConsumerState<ProjectDetailBottomActions> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = ref.watch(ProviderList.themeProvider);
    final projectProvider = ref.watch(ProviderList.projectProvider);
    final issueProvider = ref.watch(ProviderList.issuesProvider);
    final pageProvider = ref.watch(ProviderList.pageProvider);
    final statesProvider = ref.watch(ProviderList.statesProvider);

    return Row(
      children: [
        statesProvider.statesState == StateEnum.loading ||
                issueProvider.issueState == StateEnum.loading
            ? Container()
            : widget.selectedTab == 0 &&
                    statesProvider.statesState == StateEnum.restricted
                ? Container()
                : widget.selectedTab == 0 &&
                        statesProvider.statesState == StateEnum.success
                    ? Container(
                        decoration: BoxDecoration(
                          color: themeProvider
                              .themeManager.primaryBackgroundDefaultColor,
                          boxShadow: themeProvider
                              .themeManager.shadowBottomControlButtons,
                        ),
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            projectProvider.role == Role.admin ||
                                    projectProvider.role == Role.member
                                ? Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        issueProvider.createIssuedata['state'] =
                                            statesProvider
                                                .projectStates.keys.first;

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
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.add,
                                              color: themeProvider.themeManager
                                                  .primaryTextColor,
                                              size: 20,
                                            ),
                                            const CustomText(
                                              ' Issue',
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
                                BottomSheetHelper.showBottomSheet(
                                  context,
                                  const TypeSheet(
                                    issueCategory: IssueCategory.issues,
                                  ),
                                  constraints: BoxConstraints(
                                      maxHeight:
                                          MediaQuery.of(context).size.height *
                                              0.5),
                                );
                              },
                              child: SizedBox.expand(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.list_outlined,
                                      color: themeProvider
                                          .themeManager.primaryTextColor,
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
                                    IssueLayout.calendar
                                ? Container()
                                : Expanded(
                                    child: InkWell(
                                    onTap: () {
                                      BottomSheetHelper.showBottomSheet(
                                          context,
                                          ViewsSheet(
                                            projectView: issueProvider
                                                .issues.projectView,
                                            issueCategory: IssueCategory.issues,
                                          ));
                                    },
                                    child: SizedBox.expand(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.wysiwyg_outlined,
                                            color: themeProvider
                                                .themeManager.primaryTextColor,
                                            size: 19,
                                          ),
                                          const CustomText(
                                            ' Display',
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
                                BottomSheetHelper.showBottomSheet(
                                    context,
                                    FilterSheet(
                                      issueCategory: IssueCategory.issues,
                                    ));
                              },
                              child: SizedBox.expand(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.filter_list_outlined,
                                      color: themeProvider
                                          .themeManager.primaryTextColor,
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
        widget.selectedTab == 4
            ? widget.selectedTab == 4 &&
                    pageProvider.pages[pageProvider.selectedFilter]!.isEmpty
                ? Container()
                : Container(
                    height: 51,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: themeProvider
                          .themeManager.primaryBackgroundDefaultColor,
                      boxShadow:
                          themeProvider.themeManager.shadowBottomControlButtons,
                    ),
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
                                                MainAxisAlignment.center,
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
                                  BottomSheetHelper.showBottomSheet(
                                      context, const FilterPageSheet());
                                },
                                child: SizedBox.expand(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.filter_list_outlined,
                                        color: themeProvider
                                            .themeManager.primaryTextColor,
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
      ],
    );
  }
}
