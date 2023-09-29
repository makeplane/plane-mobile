// ignore_for_file: use_build_context_synchronously, unused_local_variable

import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:plane/Authentication/google_sign_in.dart';
import 'package:plane/mixins/widget_state_mixin.dart';
import 'package:plane/utils/custom_toast.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/screens/home_screen.dart';
import 'package:plane/screens/on_boarding/auth/setup_profile_screen.dart';
import 'package:plane/utils/global_functions.dart';
import 'package:plane/widgets/custom_button.dart';
import 'package:plane/utils/constants.dart';
import 'package:plane/widgets/custom_rich_text.dart';
import 'package:plane/widgets/resend_code_button.dart';

import '../../../provider/provider_list.dart';
import '../../../widgets/custom_text.dart';
import 'setup_workspace.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen>
    with WidgetStateMixin {
  GlobalKey<FormState> gkey = GlobalKey<FormState>();

  final controller = PageController();
  final formKey = GlobalKey<FormState>();
  int currentpge = 0;
  TextEditingController email = TextEditingController();
  TextEditingController code = TextEditingController();
  bool sentCode = false;

  @override
  LoadingType getLoading(WidgetRef ref) {
    return setWidgetState([
      ref.read(ProviderList.authProvider).sendCodeState,
      ref.read(ProviderList.authProvider).validateCodeState,
      ref.read(ProviderList.workspaceProvider).workspaceInvitationState,
    ], loadingType: LoadingType.translucent, allowError: false);
  }

  @override
  Widget render(BuildContext context) {
    final themeProvider = ref.watch(ProviderList.themeProvider);
    final authProvider = ref.watch(ProviderList.authProvider);
    final profileProvider = ref.watch(ProviderList.profileProvider);
    final workspaceProvider = ref.watch(ProviderList.workspaceProvider);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Form(
                key: gkey,
                child: SizedBox(
                  // height: height,
                  child: SafeArea(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 16, right: 16, top: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset('assets/svg_images/logo.svg'),
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                            children: [
                              CustomText(
                                'Sign In to',
                                type: FontStyle.H4,
                                fontWeight: FontWeightt.Semibold,
                                color:
                                    themeProvider.themeManager.primaryTextColor,
                              ),
                              CustomText(
                                ' Plane',
                                type: FontStyle.H4,
                                fontWeight: FontWeightt.Semibold,
                                color: themeProvider.themeManager.primaryColour,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          sentCode
                              ? Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color:
                                        const Color.fromRGBO(9, 169, 83, 0.15),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.check_circle,
                                          color: Color.fromRGBO(9, 169, 83, 1),
                                          size: 18,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        CustomText(
                                          'Please check your mail for code',
                                          type: FontStyle.Small,
                                          fontWeight: FontWeightt.Medium,
                                          color: themeProvider
                                              .themeManager.textSuccessColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Container(),
                          sentCode
                              ? const SizedBox(
                                  height: 20,
                                )
                              : Container(),
                          CustomRichText(
                            widgets: [
                              TextSpan(
                                  text: 'Email',
                                  style: TextStyle(
                                      color: themeProvider
                                          .themeManager.tertiaryTextColor)),
                              TextSpan(
                                  text: ' *',
                                  style: TextStyle(
                                      color: themeProvider
                                          .themeManager.textErrorColor))
                            ],
                            type: FontStyle.Small,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            controller: email,
                            decoration: themeProvider
                                .themeManager.textFieldDecoration
                                .copyWith(),
                            style:
                                themeProvider.themeManager.textFieldTextStyle,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return '*Enter your email';
                              }

                              //check if firt letter is uppercase
                              if (val[0] == val[0].toUpperCase()) {
                                return "*First letter can't be uppercase";
                              }

                              if (!RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(val)) {
                                return '*Please Enter valid email';
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          sentCode
                              ? CustomRichText(
                                  widgets: [
                                    TextSpan(
                                        text: 'Enter code',
                                        style: TextStyle(
                                            color: themeProvider.themeManager
                                                .tertiaryTextColor)),
                                    TextSpan(
                                        text: ' *',
                                        style: TextStyle(
                                            color: themeProvider
                                                .themeManager.textErrorColor))
                                  ],
                                  type: FontStyle.Small,
                                )
                              : Container(),
                          sentCode
                              ? const SizedBox(
                                  height: 5,
                                )
                              : Container(),
                          sentCode
                              ? TextFormField(
                                  controller: code,
                                  decoration: themeProvider
                                      .themeManager.textFieldDecoration,
                                  style: themeProvider
                                      .themeManager.textFieldTextStyle,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Please enter the code";
                                    }
                                    return null;
                                  },
                                )
                              : Container(),
                          const SizedBox(
                            height: 10,
                          ),
                          sentCode
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ResendCodeButton(
                                      signUp: true,
                                      email: email.text,
                                    ),
                                  ],
                                )
                              : Container(),
                          sentCode
                              ? const SizedBox(
                                  height: 30,
                                )
                              : Container(),
                          Hero(
                            tag: 'button',
                            child: Button(
                              text: !sentCode ? 'Send code' : 'Log In',
                              ontap: () async {
                                log(email.text);
                                log(themeProvider.themeManager.theme
                                    .toString());
                                if (validateSave()) {
                                  if (!sentCode) {
                                    await ref
                                        .read(ProviderList.authProvider)
                                        .sendMagicCode(email: email.text)
                                        .then((value) {
                                      if (authProvider.sendCodeState ==
                                          StateEnum.error) {
                                        CustomToast.showToast(context,
                                            message:
                                                'Something went wrong, please try again.',
                                            toastType: ToastType.failure);
                                      } else {
                                        setState(() {
                                          sentCode = true;
                                        });
                                      }
                                    });
                                  } else {
                                    await ref
                                        .read(ProviderList.authProvider)
                                        .validateMagicCode(
                                            key: "magic_${email.text}",
                                            token: code.text,
                                            context: context)
                                        .then(
                                      (value) async {
                                        if (authProvider.validateCodeState ==
                                                StateEnum.success &&
                                            profileProvider.getProfileState ==
                                                StateEnum.success) {
                                          if (profileProvider
                                              .userProfile.isOnboarded!) {
                                            // await workspaceProvider
                                            //     .getWorkspaces()
                                            //     .then((value) {
                                            //   if (workspaceProvider
                                            //       .workspaces.isEmpty) {
                                            //     return;
                                            //   }
                                            //   //  log(prov.userProfile.last_workspace_id.toString());

                                            //   ref
                                            //       .read(ProviderList
                                            //           .projectProvider)
                                            //       .getProjects(
                                            //           slug: workspaceProvider
                                            //               .workspaces
                                            //               .where((element) {
                                            //         if (element['id'] ==
                                            //             profileProvider
                                            //                 .userProfile
                                            //                 .last_workspace_id) {
                                            //           // workspaceProvider
                                            //           //         .currentWorkspace =
                                            //           //     element;
                                            //           workspaceProvider
                                            //                   .selectedWorkspace =
                                            //               WorkspaceModel
                                            //                   .fromJson(
                                            //                       element);
                                            //           return true;
                                            //         }
                                            //         return false;
                                            //       }).first['slug']);
                                            //   ref
                                            //       .read(ProviderList
                                            //           .projectProvider)
                                            //       .favouriteProjects(
                                            //           index: 0,
                                            //           slug: workspaceProvider
                                            //               .workspaces
                                            //               .where((element) =>
                                            //                   element['id'] ==
                                            //                   profileProvider
                                            //                       .userProfile
                                            //                       .last_workspace_id)
                                            //               .first['slug'],
                                            //           method: HttpMethod.get,
                                            //           projectID: "");
                                            // });
                                            postHogService(
                                                eventName: 'Log In',
                                                properties: {
                                                  'Source': 'Magic Code',
                                                  'Email': email.text,
                                                },
                                                ref: ref);
                                            Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const HomeScreen(
                                                          fromSignUp: false)),
                                              (route) => false,
                                            );
                                          } else {
                                            final String firstName = ref
                                                .read(ProviderList
                                                    .profileProvider)
                                                .userProfile
                                                .firstName!;

                                            final List workspaces = ref
                                                .read(ProviderList
                                                    .workspaceProvider)
                                                .workspaces;
                                            Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => firstName
                                                        .isEmpty
                                                    ? const SetupProfileScreen()
                                                    : workspaces.isEmpty
                                                        ? const SetupWorkspace()
                                                        : const HomeScreen(
                                                            fromSignUp: false,
                                                          ),
                                              ),
                                              ((route) => false),
                                            );
                                          }
                                        }
                                      },
                                    );
                                  }
                                }
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          (Platform.isIOS &&
                                      dotenv.env['GOOGLE_SERVER_CLIENT_ID'] ==
                                          null) ||
                                  (Platform.isAndroid &&
                                      dotenv.env['GOOGLE_CLIENT_ID'] == null)
                              ? Container()
                              : Column(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: Center(
                                        child: CustomText(
                                          'or',
                                          type: FontStyle.Small,
                                          color: themeProvider.themeManager
                                              .placeholderTextColor,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                  ],
                                ),
                          (Platform.isIOS &&
                                      dotenv.env['GOOGLE_SERVER_CLIENT_ID'] ==
                                          null) ||
                                  (Platform.isAndroid &&
                                      dotenv.env['GOOGLE_CLIENT_ID'] == null)
                              ? Container()
                              : (authProvider.googleAuthState ==
                                      StateEnum.loading
                                  ? SizedBox(
                                      width: width,
                                      child: Center(
                                        child: SizedBox(
                                          width: 30,
                                          height: 30,
                                          child: LoadingIndicator(
                                            indicatorType:
                                                Indicator.lineSpinFadeLoader,
                                            colors: themeProvider.theme ==
                                                        THEME.dark ||
                                                    themeProvider.theme ==
                                                        THEME.darkHighContrast
                                                ? [Colors.white]
                                                : [Colors.black],
                                            strokeWidth: 1.0,
                                            backgroundColor: Colors.transparent,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Button(
                                      text: 'Sign In with Google',
                                      widget: Container(
                                        height: 25,
                                        width: 25,
                                        margin:
                                            const EdgeInsets.only(right: 10),
                                        child: SvgPicture.asset(
                                            'assets/svg_images/google-icon.svg'),
                                      ),
                                      // SvgPicture.asset('assets/svg_images/google-icon.svg',),
                                      textColor: themeProvider
                                          .themeManager.primaryTextColor,
                                      filledButton: false,
                                      ontap: () async {
                                        // await GoogleSignInApi.logout();
                                        try {
                                          final user =
                                              await GoogleSignInApi.logIn();
                                          if (user == null) {
                                            // CustomToast.showToast(context,
                                            //     message:
                                            //         'Something went wrong, please try again.',
                                            //     toastType: ToastType.failure);
                                            return;
                                          }
                                          final GoogleSignInAuthentication
                                              googleAuth =
                                              await user.authentication;
                                          ref
                                              .watch(ProviderList.authProvider)
                                              .googleAuth(data: {
                                            "clientId": dotenv
                                                .env['GOOGLE_SERVER_CLIENT_ID'],
                                            "credential": googleAuth.idToken,
                                            "medium": "google"
                                          }, context: context).then((value) {
                                            if (authProvider.googleAuthState ==
                                                    StateEnum.success &&
                                                profileProvider
                                                        .getProfileState ==
                                                    StateEnum.success) {
                                              if (profileProvider
                                                  .userProfile.isOnboarded!) {
                                                Navigator.pushAndRemoveUntil(
                                                  context,
                                                  (MaterialPageRoute(
                                                    builder: (context) =>
                                                        const HomeScreen(
                                                      fromSignUp: false,
                                                    ),
                                                  )),
                                                  (route) => false,
                                                );
                                              } else {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => ref
                                                            .read(ProviderList
                                                                .profileProvider)
                                                            .userProfile
                                                            .firstName!
                                                            .isEmpty
                                                        ? const SetupProfileScreen()
                                                        : ref
                                                                .read(ProviderList
                                                                    .workspaceProvider)
                                                                .workspaces
                                                                .isEmpty
                                                            ? const SetupWorkspace()
                                                            : const HomeScreen(
                                                                fromSignUp:
                                                                    false,
                                                              ),
                                                  ),
                                                );
                                              }
                                            }
                                          });
                                        } catch (e) {
                                          log(e.toString());
                                        }
                                      },
                                    )),
                          // const SizedBox(
                          //   height: 15,
                          // ),
                          // Button(
                          //   text: 'Sign In with GitHub',
                          //   textColor: themeProvider.isDarkThemeEnabled
                          //       ? Colors.white
                          //       : Colors.black,
                          //   filledButton: false,
                          // ),

                          const Expanded(child: SizedBox()),
                          const SizedBox(
                            height: 20,
                          ),

                          GestureDetector(
                            onTap: () {
                              if (!sentCode) {
                                Navigator.pop(context);
                                return;
                              }
                              setState(() {
                                code.clear();
                                sentCode = false;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.only(bottom: 20),
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.arrow_back,
                                    color: themeProvider
                                        .themeManager.placeholderTextColor,
                                    size: 18,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  CustomText(
                                    'Go back',
                                    type: FontStyle.Small,
                                    color: themeProvider
                                        .themeManager.placeholderTextColor,
                                    fontWeight: FontWeightt.Semibold,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  bool validateSave() {
    final form = gkey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
