// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
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

class SignIn extends ConsumerStatefulWidget {
  const SignIn({super.key});

  @override
  ConsumerState<SignIn> createState() => _SignInState();
}

class _SignInState extends ConsumerState<SignIn> {
  GlobalKey<FormState> gkey = GlobalKey<FormState>();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

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
              loading: authProvider.signInState == StateEnum.loading ||
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
                              'Sign In to',
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {},
                              child: const CustomText(
                                'Forgot Password?',
                                type: FontStyle.text,
                                color: primaryColor,
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
                                      password: password.text);

                              if (authProvider.signInState ==
                                      StateEnum.success &&
                                  profileProvider.getProfileState ==
                                      StateEnum.success) {
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
                                  Navigator.pop(context);
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
