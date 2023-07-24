import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/screens/Import%20&%20Export/import_export.dart';
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
      appBar: widget.fromSettings
          ? null
          : CustomAppBar(
              onPressed: () {
                Navigator.of(context).pop();
              },
              text: 'Integrations',
            ),
      body: LoadingWidget(
        loading: integrationProvider.getIntegrationState == StateEnum.loading ||
            integrationProvider.getInstalledIntegrationState ==
                StateEnum.loading,
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
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ImportEport()));
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
                              const CustomText(
                                'Slack',
                                textAlign: TextAlign.left,
                                type: FontStyle.subheading,
                              ),
                              Container(
                                padding: const EdgeInsets.all(5),
                                color:integrationProvider.integrations["slack"]
                                        !=null && integrationProvider.integrations["slack"]
                                        ["installed"]
                                    ? const Color.fromRGBO(9, 169, 83, 1)
                                    : themeProvider.isDarkThemeEnabled
                                        ? darkBackgroundColor
                                        : const Color.fromRGBO(
                                            243, 245, 248, 1),
                                child: CustomText(
                               integrationProvider.integrations["slack"]
                                        !=null &&   integrationProvider.integrations["slack"]
                                          ["installed"]
                                      ? "Installed"
                                      : 'Not Installed',
                                  type: FontStyle.subtitle,
                                  color:integrationProvider.integrations["slack"]
                                        !=null && integrationProvider
                                          .integrations["slack"]["installed"]
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
                            'Connect with Slack with your Plane workspace to sync project issues.',
                            textAlign: TextAlign.left,
                            maxLines: 3,
                            type: FontStyle.title,
                            color: Color.fromRGBO(133, 142, 150, 1),
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
                            const CustomText(
                              'Github',
                              textAlign: TextAlign.left,
                              type: FontStyle.subheading,
                            ),
                             Container(
                                padding: const EdgeInsets.all(5),
                                color:integrationProvider.integrations["github"]
                                        !=null && integrationProvider.integrations["github"]
                                        ["installed"]
                                    ? const Color.fromRGBO(9, 169, 83, 1)
                                    : themeProvider.isDarkThemeEnabled
                                        ? darkBackgroundColor
                                        : const Color.fromRGBO(
                                            243, 245, 248, 1),
                                child: CustomText(
                                 integrationProvider.integrations["github"]
                                        !=null && integrationProvider.integrations["github"]
                                          ["installed"]
                                      ? "Installed"
                                      : 'Not Installed',
                                  type: FontStyle.subtitle,
                                  color:integrationProvider.integrations["github"]
                                        !=null && integrationProvider
                                          .integrations["github"]["installed"]
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
                          type: FontStyle.title,
                          color: Color.fromRGBO(133, 142, 150, 1),
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
