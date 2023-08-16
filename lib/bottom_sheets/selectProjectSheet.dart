// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/utils/enums.dart';
import 'package:plane_startup/widgets/custom_text.dart';

class SelectProject extends ConsumerStatefulWidget {
  const SelectProject({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SelectProjectState();
}

class _SelectProjectState extends ConsumerState<SelectProject> {
  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var projectProvider = ref.watch(ProviderList.projectProvider);
    var issuesProvider = ref.watch(ProviderList.issuesProvider);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: themeProvider.themeManager.secondaryBackgroundDefaultColor,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      width: double.infinity,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Wrap(
              children: [
                Container(
                  height: 55,
                ),
                SingleChildScrollView(
                  child: ListView.builder(
                      itemCount: projectProvider.projects.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            issuesProvider.createIssueProjectData['name'] =
                                projectProvider.projects[index]['name'];
                            issuesProvider.createIssueProjectData['id'] =
                                projectProvider.projects[index]['id'];

                            issuesProvider.setsState();

                            Navigator.pop(context);
                          },
                          child: Container(
                            //height: 40,
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                            ),

                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      int.tryParse(projectProvider
                                                  .projects[index]['emoji']) !=
                                              null
                                          ? String.fromCharCode(int.parse(
                                              projectProvider.projects[index]
                                                  ['emoji']))
                                          : '🚀',
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                    Container(
                                      width: 10,
                                    ),
                                    CustomText(
                                      projectProvider.projects[index]['name'],
                                      type: FontStyle.Medium,
                                      fontWeight: FontWeightt.Regular,
                                      color: themeProvider
                                          .themeManager.primaryTextColor,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    )
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Container(
                                    width: width,
                                    height: 1,
                                    color: themeProvider
                                        .themeManager.placeholderTextColor),
                              ],
                            ),
                          ),
                        );
                      }),
                ),
                Container(height: 30),
              ],
            ),
          ),
          Container(
            height: 50,
            color: themeProvider.themeManager.secondaryBackgroundDefaultColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CustomText(
                  'Select Project',
                  type: FontStyle.H4,
                  fontWeight: FontWeightt.Semibold,
                ),
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.close,
                        color: themeProvider.themeManager.placeholderTextColor))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
