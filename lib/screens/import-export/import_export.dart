import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/bottom-sheets/goto_plane_web_notifier_sheet.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/custom_app_bar.dart';
import 'package:plane/widgets/loading_widget.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/widgets/custom_text.dart';
import 'package:url_launcher/url_launcher.dart';

class ImportExport extends ConsumerStatefulWidget {
  const ImportExport({super.key});

  @override
  ConsumerState<ImportExport> createState() => _ImportEportState();
}

class _ImportEportState extends ConsumerState<ImportExport> {
  @override
  void initState() {
    final prov = ref.read(ProviderList.integrationProvider);
    if (prov.integrations.isEmpty) {
      ref.read(ProviderList.integrationProvider).getAllAvailableIntegrations();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = ref.watch(ProviderList.themeProvider);
    final integrationProvider = ref.watch(ProviderList.integrationProvider);
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: CustomAppBar(
          onPressed: () {
            Navigator.pop(context);
          },
          text: 'Import & Export'),
      body: LoadingWidget(
        loading: integrationProvider.getIntegrationState == DataState.loading ||
            integrationProvider.getInstalledIntegrationState ==
                DataState.loading,
        widgetClass: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 16, right: 16),
                height: 1,
                width: MediaQuery.of(context).size.width,
                color: themeProvider.themeManager.borderDisabledColor,
              ),
              Container(
                // height: 160,
                margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
                padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color:
                      themeProvider.themeManager.secondaryBackgroundActiveColor,
                ),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      'Relocation Guide',
                      textAlign: TextAlign.left,
                      type: FontStyle.Small,
                      fontWeight: FontWeightt.Semibold,
                      color: themeProvider.themeManager.primaryTextColor,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomText(
                      'You can now transfer all the issues that you\'ve created in other tracking services. This tool will guide you to relocate the issue to Plane.',
                      textAlign: TextAlign.left,
                      maxLines: 7,
                      type: FontStyle.Small,
                      color: themeProvider.themeManager.primaryTextColor,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    InkWell(
                      onTap: () {
                        _launchUrl();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          children: [
                            CustomText(
                              'Read more',
                              textAlign: TextAlign.left,
                              type: FontStyle.Small,
                              color: themeProvider.themeManager.primaryColour,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.arrow_forward,
                              size: 18,
                              color: themeProvider
                                  .themeManager.placeholderTextColor,
                            ),
                          ],
                        ),
                      ),
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
                      color: themeProvider
                          .themeManager.primaryBackgroundDefaultColor,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                          color:
                              themeProvider.themeManager.borderSubtle01Color)),
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
                                CustomText(
                                  'Github',
                                  textAlign: TextAlign.left,
                                  type: FontStyle.H5,
                                  fontWeight: FontWeightt.Medium,
                                  color: themeProvider
                                      .themeManager.primaryTextColor,
                                ),
                                Container(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10, top: 5, bottom: 8),
                                  decoration: BoxDecoration(
                                      color: integrationProvider
                                                      .integrations["github"] !=
                                                  null &&
                                              integrationProvider
                                                      .integrations["github"]
                                                  ["installed"]
                                          ? themeProvider.themeManager
                                              .successBackgroundColor
                                          : themeProvider.themeManager
                                              .tertiaryBackgroundDefaultColor,
                                      borderRadius: BorderRadius.circular(5)),
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
                                        ? themeProvider
                                            .themeManager.textSuccessColor
                                        : themeProvider
                                            .themeManager.tertiaryTextColor,
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 120,
                            child: CustomText(
                              'Connect with GitHub with your Plane workspace to sync project issues.',
                              textAlign: TextAlign.left,
                              maxLines: 3,
                              type: FontStyle.Medium,
                              color: themeProvider
                                  .themeManager.placeholderTextColor,
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
                      color: themeProvider
                          .themeManager.primaryBackgroundDefaultColor,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                          color:
                              themeProvider.themeManager.borderSubtle01Color)),
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
                                CustomText(
                                  'Jira',
                                  textAlign: TextAlign.left,
                                  type: FontStyle.H5,
                                  fontWeight: FontWeightt.Medium,
                                  color: themeProvider
                                      .themeManager.primaryTextColor,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: integrationProvider
                                                    .integrations["jira"] !=
                                                null &&
                                            integrationProvider
                                                    .integrations["jira"]
                                                ["installed"]
                                        ? themeProvider
                                            .themeManager.successBackgroundColor
                                        : themeProvider.themeManager
                                            .tertiaryBackgroundDefaultColor,
                                  ),
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10, top: 5, bottom: 8),
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
                                        ? themeProvider
                                            .themeManager.textSuccessColor
                                        : themeProvider
                                            .themeManager.tertiaryTextColor,
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 120,
                            child: CustomText(
                              'Import issues and epics from Jira projects and epics.',
                              textAlign: TextAlign.left,
                              maxLines: 3,
                              type: FontStyle.Medium,
                              color: themeProvider
                                  .themeManager.placeholderTextColor,
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

  Future<void> _launchUrl() async {
    const String url = 'https://docs.plane.so/importers/github';
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }
}
