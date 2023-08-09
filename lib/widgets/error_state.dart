import 'package:flutter/material.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/utils/enums.dart';
import 'package:plane_startup/widgets/custom_text.dart';

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
            const Icon(
              Icons.error_outline,
              color: greyColor,
            ),
            const SizedBox(
              height: 24,
            ),
            const CustomText(
              'Something went wrong',
              type: FontStyle.Medium,
              fontWeight: FontWeightt.Medium,
            ),
            const SizedBox(
              height: 24,
            ),
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

networkErrorWidget({
  required BuildContext context,
  VoidCallback? ontap,
}) {
  return SizedBox(
    height: height,
    width: width,
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.cloud_off_outlined,
            color: greyColor,
          ),
          const SizedBox(
            height: 24,
          ),
          const CustomText(
            'No Internet',
            type: FontStyle.Medium,
            fontWeight: FontWeightt.Medium,
          ),
          const SizedBox(
            height: 10,
          ),
          const CustomText(
            'Please check your internet and try again',
            type: FontStyle.XSmall,
            fontWeight: FontWeightt.Regular,
          ),
          const SizedBox(
            height: 24,
          ),
          InkWell(
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
          ),
        ],
      ),
    ),
  );
}
