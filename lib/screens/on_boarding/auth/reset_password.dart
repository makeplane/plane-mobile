import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:plane_startup/widgets/custom_button.dart';
import 'package:plane_startup/widgets/loading_widget.dart';

import '../../../provider/provider_list.dart';
import '../../../utils/constants.dart';
import '../../../utils/enums.dart';
import '../../../widgets/custom_rich_text.dart';
import '../../../widgets/custom_text.dart';

class ResetPassword extends ConsumerStatefulWidget {
  const ResetPassword({super.key});

  @override
  ConsumerState<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends ConsumerState<ResetPassword> {
  @override
  Widget build(BuildContext context) {
    var authProvider = ref.watch(ProviderList.authProvider);
    return Scaffold(
      body: SafeArea(
        child: LoadingWidget(
          loading: authProvider.resetPassState == StateEnum.loading,
          widgetClass: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              margin: const EdgeInsets.only(
                top: 20,
              ),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset('assets/svg_images/logo.svg'),
                  const SizedBox(
                    height: 30,
                  ),
                  const Row(
                    children: [
                      CustomText(
                        'Reset Password',
                        type: FontStyle.heading,
                      ),
                      CustomText(
                        '',
                        type: FontStyle.heading,
                        color: primaryColor,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color.fromRGBO(9, 169, 83, 0.15),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Color.fromRGBO(9, 169, 83, 1),
                            size: 18,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          CustomText(
                            'Please check your mail for code',
                            type: FontStyle.text,
                            color: Color.fromRGBO(9, 169, 83, 1),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  const CustomRichText(
                    widgets: [
                      TextSpan(text: 'Code'),
                      TextSpan(text: '*', style: TextStyle(color: Colors.red))
                    ],
                    type: RichFontStyle.text,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    // controller: email,
                    decoration: kTextFieldDecoration.copyWith(),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const CustomRichText(
                    widgets: [
                      TextSpan(text: 'New Password'),
                      TextSpan(text: '*', style: TextStyle(color: Colors.red))
                    ],
                    type: RichFontStyle.text,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    // controller: email,
                    decoration: kTextFieldDecoration.copyWith(),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const CustomRichText(
                    widgets: [
                      TextSpan(text: 'Confirm Password'),
                      TextSpan(text: '*', style: TextStyle(color: Colors.red))
                    ],
                    type: RichFontStyle.text,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    // controller: email,
                    decoration: kTextFieldDecoration.copyWith(),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Button(text: 'Submit', ontap: () {}),
                  const SizedBox(
                    height: 25,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
