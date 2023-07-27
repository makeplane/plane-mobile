// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:plane_startup/config/const.dart';
import 'package:plane_startup/screens/on_boarding/auth/invite_co_workers.dart';
import 'package:plane_startup/utils/custom_toast.dart';
import 'package:plane_startup/utils/enums.dart';
import 'package:plane_startup/widgets/custom_rich_text.dart';
import 'package:plane_startup/widgets/loading_widget.dart';

import '../../../provider/provider_list.dart';
import '../../../widgets/custom_button.dart';
import '../../../bottom_sheets/company_size_sheet.dart';
import '../../../utils/constants.dart';
import '../../../widgets/custom_text.dart';

class SetupWorkspace extends ConsumerStatefulWidget {
  const SetupWorkspace({super.key, this.fromHomeScreen = false});
  final bool fromHomeScreen;
  @override
  ConsumerState<SetupWorkspace> createState() => _SetupWorkspaceState();
}

class _SetupWorkspaceState extends ConsumerState<SetupWorkspace> {
  var newWorkSpace = true;
  var dropdownEmpty = false;
  final pageController = PageController();
  int currentPage = 0;
  final formKey = GlobalKey<FormState>();

  List<String> dropDownItems = ['5', '10', '25', '50'];
  String? dropDownValue;
  TextEditingController urlController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  @override
  void initState() {
    var workspaceProvider = ref.read(ProviderList.workspaceProvider);

    workspaceProvider.companySize = '';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var prov = ref.watch(ProviderList.workspaceProvider);
    var themeProv = ref.watch(ProviderList.themeProvider);
    var profileProvider = ref.watch(ProviderList.profileProvider);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LoadingWidget(
          loading: prov.checkWorkspaceState == StateEnum.loading ||
              prov.createWorkspaceState == StateEnum.loading,
          widgetClass: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height - 80,
                padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
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
                    const CustomText(
                      ' Create Workspaces',
                      type: FontStyle.heading,
                    ),
                    // const SizedBox(
                    //   height: 30,
                    // ),
                    // !widget.fromHomeScreen
                    //     ? Container(
                    //         width: MediaQuery.of(context).size.width,
                    //         decoration: BoxDecoration(
                    //             color: Colors.grey[200],
                    //             borderRadius: BorderRadius.circular(5)),
                    //         padding: const EdgeInsets.all(6),
                    //         child: Row(
                    //           mainAxisAlignment: MainAxisAlignment.center,
                    //           children: [
                    //             Expanded(
                    //               child: InkWell(
                    //                 onTap: () {
                    //                   setState(() {
                    //                     newWorkSpace = true;
                    //                   });
                    //                 },
                    //                 child: Container(
                    //                   decoration: BoxDecoration(
                    //                       borderRadius:
                    //                           BorderRadius.circular(5),
                    //                       color: newWorkSpace
                    //                           ? primaryColor
                    //                           : Colors.transparent),
                    //                   padding: const EdgeInsets.symmetric(
                    //                       vertical: 8, horizontal: 8),
                    //                   child: Center(
                    //                     // child: Text(
                    //                     //   'New Workspace',
                    //                     //   style: TextStylingWidget.buttonText
                    //                     //       .copyWith(
                    //                     //           color: newWorkSpace
                    //                     //               ? Colors.white
                    //                     //               : greyColor),
                    //                     // ),
                    //                     child: CustomText(
                    //                       'New Workspace',
                    //                       type: FontStyle.buttonText,
                    //                       color: newWorkSpace
                    //                           ? Colors.white
                    //                           : greyColor,
                    //                     ),
                    //                   ),
                    //                 ),
                    //               ),
                    //             ),
                    //             const SizedBox(
                    //               width: 10,
                    //             ),
                    //             Expanded(
                    //               child: InkWell(
                    //                 onTap: () {
                    //                   setState(() {
                    //                     newWorkSpace = false;
                    //                   });
                    //                 },
                    //                 child: Container(
                    //                   decoration: BoxDecoration(
                    //                       borderRadius:
                    //                           BorderRadius.circular(5),
                    //                       color: !newWorkSpace
                    //                           ? primaryColor
                    //                           : Colors.transparent),
                    //                   padding: const EdgeInsets.symmetric(
                    //                       vertical: 8, horizontal: 8),
                    //                   child: Center(
                    //                     // child: Text(
                    //                     //   'Join Workspace',
                    //                     //   style: TextStylingWidget.buttonText
                    //                     //       .copyWith(
                    //                     //           color: !newWorkSpace
                    //                     //               ? Colors.white
                    //                     //               : greyColor),
                    //                     // ),
                    //                     child: CustomText(
                    //                       'Join Workspace',
                    //                       type: FontStyle.buttonText,
                    //                       color: !newWorkSpace
                    //                           ? Colors.white
                    //                           : greyColor,
                    //                     ),
                    //                   ),
                    //                 ),
                    //               ),
                    //             )
                    //           ],
                    //         ),
                    //       )
                    //     : const SizedBox(),
                    newWorkSpace
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              const CustomRichText(
                                widgets: [
                                  TextSpan(text: 'Workspace name'),
                                  TextSpan(
                                    text: '*',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                                type: RichFontStyle.text,
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
                                    urlController.text =
                                        val.replaceAll(" ", "-").toLowerCase();
                                  });
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return '*Workspace name is required';
                                  }
                                  // Name can only contain (" "), ( - ), ( _ ) & Alphanumeric characters.
                                  return null;
                                },
                                decoration: kTextFieldDecoration.copyWith(
                                    labelText: 'e.g. My Workspace', floatingLabelBehavior: FloatingLabelBehavior.never),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const CustomRichText(
                                widgets: [
                                  TextSpan(text: 'Workspace URL'),
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
                                //enabled: false,

                                // style: GoogleFonts.getFont(APP_FONT).copyWith(
                                //     fontSize: 16,
                                //     color: Colors.black,
                                //     fontWeight: FontWeight.normal),
                                decoration: kTextFieldDecoration.copyWith(
                                  isDense: true,
                                  prefixIcon: const Padding(
                                    padding: EdgeInsets.only(left: 15),
                                    // child: Text(
                                    //   "https://takeoff.plane.so/",
                                    //   style: TextStyle(fontSize: 16),
                                    // ),
                                    child: CustomText(
                                      'https://takeoff.plane.so/',
                                      type: FontStyle.text,
                                    ),
                                  ),
                                  prefixIconConstraints: const BoxConstraints(
                                      minWidth: 0, minHeight: 0),
                                ),
                              ),
                              // prov.urlAvailable
                              //     ? CustomText(
                              //         'Workspace URL is already taken!',
                              //         color: Colors.red.shade700,
                              //         type: FontStyle.subtitle,
                              //         fontWeight: FontWeight.bold,
                              //       )
                              //     : Container(),
                              const SizedBox(
                                height: 20,
                              ),
                              const CustomRichText(
                                widgets: [
                                  TextSpan(text: 'How large is your company?'),
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
                                        maxHeight:
                                            MediaQuery.of(context).size.height *
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
                                  height: 50,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    border: Border.all(
                                        color: themeProv.isDarkThemeEnabled
                                            ? darkThemeBorder
                                            : Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(left: 16),
                                        child: CustomText(
                                          prov.companySize == ''
                                              ? 'Select Company Size'
                                              : prov.companySize,
                                          type: FontStyle.title,
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            const EdgeInsets.only(right: 16),
                                        child: Icon(
                                          Icons.keyboard_arrow_down,
                                          color: themeProv.isDarkThemeEnabled
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
                              Button(
                                  text: 'Create Workspace',
                                  ontap: () async {
                                    if (!formKey.currentState!.validate()) {
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
                                          name: nameController.text.trim(),
                                          slug: urlController.text.trim(),
                                          size: prov.companySize,
                                          context: context);
                                      if (prov.createWorkspaceState ==
                                          StateEnum.success) {
                                        if (!widget.fromHomeScreen) {
                                          profileProvider.updateProfile(data: {
                                            'onboarding_step': {
                                              "workspace_join": false,
                                              "profile_complete": true,
                                              "workspace_create": true,
                                              "workspace_invite": false
                                            }
                                          });
                                          Navigator.push(
                                            Const.globalKey.currentContext!,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const InviteCOWorkers(),
                                            ),
                                          );
                                        } else {
                                          Navigator.of(context).pop();
                                        }
                                      }
                                    } else {
                                      CustomToast().showToast(context,
                                          'Workspace url is already taken');
                                    }
                                  })
                            ],
                          )
                        : Container()
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
