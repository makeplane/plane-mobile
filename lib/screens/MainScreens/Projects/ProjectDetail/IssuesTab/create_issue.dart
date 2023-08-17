import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:plane_startup/bottom_sheets/issues_list_sheet.dart';
import 'package:plane_startup/bottom_sheets/selectProjectSheet.dart';
import 'package:plane_startup/bottom_sheets/select_estimate.dart';
import 'package:plane_startup/bottom_sheets/select_issue_labels.dart';
import 'package:plane_startup/bottom_sheets/select_priority.dart';
import 'package:plane_startup/bottom_sheets/select_project_members.dart';
import 'package:plane_startup/bottom_sheets/select_states.dart';
import 'package:plane_startup/config/const.dart';
import 'package:plane_startup/config/notification_serivce.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/provider/theme_provider.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/utils/enums.dart';
import 'package:plane_startup/widgets/custom_app_bar.dart';
import 'package:plane_startup/widgets/custom_button.dart';
import 'package:plane_startup/widgets/custom_text.dart';
import 'package:plane_startup/widgets/loading_widget.dart';

class CreateIssue extends ConsumerStatefulWidget {
  final String? moduleId;
  final String? cycleId;
  final String? projectId;
  const CreateIssue({
    super.key,
    this.moduleId,
    this.cycleId,
    this.projectId,
  });

  @override
  ConsumerState<CreateIssue> createState() => _CreateIssueState();
}

class _CreateIssueState extends ConsumerState<CreateIssue> {
  NotificationsServices notificationsServices = NotificationsServices();

  var tempStatesData = {};
  var tempStates = {};
  List tempStateOrdering = [];
  var tempStatesIcons = {};
  var tempLabels = [];
  var tempIssues = [];
  var tempAssignees = [];

  @override
  void initState() {
    var prov = ref.read(ProviderList.issuesProvider);
    var projectProvider = ref.read(ProviderList.projectProvider);
    notificationsServices.initialiseNotifications();
    prov.createIssueProjectData['name'] = widget.projectId != null
        ? projectProvider.projects
            .firstWhere((element) => element['id'] == widget.projectId)['name']
        : ref.read(ProviderList.projectProvider).currentProject['name'];
    prov.createIssueProjectData['id'] = widget.projectId ??
        ref.read(ProviderList.projectProvider).currentProject['id'];
    var themeProvider = ref.read(ProviderList.themeProvider);
    tempStatesData = prov.statesData;
    tempStates = prov.states;
    tempStateOrdering = prov.stateOrdering;
    tempStatesIcons = prov.stateIcons;
    tempLabels = prov.labels;
    tempIssues = ref.read(ProviderList.searchIssueProvider).issues;
    tempAssignees = prov.members;

    // if (prov.states.isEmpty) {
    prov
        .getStates(
            slug: ref
                .read(ProviderList.workspaceProvider)
                .selectedWorkspace!
                .workspaceSlug,
            projID: widget.projectId ??
                ref.read(ProviderList.projectProvider).currentProject['id'])
        .then((value) {
      prov.createIssuedata['state'] =
          (prov.states.isNotEmpty ? prov.states.keys.first : null);
    });
    // }
    // prov.getLabels(
    //     slug: ref
    //         .read(ProviderList.workspaceProvider)
    //         .selectedWorkspace!
    //         .workspaceSlug,
    //     projID: widget.projectId ??
    //         ref.read(ProviderList.projectProvider).currentProject['id']);
    // prov.getProjectMembers(
    //     slug: ref
    //         .read(ProviderList.workspaceProvider)
    //         .selectedWorkspace!
    //         .workspaceSlug,
    //     projID: widget.projectId ??
    //         ref.read(ProviderList.projectProvider).currentProject['id']);

    ref.read(ProviderList.estimatesProvider).getEstimates(
        slug: ref
            .read(ProviderList.workspaceProvider)
            .selectedWorkspace!
            .workspaceSlug,
        projID: widget.projectId ??
            ref.read(ProviderList.projectProvider).currentProject['id']);

    prov.createIssuedata['priority'] = {
      'name': 'None',
      'icon': Icon(
        Icons.remove_circle_outline_rounded,
        color: themeProvider.isDarkThemeEnabled
            ? darkSecondaryTextColor
            : lightSecondaryTextColor,
      ),
    };
    prov.createIssuedata['members'] = null;
    prov.createIssuedata['labels'] = null;
    prov.createIssueParent = '';

    // prov.createIssuedata['state'] = prov.createIssuedata['state'] ??
    //     (prov.states.isNotEmpty ? prov.states.keys.first : null);
    super.initState();
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController title = TextEditingController();
  var expanded = false;

  // @override
  // void dispose() {
  //   var issuesProvider = ref.read(ProviderList.issuesProvider);
  //   issuesProvider.createIssueParent = '';
  //   issuesProvider.createIssueParentId = '';
  //   issuesProvider.setsState();
  //   super.dispose();
  // }

  DateTime? startDate;
  DateTime? dueDate;

  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var issuesProvider = ref.watch(ProviderList.issuesProvider);
    //var issueProvider = ref.watch(ProviderList.issueProvider);
    var projectProvider = ref.watch(ProviderList.projectProvider);
    var estimatesProvider = ref.watch(ProviderList.estimatesProvider);
    if (issuesProvider.createIssuedata['state'] == null &&
        issuesProvider.states.isNotEmpty) {
      issuesProvider.createIssuedata['state'] =
          issuesProvider.states.keys.first;
    }
    //log(ref.read(ProviderList.projectProvider).currentProject['id'].toString());
    return WillPopScope(
      onWillPop: () async {
        log('WillPopScope');
        issuesProvider.createIssuedata = {};
        issuesProvider.statesData = tempStatesData;
        issuesProvider.states = tempStates;
        issuesProvider.stateOrdering = tempStateOrdering;
        issuesProvider.stateIcons = tempStatesIcons;
        issuesProvider.labels = tempLabels;
        issuesProvider.members = tempAssignees;
        issuesProvider.setsState();
        ref.read(ProviderList.searchIssueProvider).issues = tempIssues;
        return true;
      },
      child: Scaffold(
        //#f5f5f5f5 color
        // backgroundColor: themeProvider.isDarkThemeEnabled
        //     ? darkSecondaryBackgroundColor
        //     : const Color.fromRGBO(248, 249, 250, 1),
        appBar: CustomAppBar(
          onPressed: () {
            issuesProvider.createIssuedata = {};
            issuesProvider.createIssuedata = {};
            issuesProvider.statesData = tempStatesData;
            issuesProvider.states = tempStates;
            issuesProvider.stateOrdering = tempStateOrdering;
            issuesProvider.stateIcons = tempStatesIcons;
            issuesProvider.labels = tempLabels;
            issuesProvider.members = tempAssignees;
            issuesProvider.setsState();
            ref.read(ProviderList.searchIssueProvider).issues = tempIssues;
            Navigator.pop(context);
          },
          text: 'Create Issue',
        ),
        body: LoadingWidget(
          loading: issuesProvider.createIssueState == StateEnum.loading ||
              issuesProvider.statesState == StateEnum.loading,
          widgetClass: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            log(issuesProvider.createIssuedata.toString());
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          height: 1,
                          color: themeProvider.isDarkThemeEnabled
                              ? darkThemeBorder
                              : strokeColor,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 23, left: 15, right: 15),
                          child: Form(
                            key: formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //form conatining title and description
                                // Text(
                                //   'Title',
                                //   style: TextStyle(
                                //     color: themeProvider.secondaryTextColor,
                                //     fontSize: 16,
                                //     fontWeight: FontWeightt.Medium,
                                //   ),
                                // ),

                                //dropdown for selecting project
                                Row(
                                  children: [
                                    CustomText(
                                      'Project',
                                      type: FontStyle.Medium,
                                      color: themeProvider
                                          .themeManager.primaryTextColor,
                                    ),
                                    const CustomText(
                                      ' *',
                                      type: FontStyle.Small,
                                      color: Colors.red,
                                      // color: themeProvider.secondaryTextColor,
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 5),
                                Container(
                                  height: 50,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    border: Border.all(
                                      color: themeProvider
                                          .themeManager.borderSubtle01Color,
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                      showModalBottomSheet(
                                          constraints: BoxConstraints(
                                            maxHeight: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.8,
                                          ),
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          context: context,
                                          builder: (ctx) =>
                                              const SelectProject()).then(
                                          (value) {
                                        issuesProvider
                                            .getStates(
                                                slug: ref
                                                    .read(ProviderList
                                                        .workspaceProvider)
                                                    .selectedWorkspace!
                                                    .workspaceSlug,
                                                projID: issuesProvider
                                                        .createIssueProjectData[
                                                    'id'])
                                            .then((value) {
                                          issuesProvider
                                                  .createIssuedata['state'] =
                                              issuesProvider.states.keys.first;
                                        });
                                        ref
                                            .read(
                                                ProviderList.estimatesProvider)
                                            .getEstimates(
                                                slug: ref
                                                    .read(ProviderList
                                                        .workspaceProvider)
                                                    .selectedWorkspace!
                                                    .workspaceSlug,
                                                projID: issuesProvider
                                                        .createIssueProjectData[
                                                    'id']);

                                        issuesProvider
                                            .createIssuedata['labels'] = null;
                                        issuesProvider
                                            .createIssuedata['members'] = null;
                                        issuesProvider.createIssuedata[
                                            'estimate_point'] = null;

                                        issuesProvider.createIssueParent = '';
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      child: Row(
                                        children: [
                                          //icon
                                          Expanded(
                                              child: CustomText(
                                            issuesProvider
                                                .createIssueProjectData['name'],
                                            type: FontStyle.Medium,
                                            color: themeProvider
                                                .themeManager.primaryTextColor,
                                            fontWeight: FontWeightt.Medium,
                                          ))
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 10),

                                Row(
                                  children: [
                                    CustomText(
                                      'Title',
                                      type: FontStyle.Medium,
                                      color: themeProvider
                                          .themeManager.primaryTextColor,
                                    ),
                                    const CustomText(
                                      ' *',
                                      type: FontStyle.Small,
                                      color: Colors.red,
                                      // color: themeProvider.secondaryTextColor,
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 5),
                                TextFormField(
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return '*required';
                                    }
                                    return null;
                                  },
                                  maxLines: null,
                                  controller: title,
                                  decoration: themeProvider
                                      .themeManager.textFieldDecoration,
                                ),

                                // const SizedBox(height: 20),

                                // const CustomText(
                                //   'Description',
                                //   type: FontStyle.Small,
                                //   // color: themeProvider.secondaryTextColor,
                                // ),
                                // const SizedBox(height: 10),
                                // TextField(
                                //     maxLines: 4,
                                //     decoration: themeProvider.themeManager.textFieldDecoration.copyWith(
                                //       enabledBorder: OutlineInputBorder(
                                //         borderSide: BorderSide(
                                //             color:
                                //                 themeProvider.isDarkThemeEnabled
                                //                     ? darkThemeBorder
                                //                     : const Color(0xFFE5E5E5),
                                //             width: 1.0),
                                //         borderRadius: const BorderRadius.all(
                                //             Radius.circular(8)),
                                //       ),
                                //       disabledBorder: OutlineInputBorder(
                                //         borderSide: BorderSide(
                                //             color:
                                //                 themeProvider.isDarkThemeEnabled
                                //                     ? darkThemeBorder
                                //                     : const Color(0xFFE5E5E5),
                                //             width: 1.0),
                                //         borderRadius: const BorderRadius.all(
                                //             Radius.circular(8)),
                                //       ),
                                //       focusedBorder: const OutlineInputBorder(
                                //         borderSide: BorderSide(
                                //             color: primaryColor, width: 2.0),
                                //         borderRadius: BorderRadius.all(
                                //             Radius.circular(8)),
                                //       ),
                                //     )),

                                const SizedBox(height: 20),
                                CustomText(
                                  'Details',
                                  type: FontStyle.Medium,
                                  color: themeProvider
                                      .themeManager.primaryTextColor,
                                  // color: themeProvider.secondaryTextColor,
                                ),
                                const SizedBox(height: 5),
                                //three dropdown each occupying full width of the screen , each consits of a row with hint text and dropdown button at end
                                Container(
                                  height: 45,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    border: Border.all(
                                      color: themeProvider
                                          .themeManager.borderSubtle01Color,
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                      showModalBottomSheet(
                                          constraints: BoxConstraints(
                                            maxHeight: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.8,
                                          ),
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          context: context,
                                          builder: (ctx) => const SelectStates(
                                              createIssue: true));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      child: Row(
                                        children: [
                                          //icon
                                          Icon(
                                            //four squares icon
                                            Icons.view_cozy_rounded,
                                            color: themeProvider.themeManager
                                                .placeholderTextColor,
                                          ),
                                          const SizedBox(width: 15),
                                          CustomText(
                                            'State',
                                            type: FontStyle.Small,
                                            color: themeProvider.themeManager
                                                .placeholderTextColor,
                                          ),
                                          Expanded(child: Container()),
                                          Row(
                                            children: [
                                              issuesProvider.createIssuedata[
                                                          'state'] ==
                                                      null
                                                  ? Container()
                                                  : Container(
                                                      height: 20,
                                                      width: 20,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              right: 5),
                                                      child: issuesProvider
                                                              .stateIcons[
                                                          issuesProvider
                                                                  .createIssuedata[
                                                              'state']]),
                                              CustomText(
                                                issuesProvider.createIssuedata[
                                                            'state'] ==
                                                        null
                                                    ? 'Select'
                                                    : issuesProvider
                                                        .states[issuesProvider
                                                            .createIssuedata[
                                                        'state']]['name'],
                                                type: FontStyle.Small,
                                                color: themeProvider
                                                    .themeManager
                                                    .primaryTextColor,
                                              ),
                                              issuesProvider.createIssuedata[
                                                          'state'] ==
                                                      null
                                                  ? const SizedBox(
                                                      width: 5,
                                                    )
                                                  : Container(),
                                              Icon(
                                                Icons.keyboard_arrow_down,
                                                color: themeProvider
                                                    .themeManager
                                                    .primaryTextColor,
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  height: 45,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    border: Border.all(
                                      color: themeProvider
                                          .themeManager.borderSubtle01Color,
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                      showModalBottomSheet(
                                          constraints: BoxConstraints(
                                            maxHeight: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.8,
                                          ),
                                          backgroundColor: Colors.transparent,
                                          context: context,
                                          enableDrag: true,
                                          isScrollControlled: true,
                                          builder: (ctx) =>
                                              const SelectProjectMembers(
                                                createIssue: true,
                                              ));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      child: Row(
                                        children: [
                                          //icon
                                          Icon(
                                            //two people icon
                                            Icons.people_alt_rounded,
                                            color: themeProvider.themeManager
                                                .placeholderTextColor,
                                          ),
                                          const SizedBox(width: 15),
                                          // const Text(
                                          //   'Assignees',
                                          //   style: TextStyle(
                                          //     fontSize: 16,
                                          //     fontWeight: FontWeight.w400,
                                          //     color: Color.fromRGBO(143, 143, 147, 1),
                                          //   ),
                                          // ),
                                          CustomText(
                                            'Assignees',
                                            type: FontStyle.Small,
                                            color: themeProvider.themeManager
                                                .placeholderTextColor,
                                          ),
                                          Expanded(child: Container()),
                                          issuesProvider.createIssuedata[
                                                      'members'] ==
                                                  null
                                              ? Row(
                                                  children: [
                                                    const CustomText(
                                                      'Select',
                                                      type: FontStyle.Small,
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Icon(
                                                      Icons.keyboard_arrow_down,
                                                      color: themeProvider
                                                          .themeManager
                                                          .primaryTextColor,
                                                    ),
                                                  ],
                                                )
                                              : Row(
                                                  children: [
                                                    Wrap(
                                                      children: [
                                                        Container(
                                                          alignment:
                                                              Alignment.center,
                                                          // color: Colors.amber,
                                                          height: 30,
                                                          constraints:
                                                              const BoxConstraints(
                                                                  maxWidth: 80,
                                                                  minWidth: 30),
                                                          child: Stack(
                                                            alignment: Alignment
                                                                .center,
                                                            fit: StackFit
                                                                .passthrough,
                                                            children: (issuesProvider
                                                                            .createIssuedata[
                                                                        'members']
                                                                    as Map)
                                                                .entries
                                                                .map((e) =>
                                                                    Positioned(
                                                                      right: (issuesProvider.createIssuedata['members'] as Map)
                                                                              .values
                                                                              .toList()
                                                                              .indexOf(e) *
                                                                          00.0,
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            25,
                                                                        alignment:
                                                                            Alignment.center,
                                                                        width:
                                                                            25,
                                                                        decoration:
                                                                            const BoxDecoration(
                                                                          shape:
                                                                              BoxShape.circle,
                                                                          color: Color.fromRGBO(
                                                                              55,
                                                                              65,
                                                                              81,
                                                                              1),
                                                                          // image: DecorationImage(
                                                                          //   image: NetworkImage(
                                                                          //       e['profileUrl']),
                                                                          //   fit: BoxFit.cover,
                                                                          // ),
                                                                        ),
                                                                        child:
                                                                            CustomText(
                                                                          e.value['name'][0]
                                                                              .toString()
                                                                              .toUpperCase(),
                                                                          type:
                                                                              FontStyle.Small,
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                      ),
                                                                    ))
                                                                .toList(),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Icon(
                                                      Icons.keyboard_arrow_down,
                                                      color: themeProvider
                                                              .isDarkThemeEnabled
                                                          ? darkSecondaryTextColor
                                                          : lightSecondaryTextColor,
                                                    ),
                                                  ],
                                                )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  height: 45,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    border: Border.all(
                                      color: themeProvider
                                          .themeManager.borderSubtle01Color,
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                      showModalBottomSheet(
                                          backgroundColor: Colors.transparent,
                                          context: context,
                                          builder: (ctx) =>
                                              const SelectIssuePriority(
                                                createIssue: true,
                                              ));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      child: Row(
                                        children: [
                                          //icon
                                          Icon(
                                            //antenna signal icon
                                            Icons.signal_cellular_alt_sharp,
                                            color: themeProvider.themeManager
                                                .placeholderTextColor,
                                          ),
                                          const SizedBox(width: 15),
                                          // const Text(
                                          //   'Priority',
                                          //   style: TextStyle(
                                          //     fontSize: 16,
                                          //     fontWeight: FontWeight.w400,
                                          //     color: Color.fromRGBO(143, 143, 147, 1),
                                          //   ),
                                          // ),
                                          CustomText(
                                            'Priority',
                                            type: FontStyle.Small,
                                            color: themeProvider.themeManager
                                                .placeholderTextColor,
                                          ),
                                          Expanded(child: Container()),
                                          issuesProvider.createIssuedata[
                                                      'priority'] ==
                                                  null
                                              ? Row(
                                                  children: [
                                                    CustomText(
                                                      'Select',
                                                      type: FontStyle.Small,
                                                      color: themeProvider
                                                          .themeManager
                                                          .primaryTextColor,
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Icon(
                                                      Icons.keyboard_arrow_down,
                                                      color: themeProvider
                                                          .themeManager
                                                          .primaryTextColor,
                                                    ),
                                                  ],
                                                )
                                              : Row(
                                                  children: [
                                                    issuesProvider
                                                            .createIssuedata[
                                                        'priority']['icon'],
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    CustomText(
                                                      issuesProvider
                                                              .createIssuedata[
                                                          'priority']['name'],
                                                      type: FontStyle.Small,
                                                      color: themeProvider
                                                          .themeManager
                                                          .primaryTextColor,
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Icon(
                                                      Icons.keyboard_arrow_down,
                                                      color: themeProvider
                                                          .themeManager
                                                          .primaryTextColor,
                                                    ),
                                                  ],
                                                )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                (expanded &&
                                        //  ( ref
                                        //           .read(ProviderList
                                        //               .projectProvider)
                                        //           .currentProject['estimate'] !=
                                        //       null ) &&
                                        ref
                                                .read(ProviderList
                                                    .projectProvider)
                                                .projects
                                                .firstWhere((element) =>
                                                    element['id'] ==
                                                    ref
                                                            .read(ProviderList
                                                                .issuesProvider)
                                                            .createIssueProjectData[
                                                        'id'])['estimate'] !=
                                            null)
                                    ? const SizedBox(height: 8)
                                    : Container(),
                                (expanded &&
                                        // ref
                                        //         .read(ProviderList
                                        //             .projectProvider)
                                        //         .currentProject['estimate'] !=
                                        //     null &&
                                        ref
                                                .read(ProviderList
                                                    .projectProvider)
                                                .projects
                                                .firstWhere((element) =>
                                                    element['id'] ==
                                                    ref
                                                            .read(ProviderList
                                                                .issuesProvider)
                                                            .createIssueProjectData[
                                                        'id'])['estimate'] !=
                                            null)
                                    ? Container(
                                        height: 45,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          border: Border.all(
                                            color: themeProvider.themeManager
                                                .borderSubtle01Color,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 10),
                                          child: Row(
                                            children: [
                                              //icon
                                              Icon(
                                                //antenna signal icon
                                                Icons.change_history,
                                                color: themeProvider
                                                    .themeManager
                                                    .placeholderTextColor,
                                              ),
                                              const SizedBox(width: 15),
                                              CustomText(
                                                'Estimate',
                                                type: FontStyle.Small,
                                                color: themeProvider
                                                    .themeManager
                                                    .placeholderTextColor,
                                              ),
                                              Expanded(child: Container()),
                                              GestureDetector(
                                                onTap: () async {
                                                  FocusManager
                                                      .instance.primaryFocus
                                                      ?.unfocus();

                                                  //show modal bottom sheet
                                                  showModalBottomSheet(
                                                      isScrollControlled: true,
                                                      constraints:
                                                          BoxConstraints(
                                                        maxHeight:
                                                            MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.8,
                                                      ),
                                                      shape:
                                                          const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  50),
                                                          topRight:
                                                              Radius.circular(
                                                                  50),
                                                        ),
                                                      ),
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      context: context,
                                                      builder: (ctx) =>
                                                          const SelectEstimate(
                                                            createIssue: true,
                                                          ));
                                                },
                                                child: issuesProvider
                                                                .createIssuedata[
                                                            'estimate_point'] ==
                                                        null
                                                    ? Row(
                                                        children: [
                                                          CustomText(
                                                            'Estimate',
                                                            type:
                                                                FontStyle.Small,
                                                            color: themeProvider
                                                                .themeManager
                                                                .primaryTextColor,
                                                            // color: Colors.black,
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          Icon(
                                                            //antenna signal icon
                                                            Icons
                                                                .keyboard_arrow_down,
                                                            color: themeProvider
                                                                .themeManager
                                                                .primaryTextColor,
                                                          ),
                                                        ],
                                                      )
                                                    : Row(
                                                        children: [
                                                          CustomText(
                                                            estimatesProvider
                                                                .estimates
                                                                .firstWhere(
                                                                    (element) {
                                                              return element[
                                                                      'id'] ==
                                                                  projectProvider
                                                                      .projects
                                                                      .firstWhere((element) =>
                                                                          element[
                                                                              'id'] ==
                                                                          issuesProvider
                                                                              .createIssueProjectData['id'])['estimate'];
                                                            })['points'].firstWhere(
                                                                    (element) {
                                                              return element[
                                                                      'key'] ==
                                                                  issuesProvider
                                                                          .createIssuedata[
                                                                      'estimate_point'];
                                                            })['value'].toString(),
                                                            type:
                                                                FontStyle.Small,
                                                            color: themeProvider
                                                                .themeManager
                                                                .primaryTextColor,
                                                            // color: Colors.black,
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          Icon(
                                                            //antenna signal icon
                                                            Icons
                                                                .keyboard_arrow_down,
                                                            color: themeProvider
                                                                .themeManager
                                                                .primaryTextColor,
                                                          ),
                                                        ],
                                                      ),
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    : Container(),
                                expanded
                                    ? const SizedBox(height: 8)
                                    : Container(),
                                expanded
                                    ? Container(
                                        height: 45,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          border: Border.all(
                                            color: themeProvider.themeManager
                                                .borderSubtle01Color,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                            showModalBottomSheet(
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
                                                constraints: BoxConstraints(
                                                  maxHeight:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.85,
                                                ),
                                                isScrollControlled: true,
                                                // backgroundColor:
                                                //     Colors.transparent,
                                                context: context,
                                                builder: (ctx) =>
                                                    const SelectIssueLabels(
                                                      createIssue: true,
                                                    ));
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, right: 10),
                                            child: Row(
                                              children: [
                                                //icon
                                                Icon(
                                                  //antenna signal icon
                                                  Icons.label,
                                                  color: themeProvider
                                                      .themeManager
                                                      .placeholderTextColor,
                                                ),
                                                const SizedBox(width: 15),
                                                // const Text(
                                                //   'Priority',
                                                //   style: TextStyle(
                                                //     fontSize: 16,
                                                //     fontWeight: FontWeight.w400,
                                                //     color: Color.fromRGBO(143, 143, 147, 1),
                                                //   ),
                                                // ),
                                                CustomText(
                                                  'Label',
                                                  type: FontStyle.Small,
                                                  color: themeProvider
                                                      .themeManager
                                                      .placeholderTextColor,
                                                ),
                                                Expanded(child: Container()),
                                                issuesProvider.createIssuedata[
                                                            'labels'] ==
                                                        null
                                                    ? Row(
                                                        children: [
                                                          CustomText(
                                                            'Select',
                                                            type:
                                                                FontStyle.Small,
                                                            color: themeProvider
                                                                .themeManager
                                                                .primaryTextColor,
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          Icon(
                                                            Icons
                                                                .keyboard_arrow_down,
                                                            color: themeProvider
                                                                .themeManager
                                                                .primaryTextColor,
                                                          ),
                                                        ],
                                                      )
                                                    : Row(
                                                        children: [
                                                          Wrap(
                                                            children: [
                                                              Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                // color: Colors.amber,
                                                                height: 30,
                                                                constraints:
                                                                    const BoxConstraints(
                                                                        maxWidth:
                                                                            80,
                                                                        minWidth:
                                                                            30),
                                                                child: Stack(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  fit: StackFit
                                                                      .passthrough,
                                                                  children: (issuesProvider
                                                                              .createIssuedata['labels']
                                                                          as List)
                                                                      .map((e) =>
                                                                          Positioned(
                                                                            right:
                                                                                (issuesProvider.createIssuedata['labels'] as List).indexOf(e) * 15.0,
                                                                            child: Container(
                                                                                height: 25,
                                                                                alignment: Alignment.center,
                                                                                width: 25,
                                                                                decoration: BoxDecoration(shape: BoxShape.circle, color: Color(int.parse("FF${e['color'].toString().toUpperCase().replaceAll("#", "")}", radix: 16)))),
                                                                          ))
                                                                      .toList(),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          Icon(
                                                            Icons
                                                                .keyboard_arrow_down,
                                                            color: themeProvider
                                                                .themeManager
                                                                .primaryTextColor,
                                                          ),
                                                        ],
                                                      )
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(),
                                const SizedBox(height: 8),
                                expanded
                                    ? Container(
                                        height: 45,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          border: Border.all(
                                            color: themeProvider.themeManager
                                                .borderSubtle01Color,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: InkWell(
                                          onTap: () async {
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                            var date = await showDatePicker(
                                              builder: (context, child) =>
                                                  Theme(
                                                data: themeProvider
                                                        .isDarkThemeEnabled
                                                    ? ThemeData.dark().copyWith(
                                                        colorScheme:
                                                            const ColorScheme
                                                                .dark(
                                                          primary: primaryColor,
                                                        ),
                                                      )
                                                    : ThemeData.light()
                                                        .copyWith(
                                                        colorScheme:
                                                            const ColorScheme
                                                                .light(
                                                          primary: primaryColor,
                                                        ),
                                                      ),
                                                child: child!,
                                              ),
                                              context: context,
                                              initialDate: DateTime.now()
                                                      .isAfter(dueDate ??
                                                          DateTime.now())
                                                  ? dueDate ?? DateTime.now()
                                                  : DateTime.now(),
                                              firstDate: DateTime(2020),
                                              lastDate:
                                                  dueDate ?? DateTime(2025),
                                            );

                                            if (date != null) {
                                              setState(() {
                                                startDate = date;
                                                issuesProvider.createIssuedata[
                                                    'start_date'] = date;
                                              });
                                            }
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, right: 10),
                                            child: Row(
                                              children: [
                                                //icon
                                                Icon(
                                                  //antenna signal icon
                                                  Icons.calendar_month,
                                                  color: themeProvider
                                                      .themeManager
                                                      .placeholderTextColor,
                                                ),
                                                const SizedBox(width: 15),
                                                CustomText(
                                                  'Start Date',
                                                  type: FontStyle.Small,
                                                  color: themeProvider
                                                      .themeManager
                                                      .placeholderTextColor,
                                                ),
                                                Expanded(child: Container()),
                                                issuesProvider.createIssuedata[
                                                            'start_date'] ==
                                                        null
                                                    ? Row(
                                                        children: [
                                                          CustomText(
                                                            'Select',
                                                            type:
                                                                FontStyle.Small,
                                                            color: themeProvider
                                                                .themeManager
                                                                .primaryTextColor,
                                                            // color: Colors.black,
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          Icon(
                                                            //antenna signal icon
                                                            Icons
                                                                .keyboard_arrow_down,
                                                            color: themeProvider
                                                                .themeManager
                                                                .primaryTextColor,
                                                          ),
                                                        ],
                                                      )
                                                    : Row(
                                                        children: [
                                                          CustomText(
                                                            DateFormat(
                                                                    'yyyy-MM-dd')
                                                                .format(issuesProvider
                                                                        .createIssuedata[
                                                                    'start_date']),
                                                            type:
                                                                FontStyle.Small,
                                                            color: themeProvider
                                                                .themeManager
                                                                .primaryTextColor,
                                                          ),
                                                          const SizedBox(
                                                              width: 10),
                                                          InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                startDate =
                                                                    null;
                                                                issuesProvider
                                                                        .createIssuedata[
                                                                    'start_date'] = null;
                                                              });
                                                            },
                                                            child: Icon(
                                                              Icons.close,
                                                              size: 20,
                                                              color: themeProvider
                                                                  .themeManager
                                                                  .primaryTextColor,
                                                            ),
                                                          )
                                                        ],
                                                      )

                                                //createIssuedata['due_date'] != null

                                                //         setState(() {
                                                //   issuesProvider.createIssuedata[
                                                //       'due_date'] = date;
                                                // })
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(),
                                const SizedBox(height: 8),
                                expanded
                                    ? Container(
                                        height: 45,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          border: Border.all(
                                            color: themeProvider.themeManager
                                                .borderSubtle01Color,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: InkWell(
                                          onTap: () async {
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                            var date = await showDatePicker(
                                              builder: (context, child) =>
                                                  Theme(
                                                data: themeProvider
                                                        .isDarkThemeEnabled
                                                    ? ThemeData.dark().copyWith(
                                                        colorScheme:
                                                            const ColorScheme
                                                                .dark(
                                                          primary: primaryColor,
                                                        ),
                                                      )
                                                    : ThemeData.light()
                                                        .copyWith(
                                                        colorScheme:
                                                            const ColorScheme
                                                                .light(
                                                          primary: primaryColor,
                                                        ),
                                                      ),
                                                child: child!,
                                              ),
                                              context: context,
                                              initialDate: DateTime.now()
                                                      .isBefore(startDate ??
                                                          DateTime.now())
                                                  ? startDate ?? DateTime.now()
                                                  : DateTime.now(),
                                              firstDate:
                                                  startDate ?? DateTime(2020),
                                              lastDate: DateTime(2025),
                                            );

                                            if (date != null) {
                                              setState(() {
                                                dueDate = date;
                                                issuesProvider.createIssuedata[
                                                    'due_date'] = date;
                                              });
                                            }
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, right: 10),
                                            child: Row(
                                              children: [
                                                //icon
                                                Icon(
                                                  //antenna signal icon
                                                  Icons.calendar_month,
                                                  color: themeProvider
                                                      .themeManager
                                                      .placeholderTextColor,
                                                ),
                                                const SizedBox(width: 15),
                                                CustomText(
                                                  'Due Date',
                                                  type: FontStyle.Small,
                                                  color: themeProvider
                                                      .themeManager
                                                      .placeholderTextColor,
                                                ),
                                                Expanded(child: Container()),
                                                issuesProvider.createIssuedata[
                                                            'due_date'] ==
                                                        null
                                                    ? Row(
                                                        children: [
                                                          CustomText(
                                                            'Select',
                                                            type:
                                                                FontStyle.Small,
                                                            color: themeProvider
                                                                .themeManager
                                                                .primaryTextColor,
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          Icon(
                                                            //antenna signal icon
                                                            Icons
                                                                .keyboard_arrow_down,
                                                            color: themeProvider
                                                                .themeManager
                                                                .primaryTextColor,
                                                          ),
                                                        ],
                                                      )
                                                    : Row(
                                                        children: [
                                                          CustomText(
                                                            DateFormat(
                                                                    'yyyy-MM-dd')
                                                                .format(issuesProvider
                                                                        .createIssuedata[
                                                                    'due_date']),
                                                            type:
                                                                FontStyle.Small,
                                                            color: themeProvider
                                                                .themeManager
                                                                .primaryTextColor,
                                                          ),
                                                          const SizedBox(
                                                              width: 10),
                                                          InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                dueDate = null;
                                                                issuesProvider
                                                                        .createIssuedata[
                                                                    'due_date'] = null;
                                                              });
                                                            },
                                                            child: Icon(
                                                              Icons.close,
                                                              size: 20,
                                                              color: themeProvider
                                                                  .themeManager
                                                                  .primaryTextColor,
                                                            ),
                                                          )
                                                        ],
                                                      )

                                                //createIssuedata['due_date'] != null

                                                //         setState(() {
                                                //   issuesProvider.createIssuedata[
                                                //       'due_date'] = date;
                                                // })
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(),
                                const SizedBox(height: 8),
                                expanded
                                    ? Container(
                                        height: 45,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          border: Border.all(
                                            color: themeProvider.themeManager
                                                .borderSubtle01Color,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: InkWell(
                                          onTap: () async {
                                            showModalBottomSheet(
                                              isScrollControlled: false,
                                              backgroundColor:
                                                  Colors.transparent,
                                              context: context,
                                              builder: (ctx) =>
                                                  const IssuesListSheet(
                                                // parent: true,
                                                type:
                                                    IssueDetailCategory.parent,
                                                issueId: '',
                                                createIssue: true,
                                                // blocking: false,
                                              ),
                                            );
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, right: 10),
                                            child: Row(
                                              children: [
                                                //icon
                                                Icon(
                                                  //antenna signal icon
                                                  Icons.person_outline_rounded,
                                                  color: themeProvider
                                                      .themeManager
                                                      .placeholderTextColor,
                                                ),
                                                const SizedBox(width: 15),
                                                CustomText(
                                                  'Parent',
                                                  type: FontStyle.Small,
                                                  color: themeProvider
                                                      .themeManager
                                                      .placeholderTextColor,
                                                ),
                                                Expanded(child: Container()),
                                                issuesProvider.createIssueParent
                                                        .isEmpty
                                                    ? Row(
                                                        children: [
                                                          CustomText(
                                                            'Select issue',
                                                            type:
                                                                FontStyle.Small,
                                                            color: themeProvider
                                                                .themeManager
                                                                .primaryTextColor,
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          Icon(
                                                            //antenna signal icon
                                                            Icons
                                                                .keyboard_arrow_down,
                                                            color: themeProvider
                                                                .themeManager
                                                                .primaryTextColor,
                                                          ),
                                                        ],
                                                      )
                                                    : Row(
                                                        children: [
                                                          CustomText(
                                                            issuesProvider
                                                                .createIssueParent,
                                                            type:
                                                                FontStyle.Small,
                                                            color: themeProvider
                                                                .themeManager
                                                                .primaryTextColor,
                                                          ),
                                                          const SizedBox(
                                                              width: 10),
                                                          InkWell(
                                                            onTap: () {
                                                              issuesProvider
                                                                  .createIssueParent = '';
                                                              issuesProvider
                                                                  .createIssueParentId = '';
                                                              issuesProvider
                                                                  .setsState();
                                                            },
                                                            child: Icon(
                                                              Icons.close,
                                                              size: 20,
                                                              color: themeProvider
                                                                  .themeManager
                                                                  .primaryTextColor,
                                                            ),
                                                          )
                                                        ],
                                                      )
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(),
                                const SizedBox(
                                  height: 8,
                                ),
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
                                      color: Colors.transparent,
                                      border: Border.all(
                                        color: themeProvider
                                            .themeManager.borderSubtle01Color,
                                      ),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // const Text(
                                        //   'View all',
                                        //   style: TextStyle(
                                        //     fontSize: 17,
                                        //     fontWeight: FontWeight.w400,
                                        //     color: Color.fromRGBO(63, 118, 255, 1),
                                        //   ),
                                        // ),
                                        CustomText(
                                          expanded ? "View less" : 'View all',
                                          type: FontStyle.Small,
                                          color: primaryColor,
                                        ),

                                        const SizedBox(width: 10),
                                        //icon
                                        Icon(
                                          //arrow down icon

                                          expanded
                                              ? Icons.keyboard_arrow_up_rounded
                                              : Icons.keyboard_arrow_down,
                                          color: const Color.fromRGBO(
                                              63, 118, 255, 1),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // const SizedBox(height: 20),

                                // const SizedBox(height: 50),
                                // Button(
                                //     text: 'Create Issue',
                                //     ontap: () async {
                                //       if (!formKey.currentState!.validate()) return;

                                //       issueProvider.createIssuedata['title'] =
                                //           title.text;

                                //       await issueProvider.createIssue(
                                //         slug: ref
                                //             .read(ProviderList.workspaceProvider)
                                //             .selectedWorkspace!
                                //             .workspaceSlug,
                                //         projID: ref
                                //             .read(ProviderList.projectProvider)
                                //             .currentProject["id"],
                                //       );
                                //       Navigator.pop(context);
                                //     }),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 16),
                      child: Button(
                        text: 'Create Issue',
                        ontap: () async {
                          if (!formKey.currentState!.validate()) return;

                          issuesProvider.createIssuedata['title'] = title.text;
                          if (widget.cycleId != null) {
                            issuesProvider.createIssuedata['cycle'] =
                                widget.cycleId;
                          }
                          if (widget.moduleId != null) {
                            issuesProvider.createIssuedata['module'] =
                                widget.moduleId;
                          }

                          log(issuesProvider.createIssuedata.toString());

                          Enum issueCategory = IssueCategory.issues;
                          if (widget.moduleId != null) {
                            issueCategory = IssueCategory.moduleIssues;
                          }
                          if (widget.cycleId != null) {
                            issueCategory = IssueCategory.cycleIssues;
                          }

                          await issuesProvider
                              .createIssue(
                            slug: ref
                                .read(ProviderList.workspaceProvider)
                                .selectedWorkspace!
                                .workspaceSlug,
                            projID: issuesProvider.createIssueProjectData['id'],
                            issueCategory: issueCategory,
                          )
                              .then((_) {
                            notificationsServices.sendNotification(
                                'Plane', 'Issue Created Successfully');
                          });

                          // if (widget.moduleId != null) {
                          //   await ref
                          //       .read(ProviderList.modulesProvider)
                          //       .createModuleIssues(
                          //         slug: ref
                          //             .read(ProviderList.workspaceProvider)
                          //             .selectedWorkspace!
                          //             .workspaceSlug,
                          //         projID: ref
                          //             .read(ProviderList.projectProvider)
                          //             .currentProject["id"],
                          //         moduleId: widget.moduleId!,
                          //       );

                          //   issueProvider.filterIssues(
                          //       slug: ref
                          //           .read(ProviderList.workspaceProvider)
                          //           .selectedWorkspace!
                          //           .workspaceSlug,
                          //       projID: ref
                          //           .read(ProviderList.projectProvider)
                          //           .currentProject["id"],
                          //       issueCategory: IssueCategory.moduleIssues);
                          // }
                          issuesProvider.createIssuedata = {};
                          issuesProvider.statesData = tempStatesData;
                          issuesProvider.states = tempStates;
                          issuesProvider.stateOrdering = tempStateOrdering;
                          issuesProvider.stateIcons = tempStatesIcons;
                          issuesProvider.labels = tempLabels;
                          issuesProvider.members = tempAssignees;
                          issuesProvider.setsState();
                          ref.read(ProviderList.searchIssueProvider).issues =
                              tempIssues;
                          issuesProvider.createIssuedata = {};
                          issuesProvider.setsState();
                          Navigator.pop(Const.globalKey.currentContext!);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Color getBorderColor(ThemeProvider themeProvider) =>
      themeProvider.isDarkThemeEnabled ? darkThemeBorder : Colors.grey.shade200;
}
