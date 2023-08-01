import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:plane_startup/bottom_sheets/add_attachment_sheet.dart';
import 'package:plane_startup/bottom_sheets/add_link_sheet.dart';
import 'package:plane_startup/bottom_sheets/issue_detail_cycles_sheet.dart';
import 'package:plane_startup/bottom_sheets/issue_detail_modules_list.dart';
import 'package:plane_startup/bottom_sheets/issues_list_sheet.dart';
import 'package:plane_startup/bottom_sheets/select_estimate.dart';
import 'package:plane_startup/bottom_sheets/select_issue_labels.dart';
import 'package:plane_startup/bottom_sheets/select_priority.dart';
import 'package:plane_startup/bottom_sheets/select_project_members.dart';
import 'package:plane_startup/bottom_sheets/select_states.dart';
import 'package:plane_startup/provider/theme_provider.dart';
import 'package:plane_startup/utils/custom_toast.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/utils/enums.dart';

import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/widgets/custom_app_bar.dart';
import 'package:plane_startup/widgets/custom_rich_text.dart';
import 'package:plane_startup/widgets/custom_text.dart';

import 'package:plane_startup/widgets/profile_circle_avatar_widget.dart';
import 'package:plane_startup/widgets/simple_loading_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class IssueDetail extends ConsumerStatefulWidget {
  final String issueId;
  String appBarTitle;
  final String? projID;
  final String? workspaceSlug;
  IssueDetail(
      {required this.appBarTitle,
      this.projID,
      this.workspaceSlug,
      required this.issueId,
      super.key});

  @override
  ConsumerState<IssueDetail> createState() => _IssueDetailState();
}

class _IssueDetailState extends ConsumerState<IssueDetail> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  List<TextEditingController> commentControllers = [];
  List<String> imageFormates = ['PNG', 'JPEG'];
  String blockedByWidgetIssueToBeRemoved = '';
  String blockingWidgetIssueToBeRemoved = '';
  String attachmentToBeRemoved = '';
  String linkToBeRemoved = '';

  var expanded = false;

  @override
  void initState() {
    super.initState();
    getIssueDetails();
    getCycles();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getModules();
    });
  }

  @override
  void dispose() {
    ref.watch(ProviderList.issueProvider).cyclesList.clear();
    super.dispose();
  }

  Future getIssueDetails() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      var issueProvider = ref.watch(ProviderList.issueProvider);
      issueProvider.clearData();
      await issueProvider.getIssueDetails(
          slug: widget.workspaceSlug ??
              ref
                  .read(ProviderList.workspaceProvider)
                  .selectedWorkspace!
                  .workspaceSlug,
          projID: widget.projID ??
              ref.read(ProviderList.projectProvider).currentProject['id'],
          issueID: widget.issueId);

      await issueProvider.getIssueActivity(
          slug: widget.workspaceSlug ??
              ref
                  .read(ProviderList.workspaceProvider)
                  .selectedWorkspace!
                  .workspaceSlug,
          projID: widget.projID ??
              ref.read(ProviderList.projectProvider).currentProject['id'],
          issueID: widget.issueId);

      await ref.read(ProviderList.issueProvider).getSubscriptionStatus(
          slug: ref
              .read(ProviderList.workspaceProvider)
              .selectedWorkspace!
              .workspaceSlug,
          httpMethod: HttpMethod.get,
          projID: widget.projID ??
              ref.read(ProviderList.projectProvider).currentProject['id'],
          issueID: widget.issueId);

      title.text = issueProvider.issueDetails['name'];
      description.text = issueProvider.issueDetails['description_stripped'];
      issueProvider.getSubIssues(
        slug: widget.workspaceSlug ??
            ref
                .read(ProviderList.workspaceProvider)
                .selectedWorkspace!
                .workspaceSlug,
        projectId: widget.projID ??
            ref.read(ProviderList.projectProvider).currentProject['id'],
        issueId: widget.issueId,
      );
      widget.appBarTitle = issueProvider.issueDetails['project_detail']
              ['identifier'] +
          "-" +
          issueProvider.issueDetails['sequence_id'].toString();
    });
  }

  Future getCycles() async {
    var cyclesProvider = ref.read(ProviderList.cyclesProvider);
    var issueProvider = ref.read(ProviderList.issueProvider);
    var slug = ref
        .read(ProviderList.workspaceProvider)
        .selectedWorkspace!
        .workspaceSlug;
    await cyclesProvider.cyclesCrud(
        slug: widget.workspaceSlug ?? slug,
        projectId: widget.projID ??
            ref.read(ProviderList.projectProvider).currentProject['id'],
        method: CRUD.read,
        query: 'current');
    await cyclesProvider.cyclesCrud(
        slug: widget.workspaceSlug ?? slug,
        projectId: widget.projID ??
            ref.read(ProviderList.projectProvider).currentProject['id'],
        method: CRUD.read,
        query: 'upcoming');
    for (var element in cyclesProvider.cyclesActiveData) {
      issueProvider.cyclesList.add(element);
    }
    for (var element in cyclesProvider.cyclesUpcomingData) {
      issueProvider.cyclesList.add(element);
    }
    for (var element in cyclesProvider.cycleUpcomingFavoriteData) {
      issueProvider.cyclesList.add(element);
    }
    issueProvider.cyclesList.add({'name': 'None'});
  }

  Future getModules() async {
    var modulesProvider = ref.read(ProviderList.modulesProvider);
    var issueProvider = ref.read(ProviderList.issueProvider);
    var slug = ref
        .read(ProviderList.workspaceProvider)
        .selectedWorkspace!
        .workspaceSlug;
    issueProvider.modulesList.clear();
    ref.read(ProviderList.modulesProvider).getModules(
        slug: widget.workspaceSlug ?? slug,
        projId: widget.projID ??
            ref.read(ProviderList.projectProvider).currentProject['id']);
    // ref.watch(ProviderList.issueProvider).modulesList = ref.watch(ProviderList.modulesProvider).modules
    for (var element in modulesProvider.modules) {
      issueProvider.modulesList.add(element);
    }
    for (var element in modulesProvider.favModules) {
      issueProvider.modulesList.add(element);
    }
    issueProvider.modulesList.add({'name': 'None'});
  }

  bool isItAnImageExtension(String data) =>
      imageFormates.contains(data) ? true : false;

  @override
  Widget build(BuildContext context) {
    const double spaceBetweenSections = 28;
    const double spaceBetweenSectionsAndItems = 10;
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var issueProvider = ref.watch(ProviderList.issueProvider);
    var projectProvider = ref.watch(ProviderList.projectProvider);
    return Scaffold(
      //#f5f5f5f5 color
      backgroundColor: themeProvider.isDarkThemeEnabled
          ? darkBackgroundColor
          : lightBackgroundColor,
      appBar: CustomAppBar(
        onPressed: () {
          Navigator.pop(context);
        },
        text: widget.appBarTitle,
        actions: [
          (ref.read(ProviderList.profileProvider).userProfile.id ==
                      issueProvider.issueDetails['created_by'] ||
                  issueProvider.issueDetailState == StateEnum.loading)
              ? Container()
              : InkWell(
                  onTap: () {
                    (issueProvider.subscriptionState == StateEnum.loading ||
                            issueProvider.issueDetails['subscribed'] == null)
                        ? null
                        : ref
                            .read(ProviderList.issueProvider)
                            .getSubscriptionStatus(
                              slug: ref
                                  .read(ProviderList.workspaceProvider)
                                  .selectedWorkspace!
                                  .workspaceSlug,
                              httpMethod:
                                  issueProvider.issueDetails['subscribed']
                                      ? HttpMethod.delete
                                      : HttpMethod.post,
                              projID: ref
                                  .read(ProviderList.projectProvider)
                                  .currentProject['id'],
                              issueID: widget.issueId,
                            );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    margin: const EdgeInsets.all(5),
                    //container with blue border and white background with a row as chld with blue bell icon and text
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: primaryColor,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.notifications,
                          color: primaryColor,
                        ),
                        CustomText(
                          (issueProvider.subscriptionState ==
                                      StateEnum.loading ||
                                  issueProvider.issueDetails['subscribed'] ==
                                      null)
                              ? 'Loading...'
                              : issueProvider.issueDetails['subscribed']
                                  ? 'Unsubscribe'
                                  : 'Subscribe',
                          type: FontStyle.text,
                          color: primaryColor,
                        )
                      ],
                    ),
                  ),
                )
        ],
      ),
      body:
          issueProvider.issueDetailState == StateEnum.loading ||
                  issueProvider.issueActivityState == StateEnum.loading
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
              : issueProvider.issueDetailState == StateEnum.success &&
                      issueProvider.issueActivityState == StateEnum.success
                  ? SizedBox(
                      height: height,
                      child: Column(
                        children: [
                          Container(
                            height: 1,
                            color: themeProvider.isDarkThemeEnabled
                                ? darkThemeBorder
                                : strokeColor,
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 23, left: 15, right: 15),
                                child: Form(
                                  key: formKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const CustomText(
                                        'Title',
                                        type: FontStyle.description,
                                        // color: themeProvider.secondaryTextColor,
                                      ),
                                      const SizedBox(
                                          height: spaceBetweenSectionsAndItems),
                                      TextFormField(
                                        validator: (val) {
                                          if (val!.isEmpty) {
                                            return '*required';
                                          }
                                          return null;
                                        },
                                        readOnly: projectProvider.role !=
                                                Role.admin &&
                                            projectProvider.role != Role.member,
                                        //make lines of textfield to be dynamic
                                        maxLines: null,

                                        controller: title,
                                        decoration: InputDecoration(
                                          errorStyle: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.red,
                                              fontWeight: FontWeight.w600),

                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: getBorderColor(
                                                    themeProvider),
                                                width: 1.0),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(8)),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey.shade200,
                                                width: 1.0),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(8)),
                                          ),
                                          //set background color of text field
                                          fillColor:
                                              themeProvider.isDarkThemeEnabled
                                                  ? darkBackgroundColor
                                                  : lightBackgroundColor,
                                          filled: true,

                                          //show hint text always
                                          //  floatingLabelBehavior: FloatingLabelBehavior.always,
                                        ),
                                      ),
                                      const SizedBox(
                                          height: spaceBetweenSections),
                                      const CustomText(
                                        'Description',
                                        type: FontStyle.description,
                                        // color: themeProvider.secondaryTextColor,
                                      ),
                                      const SizedBox(
                                          height: spaceBetweenSectionsAndItems),
                                      TextField(
                                        onTap: () {
                                          CustomToast().showToast(context,
                                              'You can\'t perform this operation through Plane Mobile');
                                          return;
                                        },
                                        controller: description,
                                        maxLines: 4,
                                        readOnly: projectProvider.role !=
                                                Role.admin &&
                                            projectProvider.role != Role.member,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: themeProvider
                                                        .isDarkThemeEnabled
                                                    ? darkThemeBorder
                                                    : Colors.grey.shade200,
                                                width: 1.0),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(8)),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: themeProvider
                                                        .isDarkThemeEnabled
                                                    ? darkThemeBorder
                                                    : Colors.grey.shade200,
                                                width: 1.0),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(8)),
                                          ),
                                          //set background color of text field
                                          fillColor:
                                              themeProvider.isDarkThemeEnabled
                                                  ? Colors.grey.shade900
                                                  : lightBackgroundColor,
                                          filled: true,

                                          //show hint text always
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.always,
                                        ),
                                      ),
                                      const SizedBox(
                                          height: spaceBetweenSections),
                                      const Row(
                                        children: [
                                          CustomText(
                                            'Sub Issue',
                                            type: FontStyle.description,
                                          ),
                                          Spacer(),
                                        ],
                                      ),
                                      const SizedBox(
                                          height: spaceBetweenSectionsAndItems),
                                      selectedSubIssues(),
                                      // const SizedBox(
                                      //     height: spaceBetweenSectionsAndItems),
                                      Container(
                                        height: 45,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color:
                                              themeProvider.isDarkThemeEnabled
                                                  ? darkBackgroundColor
                                                  : const Color.fromRGBO(
                                                      250, 250, 250, 1),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: Border.all(
                                            color:
                                                themeProvider.isDarkThemeEnabled
                                                    ? darkThemeBorder
                                                    : Colors.grey.shade200,
                                          ),
                                        ),
                                        margin:
                                            const EdgeInsets.only(bottom: 10),
                                        child: InkWell(
                                          onTap: () async {
                                            if (projectProvider.role !=
                                                    Role.admin &&
                                                projectProvider.role !=
                                                    Role.member) {
                                              CustomToast().showToast(
                                                  context, accessRestrictedMSG);
                                              return;
                                            }
                                            showModalBottomSheet(
                                              isScrollControlled: true,
                                              backgroundColor:
                                                  Colors.transparent,
                                              context: context,
                                              builder: (ctx) => IssuesListSheet(
                                                // parent: false,
                                                type: IssueDetailCategory
                                                    .subIssue,
                                                issueId: widget.issueId,
                                                createIssue: false,
                                                // blocking: true,
                                              ),
                                            );
                                          },
                                          child: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.add, color: greyColor),
                                              CustomText('Add'),
                                            ],
                                          ),
                                        ),
                                      ),

                                      const SizedBox(
                                          height: spaceBetweenSections),
                                      const CustomText(
                                        'Details',
                                        type: FontStyle.description,
                                        // color: themeProvider.secondaryTextColor,
                                      ),
                                      const SizedBox(
                                          height: spaceBetweenSectionsAndItems),
                                      //three dropdown each occupying full width of the screen , each consits of a row with hint text and dropdown button at end
                                      stateWidget(),
                                      const SizedBox(
                                          height: spaceBetweenSectionsAndItems),
                                      assigneesWidget(),
                                      const SizedBox(
                                          height: spaceBetweenSectionsAndItems),
                                      priorityWidget(),
                                      const SizedBox(
                                          height: spaceBetweenSectionsAndItems),
                                      expanded
                                          ? Column(
                                              children: [
                                                ref
                                                                .read(ProviderList
                                                                    .projectProvider)
                                                                .currentProject[
                                                            'estimate'] ==
                                                        null
                                                    ? Container()
                                                    : estimateWidget(),
                                                const SizedBox(
                                                    height:
                                                        spaceBetweenSectionsAndItems),
                                                dueDateWidget(),
                                                const SizedBox(
                                                    height:
                                                        spaceBetweenSectionsAndItems),
                                                labelWidget(widget.issueId),
                                                const SizedBox(
                                                    height:
                                                        spaceBetweenSectionsAndItems),
                                                parentWidget(),
                                                const SizedBox(
                                                    height:
                                                        spaceBetweenSectionsAndItems),
                                                blockingWidget(widget.issueId),
                                                const SizedBox(
                                                    height:
                                                        spaceBetweenSectionsAndItems),
                                                blockedByWidget(widget.issueId),
                                                const SizedBox(
                                                    height:
                                                        spaceBetweenSectionsAndItems),
                                                cyclesWidget(),
                                                const SizedBox(
                                                    height:
                                                        spaceBetweenSectionsAndItems),
                                                moduleWidget(),
                                                const SizedBox(
                                                    height:
                                                        spaceBetweenSectionsAndItems),
                                              ],
                                            )
                                          : Container(),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            expanded = !expanded;
                                          });
                                        },
                                        child: Container(
                                          height: 45,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color:
                                                themeProvider.isDarkThemeEnabled
                                                    ? darkBackgroundColor
                                                    : lightBackgroundColor,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border: Border.all(
                                              color: themeProvider
                                                      .isDarkThemeEnabled
                                                  ? darkThemeBorder
                                                  : Colors.grey.shade200,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              CustomText(
                                                expanded
                                                    ? "View less"
                                                    : 'View all',
                                                type: FontStyle.title,
                                                color: const Color.fromRGBO(
                                                    63, 118, 255, 1),
                                              ),

                                              const SizedBox(width: 10),
                                              //icon
                                              Icon(
                                                //arrow down icon

                                                expanded
                                                    ? Icons
                                                        .keyboard_arrow_up_rounded
                                                    : Icons.keyboard_arrow_down,
                                                color: const Color.fromRGBO(
                                                    63, 118, 255, 1),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      // issueProvider.issueDetails[
                                      //                 'issue_attachment'] !=
                                      //             null &&
                                      //         issueProvider
                                      //             .issueDetails[
                                      //                 'issue_attachment']
                                      //             .isNotEmpty
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                              height: spaceBetweenSections),
                                          const CustomText(
                                            'Attachments',
                                            type: FontStyle.description,
                                            // color: themeProvider.secondaryTextColor,
                                          ),
                                          const SizedBox(
                                              height:
                                                  spaceBetweenSectionsAndItems),
                                          attachmentsWidget(),
                                          Container(
                                            height: 45,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: themeProvider
                                                      .isDarkThemeEnabled
                                                  ? darkBackgroundColor
                                                  : const Color.fromRGBO(
                                                      250, 250, 250, 1),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              border: Border.all(
                                                color: Colors.blueAccent,
                                              ),
                                            ),
                                            margin: const EdgeInsets.only(
                                                bottom: 10),
                                            child: InkWell(
                                              onTap: () {
                                                if (issueProvider
                                                        .attachmentState !=
                                                    StateEnum.loading) {
                                                  showModalBottomSheet(
                                                    isScrollControlled: true,
                                                    enableDrag: true,
                                                    shape:
                                                        const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(30),
                                                        topRight:
                                                            Radius.circular(30),
                                                      ),
                                                    ),
                                                    context: context,
                                                    builder: (ctx) {
                                                      return Padding(
                                                        padding: EdgeInsets.only(
                                                            bottom:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .viewInsets
                                                                    .bottom),
                                                        child:
                                                            AddAttachmentsSheet(
                                                          projectId: ref
                                                              .read(ProviderList
                                                                  .projectProvider)
                                                              .currentProject['id'],
                                                          slug: ref
                                                              .read(ProviderList
                                                                  .workspaceProvider)
                                                              .selectedWorkspace!
                                                              .workspaceSlug,
                                                          issueId:
                                                              widget.issueId,
                                                        ),
                                                      );
                                                    },
                                                  );
                                                }
                                              },
                                              child: Center(
                                                child: CustomText(
                                                  issueProvider
                                                              .attachmentState ==
                                                          StateEnum.loading
                                                      ? 'Uploading...'
                                                      : 'Click to upload file here',
                                                  color: Colors.blueAccent,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(
                                          height: spaceBetweenSections),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              CustomText(
                                                'Links',
                                                type: FontStyle.description,
                                                // color: themeProvider.secondaryTextColor,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                              height:
                                                  spaceBetweenSectionsAndItems),
                                          linksWidget(),
                                          Container(
                                            height: 45,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: themeProvider
                                                      .isDarkThemeEnabled
                                                  ? darkBackgroundColor
                                                  : const Color.fromRGBO(
                                                      250, 250, 250, 1),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              border: Border.all(
                                                color: getBorderColor(
                                                    themeProvider),
                                              ),
                                            ),
                                            margin: const EdgeInsets.only(
                                                bottom: 10),
                                            child: InkWell(
                                              onTap: () {
                                                if (projectProvider.role !=
                                                        Role.admin &&
                                                    projectProvider.role !=
                                                        Role.member) {
                                                  CustomToast().showToast(
                                                      context,
                                                      accessRestrictedMSG);
                                                  return;
                                                }
                                                showModalBottomSheet(
                                                  isScrollControlled: true,
                                                  enableDrag: true,
                                                  // constraints: BoxConstraints(
                                                  //     maxHeight:
                                                  //         MediaQuery.of(context)
                                                  //                 .size
                                                  //                 .height *
                                                  //             0.7),
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(30),
                                                    topRight:
                                                        Radius.circular(30),
                                                  )),
                                                  context: context,
                                                  builder: (ctx) {
                                                    return SingleChildScrollView(
                                                      child: Padding(
                                                        padding: EdgeInsets.only(
                                                            bottom:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .viewInsets
                                                                    .bottom),
                                                        child: AddLinkSheet(
                                                          issueId:
                                                              widget.issueId,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                              child: const Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.add,
                                                      color: greyColor),
                                                  CustomText('Add'),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                          height: spaceBetweenSections),
                                      const CustomText(
                                        'Activity',
                                        type: FontStyle.description,
                                        // color: themeProvider.secondaryTextColor,
                                      ),
                                      const SizedBox(
                                          height: spaceBetweenSectionsAndItems),
                                      Container(
                                        decoration: BoxDecoration(
                                          color:
                                              themeProvider.isDarkThemeEnabled
                                                  ? darkBackgroundColor
                                                  : lightBackgroundColor,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: Border.all(
                                            color:
                                                getBorderColor(themeProvider),
                                          ),
                                        ),
                                        padding: const EdgeInsets.all(15),
                                        child: Column(
                                          children: [
                                            ListView.builder(
                                              primary: false,
                                              shrinkWrap: true,
                                              itemCount: issueProvider
                                                  .issueActivity.length,
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 15),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      issueProvider.issueActivity[
                                                                          index]
                                                                      [
                                                                      'comment_stripped'] !=
                                                                  null &&
                                                              issueProvider.issueActivity[
                                                                          index]
                                                                      [
                                                                      'field'] ==
                                                                  null
                                                          ? SizedBox(
                                                              width:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                              child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Stack(
                                                                    children: [
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.only(right: 10),
                                                                        child:
                                                                            CircleAvatar(
                                                                          backgroundColor: themeProvider.isDarkThemeEnabled
                                                                              ? lightBackgroundColor
                                                                              : Colors.black54,
                                                                          radius:
                                                                              15,
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                CustomText(
                                                                              issueProvider.issueActivity[index]['actor_detail']['email'][0].toString().toUpperCase(),
                                                                              // color: Colors.black,
                                                                              type: FontStyle.buttonText,
                                                                              color: themeProvider.isDarkThemeEnabled ? Colors.black : Colors.white,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Positioned(
                                                                        right:
                                                                            0,
                                                                        bottom:
                                                                            -2,
                                                                        child:
                                                                            Container(
                                                                          decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(3),
                                                                              color: Colors.grey[200]),
                                                                          padding:
                                                                              const EdgeInsets.all(2),
                                                                          child:
                                                                              const Icon(
                                                                            Icons.comment_outlined,
                                                                            size:
                                                                                12,
                                                                          ),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                  // const SizedBox(
                                                                  //   width: 10,
                                                                  // ),
                                                                  Expanded(
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        CustomText(
                                                                          issueProvider.issueActivity[index]['actor_detail']['first_name'] + ' ${issueProvider.issueActivity[index]['actor_detail']['last_name']}' ??
                                                                              '',
                                                                          type:
                                                                              FontStyle.description,
                                                                        ),
                                                                        const SizedBox(
                                                                          height:
                                                                              10,
                                                                        ),
                                                                        CustomText(
                                                                          'Commented ${checkTimeDifferenc(issueProvider.issueActivity[index]['created_at'])}',
                                                                          type:
                                                                              FontStyle.description,
                                                                        ),
                                                                        const SizedBox(
                                                                          height:
                                                                              10,
                                                                        ),
                                                                        Container(
                                                                          padding: const EdgeInsets.symmetric(
                                                                              vertical: 15,
                                                                              horizontal: 10),
                                                                          decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(6),
                                                                              border: Border.all(color: greyColor),
                                                                              color: themeProvider.isDarkThemeEnabled ? darkBackgroundColor : lightBackgroundColor),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            children: [
                                                                              CustomText(
                                                                                issueProvider.issueActivity[index]['comment_stripped'],
                                                                                type: FontStyle.description,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          : issueProvider.issueActivity[
                                                                              index]
                                                                          [
                                                                          'comment_stripped'] ==
                                                                      null &&
                                                                  issueProvider.issueActivity[
                                                                              index]
                                                                          [
                                                                          'field'] !=
                                                                      null
                                                              ? Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    CircleAvatar(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .grey[100],
                                                                      radius:
                                                                          15,
                                                                      child: Center(
                                                                          child: issueProvider.issueActivity[index]['field'] == 'state'
                                                                              ? const Icon(
                                                                                  Icons.grid_view_outlined,
                                                                                  size: 15,
                                                                                  color: greyColor,
                                                                                )
                                                                              : issueProvider.issueActivity[index]['field'] == 'priority'
                                                                                  ? SvgPicture.asset(
                                                                                      'assets/svg_images/priority.svg',
                                                                                      height: 15,
                                                                                      width: 15,
                                                                                    )
                                                                                  : issueProvider.issueActivity[index]['field'] == 'assignees' || issueProvider.issueActivity[index]['field'] == 'assignee'
                                                                                      ? const Icon(
                                                                                          Icons.people_outline,
                                                                                          size: 18,
                                                                                          color: greyColor,
                                                                                        )
                                                                                      : issueProvider.issueActivity[index]['field'] == 'labels'
                                                                                          ? const Icon(
                                                                                              Icons.local_offer_outlined,
                                                                                              size: 15,
                                                                                              color: greyColor,
                                                                                            )
                                                                                          : issueProvider.issueActivity[index]['field'] == 'blocks'
                                                                                              ? SvgPicture.asset(
                                                                                                  'assets/svg_images/blocked_icon.svg',
                                                                                                  height: 15,
                                                                                                  width: 15,
                                                                                                )
                                                                                              : issueProvider.issueActivity[index]['field'] == 'blocking'
                                                                                                  ? SvgPicture.asset(
                                                                                                      'assets/svg_images/blocking_icon.svg',
                                                                                                      height: 15,
                                                                                                      width: 15,
                                                                                                    )
                                                                                                  : issueProvider.issueActivity[index]['field'] == 'description'
                                                                                                      ? const Icon(Icons.comment_outlined, color: greyColor, size: 15)
                                                                                                      : issueProvider.issueActivity[index]['field'] == 'link'
                                                                                                          ? SvgPicture.asset('assets/svg_images/link.svg', height: 15, width: 15, colorFilter: const ColorFilter.mode(greyColor, BlendMode.srcIn))
                                                                                                          : issueProvider.issueActivity[index]['field'] == 'modules'
                                                                                                              ? SvgPicture.asset('assets/svg_images/module.svg', height: 18, width: 18, colorFilter: const ColorFilter.mode(greyColor, BlendMode.srcIn))
                                                                                                              : issueProvider.issueActivity[index]['field'] == 'cycles'
                                                                                                                  ? SvgPicture.asset('assets/svg_images/cycles_icon.svg', height: 22, width: 22, colorFilter: const ColorFilter.mode(greyColor, BlendMode.srcIn))
                                                                                                                  : issueProvider.issueActivity[index]['field'] == 'attachment'
                                                                                                                      ? SvgPicture.asset('assets/svg_images/attachment.svg', height: 20, width: 20, colorFilter: const ColorFilter.mode(greyColor, BlendMode.srcIn))
                                                                                                                      : SvgPicture.asset('assets/svg_images/calendar_icon.svg', height: 15, width: 15, colorFilter: const ColorFilter.mode(greyColor, BlendMode.srcIn))),
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    SizedBox(
                                                                      width:
                                                                          width *
                                                                              0.7,
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          CustomText(
                                                                            '${activityFormat(issueProvider.issueActivity[index])} ',
                                                                            fontSize:
                                                                                14,
                                                                            type:
                                                                                FontStyle.description,
                                                                            textAlign:
                                                                                TextAlign.left,
                                                                            maxLines:
                                                                                4,
                                                                          ),
                                                                          const SizedBox(
                                                                              height: 6),
                                                                          CustomText(
                                                                            ' ${checkTimeDifferenc(issueProvider.issueActivity[index]['created_at'])}',
                                                                            color: themeProvider.isDarkThemeEnabled
                                                                                ? lightSecondaryBackgroundColor
                                                                                : greyColor,
                                                                            type:
                                                                                FontStyle.smallText,
                                                                            textAlign:
                                                                                TextAlign.left,
                                                                            maxLines:
                                                                                4,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )
                                                              : SizedBox(
                                                                  width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                                  child: Row(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      CircleAvatar(
                                                                        backgroundColor:
                                                                            darkSecondaryBGC,
                                                                        radius:
                                                                            15,
                                                                        child:
                                                                            Center(
                                                                          child: CustomText(
                                                                              issueProvider.issueActivity[index]['actor_detail']['email'][0].toString().toUpperCase(),
                                                                              // color: Colors.black,
                                                                              type: FontStyle.buttonText,
                                                                              color: Colors.white),
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        width:
                                                                            10,
                                                                      ),
                                                                      SizedBox(
                                                                        width: width *
                                                                            0.7,
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            CustomText(
                                                                              issueProvider.issueActivity[index]['comment'],
                                                                              type: FontStyle.description,
                                                                              textAlign: TextAlign.left,
                                                                              maxLines: 4,
                                                                            ),
                                                                            const SizedBox(height: 6),
                                                                            CustomText(
                                                                              checkTimeDifferenc(issueProvider.issueActivity[index]['created_at']),
                                                                              color: themeProvider.isDarkThemeEnabled ? lightSecondaryBackgroundColor : greyColor,
                                                                              type: FontStyle.smallText,
                                                                              textAlign: TextAlign.left,
                                                                              maxLines: 4,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                            //COMMENTS POST
                                            // Row(
                                            //   children: [
                                            //     Expanded(
                                            //       child: TextFormField(
                                            //         decoration: kTextFieldDecoration
                                            //             .copyWith(
                                            //                 enabledBorder:
                                            //                     OutlineInputBorder(
                                            //                   borderSide: BorderSide(
                                            //                       color: themeProvider
                                            //                               .isDarkThemeEnabled
                                            //                           ? darkThemeBorder
                                            //                           : const Color(
                                            //                               0xFFE5E5E5),
                                            //                       width: 1.0),
                                            //                   borderRadius:
                                            //                       const BorderRadius
                                            //                               .all(
                                            //                           Radius.circular(
                                            //                               8)),
                                            //                 ),
                                            //                 disabledBorder:
                                            //                     OutlineInputBorder(
                                            //                   borderSide: BorderSide(
                                            //                       color: themeProvider
                                            //                               .isDarkThemeEnabled
                                            //                           ? darkThemeBorder
                                            //                           : const Color(
                                            //                               0xFFE5E5E5),
                                            //                       width: 1.0),
                                            //                   borderRadius:
                                            //                       const BorderRadius
                                            //                               .all(
                                            //                           Radius.circular(
                                            //                               8)),
                                            //                 ),
                                            //                 focusedBorder:
                                            //                     const OutlineInputBorder(
                                            //                   borderSide:
                                            //                       BorderSide(
                                            //                           color:
                                            //                               primaryColor,
                                            //                           width:
                                            //                               2.0),
                                            //                   borderRadius:
                                            //                       BorderRadius
                                            //                           .all(Radius
                                            //                               .circular(
                                            //                                   8)),
                                            //                 ),
                                            //                 labelText:
                                            //                     'Enter your comment here...'),
                                            //       ),
                                            //     ),
                                            //     const SizedBox(
                                            //       width: 10,
                                            //     ),
                                            //     Container(
                                            //       padding:
                                            //           const EdgeInsets.all(18),
                                            //       decoration: BoxDecoration(
                                            //         borderRadius:
                                            //             BorderRadius.circular(
                                            //                 5),
                                            //         color: primaryColor,
                                            //       ),
                                            //       child: SvgPicture.asset(
                                            //         'assets/svg_images/send_icon.svg',
                                            //         height: 20,
                                            //         width: 20,
                                            //       ),
                                            //     )
                                            //   ],
                                            // )
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 50),
                                      const SizedBox(
                                        height: 20,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const Center(
                      child: Text('Something went wrong'),
                    ),
    );
  }

  Color getBorderColor(ThemeProvider themeProvider) =>
      themeProvider.isDarkThemeEnabled ? darkThemeBorder : Colors.grey.shade200;

  String checkTimeDifferenc(String dateTime) {
    DateTime now = DateTime.now();
    Duration difference = now.difference(DateTime.parse(dateTime));
    String? format;

    if (difference.inDays > 0) {
      format = '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      format = '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      format = '${difference.inMinutes} minutes ago';
    } else {
      format = '${difference.inSeconds} seconds ago';
    }

    return format;
  }

  String activityFormat(Map activity) {
    String formattedActivity = '';
    if (activity['actor_detail']['first_name'] != null &&
        activity['actor_detail']['last_name'] != null) {
      if (activity['field'] == 'description') {
        formattedActivity = activity['actor_detail']['first_name'] +
            " " +
            activity['actor_detail']['last_name'] +
            ' Updated the description';
      } else {
        formattedActivity = activity['comment'].toString().replaceFirst(
            activity['comment'].split(' ').first,
            activity['actor_detail']['first_name'] +
                " " +
                activity['actor_detail']['last_name']);
      }
      return formattedActivity;
    } else {
      return activity['actor_detail']['email'];
    }
  }

  Widget stateWidget() {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var issueProvider = ref.watch(ProviderList.issueProvider);
    var projectProvider = ref.watch(ProviderList.projectProvider);
    return Container(
      height: 45,
      width: double.infinity,
      decoration: BoxDecoration(
        color: themeProvider.isDarkThemeEnabled
            ? darkBackgroundColor
            : lightBackgroundColor,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: getBorderColor(themeProvider),
        ),
      ),
      child: InkWell(
        onTap: () {
          if (projectProvider.role != Role.admin &&
              projectProvider.role != Role.member) {
            CustomToast().showToast(context, accessRestrictedMSG);
            return;
          }
          showModalBottomSheet(
              enableDrag: true,
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.8,
              ),
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              context: context,
              builder: (ctx) => SelectStates(
                    createIssue: false,
                    issueId: widget.issueId,
                  ));
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Row(
            children: [
              //icon
              SvgPicture.asset('assets/svg_images/state_icon.svg',
                  height: 15,
                  width: 15,
                  colorFilter:
                      const ColorFilter.mode(greyColor, BlendMode.srcIn)),
              const SizedBox(width: 10),
              const CustomText(
                'State',
                type: FontStyle.subheading,
                color: Color.fromRGBO(143, 143, 147, 1),
              ),
              Expanded(child: Container()),
              Row(
                children: [
                  CustomText(
                    issueProvider.issueDetails['state_detail']['name'],
                    type: FontStyle.title,
                  ),
                  //issuesProvider.createIssuedata['state'] == null
                  //?
                  const SizedBox(
                    width: 5,
                  ),
                  //: Container(),
                  //issuesProvider.createIssuedata['state'] == null
                  //?
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: themeProvider.isDarkThemeEnabled
                        ? darkSecondaryTextColor
                        : lightSecondaryTextColor,
                  )
                  // : Container(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget assigneesWidget() {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var issueProvider = ref.watch(ProviderList.issueProvider);
    var projectProvider = ref.watch(ProviderList.projectProvider);
    return Container(
      height: 45,
      width: double.infinity,
      decoration: BoxDecoration(
        color: themeProvider.isDarkThemeEnabled
            ? darkBackgroundColor
            : lightBackgroundColor,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: getBorderColor(themeProvider),
        ),
      ),
      child: InkWell(
        onTap: () {
          if (projectProvider.role != Role.admin &&
              projectProvider.role != Role.member) {
            CustomToast().showToast(context, accessRestrictedMSG);
            return;
          }
          showModalBottomSheet(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.8,
              ),
              backgroundColor: Colors.transparent,
              context: context,
              enableDrag: true,
              isScrollControlled: true,
              builder: (ctx) => SelectProjectMembers(
                    createIssue: false,
                    issueId: widget.issueId,
                  ));
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Row(
            children: [
              //icon
              SvgPicture.asset('assets/svg_images/assignee.svg',
                  height: 17,
                  width: 17,
                  colorFilter:
                      const ColorFilter.mode(greyColor, BlendMode.srcIn)),
              const SizedBox(width: 10),

              const CustomText(
                'Assignees',
                type: FontStyle.subheading,
                color: Color.fromRGBO(143, 143, 147, 1),
              ),
              Expanded(child: Container()),
              issueProvider.issueDetails['assignee_details'].isEmpty
                  ? Row(
                      children: [
                        const CustomText(
                          'Select',
                          type: FontStyle.title,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: themeProvider.isDarkThemeEnabled
                              ? darkSecondaryTextColor
                              : lightSecondaryTextColor,
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        ProfileCircleAvatarsWidget(
                          details:
                              issueProvider.issueDetails['assignee_details'],
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: themeProvider.isDarkThemeEnabled
                              ? darkSecondaryTextColor
                              : lightSecondaryTextColor,
                        ),
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }

  Widget priorityWidget() {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var issueProvider = ref.watch(ProviderList.issueProvider);
    var projectProvider = ref.watch(ProviderList.projectProvider);
    return Container(
      height: 45,
      width: double.infinity,
      decoration: BoxDecoration(
        color: themeProvider.isDarkThemeEnabled
            ? darkBackgroundColor
            : lightBackgroundColor,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: getBorderColor(themeProvider),
        ),
      ),
      child: InkWell(
        onTap: () {
          if (projectProvider.role != Role.admin &&
              projectProvider.role != Role.member) {
            CustomToast().showToast(context, accessRestrictedMSG);
            return;
          }
          showModalBottomSheet(
              backgroundColor: Colors.transparent,
              context: context,
              builder: (ctx) => SelectIssuePriority(
                    createIssue: false,
                    issueId: widget.issueId,
                  ));
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Row(
            children: [
              //icon
              SvgPicture.asset('assets/svg_images/priority.svg',
                  height: 15,
                  width: 15,
                  colorFilter:
                      const ColorFilter.mode(greyColor, BlendMode.srcIn)),
              const SizedBox(width: 10),

              const CustomText(
                'Priority',
                type: FontStyle.subheading,
                color: Color.fromRGBO(143, 143, 147, 1),
              ),
              Expanded(child: Container()),
              issueProvider.issueDetails['priority'] == null
                  ? Row(
                      children: [
                        const CustomText(
                          'Select',
                          type: FontStyle.title,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: themeProvider.isDarkThemeEnabled
                              ? darkSecondaryTextColor
                              : lightSecondaryTextColor,
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        CustomText(
                          issueProvider.issueDetails['priority']
                              .toString()
                              .replaceFirst(
                                  issueProvider.issueDetails['priority']
                                      .toString()[0],
                                  issueProvider.issueDetails['priority'][0]
                                      .toString()
                                      .toUpperCase()),
                          type: FontStyle.title,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: themeProvider.isDarkThemeEnabled
                              ? darkSecondaryTextColor
                              : lightSecondaryTextColor,
                        ),
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }

  Widget estimateWidget() {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var issueProvider = ref.watch(ProviderList.issueProvider);
    var projectProvider = ref.watch(ProviderList.projectProvider);
    return Container(
      height: 45,
      width: double.infinity,
      decoration: BoxDecoration(
        color: themeProvider.isDarkThemeEnabled
            ? darkBackgroundColor
            : lightBackgroundColor,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: getBorderColor(themeProvider),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Row(
          children: [
            //icon
            const Icon(
              Icons.change_history,
              size: 17,
              color: greyColor,
            ),
            const SizedBox(width: 10),

            const CustomText(
              'Estimate',
              type: FontStyle.subheading,
              color: Color.fromRGBO(143, 143, 147, 1),
            ),
            Expanded(child: Container()),
            GestureDetector(
              onTap: () {
                if (projectProvider.role != Role.admin &&
                    projectProvider.role != Role.member) {
                  CustomToast().showToast(context, accessRestrictedMSG);
                  return;
                }
                showModalBottomSheet(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.8,
                      minHeight: MediaQuery.of(context).size.height * 0.8,
                    ),
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (ctx) => SelectEstimate(
                          createIssue: false,
                          issueId: widget.issueId,
                        ));
              },
              child: issueProvider.issueDetails['estimate_point'] == null
                  ? Row(
                      children: [
                        const CustomText(
                          'No Estimate',
                          type: FontStyle.title,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: themeProvider.isDarkThemeEnabled
                              ? darkSecondaryTextColor
                              : lightSecondaryTextColor,
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        CustomText(
                          ref
                              .read(ProviderList.estimatesProvider)
                              .estimates
                              .firstWhere((element) {
                            return element['id'] ==
                                ref
                                    .read(ProviderList.projectProvider)
                                    .currentProject['estimate'];
                          })['points'].firstWhere((element) {
                            return element['key'] ==
                                issueProvider.issueDetails['estimate_point'];
                          })['value'],
                          type: FontStyle.title,
                        ),
                      ],
                    ),
            )
          ],
        ),
      ),
    );
  }

  Widget labelWidget(String issueId) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var issueProvider = ref.watch(ProviderList.issueProvider);
    var issuesProvider = ref.watch(ProviderList.issuesProvider);
    var projectProvider = ref.watch(ProviderList.projectProvider);
    return Container(
      //height: 45,
      width: double.infinity,
      decoration: BoxDecoration(
        color: themeProvider.isDarkThemeEnabled
            ? darkBackgroundColor
            : lightBackgroundColor,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: getBorderColor(themeProvider),
        ),
      ),
      child: InkWell(
        onTap: () {
          if (projectProvider.role != Role.admin &&
              projectProvider.role != Role.member) {
            CustomToast().showToast(context, accessRestrictedMSG);
            return;
          }
          showModalBottomSheet(
              isScrollControlled: true,
              enableDrag: true,
              backgroundColor: Colors.transparent,
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.8,
              ),
              context: context,
              builder: (ctx) => SelectIssueLabels(
                    createIssue: false,
                    issueId: widget.issueId,
                  ));
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
          child: Column(
            children: [
              Row(
                children: [
                  //icon
                  Icon(
                    Icons.local_offer_outlined,
                    size: 17,
                    color: themeProvider.isDarkThemeEnabled
                        ? darkSecondaryTextColor
                        : greyColor,
                  ),
                  const SizedBox(width: 8),

                  const CustomText(
                    'Label',
                    type: FontStyle.subheading,
                    color: Color.fromRGBO(143, 143, 147, 1),
                  ),
                  Expanded(child: Container()),
                  issueProvider.issueDetails['label_details'].isEmpty
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const CustomText(
                              'Select',
                              type: FontStyle.title,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.keyboard_arrow_down,
                              color: themeProvider.isDarkThemeEnabled
                                  ? darkSecondaryTextColor
                                  : lightSecondaryTextColor,
                            ),
                          ],
                        )
                      : Wrap(
                          children: [
                            Container(
                                alignment: Alignment.centerLeft,
                                // color: Colors.amber,
                                height: 30,
                                constraints: const BoxConstraints(
                                    maxWidth: 80, minWidth: 30),
                                child: const Row(
                                  children: [
                                    CustomText(
                                      'Select',
                                      type: FontStyle.title,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Icon(
                                      //antenna signal icon
                                      Icons.keyboard_arrow_down_outlined,
                                      color: Color.fromRGBO(143, 143, 147, 1),
                                    ),
                                  ],
                                )),
                          ],
                        ),
                ],
              ),
              issueProvider.issueDetails['label_details'].isNotEmpty &&
                      issueProvider.issueDetails['label_details'] != null
                  ? const SizedBox(
                      height: 10,
                    )
                  : Container(
                      height: 10,
                    ),
              issueProvider.issueDetails['label_details'].isNotEmpty &&
                      issueProvider.issueDetails['label_details'] != null
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            ...issuesProvider.selectedLabels
                                .map((e) => Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                          width: 1,
                                          color: getBorderColor(themeProvider),
                                        ),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              CircleAvatar(
                                                backgroundColor: Color(
                                                  int.parse(
                                                      "FF${e['color'].toString().toUpperCase().replaceAll("#", "")}",
                                                      radix: 16),
                                                ),
                                                radius: 8,
                                              ),
                                              const SizedBox(width: 6),
                                              CustomText(e['name'].toString()),
                                              const SizedBox(width: 2),
                                              GestureDetector(
                                                onTap: () {
                                                  List labelIds = [];

                                                  issuesProvider.selectedLabels
                                                      .removeAt(issuesProvider
                                                          .selectedLabels
                                                          .indexOf(e));

                                                  for (var element
                                                      in issuesProvider
                                                          .selectedLabels) {
                                                    labelIds.add(element['id']);
                                                  }
                                                  issueProvider.upDateIssue(
                                                    slug: ref
                                                        .read(ProviderList
                                                            .workspaceProvider)
                                                        .selectedWorkspace!
                                                        .workspaceSlug,
                                                    projID: ref
                                                        .read(ProviderList
                                                            .projectProvider)
                                                        .currentProject['id'],
                                                    issueID: issueId,
                                                    data: {
                                                      "labels_list": labelIds
                                                    },
                                                    refs: ref,
                                                  );
                                                },
                                                child: const Icon(
                                                  Icons.close,
                                                  size: 20,
                                                  color: greyColor,
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    )),
                          ],
                        ),
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }

  Widget dueDateWidget() {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var issueProvider = ref.watch(ProviderList.issueProvider);
    var projectProvider = ref.watch(ProviderList.projectProvider);
    return Container(
      height: 45,
      width: double.infinity,
      decoration: BoxDecoration(
        color: themeProvider.isDarkThemeEnabled
            ? darkBackgroundColor
            : lightBackgroundColor,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: getBorderColor(themeProvider),
        ),
      ),
      child: InkWell(
        onTap: () async {
          if (projectProvider.role != Role.admin &&
              projectProvider.role != Role.member) {
            CustomToast().showToast(context, accessRestrictedMSG);
            return;
          }
          var date = await showDatePicker(
            builder: (context, child) => Theme(
              data: themeProvider.isDarkThemeEnabled
                  ? ThemeData.dark().copyWith(
                      colorScheme: const ColorScheme.dark(
                        primary: primaryColor,
                      ),
                    )
                  : ThemeData.light().copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: primaryColor,
                      ),
                    ),
              child: child!,
            ),
            context: context,
            initialDate: issueProvider.issueDetails['target_date'] != null
                ? DateTime.parse(issueProvider.issueDetails['target_date'])
                : DateTime.now(),
            firstDate: issueProvider.issueDetails['target_date'] != null
                ? DateTime.parse(issueProvider.issueDetails['target_date'])
                : DateTime.now(),
            lastDate: DateTime(2025),
          );

          if (date != null) {
            setState(() {
              // issuesProvider.createIssuedata[
              //     'due_date'] = date;
            });
            issueProvider.upDateIssue(
                slug: ref
                    .read(ProviderList.workspaceProvider)
                    .selectedWorkspace!
                    .workspaceSlug,
                projID:
                    ref.read(ProviderList.projectProvider).currentProject['id'],
                issueID: widget.issueId,
                data: {
                  "target_date": DateFormat('yyyy-MM-dd').format(date),
                },
                refs: ref);
          }
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Row(
            children: [
              //icon
              SvgPicture.asset('assets/svg_images/calendar_icon.svg',
                  height: 15,
                  width: 15,
                  colorFilter:
                      const ColorFilter.mode(greyColor, BlendMode.srcIn)),
              const SizedBox(width: 10),
              const CustomText(
                'Due Date',
                type: FontStyle.subheading,
                color: Color.fromRGBO(143, 143, 147, 1),
              ),
              Expanded(child: Container()),
              issueProvider.issueDetails['target_date'] == null
                  ? const Row(
                      children: [
                        CustomText(
                          'Select',
                          type: FontStyle.title,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          //antenna signal icon
                          Icons.keyboard_arrow_down_outlined,
                          color: Color.fromRGBO(143, 143, 147, 1),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        CustomText(
                          DateFormat('yyyy-MM-dd').format(DateTime.parse(
                              issueProvider.issueDetails['target_date'])),
                          type: FontStyle.title,
                        ),
                        const SizedBox(width: 10),
                        InkWell(
                          onTap: () {
                            issueProvider.upDateIssue(
                                slug: ref
                                    .read(ProviderList.workspaceProvider)
                                    .selectedWorkspace!
                                    .workspaceSlug,
                                projID: ref
                                    .read(ProviderList.projectProvider)
                                    .currentProject['id'],
                                issueID: widget.issueId,
                                data: {
                                  "target_date": null,
                                },
                                refs: ref);
                          },
                          child: const Icon(
                            Icons.close,
                            size: 20,
                            color: greyColor,
                          ),
                        )
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }

  Widget parentWidget() {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var issueProvider = ref.watch(ProviderList.issueProvider);
    var projectProvider = ref.watch(ProviderList.projectProvider);
    return Container(
      height: 45,
      width: double.infinity,
      decoration: BoxDecoration(
        color: themeProvider.isDarkThemeEnabled
            ? darkBackgroundColor
            : lightBackgroundColor,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: getBorderColor(themeProvider),
        ),
      ),
      child: InkWell(
        onTap: () async {
          if (projectProvider.role != Role.admin &&
              projectProvider.role != Role.member) {
            CustomToast().showToast(context, accessRestrictedMSG);
            return;
          }
          showModalBottomSheet(
              isScrollControlled: false,
              backgroundColor: Colors.transparent,
              context: context,
              builder: (ctx) => IssuesListSheet(
                    // parent: true,
                    type: IssueDetailCategory.parent,
                    issueId: widget.issueId,
                    createIssue: false,
                    // blocking: false,
                  ));
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Row(
            children: [
              //icon
              const Icon(
                //antenna signal icon
                Icons.person_outline_rounded,
                color: Color.fromRGBO(143, 143, 147, 1),
                size: 18,
              ),
              const SizedBox(width: 8),
              const CustomText(
                'Parent',
                type: FontStyle.subheading,
                color: Color.fromRGBO(143, 143, 147, 1),
              ),
              Expanded(child: Container()),
              issueProvider.issueDetails['parent_detail'] == null
                  ? const Row(
                      children: [
                        CustomText(
                          'Select issue',
                          type: FontStyle.title,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          //antenna signal icon
                          Icons.keyboard_arrow_down_outlined,
                          color: Color.fromRGBO(143, 143, 147, 1),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        CustomText(
                          issueProvider.issueDetails['project_detail']
                                  ['identifier'] +
                              '-' +
                              issueProvider.issueDetails['parent_detail']
                                      ['sequence_id']
                                  .toString(),
                          type: FontStyle.title,
                        ),
                        const SizedBox(width: 10),
                        InkWell(
                          onTap: () {
                            issueProvider.upDateIssue(
                              slug: ref
                                  .read(ProviderList.workspaceProvider)
                                  .selectedWorkspace!
                                  .workspaceSlug,
                              projID: ref
                                  .read(ProviderList.projectProvider)
                                  .currentProject['id'],
                              issueID: widget.issueId,
                              data: {"parent": null},
                              refs: ref,
                            );
                          },
                          child: const Icon(
                            Icons.close,
                            size: 20,
                            color: greyColor,
                          ),
                        )
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }

  Widget selectedSubIssues() {
    var issueProvider = ref.watch(ProviderList.issueProvider);
    var themeProvider = ref.watch(ProviderList.themeProvider);
    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: themeProvider.isDarkThemeEnabled
                ? darkBackgroundColor
                : lightBackgroundColor,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: issueProvider.subIssues.isNotEmpty
                  ? getBorderColor(themeProvider)
                  : Colors.transparent,
            ),
          ),
          //padding: const EdgeInsets.all(10),
          child: ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            primary: false,
            itemCount: issueProvider.subIssues.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    //padding: const EdgeInsets.all(5),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                issueProvider.subIssues[index]['project_detail']
                                        ['identifier'] +
                                    '-' +
                                    issueProvider.subIssues[index]
                                            ['sequence_id']
                                        .toString(),
                                color: themeProvider.isDarkThemeEnabled
                                    ? darkSecondaryTextColor
                                    : lightSecondaryTextColor,
                              ),
                              Expanded(
                                child: CustomText(
                                  '  ${issueProvider.subIssues[index]['name']}',
                                  maxLines: 1,
                                  color: themeProvider.isDarkThemeEnabled
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  issueProvider
                                      .deleteSubIssue(
                                          slug: ref
                                              .read(ProviderList
                                                  .workspaceProvider)
                                              .selectedWorkspace!
                                              .workspaceSlug,
                                          projectId: ref
                                              .read(
                                                  ProviderList.projectProvider)
                                              .currentProject['id'],
                                          issueId: issueProvider
                                              .subIssues[index]['id'],
                                          index: index,
                                          buildContext: context)
                                      .then(
                                        (value) => issueProvider.getSubIssues(
                                          slug: ref
                                              .read(ProviderList
                                                  .workspaceProvider)
                                              .selectedWorkspace!
                                              .workspaceSlug,
                                          projectId: ref
                                              .read(
                                                  ProviderList.projectProvider)
                                              .currentProject['id'],
                                          issueId: widget.issueId,
                                        ),
                                      );
                                  setState(
                                    () {
                                      issueProvider.subIssues.removeAt(index);
                                    },
                                  );
                                },
                                child: const Icon(
                                  Icons.close,
                                  size: 20,
                                  color: greyColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  index == issueProvider.subIssues.length - 1
                      ? Container()
                      : Container(
                          width: width,
                          height: 1,
                          color: getBorderColor(themeProvider),
                        )
                ],
              );
            },
          ),
        ),
        issueProvider.subIssues.isNotEmpty
            ? const SizedBox(height: 10)
            : const SizedBox(),
      ],
    );
  }

  Widget blockingWidget(String issueId) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var issueProvider = ref.watch(ProviderList.issueProvider);
    var projectProvider = ref.watch(ProviderList.projectProvider);
    return Container(
      // height: 45,
      width: double.infinity,
      decoration: BoxDecoration(
        color: themeProvider.isDarkThemeEnabled
            ? darkBackgroundColor
            : lightBackgroundColor,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: getBorderColor(themeProvider),
        ),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () async {
              if (projectProvider.role != Role.admin &&
                  projectProvider.role != Role.member) {
                CustomToast().showToast(context, accessRestrictedMSG);
                return;
              }
              showModalBottomSheet(
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (ctx) => IssuesListSheet(
                        // parent: false,
                        issueId: issueProvider.issueDetails['id'],
                        createIssue: false,
                        type: IssueDetailCategory.blocking,
                        // blocking: true,
                      ));
            },
            child: Row(
              children: [
                //icon
                SvgPicture.asset(
                  'assets/svg_images/blocking_icon.svg',
                  height: 15,
                  width: 15,
                ),
                const SizedBox(width: 15),
                const CustomText(
                  'Blocking',
                  type: FontStyle.subheading,
                  color: Color.fromRGBO(143, 143, 147, 1),
                ),
                Expanded(child: Container()),
                const Row(
                  children: [
                    CustomText(
                      'Select issues',
                      type: FontStyle.title,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(
                      //antenna signal icon
                      Icons.keyboard_arrow_down_outlined,
                      color: Color.fromRGBO(143, 143, 147, 1),
                    ),
                  ],
                )
              ],
            ),
          ),
          issueProvider.issueDetails['blocker_issues'].isNotEmpty &&
                  issueProvider.issueDetails['blocker_issues'] != null
              ? const SizedBox(
                  height: 10,
                )
              : Container(),
          issueProvider.issueDetails['blocker_issues'].isNotEmpty &&
                  issueProvider.issueDetails['blocker_issues'] != null
              ? Wrap(spacing: 10, runSpacing: 10, children: [
                  for (int i = 0;
                      i < issueProvider.issueDetails['blocker_issues'].length;
                      i++)
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: lightYellowColor),
                      padding: const EdgeInsets.all(5),
                      child: CustomRichText(
                        widgets: [
                          TextSpan(
                            text: issueProvider.issueDetails['project_detail']
                                    ['identifier'] +
                                '-' +
                                issueProvider.issueDetails['blocker_issues'][i]
                                        ['blocker_issue_detail']['sequence_id']
                                    .toString(),
                          ),
                          WidgetSpan(
                            child: Container(
                              margin: const EdgeInsets.only(left: 5),
                              width: 20,
                              height: 20,
                              child: SimpleLoadingWidget(
                                isLoading: (issueProvider.updateIssueState ==
                                        StateEnum.loading &&
                                    blockingWidgetIssueToBeRemoved ==
                                        issueProvider
                                                .issueDetails['blocker_issues']
                                            [i]['blocker_issue_detail']['id']),
                                child: InkWell(
                                  onTap: () {
                                    List newBlockingList = [
                                      for (int j = 0;
                                          j <
                                              issueProvider
                                                  .issueDetails[
                                                      'blocker_issues']
                                                  .length;
                                          j++)
                                        if (issueProvider.issueDetails[
                                                'blocker_issues'][j] !=
                                            issueProvider.issueDetails[
                                                'blocker_issues'][i])
                                          issueProvider.issueDetails[
                                                  'blocker_issues'][j]
                                              ['blocker_issue_detail']['id']
                                    ];

                                    blockingWidgetIssueToBeRemoved =
                                        issueProvider
                                                .issueDetails['blocker_issues']
                                            [i]['blocker_issue_detail']['id'];

                                    issueProvider.upDateIssue(
                                      slug: ref
                                          .read(ProviderList.workspaceProvider)
                                          .selectedWorkspace!
                                          .workspaceSlug,
                                      projID: ref
                                          .read(ProviderList.projectProvider)
                                          .currentProject['id'],
                                      issueID: issueId,
                                      data: {
                                        //"blocker_issues": newBlockingList
                                        "blockers_list": newBlockingList
                                      },
                                      refs: ref,
                                      buildContext: context,
                                    );
                                  },
                                  child: const Icon(
                                    Icons.close,
                                    size: 20,
                                    color: greyColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                ])
              : Container()
        ],
      ),
    );
  }

  Widget blockedByWidget(String issueId) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var issueProvider = ref.watch(ProviderList.issueProvider);
    var projectProvider = ref.watch(ProviderList.projectProvider);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: themeProvider.isDarkThemeEnabled
            ? darkBackgroundColor
            : lightBackgroundColor,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: getBorderColor(themeProvider),
        ),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () async {
              if (projectProvider.role != Role.admin &&
                  projectProvider.role != Role.member) {
                CustomToast().showToast(context, accessRestrictedMSG);
                return;
              }
              showModalBottomSheet(
                isScrollControlled: false,
                backgroundColor: Colors.transparent,
                context: context,
                builder: (ctx) => IssuesListSheet(
                  // parent: false,
                  issueId: issueProvider.issueDetails['id'],
                  createIssue: false,
                  // blocking: false,
                  type: IssueDetailCategory.blocked,
                ),
              );
            },
            child: Row(
              children: [
                //icon
                SvgPicture.asset(
                  'assets/svg_images/blocked_icon.svg',
                  height: 15,
                  width: 15,
                ),
                const SizedBox(width: 15),
                const CustomText(
                  'Blocked by',
                  type: FontStyle.subheading,
                  color: Color.fromRGBO(143, 143, 147, 1),
                ),
                Expanded(child: Container()),
                const Row(
                  children: [
                    CustomText(
                      'Select issues',
                      type: FontStyle.title,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(
                      //antenna signal icon
                      Icons.keyboard_arrow_down_outlined,
                      color: Color.fromRGBO(143, 143, 147, 1),
                    ),
                  ],
                )
              ],
            ),
          ),
          issueProvider.issueDetails['blocked_issues'].isNotEmpty &&
                  issueProvider.issueDetails['blocked_issues'] != null
              ? const SizedBox(
                  height: 10,
                )
              : Container(),
          issueProvider.issueDetails['blocked_issues'].isNotEmpty &&
                  issueProvider.issueDetails['blocked_issues'] != null
              ? Wrap(spacing: 10, runSpacing: 10, children: [
                  for (int i = 0;
                      i < issueProvider.issueDetails['blocked_issues'].length;
                      i++)
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: lightYellowColor),
                      padding: const EdgeInsets.all(5),
                      child: CustomRichText(
                        widgets: [
                          TextSpan(
                            text: issueProvider.issueDetails['project_detail']
                                    ['identifier'] +
                                '-' +
                                issueProvider.issueDetails['blocked_issues'][i]
                                        ['blocked_issue_detail']['sequence_id']
                                    .toString(),
                          ),
                          WidgetSpan(
                            child: Container(
                              margin: const EdgeInsets.only(left: 5),
                              width: 20,
                              height: 20,
                              child: SimpleLoadingWidget(
                                isLoading: (issueProvider.updateIssueState ==
                                        StateEnum.loading &&
                                    blockedByWidgetIssueToBeRemoved ==
                                        issueProvider
                                                .issueDetails['blocked_issues']
                                            [i]['blocked_issue_detail']['id']),
                                child: InkWell(
                                  onTap: () {
                                    List newBlockingList = [
                                      for (int j = 0;
                                          j <
                                              issueProvider
                                                  .issueDetails[
                                                      'blocked_issues']
                                                  .length;
                                          j++)
                                        if (issueProvider.issueDetails[
                                                'blocked_issues'][j] !=
                                            issueProvider.issueDetails[
                                                'blocked_issues'][i])
                                          issueProvider.issueDetails[
                                                  'blocked_issues'][j]
                                              ['blocked_issue_detail']['id']
                                    ];
                                    blockedByWidgetIssueToBeRemoved =
                                        issueProvider
                                                .issueDetails['blocked_issues']
                                            [i]['blocked_issue_detail']['id'];

                                    issueProvider.upDateIssue(
                                      slug: ref
                                          .read(ProviderList.workspaceProvider)
                                          .selectedWorkspace!
                                          .workspaceSlug,
                                      projID: ref
                                          .read(ProviderList.projectProvider)
                                          .currentProject['id'],
                                      issueID: issueId,
                                      data: {
                                        //"blocker_issues": newBlockingList
                                        "blocks_list": newBlockingList
                                      },
                                      refs: ref,
                                      buildContext: context,
                                    );
                                  },
                                  child: const Icon(
                                    Icons.close,
                                    size: 20,
                                    color: greyColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ])
              : Container(),
        ],
      ),
    );
  }

  Widget cyclesWidget() {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var issueProvider = ref.watch(ProviderList.issueProvider);
    var projectProvider = ref.watch(ProviderList.projectProvider);
    return Container(
      height: 45,
      width: double.infinity,
      decoration: BoxDecoration(
        color: themeProvider.isDarkThemeEnabled
            ? darkBackgroundColor
            : lightBackgroundColor,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: getBorderColor(themeProvider),
        ),
      ),
      child: InkWell(
        onTap: () {
          if (projectProvider.role != Role.admin &&
              projectProvider.role != Role.member) {
            CustomToast().showToast(context, accessRestrictedMSG);
            return;
          }
          showModalBottomSheet(
              isScrollControlled: true,
              enableDrag: true,
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.8,
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              context: context,
              builder: (ctx) => IssueDetailCyclesList(
                    cycleId: issueProvider.issueDetails['issue_cycle'] != null
                        ? issueProvider.issueDetails['issue_cycle']
                            ['cycle_detail']['id']
                        : '',
                    cycleIssueId:
                        issueProvider.issueDetails['issue_cycle'] != null
                            ? issueProvider.issueDetails['issue_cycle']['id']
                            : '',
                    issueId: widget.issueId,
                  ));
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Row(
            children: [
              //icon
              SvgPicture.asset('assets/svg_images/cycles_icon.svg'),
              const SizedBox(width: 8),
              const CustomText(
                'Cycle',
                type: FontStyle.subheading,
                color: Color.fromRGBO(143, 143, 147, 1),
              ),
              Expanded(child: Container()),
              Row(
                children: [
                  CustomText(
                    issueProvider.issueDetails['issue_cycle'] != null
                        ? issueProvider.issueDetails['issue_cycle']
                            ['cycle_detail']['name']
                        : 'No Cycle',
                    type: FontStyle.title,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: themeProvider.isDarkThemeEnabled
                        ? darkSecondaryTextColor
                        : lightSecondaryTextColor,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget moduleWidget() {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var issueProvider = ref.watch(ProviderList.issueProvider);
    var projectProvider = ref.watch(ProviderList.projectProvider);
    return Container(
      height: 45,
      width: double.infinity,
      decoration: BoxDecoration(
        color: themeProvider.isDarkThemeEnabled
            ? darkBackgroundColor
            : lightBackgroundColor,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: getBorderColor(themeProvider),
        ),
      ),
      child: InkWell(
        onTap: () {
          if (projectProvider.role != Role.admin &&
              projectProvider.role != Role.member) {
            CustomToast().showToast(context, accessRestrictedMSG);
            return;
          }
          showModalBottomSheet(
              isScrollControlled: true,
              enableDrag: true,
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.8,
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              context: context,
              builder: (ctx) => IssueDetailMoudlesList(
                    moduleId: issueProvider.issueDetails['issue_module'] != null
                        ? issueProvider.issueDetails['issue_module']
                            ['module_detail']['id']
                        : '',
                    moduleIssueId:
                        issueProvider.issueDetails['issue_module'] != null
                            ? issueProvider.issueDetails['issue_module']['id']
                            : '',
                    issueId: widget.issueId,
                  ));
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Row(
            children: [
              //icon
              SvgPicture.asset('assets/svg_images/module.svg',
                  height: 20,
                  width: 20,
                  colorFilter:
                      const ColorFilter.mode(greyColor, BlendMode.srcIn)),
              const SizedBox(width: 10),
              const CustomText(
                'Module',
                type: FontStyle.subheading,
                color: Color.fromRGBO(143, 143, 147, 1),
              ),
              Expanded(child: Container()),
              issueProvider.issueDetails['issue_module'] != null
                  ? Container(
                      constraints: BoxConstraints(maxWidth: width * 0.4),
                      width: width * 0.4,
                      child: Row(
                        children: [
                          SizedBox(
                            width: width * 0.32,
                            child: CustomText(
                              issueProvider.issueDetails['issue_module']
                                  ['module_detail']['name'],
                              type: FontStyle.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.end,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Spacer(),
                          Icon(
                            Icons.keyboard_arrow_down,
                            color: themeProvider.isDarkThemeEnabled
                                ? darkSecondaryTextColor
                                : lightSecondaryTextColor,
                          ),
                        ],
                      ),
                    )
                  : Row(
                      children: [
                        const CustomText(
                          'No Module',
                          type: FontStyle.title,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: themeProvider.isDarkThemeEnabled
                              ? darkSecondaryTextColor
                              : lightSecondaryTextColor,
                        ),
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }

  Widget attachmentsWidget() {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var issueProvider = ref.watch(ProviderList.issueProvider);
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      primary: false,
      itemCount: issueProvider.issueDetails['issue_attachment'].length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () async {
            await launchUrl(Uri.parse(issueProvider
                .issueDetails['issue_attachment'][index]['asset']));
          },
          child: Container(
            width: width * 0.4 + 50,
            decoration: BoxDecoration(
              color: themeProvider.isDarkThemeEnabled
                  ? darkBackgroundColor
                  : lightBackgroundColor,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: getBorderColor(themeProvider),
              ),
            ),
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                isItAnImageExtension(issueProvider
                        .issueDetails['issue_attachment'][index]['attributes']
                            ['name']
                        .toString()
                        .split('.')
                        .last
                        .toUpperCase())
                    ? SvgPicture.asset("assets/svg_images/image.svg",
                        width: 23,
                        height: 23,
                        colorFilter: ColorFilter.mode(
                            themeProvider.isDarkThemeEnabled
                                ? darkPrimaryTextColor
                                : lightPrimaryTextColor,
                            BlendMode.srcIn))
                    : SvgPicture.asset("assets/svg_images/file.svg",
                        width: 23,
                        height: 23,
                        colorFilter: ColorFilter.mode(
                            themeProvider.isDarkThemeEnabled
                                ? darkPrimaryTextColor
                                : lightPrimaryTextColor,
                            BlendMode.srcIn)),
                const SizedBox(width: 5),
                Expanded(
                  child: CustomText(
                    issueProvider.issueDetails['issue_attachment'][index]
                            ['attributes']['name'] ??
                        '',
                    type: FontStyle.description,
                    maxLines: 1,
                  ),
                ),
                //const Spacer(),
                SimpleLoadingWidget(
                  isLoading:
                      (issueProvider.updateIssueState == StateEnum.loading &&
                          attachmentToBeRemoved ==
                              issueProvider.issueDetails['issue_attachment']
                                  [index]['id']),
                  child: InkWell(
                    onTap: () {
                      attachmentToBeRemoved = issueProvider
                          .issueDetails['issue_attachment'][index]['id'];
                      issueProvider.removeIssueAttachment(
                          projectId: ref
                              .read(ProviderList.projectProvider)
                              .currentProject['id'],
                          slug: ref
                              .read(ProviderList.workspaceProvider)
                              .selectedWorkspace!
                              .workspaceSlug,
                          issueId: widget.issueId,
                          attachmentId: issueProvider
                              .issueDetails['issue_attachment'][index]['id'],
                          index: index);
                    },
                    child: SvgPicture.asset(
                      'assets/svg_images/delete.svg',
                      height: 20,
                      width: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget linksWidget() {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var issueProvider = ref.watch(ProviderList.issueProvider);
    return ListView.builder(
      padding: EdgeInsets.zero,
      primary: false,
      shrinkWrap: true,
      itemCount: issueProvider.issueDetails['issue_link'].length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () async {
            await launchUrl(Uri.parse(
                issueProvider.issueDetails['issue_link'][index]['url']));
          },
          child: Container(
            height: 45,
            width: double.infinity,
            decoration: BoxDecoration(
              color: themeProvider.isDarkThemeEnabled
                  ? darkBackgroundColor
                  : lightBackgroundColor,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: getBorderColor(themeProvider),
              ),
            ),
            margin: const EdgeInsets.only(bottom: 10),
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/svg_images/link.svg',
                        height: 15,
                        width: 15,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      CustomText(
                        issueProvider.issueDetails['issue_link'][index]
                            ['title'],
                        type: FontStyle.description,
                      ),
                    ],
                  ),
                  SimpleLoadingWidget(
                    isLoading:
                        (issueProvider.addLinkState == StateEnum.loading &&
                            linkToBeRemoved ==
                                issueProvider.issueDetails['issue_link'][index]
                                    ['id']),
                    child: InkWell(
                        onTap: () {
                          linkToBeRemoved = issueProvider
                              .issueDetails['issue_link'][index]['id'];
                          issueProvider.addLink(
                              projectId: ref
                                  .watch(ProviderList.projectProvider)
                                  .currentProject['id'],
                              slug: ref
                                  .watch(ProviderList.workspaceProvider)
                                  .selectedWorkspace!
                                  .workspaceSlug,
                              issueId: widget.issueId,
                              data: {},
                              method: CRUD.delete,
                              linkId: issueProvider.issueDetails['issue_link']
                                  [index]['id'],
                              buildContext: context);
                        },
                        child: SvgPicture.asset(
                          'assets/svg_images/delete.svg',
                          height: 20,
                          width: 20,
                        )),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget containerOnEmptyData(bool? isDarkThemeEnabled) {
    return Container(
      height: 45,
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDarkThemeEnabled ?? false
            ? darkBackgroundColor
            : const Color.fromRGBO(240, 240, 240, 1),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: isDarkThemeEnabled == null
              ? Colors.grey.shade200
              : isDarkThemeEnabled
                  ? darkThemeBorder
                  : Colors.grey.shade200,
        ),
      ),
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () {},
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: greyColor),
            CustomText('Add'),
          ],
        ),
      ),
    );
  }
}
