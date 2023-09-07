import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:plane/utils/custom_toast.dart';
import 'package:plane/widgets/custom_button.dart';
import 'package:plane/widgets/loading_widget.dart';

import '../../../provider/provider_list.dart';
import '../../../utils/enums.dart';
import '../../../widgets/custom_rich_text.dart';
import '../../../widgets/custom_text.dart';
import 'reset_password.dart';

class ForgotPassword extends ConsumerStatefulWidget {
  const ForgotPassword({super.key});

  @override
  ConsumerState<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends ConsumerState<ForgotPassword> {
  var email = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var authProvider = ref.watch(ProviderList.authProvider);
    var themeProvider = ref.watch(ProviderList.themeProvider);
    return Scaffold(
      body: SafeArea(
        child: LoadingWidget(
          loading: authProvider.sendCodeState == StateEnum.loading,
          widgetClass: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              margin: const EdgeInsets.only(
                top: 20,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset('assets/svg_images/logo.svg'),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        const CustomText(
                          'Forgot Password',
                          type: FontStyle.H4,
                          fontWeight: FontWeightt.Semibold,
                        ),
                        CustomText(
                          '',
                          type: FontStyle.H4,
                          fontWeight: FontWeightt.Semibold,
                          color: themeProvider.themeManager.primaryColour,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const CustomRichText(
                      widgets: [
                        TextSpan(text: 'Email'),
                        TextSpan(text: '*', style: TextStyle(color: Colors.red))
                      ],
                      type: FontStyle.Small,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      controller: email,
                      decoration: themeProvider.themeManager.textFieldDecoration
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
                      height: 25,
                    ),
                    Button(
                        text: 'Send Code',
                        ontap: () async {
                          if (formKey.currentState!.validate()) {
                            await authProvider.sendForgotCode(
                                email: email.text);
                            if (authProvider.sendCodeState ==
                                StateEnum.success) {
                              // ignore: use_build_context_synchronously
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const ResetPassword()));
                            } else {
                              // ignore: use_build_context_synchronously
                              CustomToast.showToast(context,
                                  message: 'Please check the email');
                            }
                          }
                        }),
                    const SizedBox(
                      height: 25,
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
