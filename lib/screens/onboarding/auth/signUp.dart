// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/screens/home_screen.dart';
import 'package:plane/screens/onboarding/auth/setup_profile_screen.dart';
import 'package:plane/widgets/custom_button.dart';
import 'package:plane/widgets/custom_rich_text.dart';
import 'package:plane/widgets/loading_widget.dart';

import '../../../provider/provider_list.dart';
import '../../../widgets/custom_text.dart';
import 'setup_workspace.dart';
import 'sign_in_selfhosted.dart';

class SignUp extends ConsumerStatefulWidget {
  const SignUp({super.key});

  @override
  ConsumerState<SignUp> createState() => _SignUpState();
}

class _SignUpState extends ConsumerState<SignUp> {
  GlobalKey<FormState> gkey = GlobalKey<FormState>();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = ref.watch(ProviderList.authProvider);
    final profileProvider = ref.watch(ProviderList.profileProvider);
    final workspaceProvider = ref.watch(ProviderList.workspaceProvider);
    final themeProvider = ref.watch(ProviderList.themeProvider);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Form(
            key: gkey,
            child: LoadingWidget(
              loading: authProvider.signUpState == StateEnum.loading ||
                  workspaceProvider.workspaceInvitationState ==
                      StateEnum.loading,
              widgetClass: SizedBox(
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
                              'Sign Up to',
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
                        CustomRichText(
                          widgets: [
                            TextSpan(
                                text: 'Email',
                                style: TextStyle(
                                    color: themeProvider
                                        .themeManager.tertiaryTextColor)),
                            TextSpan(
                                text: '*',
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
                        CustomRichText(
                          widgets: [
                            TextSpan(
                                text: 'Password',
                                style: TextStyle(
                                    color: themeProvider
                                        .themeManager.tertiaryTextColor)),
                            TextSpan(
                                text: '*',
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
                          obscureText: true,
                          controller: password,
                          decoration: themeProvider
                              .themeManager.textFieldDecoration
                              .copyWith(),
                          validator: (val) {
                            if (val!.isEmpty) {
                              return '*Enter your password';
                            }
                            return null;
                            //check if firt letter is uppercase
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        CustomRichText(
                          widgets: [
                            TextSpan(
                                text: 'Confirm Password',
                                style: TextStyle(
                                    color: themeProvider
                                        .themeManager.tertiaryTextColor)),
                            TextSpan(
                                text: '*',
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
                          obscureText: true,
                          controller: confirmPassword,
                          decoration: themeProvider
                              .themeManager.textFieldDecoration
                              .copyWith(),
                          validator: (val) {
                            if (val!.isEmpty) {
                              return '*Enter your password';
                            }
                            if (val != password.text) {
                              return '*Password does not match';
                            }
                            return null;
                            //check if firt letter is uppercase
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Hero(
                          tag: 'button',
                          child: Button(
                            text: 'Sign Up',
                            ontap: () async {
                              if (!gkey.currentState!.validate()) {
                                return;
                              }
                              await authProvider
                                  .signUpWithEmailAndPassword(
                                      email: email.text,
                                      password: password.text,
                                      context: context,
                                      ref: ref)
                                  .then((value) {
                                if (authProvider.signUpState ==
                                        StateEnum.success &&
                                    profileProvider.getProfileState ==
                                        StateEnum.success) {
                                  if (profileProvider
                                      .userProfile.isOnboarded!) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const HomeScreen(
                                          fromSignUp: false,
                                        ),
                                      ),
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
                                                    fromSignUp: false,
                                                  ),
                                      ),
                                    );
                                  }
                                }
                              });
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CustomText(
                              'Already have an account?',
                              type: FontStyle.Small,
                              // color: primaryColor,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const SignInSelfHosted(),
                                  ),
                                );
                              },
                              child: CustomText(
                                'Sign In',
                                type: FontStyle.Small,
                                color: themeProvider.themeManager.primaryColour,
                                fontWeight: FontWeightt.Semibold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
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
                                  fontWeight: FontWeightt.Semibold,
                                  color: themeProvider
                                      .themeManager.placeholderTextColor,
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
