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

class SignInSelfHosted extends ConsumerStatefulWidget {
  const SignInSelfHosted({super.key});

  @override
  ConsumerState<SignInSelfHosted> createState() => _SignInSelfHostedState();
}

class _SignInSelfHostedState extends ConsumerState<SignInSelfHosted> {
  GlobalKey<FormState> gkey = GlobalKey<FormState>();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

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
              loading: authProvider.signInState == DataState.loading ||
                  workspaceProvider.workspaceInvitationState ==
                      DataState.loading,
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
                          style: themeProvider.themeManager.textFieldTextStyle,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {},
                              child: CustomText(
                                'Forgot Password?',
                                type: FontStyle.Small,
                                color: themeProvider.themeManager.primaryColour,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Hero(
                          tag: 'button',
                          child: Button(
                            text: 'Sign In',
                            ontap: () async {
                              if (!gkey.currentState!.validate()) {
                                return;
                              }
                              await ref
                                  .read(ProviderList.authProvider)
                                  .signInWithEmailAndPassword(
                                      email: email.text,
                                      password: password.text,
                                      context: context,
                                      ref: ref);

                              if (authProvider.signInState ==
                                      DataState.success &&
                                  profileProvider.getProfileState ==
                                      DataState.success) {
                                if (profileProvider.userProfile.isOnboarded!) {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) => const HomeScreen(
                                  //       fromSignUp: false,
                                  //     ),
                                  //   ),
                                  // );
                                  // ignore: use_build_context_synchronously
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => const HomeScreen(
                                        fromSignUp: false,
                                      ),
                                    ),
                                  );
                                } else {
                                  // ignore: use_build_context_synchronously
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ref
                                              .read(
                                                  ProviderList.profileProvider)
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
                            },
                          ),
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
