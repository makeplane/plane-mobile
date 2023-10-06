import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/utils/theme_manager.dart';
import 'package:plane/widgets/custom_text.dart';

enum ToastType { defult, success, failure, warning }

class CustomToast {
  CustomToast({required ThemeManager manager}) {
    themeManager = manager;
  }
  static final FToast _fToast = FToast();
  static ThemeManager? themeManager;
  static Widget getToastWithColorWidget(String message,
      {Color primaryToastBackgroundColor = Colors.white,
      Color textSuccessColor = Colors.green,
      Color textErrorColor = Colors.red,
      Color primaryTextColor = Colors.black,
      int duration = 2,
      ToastType toastType = ToastType.defult,
      double? maxHeight}) {
    return ConstrainedBox(
      constraints: maxHeight == null
          ? const BoxConstraints()
          : BoxConstraints(maxHeight: maxHeight),
      child: Card(
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
      ),
    );
  }

  static void showToast(
    BuildContext context, {
    required String message,
    int duration = 2,
    ToastType toastType = ToastType.defult,
    double? maxHeight,
  }) {
    _fToast.init(context);
    final Widget toast = ConstrainedBox(
      constraints: maxHeight == null
          ? const BoxConstraints()
          : BoxConstraints(maxHeight: maxHeight),
      child: Card(
        borderOnForeground: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
            side: BorderSide(
                color: toastType == ToastType.defult
                    ? themeManager!.toastDefaultBorderColor
                    : toastType == ToastType.success
                        ? themeManager!.toastSuccessBorderColor
                        : toastType == ToastType.warning
                            ? themeManager!.toastWarningBorderColor
                            : toastType == ToastType.failure
                                ? themeManager!.toastErrorBorderColor
                                : themeManager!.toastDefaultBorderColor)),
        elevation: 20,
        color:
            // themeManager!.primaryToastBackgroundColor
            toastType == ToastType.defult
                ? themeManager!.toastDefaultColor
                : toastType == ToastType.success
                    ? themeManager!.toastSuccessColor
                    : toastType == ToastType.warning
                        ? themeManager!.toastWarningColor
                        : toastType == ToastType.failure
                            ? themeManager!.toastErrorColor
                            : themeManager!.toastDefaultColor,
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
                  color: (themeManager!.theme == THEME.dark ||
                          themeManager!.theme == THEME.darkHighContrast)
                      ? Colors.white
                      : Colors.black,
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
      ),
    );

    _fToast.showToast(
      child: toast,
      toastDuration: Duration(seconds: duration),
      gravity: ToastGravity.BOTTOM,
    );
  }

  static void showToastFromBool(
      {required BuildContext context,
      required bool isSuccess,
      required String sucessMessage,
      String errorMessage = "Something went wrong!"}) {
    showToast(context,
        message: isSuccess ? sucessMessage : errorMessage,
        toastType: isSuccess ? ToastType.success : ToastType.failure);
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
    double? maxHeight,
  }) {
    _fToast.init(context);
    _fToast.showToast(
      child: getToastWithColorWidget(
        message,
        primaryToastBackgroundColor: primaryToastBackgroundColor,
        textSuccessColor: textSuccessColor,
        textErrorColor: textErrorColor,
        primaryTextColor: primaryTextColor,
        duration: duration,
        toastType: toastType,
        maxHeight: maxHeight,
      ),
      toastDuration: Duration(seconds: duration),
      gravity: ToastGravity.BOTTOM,
    );
  }
}
