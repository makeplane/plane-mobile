import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/bottom_sheets/filter_sheet.dart';
import 'package:plane/bottom_sheets/views_sheet.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/screens/MainScreens/Projects/ProjectDetail/IssuesTab/create_issue.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/custom_app_bar.dart';
import 'package:plane/widgets/custom_text.dart';
import 'package:plane/widgets/empty.dart';
import 'package:plane/widgets/loading_widget.dart';

class ArchivedIssues extends ConsumerStatefulWidget {
  const ArchivedIssues({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ArchivedIssuesState();
}

class _ArchivedIssuesState extends ConsumerState<ArchivedIssues> {
  @override
  void initState() {
    super.initState();
    var issueProvider = ref.read(ProviderList.issuesProvider);
    issueProvider.tempProjectView = issueProvider.issues.projectView;
    issueProvider.issues.projectView = ProjectView.list;

    issueProvider.setsState();
    issueProvider.filterIssues(
      slug: ref
          .read(ProviderList.workspaceProvider)
          .selectedWorkspace
          .workspaceSlug,
      projID: ref.read(ProviderList.projectProvider).currentProject['id'],
      isArchived: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var issueProvider = ref.watch(ProviderList.issuesProvider);
    var projectProvider = ref.watch(ProviderList.projectProvider);
    // log(issueProvider.issueState.name);
    if (issueProvider.issues.projectView == ProjectView.list) {
      issueProvider.initializeBoard(
        isArchive: true,
      );
    }

    return WillPopScope(
      onWillPop: () async {
        issueProvider.issues.projectView = issueProvider.tempProjectView;
        issueProvider.setsState();
        issueProvider.filterIssues(
          slug: ref
              .read(ProviderList.workspaceProvider)
              .selectedWorkspace
              .workspaceSlug,
          projID: ref.read(ProviderList.projectProvider).currentProject['id'],
          isArchived: false,
        );
        return true;
      },
      child: Scaffold(
        appBar: CustomAppBar(
          onPressed: () {
            issueProvider.issues.projectView = issueProvider.tempProjectView;
            log(issueProvider.issues.projectView.toString());
            issueProvider.setsState();
            issueProvider.filterIssues(
              slug: ref
                  .read(ProviderList.workspaceProvider)
                  .selectedWorkspace
                  .workspaceSlug,
              projID:
                  ref.read(ProviderList.projectProvider).currentProject['id'],
              isArchived: false,
            );
            Navigator.pop(context);
          },
          text: 'Archived Issues',
        ),
        body: LoadingWidget(
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
                      .selectedWorkspace
                      .workspaceSlug)
              : Container(
                  color: themeProvider
                      .themeManager.secondaryBackgroundDefaultColor,
                  child: issueProvider.issueState == StateEnum.loading ||
                          issueProvider.statesState == StateEnum.loading ||
                          issueProvider.projectViewState == StateEnum.loading ||
                          issueProvider.orderByState == StateEnum.loading
                      ? Container()
                      : issueProvider.isISsuesEmpty
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                EmptyPlaceholder.emptyArchives(),
                              ],
                            )
                          : Column(
                              children: [
                                Expanded(
                                  child: Container(
                                    color: themeProvider.themeManager
                                        .secondaryBackgroundDefaultColor,
                                    margin: const EdgeInsets.only(top: 5),
                                    child: SingleChildScrollView(
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: issueProvider.issues.issues
                                              .map((state) =>
                                                  state.items.isEmpty &&
                                                          !issueProvider
                                                              .showEmptyStates
                                                      ? Container()
                                                      : SizedBox(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            15),
                                                                margin:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        bottom:
                                                                            10),
                                                                child: Row(
                                                                  children: [
                                                                    state.leading ??
                                                                        Container(),
                                                                    Container(
                                                                      padding:
                                                                          const EdgeInsets
                                                                              .only(
                                                                        left:
                                                                            10,
                                                                      ),
                                                                      child:
                                                                          CustomText(
                                                                        state
                                                                            .title!,
                                                                        type: FontStyle
                                                                            .Large,
                                                                        color: themeProvider
                                                                            .themeManager
                                                                            .primaryTextColor,
                                                                        fontWeight:
                                                                            FontWeightt.Semibold,
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      margin: const EdgeInsets
                                                                          .only(
                                                                        left:
                                                                            15,
                                                                      ),
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(
                                                                              15),
                                                                          color: themeProvider
                                                                              .themeManager
                                                                              .tertiaryBackgroundDefaultColor),
                                                                      height:
                                                                          25,
                                                                      width: 30,
                                                                      child:
                                                                          CustomText(
                                                                        state
                                                                            .items
                                                                            .length
                                                                            .toString(),
                                                                        type: FontStyle
                                                                            .Small,
                                                                      ),
                                                                    ),
                                                                    const Spacer(),
                                                                    projectProvider.role == Role.admin ||
                                                                            projectProvider.role ==
                                                                                Role.member
                                                                        ? IconButton(
                                                                            onPressed: () {
                                                                              if (issueProvider.issues.groupBY == GroupBY.state) {
                                                                                issueProvider.createIssuedata['state'] = state.id;
                                                                              } else {
                                                                                issueProvider.createIssuedata['prioriry'] = 'de3c90cd-25cd-42ec-ac6c-a66caf8029bc';
                                                                                // createIssuedata['s'] = element.id;
                                                                              }
                                                                              Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const CreateIssue()));
                                                                            },
                                                                            icon: Icon(
                                                                              Icons.add,
                                                                              color: themeProvider.themeManager.tertiaryTextColor,
                                                                            ))
                                                                        : Container(
                                                                            height:
                                                                                40,
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
                                                                  children: state
                                                                      .items
                                                                      .map(
                                                                          (e) =>
                                                                              e)
                                                                      .toList()),
                                                              state.items
                                                                      .isEmpty
                                                                  ? Container(
                                                                      margin: const EdgeInsets
                                                                              .only(
                                                                          bottom:
                                                                              10),
                                                                      width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width,
                                                                      color: themeProvider
                                                                          .themeManager
                                                                          .primaryBackgroundDefaultColor,
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          top:
                                                                              15,
                                                                          bottom:
                                                                              15,
                                                                          left:
                                                                              15),
                                                                      child:
                                                                          const CustomText(
                                                                        'No issues.',
                                                                        type: FontStyle
                                                                            .Small,
                                                                        maxLines:
                                                                            10,
                                                                        textAlign:
                                                                            TextAlign.start,
                                                                      ),
                                                                    )
                                                                  : Container(
                                                                      margin: const EdgeInsets
                                                                              .only(
                                                                          bottom:
                                                                              10),
                                                                    )
                                                            ],
                                                          ),
                                                        ))
                                              .toList()),
                                    ),
                                  ),
                                ),
                                issueProvider.statesState ==
                                            StateEnum.loading ||
                                        issueProvider.issueState ==
                                            StateEnum.loading
                                    ? Container()
                                    : Container(
                                        decoration: BoxDecoration(
                                          color: themeProvider.themeManager
                                              .primaryBackgroundDefaultColor,
                                          boxShadow: themeProvider.themeManager
                                              .shadowBottomControlButtons,
                                        ),
                                        height: 50,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Row(
                                          children: [
                                            Container(
                                              height: 50,
                                              width: 0.5,
                                              color: themeProvider.themeManager
                                                  .borderSubtle01Color,
                                            ),
                                            issueProvider.issues.projectView ==
                                                    ProjectView.calendar
                                                ? Container()
                                                : Expanded(
                                                    child: InkWell(
                                                    onTap: () {
                                                      showModalBottomSheet(
                                                          isScrollControlled:
                                                              true,
                                                          enableDrag: true,
                                                          constraints: BoxConstraints(
                                                              maxHeight: MediaQuery.of(
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
                                                                Radius.circular(
                                                                    30),
                                                            topRight:
                                                                Radius.circular(
                                                                    30),
                                                          )),
                                                          context: context,
                                                          builder: (ctx) {
                                                            return const ViewsSheet(
                                                              issueCategory:
                                                                  IssueCategory
                                                                      .issues,
                                                              isArchived: true,
                                                              projectView:
                                                                  ProjectView
                                                                      .list,
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
                                                            Icons
                                                                .wysiwyg_outlined,
                                                            color: themeProvider
                                                                .themeManager
                                                                .primaryTextColor,
                                                            size: 19,
                                                          ),
                                                          const CustomText(
                                                            ' Views',
                                                            type: FontStyle
                                                                .Medium,
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  )),
                                            Container(
                                              height: 50,
                                              width: 0.5,
                                              color: themeProvider.themeManager
                                                  .borderSubtle01Color,
                                            ),
                                            Expanded(
                                                child: InkWell(
                                              onTap: () {
                                                showModalBottomSheet(
                                                    isScrollControlled: true,
                                                    enableDrag: true,
                                                    constraints: BoxConstraints(
                                                        minHeight:
                                                            MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.75,
                                                        maxHeight:
                                                            MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.85),
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
                                                      return FilterSheet(
                                                        issueCategory:
                                                            IssueCategory
                                                                .issues,
                                                        isArchived: true,
                                                      );
                                                    });
                                              },
                                              child: SizedBox.expand(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .filter_list_outlined,
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
                ),
        ),
      ),
    );
  }
}
