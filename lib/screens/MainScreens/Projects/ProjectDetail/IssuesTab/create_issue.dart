// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:plane_startup/bottom_sheets/issues_list_sheet.dart';
import 'package:plane_startup/bottom_sheets/select_estimate.dart';
import 'package:plane_startup/bottom_sheets/select_issue_labels.dart';
import 'package:plane_startup/bottom_sheets/select_priority.dart';
import 'package:plane_startup/bottom_sheets/select_project_members.dart';
import 'package:plane_startup/bottom_sheets/select_states.dart';
import 'package:plane_startup/config/const.dart';
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
  const CreateIssue({
    super.key,
    this.moduleId,
    this.cycleId,
  });

  @override
  ConsumerState<CreateIssue> createState() => _CreateIssueState();
}

class _CreateIssueState extends ConsumerState<CreateIssue> {
  @override
  void initState() {
    var prov = ref.read(ProviderList.issuesProvider);

    var themeProvider = ref.read(ProviderList.themeProvider);
    if (prov.states.isEmpty) {
      prov.getStates(
          slug: ref
              .read(ProviderList.workspaceProvider)
              .selectedWorkspace!
              .workspaceSlug,
          projID: ref.read(ProviderList.projectProvider).currentProject['id']);
    }
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
    prov.createIssuedata['state'] = prov.createIssuedata['state'] ??
        (prov.states.isNotEmpty ? prov.states.keys.first : null);
    super.initState();
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController title = TextEditingController();
  var expanded = false;

  @override
  void dispose() {
    var issuesProvider = ref.read(ProviderList.issuesProvider);
    issuesProvider.createIssueParent = '';
    issuesProvider.createIssueParentId = '';
    issuesProvider.setsState();
    super.dispose();
  }

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
        issuesProvider.createIssuedata = {};
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
                                //     fontWeight: FontWeight.w500,
                                //   ),
                                // ),
                                const Row(
                                  children: [
                                    CustomText(
                                      'Title',
                                      type: FontStyle.title,
                                      // color: themeProvider.secondaryTextColor,
                                    ),
                                    CustomText(
                                      ' *',
                                      type: FontStyle.title,
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
                                  decoration: kTextFieldDecoration.copyWith(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              themeProvider.isDarkThemeEnabled
                                                  ? darkThemeBorder
                                                  : const Color(0xFFE5E5E5),
                                          width: 1.0),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8)),
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              themeProvider.isDarkThemeEnabled
                                                  ? darkThemeBorder
                                                  : const Color(0xFFE5E5E5),
                                          width: 1.0),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8)),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: primaryColor, width: 2.0),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                    ),
                                  ),
                                ),

                                // const SizedBox(height: 20),

                                // const CustomText(
                                //   'Description',
                                //   type: FontStyle.title,
                                //   // color: themeProvider.secondaryTextColor,
                                // ),
                                // const SizedBox(height: 10),
                                // TextField(
                                //     maxLines: 4,
                                //     decoration: kTextFieldDecoration.copyWith(
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
                                const CustomText(
                                  'Details',
                                  type: FontStyle.title,
                                  // color: themeProvider.secondaryTextColor,
                                ),
                                const SizedBox(height: 5),
                                //three dropdown each occupying full width of the screen , each consits of a row with hint text and dropdown button at end
                                Container(
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
                                          const Icon(
                                            //four squares icon
                                            Icons.view_cozy_rounded,
                                            color: Color.fromRGBO(
                                                143, 143, 147, 1),
                                          ),
                                          const SizedBox(width: 15),
                                          const CustomText(
                                            'State',
                                            type: FontStyle.subheading,
                                            color: Color.fromRGBO(
                                                143, 143, 147, 1),
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
                                                type: FontStyle.title,
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
                                                        .isDarkThemeEnabled
                                                    ? darkSecondaryTextColor
                                                    : lightSecondaryTextColor,
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
                                          const Icon(
                                            //two people icon
                                            Icons.people_alt_rounded,
                                            color: Color.fromRGBO(
                                                143, 143, 147, 1),
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
                                          const CustomText(
                                            'Assignees',
                                            type: FontStyle.subheading,
                                            color: Color.fromRGBO(
                                                143, 143, 147, 1),
                                          ),
                                          Expanded(child: Container()),
                                          issuesProvider.createIssuedata[
                                                      'members'] ==
                                                  null
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
                                                      color: themeProvider
                                                              .isDarkThemeEnabled
                                                          ? darkSecondaryTextColor
                                                          : lightSecondaryTextColor,
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
                                                                              FontStyle.title,
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
                                          const Icon(
                                            //antenna signal icon
                                            Icons.signal_cellular_alt_sharp,
                                            color: Color.fromRGBO(
                                                143, 143, 147, 1),
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
                                          const CustomText(
                                            'Priority',
                                            type: FontStyle.subheading,
                                            color: Color.fromRGBO(
                                                143, 143, 147, 1),
                                          ),
                                          Expanded(child: Container()),
                                          issuesProvider.createIssuedata[
                                                      'priority'] ==
                                                  null
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
                                                      color: themeProvider
                                                              .isDarkThemeEnabled
                                                          ? darkSecondaryTextColor
                                                          : lightSecondaryTextColor,
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
                                                      type: FontStyle.title,
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
                                // const SizedBox(height: 8),
                                (expanded &&
                                        ref
                                                .read(ProviderList
                                                    .projectProvider)
                                                .currentProject['estimate'] !=
                                            null)
                                    ? Container(
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
                                            color:
                                                getBorderColor(themeProvider),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 10),
                                          child: Row(
                                            children: [
                                              //icon
                                              const Icon(
                                                //antenna signal icon
                                                Icons.change_history,
                                                color: Color.fromRGBO(
                                                    143, 143, 147, 1),
                                              ),
                                              const SizedBox(width: 15),
                                              const CustomText(
                                                'Estimate',
                                                type: FontStyle.subheading,
                                                color: Color.fromRGBO(
                                                    143, 143, 147, 1),
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
                                                          const CustomText(
                                                            'Estimate',
                                                            type:
                                                                FontStyle.title,
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
                                                                    .isDarkThemeEnabled
                                                                ? darkSecondaryTextColor
                                                                : lightSecondaryTextColor,
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
                                                                          .currentProject[
                                                                      'estimate'];
                                                            })['points'].firstWhere(
                                                                    (element) {
                                                              return element[
                                                                      'key'] ==
                                                                  issuesProvider
                                                                          .createIssuedata[
                                                                      'estimate_point'];
                                                            })['value'].toString(),
                                                            type:
                                                                FontStyle.title,
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
                                                                    .isDarkThemeEnabled
                                                                ? darkSecondaryTextColor
                                                                : lightSecondaryTextColor,
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
                                                const Icon(
                                                  //antenna signal icon
                                                  Icons.label,
                                                  color: Color.fromRGBO(
                                                      143, 143, 147, 1),
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
                                                const CustomText(
                                                  'Label',
                                                  type: FontStyle.subheading,
                                                  color: Color.fromRGBO(
                                                      143, 143, 147, 1),
                                                ),
                                                Expanded(child: Container()),
                                                issuesProvider.createIssuedata[
                                                            'labels'] ==
                                                        null
                                                    ? Row(
                                                        children: [
                                                          const CustomText(
                                                            'Select',
                                                            type:
                                                                FontStyle.title,
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          Icon(
                                                            Icons
                                                                .keyboard_arrow_down,
                                                            color: themeProvider
                                                                    .isDarkThemeEnabled
                                                                ? darkSecondaryTextColor
                                                                : lightSecondaryTextColor,
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
                                      )
                                    : Container(),
                                const SizedBox(height: 8),
                                //a container containing text view all in center
                                expanded
                                    ? Container(
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
                                            color:
                                                getBorderColor(themeProvider),
                                          ),
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
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime.now(),
                                              lastDate: DateTime(2025),
                                            );

                                            if (date != null) {
                                              setState(() {
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
                                                const Icon(
                                                  //antenna signal icon
                                                  Icons.calendar_month,
                                                  color: Color.fromRGBO(
                                                      143, 143, 147, 1),
                                                ),
                                                const SizedBox(width: 15),
                                                const CustomText(
                                                  'Due Date',
                                                  type: FontStyle.subheading,
                                                  color: Color.fromRGBO(
                                                      143, 143, 147, 1),
                                                ),
                                                Expanded(child: Container()),
                                                issuesProvider.createIssuedata[
                                                            'due_date'] ==
                                                        null
                                                    ? Row(
                                                        children: [
                                                          const CustomText(
                                                            'Select',
                                                            type:
                                                                FontStyle.title,
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
                                                                    .isDarkThemeEnabled
                                                                ? darkSecondaryTextColor
                                                                : lightSecondaryTextColor,
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
                                                                FontStyle.title,
                                                          ),
                                                          const SizedBox(
                                                              width: 10),
                                                          InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                issuesProvider
                                                                        .createIssuedata[
                                                                    'due_date'] = null;
                                                              });
                                                            },
                                                            child: const Icon(
                                                              Icons.close,
                                                              size: 20,
                                                              color: greyColor,
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
                                                const Icon(
                                                  //antenna signal icon
                                                  Icons.person_outline_rounded,
                                                  color: Color.fromRGBO(
                                                      143, 143, 147, 1),
                                                ),
                                                const SizedBox(width: 15),
                                                const CustomText(
                                                  'Parent',
                                                  type: FontStyle.subheading,
                                                  color: Color.fromRGBO(
                                                      143, 143, 147, 1),
                                                ),
                                                Expanded(child: Container()),
                                                issuesProvider.createIssueParent
                                                        .isEmpty
                                                    ? Row(
                                                        children: [
                                                          const CustomText(
                                                            'Select issue',
                                                            type:
                                                                FontStyle.title,
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          Icon(
                                                            //antenna signal icon
                                                            Icons
                                                                .keyboard_arrow_down,
                                                            color: themeProvider
                                                                    .isDarkThemeEnabled
                                                                ? darkSecondaryTextColor
                                                                : lightSecondaryTextColor,
                                                          ),
                                                        ],
                                                      )
                                                    : Row(
                                                        children: [
                                                          CustomText(
                                                            issuesProvider
                                                                .createIssueParent,
                                                            type:
                                                                FontStyle.title,
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
                                      color: themeProvider.isDarkThemeEnabled
                                          ? darkBackgroundColor
                                          : lightBackgroundColor,
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                        color: getBorderColor(themeProvider),
                                      ),
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
                                          type: FontStyle.title,
                                          color: const Color.fromRGBO(
                                              63, 118, 255, 1),
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

                            issuesProvider.createIssuedata['title'] =
                                title.text;
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

                            await issuesProvider.createIssue(
                              slug: ref
                                  .read(ProviderList.workspaceProvider)
                                  .selectedWorkspace!
                                  .workspaceSlug,
                              projID: ref
                                  .read(ProviderList.projectProvider)
                                  .currentProject["id"],
                              issueCategory: issueCategory,
                            );

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
                            issuesProvider.setsState();
                            Navigator.pop(Const.globalKey.currentContext!);
                          }),
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
