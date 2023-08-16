import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:plane_startup/provider/theme_provider.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/utils/enums.dart';
import 'package:plane_startup/widgets/custom_text.dart';

enum ToastType { defult, success, failure, warning }

class CustomToast {
  void showSimpleToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: lightPrimaryBackgroundActiveColor,
      textColor: darkPrimaryTextColor,
      fontSize: 16.0,
    );
  }

  void showToast(
    BuildContext context,
    String message,
    ThemeProvider themeprovider, {
    int duration = 2,
    ToastType toastType = ToastType.defult,
  }) {
    FToast fToast = FToast();
    fToast.init(context);
    Widget toast = Card(
      borderOnForeground: true,
      elevation: 20,
      color: themeprovider.themeManager.tertiaryBackgroundDefaultColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            toastType == ToastType.defult
                ? Container()
                : toastType == ToastType.success
                    ? Icon(
                        Icons.check_circle_outline,
                        color: themeprovider.themeManager.textSuccessColor,
                      )
                    : toastType == ToastType.failure
                        ? Icon(
                            Icons.error_outline,
                            color: themeprovider.themeManager.textErrorColor,
                          )
                        : const Icon(
                            Icons.warning_amber_outlined,
                            color: Colors.amber,
                          ),
            const SizedBox(width: 10),
            CustomText(
              message,
              type: FontStyle.Small,
              fontWeight: FontWeightt.Medium,
              maxLines: 3,
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                fToast.removeCustomToast();
              },
              child: Icon(
                Icons.close,
                color: themeprovider.themeManager.primaryTextColor,
              ),
            )
          ],
        ),
      ),
    );
    fToast.showToast(
      child: toast,
      toastDuration: Duration(seconds: duration),
      gravity: ToastGravity.BOTTOM,
    );
  }

  void showToastWithCustomChild(
      BuildContext context, String message, Widget child,
      {int duration = 1}) {
    FToast fToast = FToast();
    fToast.init(context);

    fToast.showToast(
      child: child,
      toastDuration: Duration(seconds: duration),
      gravity: ToastGravity.BOTTOM,
    );
  }
}
