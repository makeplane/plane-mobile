import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/bottom-sheets/filters/filter_sheet.dart';
import 'package:plane/bottom-sheets/page_filter_sheet.dart';
import 'package:plane/bottom-sheets/views-layout-sheet/display_sheet.dart';
import 'package:plane/bottom-sheets/views-layout-sheet/widgets/layout_tab.dart';
import 'package:plane/provider/issues/base-classes/base_issue_state.dart';
import 'package:plane/provider/issues/base-classes/base_issues_provider.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/screens/project/pages/create_page_screen.dart';
import 'package:plane/utils/bottom_sheet.helper.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/custom_text.dart';

class IssuesLayoutBottomActions extends ConsumerStatefulWidget {
  const IssuesLayoutBottomActions(
      {required this.issuesProvider,
      required this.issuesState,
      required this.selectedTab,
      super.key});
  final int selectedTab;
  final ABaseIssuesState issuesState;
  final ABaseIssuesProvider issuesProvider;
  @override
  ConsumerState<IssuesLayoutBottomActions> createState() =>
      _IssuesLayoutBottomActionsState();
}

class _IssuesLayoutBottomActionsState
    extends ConsumerState<IssuesLayoutBottomActions> {
  @override
  Widget build(BuildContext context) {
    final themeManager = ref.watch(ProviderList.themeProvider).themeManager;
    final projectProvider = ref.watch(ProviderList.projectProvider);
    final pageProvider = ref.watch(ProviderList.pageProvider);
    final statesProvider = ref.watch(ProviderList.statesProvider);

    return Row(
      children: [
        statesProvider.statesState == StateEnum.loading ||
                widget.issuesState.fetchIssuesState == StateEnum.loading
            ? Container()
            : widget.selectedTab == 0 &&
                    statesProvider.statesState == StateEnum.restricted
                ? Container()
                : widget.selectedTab == 0 &&
                        statesProvider.statesState == StateEnum.success
                    ? Container(
                        decoration: BoxDecoration(
                          color: themeManager.primaryBackgroundDefaultColor,
                          boxShadow: themeManager.shadowBottomControlButtons,
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
                                        // Navigator.of(context).push(
                                        //   MaterialPageRoute(
                                        //     builder: (context) =>
                                        //         const CreateIssue(),
                                        //   ),
                                        // );
                                      },
                                      child: SizedBox.expand(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.add,
                                              color:
                                                  themeManager.primaryTextColor,
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
                              color: themeManager.borderSubtle01Color,
                            ),
                            Expanded(
                                child: InkWell(
                              onTap: () {
                                BottomSheetHelper.showBottomSheet(
                                  context,
                                  LayoutTab(
                                    issuesProvider: widget.issuesProvider,
                                    issueCategory: IssueCategory.projectIssues,
                                  ),
                                  constraints: BoxConstraints(
                                      maxHeight:
                                          MediaQuery.of(context).size.height *
                                              0.8),
                                );
                              },
                              child: SizedBox.expand(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.list_outlined,
                                      color: themeManager.primaryTextColor,
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
                              color: themeManager.borderSubtle01Color,
                            ),
                            widget.issuesProvider.displayFilters.layout ==
                                    'calendar'
                                ? Container()
                                : Expanded(
                                    child: InkWell(
                                    onTap: () {
                                      BottomSheetHelper.showBottomSheet(
                                          context,
                                          DisplayFilterSheet(
                                            issuesProvider:
                                                widget.issuesProvider,
                                            issuesState: widget.issuesState,
                                          ));
                                    },
                                    child: SizedBox.expand(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.wysiwyg_outlined,
                                            color:
                                                themeManager.primaryTextColor,
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
                              color: themeManager.borderSubtle01Color,
                            ),
                            Expanded(
                                child: InkWell(
                              onTap: () {
                                BottomSheetHelper.showBottomSheet(
                                    context,
                                    FilterSheet(
                                      issueCategory:
                                          IssueCategory.projectIssues,
                                    ));
                              },
                              child: SizedBox.expand(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.filter_list_outlined,
                                      color: themeManager.primaryTextColor,
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
                      color: themeManager.primaryBackgroundDefaultColor,
                      boxShadow: themeManager.shadowBottomControlButtons,
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
                                                color: themeManager
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
                                color: themeManager.borderSubtle01Color,
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
                                        color: themeManager.primaryTextColor,
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
