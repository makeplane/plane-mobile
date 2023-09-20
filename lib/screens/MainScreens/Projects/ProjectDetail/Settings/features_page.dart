import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/utils/constants.dart';
import 'package:plane/utils/custom_toast.dart';
import 'package:plane/utils/global_functions.dart';

import '/utils/enums.dart';
import 'package:plane/widgets/custom_text.dart';

class FeaturesPage extends ConsumerStatefulWidget {
  const FeaturesPage({super.key});

  @override
  ConsumerState<FeaturesPage> createState() => _FeaturesPageState();
}

class _FeaturesPageState extends ConsumerState<FeaturesPage> {
  List cardData = [
    {
      'title': 'Cycles',
      'description':
          'Cycles are enabled for all the projects in this workspace. Access them from the sidebar.',
      'switched': false,
      'logo': 'assets/svg_images/cycle_settings.svg',
      'event_name': 'TOGGLE_CYCLE_',
    },
    {
      'title': 'Modules',
      'description':
          'Modules are enabled for all the projects in this workspace. Access it from the sidebar.',
      'switched': false,
      'logo': 'assets/svg_images/module_settings.svg',
      'event_name': 'TOGGLE_MODULE_',
    },
    {
      'title': 'Views',
      'description':
          'Views are enabled for all the projects in this workspace. Access it from the sidebar.',
      'switched': false,
      'logo': 'assets/svg_images/view_settings.svg',
      'event_name': 'TOGGLE_VIEW_',
    },
    // {
    //   'title': 'Pages',
    //   'description':
    //       'Pages are enabled for all the projects in this workspace. Access it from the sidebar.',
    //   'switched': false
    // }
  ];

  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var projectsProvider = ref.watch(ProviderList.projectProvider);
    return Container(
      color: themeProvider.themeManager.primaryBackgroundDefaultColor,
      child: ListView.builder(
          padding: const EdgeInsets.only(top: 20),
          itemCount: cardData.length,
          itemBuilder: (context, index) {
            return Container(
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      cardData[index]['logo'],
                      // fit: BoxFit.cover,
                      height: 30,
                      width: 30,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          cardData[index]['title'],
                          textAlign: TextAlign.left,
                          // color: Colors.black,
                          type: FontStyle.H5,
                          color: themeProvider.themeManager.primaryTextColor,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: width * 0.63,
                          child: CustomText(
                            cardData[index]['description'],
                            textAlign: TextAlign.left,
                            color:
                                themeProvider.themeManager.placeholderTextColor,
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: projectsProvider.role == Role.admin
                          ? () {
                              projectsProvider.features[index + 1]['show'] =
                                  !projectsProvider.features[index + 1]['show'];
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
                                    if (projectsProvider.features[index + 1]
                                            ['title'] ==
                                        'Cycles')
                                      "cycle_view": projectsProvider
                                          .features[index + 1]['show'],
                                    if (projectsProvider.features[index + 1]
                                            ['title'] ==
                                        'Modules')
                                      "module_view": projectsProvider
                                          .features[index + 1]['show'],
                                    if (projectsProvider.features[index + 1]
                                            ['title'] ==
                                        'Views')
                                      "issue_views_view": projectsProvider
                                          .features[index + 1]['show'],
                                    if (projectsProvider.features[index + 1]
                                            ['title'] ==
                                        'Pages')
                                      "page_view": projectsProvider
                                          .features[index + 1]['show'],
                                  });

                              String prefix = cardData[index]['event_name'];
                              String suffix =
                                  projectsProvider.features[index + 1]['show']
                                      ? 'ON'
                                      : 'OFF';

                              postHogService(
                                eventName: prefix + suffix,
                                properties: {},
                                ref: ref,
                              );
                            }
                          : () {
                              CustomToast.showToast(context,
                                  message: 'Only Admins can change features',
                                  toastType: ToastType.warning);
                            },
                      child: Container(
                        width: 30,
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: projectsProvider.features[index + 1]['show']
                                ? greenHighLight
                                : themeProvider.themeManager
                                    .tertiaryBackgroundDefaultColor),
                        child: Align(
                          alignment: projectsProvider.features[index + 1]
                                  ['show']
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: const CircleAvatar(
                            radius: 6,
                            backgroundColor: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
