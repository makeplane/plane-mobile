import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/screens/Theming/custom_theme.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/utils/enums.dart';
import 'package:plane_startup/widgets/custom_text.dart';

import '../../widgets/custom_app_bar.dart';

class PrefrencesScreen extends ConsumerStatefulWidget {
  const PrefrencesScreen({super.key});

  @override
  ConsumerState<PrefrencesScreen> createState() => _PrefrencesScreenState();
}

class _PrefrencesScreenState extends ConsumerState<PrefrencesScreen> {
  getSelectedTheme(THEME theme) {
    switch (theme) {
      case THEME.light:
        return 0;
      case THEME.dark:
        return 1;
      case THEME.lightHighContrast:
        return 2;
      case THEME.darkHighContrast:
        return 3;
      case THEME.systemPreferences:
        return 4;
      case THEME.custom:
        return 5;
      default:
        return 0;
    }
  }

  late int selectedTheme;

  @override
  void initState() {
    var profileProvider = ref.read(ProviderList.profileProvider);
    if (profileProvider.userProfile.theme == null ||
        profileProvider.userProfile.theme!.isEmpty) {
      selectedTheme = 0;
    } else {
      selectedTheme = profileProvider.userProfile.theme!['theme'] == 'system'
          ? 4
          : getSelectedTheme(
              themeParser(theme: profileProvider.userProfile.theme!['theme']));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.read(ProviderList.themeProvider);
    var profileProvider = ref.read(ProviderList.profileProvider);
    return Scaffold(
      appBar: CustomAppBar(
          textColor: themeProvider.themeManager.primaryTextColor,
          text: 'Preferences',
          onPressed: () => Navigator.pop(context)),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              Row(
                children: [
                  ...List.generate(
                    2,
                    (index) => Expanded(
                        child: index == 0
                            ? GestureDetector(
                                onTap: () {
                                  var theme = profileProvider.userProfile.theme;

                                  theme!['theme'] =
                                      fromTHEME(theme: THEME.systemPreferences);
                                  log(theme.toString());
                                  themeProvider.changeTheme(
                                      data: {'theme': theme}, context: context);
                                  setState(() {
                                    selectedTheme = index + 4;
                                  });
                                },
                                child: Container(
                                    margin: EdgeInsets.only(
                                        right: index == 0 ? 10 : 0),
                                    height: 185,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: themeProvider
                                            .themeManager.borderSubtle01Color,
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: bottomBar(
                                        text: 'System Preference',
                                        circleBorder: themeProvider
                                            .themeManager.borderSubtle01Color,
                                        borderColor: themeProvider
                                            .themeManager.borderSubtle01Color,
                                        selected: (index + 4) == selectedTheme,
                                        rightHalf: Colors.black,
                                        backgroundColor: themeProvider
                                            .themeManager
                                            .secondaryBackgroundDefaultColor,
                                        svg: "assets/svg_images/light_mode.svg",
                                        leftHalf: Colors.white)),
                              )
                            : GestureDetector(
                                onTap: () {
                                  var theme = profileProvider.userProfile.theme;

                                  theme!['theme'] =
                                      fromTHEME(theme: THEME.custom);
                                  log(theme.toString());
                                  themeProvider.changeTheme(
                                      data: {'theme': theme}, context: context);
                                  setState(() {
                                    selectedTheme = index + 4;
                                  });
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => const CustomTheme()));
                                },
                                child: Container(
                                    margin: EdgeInsets.only(
                                        right: index == 0 ? 10 : 0),
                                    height: 185,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: themeProvider
                                            .themeManager.borderSubtle01Color,
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: bottomBar(
                                        text: 'Custom Theme',
                                        circleBorder: themeProvider
                                            .themeManager.borderSubtle01Color,
                                        borderColor: themeProvider
                                            .themeManager.borderSubtle01Color,
                                        selected: (index + 4) == selectedTheme,
                                        rightHalf: const Color.fromRGBO(
                                            130, 35, 254, 1),
                                        backgroundColor: themeProvider
                                            .themeManager
                                            .secondaryBackgroundDefaultColor,
                                        svg:
                                            "assets/svg_images/custom_theme.svg",
                                        leftHalf: Colors.white)),
                              )),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  ...List.generate(
                    2,
                    (index) => Expanded(
                        child: GestureDetector(
                      onTap: () {
                        var theme = profileProvider.userProfile.theme;
                        theme!['theme'] = fromTHEME(
                            theme: index == 0 ? THEME.light : THEME.dark);
                        themeProvider.changeTheme(
                            data: {'theme': theme}, context: context);

                        setState(() {
                          selectedTheme = index;
                        });
                      },
                      child: Container(
                          margin: EdgeInsets.only(right: index == 0 ? 10 : 0),
                          height: 185,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: themeProvider
                                  .themeManager.borderSubtle01Color,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: bottomBar(
                              text: index == 0 ? 'Light Mode' : 'Dark Mode',
                              circleBorder: index == 0
                                  ? themeProvider
                                      .themeManager.borderStrong01Color
                                  : themeProvider
                                      .themeManager.tertiaryTextColor,
                              borderColor: themeProvider
                                  .themeManager.borderSubtle01Color,
                              selected: index == selectedTheme,
                              rightHalf: primaryColor,
                              backgroundColor: index == 0
                                  ? themeProvider.themeManager
                                      .secondaryBackgroundDefaultColor
                                  : const Color.fromRGBO(46, 46, 46, 1),
                              svg: index == 0
                                  ? "assets/svg_images/light_mode.svg"
                                  : "assets/svg_images/dark_mode.svg",
                              leftHalf: Colors.white)),
                    )),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  ...List.generate(
                    2,
                    (index) => Expanded(
                        child: GestureDetector(
                      onTap: () {
                        var theme = profileProvider.userProfile.theme;
                        theme!['theme'] = fromTHEME(
                            theme: index == 0
                                ? THEME.lightHighContrast
                                : THEME.darkHighContrast);
                        themeProvider.changeTheme(
                            data: {'theme': theme}, context: context);

                        setState(() {
                          selectedTheme = (index + 2);
                        });
                      },
                      child: Container(
                          margin: EdgeInsets.only(right: index == 0 ? 10 : 0),
                          height: 185,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: themeProvider
                                  .themeManager.borderSubtle01Color,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: bottomBar(
                              text: index == 0
                                  ? 'Light High Contast'
                                  : 'Dark High Contast',
                              circleBorder: index == 0
                                  ? Colors.black
                                  : themeProvider
                                      .themeManager.borderSubtle01Color,
                              borderColor: themeProvider
                                  .themeManager.borderSubtle01Color,
                              selected: (index + 2) == selectedTheme,
                              rightHalf: primaryColor,
                              backgroundColor: index == 0
                                  ? themeProvider.themeManager
                                      .secondaryBackgroundDefaultColor
                                  : const Color.fromRGBO(46, 46, 46, 1),
                              svg: index == 0
                                  ? "assets/svg_images/light_high_contrast.svg"
                                  : "assets/svg_images/dark_high_contrast.svg",
                              leftHalf:
                                  index == 0 ? Colors.white : Colors.black)),
                    )),
                  )
                ],
              ),
            ],
          ),

          /////////////////////////////////////
          // Column(
          //   children: [
          //     Row(
          //       children: [
          //         ...List.generate(
          //           2,
          //           (index) => Expanded(
          //               child: GestureDetector(
          //             onTap: () {
          //               var theme = profileProvider.userProfile.theme;
          //               theme!['theme'] = fromTHEME(
          //                   theme: index == 0 ? THEME.light : THEME.dark);
          //               themeProvider.changeTheme(
          //                   data: {'theme': theme}, context: context);

          //               setState(() {
          //                 selectedTheme = index;
          //               });
          //             },
          //             child: Container(
          //                 margin: EdgeInsets.only(right: index == 0 ? 10 : 0),
          //                 height: 185,
          //                 decoration: BoxDecoration(
          //                   border: Border.all(
          //                     color: themeProvider
          //                         .themeManager.borderSubtle01Color,
          //                   ),
          //                   borderRadius: BorderRadius.circular(4),
          //                 ),
          //                 child: bottomBar(
          //                     text: index == 0 ? 'Light Mode' : 'Dark Mode',
          //                     circleBorder: index == 0
          //                         ? themeProvider
          //                             .themeManager.borderStrong01Color
          //                         : themeProvider
          //                             .themeManager.tertiaryTextColor,
          //                     borderColor: themeProvider
          //                         .themeManager.borderSubtle01Color,
          //                     selected: index == selectedTheme,
          //                     rightHalf: primaryColor,
          //                     backgroundColor: index == 0
          //                         ? themeProvider.themeManager
          //                             .secondaryBackgroundDefaultColor
          //                         : const Color.fromRGBO(46, 46, 46, 1),
          //                     svg: index == 0
          //                         ? "assets/svg_images/light_mode.svg"
          //                         : "assets/svg_images/dark_mode.svg",
          //                     leftHalf: Colors.white)),
          //           )),
          //         )
          //       ],
          //     ),
          //     const SizedBox(
          //       height: 10,
          //     ),
          //     Row(
          //       children: [
          //         ...List.generate(
          //           2,
          //           (index) => Expanded(
          //               child: GestureDetector(
          //             onTap: () {
          //               var theme = profileProvider.userProfile.theme;
          //               theme!['theme'] = fromTHEME(
          //                   theme: index == 0
          //                       ? THEME.lightHighContrast
          //                       : THEME.darkHighContrast);
          //               themeProvider.changeTheme(
          //                   data: {'theme': theme}, context: context);

          //               setState(() {
          //                 selectedTheme = (index + 2);
          //               });
          //             },
          //             child: Container(
          //                 margin: EdgeInsets.only(right: index == 0 ? 10 : 0),
          //                 height: 185,
          //                 decoration: BoxDecoration(
          //                   border: Border.all(
          //                     color: themeProvider
          //                         .themeManager.borderSubtle01Color,
          //                   ),
          //                   borderRadius: BorderRadius.circular(4),
          //                 ),
          //                 child: bottomBar(
          //                     text: index == 0
          //                         ? 'Light High Contast'
          //                         : 'Dark High Contast',
          //                     circleBorder: index == 0
          //                         ? Colors.black
          //                         : themeProvider
          //                             .themeManager.borderSubtle01Color,
          //                     borderColor: themeProvider
          //                         .themeManager.borderSubtle01Color,
          //                     selected: (index + 2) == selectedTheme,
          //                     rightHalf: primaryColor,
          //                     backgroundColor: index == 0
          //                         ? themeProvider.themeManager
          //                             .secondaryBackgroundDefaultColor
          //                         : const Color.fromRGBO(46, 46, 46, 1),
          //                     svg: index == 0
          //                         ? "assets/svg_images/light_high_contrast.svg"
          //                         : "assets/svg_images/dark_high_contrast.svg",
          //                     leftHalf:
          //                         index == 0 ? Colors.white : Colors.black)),
          //           )),
          //         )
          //       ],
          //     ),
          //     const SizedBox(
          //       height: 10,
          //     ),
          //     Row(
          //       children: [
          //         ...List.generate(
          //           2,
          //           (index) => Expanded(
          //               child: index == 1
          //                   ? GestureDetector(
          //                       onTap: () {
          //                         var theme = profileProvider.userProfile.theme;

          //                         theme!['theme'] =
          //                             fromTHEME(theme: THEME.systemPreferences);
          //                         log(theme.toString());
          //                         themeProvider.changeTheme(
          //                             data: {'theme': theme}, context: context);
          //                         setState(() {
          //                           selectedTheme = index + 4;
          //                         });
          //                       },
          //                       child: Container(
          //                           margin: EdgeInsets.only(
          //                               right: index == 0 ? 10 : 0),
          //                           height: 185,
          //                           decoration: BoxDecoration(
          //                             border: Border.all(
          //                               color: themeProvider
          //                                   .themeManager.borderSubtle01Color,
          //                             ),
          //                             borderRadius: BorderRadius.circular(4),
          //                           ),
          //                           child: bottomBar(
          //                               text: 'System Preference',
          //                               circleBorder: themeProvider
          //                                   .themeManager.borderSubtle01Color,
          //                               borderColor: themeProvider
          //                                   .themeManager.borderSubtle01Color,
          //                               selected: (index + 4) == selectedTheme,
          //                               rightHalf: Colors.black,
          //                               backgroundColor: themeProvider
          //                                   .themeManager
          //                                   .secondaryBackgroundDefaultColor,
          //                               svg: "assets/svg_images/light_mode.svg",
          //                               leftHalf: Colors.white)),
          //                     )
          //                   : GestureDetector(
          //                       onTap: () {
          //                         var theme = profileProvider.userProfile.theme;

          //                         theme!['theme'] =
          //                             fromTHEME(theme: THEME.custom);
          //                         log(theme.toString());
          //                         themeProvider.changeTheme(
          //                             data: {'theme': theme}, context: context);
          //                         setState(() {
          //                           selectedTheme = index + 4;
          //                         });
          //                         Navigator.push(
          //                             context,
          //                             MaterialPageRoute(
          //                                 builder: (_) => const CustomTheme()));
          //                       },
          //                       child: Container(
          //                           margin: EdgeInsets.only(
          //                               right: index == 0 ? 10 : 0),
          //                           height: 185,
          //                           decoration: BoxDecoration(
          //                             border: Border.all(
          //                               color: themeProvider
          //                                   .themeManager.borderSubtle01Color,
          //                             ),
          //                             borderRadius: BorderRadius.circular(4),
          //                           ),
          //                           child: bottomBar(
          //                               text: 'Custom Theme',
          //                               circleBorder: themeProvider
          //                                   .themeManager.borderSubtle01Color,
          //                               borderColor: themeProvider
          //                                   .themeManager.borderSubtle01Color,
          //                               selected: (index + 4) == selectedTheme,
          //                               rightHalf: const Color.fromRGBO(
          //                                   130, 35, 254, 1),
          //                               backgroundColor: themeProvider
          //                                   .themeManager
          //                                   .secondaryBackgroundDefaultColor,
          //                               svg:
          //                                   "assets/svg_images/custom_theme.svg",
          //                               leftHalf: Colors.white)),
          //                     )),
          //         )
          //       ],
          //     )
          //   ],
          // ),
        ),
      ),
    );
  }

  Widget bottomBar(
      {required Color borderColor,
      required Color circleBorder,
      required bool selected,
      required String text,
      required Color rightHalf,
      required Color backgroundColor,
      required String svg,
      required Color leftHalf}) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 20),
          color: backgroundColor,
          alignment: Alignment.centerRight,
          child: SvgPicture.asset(
            svg,
          ),
        ),
        Container(
          height: 1,
          color: borderColor,
        ),
        Container(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Transform.rotate(
                angle: -19.7,
                child: Column(
                  children: [
                    Container(
                        height: 10,
                        width: 20,
                        decoration: BoxDecoration(
                            color: leftHalf,
                            border: Border.all(color: circleBorder),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(100),
                              topRight: Radius.circular(100),
                            ))),
                    Container(
                        height: 10,
                        width: 20,
                        decoration: BoxDecoration(
                            color: rightHalf,
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(100),
                              bottomRight: Radius.circular(100),
                            ))),
                  ],
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: CustomText(
                  text,
                  type: FontStyle.Small,
                  maxLines: 1,
                  fontWeight: FontWeightt.Medium,
                ),
              ),
              selected
                  ? Container(
                      margin: const EdgeInsets.only(left: 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(color: primaryColor)),
                      child: const Icon(
                        Icons.done,
                        color: primaryColor,
                        size: 15,
                      ))
                  : Container(
                      margin: const EdgeInsets.only(left: 5),
                    )
            ],
          ),
        ),
      ],
    );
  }
}
