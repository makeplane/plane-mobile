// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:plane/bottom_sheets/filters/filter_sheet.dart';
import 'package:plane/models/issues.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/utils/constants.dart';
import 'package:plane/utils/custom_toast.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/utils/extensions/string_extensions.dart';
import 'package:plane/widgets/custom_app_bar.dart';
import 'package:plane/widgets/custom_button.dart';
import 'package:plane/widgets/custom_text.dart';
import 'package:plane/widgets/loading_widget.dart';

class CreateView extends ConsumerStatefulWidget {
  const CreateView({
    super.key,
    this.fromProjectIssues = false,
    this.filtersData,
  });
  final bool fromProjectIssues;
  final Filters? filtersData;

  @override
  ConsumerState<CreateView> createState() => _CreateViewState();
}

class _CreateViewState extends ConsumerState<CreateView> {
  Map filtersData = {
    'Filters': {
      "assignees": [],
      "created_by": [],
      "labels": [],
      "priority": [],
      "state": [],
      "target_date": [],
    }
  };

  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  final filterKeys = [
    'Assignees:',
    'Created By:',
    'Labels:',
    'Priority:',
    'State:',
    'Target Date:',
    'Start Date:'
  ];
  Map priorities = {
    'urgent': {
      'icon': Icons.error_outline_rounded,
      'text': 'urgent',
      'color': const Color.fromRGBO(239, 68, 68, 1)
    },
    'high': {
      'icon': Icons.signal_cellular_alt,
      'text': 'high',
      'color': const Color.fromRGBO(249, 115, 22, 1)
    },
    'medium': {
      'icon': Icons.signal_cellular_alt_2_bar,
      'text': 'medium',
      'color': const Color.fromRGBO(234, 179, 8, 1)
    },
    'low': {
      'icon': Icons.signal_cellular_alt_1_bar,
      'text': 'low',
      'color': const Color.fromRGBO(34, 197, 94, 1)
    },
    'none': {
      'icon': Icons.do_disturb_alt_outlined,
      'text': 'none',
      'color': darkBackgroundColor
    }
  };

  @override
  void initState() {
    super.initState();
    if (widget.fromProjectIssues) {
      filtersData = {
        'Filters': {
          "assignees": widget.filtersData!.assignees,
          "created_by": widget.filtersData!.createdBy,
          "labels": widget.filtersData!.labels,
          "priority": widget.filtersData!.priorities,
          "state": widget.filtersData!.states,
          "target_date": widget.filtersData!.targetDate,
          "start_date": widget.filtersData!.startDate,
        }
      };

      log(filtersData.toString());
    }
  }

  bool loading = false;
  @override
  Widget build(BuildContext context) {
    final themeProvider = ref.watch(ProviderList.themeProvider);
    final viewsProvider = ref.watch(ProviderList.viewsProvider);
    final issuesProvider = ref.watch(ProviderList.issuesProvider);
    final projectProvider = ref.watch(ProviderList.projectProvider);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor:
            themeProvider.themeManager.primaryBackgroundDefaultColor,
        appBar: CustomAppBar(
          onPressed: () {
            Navigator.pop(context);
          },
          text: 'Create View',
        ),
        body: LoadingWidget(
          loading: viewsProvider.viewsState == StateEnum.loading,
          widgetClass: LayoutBuilder(builder: (ctx, constraints) {
            return SingleChildScrollView(
              child: Stack(
                children: [
                  ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //form conatining title and description
                              Row(
                                children: [
                                  CustomText(
                                    'Title ',
                                    color: themeProvider
                                        .themeManager.tertiaryTextColor,
                                    type: FontStyle.Small,
                                  ),
                                  CustomText(
                                    '*',
                                    color: themeProvider
                                        .themeManager.textErrorColor,
                                    type: FontStyle.Small,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              TextField(
                                  controller: title,
                                  decoration: themeProvider
                                      .themeManager.textFieldDecoration),
                              const SizedBox(height: 20),

                              CustomText(
                                'Description',
                                type: FontStyle.Small,
                                color: themeProvider
                                    .themeManager.tertiaryTextColor,
                              ),
                              const SizedBox(height: 5),
                              TextField(
                                maxLines: 6,
                                controller: description,
                                decoration: themeProvider
                                    .themeManager.textFieldDecoration
                                    .copyWith(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 15,
                                )),
                              ),
                              const SizedBox(height: 30),

                              //container containing a plus icon and text add filter
                              GestureDetector(
                                onTap: () async {
                                  await showModalBottomSheet(
                                      isScrollControlled: true,
                                      enableDrag: true,
                                      constraints: BoxConstraints(
                                          maxHeight: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.85),
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        topRight: Radius.circular(30),
                                      )),
                                      context: context,
                                      builder: (ctx) {
                                        return FilterSheet(
                                          filtersData: filtersData,
                                          issueCategory: IssueCategory.issues,
                                          fromCreateView: true,
                                        );
                                      });
                                  setState(() {
                                    log(filtersData.toString());
                                  });
                                },
                                child: Container(
                                  height: 45,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: themeProvider.themeManager
                                        .primaryBackgroundDefaultColor,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: themeProvider
                                          .themeManager.borderStrong01Color,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(width: 10),
                                      Icon(
                                        Icons.add,
                                        color: themeProvider
                                            .themeManager.tertiaryTextColor,
                                      ),
                                      const SizedBox(width: 10),
                                      CustomText(
                                        'Add Filter',
                                        type: FontStyle.Small,
                                        color: themeProvider
                                            .themeManager.tertiaryTextColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              ListView.builder(
                                  itemCount: filtersData['Filters']!.length,
                                  primary: false,
                                  shrinkWrap: true,
                                  itemBuilder:
                                      ((context, index) =>
                                          filtersData['Filters']!
                                                  .values
                                                  .elementAt(index)
                                                  .isNotEmpty
                                              ? Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10,
                                                          bottom: 10,
                                                          left: 10,
                                                          right: 10),
                                                  margin: const EdgeInsets.only(
                                                      bottom: 10),
                                                  decoration: BoxDecoration(
                                                      color: themeProvider
                                                          .themeManager
                                                          .primaryBackgroundDefaultColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                      border: Border.all(
                                                          color: themeProvider
                                                              .themeManager
                                                              .borderStrong01Color)),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      CustomText(
                                                        filterKeys[index],
                                                        fontWeight: FontWeightt
                                                            .Semibold,
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Wrap(
                                                        children: ((filtersData['Filters'] as Map).values.elementAt(index) as List)
                                                            .map((e) => filterKeys[index] == 'Priority:'
                                                                ? GestureDetector(
                                                                    onTap: () {
                                                                      log(e);
                                                                      ((filtersData['Filters'] as Map).values.elementAt(index)
                                                                              as List)
                                                                          .remove(
                                                                              e);
                                                                      setState(
                                                                          () {});
                                                                    },
                                                                    child:
                                                                        filterWidget(
                                                                      color: priorities[
                                                                              e]
                                                                          [
                                                                          'color'],
                                                                      icon:
                                                                          Icon(
                                                                        priorities[e]
                                                                            [
                                                                            'icon'],
                                                                        size:
                                                                            15,
                                                                        color: priorities[e]
                                                                            [
                                                                            'color'],
                                                                      ),
                                                                      text: priorities[
                                                                              e]
                                                                          [
                                                                          'text'],
                                                                    ),
                                                                  )
                                                                : filterKeys[index] == 'State:'
                                                                    ? GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          ((filtersData['Filters'] as Map).values.elementAt(index) as List)
                                                                              .remove(e);
                                                                          setState(
                                                                              () {});
                                                                        },
                                                                        child:
                                                                            filterWidget(
                                                                          color: issuesProvider
                                                                              .states[e]['color']
                                                                              .toString()
                                                                              .toColor(),
                                                                          icon: SizedBox(
                                                                              height: 15,
                                                                              width: 15,
                                                                              child: issuesProvider.stateIcons[e]),
                                                                          text: issuesProvider.states[e]
                                                                              [
                                                                              'name'],
                                                                        ),
                                                                      )
                                                                    : filterKeys[index] == 'Assignees:' || filterKeys[index] == 'Created By:'
                                                                        ? GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              ((filtersData['Filters'] as Map).values.elementAt(index) as List).remove(e);
                                                                              setState(() {});
                                                                            },
                                                                            child:
                                                                                filterWidget(
                                                                              fill: false,
                                                                              color: Colors.black,
                                                                              icon: projectProvider.projectMembers.where((element) => element['member']["id"] == e).first['member']['avatar'] != ''
                                                                                  ? CircleAvatar(
                                                                                      radius: 10,
                                                                                      backgroundImage: NetworkImage(projectProvider.projectMembers.where((element) => element['member']["id"] == e).first['member']['avatar']),
                                                                                    )
                                                                                  : CircleAvatar(
                                                                                      radius: 10,
                                                                                      backgroundColor: const Color.fromRGBO(55, 65, 81, 1),
                                                                                      child: Center(
                                                                                          child: CustomText(
                                                                                        projectProvider.projectMembers.where((element) => element['member']["id"] == e).first['member']['first_name'][0].toString().toUpperCase(),
                                                                                        color: Colors.white,
                                                                                        fontSize: 12,
                                                                                      )),
                                                                                    ),
                                                                              text: projectProvider.projectMembers.where((element) => element['member']["id"] == e).first['member']['display_name'] ?? '',
                                                                            ),
                                                                          )
                                                                        : filterKeys[index] == 'Labels:'
                                                                            ? GestureDetector(
                                                                                onTap: () {
                                                                                  ((filtersData['Filters'] as Map).values.elementAt(index) as List).remove(e);
                                                                                  setState(() {});
                                                                                },
                                                                                child: filterWidget(
                                                                                    color: issuesProvider.labels.where((element) => element["id"] == e).first['color'].toString().toUpperCase().toColor(),
                                                                                    icon: Container(
                                                                                      height: 15,
                                                                                      width: 15,
                                                                                      decoration: BoxDecoration(
                                                                                        borderRadius: BorderRadius.circular(20),
                                                                                        color: issuesProvider.labels.where((element) => element["id"] == e).first['color'].toString().toUpperCase().toColor(),
                                                                                      ),
                                                                                    ),
                                                                                    text: issuesProvider.labels.where((element) => element["id"] == e).first["name"]),
                                                                              )
                                                                            : filterKeys[index] == 'Target Date:'
                                                                                ? GestureDetector(
                                                                                    onTap: () {
                                                                                      ((filtersData['Filters'] as Map).values.elementAt(index) as List).remove(e);
                                                                                      setState(() {});
                                                                                    },
                                                                                    child: filterWidget(
                                                                                      color: Colors.black,
                                                                                      icon: const Icon(
                                                                                        Icons.calendar_today_outlined,
                                                                                        size: 15,
                                                                                        color: Colors.black,
                                                                                      ),
                                                                                      text: e,
                                                                                    ),
                                                                                  )
                                                                                : filterKeys[index] == 'Start Date:'
                                                                                    ? GestureDetector(
                                                                                        onTap: () {
                                                                                          ((filtersData['Filters'] as Map).values.elementAt(index) as List).remove(e);
                                                                                          setState(() {});
                                                                                        },
                                                                                        child: filterWidget(
                                                                                          color: Colors.black,
                                                                                          icon: const Icon(
                                                                                            Icons.calendar_today_outlined,
                                                                                            size: 15,
                                                                                            color: Colors.black,
                                                                                          ),
                                                                                          text: e,
                                                                                        ),
                                                                                      )
                                                                                    : Container())
                                                            .toList(),
                                                      ),
                                                    ],
                                                  ))
                                              : const SizedBox()))
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20),
                          child: Button(
                            text: 'Create View',
                            ontap: () async {
                              FocusScope.of(context).unfocus();
                              try {
                                setState(() {
                                  loading = true;
                                });
                                await ref
                                    .read(ProviderList.viewsProvider.notifier)
                                    .createViews(
                                        ref: ref,
                                        context: context,
                                        data: {
                                      "name": title.text,
                                      "description": description.text,
                                      "query": {
                                        "assignees": filtersData["Filters"]![
                                            "assignees"],
                                        "created_by": filtersData["Filters"]![
                                            "created_by"],
                                        "labels":
                                            filtersData["Filters"]!["labels"],
                                        "priority":
                                            filtersData["Filters"]!["priority"],
                                        "state":
                                            filtersData["Filters"]!["state"],
                                        "target_date": filtersData["Filters"]![
                                            "target_date"],
                                        "start_date": filtersData["Filters"]![
                                            "start_date"],
                                      },
                                      "query_data": {
                                        "assignees": filtersData["Filters"]![
                                            "assignees"],
                                        "created_by": filtersData["Filters"]![
                                            "created_by"],
                                        "labels":
                                            filtersData["Filters"]!["labels"],
                                        "priority":
                                            filtersData["Filters"]!["priority"],
                                        "state":
                                            filtersData["Filters"]!["state"],
                                        "target_date": filtersData["Filters"]![
                                            "target_date"],
                                        "start_date": filtersData["Filters"]![
                                            "start_date"],
                                      }
                                    });
                                setState(() {
                                  loading = false;
                                });
                                ref
                                    .read(ProviderList.viewsProvider.notifier)
                                    .getViews();
                                Navigator.pop(context);
                              } catch (err) {
                                setState(() {
                                  loading = false;
                                });
                                CustomToast.showToast(context,
                                    message: 'Something went wrong!',
                                    toastType: ToastType.failure);
                              }
                            },
                            textColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  loading
                      ? Container(
                          padding: const EdgeInsets.only(bottom: 150),
                          decoration: BoxDecoration(
                            color: themeProvider
                                .themeManager.secondaryBackgroundDefaultColor,
                          ),
                          height: height,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: LoadingIndicator(
                                    indicatorType: Indicator.lineSpinFadeLoader,
                                    colors: [
                                      themeProvider
                                          .themeManager.primaryTextColor
                                    ],
                                    strokeWidth: 1.0,
                                    backgroundColor: Colors.transparent,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const CustomText(
                                  'Loading...',
                                  type: FontStyle.Medium,
                                  fontWeight: FontWeightt.Medium,
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container()
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget filterWidget({
    required Widget icon,
    required String text,
    bool fill = true,
    Color? color,
  }) {
    final themeProvider = ref.read(ProviderList.themeProvider);
    String newText = "";
    if (text.contains(';')) {
      String first = text.split(';')[0];
      final String second = text.split(';')[1];

      //convert yyyy-mm-dd to Aug 12, 2021 using intl package
      if (first.contains('-')) {
        final date = DateTime.parse(first);
        final format = DateFormat('MMM dd, yyyy');
        first = format.format(date);
      }

      newText = '$second $first';
    } else {
      newText = text;
    }
    return Container(
      margin: const EdgeInsets.only(bottom: 6, right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border:
            Border.all(color: themeProvider.themeManager.borderStrong01Color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          const SizedBox(width: 5),
          Container(
            constraints: const BoxConstraints(
              maxWidth: 150,
            ),
            child: CustomText(
              newText.isNotEmpty
                  ? newText.replaceFirst(newText[0], newText[0].toUpperCase())
                  : newText,
              maxLines: 1,
              color: themeProvider.themeManager.primaryTextColor,
              fontSize: 15,
            ),
          ),
          const SizedBox(
            width: 5,
          ),
        ],
      ),
    );
  }
}
