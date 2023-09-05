import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:plane_startup/provider/theme_provider.dart';
import 'package:plane_startup/utils/enums.dart';
import 'package:plane_startup/widgets/custom_text.dart';

enum ToastType { defult, success, failure, warning }

class CustomToast {
  void showToast(
    BuildContext context,
    String message,
    ThemeProvider themeProvider, {
    int duration = 2,
    ToastType toastType = ToastType.defult,
  }) {
    FToast fToast = FToast();
    fToast.init(context);
    Widget toast = Card(
      borderOnForeground: true,
      elevation: 20,
      color: themeProvider.themeManager.primaryToastBackgroundColor,
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
                        color: themeProvider.themeManager.textSuccessColor,
                      )
                    : toastType == ToastType.failure
                        ? Icon(
                            Icons.error_outline,
                            color: themeProvider.themeManager.textErrorColor,
                          )
                        : const Icon(
                            Icons.warning_amber_outlined,
                            color: Colors.amber,
                          ),
            const SizedBox(width: 10),
            Expanded(
              flex: 500,
              child: CustomText(
                message,
                type: FontStyle.Small,
                fontWeight: FontWeightt.Medium,
                maxLines: 3,
                overflow: TextOverflow.visible,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                fToast.removeCustomToast();
              },
              child: Icon(
                Icons.close,
                color: themeProvider.themeManager.primaryTextColor,
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

  void showToastWithColors(
    BuildContext context,
    String message, {
    Color primaryToastBackgroundColor = Colors.white,
    Color textSuccessColor = Colors.green,
    Color textErrorColor = Colors.red,
    Color primaryTextColor = Colors.black,
    int duration = 2,
    ToastType toastType = ToastType.defult,
  }) {
    FToast fToast = FToast();
    fToast.init(context);
    Widget toast = Card(
      borderOnForeground: true,
      elevation: 20,
      color: primaryToastBackgroundColor,
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
                        color: textSuccessColor,
                      )
                    : toastType == ToastType.failure
                        ? Icon(
                            Icons.error_outline,
                            color: textErrorColor,
                          )
                        : const Icon(
                            Icons.warning_amber_outlined,
                            color: Colors.amber,
                          ),
            const SizedBox(width: 10),
            Expanded(
              child: CustomText(
                message,
                type: FontStyle.Small,
                fontWeight: FontWeightt.Medium,
                maxLines: 3,
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {
                  fToast.removeCustomToast();
                },
                child: Icon(
                  Icons.close,
                  color: primaryTextColor,
                ),
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
}
