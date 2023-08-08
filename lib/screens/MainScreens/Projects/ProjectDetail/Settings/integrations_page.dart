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
    return Container(
      color: themeProvider.isDarkThemeEnabled
          ? darkSecondaryBackgroundDefaultColor
          : lightSecondaryBackgroundDefaultColor,
      child: ListView.builder(
        itemCount: 1,
        itemBuilder: (context, index) {
          return Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(top: 16, bottom: 16),
            margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
            decoration: BoxDecoration(
                color: themeProvider.isDarkThemeEnabled
                    ? darkBackgroundColor
                    : lightBackgroundColor,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                    color: themeProvider.isDarkThemeEnabled
                        ? darkThemeBorder
                        : strokeColor)),
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
                    const CustomText(
                      'Github',
                      textAlign: TextAlign.left,
                      type: FontStyle.Small,
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      width: MediaQuery.of(context).size.width - 120,
                      child: const CustomText(
                        'Select GitHub repository to enable sync.',
                        textAlign: TextAlign.left,
                        maxLines: 3,
                        type: FontStyle.Small,
                        color: Color.fromRGBO(133, 142, 150, 1),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
