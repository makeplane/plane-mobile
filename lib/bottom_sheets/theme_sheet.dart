import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/utils/constants.dart';

import 'package:plane_startup/widgets/custom_text.dart';

import '../utils/enums.dart';

class ThemeSheet extends ConsumerStatefulWidget {
  const ThemeSheet({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ThemeSheetState();
}

class _ThemeSheetState extends ConsumerState<ThemeSheet> {
  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    return Padding(
      padding: const EdgeInsets.only(top: 23, left: 23, right: 23),
      child: Wrap(
        children: [
          Row(
            children: [
              // const Text(
              //   'Type',
              //   style: TextStyle(
              //     fontSize: 24,
              //     fontWeight: FontWeight.w600,
              //   ),
              // ),
              const CustomText(
                'Theme',
                type: FontStyle.H6,
                fontWeight: FontWeightt.Semibold,
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.close,
                  size: 27,
                  color: themeProvider.themeManager.placeholderTextColor,
                ),
              ),
            ],
          ),

          SizedBox(
            height: 50,
            width: double.infinity,
            child: InkWell(
              onTap: () {
                themeProvider.isDarkThemeEnabled = true;
                themeProvider.changeTheme(
                    data: {'theme': fromTHEME(theme: THEME.dark)},
                    context: context);
                Navigator.of(context).pop();
              },
              child: Row(
                children: [
                  themeProvider.isDarkThemeEnabled
                      ? Icon(
                          Icons.radio_button_checked,
                          size: 22,
                          color:
                              themeProvider.themeManager.placeholderTextColor,
                        )
                      : Icon(
                          Icons.radio_button_off,
                          size: 22,
                          color:
                              themeProvider.themeManager.placeholderTextColor,
                        ),
                  const SizedBox(width: 10),
                  const CustomText(
                    'Dark',
                    type: FontStyle.Small,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 1,
            width: double.infinity,
            child: Container(
              color: themeProvider.isDarkThemeEnabled
                  ? darkThemeBorder
                  : Colors.grey[300],
            ),
          ),
          SizedBox(
            height: 50,
            width: double.infinity,
            child: InkWell(
              onTap: () {
                themeProvider.isDarkThemeEnabled = false;
                themeProvider.changeTheme(
                    data: {'theme': fromTHEME(theme: THEME.light)},
                    context: context);
                Navigator.of(context).pop();
              },
              child: Row(
                children: [
                  !themeProvider.isDarkThemeEnabled
                      ? Icon(
                          Icons.radio_button_checked,
                          size: 22,
                          color: themeProvider.themeManager.primaryColour,
                        )
                      : Icon(
                          Icons.radio_button_off,
                          size: 22,
                          color:
                              themeProvider.themeManager.placeholderTextColor,
                        ),
                  const SizedBox(width: 10),
                  const CustomText(
                    'Light',
                    type: FontStyle.Small,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
            width: double.infinity,
          ),

          //  Expanded(child: Container()),

          //long blue button to apply filter
        ],
      ),
    );
  }
}
