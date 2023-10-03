// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:plane/screens/on_boarding/auth/invite_co_workers.dart';
import 'package:plane/utils/custom_toast.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/custom_rich_text.dart';
import 'package:plane/widgets/loading_widget.dart';
import '../../../provider/provider_list.dart';
import '../../../widgets/custom_button.dart';
import '../../../bottom_sheets/company_size_sheet.dart';
import '../../../widgets/custom_text.dart';

class SetupWorkspace extends ConsumerStatefulWidget {
  const SetupWorkspace({super.key, this.fromHomeScreen = false});
  final bool fromHomeScreen;
  @override
  ConsumerState<SetupWorkspace> createState() => _SetupWorkspaceState();
}

class _SetupWorkspaceState extends ConsumerState<SetupWorkspace> {
  final newWorkSpace = true;
  bool dropdownEmpty = false;
  final pageController = PageController();
  int currentPage = 0;
  final formKey = GlobalKey<FormState>();

  List<String> dropDownItems = ['5', '10', '25', '50'];
  String? dropDownValue;
  TextEditingController urlController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  @override
  void initState() {
    final workspaceProvider = ref.read(ProviderList.workspaceProvider);

    workspaceProvider.companySize = '';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final prov = ref.watch(ProviderList.workspaceProvider);
    final themeProv = ref.watch(ProviderList.themeProvider);
    final profileProvider = ref.watch(ProviderList.profileProvider);
    final themeProvider = ref.watch(ProviderList.themeProvider);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: LoadingWidget(
            loading: prov.checkWorkspaceState == StateEnum.loading ||
                prov.createWorkspaceState == StateEnum.loading,
            widgetClass: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Form(
                    key: formKey,
                    child: Container(
                      // height: MediaQuery.of(context).size.height - 80,
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
                          //   'Workspaces',
                          //   style: TextStylingWidget.mainHeading,
                          // ),
                          CustomText(
                            ' Create Workspace',
                            type: FontStyle.H4,
                            fontWeight: FontWeightt.Semibold,
                            color: themeProvider.themeManager.primaryTextColor,
                          ),

                          newWorkSpace
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    CustomRichText(
                                      widgets: [
                                        TextSpan(
                                            text: 'Workspace name',
                                            style: TextStyle(
                                                color: themeProvider
                                                    .themeManager
                                                    .tertiaryTextColor)),
                                        TextSpan(
                                            text: ' *',
                                            style: TextStyle(
                                                color: themeProvider
                                                    .themeManager
                                                    .textErrorColor))
                                      ],
                                      type: FontStyle.Small,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    TextFormField(
                                      controller: nameController,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                          RegExp(
                                            r'^[a-zA-Z0-9_\- ]*',
                                          ),
                                        ),
                                      ],
                                      onChanged: (val) {
                                        setState(() {
                                          urlController.text = val
                                              .replaceAll(" ", "-")
                                              .toLowerCase();
                                        });
                                      },
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return '*Workspace name is required';
                                        }
                                        // Name can only contain (" "), ( - ), ( _ ) & Alphanumeric characters.
                                        return null;
                                      },
                                      style: themeProvider
                                          .themeManager.textFieldTextStyle,
                                      decoration: themeProvider
                                          .themeManager.textFieldDecoration
                                          .copyWith(
                                              floatingLabelBehavior:
                                                  FloatingLabelBehavior.never),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    CustomRichText(
                                      widgets: [
                                        TextSpan(
                                            text: 'Workspace URL',
                                            style: TextStyle(
                                                color: themeProvider
                                                    .themeManager
                                                    .tertiaryTextColor)),
                                        TextSpan(
                                            text: ' *',
                                            style: TextStyle(
                                                color: themeProvider
                                                    .themeManager
                                                    .textErrorColor))
                                      ],
                                      type: FontStyle.Small,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    TextFormField(
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return '*Workspace url is required';
                                        }
                                        // Name can only contain (" "), ( - ), ( _ ) & Alphanumeric characters.
                                        return null;
                                      },
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                          RegExp(
                                            r'^[a-zA-Z0-9_\-]*',
                                          ),
                                        ),
                                      ],
                                      controller: urlController,
                                      style: themeProvider
                                          .themeManager.textFieldTextStyle,
                                      decoration: themeProvider
                                          .themeManager.textFieldDecoration
                                          .copyWith(
                                        prefixIcon: Padding(
                                          padding: const EdgeInsets.only(
                                            left: 15,
                                          ),
                                          child: CustomText(
                                            'https://takeoff.plane.so/',
                                            type: FontStyle.Small,
                                            color: themeProvider.themeManager
                                                .placeholderTextColor,
                                          ),
                                        ),
                                        prefixIconConstraints:
                                            const BoxConstraints(
                                                minWidth: 0, minHeight: 0),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    CustomRichText(
                                      widgets: [
                                        TextSpan(
                                            text: 'How large is your company',
                                            style: TextStyle(
                                                color: themeProvider
                                                    .themeManager
                                                    .tertiaryTextColor)),
                                        TextSpan(
                                            text: ' *',
                                            style: TextStyle(
                                                color: themeProvider
                                                    .themeManager
                                                    .textErrorColor))
                                      ],
                                      type: FontStyle.Small,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    GestureDetector(
                                      key: const Key('companySize'),
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
                                              return const CompanySize();
                                            });
                                      },
                                      child: Container(
                                        height: 55,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          border: Border.all(
                                            color: themeProv.themeManager
                                                .borderSubtle01Color,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  left: 16),
                                              child: CustomText(
                                                  prov.companySize == ''
                                                      ? 'Select Company Size'
                                                      : prov.companySize,
                                                  type: FontStyle.Small,
                                                  color: prov.companySize == ''
                                                      ? themeProvider
                                                          .themeManager
                                                          .placeholderTextColor
                                                      : themeProvider
                                                          .themeManager
                                                          .primaryTextColor),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  right: 16),
                                              child: Icon(
                                                Icons.keyboard_arrow_down,
                                                color: themeProv.themeManager
                                                    .primaryTextColor,
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
                                            color: themeProvider
                                                .themeManager.textErrorColor,
                                            type: FontStyle.Small,
                                            fontWeight: FontWeightt.Semibold,
                                          )
                                        : Container(),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    Button(
                                        text: 'Create Workspace',
                                        ontap: () async {
                                          //unfocus
                                          FocusScope.of(context).unfocus();
                                          if (!formKey.currentState!
                                              .validate()) {
                                            if (prov.companySize == '') {
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
                                          if (prov.companySize == '') {
                                            setState(() {
                                              dropdownEmpty = true;
                                            });
                                            return;
                                          }
                                          if (await prov.checkWorspaceSlug(
                                              slug: urlController.text)) {
                                            await prov.createWorkspace(
                                                name:
                                                    nameController.text.trim(),
                                                slug: urlController.text.trim(),
                                                size: prov.companySize,
                                                context: context,
                                                refs: ref);
                                            if (prov.createWorkspaceState ==
                                                StateEnum.success) {
                                              if (!widget.fromHomeScreen) {
                                                profileProvider
                                                    .updateProfile(data: {
                                                  'onboarding_step': {
                                                    "workspace_join": false,
                                                    "profile_complete": true,
                                                    "workspace_create": true,
                                                    "workspace_invite": false
                                                  }
                                                });

                                                Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const InviteCOWorkers(
                                                            // fromSignUp: true,
                                                            ),
                                                  ),
                                                  (Route<dynamic> route) =>
                                                      false,
                                                );
                                              } else {
                                                Navigator.of(context).pop();
                                              }
                                            }
                                          } else {
                                            CustomToast.showToast(context,
                                                message:
                                                    'Workspace url is already taken',
                                                toastType: ToastType.defult);
                                          }
                                        })
                                  ],
                                )
                              : Container(),

                          const Spacer(),
                          prov.selectedWorkspace.workspaceId.isNotEmpty &&
                                  !widget.fromHomeScreen
                              ? Button(
                                  text: 'Skip',
                                  filledButton: false,
                                  removeStroke: true,
                                  textColor: themeProvider
                                      .themeManager.placeholderTextColor,
                                  ontap: () async {
                                    // await prov.getWorkspaceInvitations();
                                    // if (prov.workspaceInvitations.isNotEmpty) {
                                    //   profileProvider.updateProfile(data: {
                                    //     'onboarding_step': {
                                    //       "workspace_join": false,
                                    //       "profile_complete": true,
                                    //       "workspace_create": true,
                                    //       "workspace_invite": true
                                    //     }
                                    //   });
                                    //   Navigator.pushAndRemoveUntil(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //       builder: (context) => const JoinWorkspaces(
                                    //         fromOnboard: true,
                                    //       ),
                                    //     ),
                                    //     (Route<dynamic> route) => false,
                                    //   );
                                    // } else {
                                    await prov.ref!
                                        .read(ProviderList.profileProvider)
                                        .updateIsOnBoarded(val: true);
                                    await profileProvider.updateProfile(data: {
                                      'onboarding_step': {
                                        "workspace_join": true,
                                        "profile_complete": true,
                                        "workspace_create": true,
                                        "workspace_invite": false
                                      }
                                    });
                                    await ref
                                        .read(ProviderList.workspaceProvider)
                                        .getWorkspaces();
                                    // Wrap Navigator with SchedulerBinding to wait for rendering state before navigating

                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const InviteCOWorkers(
                                                // fromSignUp: true,
                                                ),
                                      ),
                                      (Route<dynamic> route) => false,
                                    );

                                    // }
                                  },
                                )
                              : Container(),

                          widget.fromHomeScreen
                              ? GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    width: MediaQuery.of(context).size.width,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.arrow_back,
                                          color: themeProvider.themeManager
                                              .placeholderTextColor,
                                          size: 18,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        CustomText(
                                          'Go back',
                                          type: FontStyle.Small,
                                          color: themeProvider.themeManager
                                              .placeholderTextColor,
                                          fontWeight: FontWeightt.Semibold,
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Container(),
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
    );
  }
}
