import 'package:flutter/material.dart';
import 'package:plane/config/const.dart';
import 'package:plane/utils/constants.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/custom_text.dart';

Widget errorState(
    {required BuildContext context,
    VoidCallback? ontap,
    bool showButton = false}) {
  return SizedBox(
    height: height,
    width: width,
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            !Const.isOnline ? Icons.cloud_off_outlined : Icons.error_outline,
            color: greyColor,
          ),
          const SizedBox(
            height: 24,
          ),
          CustomText(
            !Const.isOnline ? 'No Internet' : 'Something went wrong',
            type: FontStyle.Medium,
            fontWeight: FontWeightt.Medium,
          ),
          !Const.isOnline
              ? const Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    CustomText(
                      'Please check your internet and try again',
                      type: FontStyle.XSmall,
                      fontWeight: FontWeightt.Regular,
                    ),
                  ],
                )
              : Container(),
          const SizedBox(
            height: 24,
          ),
          !Const.isOnline
              ? InkWell(
                  onTap: ontap,
                  child: Container(
                    color: Colors.transparent,
                    padding: const EdgeInsets.all(15),
                    child: const CustomText(
                      'Reload',
                      type: FontStyle.Medium,
                      fontWeight: FontWeightt.Medium,
                      color: primaryColor,
                    ),
                  ),
                )
              : Container(),
          showButton
              ? InkWell(
                  onTap: ontap ??
                      () {
                        Navigator.of(context).pop();
                      },
                  child: Container(
                    color: Colors.transparent,
                    padding: const EdgeInsets.all(15),
                    child: const CustomText(
                      'Back to home',
                      type: FontStyle.XSmall,
                      color: primaryColor,
                      fontWeight: FontWeightt.Regular,
                    ),
                  ),
                )
              : Container()
        ],
      ),
    ),
  );
}
