import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/provider/theme_provider.dart';
import 'package:plane/provider/whats_new_provider.dart';
import 'package:plane/widgets/custom_app_bar.dart';
import 'package:plane/widgets/custom_text.dart';

class WhatsNewSheet extends ConsumerStatefulWidget {
  const WhatsNewSheet({super.key});

  @override
  ConsumerState<WhatsNewSheet> createState() => _WhatsNewSheetState();
}

class _WhatsNewSheetState extends ConsumerState<WhatsNewSheet> {
  @override
  Widget build(BuildContext context) {
    final whatsNewProvider = ref.watch(ProviderList.whatsNewProvider);
    final themeProvider = ref.watch(ProviderList.themeProvider);
    return whatsNewProvider.whatsNewData == null
        ? Container(
            decoration: BoxDecoration(
              color: themeProvider.themeManager.primaryBackgroundDefaultColor
                  .withOpacity(0.3),
            ),
            alignment: Alignment.center,
            child: Wrap(
              children: [
                SizedBox(
                  height: 30,
                  width: 30,
                  child: LoadingIndicator(
                    indicatorType: Indicator.lineSpinFadeLoader,
                    colors: [themeProvider.themeManager.primaryTextColor],
                    strokeWidth: 1.0,
                    backgroundColor: Colors.transparent,
                  ),
                ),
              ],
            ),
          )
        : Scaffold(
            appBar: CustomAppBar(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                text: 'Product Updates'),
            body: Container(
              padding: const EdgeInsets.only(
                left: 24,
                right: 24,
              ),
              child: ListView.builder(
                itemCount: whatsNewProvider.whatsNewData!.length,
                itemBuilder: (context, index) =>
                    singleVersionData(whatsNewProvider, index, themeProvider),
              ),
            ),
          );
  }

  Widget singleVersionData(
      WhatsNew whatsNewProvider, int index, ThemeProvider themeProvider) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Row(
          children: [
            Chip(
                backgroundColor:
                    themeProvider.themeManager.tertiaryBackgroundDefaultColor,
                label:
                    CustomText(whatsNewProvider.whatsNewData![index]['name'])),
            const Spacer(),
            CustomText(DateFormat('d MMMM y').format(DateTime.parse(
                whatsNewProvider.whatsNewData![index]['published_at']))),
          ],
        ),
        Markdown(
            styleSheet: MarkdownStyleSheet.fromTheme(
              ThemeData(
                textTheme: TextTheme(
                  ////////////////

                  displayLarge:
                      const TextStyle(fontSize: 20, color: Colors.amber),
                  displayMedium:
                      const TextStyle(fontSize: 18, color: Colors.amber),
                  displaySmall:
                      const TextStyle(fontSize: 16, color: Colors.amber),

                  /////////////////////

                  bodyLarge: TextStyle(
                      fontSize: 20,
                      color: themeProvider.themeManager.tertiaryTextColor),
                  bodyMedium: TextStyle(
                      fontSize: 18,
                      color: themeProvider.themeManager.tertiaryTextColor),
                  bodySmall: TextStyle(
                      fontSize: 16,
                      color: themeProvider.themeManager.tertiaryTextColor),

                  /////////////////

                  // labelLarge: TextStyle(fontSize: 20, color: Colors.amber),
                  // labelMedium: TextStyle(fontSize: 20, color: Colors.amber),
                  // labelSmall: TextStyle(fontSize: 20, color: Colors.amber),

                  ////////////////////

                  titleLarge: TextStyle(
                      fontSize: 20,
                      color: themeProvider.themeManager.primaryTextColor),
                  titleMedium: TextStyle(
                      fontSize: 20,
                      color: themeProvider.themeManager.primaryTextColor),
                  titleSmall: TextStyle(
                      fontSize: 20,
                      color: themeProvider.themeManager.primaryTextColor),

                  // overline:
                  // bodyText1:
                  // button:
                  // headline1:
                  // overline:
                  // subtitle1:
                ),
              ),
            ),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            data: whatsNewProvider.whatsNewData![index]['body']),
      ],
    );
  }
}
