import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/utils/theme_manager.dart';
import 'package:plane/widgets/custom_text.dart';

enum ToastType { defult, success, failure, warning }

class CustomToast {
  static final FToast _fToast = FToast();
  static ThemeManager? themeManager;
  CustomToast({required ThemeManager manager}) {
    themeManager = manager;
  }

  static void showToast(
    BuildContext context, {
    required String message,
    int duration = 2,
    ToastType toastType = ToastType.defult,
  }) {
    _fToast.init(context);
    Widget toast = Card(
      borderOnForeground: true,
      elevation: 20,
      color: themeManager!.primaryToastBackgroundColor,
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
                        color: themeManager!.textSuccessColor,
                      )
                    : toastType == ToastType.failure
                        ? Icon(
                            Icons.error_outline,
                            color: themeManager!.textErrorColor,
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
                _fToast.removeCustomToast();
              },
              child: Icon(
                Icons.close,
                color: themeManager!.primaryTextColor,
              ),
            )
          ],
        ),
      ),
    );

    _fToast.showToast(
      child: toast,
      toastDuration: Duration(seconds: duration),
      gravity: ToastGravity.BOTTOM,
    );
  }

  static void showToastWithCustomChild(
      BuildContext context, String message, Widget child,
      {int duration = 1}) {
    _fToast.init(context);

    _fToast.showToast(
      child: child,
      toastDuration: Duration(seconds: duration),
      gravity: ToastGravity.BOTTOM,
    );
  }

  static void showToastWithColors(
    BuildContext context,
    String message, {
    Color primaryToastBackgroundColor = Colors.white,
    Color textSuccessColor = Colors.green,
    Color textErrorColor = Colors.red,
    Color primaryTextColor = Colors.black,
    int duration = 2,
    ToastType toastType = ToastType.defult,
  }) {
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
                  _fToast.removeCustomToast;
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
    _fToast.showToast(
      child: toast,
      toastDuration: Duration(seconds: duration),
      gravity: ToastGravity.BOTTOM,
    );
  }
}
