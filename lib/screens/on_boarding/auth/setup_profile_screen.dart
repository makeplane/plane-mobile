// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:plane_startup/utils/enums.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/screens/on_boarding/auth/setup_workspace.dart';
import 'package:plane_startup/widgets/loading_widget.dart';

// import '../Provider/provider_list.dart';
import '../../../widgets/custom_button.dart';
import '../../../utils/constants.dart';
import '../../../widgets/custom_rich_text.dart';
import '../../../bottom_sheets/role_sheet.dart';
import '../../../widgets/custom_text.dart';

class SetupProfileScreen extends ConsumerStatefulWidget {
  const SetupProfileScreen({super.key});

  @override
  ConsumerState<SetupProfileScreen> createState() => _SetupProfileScreenState();
}

class _SetupProfileScreenState extends ConsumerState<SetupProfileScreen> {
  final formKey = GlobalKey<FormState>();

  bool newWorkSpace = true;
  bool dropdownEmpty = false;

  @override
  void initState() {
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
    final prov = ref.read(ProviderList.profileProvider);
    prov.dropDownValue = prov.userProfile.role;
    // });

    super.initState();
  }

  bool checked = false;
  List workSpaces = ['new Work space'];

  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    final prov = ref.watch(ProviderList.profileProvider);
    // log(dropDownValue.toString());
    return Scaffold(
      //backgroundColor: themeProvider.backgroundColor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LoadingWidget(
          loading: prov.updateProfileState == StateEnum.loading,
          widgetClass: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 16, right: 16, top: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset('assets/svg_images/logo.svg'),
                          const SizedBox(
                            height: 30,
                          ),
                          // const Text(
                          //   'Setup up your profile',
                          //   style: TextStylingWidget.mainHeading,
                          // ),
                          const CustomText(
                            'Setup your profile',
                            type: FontStyle.mainHeading,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const CustomRichText(
                                  widgets: [
                                    TextSpan(text: 'First name'),
                                    TextSpan(
                                        text: '*',
                                        style: TextStyle(color: Colors.red))
                                  ],
                                  type: RichFontStyle.text,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return "*required ";
                                    }
                                    return null;
                                  },
                                  controller: prov.firstName,
                                  decoration: kTextFieldDecoration,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                const CustomRichText(
                                  widgets: [
                                    TextSpan(text: 'Last name'),
                                    TextSpan(
                                        text: '*',
                                        style: TextStyle(color: Colors.red))
                                  ],
                                  type: RichFontStyle.text,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                    validator: (val) {
                                      if (val!.isEmpty) {
                                        return "*required ";
                                      }
                                      return null;
                                    },
                                    controller: prov.lastName,
                                    decoration: kTextFieldDecoration),
                                const SizedBox(
                                  height: 20,
                                ),
                                const CustomRichText(
                                  widgets: [
                                    TextSpan(text: 'What is your Role?'),
                                    TextSpan(
                                        text: '*',
                                        style: TextStyle(color: Colors.red))
                                  ],
                                  type: RichFontStyle.text,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                        context: context,
                                        constraints: BoxConstraints(
                                          maxHeight: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.5,
                                        ),
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20),
                                          ),
                                        ),
                                        builder: (context) {
                                          return const RoleSheet();
                                        });
                                  },
                                  child: Container(
                                    height: 50,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      border: Border.all(
                                          color:
                                              themeProvider.isDarkThemeEnabled
                                                  ? darkThemeBorder
                                                  : Colors.grey.shade300),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          margin:
                                              const EdgeInsets.only(left: 16),
                                          child: CustomText(
                                            prov.dropDownValue == null
                                                ? 'Select Role'
                                                : prov.dropDownValue!,
                                            type: FontStyle.text,
                                          ),
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(right: 16),
                                          child: Icon(
                                            Icons.keyboard_arrow_down,
                                            color:
                                                themeProvider.isDarkThemeEnabled
                                                    ? darkPrimaryTextColor
                                                    : lightPrimaryTextColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // ),
                                ),
                                dropdownEmpty
                                    ? const CustomText(
                                        "*required",
                                        fontSize: 14,
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      )
                                    : Container(),
                                const SizedBox(
                                  height: 30,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    if (!formKey.currentState!.validate()) {
                                      if (prov.dropDownValue == null) {
                                        setState(() {
                                          dropdownEmpty = true;
                                        });
                                      } else {
                                        setState(() {
                                          dropdownEmpty = false;
                                        });
                                      }
                                      return;
                                    }
                                    if (prov.dropDownValue == null) {
                                      setState(() {
                                        dropdownEmpty = true;
                                      });
                                      return;
                                    }
                                    await prov.updateProfile(data: {
                                      'first_name': prov.firstName.text,
                                      'last_name': prov.lastName.text,
                                      'role': prov.dropDownValue,
                                      'onboarding_step': {
                                        "workspace_join": false,
                                        "profile_complete": true,
                                        "workspace_create": false,
                                        "workspace_invite": false
                                      }
                                    });
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (ctx) =>
                                                const SetupWorkspace()));
                                  },
                                  child: const Button(
                                    text: 'Continue',
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    1 == 0
                        ? Container()
                        : Positioned(
                            bottom: 0,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: GestureDetector(
                                onTap: () {
                                  // pageController.previousPage(
                                  //     duration: const Duration(milliseconds: 250),
                                  //     curve: Curves.easeInOut);
                                  // setState(() {
                                  //   currentPage--;
                                  // });
                                },
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.arrow_back,
                                      color: greyColor,
                                      size: 18,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    // Text(
                                    //   'Go back',
                                    //   style: TextStylingWidget.description
                                    //       .copyWith(
                                    //     color: greyColor,
                                    //     fontWeight: FontWeight.w600,
                                    //   ),
                                    // ),
                                    CustomText(
                                      'Go back',
                                      type: FontStyle.description,
                                      color: greyColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
