import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane_startup/bottom_sheets/project_lead_assignee_sheet.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/widgets/custom_text.dart';

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
        var projectProvider = ref.read(ProviderList.projectProvider);
        projectProvider.lead.text =
            (projectProvider.projectDetailModel!.projectLead == null
                ? 'Select lead'
                : projectProvider
                    .projectDetailModel!.projectLead!['first_name']);
        projectProvider.assignee.text =
            projectProvider.projectDetailModel!.defaultAssignee == null
                ? 'Select Assingnee'
                : projectProvider
                    .projectDetailModel!.defaultAssignee!['first_name'];
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var projectProvider = ref.watch(ProviderList.projectProvider);
    return Container(
      color: themeProvider.isDarkThemeEnabled
          ? darkSecondaryBackgroundDefaultColor
          : lightSecondaryBackgroundDefaultColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Row(
              children: [
                CustomText(
                  'Project Lead',
                  type: FontStyle.title,
                ),
                CustomText(
                  '*',
                  type: FontStyle.title,
                  color: Colors.red,
                )
              ],
            ),
            const SizedBox(height: 5),
            InkWell(
              onTap: () {
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
                      title: 'Lead',
                      leadId: projectProvider.projectDetailModel!.projectLead !=
                              null
                          ? projectProvider
                              .projectDetailModel!.projectLead!['id']
                          : '',
                      assigneId:
                          projectProvider.projectDetailModel!.defaultAssignee !=
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
                decoration: kTextFieldDecoration.copyWith(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: themeProvider.isDarkThemeEnabled
                            ? darkThemeBorder
                            : const Color(0xFFE5E5E5),
                        width: 1.0),
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: themeProvider.isDarkThemeEnabled
                            ? darkThemeBorder
                            : const Color(0xFFE5E5E5),
                        width: 1.0),
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
                enabled: false,
                style: TextStyle(
                  color: themeProvider.isDarkThemeEnabled
                      ? Colors.white
                      : Colors.black,
                ),
              ),
            ),
            // DropdownButtonFormField(
            //   value: projectProvider.projectDetailModel!.projectLead!['first_name'] ?? '',
            //   decoration: kTextFieldDecoration.copyWith(
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
            //             type: FontStyle.subtitle,
            //             fontWeight: FontWeight.bold,
            //           ),
            //         ),
            //       )
            //       .toList(),
            //   onChanged: (val) {},
            // ),
            const SizedBox(height: 20),
            const Row(
              children: [
                CustomText(
                  'Default Assignee',
                  type: FontStyle.title,
                ),
                CustomText(
                  '*',
                  type: FontStyle.title,
                  color: Colors.red,
                )
              ],
            ),
            const SizedBox(height: 5),
            // DropdownButtonFormField(
            //   value: projectProvider.projectDetailModel!.defaultAssignee!['first_name'],
            //   decoration: kTextFieldDecoration.copyWith(
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
            //             type: FontStyle.subtitle,
            //             fontWeight: FontWeight.bold,
            //           ),
            //         ),
            //       )
            //       .toList(),
            //   onChanged: (val) {},
            // ),
            InkWell(
              onTap: () {
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
                      title: 'Assignee',
                      assigneId:
                          projectProvider.projectDetailModel!.defaultAssignee !=
                                  null
                              ? projectProvider
                                  .projectDetailModel!.defaultAssignee!['id']
                              : '',
                      leadId: projectProvider.projectDetailModel!.projectLead !=
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
                decoration: kTextFieldDecoration.copyWith(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: themeProvider.isDarkThemeEnabled
                            ? darkThemeBorder
                            : const Color(0xFFE5E5E5),
                        width: 1.0),
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: themeProvider.isDarkThemeEnabled
                            ? darkThemeBorder
                            : const Color(0xFFE5E5E5),
                        width: 1.0),
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
                enabled: false,
                style: TextStyle(
                    color: themeProvider.isDarkThemeEnabled
                        ? Colors.white
                        : Colors.black),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
