// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:plane/bottom_sheets/time_zone_selector_sheet.dart';
import 'package:plane/screens/on_boarding/auth/join_workspaces.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/screens/on_boarding/auth/setup_workspace.dart';
import 'package:plane/utils/timezone_manager.dart';
import 'package:plane/widgets/loading_widget.dart';

// import '../Provider/provider_list.dart';
import '../../../widgets/custom_button.dart';
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
    final themeProvider = ref.watch(ProviderList.themeProvider);
    final prov = ref.watch(ProviderList.profileProvider);
    final workspaceProv = ref.watch(ProviderList.workspaceProvider);
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
                height: MediaQuery.of(context).size.height * 0.9,
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
                          CustomText(
                            'Setup your profile',
                            type: FontStyle.H4,
                            fontWeight: FontWeightt.Semibold,
                            color: themeProvider.themeManager.primaryTextColor,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomRichText(
                                  widgets: [
                                    TextSpan(
                                        text: 'First name',
                                        style: TextStyle(
                                            color: themeProvider.themeManager
                                                .tertiaryTextColor)),
                                    TextSpan(
                                        text: ' *',
                                        style: TextStyle(
                                            color: themeProvider
                                                .themeManager.textErrorColor))
                                  ],
                                  type: FontStyle.Medium,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return "*required ";
                                    }
                                    if (val.length >= 24) {
                                      return "name should be smaller ";
                                    }
                                    return null;
                                  },
                                  controller: prov.firstName,
                                  style: themeProvider
                                      .themeManager.textFieldTextStyle,
                                  decoration: themeProvider
                                      .themeManager.textFieldDecoration,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                CustomRichText(
                                  widgets: [
                                    TextSpan(
                                        text: 'Last name',
                                        style: TextStyle(
                                            color: themeProvider.themeManager
                                                .tertiaryTextColor)),
                                    TextSpan(
                                        text: ' *',
                                        style: TextStyle(
                                            color: themeProvider
                                                .themeManager.textErrorColor))
                                  ],
                                  type: FontStyle.Medium,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                    validator: (val) {
                                      if (val!.isEmpty) {
                                        return "*required ";
                                      }
                                      if (val.length >= 24) {
                                        return "name should be smaller ";
                                      }

                                      return null;
                                    },
                                    style: themeProvider
                                        .themeManager.textFieldTextStyle,
                                    controller: prov.lastName,
                                    decoration: themeProvider
                                        .themeManager.textFieldDecoration),
                                const SizedBox(
                                  height: 20,
                                ),
                                CustomRichText(
                                  widgets: [
                                    TextSpan(
                                        text: 'What is your Role?',
                                        style: TextStyle(
                                            color: themeProvider.themeManager
                                                .tertiaryTextColor)),
                                    TextSpan(
                                        text: ' *',
                                        style: TextStyle(
                                            color: themeProvider
                                                .themeManager.textErrorColor))
                                  ],
                                  type: FontStyle.Medium,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    FocusScope.of(context).unfocus();
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
                                    height: 55,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      border: Border.all(
                                        color: themeProvider
                                            .themeManager.borderSubtle01Color,
                                      ),
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
                                            type: FontStyle.Medium,
                                          ),
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(right: 16),
                                          child: Icon(
                                            Icons.keyboard_arrow_down,
                                            color: themeProvider
                                                .themeManager.primaryTextColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // ),
                                ),
                                dropdownEmpty
                                    ? CustomText(
                                        "*required",
                                        type: FontStyle.Small,
                                        fontWeight: FontWeightt.Semibold,
                                        color: themeProvider
                                            .themeManager.textErrorColor,
                                      )
                                    : Container(),
                                const SizedBox(height: 20),
                                SizedBox(
                                  child: CustomText('Time Zone',
                                      type: FontStyle.Medium,
                                      color: themeProvider
                                          .themeManager.tertiaryTextColor),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                        isScrollControlled: true,
                                        context: context,
                                        constraints: BoxConstraints(
                                          maxHeight: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.8,
                                        ),
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20),
                                          ),
                                        ),
                                        builder: (context) {
                                          return const TimeZoneSelectorSheet();
                                        });
                                  },
                                  child: Container(
                                    height: 50,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      border: Border.all(
                                          color: themeProvider.themeManager
                                              .borderSubtle01Color),
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
                                            TimeZoneManager.timeZones
                                                        .firstWhere((element) =>
                                                            element['value'] ==
                                                            prov.selectedTimeZone)[
                                                    'label'] ??
                                                '',
                                            type: FontStyle.Small,
                                          ),
                                        ),
                                        const Spacer(),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(right: 16),
                                          child: Icon(
                                            Icons.keyboard_arrow_down,
                                            color: themeProvider
                                                .themeManager.primaryTextColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 40),
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
                                      "user_timezone":
                                          prov.selectedTimeZone.toString(),
                                      'onboarding_step': {
                                        "workspace_join": false,
                                        "profile_complete": true,
                                        "workspace_create": false,
                                        "workspace_invite": false
                                      }
                                    });
                                    await workspaceProv
                                        .getWorkspaceInvitations();
                                    if (workspaceProv
                                        .workspaceInvitations.isNotEmpty) {
                                      // profileProvider.updateProfile(data: {
                                      //   'onboarding_step': {
                                      //     "workspace_join": false,
                                      //     "profile_complete": true,
                                      //     "workspace_create": false,
                                      //     "workspace_invite": false
                                      //   }
                                      // });
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const JoinWorkspaces(
                                            fromOnboard: true,
                                          ),
                                        ),
                                      );
                                    } else {
                                      // await workspaceProv.ref!
                                      //     .read(ProviderList.profileProvider)
                                      //     .updateIsOnBoarded(val: true);
                                      // await profileProvider
                                      //     .updateProfile(data: {
                                      //   'onboarding_step': {
                                      //     "workspace_join": true,
                                      //     "profile_complete": true,
                                      //     "workspace_create": false,
                                      //     "workspace_invite": false
                                      //   }
                                      // });
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (ctx) =>
                                                  const SetupWorkspace()));
                                    }
                                  },
                                  child: const Button(
                                    text: 'Continue',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 1 == 0
                    //     ? Container()
                    //     : Positioned(
                    //         bottom: 0,
                    //         child: SizedBox(
                    //           width: MediaQuery.of(context).size.width,
                    //           child: GestureDetector(
                    //             onTap: () {
                    //               Navigator.pop(context);
                    //               // pageController.previousPage(
                    //               //     duration: const Duration(milliseconds: 250),
                    //               //     curve: Curves.easeInOut);
                    //               // setState(() {
                    //               //   currentPage--;
                    //               // });
                    //             },
                    //             child: Row(
                    //               mainAxisAlignment: MainAxisAlignment.center,
                    //               children: [
                    //                 Icon(
                    //                   Icons.arrow_back,
                    //                   color: themeProvider
                    //                       .themeManager.placeholderTextColor,
                    //                   size: 18,
                    //                 ),
                    //                 const SizedBox(
                    //                   width: 5,
                    //                 ),
                    //                 CustomText(
                    //                   'Go back',
                    //                   type: FontStyle.Small,
                    //                   fontWeight: FontWeightt.Semibold,
                    //                   color: themeProvider
                    //                       .themeManager.placeholderTextColor,
                    //                 ),
                    //               ],
                    //             ),
                    //           ),
                    //         ),
                    //       ),
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
