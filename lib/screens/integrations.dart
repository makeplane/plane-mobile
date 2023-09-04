import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/utils/enums.dart';
import 'package:plane_startup/widgets/custom_app_bar.dart';
import 'package:plane_startup/widgets/custom_text.dart';
import 'package:plane_startup/widgets/loading_widget.dart';

class Integrations extends ConsumerStatefulWidget {
  const Integrations({this.fromSettings = false, super.key});
  final bool fromSettings;
  @override
  ConsumerState<Integrations> createState() => _IntegrationsState();
}

class _IntegrationsState extends ConsumerState<Integrations> {
  // @override
  // void initState() {
  //   var prov = ref.read(ProviderList.integrationProvider);
  //   if (prov.integrations.isEmpty) {
  //     ref.read(ProviderList.integrationProvider).getAllAvailableIntegrations();
  //   }

  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var workspaceProvider = ref.watch(ProviderList.workspaceProvider);
    return Scaffold(
      appBar: widget.fromSettings
          ? null
          : CustomAppBar(
              onPressed: () {
                Navigator.of(context).pop();
              },
              text: 'Integrations',
            ),
      body: LoadingWidget(
        loading: false,
        // integrationProvider.getIntegrationState == StateEnum.loading ||
        //     integrationProvider.getInstalledIntegrationState ==
        //         StateEnum.loading,

        widgetClass: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 16, right: 16),
              height: widget.fromSettings ? 0 : 1,
              width: MediaQuery.of(context).size.width,
              color: themeProvider.isDarkThemeEnabled
                  ? darkThemeBorder
                  : Colors.grey[300],
            ),
            GestureDetector(
              onTap: () {},
              child: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(top: 16, bottom: 16),
                margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
                decoration: BoxDecoration(
                    color: themeProvider
                        .themeManager.primaryBackgroundDefaultColor,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                        color: themeProvider.themeManager.borderSubtle01Color)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 1),
                      child: Image.asset(
                        'assets/images/slack_logo.png',
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
                                'Slack',
                                textAlign: TextAlign.left,
                                type: FontStyle.Small,
                                color:
                                    themeProvider.themeManager.primaryTextColor,
                              ),
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, top: 5, bottom: 8),
                                decoration: BoxDecoration(
                                    color: workspaceProvider.slackIntegration ==
                                            null
                                        ? themeProvider.themeManager
                                            .tertiaryBackgroundDefaultColor
                                        : themeProvider.themeManager
                                            .successBackgroundColor,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Center(
                                  child: CustomText(
                                    workspaceProvider.slackIntegration == null
                                        ? 'Not Installed'
                                        : 'Installed',
                                    type: FontStyle.XSmall,
                                    color: workspaceProvider.slackIntegration ==
                                            null
                                        ? lightPlaceholderTextColor
                                        : lightTextSuccessColor,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 5),
                          width: MediaQuery.of(context).size.width - 120,
                          child: CustomText(
                            workspaceProvider.slackIntegration == null
                                ? 'Connect with Slack with your Plane workspace to sync project issues.'
                                : 'Slack is connected',
                            textAlign: TextAlign.left,
                            maxLines: 3,
                            type: FontStyle.Medium,
                            color: const Color.fromRGBO(133, 142, 150, 1),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(top: 16, bottom: 16),
              margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
              decoration: BoxDecoration(
                  color:
                      themeProvider.themeManager.primaryBackgroundDefaultColor,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                      color: themeProvider.themeManager.borderSubtle01Color)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 1),
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
                              type: FontStyle.Small,
                              color:
                                  themeProvider.themeManager.primaryTextColor,
                            ),
                            Container(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, top: 5, bottom: 8),
                              decoration: BoxDecoration(
                                  color: workspaceProvider.githubIntegration ==
                                          null
                                      ? themeProvider.themeManager
                                          .tertiaryBackgroundDefaultColor
                                      : themeProvider
                                          .themeManager.successBackgroundColor,
                                  borderRadius: BorderRadius.circular(5)),
                              child: CustomText(
                                  workspaceProvider.githubIntegration == null
                                      ? 'Not Installed'
                                      : 'Installed',
                                  type: FontStyle.XSmall,
                                  color:
                                      workspaceProvider.slackIntegration == null
                                          ? lightPlaceholderTextColor
                                          : lightTextSuccessColor),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        width: MediaQuery.of(context).size.width - 120,
                        child: CustomText(
                          workspaceProvider.githubIntegration == null
                              ? 'Connect with GitHub with your Plane workspace to sync project issues.'
                              : 'Github is connected',
                          textAlign: TextAlign.left,
                          maxLines: 3,
                          type: FontStyle.Medium,
                          color: const Color.fromRGBO(133, 142, 150, 1),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
