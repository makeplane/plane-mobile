import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:plane_startup/widgets/custom_button.dart';
import 'package:plane_startup/widgets/custom_text.dart';

import '../../provider/provider_list.dart';
import '../../utils/enums.dart';
import '../../widgets/custom_app_bar.dart';

class CustomTheme extends ConsumerStatefulWidget {
  const CustomTheme({super.key});

  @override
  ConsumerState<CustomTheme> createState() => _CustomThemeState();
}

class _CustomThemeState extends ConsumerState<CustomTheme> {
  var fields = {
    'Accent Color': TextEditingController(),
    'Background Color': TextEditingController(),
    'Text Color': TextEditingController(),
    'Navbar Background Color': TextEditingController(),
    'Navbar Text Color': TextEditingController(),
  };

  @override
  void initState() {
    var profileProvider = ref.read(ProviderList.profileProvider);
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

  var formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var profileProvider = ref.watch(ProviderList.profileProvider);

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
                              color:
                                  themeProvider.themeManager.tertiaryTextColor,
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            TextFormField(
                              controller: fields.values.elementAt(index),
                              decoration: themeProvider
                                  .themeManager.textFieldDecoration
                                  .copyWith(),
                              style:
                                  themeProvider.themeManager.textFieldTextStyle,
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
                            const SizedBox(
                              height: 15,
                            ),
                          ],
                        );
                      }),
                  Container(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 20),
                      child: Button(
                        text: 'Set Theme',
                        ontap: () {
                          if (!formkey.currentState!.validate()) {
                            return;
                          }
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
                          },context: context);
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
                              .themeManager.secondaryBackgroundDefaultColor.withOpacity(0.7)
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
                          ? themeProvider
                              .themeManager.primaryBackgroundDefaultColor
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
}
