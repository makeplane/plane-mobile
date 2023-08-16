import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/utils/enums.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/widgets/custom_text.dart';

class IntegrationsWidget extends ConsumerStatefulWidget {
  const IntegrationsWidget({super.key});

  @override
  ConsumerState<IntegrationsWidget> createState() => _IntegrationsWidgetState();
}

class _IntegrationsWidgetState extends ConsumerState<IntegrationsWidget> {
  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var workspaceProvider = ref.watch(ProviderList.workspaceProvider);
    var projectProvider = ref.watch(ProviderList.projectProvider);
    var integrationProvider = ref.watch(ProviderList.integrationProvider);
    return Container(
        //padding: const EdgeInsets.all(15),
        color: themeProvider.isDarkThemeEnabled
            ? darkSecondaryBackgroundDefaultColor
            : lightSecondaryBackgroundDefaultColor,
        child: ListView(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(top: 16, bottom: 16),
              margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
              decoration: BoxDecoration(
                  color: themeProvider.isDarkThemeEnabled
                      ? darkSecondaryBGC
                      : lightSecondaryBackgroundColor,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                      color: themeProvider.isDarkThemeEnabled
                          ? Colors.transparent
                          : Colors.grey.shade300)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 15),
                    height: 45,
                    width: 45,
                    child: Image.asset(
                      'assets/images/github_logo.png',
                      height: 45,
                      width: 45,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        'Github',
                        textAlign: TextAlign.left,
                        type: FontStyle.H5,
                        color: themeProvider.themeManager.primaryTextColor,
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        width: MediaQuery.of(context).size.width - 120,
                        child: CustomText(
                          (integrationProvider.githubIntegration == null ||
                                  integrationProvider.githubIntegration.isEmpty)
                              ? 'Select GitHub repository to enable sync.'
                              : 'Synced',
                          textAlign: TextAlign.left,
                          maxLines: 3,
                          type: FontStyle.Small,
                          color:
                              themeProvider.themeManager.placeholderTextColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(top: 16, bottom: 16),
              margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
              decoration: BoxDecoration(
                  color: themeProvider.isDarkThemeEnabled
                      ? darkSecondaryBGC
                      : lightSecondaryBackgroundColor,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                      color: themeProvider.isDarkThemeEnabled
                          ? Colors.transparent
                          : Colors.grey.shade300)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 15),
                    height: 45,
                    width: 45,
                    child: Image.asset(
                      'assets/images/slack_logo.png',
                      height: 45,
                      width: 45,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        'Slack',
                        textAlign: TextAlign.left,
                        type: FontStyle.H5,
                        color: themeProvider.themeManager.primaryTextColor,
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        width: MediaQuery.of(context).size.width - 120,
                        child: CustomText(
                          (integrationProvider.slackIntegration == null ||
                                  integrationProvider.slackIntegration.isEmpty)
                              ? 'Select GitHub repository to enable sync.'
                              : "Synced with ${integrationProvider.slackIntegration[0]['team_name']} workspace",
                          textAlign: TextAlign.left,
                          maxLines: 3,
                          type: FontStyle.Small,
                          color:
                              themeProvider.themeManager.placeholderTextColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        )

        // ListView.builder(
        //   itemCount: 1,
        //   itemBuilder: (context, index) {
        //     return Container(
        //       alignment: Alignment.centerLeft,
        //       padding: const EdgeInsets.only(top: 16, bottom: 16),
        //       margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
        //       decoration: BoxDecoration(
        //           color: themeProvider.isDarkThemeEnabled
        //               ? darkBackgroundColor
        //               : lightBackgroundColor,
        //           borderRadius: BorderRadius.circular(6),
        //           border: Border.all(
        //               color: themeProvider.isDarkThemeEnabled
        //                   ? darkThemeBorder
        //                   : strokeColor)),
        //       child: Row(
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: [
        //           Container(
        //             margin: const EdgeInsets.only(left: 15),
        //             height: 45,
        //             width: 45,
        //             child: Image.asset(
        //               'assets/images/github_logo.png',
        //               height: 45,
        //               width: 45,
        //             ),
        //           ),
        //           const SizedBox(
        //             width: 10,
        //           ),
        //           Column(
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: [
        //               CustomText(
        //                 'Github',
        //                 textAlign: TextAlign.left,
        //                 type: FontStyle.H5,
        //                 color: themeProvider.themeManager.primaryTextColor,
        //               ),
        //               Container(
        //                 margin: const EdgeInsets.only(top: 5),
        //                 width: MediaQuery.of(context).size.width - 120,
        //                 child: CustomText(
        //                   'Select GitHub repository to enable sync.',
        //                   textAlign: TextAlign.left,
        //                   maxLines: 3,
        //                   type: FontStyle.Small,
        //                   color: themeProvider.themeManager.placeholderTextColor,
        //                 ),
        //               ),
        //             ],
        //           ),
        //         ],
        //       ),
        //     );
        //   },
        // ),

        );
  }
}
