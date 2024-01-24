import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/bottom-sheets/project_lead_assignee_sheet.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/utils/custom_toast.dart';
import 'package:plane/widgets/custom_text.dart';
import '/utils/enums.dart';

class ControlPage extends ConsumerStatefulWidget {
  const ControlPage({super.key});

  @override
  ConsumerState<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends ConsumerState<ControlPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        final projectProvider = ref.read(ProviderList.projectProvider);
        projectProvider.lead.text =
            (projectProvider.projectDetailModel!.projectLead == null
                ? ''
                : projectProvider
                    .projectDetailModel!.projectLead!['display_name']);
        projectProvider.assignee.text =
            projectProvider.projectDetailModel!.defaultAssignee == null
                ? ''
                : projectProvider
                    .projectDetailModel!.defaultAssignee!['display_name'];
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = ref.watch(ProviderList.themeProvider);
    final projectProvider = ref.watch(ProviderList.projectProvider);
    return Container(
      color: themeProvider.themeManager.primaryBackgroundDefaultColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              children: [
                CustomText(
                  'Project Lead',
                  type: FontStyle.Small,
                  color: themeProvider.themeManager.tertiaryTextColor,
                ),
                CustomText(
                  '*',
                  type: FontStyle.Small,
                  color: themeProvider.themeManager.textErrorColor,
                )
              ],
            ),
            const SizedBox(height: 5),
            InkWell(
              onTap: projectProvider.role != Role.admin
                  ? () {
                      CustomToast.showToast(context,
                          message: 'Only Admins can perform this action',
                          toastType: ToastType.warning);
                    }
                  : () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        enableDrag: true,
                        constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height * 0.8,
                            minHeight: 150),
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        )),
                        context: context,
                        builder: (ctx) {
                          return ProjectLeadAssigneeSheet(
                            title: 'Lead ',
                            leadId: projectProvider
                                        .projectDetailModel!.projectLead !=
                                    null
                                ? projectProvider
                                    .projectDetailModel!.projectLead!['id']
                                : '',
                            assigneId: projectProvider
                                        .projectDetailModel!.defaultAssignee !=
                                    null
                                ? projectProvider
                                    .projectDetailModel!.defaultAssignee!['id']
                                : '',
                          );
                        },
                      );
                    },
              child: TextField(
                controller: projectProvider.lead,
                style: TextStyle(
                    color: themeProvider.themeManager.primaryTextColor),
                decoration:
                    themeProvider.themeManager.textFieldDecoration.copyWith(
                  suffixIcon: Icon(
                    Icons.keyboard_arrow_down,
                    color: themeProvider.themeManager.primaryTextColor,
                  ),
                ),
                enabled: false,
              ),
            ),
            // DropdownButtonFormField(
            //   value: projectProvider.projectDetailModel!.projectLead!['first_name'] ?? '',
            //   decoration: themeProvider.themeManager.textFieldDecoration.copyWith(
            //     fillColor: themeProvider.isDarkThemeEnabled
            //         ? darkBackgroundColor
            //         : lightBackgroundColor,
            //     filled: true,
            //   ),
            //   dropdownColor: themeProvider.isDarkThemeEnabled
            //       ? Colors.black
            //       : Colors.white,
            //   items: issueProvider.members
            //       .map(
            //         (e) => DropdownMenuItem(
            //           value: e['member']['first_name'],
            //           child: CustomText(
            //             e['member']['first_name'],
            //             type: FontStyle.Medium,
            //             fontWeight: FontWeight.bold,
            //           ),
            //         ),
            //       )
            //       .toList(),
            //   onChanged: (val) {},
            // ),
            const SizedBox(height: 20),
            Row(
              children: [
                CustomText(
                  'Default Assignee ',
                  type: FontStyle.Small,
                  color: themeProvider.themeManager.tertiaryTextColor,
                ),
                CustomText(
                  '*',
                  type: FontStyle.Small,
                  color: themeProvider.themeManager.textErrorColor,
                )
              ],
            ),
            const SizedBox(height: 5),
            // DropdownButtonFormField(
            //   value: projectProvider.projectDetailModel!.defaultAssignee!['first_name'],
            //   decoration: themeProvider.themeManager.textFieldDecoration.copyWith(
            //     fillColor: themeProvider.isDarkThemeEnabled
            //         ? darkBackgroundColor
            //         : lightBackgroundColor,
            //     filled: true,
            //   ),
            //   dropdownColor: themeProvider.isDarkThemeEnabled
            //       ? Colors.black
            //       : Colors.white,
            //   items: issueProvider.members
            //       .map(
            //         (e) => DropdownMenuItem(
            //           value: e['member']['first_name'],
            //           child: CustomText(
            //             e['member']['first_name'],
            //             type: FontStyle.Medium,
            //             fontWeight: FontWeight.bold,
            //           ),
            //         ),
            //       )
            //       .toList(),
            //   onChanged: (val) {},
            // ),
            InkWell(
              onTap: projectProvider.role != Role.admin
                  ? () {
                      CustomToast.showToast(context,
                          message: 'Only Admins can perform this action',
                          toastType: ToastType.warning);
                    }
                  : () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        enableDrag: true,
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.8,
                          minHeight: 150,
                        ),
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        )),
                        context: context,
                        builder: (ctx) {
                          return ProjectLeadAssigneeSheet(
                            title: 'Assignee ',
                            assigneId: projectProvider
                                        .projectDetailModel!.defaultAssignee !=
                                    null
                                ? projectProvider
                                    .projectDetailModel!.defaultAssignee!['id']
                                : '',
                            leadId: projectProvider
                                        .projectDetailModel!.projectLead !=
                                    null
                                ? projectProvider
                                    .projectDetailModel!.projectLead!['id']
                                : '',
                          );
                        },
                      );
                    },
              child: TextField(
                controller: projectProvider.assignee,
                style: TextStyle(
                    color: themeProvider.themeManager.primaryTextColor),
                decoration:
                    themeProvider.themeManager.textFieldDecoration.copyWith(
                        suffixIcon: Icon(
                  Icons.keyboard_arrow_down,
                  color: themeProvider.themeManager.primaryTextColor,
                )),
                enabled: false,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
