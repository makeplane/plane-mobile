// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:plane_startup/screens/on_boarding/auth/signIn.dart';
import 'package:plane_startup/utils/enums.dart';
import 'package:plane_startup/screens/home_screen.dart';
import 'package:plane_startup/screens/on_boarding/auth/setup_profile_screen.dart';
import 'package:plane_startup/widgets/custom_button.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/widgets/custom_rich_text.dart';
import 'package:plane_startup/widgets/loading_widget.dart';

import '../../../provider/provider_list.dart';
import '../../../widgets/custom_text.dart';
import 'setup_workspace.dart';

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
    var authProvider = ref.watch(ProviderList.authProvider);
    var profileProvider = ref.watch(ProviderList.profileProvider);
    var workspaceProvider = ref.watch(ProviderList.workspaceProvider);
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
                        const Row(
                          children: [
                            CustomText(
                              'Sign Up to',
                              type: FontStyle.heading,
                            ),
                            CustomText(
                              ' Plane',
                              type: FontStyle.heading,
                              color: primaryColor,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        const CustomRichText(
                          widgets: [
                            TextSpan(text: 'Email'),
                            TextSpan(
                                text: '*', style: TextStyle(color: Colors.red))
                          ],
                          type: RichFontStyle.text,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          controller: email,
                          decoration: kTextFieldDecoration.copyWith(),
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
                        const CustomRichText(
                          widgets: [
                            TextSpan(text: 'Password'),
                            TextSpan(
                                text: '*', style: TextStyle(color: Colors.red))
                          ],
                          type: RichFontStyle.text,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          obscureText: true,
                          controller: password,
                          decoration: kTextFieldDecoration.copyWith(),
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
                        const CustomRichText(
                          widgets: [
                            TextSpan(text: 'Confirm Password'),
                            TextSpan(
                                text: '*', style: TextStyle(color: Colors.red))
                          ],
                          type: RichFontStyle.text,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          obscureText: true,
                          controller: confirmPassword,
                          decoration: kTextFieldDecoration.copyWith(),
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
                                      password: password.text)
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
                              type: FontStyle.text,
                              // color: primaryColor,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const SignIn(),
                                  ),
                                );
                              },
                              child: const CustomText(
                                'Sign In',
                                type: FontStyle.text,
                                color: primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Container(
                          padding: const EdgeInsets.only(bottom: 20),
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.arrow_back,
                                color: greyColor,
                                size: 18,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: const CustomText(
                                  'Go back',
                                  type: FontStyle.heading2,
                                  color: greyColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
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
