import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:plane/bottom_sheets/select_automation_state.dart';
import 'package:plane/bottom_sheets/select_month.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/utils/constants.dart';
import 'package:plane/utils/custom_toast.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/custom_text.dart';

class AutomationsPage extends ConsumerStatefulWidget {
  const AutomationsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AutomationsPageState();
}

class _AutomationsPageState extends ConsumerState<AutomationsPage> {
  final TextEditingController closeController =
      TextEditingController(text: '1 Month');
  final TextEditingController archiveController =
      TextEditingController(text: '1 Month');
  final TextEditingController defaultStateController =
      TextEditingController(text: 'Cancelled');

  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var projectsProvider = ref.watch(ProviderList.projectProvider);
    var issuesProvider = ref.watch(ProviderList.issuesProvider);
    // log(projectsProvider.currentProject.toString());
    // log(projectsProvider.currentProject['close_in'].toString());
    // log(projectsProvider.currentProject['default_state'].toString());
    String stateColor = issuesProvider.statesData['cancelled'].firstWhere(
        (element) =>
            element['id'] == projectsProvider.currentProject['default_state'],
        orElse: () => {'color': '#000000'})['color'];
    defaultStateController.text = issuesProvider.statesData['cancelled']
        .firstWhere(
            (element) =>
                element['id'] ==
                projectsProvider.currentProject['default_state'],
            orElse: () => {'name': 'Cancelled'})['name'];

    closeController.text = projectsProvider.currentProject['close_in'] > 0
        ? '${projectsProvider.currentProject['close_in']} Month'
        : 'Never';

    archiveController.text = projectsProvider.currentProject['archive_in'] > 0
        ? '${projectsProvider.currentProject['archive_in']} Month'
        : 'Never';
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(
                  color: themeProvider.themeManager.borderSubtle01Color),
              borderRadius: BorderRadius.circular(10),
              color: themeProvider.themeManager.primaryBackgroundDefaultColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            "Auto-close inactive issues",
                            textAlign: TextAlign.left,
                            // color: Colors.black,
                            type: FontStyle.H5,
                            fontWeight: FontWeightt.Semibold,
                            color: themeProvider.themeManager.primaryTextColor,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: width * 0.63,
                            child: CustomText(
                              "Plane will automatically close the issues that have not been updated for the configured time period.",
                              textAlign: TextAlign.left,
                              color: themeProvider
                                  .themeManager.placeholderTextColor,
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: (projectsProvider.role == Role.admin)
                            ? () {
                                int value =
                                    projectsProvider.currentProject['close_in'];
                                projectsProvider.currentProject['close_in'] > 0
                                    ? projectsProvider
                                        .currentProject['close_in'] = 0
                                    : projectsProvider
                                        .currentProject['close_in'] = 1;
                                projectsProvider.setState();
                                // print(projectsProvider.features[index + 1]);
                                projectsProvider.updateProject(
                                    slug: ref
                                        .read(ProviderList.workspaceProvider)
                                        .selectedWorkspace
                                        .workspaceSlug,
                                    projId: ref
                                        .read(ProviderList.projectProvider)
                                        .currentProject['id'],
                                    ref: ref,
                                    data: {
                                      'close_in': value == 0 ? 1 : 0,
                                      'default_state': issuesProvider
                                          .statesData['cancelled'][0]['id'],
                                    });
                              }
                            : () {
                                CustomToast.showToast(context,
                                    message: 'You are not allowed to change',
                                    toastType: ToastType.warning);
                              },
                        child: Container(
                          width: 30,
                          // height: 20,
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color:
                                  projectsProvider.currentProject['close_in'] >
                                          0
                                      ? greenHighLight
                                      : themeProvider.themeManager
                                          .tertiaryBackgroundDefaultColor),
                          child: Align(
                            alignment:
                                projectsProvider.currentProject['close_in'] > 0
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                            child: const CircleAvatar(
                              radius: 6,
                              backgroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  projectsProvider.currentProject['close_in'] > 0
                      ? CustomText(
                          "Auto-close issues that are inactive for",
                          textAlign: TextAlign.left,
                          color: themeProvider.themeManager.primaryTextColor,
                        )
                      : const SizedBox(),
                  projectsProvider.currentProject['close_in'] > 0
                      ? const SizedBox(
                          height: 15,
                        )
                      : const SizedBox(),
                  projectsProvider.currentProject['close_in'] > 0
                      ? InkWell(
                          onTap: (projectsProvider.role == Role.admin ||
                                  projectsProvider.role == Role.member)
                              ? () {
                                  showModalBottomSheet(
                                    enableDrag: true,
                                    isScrollControlled: true,
                                    constraints: BoxConstraints(
                                      maxHeight:
                                          MediaQuery.of(context).size.height *
                                              0.8,
                                    ),
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      ),
                                    ),
                                    context: context,
                                    builder: (ctx) {
                                      return const SelectMonthSheet(
                                        isCloseIn: true,
                                      );
                                    },
                                  );
                                }
                              : () {
                                  CustomToast.showToast(context,
                                      message: 'You are not allowed to change',
                                      toastType: ToastType.warning);
                                },
                          child: TextField(
                            controller: closeController,
                            style: TextStyle(
                                color: themeProvider
                                    .themeManager.primaryTextColor),
                            decoration: themeProvider
                                .themeManager.textFieldDecoration
                                .copyWith(
                              suffixIcon: Icon(
                                Icons.keyboard_arrow_down,
                                color:
                                    themeProvider.themeManager.primaryTextColor,
                              ),
                            ),
                            enabled: false,
                          ),
                        )
                      : const SizedBox(),
                  projectsProvider.currentProject['close_in'] > 0
                      ? const SizedBox(
                          height: 15,
                        )
                      : const SizedBox(),
                  projectsProvider.currentProject['close_in'] > 0
                      ? CustomText(
                          "Auto-close Status",
                          textAlign: TextAlign.left,
                          color: themeProvider.themeManager.primaryTextColor,
                        )
                      : const SizedBox(),
                  projectsProvider.currentProject['close_in'] > 0
                      ? const SizedBox(
                          height: 15,
                        )
                      : const SizedBox(),
                  projectsProvider.currentProject['close_in'] > 0
                      ? InkWell(
                          onTap: (projectsProvider.role == Role.admin)
                              ? issuesProvider.statesData['cancelled'].length >
                                      1
                                  ? () {
                                      showModalBottomSheet(
                                        enableDrag: true,
                                        isScrollControlled: true,
                                        constraints: BoxConstraints(
                                          maxHeight: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.8,
                                        ),
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20),
                                          ),
                                        ),
                                        context: context,
                                        builder: (ctx) {
                                          return const SelectAutomationState();
                                        },
                                      );
                                    }
                                  : null
                              : () {
                                  CustomToast.showToast(context,
                                      message: 'You are not allowed to change',
                                      toastType: ToastType.warning);
                                },
                          child: TextField(
                            controller: defaultStateController,
                            style: TextStyle(
                                color: themeProvider
                                    .themeManager.primaryTextColor),
                            decoration: themeProvider
                                .themeManager.textFieldDecoration
                                .copyWith(
                              suffixIcon: issuesProvider
                                          .statesData['cancelled'].length >
                                      1
                                  ? Icon(
                                      Icons.keyboard_arrow_down,
                                      color: themeProvider
                                          .themeManager.primaryTextColor,
                                    )
                                  : null,
                              prefix: Padding(
                                padding: const EdgeInsets.only(
                                  right: 10.0,
                                ),
                                child: SvgPicture.asset(
                                  'assets/svg_images/cancelled.svg',
                                  colorFilter: ColorFilter.mode(
                                      Color(int.parse(
                                          "FF${stateColor.replaceAll('#', '')}",
                                          radix: 16)),
                                      BlendMode.srcIn),
                                  height: 22,
                                  width: 22,
                                ),
                              ),
                            ),
                            enabled: false,
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(
                  color: themeProvider.themeManager.borderSubtle01Color),
              borderRadius: BorderRadius.circular(10),
              color: themeProvider.themeManager.primaryBackgroundDefaultColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            "Auto-archive closed issues",
                            textAlign: TextAlign.left,
                            // color: Colors.black,
                            type: FontStyle.H5,
                            fontWeight: FontWeightt.Semibold,
                            color: themeProvider.themeManager.primaryTextColor,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: width * 0.63,
                            child: CustomText(
                              "Plane will automatically archive issues that have been completed or cancelled for the configured time period.",
                              textAlign: TextAlign.left,
                              color: themeProvider
                                  .themeManager.placeholderTextColor,
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: (projectsProvider.role == Role.admin)
                            ? () {
                                int value = projectsProvider
                                    .currentProject['archive_in'];
                                projectsProvider.currentProject['archive_in'] >
                                        0
                                    ? projectsProvider
                                        .currentProject['archive_in'] = 0
                                    : projectsProvider
                                        .currentProject['archive_in'] = 1;
                                projectsProvider.setState();
                                // print(projectsProvider.features[index + 1]);
                                projectsProvider.updateProject(
                                    slug: ref
                                        .read(ProviderList.workspaceProvider)
                                        .selectedWorkspace
                                        .workspaceSlug,
                                    projId: ref
                                        .read(ProviderList.projectProvider)
                                        .currentProject['id'],
                                    ref: ref,
                                    data: {
                                      'archive_in': value == 0 ? 1 : 0,
                                    });
                              }
                            : () {
                                CustomToast.showToast(context,
                                    message: 'Only Admins can change features',
                                    toastType: ToastType.warning);
                              },
                        child: Container(
                          width: 30,
                          // height: 20,
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: projectsProvider
                                          .currentProject['archive_in'] >
                                      0
                                  ? greenHighLight
                                  : themeProvider.themeManager
                                      .tertiaryBackgroundDefaultColor),
                          child: Align(
                            alignment:
                                projectsProvider.currentProject['archive_in'] >
                                        0
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                            child: const CircleAvatar(
                              radius: 6,
                              backgroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  projectsProvider.currentProject['archive_in'] > 0
                      ? CustomText(
                          "Auto-archive issues that are closed for",
                          textAlign: TextAlign.left,
                          color: themeProvider.themeManager.primaryTextColor,
                        )
                      : const SizedBox(),
                  projectsProvider.currentProject['archive_in'] > 0
                      ? const SizedBox(
                          height: 10,
                        )
                      : const SizedBox(),
                  projectsProvider.currentProject['archive_in'] > 0
                      ? InkWell(
                          onTap: (projectsProvider.role == Role.admin)
                              ? () {
                                  showModalBottomSheet(
                                    enableDrag: true,
                                    isScrollControlled: true,
                                    constraints: BoxConstraints(
                                      maxHeight:
                                          MediaQuery.of(context).size.height *
                                              0.8,
                                    ),
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      ),
                                    ),
                                    context: context,
                                    builder: (ctx) {
                                      return const SelectMonthSheet(
                                        isCloseIn: false,
                                      );
                                    },
                                  );
                                }
                              : () {
                                  CustomToast.showToast(context,
                                      message: 'You are not allowed to change',
                                      toastType: ToastType.warning);
                                },
                          child: TextField(
                            controller: archiveController,
                            style: TextStyle(
                                color: themeProvider
                                    .themeManager.primaryTextColor),
                            decoration: themeProvider
                                .themeManager.textFieldDecoration
                                .copyWith(
                              suffixIcon: Icon(
                                Icons.keyboard_arrow_down,
                                color:
                                    themeProvider.themeManager.primaryTextColor,
                              ),
                            ),
                            enabled: false,
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
