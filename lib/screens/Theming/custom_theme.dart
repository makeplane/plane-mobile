import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:plane/provider/theme_provider.dart';
import 'package:plane/utils/color_manager.dart';
import 'package:plane/utils/constants.dart';
import 'package:plane/widgets/custom_button.dart';
import 'package:plane/widgets/custom_text.dart';

import '../../provider/provider_list.dart';
import '../../utils/enums.dart';
import '../../widgets/custom_app_bar.dart';

class CustomTheme extends ConsumerStatefulWidget {
  const CustomTheme({super.key});

  @override
  ConsumerState<CustomTheme> createState() => _CustomThemeState();
}

class _CustomThemeState extends ConsumerState<CustomTheme> {
  final fields = {
    'Accent Color': TextEditingController(),
    'Background Color': TextEditingController(),
    'Text Color': TextEditingController(),
    'Navbar Background Color': TextEditingController(),
    'Navbar Text Color': TextEditingController(),
  };
  List colors = [
    '#B71F1F',
    '#08AB22',
    '#BC009E',
    '#F15700',
    '#290CDE',
    '#B1700D',
    '#08BECA',
    '#6500CA',
    '#E98787',
    '#ADC57C',
    '#75A0C8',
    '#E96B6B',
    '#FFFFFF',
    '#000000'
  ];
  int? colorSelectorIndex;

  @override
  void initState() {
    final profileProvider = ref.read(ProviderList.profileProvider);
    // if (profileProvider.userProfile.theme == null ||
    //     profileProvider.userProfile.theme!.isEmpty) {
    fields['Accent Color']!.text =
        profileProvider.userProfile.theme!['primary'] ?? '#3f76ff';
    fields['Background Color']!.text =
        profileProvider.userProfile.theme!['background'] ?? '#0d101b';
    fields['Text Color']!.text =
        profileProvider.userProfile.theme!['text'] ?? '#c5c5c5';
    fields['Navbar Background Color']!.text =
        profileProvider.userProfile.theme!['sidebarBackground'] ?? '#0d101b';
    fields['Navbar Text Color']!.text =
        profileProvider.userProfile.theme!['sidebarText'] ?? '#c5c5c5';
    //  }
    super.initState();
  }

  final formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final themeProvider = ref.watch(ProviderList.themeProvider);
    final profileProvider = ref.watch(ProviderList.profileProvider);

    return Scaffold(
      appBar: CustomAppBar(
          textColor: themeProvider.themeManager.primaryTextColor,
          text: 'Custom Theme',
          onPressed: () => Navigator.pop(context)),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Form(
              key: formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: MediaQuery.sizeOf(context).height * 0.3,
                    width: MediaQuery.sizeOf(context).width,
                    color: themeProvider.themeManager.primaryColour,
                    child: Container(
                      padding: const EdgeInsets.only(top: 20),
                      alignment: Alignment.centerRight,
                      child: SvgPicture.asset(
                        themeProvider.theme == THEME.light
                            ? "assets/svg_images/light_mode.svg"
                            : themeProvider.theme == THEME.dark
                                ? "assets/svg_images/dark_mode.svg"
                                : themeProvider.theme == THEME.lightHighContrast
                                    ? "assets/svg_images/light_high_contrast.svg"
                                    : themeProvider.theme ==
                                            THEME.darkHighContrast
                                        ? "assets/svg_images/dark_high_contrast.svg"
                                        : "assets/svg_images/custom_theme.svg",
                        height: MediaQuery.sizeOf(context).height * 0.3,
                        alignment: Alignment.centerRight,
                      ),
                    ),
                  ),
                  Stack(
                    children: [
                      ListView.builder(
                          itemCount: fields.length,
                          shrinkWrap: true,
                          primary: false,
                          padding: const EdgeInsets.all(20),
                          itemBuilder: (ctx, index) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  fields.keys.elementAt(index),
                                  type: FontStyle.Small,
                                  color: themeProvider
                                      .themeManager.tertiaryTextColor,
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                Column(
                                  children: [
                                    TextFormField(
                                      controller:
                                          fields.values.elementAt(index),
                                      decoration: themeProvider
                                          .themeManager.textFieldDecoration
                                          .copyWith(
                                              suffix: InkWell(
                                        onTap: () {
                                          if (index == colorSelectorIndex) {
                                            setState(() {
                                              colorSelectorIndex = null;
                                            });
                                          } else {
                                            setState(() {
                                              colorSelectorIndex = index;
                                            });
                                          }
                                          FocusScope.of(context).unfocus();
                                        },
                                        child: Container(
                                          height: 20,
                                          width: 20,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: themeProvider
                                                    .themeManager
                                                    .borderSubtle01Color),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            color: int.tryParse(
                                                            "FF${fields.values.elementAt(index).text.toString().toUpperCase().replaceAll("#", "FF")}",
                                                            radix: 16) ==
                                                        null ||
                                                    fields.values
                                                        .elementAt(index)
                                                        .text
                                                        .trim()
                                                        .isEmpty
                                                ? Color(int.parse(
                                                    colors[0]
                                                        .toUpperCase()
                                                        .replaceAll("#", "FF"),
                                                    radix: 16))
                                                : Color(int.parse(
                                                    "FF${fields.values.elementAt(index).text.toString().toUpperCase().replaceAll("#", "")}",
                                                    radix: 16)),
                                          ),
                                        ),
                                        // Icon(
                                        //   Icons.arrow_drop_down,
                                        //   color: themeProvider.themeManager
                                        //       .placeholderTextColor,
                                        //   size: 20,
                                        // ),
                                      )),
                                      style: themeProvider
                                          .themeManager.textFieldTextStyle,
                                      validator: (val) {
                                        if (val!.isEmpty) {
                                          return 'Please enter a value';
                                        } else if (int.tryParse(
                                                val.replaceAll(
                                                  '#',
                                                  'FF',
                                                ),
                                                radix: 16) ==
                                            null) {
                                          return 'Please enter a valid color code';
                                        }
                                        return null;
                                      },
                                    ),
                                    (colorSelectorIndex == 3 ||
                                                colorSelectorIndex == 4) &&
                                            (index == 4)
                                        ? const SizedBox(height: 200)
                                        : Container(),
                                  ],
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                              ],
                            );
                          }),
                      Positioned(
                          top: ((colorSelectorIndex ?? 0).toDouble() * 85) + 95,
                          right: 0,
                          child: Container(
                            alignment: Alignment.centerRight,
                            width: MediaQuery.of(context).size.width,
                            child: colorSelector(
                                themeProvider,
                                fields.values
                                    .elementAt(colorSelectorIndex ?? 0),
                                colorSelectorIndex),
                          ))
                    ],
                  ),
                  Container(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 20),
                      child: Button(
                        text: 'Set Theme',
                        ontap: () {
                          if (!formkey.currentState!.validate()) {
                            return;
                          }
                          final theme = profileProvider.userProfile.theme;

                          theme!['theme'] = fromTHEME(theme: THEME.custom);

                          // themeProvider.changeTheme(
                          //     data: {'theme': theme}, context: context);
                          themeProvider.changeTheme(data: {
                            'theme': {
                              'primary': fields['Accent Color']!.text,
                              'background': fields['Background Color']!.text,
                              'text': fields['Text Color']!.text,
                              'sidebarBackground':
                                  fields['Navbar Background Color']!.text,
                              'sidebarText': fields['Navbar Text Color']!.text,
                              'theme': 'custom'
                            }
                          }, context: context);
                          colorSelectorIndex = null;
                        },
                      ))
                ],
              ),
            ),
          ),
          profileProvider.updateProfileState == StateEnum.loading
              ? Container(
                  alignment: Alignment.center,
                  color: themeProvider.theme == THEME.dark ||
                          themeProvider.theme == THEME.darkHighContrast
                      ? themeProvider.themeManager.primaryBackgroundDefaultColor
                          .withOpacity(0.7)
                      : themeProvider.theme == THEME.custom
                          ? themeProvider
                              .themeManager.secondaryBackgroundDefaultColor
                              .withOpacity(0.7)
                          : themeProvider
                              .themeManager.primaryBackgroundDefaultColor
                              .withOpacity(0.7),
                  // height: 25,
                  // width: 25,
                  child: Center(
                    child: SizedBox(
                      height: 25,
                      width: 25,
                      child: LoadingIndicator(
                        indicatorType: Indicator.lineSpinFadeLoader,
                        colors: [
                          themeProvider.theme == THEME.dark ||
                                  themeProvider.theme == THEME.darkHighContrast
                              ? Colors.white
                              : themeProvider.theme == THEME.custom
                                  ? themeProvider.themeManager
                                      .primaryBackgroundDefaultColor
                                  : Colors.black
                        ],
                        strokeWidth: 1.0,
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  Widget colorSelector(ThemeProvider themeProvider,
      TextEditingController colorController, int? index) {
    return index == colorSelectorIndex && index != null
        ? Card(
            color: themeProvider.themeManager.secondaryBackgroundDefaultColor,
            margin: const EdgeInsets.only(right: 15, left: 15, bottom: 15),
            elevation: 10,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10, top: 15),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.start,
                    alignment: WrapAlignment.start,
                    runAlignment: WrapAlignment.start,
                    spacing: 5,
                    children: colors
                        .map(
                          (e) => GestureDetector(
                            onTap: () {
                              setState(() {
                                colorController.text =
                                    e.toString().toUpperCase();
                                colorSelectorIndex = null;
                              });
                              FocusScope.of(context).unfocus();
                            },
                            child: Container(
                              height: 50,
                              width: 50,
                              margin: const EdgeInsets.only(bottom: 20),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: ColorManager.getColorFromHexaDecimal(
                                    e.toString()),
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: const [
                                  BoxShadow(
                                    blurRadius: 1.0,
                                    color: greyColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                ///////////////////////////////////
                // Container(
                //   margin:
                //       const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                //   // height: 50,
                //   child: Row(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Container(
                //         width: 55,
                //         height: 60,
                //         alignment: Alignment.center,
                //         decoration: BoxDecoration(
                //             color: int.tryParse(
                //                             "FF${colorController.text.toString().toUpperCase().replaceAll("#", "FF")}",
                //                             radix: 16) ==
                //                         null ||
                //                     colorController.text.trim().isEmpty
                //                 ? Color(int.parse(
                //                     colors[0]
                //                         .toUpperCase()
                //                         .replaceAll("#", "FF"),
                //                     radix: 16))
                //                 : Color(int.parse(
                //                     "FF${colorController.text.toString().toUpperCase().replaceAll("#", "")}",
                //                     radix: 16)),
                //             borderRadius: const BorderRadius.only(
                //                 topLeft: Radius.circular(8),
                //                 bottomLeft: Radius.circular(8))),
                //         child: const CustomText(
                //           '#',
                //           color: Colors.white,
                //           fontWeight: FontWeightt.Semibold,
                //           fontSize: 20,
                //         ),
                //       ),
                //       Expanded(
                //         child: TextFormField(
                //           validator: (value) {
                //             if (value!.isEmpty) {
                //               return '*required';
                //             }
                //             return null;
                //           },
                //           controller: colorController,
                //           maxLength: 6,
                //           onChanged: (val) {
                //             colorController.text = val.toUpperCase();
                //             colorController.selection =
                //                 TextSelection.fromPosition(TextPosition(
                //                     offset: colorController.text.length));
                //             setState(() {});
                //           },
                //           decoration: themeProvider
                //               .themeManager.textFieldDecoration
                //               .copyWith(
                //             counterText: '',
                //             errorStyle: const TextStyle(
                //                 fontSize: 16,
                //                 color: Colors.red,
                //                 fontWeight: FontWeight.w600),
                //             errorBorder: OutlineInputBorder(
                //               borderSide: BorderSide(
                //                   color: Colors.red.shade600, width: 1.0),
                //               borderRadius: const BorderRadius.only(
                //                 topRight: Radius.circular(6),
                //                 bottomRight: Radius.circular(6),
                //               ),
                //             ),
                //             focusedErrorBorder: OutlineInputBorder(
                //               borderSide: BorderSide(
                //                   color: Colors.red.shade600, width: 2.0),
                //               borderRadius: const BorderRadius.only(
                //                 topRight: Radius.circular(6),
                //                 bottomRight: Radius.circular(6),
                //               ),
                //             ),
                //             enabledBorder: OutlineInputBorder(
                //               borderSide: BorderSide(
                //                   color: themeProvider
                //                       .themeManager.borderSubtle01Color,
                //                   width: 1.0),
                //               borderRadius: const BorderRadius.only(
                //                 topRight: Radius.circular(6),
                //                 bottomRight: Radius.circular(6),
                //               ),
                //             ),
                //             focusedBorder: OutlineInputBorder(
                //               borderSide: BorderSide(
                //                   color: themeProvider
                //                       .themeManager.borderSubtle01Color,
                //                   width: 1.0),
                //               borderRadius: const BorderRadius.only(
                //                 topRight: Radius.circular(6),
                //                 bottomRight: Radius.circular(6),
                //               ),
                //             ),
                //             fillColor: themeProvider
                //                 .themeManager.secondaryBackgroundActiveColor,
                //             filled: true,
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          )
        : Container();
  }
}
