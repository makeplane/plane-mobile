import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane_startup/bottom_sheets/goto_plane_web_notifier_sheet.dart';

import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/utils/enums.dart';
import 'package:plane_startup/widgets/custom_app_bar.dart';
import 'package:plane_startup/widgets/loading_widget.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/widgets/custom_text.dart';

class ImportEport extends ConsumerStatefulWidget {
  const ImportEport({super.key});

  @override
  ConsumerState<ImportEport> createState() => _ImportEportState();
}

class _ImportEportState extends ConsumerState<ImportEport> {
  @override
  void initState() {
    var prov = ref.read(ProviderList.integrationProvider);
    if (prov.integrations.isEmpty) {
      ref.read(ProviderList.integrationProvider).getAllAvailableIntegrations();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var integrationProvider = ref.watch(ProviderList.integrationProvider);
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: CustomAppBar(
          onPressed: () {
            Navigator.pop(context);
          },
          text: 'Import & Export'),
      body: LoadingWidget(
        loading: integrationProvider.getIntegrationState == StateEnum.loading ||
            integrationProvider.getInstalledIntegrationState ==
                StateEnum.loading,
        widgetClass: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 16, right: 16),
                height: 1,
                width: MediaQuery.of(context).size.width,
                color: themeProvider.isDarkThemeEnabled
                    ? darkThemeBorder
                    : Colors.grey[300],
              ),
              Container(
                height: 160,
                margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
                padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                decoration: BoxDecoration(
                  color: themeProvider.isDarkThemeEnabled
                      ? darkSecondaryBGC
                      : lightSecondaryBackgroundColor,
                ),
                width: MediaQuery.of(context).size.width,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      'Relocation Guide',
                      textAlign: TextAlign.left,
                      type: FontStyle.Small,
                      fontWeight: FontWeightt.Semibold,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomText(
                      'You can now transfer all the issues that you\'ve created in other tracking services. This tool will guide you to relocate the issue to Plane.',
                      textAlign: TextAlign.left,
                      maxLines: 7,
                      type: FontStyle.Small,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        CustomText(
                          'Read more',
                          textAlign: TextAlign.left,
                          type: FontStyle.Small,
                          color: Color.fromRGBO(63, 118, 255, 1),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.arrow_forward,
                          size: 18,
                          color: Color.fromRGBO(63, 118, 255, 1),
                        )
                      ],
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    )),
                    context: context,
                    builder: (context) {
                      return const GotoPlaneWebNotifierSheet();
                    },
                  );
                },
                child: Container(
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
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 1),
                        child: Image.asset(
                          'assets/images/github_logo.png',
                          width: 40,
                          height: 40,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 120,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const CustomText(
                                  'Github',
                                  textAlign: TextAlign.left,
                                  type: FontStyle.H5,
                                  fontWeight: FontWeightt.Medium,
                                ),
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  color: integrationProvider
                                                  .integrations["github"] !=
                                              null &&
                                          integrationProvider
                                                  .integrations["github"]
                                              ["installed"]
                                      ? const Color.fromRGBO(9, 169, 83, 1)
                                      : themeProvider.isDarkThemeEnabled
                                          ? darkBackgroundColor
                                          : const Color.fromRGBO(
                                              243, 245, 248, 1),
                                  child: CustomText(
                                    integrationProvider
                                                    .integrations["github"] !=
                                                null &&
                                            integrationProvider
                                                    .integrations["github"]
                                                ["installed"]
                                        ? "Installed"
                                        : 'Not Installed',
                                    type: FontStyle.XSmall,
                                    color: integrationProvider
                                                    .integrations["github"] !=
                                                null &&
                                            integrationProvider
                                                    .integrations["github"]
                                                ["installed"]
                                        ? Colors.white
                                        : const Color.fromRGBO(73, 80, 87, 1),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 5),
                            width: MediaQuery.of(context).size.width - 120,
                            child: const CustomText(
                              'Connect with GitHub with your Plane workspace to sync project issues.',
                              textAlign: TextAlign.left,
                              maxLines: 3,
                              type: FontStyle.Medium,
                              color: Color.fromRGBO(133, 142, 150, 1),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    )),
                    context: context,
                    builder: (context) {
                      return const GotoPlaneWebNotifierSheet();
                    },
                  );
                },
                child: Container(
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
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 1),
                        child: Image.asset(
                          'assets/images/jira_logo.png',
                          width: 40,
                          height: 40,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 120,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const CustomText(
                                  'Jira',
                                  textAlign: TextAlign.left,
                                  type: FontStyle.H5,
                                  fontWeight: FontWeightt.Medium,
                                ),
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  color: integrationProvider
                                                  .integrations["jira"] !=
                                              null &&
                                          integrationProvider
                                              .integrations["jira"]["installed"]
                                      ? const Color.fromRGBO(9, 169, 83, 1)
                                      : themeProvider.isDarkThemeEnabled
                                          ? darkBackgroundColor
                                          : const Color.fromRGBO(
                                              243, 245, 248, 1),
                                  child: CustomText(
                                    integrationProvider.integrations["jira"] !=
                                                null &&
                                            integrationProvider
                                                    .integrations["jira"]
                                                ["installed"]
                                        ? "Installed"
                                        : 'Not Installed',
                                    type: FontStyle.XSmall,
                                    color: integrationProvider
                                                    .integrations["jira"] !=
                                                null &&
                                            integrationProvider
                                                    .integrations["jira"]
                                                ["installed"]
                                        ? Colors.white
                                        : const Color.fromRGBO(73, 80, 87, 1),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 5),
                            width: MediaQuery.of(context).size.width - 120,
                            child: const CustomText(
                              'Import issues and epics from Jira projects and epics.',
                              textAlign: TextAlign.left,
                              maxLines: 3,
                              type: FontStyle.Medium,
                              color: Color.fromRGBO(133, 142, 150, 1),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Container(
              //   alignment: Alignment.centerLeft,
              //   margin: const EdgeInsets.only(left: 16, right: 16, top: 25),
              //   child: const CustomText(
              //     'Billing History',
              //     textAlign: TextAlign.left,
              //     type: FontStyle.H6,
              // fontWeight: FontWeightt.Semibold,
              //   ),
              // ),
              // Container(
              //   alignment: Alignment.center,
              //   padding: const EdgeInsets.only(top: 40, bottom: 40),
              //   margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
              //   decoration: BoxDecoration(
              //       color: themeProvider.isDarkThemeEnabled
              //           ? darkSecondaryBGC
              //           : lightSecondaryBackgroundColor,
              //       borderRadius: BorderRadius.circular(6),
              //       border: Border.all(color: Colors.grey.shade300)),
              //   child: const Column(
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     children: [
              //       Icon(
              //         Icons.file_download_outlined,
              //         size: 50,
              //         color: Color.fromRGBO(133, 142, 150, 1),
              //       ),
              //       SizedBox(
              //         height: 30,
              //       ),
              //       CustomText(
              //         'No previous imports available.',
              //         textAlign: TextAlign.center,
              //         type: FontStyle.Small,
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
